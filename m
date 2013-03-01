Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20435 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3CALBs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 06:01:48 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MIZ002ZVAJQAF70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Mar 2013 11:01:47 +0000 (GMT)
Received: from [106.116.147.108] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MIZ00AW1AMY3DA0@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Mar 2013 11:01:47 +0000 (GMT)
Message-id: <51308A99.3060009@samsung.com>
Date: Fri, 01 Mar 2013 12:01:45 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 09/18] s5p-tv: add dv_timings support for hdmi.
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
 <92ae3c7595637957ef1894921b9a451ffd458d16.1361006882.git.hans.verkuil@cisco.com>
In-reply-to: <92ae3c7595637957ef1894921b9a451ffd458d16.1361006882.git.hans.verkuil@cisco.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Please refer to the comments below.

On 02/16/2013 10:28 AM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This just adds dv_timings support without modifying existing dv_preset
> support.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-tv/hdmi_drv.c |   92 +++++++++++++++++++++++++-----
>  1 file changed, 79 insertions(+), 13 deletions(-)
> 

[snip]

> +static int hdmi_enum_dv_timings(struct v4l2_subdev *sd,
> +	struct v4l2_enum_dv_timings *timings)
> +{
> +	if (timings->index >= ARRAY_SIZE(hdmi_timings))
> +		return -EINVAL;
> +	timings->timings = hdmi_timings[timings->index].dv_timings;
> +	if (!hdmi_timings[timings->index].reduced_fps)
> +		timings->timings.bt.flags &= ~V4L2_DV_FL_CAN_REDUCE_FPS;
> +	return 0;
> +}
> +
> +static int hdmi_dv_timings_cap(struct v4l2_subdev *sd,
> +	struct v4l2_dv_timings_cap *cap)
> +{
> +	cap->type = V4L2_DV_BT_656_1120;

The minimal width among all the supported timings is 720 not 640.

> +	cap->bt.min_width = 640;
> +	cap->bt.max_width = 1920;
> +	cap->bt.min_height = 480;
> +	cap->bt.max_height = 1080;

The range of pixelclock is a property of hdmiphy.
Not all ranges might be supported on all platforms.
Therefore it may be a good idea to obtains those values
from hdmiphy by chaining hdmi_dv_timings_cap to hdmiphy.

> +	cap->bt.min_pixelclock = 27000000;
> +	cap->bt.max_pixelclock = 148500000;
> +	cap->bt.standards = V4L2_DV_BT_STD_CEA861;
> +	cap->bt.capabilities = V4L2_DV_BT_CAP_INTERLACED |
> +			       V4L2_DV_BT_CAP_PROGRESSIVE;
> +	return 0;
> +}
> +
>  static const struct v4l2_subdev_core_ops hdmi_sd_core_ops = {
>  	.s_power = hdmi_s_power,
>  };
> @@ -687,6 +749,10 @@ static const struct v4l2_subdev_video_ops hdmi_sd_video_ops = {
>  	.s_dv_preset = hdmi_s_dv_preset,
>  	.g_dv_preset = hdmi_g_dv_preset,
>  	.enum_dv_presets = hdmi_enum_dv_presets,
> +	.s_dv_timings = hdmi_s_dv_timings,
> +	.g_dv_timings = hdmi_g_dv_timings,
> +	.enum_dv_timings = hdmi_enum_dv_timings,
> +	.dv_timings_cap = hdmi_dv_timings_cap,
>  	.g_mbus_fmt = hdmi_g_mbus_fmt,
>  	.s_stream = hdmi_s_stream,
>  };
> 

