Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57573 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597Ab2FTJBb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 05:01:31 -0400
Date: Wed, 20 Jun 2012 11:01:26 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de, fabio.estevam@freescale.com,
	shawn.guo@linaro.org, dirk.behme@googlemail.com,
	r.schwebel@pengutronix.de
Subject: Re: [RFC] Support for 'Coda' video codec IP.
Message-ID: <20120620090126.GO28394@pengutronix.de>
References: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
 <20120619181717.GE28394@pengutronix.de>
 <CACKLOr1zCp2NfLjBrHjtXpmsFMHqhoHFPpghN=Tyf3YAcyRrYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr1zCp2NfLjBrHjtXpmsFMHqhoHFPpghN=Tyf3YAcyRrYg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 20, 2012 at 09:51:32AM +0200, javier Martin wrote:
> Hi Sascha,
> thank you for your review.
> 
> >
> > Since we all move to devicetree shouldn't we stop adding new
> > platform devices?
> 
> Our platfrom, 'visstrim_m10' doesn't currently support devicetree yet,
> so it would be highly difficult for us to test it at the moment.
> Couldn't you add devicetree support in a later patch?

I try to motivate people moving to devicetree. At some point I'd like to
get rid of the platform based boards in the tree. Adding new platform
seems like delaying this instead of working towards a platform board
free Kernel.
Any other opinions on this?

> >
> > The Coda device supports four instances. In this patch you only use
> > instance 0, but you do not protect this function from being opened
> > multiple times. Does this work with multiple opens?
> 
> No, it doesn't work with multiple opens. It would need either
> multi-instance handling support or a restriction so that only can be
> opened once, as you said.
> 
> > Can we do this driver multiple instance from the start? This could be
> > done more easily if we do not create seperate device nodes for
> > encoding/decoding, but when we create a single device node which can be
> > opened exactly 4 times. The decision whether we do encoder or decoder
> > can then be done in set_fmt.
> 
> I don't think adding multi-instance support is that difficult, let me
> take a look at your code and if this is the case I'll do it.

The only difficult thing in multi instance support is that the core has
memory for four different contexts, but only a single processing engine.
So you have to queue up the next frames for all instances in a single
list and let the driver pick the next frame from the list.
In our code we use 'write' to get the datastream from userspace. This
means that it may happen that there is not enough data available for the
next decoding frame. For encoding we use 'read' to pass the datastream
to userspace.  This means that there may be not enough space in the
fifo. Handling this is a bit complicated. Since you are using mem2mem
and work on buffers instead of streams this should be much simpler than
in our driver. I'm just telling you so that you don't get confused when
you look at our code.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
