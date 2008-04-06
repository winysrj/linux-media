Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m36MUJiC028408
	for <video4linux-list@redhat.com>; Sun, 6 Apr 2008 18:30:19 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m36MU712028754
	for <video4linux-list@redhat.com>; Sun, 6 Apr 2008 18:30:07 -0400
Date: Mon, 7 Apr 2008 00:30:05 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Mike Rapoport <mike@compulab.co.il>
In-Reply-To: <47F872DE.60004@compulab.co.il>
Message-ID: <Pine.LNX.4.64.0804070008220.5129@axis700.grange>
References: <47F21593.7080507@compulab.co.il>
	<Pine.LNX.4.64.0804031708470.18539@axis700.grange>
	<47F872DE.60004@compulab.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] pxa_camera: Add support for YUV modes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sun, 6 Apr 2008, Mike Rapoport wrote:

> >> +		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
> >> +			ret = pxa_init_dma_channel(pcdev, buf, dma, 1, sglen_y,
> > 
> > This should be sglen_u							^^^^^
> 
> Right. No wonder I had colors distorted :)

Now you get them right?

The patch looks good to me now, just please regenerate it in the "-p1" 
format. Also, I'm not quite sure why you don't have blanks in unchenged 
lines like, normally one sees (space replaced with "*")

<hunk>
@@ -145,6 +171,7 @@ static void free_buffer(struct videobuf_
*		to_soc_camera_host(icd->dev.parent);
*	struct pxa_camera_dev *pcdev = ici->priv;
*	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
+	int i;
*
*	BUG_ON(in_interrupt());
*
</hunk>

whereas you have everywhere just blank lines:

<hunk>
@@ -145,6 +171,7 @@ static void free_buffer(struct videobuf_
*		to_soc_camera_host(icd->dev.parent);
*	struct pxa_camera_dev *pcdev = ici->priv;
*	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
+	int i;

*	BUG_ON(in_interrupt());

</hunk>

It wasn't a problem for my version of GNU patch, don't know if this can be 
a problem for git or whatever else the person applying your patch (Mauro?) 
will be using. Maybe would be better to fix this as you resend in "-p1" 
too. Hm, I think, on V4L they do use "-p2" for mercurial, so, this might 
not be a problem then.

In any case here's my

> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Just one more request:

> diff --git a/linux/drivers/media/video/pxa_camera.c b/linux/drivers/media/video/pxa_camera.c
> --- a/linux/drivers/media/video/pxa_camera.c
> +++ b/linux/drivers/media/video/pxa_camera.c
> @@ -49,6 +49,9 @@
> 
>  #define CICR1_DW_VAL(x)   ((x) & CICR1_DW)	    /* Data bus width */
>  #define CICR1_PPL_VAL(x)  (((x) << 15) & CICR1_PPL) /* Pixels per line */
> +#define CICR1_COLOR_SP_VAL(x)	(((x) << 3) & CICR1_COLOR_SP)	/* color space */
> +#define CICR1_RGB_BPP_VAL(x)	(((x) << 7) & CICR1_RGB_BPP)	/* bpp for rgb */
> +#define CICR1_RGBT_CONV_VAL(x)	(((x) << 29) & CICR1_RGBT_CONV)	/* rgbt conv */

There's a typo in include/asm-arm/arch-pxa/pxa-regs.h:

#define CICR1_RGBT_CONV	(0x3 << 30)	/* RGBT conversion mask */

30 should be 29, you have it right. Could you please submit a patch to ARM 
kernel to fix this?

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
