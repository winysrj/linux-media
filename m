Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24396 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbaCCMOQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 07:14:16 -0500
From: Kamil Debski <k.debski@samsung.com>
To: 'Archit Taneja' <archit@ti.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
References: <1393832008-22174-1-git-send-email-archit@ti.com>
 <1393832008-22174-6-git-send-email-archit@ti.com>
In-reply-to: <1393832008-22174-6-git-send-email-archit@ti.com>
Subject: RE: [PATCH 5/7] v4l: ti-vpe: Allow usage of smaller images
Date: Mon, 03 Mar 2014 13:14:13 +0100
Message-id: <16d701cf36da$17704d80$4650e880$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Archit,

> From: Archit Taneja [mailto:archit@ti.com]
> Sent: Monday, March 03, 2014 8:33 AM
> 
> The minimum width and height for VPE input/output was kept as 128
> pixels. VPE doesn't have a constraint on the image height, it requires
> the image width to be atleast 16 bytes.

"16 bytes" - shouldn't it be pixels? (also "at least" :) ) 
I can correct it when applying the patch if the above is the case.
 
> Change the minimum supported dimensions to 32x32. This allows us to de-
> interlace qcif content. A smaller image size than 32x32 didn't make
> much sense, so stopped at this.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> ---
>  drivers/media/platform/ti-vpe/vpe.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c
> b/drivers/media/platform/ti-vpe/vpe.c
> index 915029b..3a610a6 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -49,8 +49,8 @@
>  #define VPE_MODULE_NAME "vpe"
> 
>  /* minimum and maximum frame sizes */
> -#define MIN_W		128
> -#define MIN_H		128
> +#define MIN_W		32
> +#define MIN_H		32
>  #define MAX_W		1920
>  #define MAX_H		1080
> 
> --
> 1.8.3.2

