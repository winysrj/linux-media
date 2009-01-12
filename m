Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:56682 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbZALTNO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 14:13:14 -0500
Date: Mon, 12 Jan 2009 11:13:12 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andy Walls <awalls@radix.net>
cc: hermann pitton <hermann-pitton@arcor.de>,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	v4l-list <video4linux-list@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Marcin Slusarz <marcin.slusarz@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: saa7134: race between device initialization and first interrupt
In-Reply-To: <1231722231.10277.38.camel@palomino.walls.org>
Message-ID: <Pine.LNX.4.58.0901121042070.23876@shell2.speakeasy.net>
References: <20090104215738.GA9285@joi> <20090108005039.6eeeb470@pedra.chehab.org>
 <1231555687.3122.59.camel@palomino.walls.org> <20090110120213.GA5737@joi>
 <1231591056.3111.7.camel@palomino.walls.org> <1231641126.2613.10.camel@pc10.localdom.local>
 <1231643119.10110.41.camel@palomino.walls.org> <1231718073.8278.32.camel@pc10.localdom.local>
 <1231722231.10277.38.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 11 Jan 2009, Andy Walls wrote:
> On Mon, 2009-01-12 at 00:54 +0100, hermann pitton wrote:
> > Am Samstag, den 10.01.2009, 22:05 -0500 schrieb Andy Walls:
> > > On Sun, 2009-01-11 at 03:32 +0100, hermann pitton wrote:
> > > > Am Samstag, den 10.01.2009, 07:37 -0500 schrieb Andy Walls:
> > > > > On Sat, 2009-01-10 at 13:02 +0100, Marcin Slusarz wrote:
> > > > > > On Fri, Jan 09, 2009 at 09:48:07PM -0500, Andy Walls wrote:
> > > > > > > but not clearing the state of SAA7134_IRQ_REPORT, maybe something like
> > > > > > > this (I don't have a SAA7134 datasheet):
> > > > > > >
> > > > > > > 	saa_writel(SAA7134_IRQ_REPORT, 0xffffffff);
> > > > > > >
> > > > > > > So when saa7134_initdev() calls request_irq(..., saa7134_irq,
> > > > > > > IRQF_SHARED | IRQF_DISABLED, ...), it gets an IRQ that is shared with
> > > > > > > another device.

Keep in mind that PCI writes are posted, so 'writel(...);request_irq(...);'
might result in the irq being requested (which only involves the CPU and
kernel) before the device receives and processes the write (which involves
the CPU, pci bridge(s), and the saa7134 device).

IMHO, a better solution is to just not request the irq until the driver is
read to handle interrupts.  That seems a lot safer than depending on the
irq handler not doing anything bad if it's called while the driver is still
initializing.

> > Andy, I allowed shared interrupts on several machines with multiple
> > saa713x cards and current v4l-dvb, but I'm still not able to reproduce
> > the oops. So can't try the fix. Who has the oops and can try?

What you need to have is the saa713x sharing an interrupt with a different
device which generates a lot of interrupts while the saa713x driver is
being loaded.  Even then it's a race and isn't going to happen every time.

> So "dev->input" is NULL when saa7134-tvaudio.c:mute_input_7133() is
> called and that is what causes the Oops.  It was called by the
> saa7134_irq() handler trying to take action, shortly after request_irq()
> was called.  Can you think of why this would happen?

I have no doubt that the original idea that SAA7134_IRQ_REPORT isn't clear
when the driver loads is correct.  Why shouldn't the bits be set?  And if
they are, we should see an Oops that looks exactly like this one.
