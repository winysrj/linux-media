Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05567C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 10:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7147020823
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 10:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfBHKbH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 05:31:07 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49775 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfBHKbG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 05:31:06 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gs3R3-00066Q-MD; Fri, 08 Feb 2019 11:31:05 +0100
Message-ID: <1549621864.3305.5.camel@pengutronix.de>
Subject: Re: [PATCH 4/4] media: imx-pxp: Start using the format VUYA32
 instead of YUV32
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Vivek Kasireddy <vivek.kasireddy@intel.com>,
        linux-media@vger.kernel.org
Date:   Fri, 08 Feb 2019 11:31:04 +0100
In-Reply-To: <20190208031846.14453-5-vivek.kasireddy@intel.com>
References: <20190208031846.14453-1-vivek.kasireddy@intel.com>
         <20190208031846.14453-5-vivek.kasireddy@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Vivek,

On Thu, 2019-02-07 at 19:18 -0800, Vivek Kasireddy wrote:
> Buffers generated with YUV32 format seems to be incorrect, hence use
> VUYA32 instead.
> 
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> ---
>  drivers/media/platform/imx-pxp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
> index f087dc4fc729..70adbe38f802 100644
> --- a/drivers/media/platform/imx-pxp.c
> +++ b/drivers/media/platform/imx-pxp.c
> @@ -90,7 +90,7 @@ static struct pxp_fmt formats[] = {
>  		.depth	= 16,
>  		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
>  	}, {
> -		.fourcc = V4L2_PIX_FMT_YUV32,
> +		.fourcc = V4L2_PIX_FMT_VUYA32,

After Hans' comment I noticed that to support VUYA32 input correctly,
we'll have to disable the alpha override. Currently the alpha channel of
buffers on the OUTPUT queue is ignored. The driver always uses the value
of V4L2_CID_ALPHA_COMPONENT when writing alpha values. Therefore, it
would be more correct to replace VUYA32 with VUYX32 everywhere.

Or alternatively add both formats, but only VUYX32 on the output queue:

 	}, {
-		.fourcc = V4L2_PIX_FMT_YUV32,
+		.fourcc = V4L2_PIX_FMT_VUYA32,
+		.depth  = 32,
+		.types  = MEM2MEM_CAPTURE,
+	}, {
+		.fourcc = V4L2_PIX_FMT_VUYX32,
 		.depth  = 32,

>  		.depth	= 32,
>  		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
>  	}, {
> @@ -236,7 +236,7 @@ static u32 pxp_v4l2_pix_fmt_to_ps_format(u32 v4l2_pix_fmt)
>  	case V4L2_PIX_FMT_RGB555:  return BV_PXP_PS_CTRL_FORMAT__RGB555;
>  	case V4L2_PIX_FMT_RGB444:  return BV_PXP_PS_CTRL_FORMAT__RGB444;
>  	case V4L2_PIX_FMT_RGB565:  return BV_PXP_PS_CTRL_FORMAT__RGB565;
> -	case V4L2_PIX_FMT_YUV32:   return BV_PXP_PS_CTRL_FORMAT__YUV1P444;
> +	case V4L2_PIX_FMT_VUYA32:  return BV_PXP_PS_CTRL_FORMAT__YUV1P444;

This should be replaced with VUYX32:

-	case V4L2_PIX_FMT_YUV32:   return BV_PXP_PS_CTRL_FORMAT__YUV1P444;
+	case V4L2_PIX_FMT_VUYX32:  return BV_PXP_PS_CTRL_FORMAT__YUV1P444;

>  	case V4L2_PIX_FMT_UYVY:    return BV_PXP_PS_CTRL_FORMAT__UYVY1P422;
>  	case V4L2_PIX_FMT_YUYV:    return BM_PXP_PS_CTRL_WB_SWAP |
>  					  BV_PXP_PS_CTRL_FORMAT__UYVY1P422;
> @@ -265,7 +265,7 @@ static u32 pxp_v4l2_pix_fmt_to_out_format(u32 v4l2_pix_fmt)
>  	case V4L2_PIX_FMT_RGB555:   return BV_PXP_OUT_CTRL_FORMAT__RGB555;
>  	case V4L2_PIX_FMT_RGB444:   return BV_PXP_OUT_CTRL_FORMAT__RGB444;
>  	case V4L2_PIX_FMT_RGB565:   return BV_PXP_OUT_CTRL_FORMAT__RGB565;
> -	case V4L2_PIX_FMT_YUV32:    return BV_PXP_OUT_CTRL_FORMAT__YUV1P444;
> +	case V4L2_PIX_FMT_VUYA32:   return BV_PXP_OUT_CTRL_FORMAT__YUV1P444;

Here you could add both:

-	case V4L2_PIX_FMT_YUV32:    return BV_PXP_OUT_CTRL_FORMAT__YUV1P444;
+	case V4L2_PIX_FMT_VUYA32:
+	case V4L2_PIX_FMT_VUYX32:   return BV_PXP_OUT_CTRL_FORMAT__YUV1P444;

>  	case V4L2_PIX_FMT_UYVY:     return BV_PXP_OUT_CTRL_FORMAT__UYVY1P422;
>  	case V4L2_PIX_FMT_VYUY:     return BV_PXP_OUT_CTRL_FORMAT__VYUY1P422;
>  	case V4L2_PIX_FMT_GREY:     return BV_PXP_OUT_CTRL_FORMAT__Y8;
> @@ -281,7 +281,7 @@ static u32 pxp_v4l2_pix_fmt_to_out_format(u32 v4l2_pix_fmt)
>  static bool pxp_v4l2_pix_fmt_is_yuv(u32 v4l2_pix_fmt)
>  {
>  	switch (v4l2_pix_fmt) {
> -	case V4L2_PIX_FMT_YUV32:
> +	case V4L2_PIX_FMT_VUYA32:

And here as well:

-	case V4L2_PIX_FMT_YUV32:
+	case V4L2_PIX_FMT_VUYA32:
+	case V4L2_PIX_FMT_VUYX32:

>  	case V4L2_PIX_FMT_UYVY:
>  	case V4L2_PIX_FMT_YUYV:
>  	case V4L2_PIX_FMT_VYUY:

regards
Philipp
