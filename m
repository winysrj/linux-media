Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49712 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbZBMW1Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 17:27:24 -0500
Date: Fri, 13 Feb 2009 20:26:55 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Michael Schimek <mschimek@gmx.at>,
	hjkoch@users.berlios.de, tobias.lorenz@gmx.net,
	belavenuto@gmail.com
Subject: Re: RFC: Finalizing the V4L2 RDS interface
Message-ID: <20090213202655.66d6923c@pedra.chehab.org>
In-Reply-To: <200902132259.07618.hverkuil@xs4all.nl>
References: <200902130955.19995.hverkuil@xs4all.nl>
	<20090213191545.3d92e121@pedra.chehab.org>
	<200902132259.07618.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Feb 2009 22:59:07 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> > > Or perhaps we should add a field that reports the maximum number of
> > > buffered packets? E.g. __u16 rds_buf_size. This might be more generic
> > > and you can even allow this to be set with VIDIOC_S_TUNER (although
> > > drivers can ignore it).
> >
> > Why to spend 16 bits for it? It seems easier to check for for the amount
> > of received packets on userspace. I think we should avoid to waste those
> > reserved bytes.
> 
> Hmm, I'm too creative here, I agree. Let's keep it simple.

Ok.

> I realized that we also need to make a note that no RDS *encoder* interface 
> has yet been designed, and that anyone interested should contact 
> linux-media. Any encoder interface would probably be very similar, except 
> using write() instead of read().

There are some interests on RDS encoder also. Someone contacted me about that
sometime ago. I suspect that a few more is needed than just write().

> BTW, do you think that drivers that can do RDS should set 
> V4L2_CAP_RDS_CAPTURE in addition to the v4l2_tuner caps? I'm leaning 
> towards a 'yes' here. It's already defined, so there might be some apps 
> that already use this define, and it might be a useful high-level 
> capability anyway.

I think so.

Cheers,
Mauro
