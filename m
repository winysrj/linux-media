Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58588 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbbAOQ7v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2015 11:59:51 -0500
Received: by mail-wi0-f171.google.com with SMTP id ho1so3852194wib.4
        for <linux-media@vger.kernel.org>; Thu, 15 Jan 2015 08:59:49 -0800 (PST)
Message-ID: <54B7F202.5050003@vodalys.com>
Date: Thu, 15 Jan 2015 17:59:46 +0100
From: =?windows-1252?Q?Fr=E9d=E9ric_Sureau?=
	<frederic.sureau@vodalys.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Kamil Debski <k.debski@samsung.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [RFC PATCH] [media] coda: Use S_PARM to set nominal framerate
 for h.264 encoder
References: <1419264000-11761-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1419264000-11761-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Le 22/12/2014 17:00, Philipp Zabel a écrit :
> The encoder needs to know the nominal framerate for the constant bitrate
> control mechanism to work. Currently the only way to set the framerate is
> by using VIDIOC_S_PARM on the output queue.
>
> Signed-off-by: Philipp Zabel<p.zabel@pengutronix.de>
> ---
>   drivers/media/platform/coda/coda-common.c | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
>
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 39330a7..63eb510 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -803,6 +803,32 @@ static int coda_decoder_cmd(struct file *file, void *fh,
>   	return 0;
>   }
>   
> +static int coda_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(fh);
> +
> +	a->parm.output.timeperframe.denominator = 1;
> +	a->parm.output.timeperframe.numerator = ctx->params.framerate;
> +
Maybe a->parm.output.capability should be set to V4L2_CAP_TIMEPERFRAME here.
I think it is required by GStreamer V4L2 plugin.
> +	return 0;
> +}
> +
> +static int coda_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(fh);
> +
> +	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> +	    a->parm.output.timeperframe.numerator != 0) {
> +		ctx->params.framerate = a->parm.output.timeperframe.denominator
> +				      / a->parm.output.timeperframe.numerator;
> +	}
> +
> +	a->parm.output.timeperframe.denominator = 1;
> +	a->parm.output.timeperframe.numerator = ctx->params.framerate;
> +
> +	return 0;
> +}
> +
>   static int coda_subscribe_event(struct v4l2_fh *fh,
>   				const struct v4l2_event_subscription *sub)
>   {
> @@ -843,6 +869,9 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
>   	.vidioc_try_decoder_cmd	= coda_try_decoder_cmd,
>   	.vidioc_decoder_cmd	= coda_decoder_cmd,
>   
> +	.vidioc_g_parm		= coda_g_parm,
> +	.vidioc_s_parm		= coda_s_parm,
> +
>   	.vidioc_subscribe_event = coda_subscribe_event,
>   	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>   };
Thanks for the patch!
Fred
