Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40981 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab3EaJ3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 05:29:55 -0400
Message-ID: <1369992590.4951.9.camel@pizza.hi.pengutronix.de>
Subject: Re: [RFC PATCH v3] [media] mem2mem: add support for hardware
 buffered queue
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>, John Sheu <sheu@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Date: Fri, 31 May 2013 11:29:50 +0200
In-Reply-To: <51A864C5.4090703@samsung.com>
References: <1369989199-20952-1-git-send-email-p.zabel@pengutronix.de>
	 <51A864C5.4090703@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Am Freitag, den 31.05.2013, 10:52 +0200 schrieb Sylwester Nawrocki:
> Hi Philipp,
> 
> On 05/31/2013 10:33 AM, Philipp Zabel wrote:
> > +void v4l2_m2m_queue_set_buffered(struct vb2_queue *vq, bool buffered)
> 
> How about making it a 'static inline' function in include/media/v4l2-mem2mem.h
> instead ?

Thanks, I'll change this.

> > +{
> > +	struct v4l2_m2m_queue_ctx *q_ctx = container_of(vq, struct v4l2_m2m_queue_ctx, q);
> > +
> > +	q_ctx->buffered = buffered;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_m2m_queue_set_buffered);
> 
> 
> Also, I was wondering how do you handle now in the coda driver a situation
> when, e.g. during normal stream decoding more than one buffer is produced
> by the decoder from one compressed data buffer on its input side ?

I didn't properly test it yet. In principle it should just work because
the compressed OUTPUT source buffer is always copied into the internal
bitstream ringbuffer, and then device_run can be scheduled multiple
times as long as there is enough bitstream data available, each run
producing a single CAPTURE destination buffer.

But I'm counting input buffers to send the EOS signal with the last
CAPTURE buffer DQBUF, assuming that there is one compressed frame per
OUTPUT source buffer.

regards
Philipp

