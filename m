Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:34535 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756651AbdDRJa3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 05:30:29 -0400
Message-ID: <1492507819.2432.53.camel@pengutronix.de>
Subject: Re: [PATCH 40/40] media: imx: set and propagate empty field,
 colorimetry params
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: gregkh@linuxfoundation.org, mchehab@kernel.org,
        rmk+kernel@armlinux.org.uk, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Tue, 18 Apr 2017 11:30:19 +0200
In-Reply-To: <3dc391ff-685e-8d76-1e9c-9725c397bee2@gmail.com>
References: <7d836723-dc01-2cea-f794-901b632ce46e@gmail.com>
         <1492044337-11324-1-git-send-email-steve_longerbeam@mentor.com>
         <1492078154.2383.21.camel@pengutronix.de>
         <3dc391ff-685e-8d76-1e9c-9725c397bee2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-04-13 at 09:40 -0700, Steve Longerbeam wrote:
[...]
> >> @@ -804,12 +804,29 @@ static void prp_try_fmt(struct prp_priv *priv,
> >>  					      &sdformat->format.height,
> >>  					      infmt->height / 4, MAX_H_SRC,
> >>  					      H_ALIGN_SRC, S_ALIGN);
> >> +
> >> +		/*
> >> +		 * The Image Converter produces fixed quantization
> >> +		 * (full range for RGB, limited range for YUV), and
> >> +		 * uses a fixed Y`CbCr encoding (V4L2_YCBCR_ENC_601).
> >> +		 * For colorspace and transfer func, just propagate
> >> +		 * from the sink.
> >> +		 */
> >> +		sdformat->format.quantization =
> >> +			((*cc)->cs != IPUV3_COLORSPACE_YUV) ?
> >> +			V4L2_QUANTIZATION_FULL_RANGE :
> >> +			V4L2_QUANTIZATION_LIM_RANGE;
> >> +		sdformat->format.ycbcr_enc = V4L2_YCBCR_ENC_601;
> >
> > Support for V4L2_YCBCR_ENC_709 and quantization options could be added
> > to the IPUv3 core code, so this limitation could be relaxed later.
> 
> Yes, I was going to mention that too. We can add coefficient tables
> to ipu-ic for all the encodings enumerated in enum v4l2_ycbcr_encoding.

Exactly.

> I know that quantization is programmable in the DP, but is it in the
> IC? AFAICT there is none.

We have a freely programmable 4x3 matrix multiplication both before and
after processing in each task, and there is a saturation mode switch
that can limit the first component to (16...235) and the other two to
(16...240). That should be enough for at least full/limited range YCbCr
quantizations. So we apparently can't saturate to limited range RGB, but
for example full-range -> limited-range RGB conversions should be
perfectly possible.

regards
Philipp
