Return-path: <linux-media-owner@vger.kernel.org>
Received: from atlantis.8hz.com ([212.129.237.78]:61428 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705AbZKYVjz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 16:39:55 -0500
Date: Wed, 25 Nov 2009 21:32:46 +0000
From: Sean Young <sean@mess.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: IR raw input is not sutable for input system
Message-ID: <20091125213246.GA44831@atlantis.8hz.com>
References: <200910200956.33391.jarod@redhat.com> <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <20091123173726.GE17813@core.coreip.homeip.net> <4B0B6321.3050001@wilsonet.com> <1259105571.28219.20.camel@maxim-laptop> <Pine.LNX.4.58.0911241918390.30284@shell2.speakeasy.net> <1259155734.4875.23.camel@maxim-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259155734.4875.23.camel@maxim-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 25, 2009 at 03:28:54PM +0200, Maxim Levitsky wrote:
> On Tue, 2009-11-24 at 19:32 -0800, Trent Piepho wrote: 
> > On Wed, 25 Nov 2009, Maxim Levitsky wrote:
> > > Its not the case.
> > > There are many protocols, I know that by experimenting with my universal
> > > remote. There are many receivers, and all have different accuracy.
> > > Most remotes aren't designed to be used with PC, thus user has to invent
> > > mapping between buttons and actions.
> > > Its is not possible to identify remotes accurately, many remotes send
> > > just a 8 bit integer that specifies the 'model' thus many remotes can
> > > share it.
> > 
> > The signal recevied by the ir receiver contains glitches.  Depending on the
> > receiver there can be quite a few.  It is also not trivial to turn the raw
> > signal sent by the remote into a digital value, even if you know what to
> > expect.  It takes digital signal processing techniques to turn the messy
> > sequence of inaccurate mark and space lengths into a best guess at what
> > digital code the remote sent.
> Exactly
> 
> > 
> > It's like turning raw VBI data into decoded ASCII teletext from a simulated
> > keyboard device, all in the kernel.
> You hit a nail on the head with this one.

Absolutely. There are a number of use cases when you want access to the 
space-pulse (i.e. IR) information. For debugging purposes; support for 
non-standard remotes. Being able to do a precise recording of IR activity
so you can replay without parsing. One could even imagine IR being used 
for completely different purposes than "key strokes", so the kernel
should not enforce this "policy".

In the past I've spent time dissecting the IR output of a strange remote, 
I would hate to think this would not be possible due to mad kernel 
interfaces which cater just for drooling in front of the telly with
your *new* remote.


Sean
