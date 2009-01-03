Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n039bcOB021444
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 04:37:38 -0500
Received: from smtp-vbr7.xs4all.nl (smtp-vbr7.xs4all.nl [194.109.24.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n039bLHw022043
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 04:37:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Date: Sat, 3 Jan 2009 10:36:15 +0100
References: <1230848408.11900.20.camel@palomino.walls.org>
In-Reply-To: <1230848408.11900.20.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901031036.15661.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, ivtv-devel@ivtvdriver.org
Subject: Re: [PATCH] cx18, cx2341x,
	ivtv: Add AC-3 audio encoding control to cx18
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Andy,

I've done a quick review:

On Thursday 01 January 2009 23:20:08 Andy Walls wrote:
> The patch in line below adds a control to the cx18 driver to request
> AC-3 audio instead of MPEG Layer II.  It doesn't quite work yet due to
> cx18 firmware issues.
>
> However, I think I've got the basic control work done and need a review
> to make sure I didn't muck anything up with the cx2341x or ivtv modules.
>
> Of particular concern to me is
>
> a) changing the cx2341x "audio_properties" from a u16 to a u32, as this
> is what rippled down in source code to the to ivtv driver.
>
> b) accidentally adding a bogus options or controls to ivtv.
>
>
> The change can also be found at
>
> http://linuxtv.org/hg/~awalls/v4l-dvb
>
> Regards,
> Andy
>
>
> # HG changeset patch
> # User Andy Walls <awalls@radix.net>
> # Date 1230847351 18000
> # Node ID e9cf344a6749de5d3778fac3c7114476f7f0b647
> # Parent  41242777b3d8bb162c65c2d0b2c542417b72d946
> cx18, cx2341x, ivtv: Add AC-3 audio encoding control to cx18
>
> From: Andy Walls <awalls@radix.net>
>
> Initial addition of controls to set AC-3 audio encoding for the CX23418 -
> it does not work yet due to firmware or cx18 driver issues.  This change
> affects the common cx2341x and ivtv modules due to shared structures and
> common functions.
>
> Priority: normal
>
> Signed-off-by: Andy Walls <awalls@radix.net>
>
> diff -r 41242777b3d8 -r e9cf344a6749
> linux/drivers/media/video/cx18/cx18-driver.c ---
> a/linux/drivers/media/video/cx18/cx18-driver.c	Thu Jan 01 10:35:06 2009
> -0500 +++ b/linux/drivers/media/video/cx18/cx18-driver.c	Thu Jan 01
> 17:02:31 2009 -0500 @@ -592,7 +592,8 @@ static int __devinit
> cx18_init_struct1(s
>  		(cx->params.video_temporal_filter_mode << 1) |
>  		(cx->params.video_median_filter_type << 2);
>  	cx->params.port = CX2341X_PORT_MEMORY;
> -	cx->params.capabilities = CX2341X_CAP_HAS_TS;
> +	cx->params.capabilities = CX2341X_CAP_HAS_TS   | CX2341X_CAP_HAS_AC3 |
> +				  CX2341X_CAP_HAS_LPCM;
>  	init_waitqueue_head(&cx->cap_w);
>  	init_waitqueue_head(&cx->mb_apu_waitq);
>  	init_waitqueue_head(&cx->mb_cpu_waitq);
> diff -r 41242777b3d8 -r e9cf344a6749
> linux/drivers/media/video/cx18/cx18-driver.h ---
> a/linux/drivers/media/video/cx18/cx18-driver.h	Thu Jan 01 10:35:06 2009
> -0500 +++ b/linux/drivers/media/video/cx18/cx18-driver.h	Thu Jan 01
> 17:02:31 2009 -0500 @@ -413,7 +413,7 @@ struct cx18 {
>
>  	/* dualwatch */
>  	unsigned long dualwatch_jiffies;
> -	u16 dualwatch_stereo_mode;
> +	u32 dualwatch_stereo_mode;
>
>  	/* Digitizer type */
>  	int digitizer;		/* 0x00EF = saa7114 0x00FO = saa7115 0x0106 = mic */
> diff -r 41242777b3d8 -r e9cf344a6749
> linux/drivers/media/video/cx18/cx18-fileops.c ---
> a/linux/drivers/media/video/cx18/cx18-fileops.c	Thu Jan 01 10:35:06 2009
> -0500 +++ b/linux/drivers/media/video/cx18/cx18-fileops.c	Thu Jan 01
> 17:02:31 2009 -0500 @@ -128,10 +128,10 @@ static void
> cx18_dualwatch(struct cx18 *
>  static void cx18_dualwatch(struct cx18 *cx)
>  {
>  	struct v4l2_tuner vt;
> -	u16 new_bitmap;
> -	u16 new_stereo_mode;
> -	const u16 stereo_mask = 0x0300;
> -	const u16 dual = 0x0200;
> +	u32 new_bitmap;
> +	u32 new_stereo_mode;
> +	const u32 stereo_mask = 0x0300;
> +	const u32 dual = 0x0200;
>  	u32 h;
>
>  	new_stereo_mode = cx->params.audio_properties & stereo_mask;
> diff -r 41242777b3d8 -r e9cf344a6749 linux/drivers/media/video/cx2341x.c
> --- a/linux/drivers/media/video/cx2341x.c	Thu Jan 01 10:35:06 2009 -0500
> +++ b/linux/drivers/media/video/cx2341x.c	Thu Jan 01 17:02:31 2009 -0500
> @@ -1,5 +1,5 @@
>  /*
> - * cx2341x - generic code for cx23415/6 based devices
> + * cx2341x - generic code for cx23415/6/8 based devices
>   *
>   * Copyright (C) 2006 Hans Verkuil <hverkuil@xs4all.nl>
>   *
> @@ -31,7 +31,7 @@
>  #include <media/v4l2-common.h>
>  #include "compat.h"
>
> -MODULE_DESCRIPTION("cx23415/6 driver");
> +MODULE_DESCRIPTION("cx23415/6/8 driver");
>  MODULE_AUTHOR("Hans Verkuil");
>  MODULE_LICENSE("GPL");
>
> @@ -46,6 +46,7 @@ const u32 cx2341x_mpeg_ctrls[] = {
>  	V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ,
>  	V4L2_CID_MPEG_AUDIO_ENCODING,
>  	V4L2_CID_MPEG_AUDIO_L2_BITRATE,
> +	V4L2_CID_MPEG_AUDIO_AC3_BITRATE,
>  	V4L2_CID_MPEG_AUDIO_MODE,
>  	V4L2_CID_MPEG_AUDIO_MODE_EXTENSION,
>  	V4L2_CID_MPEG_AUDIO_EMPHASIS,
> @@ -95,6 +96,7 @@ static const struct cx2341x_mpeg_params
>  	.audio_sampling_freq = V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000,
>  	.audio_encoding = V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
>  	.audio_l2_bitrate = V4L2_MPEG_AUDIO_L2_BITRATE_224K,
> +	.audio_ac3_bitrate = V4L2_MPEG_AUDIO_AC3_BITRATE_224K,
>  	.audio_mode = V4L2_MPEG_AUDIO_MODE_STEREO,
>  	.audio_mode_extension = V4L2_MPEG_AUDIO_MODE_EXTENSION_BOUND_4,
>  	.audio_emphasis = V4L2_MPEG_AUDIO_EMPHASIS_NONE,
> @@ -149,6 +151,9 @@ static int cx2341x_get_ctrl(const struct
>  	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
>  		ctrl->value = params->audio_l2_bitrate;
>  		break;
> +	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE:
> +		ctrl->value = params->audio_ac3_bitrate;
> +		break;
>  	case V4L2_CID_MPEG_AUDIO_MODE:
>  		ctrl->value = params->audio_mode;
>  		break;
> @@ -257,12 +262,23 @@ static int cx2341x_set_ctrl(struct cx234
>  		params->audio_sampling_freq = ctrl->value;
>  		break;
>  	case V4L2_CID_MPEG_AUDIO_ENCODING:
> +		if (busy)
> +			return -EBUSY;
> +		if (params->capabilities & CX2341X_CAP_HAS_AC3 &&
> +		    ctrl->value != V4L2_MPEG_AUDIO_ENCODING_LAYER_2 &&
> +		    ctrl->value != V4L2_MPEG_AUDIO_ENCODING_AC3)
> +			return -EINVAL;

This can't be right: if CAP_HAS_AC3 is not set, then it will always 
return -EINVAL.

>  		params->audio_encoding = ctrl->value;
>  		break;
>  	case V4L2_CID_MPEG_AUDIO_L2_BITRATE:
>  		if (busy)
>  			return -EBUSY;
>  		params->audio_l2_bitrate = ctrl->value;
> +		break;
> +	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE:
> +		if (busy)
> +			return -EBUSY;
> +		params->audio_ac3_bitrate = ctrl->value;
>  		break;

This should test for CAP_HAS_AC3 as well.

>  	case V4L2_CID_MPEG_AUDIO_MODE:
>  		params->audio_mode = ctrl->value;
> @@ -483,6 +499,12 @@ int cx2341x_ctrl_query(const struct cx23
>
>  	switch (qctrl->id) {
>  	case V4L2_CID_MPEG_AUDIO_ENCODING:
> +		if (params->capabilities & CX2341X_CAP_HAS_AC3)
> +			return v4l2_ctrl_query_fill(qctrl,
> +					V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
> +					V4L2_MPEG_AUDIO_ENCODING_AC3, 1,
> +					default_params.audio_encoding);
> +
>  		return v4l2_ctrl_query_fill(qctrl,
>  				V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
>  				V4L2_MPEG_AUDIO_ENCODING_LAYER_2, 1,
> @@ -497,6 +519,12 @@ int cx2341x_ctrl_query(const struct cx23
>  	case V4L2_CID_MPEG_AUDIO_L1_BITRATE:
>  	case V4L2_CID_MPEG_AUDIO_L3_BITRATE:
>  		return -EINVAL;
> +
> +	case V4L2_CID_MPEG_AUDIO_AC3_BITRATE:
> +		return v4l2_ctrl_query_fill(qctrl,
> +				V4L2_MPEG_AUDIO_AC3_BITRATE_48K,
> +				V4L2_MPEG_AUDIO_AC3_BITRATE_448K, 1,
> +				default_params.audio_ac3_bitrate);

Also needs a test.

>  	case V4L2_CID_MPEG_AUDIO_MODE_EXTENSION:
>  		err = v4l2_ctrl_query_fill_std(qctrl);
> @@ -672,6 +700,15 @@ const char **cx2341x_ctrl_get_menu(const
>  		NULL
>  	};
>
> +	static const char *mpeg_audio_encoding_l2_ac3[] = {
> +		"",
> +		"MPEG-1/2 Layer II",
> +		"",
> +		"",
> +		"AC-3",
> +		NULL
> +	};
> +
>  	static const char *cx2341x_video_spatial_filter_mode_menu[] = {
>  		"Manual",
>  		"Auto",
> @@ -712,6 +749,9 @@ const char **cx2341x_ctrl_get_menu(const
>  	case V4L2_CID_MPEG_STREAM_TYPE:
>  		return (p->capabilities & CX2341X_CAP_HAS_TS) ?
>  			mpeg_stream_type_with_ts : mpeg_stream_type_without_ts;
> +	case V4L2_CID_MPEG_AUDIO_ENCODING:
> +		return (p->capabilities & CX2341X_CAP_HAS_AC3) ?
> +			mpeg_audio_encoding_l2_ac3 : v4l2_ctrl_get_menu(id);
>  	case V4L2_CID_MPEG_AUDIO_L1_BITRATE:
>  	case V4L2_CID_MPEG_AUDIO_L3_BITRATE:
>  		return NULL;
> @@ -731,16 +771,36 @@ const char **cx2341x_ctrl_get_menu(const
>  }
>  EXPORT_SYMBOL(cx2341x_ctrl_get_menu);
>
> +/* definitions for audio properties bits 29-28 */
> +#define CX2341X_AUDIO_ENCDING_METHOD_MPEG	0
> +#define CX2341X_AUDIO_ENCDING_METHOD_AC3	1
> +#define CX2341X_AUDIO_ENCDING_METHOD_LPCM	2

ENCDING? You mean ENCODING.

> +
>  static void cx2341x_calc_audio_properties(struct cx2341x_mpeg_params
> *params) {
> -	params->audio_properties = (params->audio_sampling_freq << 0) |
> -		((3 - params->audio_encoding) << 2) |
> -		((1 + params->audio_l2_bitrate) << 4) |
> +	params->audio_properties =
> +		(params->audio_sampling_freq << 0) |
>  		(params->audio_mode << 8) |
>  		(params->audio_mode_extension << 10) |
>  		(((params->audio_emphasis == V4L2_MPEG_AUDIO_EMPHASIS_CCITT_J17)
>  		  ? 3 : params->audio_emphasis) << 12) |
>  		(params->audio_crc << 14);
> +
> +	if ((params->capabilities & CX2341X_CAP_HAS_AC3) &&
> +	    params->audio_encoding == V4L2_MPEG_AUDIO_ENCODING_AC3) {
> +		params->audio_properties |=
> +#if 1
> +			/* Not sure if this MPEG Layer II setting is required */
> +			((3 - V4L2_MPEG_AUDIO_ENCODING_LAYER_2) << 2) |
> +#endif
> +			(params->audio_ac3_bitrate << 4) |
> +			(CX2341X_AUDIO_ENCDING_METHOD_AC3 << 28);
> +	} else {
> +		/* Assuming MPEG Layer II */
> +		params->audio_properties |=
> +			((3 - params->audio_encoding) << 2) |
> +			((1 + params->audio_l2_bitrate) << 4);
> +	}
>  }
>
>  int cx2341x_ext_ctrls(struct cx2341x_mpeg_params *params, int busy,
> @@ -1023,7 +1083,10 @@ void cx2341x_log_status(const struct cx2
>  		prefix,
>  		cx2341x_menu_item(p, V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ),
>  		cx2341x_menu_item(p, V4L2_CID_MPEG_AUDIO_ENCODING),
> -		cx2341x_menu_item(p, V4L2_CID_MPEG_AUDIO_L2_BITRATE),
> +		cx2341x_menu_item(p,
> +			   p->audio_encoding == V4L2_MPEG_AUDIO_ENCODING_AC3
> +					      ? V4L2_CID_MPEG_AUDIO_AC3_BITRATE
> +					      : V4L2_CID_MPEG_AUDIO_L2_BITRATE),
>  		cx2341x_menu_item(p, V4L2_CID_MPEG_AUDIO_MODE),
>  		p->audio_mute ? " (muted)" : "");
>  	if (p->audio_mode == V4L2_MPEG_AUDIO_MODE_JOINT_STEREO)
> diff -r 41242777b3d8 -r e9cf344a6749
> linux/drivers/media/video/ivtv/ivtv-driver.h ---
> a/linux/drivers/media/video/ivtv/ivtv-driver.h	Thu Jan 01 10:35:06 2009
> -0500 +++ b/linux/drivers/media/video/ivtv/ivtv-driver.h	Thu Jan 01
> 17:02:31 2009 -0500 @@ -697,7 +697,7 @@ struct ivtv {
>  	u64 vbi_data_inserted;          /* number of VBI bytes inserted into
> the MPEG stream */ u32 last_dec_timing[3];         /* cache last
> retrieved pts/scr/frame values */ unsigned long dualwatch_jiffies;/*
> jiffies value of the previous dualwatch check */ -	u16
> dualwatch_stereo_mode;      /* current detected dualwatch stereo mode */
> +	u32 dualwatch_stereo_mode;      /* current detected dualwatch stereo
> mode */
>
>
>  	/* VBI state info */
> diff -r 41242777b3d8 -r e9cf344a6749
> linux/drivers/media/video/ivtv/ivtv-fileops.c ---
> a/linux/drivers/media/video/ivtv/ivtv-fileops.c	Thu Jan 01 10:35:06 2009
> -0500 +++ b/linux/drivers/media/video/ivtv/ivtv-fileops.c	Thu Jan 01
> 17:02:31 2009 -0500 @@ -148,10 +148,10 @@ static void
> ivtv_dualwatch(struct ivtv *
>  static void ivtv_dualwatch(struct ivtv *itv)
>  {
>  	struct v4l2_tuner vt;
> -	u16 new_bitmap;
> -	u16 new_stereo_mode;
> -	const u16 stereo_mask = 0x0300;
> -	const u16 dual = 0x0200;
> +	u32 new_bitmap;
> +	u32 new_stereo_mode;
> +	const u32 stereo_mask = 0x0300;
> +	const u32 dual = 0x0200;
>
>  	new_stereo_mode = itv->params.audio_properties & stereo_mask;
>  	memset(&vt, 0, sizeof(vt));
> diff -r 41242777b3d8 -r e9cf344a6749 linux/include/media/cx2341x.h
> --- a/linux/include/media/cx2341x.h	Thu Jan 01 10:35:06 2009 -0500
> +++ b/linux/include/media/cx2341x.h	Thu Jan 01 17:02:31 2009 -0500
> @@ -1,5 +1,5 @@
>  /*
> -    cx23415/6 header containing common defines.
> +    cx23415/6/8 header containing common defines.
>
>      This program is free software; you can redistribute it and/or modify
>      it under the terms of the GNU General Public License as published by
> @@ -28,6 +28,8 @@ enum cx2341x_cap {
>  enum cx2341x_cap {
>  	CX2341X_CAP_HAS_SLICED_VBI = 1 << 0,
>  	CX2341X_CAP_HAS_TS 	   = 1 << 1,
> +	CX2341X_CAP_HAS_AC3 	   = 1 << 2,
> +	CX2341X_CAP_HAS_LPCM	   = 1 << 3,
>  };
>
>  struct cx2341x_mpeg_params {
> @@ -47,11 +49,12 @@ struct cx2341x_mpeg_params {
>  	enum v4l2_mpeg_audio_sampling_freq audio_sampling_freq;
>  	enum v4l2_mpeg_audio_encoding audio_encoding;
>  	enum v4l2_mpeg_audio_l2_bitrate audio_l2_bitrate;
> +	enum v4l2_mpeg_audio_ac3_bitrate audio_ac3_bitrate;
>  	enum v4l2_mpeg_audio_mode audio_mode;
>  	enum v4l2_mpeg_audio_mode_extension audio_mode_extension;
>  	enum v4l2_mpeg_audio_emphasis audio_emphasis;
>  	enum v4l2_mpeg_audio_crc audio_crc;
> -	u16 audio_properties;
> +	u32 audio_properties;
>  	u16 audio_mute;
>
>  	/* video */

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
