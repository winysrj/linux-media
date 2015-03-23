Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52592 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbbCWJYs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2015 05:24:48 -0400
Message-ID: <1427102687.3170.7.camel@pengutronix.de>
Subject: Re: [RFC PATCH] v4l2-ioctl: fill in the description for
 VIDIOC_ENUM_FMT
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Mon, 23 Mar 2015 10:24:47 +0100
In-Reply-To: <550C0FCF.4030302@xs4all.nl>
References: <550C0FCF.4030302@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Am Freitag, den 20.03.2015, 13:17 +0100 schrieb Hans Verkuil:
> The descriptions used in drivers for the formats returned with ENUM_FMT
> are all over the place.
> 
> So instead allow the core to fill in the description and flags. This
> allows drivers to drop the description and flags.
> 
> If the format is not found in the list, and if the description field is
> filled in, then just return but call WARN_ONCE to let developers know
> that this list needs to be extended.
> 
> Based on an earlier patch from Philipp Zabel:
> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/81411
> 
> But this patch moves the code into the core and away from drivers.

I like it. There's one small error in the NV42 description below,
otherwise
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 222 +++++++++++++++++++++++++++++++++--
>  1 file changed, 215 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 09ad8dd..694d1e0 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1101,6 +1101,205 @@ static int v4l_enumoutput(const struct v4l2_ioctl_ops *ops,
>  	return ops->vidioc_enum_output(file, fh, p);
>  }
>  
> +static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
> +{
> +	const unsigned sz = sizeof(fmt->description);
> +	const char *descr = NULL;
> +
> +	switch (fmt->pixelformat) {
> +	/* Max description length mask:	descr = "0123456789012345678901234567890" */
> +	case V4L2_PIX_FMT_RGB332:	descr = "8-bit RGB 3-3-2"; break;
[...]
> +	case V4L2_PIX_FMT_NV12:		descr = "Y/CbCr 4:2:0"; break;
> +	case V4L2_PIX_FMT_NV21:		descr = "Y/CrCb 4:2:0"; break;
> +	case V4L2_PIX_FMT_NV16:		descr = "Y/CbCr 4:2:2"; break;
> +	case V4L2_PIX_FMT_NV61:		descr = "Y/CrCb 4:2:0"; break;
> +	case V4L2_PIX_FMT_NV24:		descr = "Y/CbCr 4:4:4"; break;
> +	case V4L2_PIX_FMT_NV42:		descr = "Y/CrCb 4:2:0"; break;

That should be 4:4:4 for NV42.

regards
Philipp

