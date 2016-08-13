Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:60426 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294AbcHMNbG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2016 09:31:06 -0400
Subject: Re: [PATCH v6 4/4] rcar-vin: implement EDID control ioctls
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
References: <1469178554-20719-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1469178554-20719-5-git-send-email-ulrich.hecht+renesas@gmail.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	william.towle@codethink.co.uk, geert@linux-m68k.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0bf4740a-7200-c6c4-c432-6a8152dec17a@xs4all.nl>
Date: Sat, 13 Aug 2016 15:30:59 +0200
MIME-Version: 1.0
In-Reply-To: <1469178554-20719-5-git-send-email-ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/22/2016 11:09 AM, Ulrich Hecht wrote:
> Adds G_EDID and S_EDID.
> 
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 33 +++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 396eabc..57e040c 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -661,6 +661,36 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
>  	return ret;
>  }
>  
> +static int rvin_g_edid(struct file *file, void *fh, struct v4l2_edid *edid)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	int input, ret;
> +
> +	input = edid->pad;
> +	edid->pad = vin->inputs[input].sink_idx;

There is no vin->inputs array. Are there some other patches that need to be merged
first?

Anyway, it would be good if you can post a rebased v7, I had to manually update
one or two other patches from this series as well to make them apply so a new patch
series would be helpful.

Regards,

	Hans

> +
> +	ret = rvin_subdev_call(vin, pad, get_edid, edid);
> +
> +	edid->pad = input;
> +
> +	return ret;
> +}
> +
> +static int rvin_s_edid(struct file *file, void *fh, struct v4l2_edid *edid)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	int input, ret;
> +
> +	input = edid->pad;
> +	edid->pad = vin->inputs[input].sink_idx;
> +
> +	ret = rvin_subdev_call(vin, pad, set_edid, edid);
> +
> +	edid->pad = input;
> +
> +	return ret;
> +}
> +
>  static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
>  	.vidioc_querycap		= rvin_querycap,
>  	.vidioc_try_fmt_vid_cap		= rvin_try_fmt_vid_cap,
> @@ -683,6 +713,9 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
>  	.vidioc_s_dv_timings		= rvin_s_dv_timings,
>  	.vidioc_query_dv_timings	= rvin_query_dv_timings,
>  
> +	.vidioc_g_edid			= rvin_g_edid,
> +	.vidioc_s_edid			= rvin_s_edid,
> +
>  	.vidioc_querystd		= rvin_querystd,
>  	.vidioc_g_std			= rvin_g_std,
>  	.vidioc_s_std			= rvin_s_std,
> 
