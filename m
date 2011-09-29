Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:51536 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1I2L3U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 07:29:20 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Taneja, Archit" <archit@ti.com>
CC: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Semwal, Sumit" <sumit.semwal@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 29 Sep 2011 16:59:12 +0530
Subject: RE: [PATCH v4 3/5] OMAP_VOUT: Fix VSYNC IRQ handling in
 omap_vout_isr
Message-ID: <19F8576C6E063C45BE387C64729E739404ECA5512C@dbde02.ent.ti.com>
References: <1317221368-3301-1-git-send-email-archit@ti.com>
 <1317221368-3301-4-git-send-email-archit@ti.com>
In-Reply-To: <1317221368-3301-4-git-send-email-archit@ti.com>
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
> Subject: [PATCH v4 3/5] OMAP_VOUT: Fix VSYNC IRQ handling in omap_vout_isr
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
> index 247ea31..6bc2620 100644
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
>  	case OMAP_DISPLAY_TYPE_VENC:

Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>

Thanks,
Vaibhav

> --
> 1.7.1

