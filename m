Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:34841 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbcGGARC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 20:17:02 -0400
Received: by mail-lf0-f46.google.com with SMTP id l188so1325798lfe.2
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 17:17:01 -0700 (PDT)
Date: Thu, 7 Jul 2016 02:16:58 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
	<niklas.soderlund@ragnatech.se>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: hans.verkuil@cisco.com, linux-media@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
	laurent.pinchart@ideasonboard.com, william.towle@codethink.co.uk
Subject: Re: [PATCH v5 4/4] rcar-vin: implement EDID control ioctls
Message-ID: <20160707001658.GL20356@bigcity.dyn.berto.se>
References: <1467819576-17743-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1467819576-17743-5-git-send-email-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1467819576-17743-5-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

Thanks for your patch.

On 2016-07-06 17:39:36 +0200, Ulrich Hecht wrote:
> Adds G_EDID and S_EDID.
> 
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 396eabc..bd8f14c 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -661,6 +661,20 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
>  	return ret;
>  }
>  
> +static int rvin_g_edid(struct file *file, void *fh, struct v4l2_edid *edid)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +
> +	return rvin_subdev_call(vin, pad, get_edid, edid);

You need to add a translation from the rcar-vin drivers view of it's 
current input to the subdevices view of how it's pads are arranged. I 
think something like this would work:

    struct rvin_dev *vin = video_drvdata(file);
    unsigned int input;
    int ret;

    input = edid->pad;

    edid->pad = vin->inputs[input].sink_idx;

    ret = vin_subdev_call(vin, pad, get_edid, edid);

    edid->pad = input;

    return ret;

I know it's not obvious you need this and I can't figure out a better 
way to solve runtime switching of subdevices. Any ideas on how to 
improve the situation are more then welcome :-)

> +}
> +
> +static int rvin_s_edid(struct file *file, void *fh, struct v4l2_edid *edid)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +
> +	return rvin_subdev_call(vin, pad, set_edid, edid);

Same comment as above.

> +}
> +
>  static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
>  	.vidioc_querycap		= rvin_querycap,
>  	.vidioc_try_fmt_vid_cap		= rvin_try_fmt_vid_cap,
> @@ -683,6 +697,9 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
>  	.vidioc_s_dv_timings		= rvin_s_dv_timings,
>  	.vidioc_query_dv_timings	= rvin_query_dv_timings,
>  
> +	.vidioc_g_edid			= rvin_g_edid,
> +	.vidioc_s_edid			= rvin_s_edid,
> +
>  	.vidioc_querystd		= rvin_querystd,
>  	.vidioc_g_std			= rvin_g_std,
>  	.vidioc_s_std			= rvin_s_std,
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
