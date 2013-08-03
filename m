Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:40829 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab3HCVnf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Aug 2013 17:43:35 -0400
Message-ID: <51FD7982.5080101@gmail.com>
Date: Sat, 03 Aug 2013 23:43:30 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC v3 04/13] [media] exynos5-fimc-is: Add common driver header
 files
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com> <1375455762-22071-5-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1375455762-22071-5-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/02/2013 05:02 PM, Arun Kumar K wrote:
> This patch adds all the common header files used by the fimc-is
> driver. It includes the commands for interfacing with the firmware
> and error codes from IS firmware, metadata and command parameter
> definitions.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
> ---
>   drivers/media/platform/exynos5-is/fimc-is-cmd.h    |  187 +++
>   drivers/media/platform/exynos5-is/fimc-is-err.h    |  257 +++++
>   .../media/platform/exynos5-is/fimc-is-metadata.h   |  767 +++++++++++++
>   drivers/media/platform/exynos5-is/fimc-is-param.h  | 1212 ++++++++++++++++++++
>   4 files changed, 2423 insertions(+)
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-cmd.h
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-err.h
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-metadata.h
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-param.h
>
[...]
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-metadata.h b/drivers/media/platform/exynos5-is/fimc-is-metadata.h
> new file mode 100644
> index 0000000..2f6339d
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-metadata.h
> @@ -0,0 +1,767 @@
> +/*
> + * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Kil-yeon Lim<kilyeon.im@samsung.com>
> + * Arun Kumar K<arun.kk@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef FIMC_IS_METADATA_H_
> +#define FIMC_IS_METADATA_H_
> +
> +struct rational {
> +	uint32_t num;
> +	uint32_t den;
> +};
> +
> +#define CAMERA2_MAX_AVAILABLE_MODE	21
> +#define CAMERA2_MAX_FACES		16
> +
> +/*
> + * Controls/dynamic metadata
> + */
> +
> +enum metadata_mode {
> +	METADATA_MODE_NONE,
> +	METADATA_MODE_FULL
> +};
> +
> +struct camera2_request_ctl {
> +	uint32_t		id;
> +	enum metadata_mode	metadatamode;
> +	uint8_t			outputstreams[16];
> +	uint32_t		framecount;
> +};
> +
> +struct camera2_request_dm {
> +	uint32_t		id;
> +	enum metadata_mode	metadatamode;
> +	uint32_t		framecount;
> +};
> +
> +
> +
> +enum optical_stabilization_mode {
> +	OPTICAL_STABILIZATION_MODE_OFF,
> +	OPTICAL_STABILIZATION_MODE_ON
> +};
> +
> +enum lens_facing {
> +	LENS_FACING_BACK,
> +	LENS_FACING_FRONT
> +};
> +
> +struct camera2_lens_ctl {
> +	uint32_t				focus_distance;
> +	float					aperture;
> +	float					focal_length;
> +	float					filter_density;
> +	enum optical_stabilization_mode		optical_stabilization_mode;
> +};
> +
> +struct camera2_lens_dm {
> +	uint32_t				focus_distance;
> +	float					aperture;
> +	float					focal_length;
> +	float					filter_density;
> +	enum optical_stabilization_mode		optical_stabilization_mode;
> +	float					focus_range[2];
> +};
> +
> +struct camera2_lens_sm {
> +	float				minimum_focus_distance;
> +	float				hyper_focal_distance;
> +	float				available_focal_length[2];
> +	float				available_apertures;
> +	/* assuming 1 aperture */
> +	float				available_filter_densities;
> +	/* assuming 1 ND filter value */
> +	enum optical_stabilization_mode	available_optical_stabilization;
> +	/* assuming 1 */
> +	uint32_t			shading_map_size;
> +	float				shading_map[3][40][30];
> +	uint32_t			geometric_correction_map_size;
> +	float				geometric_correction_map[2][3][40][30];
> +	enum lens_facing		facing;
> +	float				position[2];
> +};
> +
> +enum sensor_colorfilter_arrangement {
> +	SENSOR_COLORFILTER_ARRANGEMENT_RGGB,
> +	SENSOR_COLORFILTER_ARRANGEMENT_GRBG,
> +	SENSOR_COLORFILTER_ARRANGEMENT_GBRG,
> +	SENSOR_COLORFILTER_ARRANGEMENT_BGGR,
> +	SENSOR_COLORFILTER_ARRANGEMENT_RGB
> +};
> +
> +enum sensor_ref_illuminant {
> +	SENSOR_ILLUMINANT_DAYLIGHT = 1,
> +	SENSOR_ILLUMINANT_FLUORESCENT = 2,
> +	SENSOR_ILLUMINANT_TUNGSTEN = 3,
> +	SENSOR_ILLUMINANT_FLASH = 4,
> +	SENSOR_ILLUMINANT_FINE_WEATHER = 9,
> +	SENSOR_ILLUMINANT_CLOUDY_WEATHER = 10,
> +	SENSOR_ILLUMINANT_SHADE = 11,
> +	SENSOR_ILLUMINANT_DAYLIGHT_FLUORESCENT = 12,
> +	SENSOR_ILLUMINANT_DAY_WHITE_FLUORESCENT = 13,
> +	SENSOR_ILLUMINANT_COOL_WHITE_FLUORESCENT = 14,
> +	SENSOR_ILLUMINANT_WHITE_FLUORESCENT = 15,
> +	SENSOR_ILLUMINANT_STANDARD_A = 17,
> +	SENSOR_ILLUMINANT_STANDARD_B = 18,
> +	SENSOR_ILLUMINANT_STANDARD_C = 19,
> +	SENSOR_ILLUMINANT_D55 = 20,
> +	SENSOR_ILLUMINANT_D65 = 21,
> +	SENSOR_ILLUMINANT_D75 = 22,
> +	SENSOR_ILLUMINANT_D50 = 23,
> +	SENSOR_ILLUMINANT_ISO_STUDIO_TUNGSTEN = 24
> +};
> +
> +struct camera2_sensor_ctl {
> +	/* unit : nano */
> +	uint64_t	exposure_time;
> +	/* unit : nano(It's min frame duration */
> +	uint64_t	frame_duration;
> +	/* unit : percent(need to change ISO value?) */
> +	uint32_t	sensitivity;
> +};
> +
> +struct camera2_sensor_dm {
> +	uint64_t	exposure_time;
> +	uint64_t	frame_duration;
> +	uint32_t	sensitivity;
> +	uint64_t	timestamp;
> +};
> +
> +struct camera2_sensor_sm {
> +	uint32_t	exposure_time_range[2];
> +	uint32_t	max_frame_duration;
> +	/* list of available sensitivities. */
> +	uint32_t	available_sensitivities[10];
> +	enum sensor_colorfilter_arrangement colorfilter_arrangement;
> +	float		physical_size[2];
> +	uint32_t	pixel_array_size[2];
> +	uint32_t	active_array_size[4];
> +	uint32_t	white_level;
> +	uint32_t	black_level_pattern[4];
> +	struct rational	color_transform1[9];
> +	struct rational	color_transform2[9];
> +	enum sensor_ref_illuminant	reference_illuminant1;
> +	enum sensor_ref_illuminant	reference_illuminant2;
> +	struct rational	forward_matrix1[9];
> +	struct rational	forward_matrix2[9];
> +	struct rational	calibration_transform1[9];
> +	struct rational	calibration_transform2[9];
> +	struct rational	base_gain_factor;
> +	uint32_t	max_analog_sensitivity;
> +	float		noise_model_coefficients[2];
> +	uint32_t	orientation;
> +};
> +
> +
> +
> +enum flash_mode {
> +	CAM2_FLASH_MODE_OFF = 1,
> +	CAM2_FLASH_MODE_SINGLE,
> +	CAM2_FLASH_MODE_TORCH,
> +	CAM2_FLASH_MODE_BEST
> +};
> +
> +struct camera2_flash_ctl {
> +	enum flash_mode		flash_mode;
> +	uint32_t		firing_power;
> +	uint64_t		firing_time;
> +};
> +
> +struct camera2_flash_dm {
> +	enum flash_mode		flash_mode;
> +	/* 10 is max power */
> +	uint32_t		firing_power;
> +	/* unit : microseconds */
> +	uint64_t		firing_time;
> +	/* 1 : stable, 0 : unstable */
> +	uint32_t		firing_stable;
> +	/* 1 : success, 0 : fail */
> +	uint32_t		decision;
> +};
> +
> +struct camera2_flash_sm {
> +	uint32_t	available;
> +	uint64_t	charge_duration;
> +};
> +
> +enum processing_mode {
> +	PROCESSING_MODE_OFF = 1,
> +	PROCESSING_MODE_FAST,
> +	PROCESSING_MODE_HIGH_QUALITY
> +};
> +
> +
> +struct camera2_hotpixel_ctl {
> +	enum processing_mode	mode;
> +};
> +
> +struct camera2_hotpixel_dm {
> +	enum processing_mode	mode;
> +};
> +
> +struct camera2_demosaic_ctl {
> +	enum processing_mode	mode;
> +};
> +
> +struct camera2_demosaic_dm {
> +	enum processing_mode	mode;
> +};
> +
> +struct camera2_noise_reduction_ctl {
> +	enum processing_mode	mode;
> +	uint32_t		strength;
> +};
> +
> +struct camera2_noise_reduction_dm {
> +	enum processing_mode	mode;
> +	uint32_t		strength;
> +};
> +
> +struct camera2_shading_ctl {
> +	enum processing_mode	mode;
> +};
> +
> +struct camera2_shading_dm {
> +	enum processing_mode	mode;
> +};
> +
> +struct camera2_geometric_ctl {
> +	enum processing_mode	mode;
> +};
> +
> +struct camera2_geometric_dm {
> +	enum processing_mode	mode;
> +};
> +
> +enum color_correction_mode {
> +	COLOR_CORRECTION_MODE_FAST = 1,
> +	COLOR_CORRECTION_MODE_HIGH_QUALITY,
> +	COLOR_CORRECTION_MODE_TRANSFORM_MATRIX,
> +	COLOR_CORRECTION_MODE_EFFECT_MONO,
> +	COLOR_CORRECTION_MODE_EFFECT_NEGATIVE,
> +	COLOR_CORRECTION_MODE_EFFECT_SOLARIZE,
> +	COLOR_CORRECTION_MODE_EFFECT_SEPIA,
> +	COLOR_CORRECTION_MODE_EFFECT_POSTERIZE,
> +	COLOR_CORRECTION_MODE_EFFECT_WHITEBOARD,
> +	COLOR_CORRECTION_MODE_EFFECT_BLACKBOARD,
> +	COLOR_CORRECTION_MODE_EFFECT_AQUA
> +};
> +
> +
> +struct camera2_color_correction_ctl {
> +	enum color_correction_mode	mode;
> +	float				transform[9];
> +	uint32_t			hue;
> +	uint32_t			saturation;
> +	uint32_t			brightness;
> +};
> +
> +struct camera2_color_correction_dm {
> +	enum color_correction_mode	mode;
> +	float				transform[9];
> +	uint32_t			hue;
> +	uint32_t			saturation;
> +	uint32_t			brightness;
> +};
> +
> +struct camera2_color_correction_sm {
> +	/* assuming 10 supported modes */
> +	uint8_t			available_modes[CAMERA2_MAX_AVAILABLE_MODE];
> +	uint32_t		hue_range[2];
> +	uint32_t		saturation_range[2];
> +	uint32_t		brightness_range[2];
> +};
> +
> +enum tonemap_mode {
> +	TONEMAP_MODE_FAST = 1,
> +	TONEMAP_MODE_HIGH_QUALITY,
> +	TONEMAP_MODE_CONTRAST_CURVE
> +};
> +
> +struct camera2_tonemap_ctl {
> +	enum tonemap_mode		mode;
> +	/* assuming maxCurvePoints = 64 */
> +	float				curve_red[64];
> +	float				curve_green[64];
> +	float				curve_blue[64];
> +};
> +
> +struct camera2_tonemap_dm {
> +	enum tonemap_mode		mode;
> +	/* assuming maxCurvePoints = 64 */
> +	float				curve_red[64];
> +	float				curve_green[64];
> +	float				curve_blue[64];

So all those floating point numbers are now not really used in
the driver but we need them for proper data structures/offsets
declarations of the firmware interface ?

> +};
> +
> +struct camera2_tonemap_sm {
> +	uint32_t	max_curve_points;
> +};
> +
> +struct camera2_edge_ctl {
> +	enum processing_mode	mode;
> +	uint32_t		strength;
> +};
> +
> +struct camera2_edge_dm {
> +	enum processing_mode	mode;
> +	uint32_t		strength;
> +};
> +
> +enum scaler_formats {
> +	SCALER_FORMAT_BAYER_RAW,
> +	SCALER_FORMAT_YV12,
> +	SCALER_FORMAT_NV21,
> +	SCALER_FORMAT_JPEG,
> +	SCALER_FORMAT_UNKNOWN
> +};
> +
> +struct camera2_scaler_ctl {
> +	uint32_t	crop_region[3];
> +};
> +
> +struct camera2_scaler_dm {
> +	uint32_t	crop_region[3];
> +};
> +
> +struct camera2_scaler_sm {
> +	enum scaler_formats available_formats[4];
> +	/* assuming # of availableFormats = 4 */
> +	uint32_t	available_raw_sizes;
> +	uint64_t	available_raw_min_durations;
> +	/* needs check */
> +	uint32_t	available_processed_sizes[8];
> +	uint64_t	available_processed_min_durations[8];
> +	uint32_t	available_jpeg_sizes[8][2];
> +	uint64_t	available_jpeg_min_durations[8];
> +	uint32_t	available_max_digital_zoom[8];
> +};
> +
> +struct camera2_jpeg_ctl {
> +	uint32_t	quality;
> +	uint32_t	thumbnail_size[2];
> +	uint32_t	thumbnail_quality;
> +	double		gps_coordinates[3];
> +	uint32_t	gps_processing_method;
> +	uint64_t	gps_timestamp;
> +	uint32_t	orientation;
> +};
> +
> +struct camera2_jpeg_dm {
> +	uint32_t	quality;
> +	uint32_t	thumbnail_size[2];
> +	uint32_t	thumbnail_quality;
> +	double		gps_coordinates[3];
> +	uint32_t	gps_processing_method;
> +	uint64_t	gps_timestamp;
> +	uint32_t	orientation;
> +};
> +
> +struct camera2_jpeg_sm {
> +	uint32_t	available_thumbnail_sizes[8][2];
> +	uint32_t	maxsize;
> +	/* assuming supported size=8 */
> +};
> +
> +enum face_detect_mode {
> +	FACEDETECT_MODE_OFF = 1,
> +	FACEDETECT_MODE_SIMPLE,
> +	FACEDETECT_MODE_FULL
> +};
> +
> +enum stats_mode {
> +	STATS_MODE_OFF = 1,
> +	STATS_MODE_ON
> +};
> +
> +struct camera2_stats_ctl {
> +	enum face_detect_mode	face_detect_mode;
> +	enum stats_mode		histogram_mode;
> +	enum stats_mode		sharpness_map_mode;
> +};
> +
> +
> +struct camera2_stats_dm {
> +	enum face_detect_mode	face_detect_mode;
> +	uint32_t		face_rectangles[CAMERA2_MAX_FACES][4];
> +	uint8_t			face_scores[CAMERA2_MAX_FACES];
> +	uint32_t		face_landmarks[CAMERA2_MAX_FACES][6];
> +	uint32_t		face_ids[CAMERA2_MAX_FACES];
> +	enum stats_mode		histogram_mode;
> +	uint32_t		histogram[3 * 256];
> +	enum stats_mode		sharpness_map_mode;
> +};
> +
> +
> +struct camera2_stats_sm {
> +	uint8_t		available_face_detect_modes[CAMERA2_MAX_AVAILABLE_MODE];
> +	/* assuming supported modes = 3 */
> +	uint32_t	max_face_count;
> +	uint32_t	histogram_bucket_count;
> +	uint32_t	max_histogram_count;
> +	uint32_t	sharpness_map_size[2];
> +	uint32_t	max_sharpness_map_value;
> +};
> +
> +enum aa_capture_intent {
> +	AA_CAPTURE_INTENT_CUSTOM = 0,
> +	AA_CAPTURE_INTENT_PREVIEW,
> +	AA_CAPTURE_INTENT_STILL_CAPTURE,
> +	AA_CAPTURE_INTENT_VIDEO_RECORD,
> +	AA_CAPTURE_INTENT_VIDEO_SNAPSHOT,
> +	AA_CAPTURE_INTENT_ZERO_SHUTTER_LAG
> +};
> +
> +enum aa_mode {
> +	AA_CONTROL_OFF = 1,
> +	AA_CONTROL_AUTO,
> +	AA_CONTROL_USE_SCENE_MODE
> +};
> +
> +enum aa_scene_mode {
> +	AA_SCENE_MODE_UNSUPPORTED = 1,
> +	AA_SCENE_MODE_FACE_PRIORITY,
> +	AA_SCENE_MODE_ACTION,
> +	AA_SCENE_MODE_PORTRAIT,
> +	AA_SCENE_MODE_LANDSCAPE,
> +	AA_SCENE_MODE_NIGHT,
> +	AA_SCENE_MODE_NIGHT_PORTRAIT,
> +	AA_SCENE_MODE_THEATRE,
> +	AA_SCENE_MODE_BEACH,
> +	AA_SCENE_MODE_SNOW,
> +	AA_SCENE_MODE_SUNSET,
> +	AA_SCENE_MODE_STEADYPHOTO,
> +	AA_SCENE_MODE_FIREWORKS,
> +	AA_SCENE_MODE_SPORTS,
> +	AA_SCENE_MODE_PARTY,
> +	AA_SCENE_MODE_CANDLELIGHT,
> +	AA_SCENE_MODE_BARCODE,
> +	AA_SCENE_MODE_NIGHT_CAPTURE
> +};
> +
> +enum aa_effect_mode {
> +	AA_EFFECT_OFF = 1,
> +	AA_EFFECT_MONO,
> +	AA_EFFECT_NEGATIVE,
> +	AA_EFFECT_SOLARIZE,
> +	AA_EFFECT_SEPIA,
> +	AA_EFFECT_POSTERIZE,
> +	AA_EFFECT_WHITEBOARD,
> +	AA_EFFECT_BLACKBOARD,
> +	AA_EFFECT_AQUA
> +};
> +
> +enum aa_aemode {
> +	AA_AEMODE_OFF = 1,
> +	AA_AEMODE_LOCKED,
> +	AA_AEMODE_ON,
> +	AA_AEMODE_ON_AUTO_FLASH,
> +	AA_AEMODE_ON_ALWAYS_FLASH,
> +	AA_AEMODE_ON_AUTO_FLASH_REDEYE
> +};
> +
> +enum aa_ae_flashmode {
> +	/* all flash control stop */
> +	AA_FLASHMODE_OFF = 1,
> +	/* internal 3A can control flash */
> +	AA_FLASHMODE_ON,
> +	/* internal 3A can do auto flash algorithm */
> +	AA_FLASHMODE_AUTO,
> +	/* internal 3A can fire flash by auto result */
> +	AA_FLASHMODE_CAPTURE,
> +	/* internal 3A can control flash forced */
> +	AA_FLASHMODE_ON_ALWAYS
> +
> +};
> +
> +enum aa_ae_antibanding_mode {
> +	AA_AE_ANTIBANDING_OFF = 1,
> +	AA_AE_ANTIBANDING_50HZ,
> +	AA_AE_ANTIBANDING_60HZ,
> +	AA_AE_ANTIBANDING_AUTO
> +};
> +
> +enum aa_awbmode {
> +	AA_AWBMODE_OFF = 1,
> +	AA_AWBMODE_LOCKED,
> +	AA_AWBMODE_WB_AUTO,
> +	AA_AWBMODE_WB_INCANDESCENT,
> +	AA_AWBMODE_WB_FLUORESCENT,
> +	AA_AWBMODE_WB_WARM_FLUORESCENT,
> +	AA_AWBMODE_WB_DAYLIGHT,
> +	AA_AWBMODE_WB_CLOUDY_DAYLIGHT,
> +	AA_AWBMODE_WB_TWILIGHT,
> +	AA_AWBMODE_WB_SHADE
> +};
> +
> +enum aa_afmode {
> +	AA_AFMODE_OFF = 1,
> +	AA_AFMODE_AUTO,
> +	AA_AFMODE_MACRO,
> +	AA_AFMODE_CONTINUOUS_VIDEO,
> +	AA_AFMODE_CONTINUOUS_PICTURE,
> +	AA_AFMODE_EDOF
> +};
> +
> +enum aa_afstate {
> +	AA_AFSTATE_INACTIVE = 1,
> +	AA_AFSTATE_PASSIVE_SCAN,
> +	AA_AFSTATE_ACTIVE_SCAN,
> +	AA_AFSTATE_AF_ACQUIRED_FOCUS,
> +	AA_AFSTATE_AF_FAILED_FOCUS
> +};
> +
> +enum ae_state {
> +	AE_STATE_INACTIVE = 1,
> +	AE_STATE_SEARCHING,
> +	AE_STATE_CONVERGED,
> +	AE_STATE_LOCKED,
> +	AE_STATE_FLASH_REQUIRED,
> +	AE_STATE_PRECAPTURE
> +};
> +
> +enum awb_state {
> +	AWB_STATE_INACTIVE = 1,
> +	AWB_STATE_SEARCHING,
> +	AWB_STATE_CONVERGED,
> +	AWB_STATE_LOCKED
> +};
> +
> +enum aa_isomode {
> +	AA_ISOMODE_AUTO = 1,
> +	AA_ISOMODE_MANUAL,
> +};
> +
> +struct camera2_aa_ctl {
> +	enum aa_capture_intent		capture_intent;
> +	enum aa_mode			mode;
> +	enum aa_scene_mode		scene_mode;
> +	uint32_t			video_stabilization_mode;
> +	enum aa_aemode			ae_mode;
> +	uint32_t			ae_regions[5];
> +	/* 5 per region(x1,y1,x2,y2,weight). Currently assuming 1 region. */
> +	int32_t				ae_exp_compensation;
> +	uint32_t			ae_target_fps_range[2];
> +	enum aa_ae_antibanding_mode	ae_anti_banding_mode;
> +	enum aa_ae_flashmode		ae_flash_mode;
> +	enum aa_awbmode			awb_mode;
> +	uint32_t			awb_regions[5];
> +	/* 5 per region(x1,y1,x2,y2,weight). Currently assuming 1 region. */
> +	enum aa_afmode			af_mode;
> +	uint32_t			af_regions[5];
> +	/* 5 per region(x1,y1,x2,y2,weight). Currently assuming 1 region. */
> +	uint32_t			af_trigger;
> +	enum aa_isomode			iso_mode;
> +	uint32_t			iso_value;
> +
> +};
> +
> +struct camera2_aa_dm {
> +	enum aa_mode				mode;
> +	enum aa_effect_mode			effect_mode;
> +	enum aa_scene_mode			scene_mode;
> +	uint32_t				video_stabilization_mode;
> +	enum aa_aemode				ae_mode;
> +	uint32_t				ae_regions[5];
> +	/* 5 per region(x1,y1,x2,y2,weight). Currently assuming 1 region. */
> +	enum ae_state				ae_state;
> +	enum aa_ae_flashmode			ae_flash_mode;
> +	enum aa_awbmode				awb_mode;
> +	uint32_t				awb_regions[5];
> +	enum awb_state				awb_state;
> +	/* 5 per region(x1,y1,x2,y2,weight). Currently assuming 1 region. */
> +	enum aa_afmode				af_mode;
> +	uint32_t				af_regions[5];
> +	/* 5 per region(x1,y1,x2,y2,weight). Currently assuming 1 region */
> +	enum aa_afstate				af_state;
> +	enum aa_isomode				iso_mode;
> +	uint32_t				iso_value;
> +};
> +
> +struct camera2_aa_sm {
> +	uint8_t	available_scene_modes[CAMERA2_MAX_AVAILABLE_MODE];
> +	uint8_t	available_effects[CAMERA2_MAX_AVAILABLE_MODE];
> +	/* Assuming # of available scene modes = 10 */
> +	uint32_t max_regions;
> +	uint8_t ae_available_modes[CAMERA2_MAX_AVAILABLE_MODE];
> +	/* Assuming # of available ae modes = 8 */
> +	struct rational	ae_compensation_step;
> +	int32_t	ae_compensation_range[2];
> +	uint32_t ae_available_target_fps_ranges[CAMERA2_MAX_AVAILABLE_MODE][2];
> +	uint8_t	 ae_available_antibanding_modes[CAMERA2_MAX_AVAILABLE_MODE];
> +	uint8_t	awb_available_modes[CAMERA2_MAX_AVAILABLE_MODE];
> +	/* Assuming # of awbAvailableModes = 10 */
> +	uint8_t	af_available_modes[CAMERA2_MAX_AVAILABLE_MODE];
> +	/* Assuming # of afAvailableModes = 4 */
> +	uint8_t	available_video_stabilization_modes[4];
> +	/* Assuming # of availableVideoStabilizationModes = 4 */
> +	uint32_t iso_range[2];
> +};
> +
> +struct camera2_lens_usm {
> +	/* Frame delay between sending command and applying frame data */
> +	uint32_t	focus_distance_frame_delay;
> +};
> +
> +struct camera2_sensor_usm {
> +	/* Frame delay between sending command and applying frame data */
> +	uint32_t	exposure_time_frame_delay;
> +	uint32_t	frame_duration_frame_delay;
> +	uint32_t	sensitivity_frame_delay;
> +};
> +
> +struct camera2_flash_usm {
> +	/* Frame delay between sending command and applying frame data */
> +	uint32_t	flash_mode_frame_delay;
> +	uint32_t	firing_power_frame_delay;
> +	uint64_t	firing_time_frame_delay;
> +};
> +
> +struct camera2_ctl {
> +	struct camera2_request_ctl		request;
> +	struct camera2_lens_ctl			lens;
> +	struct camera2_sensor_ctl		sensor;
> +	struct camera2_flash_ctl		flash;
> +	struct camera2_hotpixel_ctl		hotpixel;
> +	struct camera2_demosaic_ctl		demosaic;
> +	struct camera2_noise_reduction_ctl	noise;
> +	struct camera2_shading_ctl		shading;
> +	struct camera2_geometric_ctl		geometric;
> +	struct camera2_color_correction_ctl	color;
> +	struct camera2_tonemap_ctl		tonemap;
> +	struct camera2_edge_ctl			edge;
> +	struct camera2_scaler_ctl		scaler;
> +	struct camera2_jpeg_ctl			jpeg;
> +	struct camera2_stats_ctl		stats;
> +	struct camera2_aa_ctl			aa;
> +};
> +
> +struct camera2_dm {
> +	struct camera2_request_dm		request;
> +	struct camera2_lens_dm			lens;
> +	struct camera2_sensor_dm		sensor;
> +	struct camera2_flash_dm			flash;
> +	struct camera2_hotpixel_dm		hotpixel;
> +	struct camera2_demosaic_dm		demosaic;
> +	struct camera2_noise_reduction_dm	noise;
> +	struct camera2_shading_dm		shading;
> +	struct camera2_geometric_dm		geometric;
> +	struct camera2_color_correction_dm	color;
> +	struct camera2_tonemap_dm		tonemap;
> +	struct camera2_edge_dm			edge;
> +	struct camera2_scaler_dm		scaler;
> +	struct camera2_jpeg_dm			jpeg;
> +	struct camera2_stats_dm			stats;
> +	struct camera2_aa_dm			aa;
> +};
> +
> +struct camera2_sm {
> +	struct camera2_lens_sm			lens;
> +	struct camera2_sensor_sm		sensor;
> +	struct camera2_flash_sm			flash;
> +	struct camera2_color_correction_sm	color;
> +	struct camera2_tonemap_sm		tonemap;
> +	struct camera2_scaler_sm		scaler;
> +	struct camera2_jpeg_sm			jpeg;
> +	struct camera2_stats_sm			stats;
> +	struct camera2_aa_sm			aa;
> +
> +	/* User-defined(ispfw specific) static metadata. */
> +	struct camera2_lens_usm			lensud;
> +	struct camera2_sensor_usm		sensor_ud;
> +	struct camera2_flash_usm		flash_ud;
> +};
> +
> +/*
> + * User-defined control for lens.
> + */
> +struct camera2_lens_uctl {
> +	struct camera2_lens_ctl ctl;
> +
> +	/* It depends by af algorithm(normally 255 or 1023) */
> +	uint32_t        max_pos;
> +	/* Some actuator support slew rate control. */
> +	uint32_t        slew_rate;
> +};
> +
> +/*
> + * User-defined metadata for lens.
> + */
> +struct camera2_lens_udm {
> +	/* It depends by af algorithm(normally 255 or 1023) */
> +	uint32_t        max_pos;
> +	/* Some actuator support slew rate control. */
> +	uint32_t        slew_rate;
> +};
> +
> +/*
> + * User-defined control for sensor.
> + */
> +struct camera2_sensor_uctl {
> +	struct camera2_sensor_ctl ctl;
> +	/* Dynamic frame duration.
> +	 * This feature is decided to max. value between
> +	 * 'sensor.exposureTime'+alpha and 'sensor.frameDuration'.
> +	 */
> +	uint64_t        dynamic_frame_duration;
> +};
> +
> +struct camera2_scaler_uctl {
> +	/* Target address for next frame.
> +	 * [0] invalid address, stop
> +	 * [others] valid address
> +	 */
> +	uint32_t scc_target_address[4];
> +	uint32_t scp_target_address[4];
> +};
> +
> +struct camera2_flash_uctl {
> +	struct camera2_flash_ctl ctl;
> +};
> +
> +struct camera2_uctl {
> +	/* Set sensor, lens, flash control for next frame.
> +	 * This flag can be combined.
> +	 * [0 bit] lens
> +	 * [1 bit] sensor
> +	 * [2 bit] flash
> +	 */
> +	uint32_t u_update_bitmap;
> +
> +	/* For debugging */
> +	uint32_t u_frame_number;
> +
> +	/* isp fw specific control(user-defined) of lens. */
> +	struct camera2_lens_uctl	lens_ud;
> +	/* isp fw specific control(user-defined) of sensor. */
> +	struct camera2_sensor_uctl	sensor_ud;
> +	/* isp fw specific control(user-defined) of flash. */

nit: please add spaces before '('.

> +	struct camera2_flash_uctl	flash_ud;
> +
> +	struct camera2_scaler_uctl	scaler_ud;
> +};
> +
> +struct camera2_udm {
> +	struct camera2_lens_udm		lens;
> +};
> +
> +struct camera2_shot {
> +	/* standard area */
> +	struct camera2_ctl	ctl;
> +	struct camera2_dm	dm;
> +	/* user defined area */
> +	struct camera2_uctl	uctl;
> +	struct camera2_udm	udm;
> +	/* magic : 23456789 */
> +	uint32_t		magicnumber;
> +};
> +#endif
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-param.h b/drivers/media/platform/exynos5-is/fimc-is-param.h
> new file mode 100644
> index 0000000..0beb43e
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-param.h
> @@ -0,0 +1,1212 @@
> +/*
> + * Samsung Exynos5 SoC series FIMC-IS driver
> + *
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd
> + * Kil-yeon Lim<kilyeon.im@samsung.com>
> + * Arun Kumar K<arun.kk@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef FIMC_IS_PARAM_H
> +#define FIMC_IS_PARAM_H
> +
> +#define MAGIC_NUMBER 0x01020304
> +
> +#define PARAMETER_MAX_SIZE    128  /* in byte */

