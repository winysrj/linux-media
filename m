Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48795 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab1DEMmF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 08:42:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC 2/4 v2] V4L: add videobuf2 helper functions to support multi-size video-buffers
Date: Tue, 5 Apr 2011 14:42:38 +0200
Cc: Pawel Osciak <pawel@osciak.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <BANLkTikdwRMp4n_wsSu7Gnm4qXYboDGY6Q@mail.gmail.com> <Pine.LNX.4.64.1104040945130.4668@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1104040945130.4668@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104051442.38669.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 04 April 2011 09:55:17 Guennadi Liakhovetski wrote:
> On Sun, 3 Apr 2011, Pawel Osciak wrote:
> > On Fri, Apr 1, 2011 at 07:06, Guennadi Liakhovetski wrote:
> > > This patch extends the videobuf2 framework with new helper functions
> > > and modifies existing ones to support multi-size video-buffers.

[snip]

> > > diff --git a/drivers/media/video/videobuf2-core.c
> > > b/drivers/media/video/videobuf2-core.c index 71734a4..20e1572 100644
> > > --- a/drivers/media/video/videobuf2-core.c
> > > +++ b/drivers/media/video/videobuf2-core.c

[snip]

> > > @@ -241,16 +250,36 @@ static void __vb2_queue_free(struct vb2_queue *q)
> > >        }
> > > 
> > >        /* Release video buffer memory */
> > > -       __vb2_free_mem(q);
> > > +       __vb2_free_mem(q, span);
> > > 
> > >        /* Free videobuf buffers */
> > > -       for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> > > +       for (buffer = span->index;
> > > +            buffer < span->index + span->count; ++buffer) {
> > >                kfree(q->bufs[buffer]);
> > >                q->bufs[buffer] = NULL;
> > >        }
> > > 
> > > -       q->num_buffers = 0;
> > > -       q->memory = 0;
> > > +       q->num_buffers -= span->count;
> > > +       if (!q->num_buffers)
> > > +               q->memory = 0;
> > > +
> > > +       return 0;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vb2_destroy_bufs);
> > > +
> > 
> > This messes up q->num_buffers, which is used in other places as the
> > upper bound for indexes and assumes <0; q->num_buffers> is contiguous.
> > Examples include querybufs, buffers_in_use. In general, I find it
> > unnecessary complicated and dangerous to allow introducing "holes" in
> > buffer indexes.
> 
> Yes, there are issues... I think, we can just return -EBUSY on such
> fragmenting DESTROY calls. Anything left over will be freed on last
> close() anyway. Let's decide how we want to handle these and I'll prepare
> a v2, probably with documentation this time:-)

I also feel a bit uneasy about introducing holes in buffer indexes. Do we have 
use cases for that right now ?

-- 
Regards,

Laurent Pinchart
