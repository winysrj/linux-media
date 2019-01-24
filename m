Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F69C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 11:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0451321872
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 11:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfAXLXq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 06:23:46 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43031 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfAXLXq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 06:23:46 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gmd6j-0007k1-DE; Thu, 24 Jan 2019 12:23:41 +0100
Message-ID: <1548329020.6014.12.camel@pengutronix.de>
Subject: Re: [PATCH v10 12/13] media: video-mux: add bayer formats
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Rui Miguel Silva <rui.silva@linaro.org>,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Thu, 24 Jan 2019 12:23:40 +0100
In-Reply-To: <20190123105222.2378-13-rui.silva@linaro.org>
References: <20190123105222.2378-1-rui.silva@linaro.org>
         <20190123105222.2378-13-rui.silva@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 2019-01-23 at 10:52 +0000, Rui Miguel Silva wrote:
> Add non vendor bayer formats to the  allowed format array.
> 
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  drivers/media/platform/video-mux.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
> index c33900e3c23e..0ba30756e1e4 100644
> --- a/drivers/media/platform/video-mux.c
> +++ b/drivers/media/platform/video-mux.c
> @@ -263,6 +263,26 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
>  	case MEDIA_BUS_FMT_UYYVYY16_0_5X48:
>  	case MEDIA_BUS_FMT_JPEG_1X8:
>  	case MEDIA_BUS_FMT_AHSV8888_1X32:
> +	case MEDIA_BUS_FMT_SBGGR8_1X8:
> +	case MEDIA_BUS_FMT_SGBRG8_1X8:
> +	case MEDIA_BUS_FMT_SGRBG8_1X8:
> +	case MEDIA_BUS_FMT_SRGGB8_1X8:
> +	case MEDIA_BUS_FMT_SBGGR10_1X10:
> +	case MEDIA_BUS_FMT_SGBRG10_1X10:
> +	case MEDIA_BUS_FMT_SGRBG10_1X10:
> +	case MEDIA_BUS_FMT_SRGGB10_1X10:
> +	case MEDIA_BUS_FMT_SBGGR12_1X12:
> +	case MEDIA_BUS_FMT_SGBRG12_1X12:
> +	case MEDIA_BUS_FMT_SGRBG12_1X12:
> +	case MEDIA_BUS_FMT_SRGGB12_1X12:
> +	case MEDIA_BUS_FMT_SBGGR14_1X14:
> +	case MEDIA_BUS_FMT_SGBRG14_1X14:
> +	case MEDIA_BUS_FMT_SGRBG14_1X14:
> +	case MEDIA_BUS_FMT_SRGGB14_1X14:
> +	case MEDIA_BUS_FMT_SBGGR16_1X16:
> +	case MEDIA_BUS_FMT_SGBRG16_1X16:
> +	case MEDIA_BUS_FMT_SGRBG16_1X16:
> +	case MEDIA_BUS_FMT_SRGGB16_1X16:
>  		break;
>  	default:
>  		sdformat->format.code = MEDIA_BUS_FMT_Y8_1X8;

This could be merged independently from the other changes.

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
