Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51094 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab1LWL25 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Dec 2011 06:28:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: MEM2MEM devices: how to handle sequence number?
Date: Fri, 23 Dec 2011 12:28:44 +0100
Cc: "'javier Martin'" <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	shawn.guo@linaro.org, richard.zhao@linaro.org,
	fabio.estevam@freescale.com, kernel@pengutronix.de,
	s.hauer@pengutronix.de, r.schwebel@pengutronix.de,
	"'Pawel Osciak'" <p.osciak@gmail.com>
References: <CACKLOr0H4enuADtWcUkZCS_V92mmLD8K5CgScbGo7w9nbT=-CA@mail.gmail.com> <013f01ccc141$cdf78ed0$69e6ac70$%szyprowski@samsung.com>
In-Reply-To: <013f01ccc141$cdf78ed0$69e6ac70$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112231228.45439.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

On Friday 23 December 2011 08:09:25 Marek Szyprowski wrote:
> On Thursday, December 22, 2011 3:34 PM Javier Martin wrote:
> > we have a processing chain composed of three v4l2 devices:
> > 
> > ---------------------           -----------------------
> > ----------------------
> > 
> > | v4l2 source  |            |     v4l2 fixer   |               |  v4l2
> > | encoder |
> > | 
> > |  (capture)     |---------->|  (mem2mem)| ------------>|  (mem2mem) |
> > 
> > ------------>
> > 
> > |___________|            |____________|              |____________|
> > 
> > "v4l2 source" generates consecutive sequence numbers so that we can
> > detect whether a frame has been lost or not.
> > "v4l2 fixer" and "v4l2 encoder" cannot lose frames because they don't
> > interact with an external sensor.
> > 
> > How should "v4l2 fixer" and "v4l2 encoder" behave regarding frame
> > sequence number? Should they just copy the sequence number from the
> > input buffer to the output buffer or should they maintain their own
> > count for the CAPTURE queue?
> 
> IMHO mem2mem devices, which process buffers in 1:1 way (there is always
> exactly one 'capture'/destination buffer for every 'output'/source buffer)
> can simply copy the sequence number from the source buffer to the
> destination.
> 
> If there is no such 1:1 mapping between the buffers, drivers should
> maintain their own numbers. video encoder is probably an example of such
> device. A single destination ('capture') buffer with encoded video data
> might contain a fraction, one or more source ('output') video
> buffers/frames.
> 
> > If the former option is chosen we should apply a patch like the
> > following so that the sequence number of the input buffer is passed to
> > the videobuf2 layer:
> > 
> > diff --git a/drivers/media/video/videobuf2-core.c
> > b/drivers/media/video/videobuf2-core.c
> > index 1250662..7d8a88b 100644
> > --- a/drivers/media/video/videobuf2-core.c
> > +++ b/drivers/media/video/videobuf2-core.c
> > @@ -1127,6 +1127,7 @@ int vb2_qbuf(struct vb2_queue *q, struct
> > v4l2_buffer *b)
> >          */
> >         list_add_tail(&vb->queued_entry, &q->queued_list);
> >         vb->state = VB2_BUF_STATE_QUEUED;
> > +       vb->v4l2_buf.sequence = b->sequence;
> >         /*
> >          * If already streaming, give the buffer to driver for
> >          processing.
> 
> Right, such patch is definitely needed. Please resend it with
> 'signed-off-by' annotation.

I'm not too sure about that. Isn't the sequence number supposed to be ignored 
by drivers on video output devices ? The documentation is a bit terse on the 
subject, all it says is

__u32  sequence     Set by the driver, counting the frames in the sequence.

-- 
Regards,

Laurent Pinchart
