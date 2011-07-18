Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52617 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab1GRSLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 14:11:40 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p6IIBbOj020485
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 18 Jul 2011 13:11:39 -0500
Received: from dbde71.ent.ti.com (localhost [127.0.0.1])
	by dbdp20.itg.ti.com (8.13.8/8.13.8) with ESMTP id p6IIBasb024123
	for <linux-media@vger.kernel.org>; Mon, 18 Jul 2011 23:41:36 +0530 (IST)
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "JAIN, AMBER" <amber@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 18 Jul 2011 23:41:36 +0530
Subject: RE: [PATCH v2 1/3] V4L2: OMAP: VOUT: isr handling extended for DPI
 and HDMI interface
Message-ID: <19F8576C6E063C45BE387C64729E739404E3737BA6@dbde02.ent.ti.com>
References: <1310041278-8810-1-git-send-email-amber@ti.com>
 <1310041278-8810-2-git-send-email-amber@ti.com>
In-Reply-To: <1310041278-8810-2-git-send-email-amber@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: JAIN, AMBER
> Sent: Thursday, July 07, 2011 5:51 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav; JAIN, AMBER
> Subject: [PATCH v2 1/3] V4L2: OMAP: VOUT: isr handling extended for DPI
> and HDMI interface
> 
> Extending the omap vout isr handling for:
> - secondary lcd over DPI interface,
> - HDMI interface.
> 
> These are the new interfaces added to OMAP4 DSS.
> 
> Signed-off-by: Amber Jain <amber@ti.com>
> ---
> Changes from v1:
> - updated commit message to mention that these changes are specifically
>   for OMAP4.
> 
>  drivers/media/video/omap/omap_vout.c |   26 +++++++++++++++++++-------
>  1 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index 343b50c..6cd3622 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -546,10 +546,20 @@ static void omap_vout_isr(void *arg, unsigned int
> irqstatus)
> 
>  	spin_lock(&vout->vbq_lock);
>  	do_gettimeofday(&timevalue);
> -	if (cur_display->type == OMAP_DISPLAY_TYPE_DPI) {
> -		if (!(irqstatus & DISPC_IRQ_VSYNC))
> -			goto vout_isr_err;
> 
> +	if (cur_display->type != OMAP_DISPLAY_TYPE_VENC) {
> +		switch (cur_display->type) {
> +		case OMAP_DISPLAY_TYPE_DPI:
> +			if (!(irqstatus & (DISPC_IRQ_VSYNC | DISPC_IRQ_VSYNC2)))
> +				goto vout_isr_err;
> +			break;
> +		case OMAP_DISPLAY_TYPE_HDMI:
> +			if (!(irqstatus & DISPC_IRQ_EVSYNC_EVEN))
> +				goto vout_isr_err;
> +			break;
> +		default:
> +			goto vout_isr_err;
> +		}
>  		if (!vout->first_int && (vout->cur_frm != vout->next_frm)) {
>  			vout->cur_frm->ts = timevalue;
>  			vout->cur_frm->state = VIDEOBUF_DONE;
> @@ -573,7 +583,7 @@ static void omap_vout_isr(void *arg, unsigned int
> irqstatus)
>  		ret = omapvid_init(vout, addr);
>  		if (ret)
>  			printk(KERN_ERR VOUT_NAME
> -					"failed to set overlay info\n");
> +				"failed to set overlay info\n");
>  		/* Enable the pipeline and set the Go bit */
>  		ret = omapvid_apply_changes(vout);
>  		if (ret)
> @@ -943,7 +953,7 @@ static int omap_vout_release(struct file *file)
>  		u32 mask = 0;
> 
>  		mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
> -			DISPC_IRQ_EVSYNC_ODD;
> +			DISPC_IRQ_EVSYNC_ODD | DISPC_IRQ_VSYNC2;
>  		omap_dispc_unregister_isr(omap_vout_isr, vout, mask);
>  		vout->streaming = 0;
> 
> @@ -1614,7 +1624,8 @@ static int vidioc_streamon(struct file *file, void
> *fh, enum v4l2_buf_type i)
>  	addr = (unsigned long) vout->queued_buf_addr[vout->cur_frm->i]
>  		+ vout->cropped_offset;
> 
> -	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
> DISPC_IRQ_EVSYNC_ODD;
> +	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
> DISPC_IRQ_EVSYNC_ODD
> +		| DISPC_IRQ_VSYNC2;
> 
>  	omap_dispc_register_isr(omap_vout_isr, vout, mask);
> 
> @@ -1664,7 +1675,8 @@ static int vidioc_streamoff(struct file *file, void
> *fh, enum v4l2_buf_type i)
>  		return -EINVAL;
> 
>  	vout->streaming = 0;
> -	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
> DISPC_IRQ_EVSYNC_ODD;
> +	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
> DISPC_IRQ_EVSYNC_ODD
> +		| DISPC_IRQ_VSYNC2;
> 
>  	omap_dispc_unregister_isr(omap_vout_isr, vout, mask);
> 
[Hiremath, Vaibhav] Acked-By: Vaibhav Hiremath <hvaibhav@ti.com>


Thanks,
Vaibhav

> --
> 1.7.1

