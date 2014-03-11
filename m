Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3244 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbaCKME0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 08:04:26 -0400
Message-ID: <531EFB9B.1050902@xs4all.nl>
Date: Tue, 11 Mar 2014 13:03:39 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: k.debski@samsung.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 05/14] v4l: ti-vpe: Allow usage of smaller images
References: <1393922965-15967-1-git-send-email-archit@ti.com> <1394526833-24805-1-git-send-email-archit@ti.com> <1394526833-24805-6-git-send-email-archit@ti.com>
In-Reply-To: <1394526833-24805-6-git-send-email-archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/14 09:33, Archit Taneja wrote:
> The minimum width and height for VPE input/output was kept as 128 pixels. VPE
> doesn't have a constraint on the image height, it requires the image width to
> be at least 16 bytes.
> 
> Change the minimum supported dimensions to 32x32. This allows us to de-interlace
> qcif content. A smaller image size than 32x32 didn't make much sense, so stopped
> at this.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/platform/ti-vpe/vpe.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 0e7573a..dbdc338 100644
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
> 

