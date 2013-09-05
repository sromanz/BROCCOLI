#!/bin/bash

clear


MNI_TEMPLATE=/home/andek/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz

data_directory=/data/andek/BROCCOLI_test_data/Cambridge/
results_directory=/data/andek/BROCCOLI_test_data/AFNI

subject=1

date1=$(date +"%s")

for dir in ${data_directory}/*/ 
do
#dir=/data/andek/BROCCOLI_test_data/Cambridge/sub04491
	
	
	rm anat_unifized.nii
	rm anat_affine.nii
	rm anat_affine.1D
	rm AFNI_nonlinear.nii

	3dUnifize -prefix anat_unifized.nii -input ${dir}/anat/mprage_skullstripped.nii.gz
	3dAllineate -prefix anat_affine.nii -base ${MNI_TEMPLATE} -source anat_unifized.nii -twopass -cost lpa -1Dmatrix_save anat_affine.1D -autoweight -fineblur 3 -cmass
	3dQwarp -duplo -useweight -prefix ${results_directory}/AFNI_warped_subject${subject}.nii -source anat_affine.nii -base ${MNI_TEMPLATE} 
	#3dQwarp -duplo -useweight -prefix AFNI_nonlinear.nii -source anat_affine.nii -base ${MNI_TEMPLATE} 
	#3dNwarpApply -nwarp 'AFNI_nonlinear_WARP.nii anat_affine.1D' -source ${dir}/anat/mprage_skullstripped.nii.gz -prefix ANAT_warped_${subject}.nii
	
	subject=$((subject + 1))	

done

date2=$(date +"%s")
diff=$(($date2-$date1))
echo "$(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed."
