Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:57039 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab1IOHPu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 03:15:50 -0400
Date: Thu, 15 Sep 2011 09:14:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Scott Jiang <scott.jiang.linux@gmail.com>
cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
In-Reply-To: <CAHG8p1CDQ-nFwTCXzJBBp76n+16Pz=mDat=dpdNy5N3jjNNvbQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1109150912570.11565@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
 <1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
 <4E6FC8E8.70008@gmail.com> <CAHG8p1C5F_HKX_GPHv_RdCRRNw9s3+ybK4giCjUXxgSUAUDRVw@mail.gmail.com>
 <4E70BA97.1090904@samsung.com> <CAHG8p1D1jnwRO0ie6xrXGL5Uhu+2YjoNdXzhnnBweZDPRyE1fw@mail.gmail.com>
 <Pine.LNX.4.64.1109150826560.11565@axis700.grange>
 <CAHG8p1CDQ-nFwTCXzJBBp76n+16Pz=mDat=dpdNy5N3jjNNvbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 15 Sep 2011, Scott Jiang wrote:

> 2011/9/15 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> > On Thu, 15 Sep 2011, Scott Jiang wrote:
> >
> >> accually this array is to convert mbus to pixformat. ppi supports any formats.
> >
> > You mean, it doesn't distinguish formats? It just packs bytes in RAM
> > exactly as it ready them from the bus, and doesn't support any formats
> > natively, i.e., doesn't offer any data processing?
> >
> yes, ppi means Parallel Peripheral Interface.
> 
> >> Ideally it should contain all formats in v4l2, but it is enough at
> >> present for our platform.
> >> If I find someone needs more, I will add it.
> >> So return -EINVAL means this format is out of range, it can't be supported now.
> >
> > You might consider using
> >
> > drivers/media/video/soc_mediabus.c
> >
> > If your driver were using soc-camera, it could benefit from the
> > dynamically built pixel translation table, see
> >
> > drivers/media/video/soc_camera.c::soc_camera_init_user_formats()
> >
> > and simpler examples like mx1_camera.c or more complex ones like
> > sh_mobile_ceu_camera.c, pxa_camera.c or mx3_camera.c and the use of the
> > soc_camera_xlate_by_fourcc() function in them.
> >
> I have considered using soc, but it can't support decoder when I began
> to write this driver in 2.6.38.

soc_mediabus.c is a stand-alone module, it has no dependencies on 
soc-camera.

Out of interest - what kind of decoder you mean? A tv-decoder? We do have 
a tv-decoder driver tw9910 under soc-camera.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
