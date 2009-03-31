Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55615 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750890AbZCaJXy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 05:23:54 -0400
Date: Tue, 31 Mar 2009 11:23:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Magnus <magnus.damm@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: soc_camera_open crash
In-Reply-To: <uy6umukch.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0903311122180.4806@axis700.grange>
References: <uy6umukch.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 31 Mar 2009, morimoto.kuninori@renesas.com wrote:

> 
> Hi Guennadi
> 
> I tyied to use latest Linux 2.6.29 from Paul's git
>  git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git
> 
> soc_camera doesn't work on it.
> And I found the reason.
> 
> -------------
> static int soc_camera_open(struct file *file)
> {
>    ...
> 	if (icd->use_count == 1) {
> 		/* Restore parameters before the last close() per V4L2 API */
> 		struct v4l2_format f = {
> 			.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> 			.fmt.pix = {
> 				.width		= icd->width,
> 				.height		= icd->height,
> 				.field		= icd->field,
> =>				.pixelformat	= icd->current_fmt->fourcc,
> =>				.colorspace	= icd->current_fmt->colorspace,
> 			},
> 		};
> ...
> 		ret = soc_camera_set_fmt(icf, &f);
> ------------- 
> 
> now, icd->current_fmt seems NULL.
> So, I can not call soc_camera_set_fmt.

Strange, it should not be NULL, it should be initialised in 
soc_camera_init_user_formats() during probing. Could you verify whether it 
gets initialised there?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
