Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:64297 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1CKQvQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 11:51:16 -0500
Date: Fri, 11 Mar 2011 17:51:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergio Aguirre <saaguirre@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"pawel@osciak.com" <pawel@osciak.com>
Subject: Re: [PATCH] V4L: soc-camera: Add support for custom host mmap
In-Reply-To: <4D762C9F.1010707@ti.com>
Message-ID: <Pine.LNX.4.64.1103111748270.26572@axis700.grange>
References: <1299545691-917-1-git-send-email-saaguirre@ti.com>
 <Pine.LNX.4.64.1103080809120.3903@axis700.grange> <4D762C9F.1010707@ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 8 Mar 2011, Sergio Aguirre wrote:

> Hi Guennadi,
> 
> On 03/08/2011 01:17 AM, Guennadi Liakhovetski wrote:
> > Hi Sergio
> > 
> > On Mon, 7 Mar 2011, Sergio Aguirre wrote:
> > 
> > > This helps redirect mmap calls to custom memory managers which
> > > already have preallocated space to use by the device.
> > > 
> > > Otherwise, device might not support the allocation attempted
> > > generically by videobuf.
> > > 
> > > Signed-off-by: Sergio Aguirre<saaguirre@ti.com>
> > > ---
> > >   drivers/media/video/soc_camera.c |    7 ++++++-
> > >   include/media/soc_camera.h       |    2 ++
> > >   2 files changed, 8 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/soc_camera.c
> > > b/drivers/media/video/soc_camera.c
> > > index 59dc71d..d361ba0 100644
> > > --- a/drivers/media/video/soc_camera.c
> > > +++ b/drivers/media/video/soc_camera.c

[snip]

> > > +	if (ici->ops->mmap)
> > > +		err = ici->ops->mmap(&icd->vb_vidq, icd, vma);
> > > +	else
> > > +		err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
> > 
> > You're patching an old version of soc-camera. Please use a current one
> > with support for videobuf2. Further, wouldn't it be possible for you to
> > just replace the videobuf mmap_mapper() (videobuf2 q->mem_ops->mmap())
> > method? I am not sure how possible this is, maybe one of videobuf2 experts
> > could help us? BTW, you really should be using the videobuf2 API.

I looked a bit more at videobuf2. Wouldn't it satisfy your needs if you 
just provide an own struct vb2_mem_ops, copy all its fields from your 
required memory allocator, and only replace the .mmap method? Please, try, 
if this would work for you. Then you won't need any changes to 
soc_camera.c

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
