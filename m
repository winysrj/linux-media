Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:49148 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753761AbeBGRw1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 12:52:27 -0500
Subject: Re: [PATCH] media: stm32-dcmi: add g/s_parm framerate support
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
References: <1518025389-3677-1-git-send-email-hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <727ee222-20f1-23d3-fdff-4b985e24593d@xs4all.nl>
Date: Wed, 7 Feb 2018 18:52:20 +0100
MIME-Version: 1.0
In-Reply-To: <1518025389-3677-1-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/2018 06:43 PM, Hugues Fruchet wrote:
> Add g/s_parm framerate support by calling subdev
> g/s_frame_interval ops.
> This allows user to control sensor framerate by
> calling ioctl G/S_PARM.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/platform/stm32/stm32-dcmi.c | 49 +++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
> index ab555d4..8197554 100644
> --- a/drivers/media/platform/stm32/stm32-dcmi.c
> +++ b/drivers/media/platform/stm32/stm32-dcmi.c
> @@ -1151,6 +1151,52 @@ static int dcmi_enum_framesizes(struct file *file, void *fh,
>  	return 0;
>  }
>  
> +static int dcmi_g_parm(struct file *file, void *priv,
> +		       struct v4l2_streamparm *p)
> +{
> +	struct stm32_dcmi *dcmi = video_drvdata(file);
> +	struct v4l2_subdev_frame_interval ival = { 0 };
> +	int ret;
> +
> +	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	p->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
> +	ret = v4l2_subdev_call(dcmi->entity.subdev, video,
> +			       g_frame_interval, &ival);
> +	if (ret)
> +		return ret;
> +
> +	p->parm.capture.timeperframe = ival.interval;
> +
> +	return ret;
> +}

This function and the next can be simplified by using the help functions
introduced here:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=parm

I'll make a pull request for this later this week, so it's probably a good
idea to base your code on this as well.

Regards,

	Hans

> +
> +static int dcmi_s_parm(struct file *file, void *priv,
> +		       struct v4l2_streamparm *p)
> +{
> +	struct stm32_dcmi *dcmi = video_drvdata(file);
> +	struct v4l2_subdev_frame_interval ival = {
> +		0,
> +		p->parm.capture.timeperframe
> +	};
> +	int ret;
> +
> +	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	memset(&p->parm, 0, sizeof(p->parm));
> +	p->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
> +	ret = v4l2_subdev_call(dcmi->entity.subdev, video,
> +			       s_frame_interval, &ival);
> +	if (ret)
> +		return ret;
> +
> +	p->parm.capture.timeperframe = ival.interval;
> +
> +	return ret;
> +}
> +
>  static int dcmi_enum_frameintervals(struct file *file, void *fh,
>  				    struct v4l2_frmivalenum *fival)
>  {
> @@ -1253,6 +1299,9 @@ static int dcmi_release(struct file *file)
>  	.vidioc_g_input			= dcmi_g_input,
>  	.vidioc_s_input			= dcmi_s_input,
>  
> +	.vidioc_g_parm			= dcmi_g_parm,
> +	.vidioc_s_parm			= dcmi_s_parm,
> +
>  	.vidioc_enum_framesizes		= dcmi_enum_framesizes,
>  	.vidioc_enum_frameintervals	= dcmi_enum_frameintervals,
>  
> 
