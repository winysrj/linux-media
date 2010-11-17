Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42757 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934796Ab0KQMhg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 07:37:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/1] videobuf: Initialize lists in videobuf_buffer.
Date: Wed, 17 Nov 2010 13:37:33 +0100
Cc: Andrew Chew <AChew@nvidia.com>,
	"'Figo.zhang'" <zhangtianfei@leadcoretech.com>,
	"pawel@osciak.com" <pawel@osciak.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1289939083-27209-1-git-send-email-achew@nvidia.com> <643E69AA4436674C8F39DCC2C05F763816BB828A40@HQMAIL03.nvidia.com> <201011170811.06697.hverkuil@xs4all.nl>
In-Reply-To: <201011170811.06697.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011171337.35663.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Wednesday 17 November 2010 08:11:06 Hans Verkuil wrote:
> On Wednesday, November 17, 2010 02:38:09 Andrew Chew wrote:
> > > > diff --git a/drivers/media/video/videobuf-dma-contig.c
> > > 
> > > b/drivers/media/video/videobuf-dma-contig.c
> > > 
> > > > index c969111..f7e0f86 100644
> > > > --- a/drivers/media/video/videobuf-dma-contig.c
> > > > +++ b/drivers/media/video/videobuf-dma-contig.c
> > > > @@ -193,6 +193,8 @@ static struct videobuf_buffer
> > > 
> > > *__videobuf_alloc_vb(size_t size)
> > > 
> > > >   	if (vb) {
> > > >   	
> > > >   		mem = vb->priv = ((char *)vb) + size;
> > > >   		mem->magic = MAGIC_DC_MEM;
> > > > 
> > > > +		INIT_LIST_HEAD(&vb->stream);
> > > > +		INIT_LIST_HEAD(&vb->queue);
> > > 
> > > i think it no need to be init, it just a list-entry.
> > 
> > Okay, if that's really the case, then sh_mobile_ceu_camera.c,
> > pxa_camera.c, mx1_camera.c, mx2_camera.c, and omap1_camera.c needs to be
> > fixed to remove that WARN_ON(!list_empty(&vb->queue)); in their
> > videobuf_prepare() methods, because those WARN_ON's are assuming that
> > vb->queue is properly initialized as a list head.
> > 
> > Which will it be?
> 
> These list entries need to be inited. It is bad form to have uninitialized
> list entries. It is not as if this is a big deal to initialize them
> properly.

I disagree with that. List heads must be initialized, but there's no point in 
initializing list entries.

-- 
Regards,

Laurent Pinchart
