Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34369 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3EVLAL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 May 2013 07:00:11 -0400
Message-ID: <1369220358.4426.10.camel@pizza.hi.pengutronix.de>
Subject: Re: [RFC] [media] mem2mem: add support for hardware buffered queue
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>, John Sheu <sheu@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Date: Wed, 22 May 2013 12:59:18 +0200
In-Reply-To: <201305221236.48467.hverkuil@xs4all.nl>
References: <1369217856-10385-1-git-send-email-p.zabel@pengutronix.de>
	 <201305221236.48467.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 22.05.2013, 12:36 +0200 schrieb Hans Verkuil:
> On Wed 22 May 2013 12:17:36 Philipp Zabel wrote:
> > On mem2mem decoders with a hardware bitstream ringbuffer, to drain the
> > buffer at the end of the stream, remaining frames might need to be decoded
> > without additional input buffers being provided, and after calling streamoff
> > on the v4l2 output queue. This also allows a driver to copy input buffers
> > into their bitstream ringbuffer and immediately mark them as done to be
> > dequeued.
> > 
> > The motivation for this patch is hardware assisted h.264 reordering support
> > in the coda driver. For high profile streams, the coda can hold back
> > out-of-order frames, causing a few mem2mem device runs in the beginning, that
> > don't produce any decompressed buffer at the v4l2 capture side. At the same
> > time, the last few frames can be decoded from the bitstream with mem2mem device
> > runs that don't need a new input buffer at the v4l2 output side. A streamoff
> > on the v4l2 output side can be used to put the decoder into the ringbuffer
> > draining end-of-stream mode.
> 
> This is just a pointer to a related issue: how to signal to the application
> that the end-of-stream has been reached:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg60916.html

Thank you for the pointer, this is exactly

> How does the coda driver handle eos signalling?

It does not, yet. The patches I'm currently preparing are still just
calling v4l2_event_queue_fh before v4l2_m2m_job_finish from the
interrupt handler after the device run signals that there is no more
data, but I think this needs to be done with the DQBUF instead.

I like the idea of an EOS buffer flag for the capture side.

regards
Philipp

