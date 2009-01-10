Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:34564 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbZAJMfc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jan 2009 07:35:32 -0500
Subject: Re: saa7134: race between device initialization and first interrupt
From: Andy Walls <awalls@radix.net>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	v4l-list <video4linux-list@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <20090110120213.GA5737@joi>
References: <20090104215738.GA9285@joi>
	 <20090108005039.6eeeb470@pedra.chehab.org>
	 <1231555687.3122.59.camel@palomino.walls.org>  <20090110120213.GA5737@joi>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 07:37:36 -0500
Message-Id: <1231591056.3111.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-01-10 at 13:02 +0100, Marcin Slusarz wrote:
> On Fri, Jan 09, 2009 at 09:48:07PM -0500, Andy Walls wrote:
> > On Thu, 2009-01-08 at 00:50 -0200, Mauro Carvalho Chehab wrote:
> > > On Sun, 4 Jan 2009 22:57:42 +0100
> > > Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > > 
> > > > Hi
> > > > There's a race between saa7134 device initialization and first interrupt
> > > > handler, which manifests as an oops [1].
> > > > 
> > > > saa7134_initdev -> request_irq -> saa7134_irq ->
> > > > saa7134_irq_video_signalchange -> saa7134_tvaudio_setmute -> mute_input_7133
> > > > 
> > > > In mute_input_7133 dev->input == NULL and accessing dev->input->amux will oops,
> > > > because dev->input would be initialized later:
> > > > 
> > > > saa7134_initdev -> saa7134_hwinit2 -> saa7134_video_init2 -> video_mux ->
> > > > saa7134_tvaudio_setinput
> > > > 
> > > > I'm not sure how it should be fixed correctly, but one of attached patches
> > > > should fix the symptom.
> > > > 
> > > > Marcin
 
> > Marcin,
> > 
> > What devices share the interrupt with the SAA7133?
> > 
> > $ cat /proc/interrupts
> > 
> > And could on of those those devices possibly generate an interrupt while
> > the saa7134 driver is being modporbe'd?
> 
> I don't have this hardware so I can't tell. I've picked random oops from
> kerneloops.org and tried to fix it.

Ah.  Good man.


> > 
> > Mauro & Marcin,
> > 
> > This looks like to me what is going on:
> > 
> > saa7134_hwinit1() does properly turn off IRQs for which it wants
> > reports:
> > 
> > 	saa_writel(SAA7134_IRQ1, 0);
> >         saa_writel(SAA7134_IRQ2, 0);
> > 
> > but not clearing the state of SAA7134_IRQ_REPORT, maybe something like
> > this (I don't have a SAA7134 datasheet):
> > 
> > 	saa_writel(SAA7134_IRQ_REPORT, 0xffffffff);
> > 
> > So when saa7134_initdev() calls request_irq(..., saa7134_irq,
> > IRQF_SHARED | IRQF_DISABLED, ...), it gets an IRQ that is shared with
> > another device.
> > 
> > Before saa7134_hwinit2() is called by saa7134_initdev() to set
> > "dev->input", some other device fires an interrupt and saa7134_irq() is
> > called that then operates on the unknown state of the SAA7134_IRQ_REPORT
> > register that was never cleared.
> 
> Sounds good. But I think this register should be set to 0, because in 
> saa7134_irq, we do:
> 
> report = saa_readl(SAA7134_IRQ_REPORT);
> (...)
> if ((report & SAA7134_IRQ_REPORT_RDCAP) || (report & SAA7134_IRQ_REPORT_INTL))
> 	saa7134_irq_video_signalchange(dev);
> 
> But I'm not v4l expert, so...

With most chip interrupt status registers, you write the flags you want
to clear.

That way you can always do something like:

	a = read(ISR_REG);
	write(ISR_REG,a);

to clear the Interrupt status register.

Note what saa7134_irq() does:

                report = saa_readl(SAA7134_IRQ_REPORT);
		[...]
                saa_writel(SAA7134_IRQ_REPORT,report);
		[...]
                if ((report & SAA7134_IRQ_REPORT_RDCAP) ||
                        (report & SAA7134_IRQ_REPORT_INTL))
                                saa7134_irq_video_signalchange(dev);


So I'm thinking writing 0 to the register won't have the desired effect.

Again, thanks for taking the initiative.

Regards,
Andy

> > Marcin has mapped out the oops from there.
> > 
> > So the solution, I'm guessing, is likely to clear the SAA7134_IRQ_REPORT
> > register in saa7134_hwinit1().
> > 
> > If only I had a datasheet, hardware, spare time... ;)
> > 
> > 
> > Regards,
> > Andy
> > 
> > 
> > 
> > > Cheers,
> > > Mauro.
> > > 
> > > 
> > > > [1] http://kerneloops.org/guilty.php?guilty=mute_input_7133&version=2.6.27-release&start=1802240&end=1835007&class=oops


