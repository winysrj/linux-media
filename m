Return-path: <mchehab@localhost>
Received: from comal.ext.ti.com ([198.47.26.152]:44773 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1GESrA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 14:47:00 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p65Ikuhr027298
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 5 Jul 2011 13:46:59 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "JAIN, AMBER" <amber@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Wed, 6 Jul 2011 00:16:54 +0530
Subject: RE: [PATCH 1/6] V4L2: OMAP: VOUT: isr handling extended for DPI and
 HDMI interface
Message-ID: <19F8576C6E063C45BE387C64729E739404E3485E6B@dbde02.ent.ti.com>
References: <1307458058-29030-1-git-send-email-amber@ti.com>
 <1307458058-29030-2-git-send-email-amber@ti.com>
In-Reply-To: <1307458058-29030-2-git-send-email-amber@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>


> -----Original Message-----
> From: JAIN, AMBER
> Sent: Tuesday, June 07, 2011 8:18 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav; Semwal, Sumit; JAIN, AMBER
> Subject: [PATCH 1/6] V4L2: OMAP: VOUT: isr handling extended for DPI and
> HDMI interface
[Hiremath, Vaibhav] Few minor comments below -

> 
> Extending the omap vout isr handling for:
> - secondary lcd over DPI interface,
> - HDMI interface.
> 
[Hiremath, Vaibhav] It would be useful to mention about OMAP4 DSS block (these are new additions compared to OAMP3), that's where both the interfaces are getting used, right?

> Signed-off-by: Amber Jain <amber@ti.com>
> ---
>  drivers/media/video/omap/omap_vout.c |   26 +++++++++++++++++++-------
>  1 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index a831241..6fe7efa 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -544,10 +544,20 @@ void omap_vout_isr(void *arg, unsigned int
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
[Hiremath, Vaibhav] how about implementing this like,


if (cur_display->type != OMAP_DISPLAY_TYPE_VENC) {
	unsigned int status;

	switch (cur_display->type) {
	case OMAP_DISPLAY_TYPE_DPI:
		status = DISPC_IRQ_VSYNC | DISPC_IRQ_VSYNC2;
		break;
	case OMAP_DISPLAY_TYPE_HDMI:
		status = DISPC_IRQ_EVSYNC_EVEN;
		break;
	default:
		goto vout_isr_err;
	}
	If (!(irqstatus & status))
		goto vout_isr_err;


Thanks,
Vaibhav

>  		if (!vout->first_int && (vout->cur_frm != vout->next_frm)) {
>  			vout->cur_frm->ts = timevalue;
>  			vout->cur_frm->state = VIDEOBUF_DONE;
> @@ -571,7 +581,7 @@ void omap_vout_isr(void *arg, unsigned int irqstatus)
>  		ret = omapvid_init(vout, addr);
>  		if (ret)
>  			printk(KERN_ERR VOUT_NAME
> -					"failed to set overlay info\n");
> +		[Hiremath, Vaibhav] 			"failed to set overlay info\n");
>  		/* Enable the pipeline and set the Go bit */
>  		ret = omapvid_apply_changes(vout);
>  		if (ret)
> @@ -925,7 +935,7 @@ static int omap_vout_release(struct file *file)
>  		u32 mask = 0;
> 
>  		mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
> -			DISPC_IRQ_EVSYNC_ODD;
> +			DISPC_IRQ_EVSYNC_ODD | DISPC_IRQ_VSYNC2;
>  		omap_dispc_unregister_isr(omap_vout_isr, vout, mask);
>  		vout->streaming = 0;
> 
> @@ -1596,7 +1606,8 @@ static int vidioc_streamon(struct file *file, void
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
> @@ -1646,7 +1657,8 @@ static int vidioc_streamoff(struct file *file, void
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
> --
> 1.7.1

