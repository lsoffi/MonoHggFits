#!/bin/bash

# set -x

folder=$1 && shift
coupl=$1 && shift

# echo $coupl

cd $folder

args=""
while [[ -n $1 ]]; do
    case $1 in
	-M)
	    method=$2
	    args="$args $1 $2"
	    shift
	    ;;
	-n)
	    label=$2
	    shift
	    ;;
	--hadd)
	    hadd="hadd"
	    ;;
	--dry-run)
	    dry="1"
	    ;;
	--cont)
	    cont="1"
	    ;;
	*)	    
	    args="$args $1"
	    ;;	    
    esac
    shift
done
shift


libs="-L libdiphotonsUtils"
rootversion=$(root-config --version| tr '.' ' ')
#[[ $rootversion -gt 5 ]] && libs="-L libdiphotonsRooUtils"

for mZ in "600" "800" "1200" "1400"; do #
    echo $mZ
    card=datacard_JAN11MonoHgg_cic_default_shapes_lumi_2.6_MonoHgg_2HDM_mZP${mZ}_mA0300_13TeV.txt
    echo $card
    binary=$(echo $card | sed 's%.txt$%.root%')
    signame=$(echo $card | sed 's%.*MonoHgg_%%; s%.txt%%')
    echo $binary
    echo $signame
    label=MonoHgg
    log=combine_log_${method}_${label}_mH125_mZP${mZ}.log
    #set -x
#	if [[ -z $dry ]] && ( [[ -z $cont ]] ||  [[ ! -f higgsCombine${label}.${method}.mH125_mZ${mZ}.root ]] ); then 
#	    if [[ -f $binary ]] && [[ $binary -nt $card ]]; then
#		card=$binary
#	    fi
	    combine $libs $args -n "${label}_mZP${mZ}" -m 125 $card 2>&1 | tee $log
	    #echo combine $libs $args -n "${label}_mZP${mZ}" -m 125 ${folder}$card
	    ## sleep 1
#	fi
#	set +x
	tail -5 $log
        [[ -f higgsCombine${label}.${method}.mH125_mZP${mZ}.root ]] && outputs="$outputs higgsCombine${label}.${method}.mH125_mZP${mZ}.root"
done
if [[ -n $hadd ]]; then
	hadd -f higgsCombine${label}Combined.$method.mH125_2HDM.root $outputs
fi

#    cards=datacard*_MonoHgg_*.txt
#    outputs=""
    
#    for mZ in "600" "800" "1200" "1400"; do
#	echo $mZ
#	#echo $card
#	binary=$(echo $card | sed 's%.txt$%.root%')
#	signame=$(echo $card | sed 's%.*MonoHgg_%%; s%.txt%%')
#	set $(echo $signame | tr '_' ' ')
#	kmpl=$1
#	mass=$mZ
#	label=MonoHgg
#	log=combine_log_${method}_${label}_mH125_mZ${mass}.log
#	set -x
#	if [[ -z $dry ]] && ( [[ -z $cont ]] ||  [[ ! -f higgsCombine${label}.${method}.mH${mass}_mZ${mZ}.root ]] ); then 
#	    if [[ -f $binary ]] && [[ $binary -nt $card ]]; then
#		card=$binary
#	    fi
#	    combine $libs $args -n "${label}" -m 125 $card 2>&1 | tee $log
#	    ## sleep 1
#	fi
#	set +x
#	tail -5 $log 
#	[[ -f higgsCombine${label}.${method}.mH${mass}_mZ${mZ}.root ]] && outputs="$outputs higgsCombine${label}.${method}.mH${mass}_mZ${mZ}.root"
#    done
#    if [[ -n $hadd ]]; then
#	hadd -f higgsCombine${label}Combined.$method.mH${mass}_mZ${mZ}.root $outputs
#    fi
#done