s/byte/bytes ?

> +#define PARAMETER_MAX_MEMBER  (PARAMETER_MAX_SIZE/4)
> +
> +enum is_param_set_bit {
> +	PARAM_GLOBAL_SHOTMODE = 0,
> +	PARAM_SENSOR_CONTROL,
> +	PARAM_SENSOR_OTF_INPUT,
> +	PARAM_SENSOR_OTF_OUTPUT,
> +	PARAM_SENSOR_FRAME_RATE,
> +	PARAM_SENSOR_DMA_OUTPUT,
> +	PARAM_BUFFER_CONTROL,
> +	PARAM_BUFFER_OTF_INPUT,
> +	PARAM_BUFFER_OTF_OUTPUT,
> +	PARAM_ISP_CONTROL,
> +	PARAM_ISP_OTF_INPUT = 10,
> +	PARAM_ISP_DMA1_INPUT,
> +	PARAM_ISP_DMA2_INPUT,
> +	PARAM_ISP_AA,
> +	PARAM_ISP_FLASH,
> +	PARAM_ISP_AWB,
> +	PARAM_ISP_IMAGE_EFFECT,
> +	PARAM_ISP_ISO,
> +	PARAM_ISP_ADJUST,
> +	PARAM_ISP_METERING,
> +	PARAM_ISP_AFC = 20,
> +	PARAM_ISP_OTF_OUTPUT,
> +	PARAM_ISP_DMA1_OUTPUT,
> +	PARAM_ISP_DMA2_OUTPUT,
> +	PARAM_DRC_CONTROL,
> +	PARAM_DRC_OTF_INPUT,
> +	PARAM_DRC_DMA_INPUT,
> +	PARAM_DRC_OTF_OUTPUT,
> +	PARAM_SCALERC_CONTROL,
> +	PARAM_SCALERC_OTF_INPUT,
> +	PARAM_SCALERC_IMAGE_EFFECT = 30,
> +	PARAM_SCALERC_INPUT_CROP,
> +	PARAM_SCALERC_OUTPUT_CROP,
> +	PARAM_SCALERC_OTF_OUTPUT,
> +	PARAM_SCALERC_DMA_OUTPUT = 34,
> +	PARAM_ODC_CONTROL,
> +	PARAM_ODC_OTF_INPUT,
> +	PARAM_ODC_OTF_OUTPUT,
> +	PARAM_DIS_CONTROL,
> +	PARAM_DIS_OTF_INPUT,
> +	PARAM_DIS_OTF_OUTPUT = 40,
> +	PARAM_TDNR_CONTROL,
> +	PARAM_TDNR_OTF_INPUT,
> +	PARAM_TDNR_1ST_FRAME,
> +	PARAM_TDNR_OTF_OUTPUT,
> +	PARAM_TDNR_DMA_OUTPUT,
> +	PARAM_SCALERP_CONTROL,
> +	PARAM_SCALERP_OTF_INPUT,
> +	PARAM_SCALERP_IMAGE_EFFECT,
> +	PARAM_SCALERP_INPUT_CROP,
> +	PARAM_SCALERP_OUTPUT_CROP = 50,
> +	PARAM_SCALERP_ROTATION,
> +	PARAM_SCALERP_FLIP,
> +	PARAM_SCALERP_OTF_OUTPUT,
> +	PARAM_SCALERP_DMA_OUTPUT,
> +	PARAM_FD_CONTROL,
> +	PARAM_FD_OTF_INPUT,
> +	PARAM_FD_DMA_INPUT,
> +	PARAM_FD_CONFIG = 58,
> +	PARAM_END,
> +};
> +
> +/* ----------------------  Input  ----------------------------------- */
> +enum control_command {
> +	CONTROL_COMMAND_STOP	= 0,
> +	CONTROL_COMMAND_START	= 1,
> +	CONTROL_COMMAND_TEST	= 2
> +};
> +
> +enum bypass_command {
> +	CONTROL_BYPASS_DISABLE		= 0,
> +	CONTROL_BYPASS_ENABLE		= 1
> +};
> +
> +enum control_error {
> +	CONTROL_ERROR_NONE		= 0
> +};
> +
> +enum otf_input_command {
> +	OTF_INPUT_COMMAND_DISABLE	= 0,
> +	OTF_INPUT_COMMAND_ENABLE	= 1
> +};
> +
> +enum otf_input_format {
> +	OTF_INPUT_FORMAT_BAYER		= 0, /* 1 Channel */
> +	OTF_INPUT_FORMAT_YUV444		= 1, /* 3 Channel */
> +	OTF_INPUT_FORMAT_YUV422		= 2, /* 3 Channel */
> +	OTF_INPUT_FORMAT_YUV420		= 3, /* 3 Channel */
> +	OTF_INPUT_FORMAT_STRGEN_COLORBAR_BAYER = 10,
> +	OTF_INPUT_FORMAT_BAYER_DMA	= 11,
> +};
> +
> +enum otf_input_bitwidth {
> +	OTF_INPUT_BIT_WIDTH_14BIT	= 14,
> +	OTF_INPUT_BIT_WIDTH_12BIT	= 12,
> +	OTF_INPUT_BIT_WIDTH_11BIT	= 11,
> +	OTF_INPUT_BIT_WIDTH_10BIT	= 10,
> +	OTF_INPUT_BIT_WIDTH_9BIT	= 9,
> +	OTF_INPUT_BIT_WIDTH_8BIT	= 8
> +};
> +
> +enum otf_input_order {
> +	OTF_INPUT_ORDER_BAYER_GR_BG	= 0,
> +	OTF_INPUT_ORDER_BAYER_RG_GB	= 1,
> +	OTF_INPUT_ORDER_BAYER_BG_GR	= 2,
> +	OTF_INPUT_ORDER_BAYER_GB_RG	= 3
> +};
> +
> +enum otf_intput_error {
> +	OTF_INPUT_ERROR_NONE		= 0 /* Input setting is done */
> +};
> +
> +enum dma_input_command {
> +	DMA_INPUT_COMMAND_DISABLE	= 0,
> +	DMA_INPUT_COMMAND_ENABLE	= 1,
> +	DMA_INPUT_COMMAND_BUF_MNGR	= 2,
> +	DMA_INPUT_COMMAND_RUN_SINGLE	= 3,
> +};
> +
> +enum dma_inut_format {
> +	DMA_INPUT_FORMAT_BAYER		= 0,
> +	DMA_INPUT_FORMAT_YUV444		= 1,
> +	DMA_INPUT_FORMAT_YUV422		= 2,
> +	DMA_INPUT_FORMAT_YUV420		= 3,
> +};

