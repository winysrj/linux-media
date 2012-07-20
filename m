Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:58059 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab2GTH6H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 03:58:07 -0400
Date: Fri, 20 Jul 2012 09:57:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com,
	laurent.pinchart@ideasonboard.com, mchehab@infradead.org
Subject: Re: [PATCH] media: mx2_camera: Add YUYV output format.
In-Reply-To: <CACKLOr2CnQ6Dok_N-KCKMvp5dzSi=OP=WBFAfqaGr17enEkW8A@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1207200955440.27906@axis700.grange>
References: <1342083373-18245-1-git-send-email-javier.martin@vista-silicon.com>
 <CACKLOr2CnQ6Dok_N-KCKMvp5dzSi=OP=WBFAfqaGr17enEkW8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Fri, 20 Jul 2012, javier Martin wrote:

> On 12 July 2012 10:56, Javier Martin <javier.martin@vista-silicon.com> wrote:
> > Add explicit conversions from UYVY and YUYV to YUYV so that
> > csicr1 configuration can be set properly for each format.
> >
> > Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> > ---
> >  drivers/media/video/mx2_camera.c |   40 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 40 insertions(+)
> >
> > diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> > index 0f01e7b..2a33bcb 100644
> > --- a/drivers/media/video/mx2_camera.c
> > +++ b/drivers/media/video/mx2_camera.c
> > @@ -337,6 +337,34 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
> >                 }
> >         },
> >         {
> > +               .in_fmt         = V4L2_MBUS_FMT_UYVY8_2X8,
> > +               .out_fmt        = V4L2_PIX_FMT_YUYV,
> > +               .cfg            = {
> > +                       .channel        = 1,
> > +                       .in_fmt         = PRP_CNTL_DATA_IN_YUV422,
> > +                       .out_fmt        = PRP_CNTL_CH1_OUT_YUV422,
> > +                       .src_pixel      = 0x22000888, /* YUV422 (YUYV) */
> > +                       .ch1_pixel      = 0x62000888, /* YUV422 (YUYV) */
> > +                       .irq_flags      = PRP_INTR_RDERR | PRP_INTR_CH1WERR |
> > +                                               PRP_INTR_CH1FC | PRP_INTR_LBOVF,
> > +                       .csicr1         = CSICR1_SWAP16_EN,
> > +               }
> > +       },
> > +       {
> > +               .in_fmt         = V4L2_MBUS_FMT_YUYV8_2X8,
> > +               .out_fmt        = V4L2_PIX_FMT_YUYV,
> > +               .cfg            = {
> > +                       .channel        = 1,
> > +                       .in_fmt         = PRP_CNTL_DATA_IN_YUV422,
> > +                       .out_fmt        = PRP_CNTL_CH1_OUT_YUV422,
> > +                       .src_pixel      = 0x22000888, /* YUV422 (YUYV) */
> > +                       .ch1_pixel      = 0x62000888, /* YUV422 (YUYV) */
> > +                       .irq_flags      = PRP_INTR_RDERR | PRP_INTR_CH1WERR |
> > +                                               PRP_INTR_CH1FC | PRP_INTR_LBOVF,
> > +                       .csicr1         = CSICR1_PACK_DIR,
> > +               }
> > +       },
> > +       {
> >                 .in_fmt         = V4L2_MBUS_FMT_YUYV8_2X8,
> >                 .out_fmt        = V4L2_PIX_FMT_YUV420,
> >                 .cfg            = {
> > @@ -1146,6 +1174,18 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
> >                 }
> >         }
> >
> > +       if (code == V4L2_MBUS_FMT_UYVY8_2X8) {
> > +               formats++;
> > +               if (xlate) {
> > +                       xlate->host_fmt =
> > +                               soc_mbus_get_fmtdesc(V4L2_MBUS_FMT_YUYV8_2X8);
> > +                       xlate->code     = code;
> > +                       dev_dbg(dev, "Providing host format %s for sensor code %d\n",
> > +                               xlate->host_fmt->name, code);
> > +                       xlate++;
> > +               }
> > +       }
> > +
> >         /* Generic pass-trough */
> >         formats++;
> >         if (xlate) {
> > --
> > 1.7.9.5
> >
> 
> Any comments on this one?

Thanks for the reminder, but in this specific case I haven't 
forgottne:-) I'm processing my v4l patch queue ATM, will have a closer 
look at this and other your patches, will write back if I have any 
objections. I hope I won't - I'm leaving for a week-long holiday tomorrow, 
so, I hope to push my queue today.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
