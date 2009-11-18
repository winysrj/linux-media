Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:60107 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbZKRUsv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 15:48:51 -0500
Date: Wed, 18 Nov 2009 12:48:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH v3] V4L - Adding Digital Video Timings APIs
Message-Id: <20091118124841.44d86b50.randy.dunlap@oracle.com>
In-Reply-To: <1258576711-7809-1-git-send-email-m-karicheri2@ti.com>
References: <1258576711-7809-1-git-send-email-m-karicheri2@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Nov 2009 15:38:31 -0500 m-karicheri2@ti.com wrote:

> From: Muralidharan Karicheri <m-karicheri2@ti.com>
> 
> This is v3 of the digital video timings APIs implementation.
> This has updates based on comments received against v2 of the patch. Hopefully
> this can be merged to 2.6.33 if there are no more comments.
> 
> This adds the above APIs to the v4l2 core. This is based on version v1.2
> of the RFC titled "V4L - Support for video timings at the input/output interface"
> Following new ioctls are added:-
> 
> 	- VIDIOC_ENUM_DV_PRESETS
> 	- VIDIOC_S_DV_PRESET
> 	- VIDIOC_G_DV_PRESET
> 	- VIDIOC_QUERY_DV_PRESET
> 	- VIDIOC_S_DV_TIMINGS
> 	- VIDIOC_G_DV_TIMINGS
> 
> Please refer to the RFC for the details. This code was tested using vpfe
> capture driver on TI's DM365. Following is the test configuration used :-
> 
> Blue Ray HD DVD source -> TVP7002 -> DM365 (VPFE) ->DDR

That's "Blu-Ray", fwiw.

> A draft version of the TVP7002 driver (currently being reviewed in the mailing
> list) was used that supports V4L2_DV_1080I60 & V4L2_DV_720P60 presets. 
> 
> A loopback video capture application was used for testing these APIs. This calls
> following IOCTLS :-
> 
>  -  verify the new v4l2_input capabilities flag added
>  -  Enumerate available presets using VIDIOC_ENUM_DV_PRESETS
>  -  Set one of the supported preset using VIDIOC_S_DV_PRESET
>  -  Get current preset using VIDIOC_G_DV_PRESET
>  -  Detect current preset using VIDIOC_QUERY_DV_PRESET
>  -  Using stub functions in tvp7002, verify VIDIOC_S_DV_TIMINGS
>     and VIDIOC_G_DV_TIMINGS ioctls are received at the sub device. 
>  -  Tested on 64bit platform by Hans Verkuil
> 	
> TODOs :
> 
>  - Update v4l2-apps for the new ioctl (will send another patch after
>    compilation issue is resolved)
> 
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
> Applies to V4L-DVB linux-next branch
> 
>  drivers/media/video/v4l2-compat-ioctl32.c |    6 +
>  drivers/media/video/v4l2-ioctl.c          |  147 +++++++++++++++++++++++++++++
>  include/linux/videodev2.h                 |  116 ++++++++++++++++++++++-
>  include/media/v4l2-ioctl.h                |   15 +++
>  include/media/v4l2-subdev.h               |   21 ++++
>  5 files changed, 303 insertions(+), 2 deletions(-)

> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 30cc334..0ba435c 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -284,6 +284,12 @@ static const char *v4l2_ioctls[] = {
>  	[_IOC_NR(VIDIOC_DBG_G_CHIP_IDENT)] = "VIDIOC_DBG_G_CHIP_IDENT",
>  	[_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
>  #endif
> +	[_IOC_NR(VIDIOC_ENUM_DV_PRESETS)]  = "VIDIOC_ENUM_DV_PRESETS",
> +	[_IOC_NR(VIDIOC_S_DV_PRESET)]	   = "VIDIOC_S_DV_PRESET",
> +	[_IOC_NR(VIDIOC_G_DV_PRESET)]	   = "VIDIOC_G_DV_PRESET",
> +	[_IOC_NR(VIDIOC_QUERY_DV_PRESET)]  = "VIDIOC_QUERY_DV_PRESET",
> +	[_IOC_NR(VIDIOC_S_DV_TIMINGS)]     = "VIDIOC_S_DV_TIMINGS",
> +	[_IOC_NR(VIDIOC_G_DV_TIMINGS)]     = "VIDIOC_G_DV_TIMINGS",
>  };
>  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
>  
> @@ -1135,6 +1141,19 @@ static long __video_do_ioctl(struct file *file,
>  	{
>  		struct v4l2_input *p = arg;
>  
> +		/**
> +		 * We set the flags for CAP_PRESETS, CAP_CUSTOM_TIMINGS &
> +		 * CAP_STD here based on ioctl handler provided by the
> +		 * driver. If the driver doesn't support these
> +		 * for a specific input, it must override these flags.
> +		 */

"/**" means "beginning of kernel-doc notation", so please don't use it
just to begin a comment block (here and below).


> +		if (ops->vidioc_s_std)
> +			p->capabilities |= V4L2_IN_CAP_STD;
> +		if (ops->vidioc_s_dv_preset)
> +			p->capabilities |= V4L2_IN_CAP_PRESETS;
> +		if (ops->vidioc_s_dv_timings)
> +			p->capabilities |= V4L2_IN_CAP_CUSTOM_TIMINGS;
> +
>  		if (!ops->vidioc_enum_input)
>  			break;
>  
> @@ -1179,6 +1198,19 @@ static long __video_do_ioctl(struct file *file,
>  		if (!ops->vidioc_enum_output)
>  			break;
>  
> +		/**
> +		 * We set the flags for CAP_PRESETS, CAP_CUSTOM_TIMINGS &
> +		 * CAP_STD here based on ioctl handler provided by the
> +		 * driver. If the driver doesn't support these
> +		 * for a specific output, it must override these flags.
> +		 */
> +		if (ops->vidioc_s_std)
> +			p->capabilities |= V4L2_OUT_CAP_STD;
> +		if (ops->vidioc_s_dv_preset)
> +			p->capabilities |= V4L2_OUT_CAP_PRESETS;
> +		if (ops->vidioc_s_dv_timings)
> +			p->capabilities |= V4L2_OUT_CAP_CUSTOM_TIMINGS;
> +
>  		ret = ops->vidioc_enum_output(file, fh, p);
>  		if (!ret)
>  			dbgarg(cmd, "index=%d, name=%s, type=%d, "

> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index cfde111..b8ae314 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h

> @@ -1621,6 +1726,13 @@ struct v4l2_dbg_chip_ident {
>  #endif
>  
>  #define VIDIOC_S_HW_FREQ_SEEK	 _IOW('V', 82, struct v4l2_hw_freq_seek)
> +#define	VIDIOC_ENUM_DV_PRESETS	_IOWR('V', 83, struct v4l2_dv_enum_preset)
> +#define	VIDIOC_S_DV_PRESET	_IOWR('V', 84, struct v4l2_dv_preset)
> +#define	VIDIOC_G_DV_PRESET	_IOWR('V', 85, struct v4l2_dv_preset)
> +#define	VIDIOC_QUERY_DV_PRESET	_IOR('V',  86, struct v4l2_dv_preset)
> +#define	VIDIOC_S_DV_TIMINGS	_IOWR('V', 87, struct v4l2_dv_timings)
> +#define	VIDIOC_G_DV_TIMINGS	_IOWR('V', 88, struct v4l2_dv_timings)

Make sure that these ioctls (range) are added to/included in
Documentation/ioctl/ioctl-number.txt .

Hm, are those supposed to be small 'v' instead of large 'V'?


---
~Randy
