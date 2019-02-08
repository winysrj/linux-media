Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B28C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 09:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7A5F21917
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 09:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfBHJPs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 04:15:48 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:52405 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726934AbfBHJPs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 04:15:48 -0500
Received: from [IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a] ([IPv6:2001:983:e9a7:1:5eb:9ad5:2371:b65a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id s2G8gyuqzBDyIs2G9gLgjB; Fri, 08 Feb 2019 10:15:45 +0100
Subject: Re: [PATCH 4/4] media: imx-pxp: Start using the format VUYA32 instead
 of YUV32
To:     Vivek Kasireddy <vivek.kasireddy@intel.com>,
        linux-media@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>
References: <20190208031846.14453-1-vivek.kasireddy@intel.com>
 <20190208031846.14453-5-vivek.kasireddy@intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5119be5b-4480-68f5-bb50-900eca9eb10f@xs4all.nl>
Date:   Fri, 8 Feb 2019 10:15:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190208031846.14453-5-vivek.kasireddy@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAZdUizOE1mi8Ri6vz5bd93ulEGNw8doZwRQEAFyNfEF1aW2rB0Q2C0N3uxzS0E6aQo0FUl+zWaTsMSvxVUSNFQ5YspJVL2Z5AaaUnbR4tbx24d/ny+a
 jbhWYF5aDRLQun+X1+pdJEGlU+v/AvKMOaZ+tE4A3ScfCUV+r6cBuW1ZXK47PBMJfnklBVUM4IKRjHScrjNldeQu7tt4kC67lX3Z0QLbNH4DNNuCoqC2D6xo
 rxWvB9i8/o25SYPF3fuK6FHwJsn5R+2hLiml+VOtbOI8JUaaN9vcehjA3e8N1//L2qW1pnb910TqEhdbx8xgZjehGmbXwNYbfzi6tjpKWpcXQRevVFv0/HEC
 rFoczd7y
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/8/19 4:18 AM, Vivek Kasireddy wrote:
> Buffers generated with YUV32 format seems to be incorrect, hence use
> VUYA32 instead.
> 
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>

Philipp, I wonder whether VUYA32 or VUYX32 should be used? I think the alpha
channel is completely ignored on the source side and on the destination side
it is probably set by some fixed value?

Note that there exists a control V4L2_CID_ALPHA_COMPONENT that can be used
to let userspace specify the generated alpha value.

What if both source and destination formats have an alpha channel? Can the
hardware preserved the alpha values?

Regards,

	Hans

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
>  		.depth	= 32,
>  		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
>  	}, {
> @@ -236,7 +236,7 @@ static u32 pxp_v4l2_pix_fmt_to_ps_format(u32 v4l2_pix_fmt)
>  	case V4L2_PIX_FMT_RGB555:  return BV_PXP_PS_CTRL_FORMAT__RGB555;
>  	case V4L2_PIX_FMT_RGB444:  return BV_PXP_PS_CTRL_FORMAT__RGB444;
>  	case V4L2_PIX_FMT_RGB565:  return BV_PXP_PS_CTRL_FORMAT__RGB565;
> -	case V4L2_PIX_FMT_YUV32:   return BV_PXP_PS_CTRL_FORMAT__YUV1P444;
> +	case V4L2_PIX_FMT_VUYA32:  return BV_PXP_PS_CTRL_FORMAT__YUV1P444;
>  	case V4L2_PIX_FMT_UYVY:    return BV_PXP_PS_CTRL_FORMAT__UYVY1P422;
>  	case V4L2_PIX_FMT_YUYV:    return BM_PXP_PS_CTRL_WB_SWAP |
>  					  BV_PXP_PS_CTRL_FORMAT__UYVY1P422;
> @@ -265,7 +265,7 @@ static u32 pxp_v4l2_pix_fmt_to_out_format(u32 v4l2_pix_fmt)
>  	case V4L2_PIX_FMT_RGB555:   return BV_PXP_OUT_CTRL_FORMAT__RGB555;
>  	case V4L2_PIX_FMT_RGB444:   return BV_PXP_OUT_CTRL_FORMAT__RGB444;
>  	case V4L2_PIX_FMT_RGB565:   return BV_PXP_OUT_CTRL_FORMAT__RGB565;
> -	case V4L2_PIX_FMT_YUV32:    return BV_PXP_OUT_CTRL_FORMAT__YUV1P444;
> +	case V4L2_PIX_FMT_VUYA32:   return BV_PXP_OUT_CTRL_FORMAT__YUV1P444;
>  	case V4L2_PIX_FMT_UYVY:     return BV_PXP_OUT_CTRL_FORMAT__UYVY1P422;
>  	case V4L2_PIX_FMT_VYUY:     return BV_PXP_OUT_CTRL_FORMAT__VYUY1P422;
>  	case V4L2_PIX_FMT_GREY:     return BV_PXP_OUT_CTRL_FORMAT__Y8;
> @@ -281,7 +281,7 @@ static u32 pxp_v4l2_pix_fmt_to_out_format(u32 v4l2_pix_fmt)
>  static bool pxp_v4l2_pix_fmt_is_yuv(u32 v4l2_pix_fmt)
>  {
>  	switch (v4l2_pix_fmt) {
> -	case V4L2_PIX_FMT_YUV32:
> +	case V4L2_PIX_FMT_VUYA32:
>  	case V4L2_PIX_FMT_UYVY:
>  	case V4L2_PIX_FMT_YUYV:
>  	case V4L2_PIX_FMT_VYUY:
> 

