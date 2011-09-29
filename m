Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:51205 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079Ab1I2L35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 07:29:57 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Taneja, Archit" <archit@ti.com>
CC: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Semwal, Sumit" <sumit.semwal@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 29 Sep 2011 16:59:49 +0530
Subject: RE: [PATCH v4 5/5] OMAP_VOUT: Increase MAX_DISPLAYS to a larger
 value
Message-ID: <19F8576C6E063C45BE387C64729E739404ECA5512F@dbde02.ent.ti.com>
References: <1317221368-3301-1-git-send-email-archit@ti.com>
 <1317221368-3301-6-git-send-email-archit@ti.com>
In-Reply-To: <1317221368-3301-6-git-send-email-archit@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Taneja, Archit
> Sent: Wednesday, September 28, 2011 8:19 PM
> To: Hiremath, Vaibhav
> Cc: Valkeinen, Tomi; linux-omap@vger.kernel.org; Semwal, Sumit; linux-
> media@vger.kernel.org; Taneja, Archit
> Subject: [PATCH v4 5/5] OMAP_VOUT: Increase MAX_DISPLAYS to a larger value
> 
> There is no limit to the number of displays that can registered with DSS2.
> The
> current value of MAX_DISPLAYS is 3, set this to 10 so that the 'displays'
> member of omap2video_device struct can store more omap_dss_device pointers.
> 
> This fixes a crash seen in omap_vout_probe when DSS2 registers for more
> than 3
> displays.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>
> ---
>  drivers/media/video/omap/omap_voutdef.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_voutdef.h
> b/drivers/media/video/omap/omap_voutdef.h
> index d793501..27a95d2 100644
> --- a/drivers/media/video/omap/omap_voutdef.h
> +++ b/drivers/media/video/omap/omap_voutdef.h
> @@ -25,7 +25,7 @@
>  #define MAC_VRFB_CTXS	4
>  #define MAX_VOUT_DEV	2
>  #define MAX_OVLS	3
> -#define MAX_DISPLAYS	3
> +#define MAX_DISPLAYS	10
>  #define MAX_MANAGERS	3
> 
>  #define QQVGA_WIDTH		160

Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>

Thanks,
Vaibhav


> --
> 1.7.1

