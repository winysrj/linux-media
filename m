Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:53515 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZBPQTH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 11:19:07 -0500
Received: from shell2.sea5.speakeasy.net ([69.17.116.3])
          (envelope-sender <xyzzy@speakeasy.org>)
          by mail3.sea5.speakeasy.net (qmail-ldap-1.03) with AES256-SHA encrypted SMTP
          for <linux-media@vger.kernel.org>; 16 Feb 2009 16:19:06 -0000
Date: Mon, 16 Feb 2009 08:19:06 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: linux-media@vger.kernel.org
cc: e9hack <e9hack@googlemail.com>, obi@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-dvb@linuxtv.org
Subject: Re: [BUG] changeset 9029 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
In-Reply-To: <200902151336.17202@orion.escape-edv.de>
Message-ID: <Pine.LNX.4.58.0902160811340.24268@shell2.speakeasy.net>
References: <4986507C.1050609@googlemail.com> <200902151336.17202@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Feb 2009, Oliver Endriss wrote:
> e9hack wrote:
> > this change set is wrong. The affected functions cannot be called from an interrupt
> > context, because they may process large buffers. In this case, interrupts are disabled for
> > a long time. Functions, like dvb_dmx_swfilter_packets(), could be called only from a
> > tasklet. This change set does hide some strong design bugs in dm1105.c and au0828-dvb.c.
> >
> > Please revert this change set and do fix the bugs in dm1105.c and au0828-dvb.c (and other
> > files).
>
> @Mauro:
>
> This changeset _must_ be reverted! It breaks all kernels since 2.6.27
> for applications which use DVB and require a low interrupt latency.
>
> It is a very bad idea to call the demuxer to process data buffers with
> interrupts disabled!

I agree, this is bad.  The demuxer is far too much work to be done with
IRQs off.  IMHO, even doing it under a spin-lock is excessive.  It should
be a mutex.  Drivers should use a work-queue to feed the demuxer.
