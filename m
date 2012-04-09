Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51266 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab2DIKy2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2012 06:54:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: saaguirre@ti.com
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for YUV420 formats
Date: Mon, 09 Apr 2012 12:54:34 +0200
Message-ID: <3345973.yLnIm4HIcR@avalon>
In-Reply-To: <1333857274-9435-1-git-send-email-saaguirre@ti.com>
References: <1333857274-9435-1-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

Thanks for the patch.

On Saturday 07 April 2012 22:54:34 saaguirre@ti.com wrote:
> From: Sergio Aguirre <saaguirre@ti.com>
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>

Applied to the tree (with a small modification to keep the entries somehow 
sorted).

> ---
>  src/v4l2subdev.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
> index b886b72..e28ed49 100644
> --- a/src/v4l2subdev.c
> +++ b/src/v4l2subdev.c
> @@ -498,8 +498,10 @@ static struct {
>  	{ "Y12", V4L2_MBUS_FMT_Y12_1X12 },
>  	{ "YUYV", V4L2_MBUS_FMT_YUYV8_1X16 },
>  	{ "YUYV2X8", V4L2_MBUS_FMT_YUYV8_2X8 },
> +	{ "YUYV1_5X8", V4L2_MBUS_FMT_YUYV8_1_5X8 },
>  	{ "UYVY", V4L2_MBUS_FMT_UYVY8_1X16 },
>  	{ "UYVY2X8", V4L2_MBUS_FMT_UYVY8_2X8 },
> +	{ "UYVY1_5X8", V4L2_MBUS_FMT_UYVY8_1_5X8 },
>  	{ "SBGGR8", V4L2_MBUS_FMT_SBGGR8_1X8 },
>  	{ "SGBRG8", V4L2_MBUS_FMT_SGBRG8_1X8 },
>  	{ "SGRBG8", V4L2_MBUS_FMT_SGRBG8_1X8 },
-- 
Regards,

Laurent Pinchart