> +enum dma_input_bitwidth {
> +	DMA_INPUT_BIT_WIDTH_14BIT	= 14,
> +	DMA_INPUT_BIT_WIDTH_12BIT	= 12,
> +	DMA_INPUT_BIT_WIDTH_11BIT	= 11,
> +	DMA_INPUT_BIT_WIDTH_10BIT	= 10,
> +	DMA_INPUT_BIT_WIDTH_9BIT	= 9,
> +	DMA_INPUT_BIT_WIDTH_8BIT	= 8
> +};
> +
> +enum dma_input_plane {
> +	DMA_INPUT_PLANE_3	= 3,
> +	DMA_INPUT_PLANE_2	= 2,
> +	DMA_INPUT_PLANE_1	= 1
> +};

Are these two enums really needed ? Couldn't plain numbers be used ?
It makes little sense to me to define natural numbers like this.

> +enum dma_input_order {
> +	/* (for DMA_INPUT_PLANE_3) */
> +	DMA_INPUT_ORDER_NONE	= 0,
> +	/* (only valid at DMA_INPUT_PLANE_2) */
> +	DMA_INPUT_ORDER_CBCR	= 1,
> +	/* (only valid at DMA_INPUT_PLANE_2) */
> +	DMA_INPUT_ORDER_CRCB	= 2,
> +	/* (only valid at DMA_INPUT_PLANE_1&  DMA_INPUT_FORMAT_YUV444) */
> +	DMA_INPUT_ORDER_YCBCR	= 3,
> +	/* (only valid at DMA_INPUT_FORMAT_YUV422&  DMA_INPUT_PLANE_1) */
> +	DMA_INPUT_ORDER_YYCBCR	= 4,
> +	/* (only valid at DMA_INPUT_FORMAT_YUV422&  DMA_INPUT_PLANE_1) */
> +	DMA_INPUT_ORDER_YCBYCR	= 5,
> +	/* (only valid at DMA_INPUT_FORMAT_YUV422&  DMA_INPUT_PLANE_1) */
> +	DMA_INPUT_ORDER_YCRYCB	= 6,
> +	/* (only valid at DMA_INPUT_FORMAT_YUV422&  DMA_INPUT_PLANE_1) */
> +	DMA_INPUT_ORDER_CBYCRY	= 7,
> +	/* (only valid at DMA_INPUT_FORMAT_YUV422&  DMA_INPUT_PLANE_1) */
> +	DMA_INPUT_ORDER_CRYCBY	= 8,
> +	/* (only valid at DMA_INPUT_FORMAT_BAYER) */
> +	DMA_INPUT_ORDER_GR_BG	= 9
> +};
> +
> +enum dma_input_error {
> +	DMA_INPUT_ERROR_NONE	= 0 /*  DMA input setting is done */
> +};
> +
> +/* ----------------------  Output  ----------------------------------- */
> +enum otf_output_crop {
> +	OTF_OUTPUT_CROP_DISABLE		= 0,
> +	OTF_OUTPUT_CROP_ENABLE		= 1
> +};
> +
> +enum otf_output_command {
> +	OTF_OUTPUT_COMMAND_DISABLE	= 0,
> +	OTF_OUTPUT_COMMAND_ENABLE	= 1
> +};
> +
> +enum orf_output_format {
> +	OTF_OUTPUT_FORMAT_YUV444	= 1,
> +	OTF_OUTPUT_FORMAT_YUV422	= 2,
> +	OTF_OUTPUT_FORMAT_YUV420	= 3,
> +	OTF_OUTPUT_FORMAT_RGB		= 4
> +};
> +
> +enum otf_output_bitwidth {
> +	OTF_OUTPUT_BIT_WIDTH_14BIT	= 14,
> +	OTF_OUTPUT_BIT_WIDTH_12BIT	= 12,
> +	OTF_OUTPUT_BIT_WIDTH_11BIT	= 11,
> +	OTF_OUTPUT_BIT_WIDTH_10BIT	= 10,
> +	OTF_OUTPUT_BIT_WIDTH_9BIT	= 9,
> +	OTF_OUTPUT_BIT_WIDTH_8BIT	= 8
> +};
> +
> +enum otf_output_order {
> +	OTF_OUTPUT_ORDER_BAYER_GR_BG	= 0,
> +};
> +
> +enum otf_output_error {
> +	OTF_OUTPUT_ERROR_NONE = 0 /* Output Setting is done */
> +};
> +
> +enum dma_output_command {
> +	DMA_OUTPUT_COMMAND_DISABLE	= 0,
> +	DMA_OUTPUT_COMMAND_ENABLE	= 1,
> +	DMA_OUTPUT_COMMAND_BUF_MNGR	= 2,
> +	DMA_OUTPUT_UPDATE_MASK_BITS	= 3
> +};
> +
> +enum dma_output_format {
> +	DMA_OUTPUT_FORMAT_BAYER		= 0,
> +	DMA_OUTPUT_FORMAT_YUV444	= 1,
> +	DMA_OUTPUT_FORMAT_YUV422	= 2,
> +	DMA_OUTPUT_FORMAT_YUV420	= 3,
> +	DMA_OUTPUT_FORMAT_RGB		= 4
> +};
> +
> +enum dma_output_bitwidth {
> +	DMA_OUTPUT_BIT_WIDTH_14BIT	= 14,
> +	DMA_OUTPUT_BIT_WIDTH_12BIT	= 12,
> +	DMA_OUTPUT_BIT_WIDTH_11BIT	= 11,
> +	DMA_OUTPUT_BIT_WIDTH_10BIT	= 10,
> +	DMA_OUTPUT_BIT_WIDTH_9BIT	= 9,
> +	DMA_OUTPUT_BIT_WIDTH_8BIT	= 8
> +};
> +
> +enum dma_output_plane {
> +	DMA_OUTPUT_PLANE_3		= 3,
> +	DMA_OUTPUT_PLANE_2		= 2,
> +	DMA_OUTPUT_PLANE_1		= 1
> +};

