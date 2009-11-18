Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:36479 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168AbZKRPNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 10:13:53 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Y, Kishore" <kishore.y@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Wed, 18 Nov 2009 20:43:57 +0530
Subject: RE: [PATCH] V4L2: clear buf when vrfb buf not allocated
Message-ID: <19F8576C6E063C45BE387C64729E7394043702BAA3@dbde02.ent.ti.com>
References: <E0D41E29EB0DAC4E9F3FF173962E9E9402543305C5@dbde02.ent.ti.com>
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E9402543305C5@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Y, Kishore
> Sent: Wednesday, November 18, 2009 7:20 PM
> To: linux-media@vger.kernel.org
> Cc: linux-omap@vger.kernel.org
> Subject: [PATCH] V4L2: clear buf when vrfb buf not allocated
> 
> From 15246e4dfa6853d9aef48a4b8633f93efe40ed81 Mon Sep 17 00:00:00
> 2001
> From: Kishore Y <kishore.y@ti.com>
> Date: Thu, 12 Nov 2009 20:47:58 +0530
> Subject: [PATCH] V4L2: clear buf when vrfb buf not allocated
> 
> 	buffer memory is set to 0 only for the first time
> before the vrfb buffer is allocated
> 
> Signed-off-by:  Kishore Y <kishore.y@ti.com>
> ---
> This patch is dependent on the patch
> [PATCH 4/4] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on top
> of DSS2
> 
>  drivers/media/video/omap/omap_vout.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index 7092ef2..0a9fdd7 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -223,9 +223,11 @@ static int
> omap_vout_allocate_vrfb_buffers(struct omap_vout_device *vout,
>  		unsigned int *count, int startindex)
>  {
>  	int i, j;
> +	int buffer_set;
> 
>  	for (i = 0; i < *count; i++) {
> -		if (!vout->smsshado_virt_addr[i]) {
> +		buffer_set = vout->smsshado_virt_addr[i];
> +		if (!buffer_set) {
>  			vout->smsshado_virt_addr[i] =
>  				omap_vout_alloc_buffer(vout->smsshado_size,
>  						&vout->smsshado_phy_addr[i]);
> @@ -247,8 +249,10 @@ static int
> omap_vout_allocate_vrfb_buffers(struct omap_vout_device *vout,
>  			*count = 0;
>  			return -ENOMEM;
>  		}
> -		memset((void *) vout->smsshado_virt_addr[i], 0,
> -				vout->smsshado_size);
> +		if (!buffer_set) {
> +			memset((void *) vout->smsshado_virt_addr[i], 0,
> +					vout->smsshado_size);
> +		}
>  	}
[Hiremath, Vaibhav] Why do we need this? Anyway if I understand correctly this function is getting called only once during REQBUF or probe, right?

If you are selecting static_vrfb_allocation through module_params, then anyway REQBUF won't call this function again, since the buffers are already allocated.

Thanks,
Vaibhav

>  	return 0;
>  }
> --
> 1.5.4.3
> 
> 
> Regards,
> Kishore Y
> Ph:- +918039813085
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

