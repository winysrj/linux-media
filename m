Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:53297 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab1IOHce (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 03:32:34 -0400
Date: Thu, 15 Sep 2011 09:32:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Scott Jiang <scott.jiang.linux@gmail.com>
cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
In-Reply-To: <CAHG8p1D+NskH5cLT3t9QrtQNGdRH3xj23aiSxDsCGO4r0O7sAQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1109150930070.11565@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
 <1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
 <4E6FC8E8.70008@gmail.com> <CAHG8p1C5F_HKX_GPHv_RdCRRNw9s3+ybK4giCjUXxgSUAUDRVw@mail.gmail.com>
 <4E70BA97.1090904@samsung.com> <CAHG8p1D1jnwRO0ie6xrXGL5Uhu+2YjoNdXzhnnBweZDPRyE1fw@mail.gmail.com>
 <Pine.LNX.4.64.1109150826560.11565@axis700.grange>
 <CAHG8p1CDQ-nFwTCXzJBBp76n+16Pz=mDat=dpdNy5N3jjNNvbQ@mail.gmail.com>
 <Pine.LNX.4.64.1109150912570.11565@axis700.grange>
 <CAHG8p1D+NskH5cLT3t9QrtQNGdRH3xj23aiSxDsCGO4r0O7sAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 15 Sep 2011, Scott Jiang wrote:

> >> I have considered using soc, but it can't support decoder when I began
> >> to write this driver in 2.6.38.
> >
> > soc_mediabus.c is a stand-alone module, it has no dependencies on
> > soc-camera.
> >
> > Out of interest - what kind of decoder you mean? A tv-decoder? We do have
> > a tv-decoder driver tw9910 under soc-camera.
> >
> static int soc_camera_s_input(struct file *file, void *priv, unsigned int i)
> {
>      if (i > 0)
>         return -EINVAL;
> 
>     return 0;
> }
> I don't think most of tv-decoders only support one input.

Ah:-) soc-camera is a living project, it's not set in stone. Until now we 
didn't have any need for more than one input, but as soon as such a need 
would arise, this would be changed in no time.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