Ditto.

> +enum dma_output_order {
> +	DMA_OUTPUT_ORDER_NONE		= 0,
> +	/* (for DMA_OUTPUT_PLANE_3) */
> +	DMA_OUTPUT_ORDER_CBCR		= 1,
> +	/* (only valid at DMA_INPUT_PLANE_2) */
> +	DMA_OUTPUT_ORDER_CRCB		= 2,
> +	/* (only valid at DMA_OUTPUT_PLANE_2) */
> +	DMA_OUTPUT_ORDER_YYCBCR		= 3,
> +	/* (only valid at DMA_OUTPUT_FORMAT_YUV422&  DMA_OUTPUT_PLANE_1) */
> +	DMA_OUTPUT_ORDER_YCBYCR		= 4,
> +	/* (only valid at DMA_OUTPUT_FORMAT_YUV422&  DMA_OUTPUT_PLANE_1) */
> +	DMA_OUTPUT_ORDER_YCRYCB		= 5,
> +	/* (only valid at DMA_OUTPUT_FORMAT_YUV422&  DMA_OUTPUT_PLANE_1) */
> +	DMA_OUTPUT_ORDER_CBYCRY		= 6,
> +	/* (only valid at DMA_OUTPUT_FORMAT_YUV422&  DMA_OUTPUT_PLANE_1) */
> +	DMA_OUTPUT_ORDER_CRYCBY		= 7,
> +	/* (only valid at DMA_OUTPUT_FORMAT_YUV422&  DMA_OUTPUT_PLANE_1) */
> +	DMA_OUTPUT_ORDER_YCBCR		= 8,
> +	/* (only valid at DMA_OUTPUT_FORMAT_YUV444&  DMA_OUPUT_PLANE_1) */
> +	DMA_OUTPUT_ORDER_CRYCB		= 9,
> +	/* (only valid at DMA_OUTPUT_FORMAT_YUV444&  DMA_OUPUT_PLANE_1) */
> +	DMA_OUTPUT_ORDER_CRCBY		= 10,
> +	/* (only valid at DMA_OUTPUT_FORMAT_YUV444&  DMA_OUPUT_PLANE_1) */
> +	DMA_OUTPUT_ORDER_CBYCR		= 11,
> +	/* (only valid at DMA_OUTPUT_FORMAT_YUV444&  DMA_OUPUT_PLANE_1) */
> +	DMA_OUTPUT_ORDER_YCRCB		= 12,
> +	/* (only valid at DMA_OUTPUT_FORMAT_YUV444&  DMA_OUPUT_PLANE_1) */
> +	DMA_OUTPUT_ORDER_CBCRY		= 13,
> +	/* (only valid at DMA_OUTPUT_FORMAT_YUV444&  DMA_OUPUT_PLANE_1) */
> +	DMA_OUTPUT_ORDER_BGR		= 14,
> +	/* (only valid at DMA_OUTPUT_FORMAT_RGB) */
> +	DMA_OUTPUT_ORDER_GB_BG		= 15
> +	/* (only valid at DMA_OUTPUT_FORMAT_BAYER) */
> +};
> +
> +enum dma_output_notify_dma_done {
> +	DMA_OUTPUT_NOTIFY_DMA_DONE_DISABLE	= 0,
> +	DMA_OUTPUT_NOTIFY_DMA_DONE_ENBABLE	= 1,
> +};
> +
> +enum dma_output_error {
> +	DMA_OUTPUT_ERROR_NONE		= 0 /* DMA output setting is done */
> +};
> +
> +/* ----------------------  Global  ----------------------------------- */
> +enum global_shotmode_error {
> +	GLOBAL_SHOTMODE_ERROR_NONE	= 0 /* shot-mode setting is done */
> +};
> +
> +/* -------------------------  AA  ------------------------------------ */
> +enum isp_lock_command {
> +	ISP_AA_COMMAND_START	= 0,
> +	ISP_AA_COMMAND_STOP	= 1
> +};
> +
> +enum isp_lock_target {
> +	ISP_AA_TARGET_AF	= 1,
> +	ISP_AA_TARGET_AE	= 2,
> +	ISP_AA_TARGET_AWB	= 4
> +};
> +
> +enum isp_af_mode {
> +	ISP_AF_MANUAL = 0,
> +	ISP_AF_SINGLE,
> +	ISP_AF_CONTINUOUS,
> +	ISP_AF_REGION,
> +	ISP_AF_SLEEP,
> +	ISP_AF_INIT,
> +	ISP_AF_SET_CENTER_WINDOW,
> +	ISP_AF_SET_TOUCH_WINDOW,
> +	ISP_AF_SET_FACE_WINDOW
> +};
> +
> +enum isp_af_scene {
> +	ISP_AF_SCENE_NORMAL		= 0,
> +	ISP_AF_SCENE_MACRO		= 1
> +};
> +
> +enum isp_af_touch {
> +	ISP_AF_TOUCH_DISABLE = 0,
> +	ISP_AF_TOUCH_ENABLE
> +};
> +
> +enum isp_af_face {
> +	ISP_AF_FACE_DISABLE = 0,
> +	ISP_AF_FACE_ENABLE
> +};
> +
> +enum isp_af_reponse {
> +	ISP_AF_RESPONSE_PREVIEW = 0,
> +	ISP_AF_RESPONSE_MOVIE
> +};
> +
> +enum isp_af_sleep {
> +	ISP_AF_SLEEP_OFF		= 0,
> +	ISP_AF_SLEEP_ON			= 1
> +};
> +
> +enum isp_af_continuous {
> +	ISP_AF_CONTINUOUS_DISABLE	= 0,
> +	ISP_AF_CONTINUOUS_ENABLE	= 1
> +};
> +
> +enum isp_af_error {
> +	ISP_AF_ERROR_NONE		= 0, /* AF mode change is done */
> +	ISP_AF_EROOR_NO_LOCK_DONE	= 1  /* AF lock is done */
> +};
> +
> +/* -------------------------  Flash  ------------------------------------- */
> +enum isp_flash_command {
> +	ISP_FLASH_COMMAND_DISABLE	= 0,
> +	ISP_FLASH_COMMAND_MANUALON	= 1, /* (forced flash) */
> +	ISP_FLASH_COMMAND_AUTO		= 2,
> +	ISP_FLASH_COMMAND_TORCH		= 3,   /* 3 sec */
> +	ISP_FLASH_COMMAND_FLASH_ON	= 4,
> +	ISP_FLASH_COMMAND_CAPTURE	= 5,
> +	ISP_FLASH_COMMAND_TRIGGER	= 6,
> +	ISP_FLASH_COMMAND_CALIBRATION	= 7
> +};
> +
> +enum isp_flash_redeye {
> +	ISP_FLASH_REDEYE_DISABLE	= 0,
> +	ISP_FLASH_REDEYE_ENABLE		= 1
> +};
> +
> +enum isp_flash_error {
> +	ISP_FLASH_ERROR_NONE		= 0 /* Flash setting is done */
> +};
> +
> +/* --------------------------  AWB  ------------------------------------ */
> +enum isp_awb_command {
> +	ISP_AWB_COMMAND_AUTO		= 0,
> +	ISP_AWB_COMMAND_ILLUMINATION	= 1,
> +	ISP_AWB_COMMAND_MANUAL	= 2
> +};
> +
> +enum isp_awb_illumination {
> +	ISP_AWB_ILLUMINATION_DAYLIGHT		= 0,
> +	ISP_AWB_ILLUMINATION_CLOUDY		= 1,
> +	ISP_AWB_ILLUMINATION_TUNGSTEN		= 2,
> +	ISP_AWB_ILLUMINATION_FLUORESCENT	= 3
> +};
> +
> +enum isp_awb_error {
> +	ISP_AWB_ERROR_NONE		= 0 /* AWB setting is done */
> +};
> +
> +/* --------------------------  Effect  ----------------------------------- */
> +enum isp_imageeffect_command {
> +	ISP_IMAGE_EFFECT_DISABLE		= 0,
> +	ISP_IMAGE_EFFECT_MONOCHROME		= 1,
> +	ISP_IMAGE_EFFECT_NEGATIVE_MONO		= 2,
> +	ISP_IMAGE_EFFECT_NEGATIVE_COLOR		= 3,
> +	ISP_IMAGE_EFFECT_SEPIA			= 4,
> +	ISP_IMAGE_EFFECT_AQUA			= 5,
> +	ISP_IMAGE_EFFECT_EMBOSS			= 6,
> +	ISP_IMAGE_EFFECT_EMBOSS_MONO		= 7,
> +	ISP_IMAGE_EFFECT_SKETCH			= 8,
> +	ISP_IMAGE_EFFECT_RED_YELLOW_POINT	= 9,
> +	ISP_IMAGE_EFFECT_GREEN_POINT		= 10,
> +	ISP_IMAGE_EFFECT_BLUE_POINT		= 11,
> +	ISP_IMAGE_EFFECT_MAGENTA_POINT		= 12,
> +	ISP_IMAGE_EFFECT_WARM_VINTAGE		= 13,
> +	ISP_IMAGE_EFFECT_COLD_VINTAGE		= 14,
> +	ISP_IMAGE_EFFECT_POSTERIZE		= 15,
> +	ISP_IMAGE_EFFECT_SOLARIZE		= 16,
> +	ISP_IMAGE_EFFECT_WASHED			= 17,
> +	ISP_IMAGE_EFFECT_CCM			= 18,
> +};

