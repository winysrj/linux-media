Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:41089 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756437AbdCUJZn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 05:25:43 -0400
Message-ID: <1490088242.2913.5.camel@pengutronix.de>
Subject: Re: [PATCH v3 2/4] media-ctl: print the configured frame interval
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Date: Tue, 21 Mar 2017 10:24:02 +0100
In-Reply-To: <1486986047-18128-2-git-send-email-p.zabel@pengutronix.de>
References: <1486986047-18128-1-git-send-email-p.zabel@pengutronix.de>
         <1486986047-18128-2-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-02-13 at 12:40 +0100, Philipp Zabel wrote:
> After the pad format, also print the frame interval, if already configured.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  utils/media-ctl/media-ctl.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/utils/media-ctl/media-ctl.c b/utils/media-ctl/media-ctl.c
> index 572bcf7..383fbfa 100644
> --- a/utils/media-ctl/media-ctl.c
> +++ b/utils/media-ctl/media-ctl.c
> @@ -79,6 +79,7 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
>  	unsigned int pad, enum v4l2_subdev_format_whence which)
>  {
>  	struct v4l2_mbus_framefmt format;
> +	struct v4l2_fract interval = { 0, 0 };
>  	struct v4l2_rect rect;
>  	int ret;
>  
> @@ -86,10 +87,17 @@ static void v4l2_subdev_print_format(struct media_entity *entity,
>  	if (ret != 0)
>  		return;
>  
> +	ret = v4l2_subdev_get_frame_interval(entity, &interval, pad);
> +	if (ret != 0 && ret != -ENOTTY)

I noticed the documentation says in 8.60.5. Return Value [1]:

  EINVAL
    The struct v4l2_subdev_frame_interval pad references a non-existing
    pad, or the pad doesn’t support frame intervals.

even though VIDIOC_SUBDEV_G_FRAME_INTERVAL returns ENOTTY (by way of
ENOIOCTLCMD) if .g_frame_interval in the video ops is not implemented.
Is this an error in the spec, an error in the code, or just me
misunderstanding?

Should this line be changed to
	if (ret != 0 && ret != -ENOTTY && ret != -EINVAL)
?

[1] https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/vidioc-subdev-g-frame-interval.html#return-value

> +		return;
> +
>  	printf("\t\t[fmt:%s/%ux%u",
>  	       v4l2_subdev_pixelcode_to_string(format.code),
>  	       format.width, format.height);
>  
> +	if (interval.numerator || interval.denominator)
> +		printf("@%u/%u", interval.numerator, interval.denominator);
> +
>  	if (format.field)
>  		printf(" field:%s", v4l2_subdev_field_to_string(format.field));
>  

regards
Philipp
