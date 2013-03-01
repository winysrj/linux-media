Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37259 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab3CALCd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 06:02:33 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MIZ00BBPAK3MI70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Mar 2013 11:02:32 +0000 (GMT)
Received: from [106.116.147.108] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MIZ003SWAO8OT10@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Mar 2013 11:02:32 +0000 (GMT)
Message-id: <51308AC7.9070005@samsung.com>
Date: Fri, 01 Mar 2013 12:02:31 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 11/18] s5p-tv: remove dv_preset support from
 mixer_video.
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
 <686e9074fa10f883d236767e2b33f07728aaf8f7.1361006882.git.hans.verkuil@cisco.com>
In-reply-to: <686e9074fa10f883d236767e2b33f07728aaf8f7.1361006882.git.hans.verkuil@cisco.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Please refer to the comments below.

On 02/16/2013 10:28 AM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The dv_preset API is deprecated and is replaced by the much improved dv_timings
> API. Remove the dv_preset support from this driver as this will allow us to
> remove the dv_preset API altogether (s5p-tv being the last user of this code).
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-tv/mixer_video.c |   68 ++-------------------------
>  1 file changed, 3 insertions(+), 65 deletions(-)
> 

[snip]

>  static int mxr_enum_dv_timings(struct file *file, void *fh,
>  	struct v4l2_enum_dv_timings *timings)
>  {
> @@ -584,7 +526,7 @@ static int mxr_s_dv_timings(struct file *file, void *fh,
>  	/* lock protects from changing sd_out */
>  	mutex_lock(&mdev->mutex);
>  
> -	/* preset change cannot be done while there is an entity
> +	/* timings change cannot be done while there is an entity
>  	 * dependant on output configuration
>  	 */
>  	if (mdev->n_output > 0) {
> @@ -689,8 +631,8 @@ static int mxr_enum_output(struct file *file, void *fh, struct v4l2_output *a)
>  	/* try to obtain supported tv norms */
>  	v4l2_subdev_call(sd, video, g_tvnorms_output, &a->std);
>  	a->capabilities = 0;
> -	if (sd->ops->video && sd->ops->video->s_dv_preset)
> -		a->capabilities |= V4L2_OUT_CAP_PRESETS;

Could you move the lines below to the patch named
"[RFC PATCH 08/18] s5p-tv: add dv_timings support for mixer_video.".

> +	if (sd->ops->video && sd->ops->video->s_dv_timings)
> +		a->capabilities |= V4L2_OUT_CAP_DV_TIMINGS;

Don't you think that all "add" patches should go in reverse order?
I mean that dv_timings hdmiphy should be applied before hdmi. The hdmi before mixer.
This way all non-functional features would stay invisible from user-space until
they become functional.

>  	if (sd->ops->video && sd->ops->video->s_std_output)
>  		a->capabilities |= V4L2_OUT_CAP_STD;
>  	a->type = V4L2_OUTPUT_TYPE_ANALOG;
> @@ -811,10 +753,6 @@ static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
>  	/* Streaming control */
>  	.vidioc_streamon = mxr_streamon,
>  	.vidioc_streamoff = mxr_streamoff,
> -	/* Preset functions */
> -	.vidioc_enum_dv_presets = mxr_enum_dv_presets,
> -	.vidioc_s_dv_preset = mxr_s_dv_preset,
> -	.vidioc_g_dv_preset = mxr_g_dv_preset,
>  	/* DV Timings functions */
>  	.vidioc_enum_dv_timings = mxr_enum_dv_timings,
>  	.vidioc_s_dv_timings = mxr_s_dv_timings,
> 

