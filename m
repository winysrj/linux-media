Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51386 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752223AbdCSWjp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 18:39:45 -0400
Date: Sun, 19 Mar 2017 22:39:31 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, kernel@pengutronix.de,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, p.zabel@pengutronix.de
Subject: Re: [PATCH 4/4] media: imx-media-capture: add frame sizes/interval
 enumeration
Message-ID: <20170319223931.GB21222@n2100.armlinux.org.uk>
References: <20170319103801.GQ21222@n2100.armlinux.org.uk>
 <E1cpYOa-0006Eu-CL@rmk-PC.armlinux.org.uk>
 <a9f6445c-97e4-fee9-d795-50724e98a766@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9f6445c-97e4-fee9-d795-50724e98a766@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 19, 2017 at 03:21:37PM -0700, Steve Longerbeam wrote:
> 
> 
> On 03/19/2017 03:49 AM, Russell King wrote:
> >Add support for enumerating frame sizes and frame intervals from the
> >first subdev via the V4L2 interfaces.
> >
> >Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> >---
> >  drivers/staging/media/imx/imx-media-capture.c | 62 +++++++++++++++++++++++++++
> >  1 file changed, 62 insertions(+)
> >
> >diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> >index cdeb2cd8b1d7..bc99d9310e36 100644
> >--- a/drivers/staging/media/imx/imx-media-capture.c
> >+++ b/drivers/staging/media/imx/imx-media-capture.c
> >@@ -82,6 +82,65 @@ static int vidioc_querycap(struct file *file, void *fh,
> >  	return 0;
> >  }
> >+static int capture_enum_framesizes(struct file *file, void *fh,
> >+				   struct v4l2_frmsizeenum *fsize)
> >+{
> >+	struct capture_priv *priv = video_drvdata(file);
> >+	const struct imx_media_pixfmt *cc;
> >+	struct v4l2_subdev_frame_size_enum fse = {
> >+		.index = fsize->index,
> >+		.pad = priv->src_sd_pad,
> >+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> >+	};
> >+	int ret;
> >+
> >+	cc = imx_media_find_format(fsize->pixel_format, CS_SEL_ANY, true);
> >+	if (!cc)
> >+		return -EINVAL;
> >+
> >+	fse.code = cc->codes[0];
> >+
> >+	ret = v4l2_subdev_call(priv->src_sd, pad, enum_frame_size, NULL, &fse);
> >+	if (ret)
> >+		return ret;
> >+
> >+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> >+	fsize->discrete.width = fse.min_width;
> >+	fsize->discrete.height = fse.max_height;
> >+
> >+	return 0;
> >+}
> 
> 
> The PRP ENC/VF subdevices will return a continuous range of
> supported frame sizes at their source pad, so this should be
> modified to:
> 
> ...
>     if (fse.min_width == fse.max_width &&
>         fse.min_height == fse.max_height) {
>         fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
>         fsize->discrete.width = fse.min_width;
>         fsize->discrete.height = fse.min_height;
>     } else {
>         fsize->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
>         fsize->stepwise.min_width = fse.min_width;
>         fsize->stepwise.max_width = fse.max_width;
>         fsize->stepwise.min_height = fse.min_height;
>         fsize->stepwise.max_height = fse.max_height;
>         fsize->stepwise.step_width = 1;
>         fsize->stepwise.step_height = 1;
>     }
> ...

Fine by me - I don't have any experience of those subdevices as they're
unusable for me.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
