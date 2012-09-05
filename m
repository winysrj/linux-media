Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53299 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2IEI31 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 04:29:27 -0400
Date: Wed, 5 Sep 2012 10:29:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com,
	laurent.pinchart@ideasonboard.com, mchehab@infradead.org
Subject: Re: [PATCH v3] media: mx2_camera: Don't modify non volatile parameters
 in try_fmt.
In-Reply-To: <Pine.LNX.4.64.1209051016360.16676@axis700.grange>
Message-ID: <Pine.LNX.4.64.1209051028380.16676@axis700.grange>
References: <1345456164-12995-1-git-send-email-javier.martin@vista-silicon.com>
 <CACKLOr1HLSvvz8Bs_qgHuF1qjshwnsXqtcuS3q5uWmGhTkpxkg@mail.gmail.com>
 <Pine.LNX.4.64.1209051016360.16676@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 5 Sep 2012, Guennadi Liakhovetski wrote:

> Hi Javier
> 
> On Mon, 3 Sep 2012, javier Martin wrote:
> 
> > Hi,
> > Guennadi,did you pick this one?
> 
> Wanted to do so, but

I've applied this your patch with only that "memset()" line additionally 
removed. If this is ok with you, no need to re-send.

Thanks
Guennadi

> > Regards.
> > 
> > On 20 August 2012 11:49, Javier Martin <javier.martin@vista-silicon.com> wrote:
> > > Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> > > ---
> > > Changes since v2:
> > >  - Add Signed-off-by line.
> > >
> > > ---
> > >  drivers/media/video/mx2_camera.c |    5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> > > index 2a33bcb..88dcae6 100644
> > > --- a/drivers/media/video/mx2_camera.c
> > > +++ b/drivers/media/video/mx2_camera.c
> > > @@ -1385,6 +1385,7 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
> > >         __u32 pixfmt = pix->pixelformat;
> > >         struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> > >         struct mx2_camera_dev *pcdev = ici->priv;
> > > +       struct mx2_fmt_cfg *emma_prp;
> > >         unsigned int width_limit;
> > >         int ret;
> > >
> > > @@ -1447,12 +1448,12 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
> > >                 __func__, pcdev->s_width, pcdev->s_height);
> > >
> > >         /* If the sensor does not support image size try PrP resizing */
> > > -       pcdev->emma_prp = mx27_emma_prp_get_format(xlate->code,
> > > +       emma_prp = mx27_emma_prp_get_format(xlate->code,
> > >                                                    xlate->host_fmt->fourcc);
> > >
> > >         memset(pcdev->resizing, 0, sizeof(pcdev->resizing));
> 
> Doesn't the above line also have to be removed?
> 
> Thanks
> Guennadi
> 
> > >         if ((mf.width != pix->width || mf.height != pix->height) &&
> > > -               pcdev->emma_prp->cfg.in_fmt == PRP_CNTL_DATA_IN_YUV422) {
> > > +               emma_prp->cfg.in_fmt == PRP_CNTL_DATA_IN_YUV422) {
> > >                 if (mx2_emmaprp_resize(pcdev, &mf, pix, false) < 0)
> > >                         dev_dbg(icd->parent, "%s: can't resize\n", __func__);
> > >         }
> > > --
> > > 1.7.9.5
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
