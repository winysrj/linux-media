Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55115 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab1IUNex convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 09:34:53 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Taneja, Archit" <archit@ti.com>
CC: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Semwal, Sumit" <sumit.semwal@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 21 Sep 2011 19:04:45 +0530
Subject: RE: [PATCH 3/5] [media]: OMAP_VOUT: Fix VSYNC IRQ handling in
 omap_vout_isr
Message-ID: <19F8576C6E063C45BE387C64729E739404EC941F86@dbde02.ent.ti.com>
References: <1316167233-1437-1-git-send-email-archit@ti.com>
 <1316167233-1437-4-git-send-email-archit@ti.com>
In-Reply-To: <1316167233-1437-4-git-send-email-archit@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Taneja, Archit
> Sent: Friday, September 16, 2011 3:31 PM
> To: Hiremath, Vaibhav
> Cc: Valkeinen, Tomi; linux-omap@vger.kernel.org; Semwal, Sumit; linux-
> media@vger.kernel.org; Taneja, Archit
> Subject: [PATCH 3/5] [media]: OMAP_VOUT: Fix VSYNC IRQ handling in
> omap_vout_isr
> 
> Currently, in omap_vout_isr(), if the panel type is DPI, and if we
> get either VSYNC or VSYNC2 interrupts, we proceed ahead to set the
> current buffers state to VIDEOBUF_DONE and prepare to display the
> next frame in the queue.
> 
> On OMAP4, because we have 2 LCD managers, the panel type itself is not
> sufficient to tell if we have received the correct irq, i.e, we shouldn't
> proceed ahead if we get a VSYNC interrupt for LCD2 manager, or a VSYNC2
> interrupt for LCD manager.
> 
> Fix this by correlating LCD manager to VSYNC interrupt and LCD2 manager
> to VSYNC2 interrupt.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>
> ---
>  drivers/media/video/omap/omap_vout.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index c5f2ea0..20638c3 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -566,8 +566,8 @@ err:
> 
>  static void omap_vout_isr(void *arg, unsigned int irqstatus)
>  {
> -	int ret, fid;
> -	u32 addr;
> +	int ret, fid, mgr_id;
> +	u32 addr, irq;
>  	struct omap_overlay *ovl;
>  	struct timeval timevalue;
>  	struct omapvideo_info *ovid;
> @@ -583,6 +583,7 @@ static void omap_vout_isr(void *arg, unsigned int
> irqstatus)
>  	if (!ovl->manager || !ovl->manager->device)
>  		return;
> 
> +	mgr_id = ovl->manager->id;
>  	cur_display = ovl->manager->device;
> 
>  	spin_lock(&vout->vbq_lock);
> @@ -590,7 +591,14 @@ static void omap_vout_isr(void *arg, unsigned int
> irqstatus)
> 
>  	switch (cur_display->type) {
>  	case OMAP_DISPLAY_TYPE_DPI:
> -		if (!(irqstatus & (DISPC_IRQ_VSYNC | DISPC_IRQ_VSYNC2)))
> +		if (mgr_id == OMAP_DSS_CHANNEL_LCD)
> +			irq = DISPC_IRQ_VSYNC;
> +		else if (mgr_id == OMAP_DSS_CHANNEL_LCD2)
> +			irq = DISPC_IRQ_VSYNC2;
> +		else
> +			goto vout_isr_err;
> +
> +		if (!(irqstatus & irq))
>  			goto vout_isr_err;
>  		break;
I understand what this patch meant for, but I am more curious to know
What is value addition of this patch?

if (!(irqstatus & (DISPC_IRQ_VSYNC | DISPC_IRQ_VSYNC2)))

Vs

if (mgr_id == OMAP_DSS_CHANNEL_LCD)
	irq = DISPC_IRQ_VSYNC;
else if (mgr_id == OMAP_DSS_CHANNEL_LCD2)
	irq = DISPC_IRQ_VSYNC2;

Isn't this same, because we are not doing anything separate and special
for VSYNC and VSYNC2?

Thanks,
Vaibhav


>  	case OMAP_DISPLAY_TYPE_VENC:
> --
> 1.7.1