Hmm, I guess we will need a private v4l2 control for those.

> +enum isp_imageeffect_error {
> +	ISP_IMAGE_EFFECT_ERROR_NONE	= 0 /* Image effect setting is done */
> +};
> +
> +/* ---------------------------  ISO  ------------------------------------ */
> +enum isp_iso_command {
> +	ISP_ISO_COMMAND_AUTO		= 0,
> +	ISP_ISO_COMMAND_MANUAL		= 1
> +};
> +
> +enum iso_error {
> +	ISP_ISO_ERROR_NONE		= 0 /* ISO setting is done */
> +};
> +
> +/* --------------------------  Adjust  ----------------------------------- */
> +enum iso_adjust_command {
> +	ISP_ADJUST_COMMAND_AUTO			= 0,
> +	ISP_ADJUST_COMMAND_MANUAL_CONTRAST	= (1<<  0),
> +	ISP_ADJUST_COMMAND_MANUAL_SATURATION	= (1<<  1),
> +	ISP_ADJUST_COMMAND_MANUAL_SHARPNESS	= (1<<  2),
> +	ISP_ADJUST_COMMAND_MANUAL_EXPOSURE	= (1<<  3),
> +	ISP_ADJUST_COMMAND_MANUAL_BRIGHTNESS	= (1<<  4),
> +	ISP_ADJUST_COMMAND_MANUAL_HUE		= (1<<  5),
> +	ISP_ADJUST_COMMAND_MANUAL_HOTPIXEL	= (1<<  6),
> +	ISP_ADJUST_COMMAND_MANUAL_NOISEREDUCTION = (1<<  7),
> +	ISP_ADJUST_COMMAND_MANUAL_SHADING	= (1<<  8),
> +	ISP_ADJUST_COMMAND_MANUAL_GAMMA		= (1<<  9),
> +	ISP_ADJUST_COMMAND_MANUAL_EDGEENHANCEMENT = (1<<  10),
> +	ISP_ADJUST_COMMAND_MANUAL_SCENE		= (1<<  11),
> +	ISP_ADJUST_COMMAND_MANUAL_FRAMETIME	= (1<<  12),
> +	ISP_ADJUST_COMMAND_MANUAL_ALL		= 0x1FFF
> +};
> +
> +enum isp_adjust_scene_index {
> +	ISP_ADJUST_SCENE_NORMAL			= 0,
> +	ISP_ADJUST_SCENE_NIGHT_PREVIEW		= 1,
> +	ISP_ADJUST_SCENE_NIGHT_CAPTURE		= 2
> +};
> +
> +
> +enum isp_adjust_error {
> +	ISP_ADJUST_ERROR_NONE		= 0 /* Adjust setting is done */
> +};
> +
> +/* -------------------------  Metering  ---------------------------------- */
> +enum isp_metering_command {
> +	ISP_METERING_COMMAND_AVERAGE		= 0,
> +	ISP_METERING_COMMAND_SPOT		= 1,
> +	ISP_METERING_COMMAND_MATRIX		= 2,
> +	ISP_METERING_COMMAND_CENTER		= 3,
> +	ISP_METERING_COMMAND_EXPOSURE_MODE	= (1<<  8)
> +};
> +
> +enum isp_exposure_mode {
> +	ISP_EXPOSUREMODE_OFF		= 1,
> +	ISP_EXPOSUREMODE_AUTO		= 2
> +};
> +
> +enum isp_metering_error {
> +	ISP_METERING_ERROR_NONE	= 0 /* Metering setting is done */
> +};
> +
> +/* --------------------------  AFC  ----------------------------------- */
> +enum isp_afc_command {
> +	ISP_AFC_COMMAND_DISABLE		= 0,
> +	ISP_AFC_COMMAND_AUTO		= 1,
> +	ISP_AFC_COMMAND_MANUAL		= 2
> +};
> +
> +enum isp_afc_manual {
> +	ISP_AFC_MANUAL_50HZ		= 50,
> +	ISP_AFC_MANUAL_60HZ		= 60
> +};
> +
> +enum isp_afc_error {
> +	ISP_AFC_ERROR_NONE	= 0 /* AFC setting is done */
> +};
> +
> +enum isp_scene_command {
> +	ISP_SCENE_NONE		= 0,
> +	ISP_SCENE_PORTRAIT	= 1,
> +	ISP_SCENE_LANDSCAPE     = 2,
> +	ISP_SCENE_SPORTS        = 3,
> +	ISP_SCENE_PARTYINDOOR	= 4,
> +	ISP_SCENE_BEACHSNOW	= 5,
> +	ISP_SCENE_SUNSET	= 6,
> +	ISP_SCENE_DAWN		= 7,
> +	ISP_SCENE_FALL		= 8,
> +	ISP_SCENE_NIGHT		= 9,
> +	ISP_SCENE_AGAINSTLIGHTWLIGHT	= 10,
> +	ISP_SCENE_AGAINSTLIGHTWOLIGHT	= 11,
> +	ISP_SCENE_FIRE			= 12,
> +	ISP_SCENE_TEXT			= 13,
> +	ISP_SCENE_CANDLE		= 14
> +};
> +
> +/* --------------------------  Scaler  --------------------------------- */
> +enum scaler_imageeffect_command {
> +	SCALER_IMAGE_EFFECT_COMMNAD_DISABLE	= 0,
> +	SCALER_IMAGE_EFFECT_COMMNAD_SEPIA_CB	= 1,
> +	SCALER_IMAGE_EFFECT_COMMAND_SEPIA_CR	= 2,
> +	SCALER_IMAGE_EFFECT_COMMAND_NEGATIVE	= 3,
> +	SCALER_IMAGE_EFFECT_COMMAND_ARTFREEZE	= 4,
> +	SCALER_IMAGE_EFFECT_COMMAND_EMBOSSING	= 5,
> +	SCALER_IMAGE_EFFECT_COMMAND_SILHOUETTE	= 6
> +};
> +
> +enum scaler_imageeffect_error {
> +	SCALER_IMAGE_EFFECT_ERROR_NONE		= 0
> +};
> +
> +enum scaler_crop_command {
> +	SCALER_CROP_COMMAND_DISABLE		= 0,
> +	SCALER_CROP_COMMAND_ENABLE		= 1
> +};
> +
> +enum scaler_crop_error {
> +	SCALER_CROP_ERROR_NONE			= 0 /* crop setting is done */
> +};
> +
> +enum scaler_scaling_command {
> +	SCALER_SCALING_COMMNAD_DISABLE		= 0,
> +	SCALER_SCALING_COMMAND_UP		= 1,
> +	SCALER_SCALING_COMMAND_DOWN		= 2
> +};
> +
> +enum scaler_scaling_error {
> +	SCALER_SCALING_ERROR_NONE		= 0
> +};
> +
> +enum scaler_rotation_command {
> +	SCALER_ROTATION_COMMAND_DISABLE		= 0,
> +	SCALER_ROTATION_COMMAND_CLOCKWISE90	= 1
> +};
> +
> +enum scaler_rotation_error {
> +	SCALER_ROTATION_ERROR_NONE		= 0
> +};
> +
> +enum scaler_flip_command {
> +	SCALER_FLIP_COMMAND_NORMAL		= 0,
> +	SCALER_FLIP_COMMAND_X_MIRROR		= 1,
> +	SCALER_FLIP_COMMAND_Y_MIRROR		= 2,
> +	SCALER_FLIP_COMMAND_XY_MIRROR		= 3 /* (180 rotation) */
> +};
> +
> +enum scaler_flip_error {
> +	SCALER_FLIP_ERROR_NONE			= 0 /* flip setting is done */
> +};
> +
> +/* --------------------------  3DNR  ----------------------------------- */
> +enum tdnr_1st_frame_command {
> +	TDNR_1ST_FRAME_COMMAND_NOPROCESSING	= 0,
> +	TDNR_1ST_FRAME_COMMAND_2DNR		= 1
> +};
> +
> +enum tdnr_1st_frame_error {
> +	TDNR_1ST_FRAME_ERROR_NONE		= 0
> +		/*1st frame setting is done*/

Misaligned comment, missing space around '*'.

> +};
> +
> +/* ----------------------------  FD  ------------------------------------- */
> +enum fd_config_command {
> +	FD_CONFIG_COMMAND_MAXIMUM_NUMBER	= 0x1,
> +	FD_CONFIG_COMMAND_ROLL_ANGLE		= 0x2,
> +	FD_CONFIG_COMMAND_YAW_ANGLE		= 0x4,
> +	FD_CONFIG_COMMAND_SMILE_MODE		= 0x8,
> +	FD_CONFIG_COMMAND_BLINK_MODE		= 0x10,
> +	FD_CONFIG_COMMAND_EYES_DETECT		= 0x20,
> +	FD_CONFIG_COMMAND_MOUTH_DETECT		= 0x40,
> +	FD_CONFIG_COMMAND_ORIENTATION		= 0x80,
> +	FD_CONFIG_COMMAND_ORIENTATION_VALUE	= 0x100
> +};
> +
> +enum fd_config_roll_angle {
> +	FD_CONFIG_ROLL_ANGLE_BASIC		= 0,
> +	FD_CONFIG_ROLL_ANGLE_PRECISE_BASIC	= 1,
> +	FD_CONFIG_ROLL_ANGLE_SIDES		= 2,
> +	FD_CONFIG_ROLL_ANGLE_PRECISE_SIDES	= 3,
> +	FD_CONFIG_ROLL_ANGLE_FULL		= 4,
> +	FD_CONFIG_ROLL_ANGLE_PRECISE_FULL	= 5,
> +};
> +
> +enum fd_config_yaw_angle {
> +	FD_CONFIG_YAW_ANGLE_0			= 0,
> +	FD_CONFIG_YAW_ANGLE_45			= 1,
> +	FD_CONFIG_YAW_ANGLE_90			= 2,
> +	FD_CONFIG_YAW_ANGLE_45_90		= 3,
> +};
> +
> +enum fd_config_smile_mode {
> +	FD_CONFIG_SMILE_MODE_DISABLE		= 0,
> +	FD_CONFIG_SMILE_MODE_ENABLE		= 1
> +};
> +
> +enum fd_config_blink_mode {
> +	FD_CONFIG_BLINK_MODE_DISABLE		= 0,
> +	FD_CONFIG_BLINK_MODE_ENABLE		= 1
> +};
> +
> +enum fd_config_eye_result {
> +	FD_CONFIG_EYES_DETECT_DISABLE		= 0,
> +	FD_CONFIG_EYES_DETECT_ENABLE		= 1
> +};
> +
> +enum fd_config_mouth_result {
> +	FD_CONFIG_MOUTH_DETECT_DISABLE		= 0,
> +	FD_CONFIG_MOUTH_DETECT_ENABLE		= 1
> +};
> +
> +enum fd_config_orientation {
> +	FD_CONFIG_ORIENTATION_DISABLE		= 0,
> +	FD_CONFIG_ORIENTATION_ENABLE		= 1
> +};
> +
> +struct param_control {
> +	u32	cmd;
> +	u32	bypass;
> +	u32	buffer_address;
> +	u32	buffer_number;
> +	/* 0: continuous, 1: single */
> +	u32	run_mode;
> +	u32	reserved[PARAMETER_MAX_MEMBER-6];
> +	u32	err;
> +};
> +
> +struct param_otf_input {
> +	u32	cmd;
> +	u32	width;
> +	u32	height;
> +	u32	format;
> +	u32	bitwidth;
> +	u32	order;
> +	u32	crop_offset_x;
> +	u32	crop_offset_y;
> +	u32	crop_width;
> +	u32	crop_height;
> +	u32	frametime_min;
> +	u32	frametime_max;
> +	u32	reserved[PARAMETER_MAX_MEMBER-13];
> +	u32	err;
> +};
> +
> +struct param_dma_input {
> +	u32	cmd;
> +	u32	width;
> +	u32	height;
> +	u32	format;
> +	u32	bitwidth;
> +	u32	plane;
> +	u32	order;
> +	u32	buffer_number;
> +	u32	buffer_address;
> +	u32	bayer_crop_offset_x;
> +	u32	bayer_crop_offset_y;
> +	u32	bayer_crop_width;
> +	u32	bayer_crop_height;
> +	u32	dma_crop_offset_x;
> +	u32	dma_crop_offset_y;
> +	u32	dma_crop_width;
> +	u32	dma_crop_height;
> +	u32	user_min_frametime;
> +	u32	user_max_frametime;
> +	u32	wide_frame_gap;
> +	u32	frame_gap;
> +	u32	line_gap;
> +	u32	reserved[PARAMETER_MAX_MEMBER-23];
> +	u32	err;
> +};
> +
> +struct param_otf_output {
> +	u32	cmd;
> +	u32	width;
> +	u32	height;
> +	u32	format;
> +	u32	bitwidth;
> +	u32	order;
> +	u32	crop_offset_x;
> +	u32	crop_offset_y;
> +	u32	reserved[PARAMETER_MAX_MEMBER-9];
> +	u32	err;
> +};
> +
> +struct param_dma_output {
> +	u32	cmd;
> +	u32	width;
> +	u32	height;
> +	u32	format;
> +	u32	bitwidth;
> +	u32	plane;
> +	u32	order;
> +	u32	buffer_number;
> +	u32	buffer_address;
> +	u32	notify_dma_done;
> +	u32	dma_out_mask;
> +	u32	reserved[PARAMETER_MAX_MEMBER-12];
> +	u32	err;
> +};
> +
> +struct param_global_shotmode {
> +	u32	cmd;
> +	u32	skip_frames;
> +	u32	reserved[PARAMETER_MAX_MEMBER-3];
> +	u32	err;
> +};
> +
> +struct param_sensor_framerate {
> +	u32	frame_rate;
> +	u32	reserved[PARAMETER_MAX_MEMBER-2];
> +	u32	err;
> +};
> +
> +struct param_isp_aa {
> +	u32	cmd;
> +	u32	target;
> +	u32	mode;
> +	u32	scene;
> +	u32	af_touch;
> +	u32	af_face;
> +	u32	af_response;
> +	u32	sleep;
> +	u32	touch_x;
> +	u32	touch_y;
> +	u32	manual_af_setting;
> +	/*0: Legacy, 1: Camera 2.0*/
> +	u32	cam_api2p0;
> +	/* For android.control.afRegions in Camera 2.0,
> +	Resolution based on YUV output size*/

Wrong multi-line comment style.

> +	u32	af_region_left;
> +	/* For android.control.afRegions in Camera 2.0,
> +	Resolution based on YUV output size*/

Ditto.

> +	u32	af_region_top;
> +	/* For android.control.afRegions in Camera 2.0,
> +	Resolution based on YUV output size*/

Ditto.

> +	u32	af_region_right;
> +	/* For android.control.afRegions in Camera 2.0,
> +	Resolution based on YUV output size*/

Ditto.

> +	u32	af_region_bottom;
> +	u32	reserved[PARAMETER_MAX_MEMBER-17];

Spaces missing around '-'. Please fix all occurrences like this.

> +	u32	err;
> +};
> +
> +struct param_isp_flash {
> +	u32	cmd;
> +	u32	redeye;
> +	u32	flash_intensity;
> +	u32	reserved[PARAMETER_MAX_MEMBER-4];
> +	u32	err;
> +};
> +
> +struct param_isp_awb {
> +	u32	cmd;
> +	u32	illumination;
> +	u32	reserved[PARAMETER_MAX_MEMBER-3];
> +	u32	err;
> +};
> +
> +struct param_isp_imageeffect {
> +	u32	cmd;
> +	u32	reserved[PARAMETER_MAX_MEMBER-2];
> +	u32	err;
> +};
> +
> +struct param_isp_iso {
> +	u32	cmd;
> +	u32	value;
> +	u32	reserved[PARAMETER_MAX_MEMBER-3];
> +	u32	err;
> +};
> +
> +struct param_isp_adjust {
> +	u32	cmd;
> +	s32	contrast;
> +	s32	saturation;
> +	s32	sharpness;
> +	s32	exposure;
> +	s32	brightness;
> +	s32	hue;
> +	/* 0 or 1 */
> +	u32	hotpixel_enable;
> +	/* -127 ~ 127 */
> +	s32	noise_reduction_strength;
> +	/* 0 or 1 */
> +	u32	shading_correction_enable;
> +	/* 0 or 1 */
> +	u32	user_gamma_enable;
> +	/* -127 ~ 127 */
> +	s32	edge_enhancement_strength;
> +	/* ISP_AdjustSceneIndexEnum */
> +	u32	user_scene_mode;
> +	u32	min_frametime;
> +	u32	max_frametime;
> +	u32	reserved[PARAMETER_MAX_MEMBER-16];
> +	u32	err;
> +};
> +
> +struct param_isp_metering {
> +	u32	cmd;
> +	u32	win_pos_x;
> +	u32	win_pos_y;
> +	u32	win_width;
> +	u32	win_height;
> +	u32	exposure_mode;
> +	/* 0: Legacy, 1: Camera 2.0 */
> +	u32	cam_api2p0;
> +	u32	reserved[PARAMETER_MAX_MEMBER-8];
> +	u32	err;
> +};
> +
> +struct param_isp_afc {
> +	u32	cmd;
> +	u32	manual;
> +	u32	reserved[PARAMETER_MAX_MEMBER-3];
> +	u32	err;
> +};
> +
> +struct param_scaler_imageeffect {
> +	u32	cmd;
> +	u32	reserved[PARAMETER_MAX_MEMBER-2];
> +	u32	err;

Please use either tabs or spaces consistently.

> +};
> +
> +struct param_scaler_input_crop {
> +	u32  cmd;
> +	u32  pos_x;
> +	u32  pos_y;
> +	u32  crop_width;
> +	u32  crop_height;
> +	u32  in_width;
> +	u32  in_height;
> +	u32  out_width;
> +	u32  out_height;
> +	u32  reserved[PARAMETER_MAX_MEMBER-10];
> +	u32  err;
> +};
> +
> +struct param_scaler_output_crop {
> +	u32  cmd;
> +	u32  pos_x;
> +	u32  pos_y;
> +	u32  crop_width;
> +	u32  crop_height;
> +	u32  format;
> +	u32  reserved[PARAMETER_MAX_MEMBER-7];
> +	u32  err;
> +};
> +
> +struct param_scaler_rotation {
> +	u32	cmd;
> +	u32	reserved[PARAMETER_MAX_MEMBER-2];
> +	u32	err;
> +};
> +
> +struct param_scaler_flip {
> +	u32	cmd;
> +	u32	reserved[PARAMETER_MAX_MEMBER-2];
> +	u32	err;
> +};
> +
> +struct param_3dnr_1stframe {
> +	u32	cmd;
> +	u32	reserved[PARAMETER_MAX_MEMBER-2];
> +	u32	err;
> +};
> +
> +struct param_fd_config {
> +	u32	cmd;
> +	u32	max_number;
> +	u32	roll_angle;
> +	u32	yaw_angle;
> +	s32	smile_mode;
> +	s32	blink_mode;
> +	u32	eye_detect;
> +	u32	mouth_detect;
> +	u32	orientation;
> +	u32	orientation_value;
> +	u32	reserved[PARAMETER_MAX_MEMBER-11];
> +	u32	err;
> +};
> +
> +struct global_param {
> +	struct param_global_shotmode	shotmode; /* 0 */

What this /* 0 */ comment is supposed to mean ?

> +};
> +
> +/* To be added */

