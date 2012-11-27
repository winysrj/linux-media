Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:52661 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095Ab2K0QuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 11:50:05 -0500
Date: Tue, 27 Nov 2012 17:50:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: "corbet@lwn.net" <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Subject: RE: [PATCH 11/15] [media] marvell-ccic: add soc_camera support in
 mcam core
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D1367C90C@SC-VEXCH1.marvell.com>
Message-ID: <Pine.LNX.4.64.1211271740410.22273@axis700.grange>
References: <1353677659-24324-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271516010.22273@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D1367C90C@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 27 Nov 2012, Albert Wang wrote:

[snip]

> >> +static int mcam_camera_set_fmt(struct soc_camera_device *icd,
> >> +                    struct v4l2_format *f)
> >> +{
> >> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> >> +    struct mcam_camera *mcam = ici->priv;
> >> +    const struct soc_camera_format_xlate *xlate = NULL;
> >> +    struct v4l2_mbus_framefmt mf;
> >> +    struct v4l2_pix_format *pix = &f->fmt.pix;
> >> +    int ret = 0;
> >
> >No need to initialise ret.
> >
> Yes, but it looks there is no "bad" impact if we initialize it. :)
> I just want to keep the rule: initialize it before use it. :)

No, please, don't. Firstly, it adds bloat. Secondly, such "blind" 
initialisation can hide real bugs: the variable is initialised, so the 
compiler doesn't complain, then you use it in your code, but in reality, 
the value, that you used is meaningless in your context and you get a 
hidden bug.

[snip]

> >> +static int mcam_camera_try_fmt(struct soc_camera_device *icd,
> >> +                    struct v4l2_format *f)
> >> +{
> >> +    struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> >> +    struct mcam_camera *mcam = ici->priv;
> >> +    const struct soc_camera_format_xlate *xlate;
> >> +    struct v4l2_pix_format *pix = &f->fmt.pix;
> >> +    struct v4l2_mbus_framefmt mf;
> >> +    __u32 pixfmt = pix->pixelformat;
> >> +    int ret = 0;
> >
> >No need to initialise ret.
> >
> >> +
> >> +    xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> >> +    if (!xlate) {
> >> +            cam_err(mcam, "camera: format: %c not found\n",
> >> +                    pix->pixelformat);
> >> +            return -EINVAL;
> >
> >You shouldn't fail .try_fmt() (unless something really bad happens). Just
> >pick up a default supported format.
> >
> Do you means we just need pick up the default supported format when try_fmt()?

If you don't find the requested format - yes, just pick up any format, that 
you can support.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
