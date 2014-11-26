Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53774 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaKZTrj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 14:47:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Osciak <pawel@osciak.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv7 PATCH 01/12] videobuf2-core.h: improve documentation
Date: Wed, 26 Nov 2014 21:48:04 +0200
Message-ID: <1849257.LYuFVs0uYE@avalon>
In-Reply-To: <CAMm-=zADQpwW8+A24vWo0hAS+h=5eqGVsKQfn4ApEiL5czxSgA@mail.gmail.com>
References: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl> <1416315068-22936-2-git-send-email-hverkuil@xs4all.nl> <CAMm-=zADQpwW8+A24vWo0hAS+h=5eqGVsKQfn4ApEiL5czxSgA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Sunday 23 November 2014 20:01:22 Pawel Osciak wrote:
> On Tue, Nov 18, 2014 at 9:50 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Document that drivers can access/modify the buffer contents in buf_prepare
> > and buf_finish. That was not clearly stated before.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Acked-by: Pawel Osciak <pawel@osciak.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> 
> > ---
> > 
> >  include/media/videobuf2-core.h | 32 +++++++++++++++++---------------
> >  1 file changed, 17 insertions(+), 15 deletions(-)
> > 
> > diff --git a/include/media/videobuf2-core.h
> > b/include/media/videobuf2-core.h index 6ef2d01..70ace7c 100644
> > --- a/include/media/videobuf2-core.h
> > +++ b/include/media/videobuf2-core.h
> > @@ -270,22 +270,24 @@ struct vb2_buffer {
> > 
> >   *                     queue setup from completing successfully;
> >   optional.
> >   * @buf_prepare:       called every time the buffer is queued from
> >   userspace
> >   *                     and from the VIDIOC_PREPARE_BUF ioctl; drivers may
> > 
> > - *                     perform any initialization required before each
> > hardware - *                     operation in this callback; drivers that
> > support - *                     VIDIOC_CREATE_BUFS must also validate the
> > buffer size; - *                     if an error is returned, the buffer
> > will not be queued - *                     in driver; optional.
> > + *                     perform any initialization required before each
> > + *                     hardware operation in this callback; drivers can
> > + *                     access/modify the buffer here as it is still
> > synced for + *                     the CPU; drivers that support
> > VIDIOC_CREATE_BUFS must + *                     also validate the buffer
> > size; if an error is returned, + *                     the buffer will
> > not be queued in driver; optional.> 
> >   * @buf_finish:                called before every dequeue of the buffer
> >   back to> 
> > - *                     userspace; drivers may perform any operations
> > required - *                     before userspace accesses the buffer;
> > optional. The - *                     buffer state can be one of the
> > following: DONE and - *                     ERROR occur while streaming
> > is in progress, and the - *                     PREPARED state occurs
> > when the queue has been canceled - *                     and all pending
> > buffers are being returned to their - *                     default
> > DEQUEUED state. Typically you only have to do - *                    
> > something if the state is VB2_BUF_STATE_DONE, since in - *               
> >      all other cases the buffer contents will be ignored - *             
> >        anyway.
> > + *                     userspace; the buffer is synced for the CPU, so
> > drivers + *                     can access/modify the buffer contents;
> > drivers may + *                     perform any operations required
> > before userspace + *                     accesses the buffer; optional.
> > The buffer state can be + *                     one of the following:
> > DONE and ERROR occur while + *                     streaming is in
> > progress, and the PREPARED state occurs + *                     when the
> > queue has been canceled and all pending + *                     buffers
> > are being returned to their default DEQUEUED + *                    
> > state. Typically you only have to do something if the + *                
> >     state is VB2_BUF_STATE_DONE, since in all other cases + *            
> >         the buffer contents will be ignored anyway.> 
> >   * @buf_cleanup:       called once before the buffer is freed; drivers
> >   may
> >   *                     perform any additional cleanup; optional.
> >   * @start_streaming:   called once to enter 'streaming' state; the driver
> >   may> 
> > --
> > 2.1.1

-- 
Regards,

Laurent Pinchart