What ? Where ? When ? :)

> +struct sensor_param {
> +	struct param_control		control;
> +	struct param_otf_input		otf_input;
> +	struct param_otf_output		otf_output;
> +	struct param_sensor_framerate	frame_rate;
> +	struct param_dma_output		dma_output;
> +};
> +
> +struct buffer_param {
> +	struct param_control	control;
> +	struct param_otf_input	otf_input;
> +	struct param_otf_output	otf_output;
> +};
> +
> +struct isp_param {
> +	struct param_control		control;
> +	struct param_otf_input		otf_input;
> +	struct param_dma_input		dma1_input;
> +	struct param_dma_input		dma2_input;
> +	struct param_isp_aa		aa;
> +	struct param_isp_flash		flash;
> +	struct param_isp_awb		awb;
> +	struct param_isp_imageeffect	effect;
> +	struct param_isp_iso		iso;
> +	struct param_isp_adjust		adjust;
> +	struct param_isp_metering	metering;
> +	struct param_isp_afc		afc;
> +	struct param_otf_output		otf_output;
> +	struct param_dma_output		dma1_output;
> +	struct param_dma_output		dma2_output;
> +};
> +
> +struct drc_param {
> +	struct param_control		control;
> +	struct param_otf_input		otf_input;
> +	struct param_dma_input		dma_input;
> +	struct param_otf_output		otf_output;
> +};
> +
> +struct scalerc_param {
> +	struct param_control		control;
> +	struct param_otf_input		otf_input;
> +	struct param_scaler_imageeffect	effect;
> +	struct param_scaler_input_crop	input_crop;
> +	struct param_scaler_output_crop	 output_crop;
> +	struct param_otf_output		otf_output;
> +	struct param_dma_output		dma_output;
> +};
> +
> +struct odc_param {
> +	struct param_control		control;
> +	struct param_otf_input		otf_input;
> +	struct param_otf_output		otf_output;
> +};
> +
> +struct dis_param {
> +	struct param_control		control;
> +	struct param_otf_input		otf_input;
> +	struct param_otf_output		otf_output;
> +};
> +
> +struct tdnr_param {
> +	struct param_control		control;
> +	struct param_otf_input		otf_input;
> +	struct param_3dnr_1stframe	frame;
> +	struct param_otf_output		otf_output;
> +	struct param_dma_output		dma_output;
> +};
> +
> +struct scalerp_param {
> +	struct param_control			control;
> +	struct param_otf_input			otf_input;
> +	struct param_scaler_imageeffect		effect;
> +	struct param_scaler_input_crop		input_crop;
> +	struct param_scaler_output_crop		output_crop;
> +	struct param_scaler_rotation		rotation;
> +	struct param_scaler_flip		flip;
> +	struct param_otf_output			otf_output;
> +	struct param_dma_output			dma_output;
> +};
> +
> +struct fd_param {
> +	struct param_control			control;
> +	struct param_otf_input			otf_input;
> +	struct param_dma_input			dma_input;
> +	struct param_fd_config			config;
> +};
> +
> +struct is_param_region {
> +	struct global_param	global;
> +	struct sensor_param	sensor;
> +	struct buffer_param	buf;
> +	struct isp_param	isp;
> +	struct drc_param	drc;
> +	struct scalerc_param	scalerc;
> +	struct odc_param	odc;
> +	struct dis_param	dis;
> +	struct tdnr_param	tdnr;
> +	struct scalerp_param	scalerp;
> +	struct fd_param		fd;
> +};
> +
> +#define	NUMBER_OF_GAMMA_CURVE_POINTS	32
> +
> +struct is_sensor_tune {
> +	u32 exposure;
> +	u32 analog_gain;
> +	u32 frame_rate;
> +	u32 actuator_pos;
> +};
> +
> +struct is_tune_gammacurve {
> +	u32 num_pts_x[NUMBER_OF_GAMMA_CURVE_POINTS];
> +	u32 num_pts_y_r[NUMBER_OF_GAMMA_CURVE_POINTS];
> +	u32 num_pts_y_g[NUMBER_OF_GAMMA_CURVE_POINTS];
> +	u32 num_pts_y_b[NUMBER_OF_GAMMA_CURVE_POINTS];
> +};
> +
> +struct is_isp_tune {
> +	/* Brightness level : range 0~100, default : 7 */
> +	u32 brightness_level;
> +	/* Contrast level : range -127~127, default : 0 */
> +	s32 contrast_level;
> +	/* Saturation level : range -127~127, default : 0 */
> +	s32 saturation_level;
> +	s32 gamma_level;
> +	struct is_tune_gammacurve gamma_curve[4];
> +	/* Hue : range -127~127, default : 0 */
> +	s32 hue;
> +	/* Sharpness blur : range -127~127, default : 0 */
> +	s32 sharpness_blur;
> +	/* Despeckle : range -127~127, default : 0 */
> +	s32 despeckle;
> +	/* Edge color supression : range -127~127, default : 0 */
> +	s32 edge_color_supression;
> +	/* Noise reduction : range -127~127, default : 0 */

nit: I would remove spaces before ':' above.

> +	s32 noise_reduction;
> +	/* (32*4 + 9)*4 = 548 bytes */

Is this useful for anything ? Any problem with using sizeof() ?

> +};
> +
> +struct is_tune_region {
> +	struct is_sensor_tune sensor_tune;
> +	struct is_isp_tune isp_tune;
> +};
> +
> +struct rational_t {
> +	u32 num;
> +	u32 den;
> +};
> +
> +struct srational_t {
> +	s32 num;
> +	s32 den;
> +};
> +
> +#define FLASH_FIRED_SHIFT	0
> +#define FLASH_NOT_FIRED		0
> +#define FLASH_FIRED		1
> +
> +#define FLASH_STROBE_SHIFT				1
> +#define FLASH_STROBE_NO_DETECTION			0
> +#define FLASH_STROBE_RESERVED				1
> +#define FLASH_STROBE_RETURN_LIGHT_NOT_DETECTED		2
> +#define FLASH_STROBE_RETURN_LIGHT_DETECTED		3
> +
> +#define FLASH_MODE_SHIFT			3
> +#define FLASH_MODE_UNKNOWN			0
> +#define FLASH_MODE_COMPULSORY_FLASH_FIRING	1
> +#define FLASH_MODE_COMPULSORY_FLASH_SUPPRESSION	2
> +#define FLASH_MODE_AUTO_MODE			3
> +
> +#define FLASH_FUNCTION_SHIFT		5
> +#define FLASH_FUNCTION_PRESENT		0
> +#define FLASH_FUNCTION_NONE		1
> +
> +#define FLASH_RED_EYE_SHIFT		6
> +#define FLASH_RED_EYE_DISABLED		0
> +#define FLASH_RED_EYE_SUPPORTED		1
> +
> +struct exif_attribute {
> +	struct rational_t exposure_time;
> +	struct srational_t shutter_speed;
> +	u32 iso_speed_rating;
> +	u32 flash;
> +	struct srational_t brightness;
> +};
> +
> +struct is_frame_header {
> +	u32 valid;
> +	u32 bad_mark;
> +	u32 captured;
> +	u32 frame_number;
> +	struct exif_attribute	exif;
> +};
> +
> +struct is_fd_rect {

Would it be an option to use struct v4l2_rect instead ? It has
same layout. I planned to make such change in exynos4-is is well.
We could add some comment on what left/top/width/height fields
mean exactly in struct is_face_marker.

> +	u32 offset_x;
> +	u32 offset_y;
> +	u32 width;
> +	u32 height;
> +};
> +
> +struct is_face_marker {
> +	u32	frame_number;

nit: it's probably better to use spaces instead of tabs after those
u32s in this case.

> +	struct is_fd_rect face;
> +	struct is_fd_rect left_eye;
> +	struct is_fd_rect right_eye;
> +	struct is_fd_rect mouth;
> +	u32	roll_angle;
> +	u32	yaw_angle;
> +	u32	confidence;
> +	u32	stracked;
> +	u32	tracked_faceid;
> +	u32	smile_level;
> +	u32	blink_level;
> +};

Thanks,
Sylwester
