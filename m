Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51407 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbZAJCqQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jan 2009 21:46:16 -0500
Subject: Re: saa7134: race between device initialization and first interrupt
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
	v4l-list <video4linux-list@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <20090108005039.6eeeb470@pedra.chehab.org>
References: <20090104215738.GA9285@joi>
	 <20090108005039.6eeeb470@pedra.chehab.org>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 21:48:07 -0500
Message-Id: <1231555687.3122.59.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-01-08 at 00:50 -0200, Mauro Carvalho Chehab wrote:
> On Sun, 4 Jan 2009 22:57:42 +0100
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > Hi
> > There's a race between saa7134 device initialization and first interrupt
> > handler, which manifests as an oops [1].
> > 
> > saa7134_initdev -> request_irq -> saa7134_irq ->
> > saa7134_irq_video_signalchange -> saa7134_tvaudio_setmute -> mute_input_7133
> > 
> > In mute_input_7133 dev->input == NULL and accessing dev->input->amux will oops,
> > because dev->input would be initialized later:
> > 
> > saa7134_initdev -> saa7134_hwinit2 -> saa7134_video_init2 -> video_mux ->
> > saa7134_tvaudio_setinput
> > 
> > I'm not sure how it should be fixed correctly, but one of attached patches
> > should fix the symptom.
> > 
> > Marcin
> 
> Hi Marcin,
> 
> Probably, it is some locking trouble on saa7134 driver that appeared on 2.6.27,
> with the lack of KBL on newer kernels. cx88 driver is suffering similar
> troubles starting with 2.6.27.
> 
> I'll try to find some time to review, but it would be better if someone volunteer himself to take a look on cx88 and saa7134 locks.

Mauro & Marcin,

This isn't a locking issue.  This is a device initialization issue.  It
also looks like it's been reported quite often under 2.6.25 as well.


Marcin,

What devices share the interrupt with the SAA7133?

$ cat /proc/interrupts

And could on of those those devices possibly generate an interrupt while
the saa7134 driver is being modporbe'd?


Mauro & Marcin,

This looks like to me what is going on:

saa7134_hwinit1() does properly turn off IRQs for which it wants
reports:

	saa_writel(SAA7134_IRQ1, 0);
        saa_writel(SAA7134_IRQ2, 0);

but not clearing the state of SAA7134_IRQ_REPORT, maybe something like
this (I don't have a SAA7134 datasheet):

	saa_writel(SAA7134_IRQ_REPORT, 0xffffffff);

So when saa7134_initdev() calls request_irq(..., saa7134_irq,
IRQF_SHARED | IRQF_DISABLED, ...), it gets an IRQ that is shared with
another device.

Before saa7134_hwinit2() is called by saa7134_initdev() to set
"dev->input", some other device fires an interrupt and saa7134_irq() is
called that then operates on the unknown state of the SAA7134_IRQ_REPORT
register that was never cleared.

Marcin has mapped out the oops from there.

So the solution, I'm guessing, is likely to clear the SAA7134_IRQ_REPORT
register in saa7134_hwinit1().

If only I had a datasheet, hardware, spare time... ;)


Regards,
Andy



> Cheers,
> Mauro.
> 
> 
> > [1] http://kerneloops.org/guilty.php?guilty=mute_input_7133&version=2.6.27-release&start=1802240&end=1835007&class=oops
> > 
> > ---
> > diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
> > index 02bb674..fcb0b17 100644
> > --- a/drivers/media/video/saa7134/saa7134-video.c
> > +++ b/drivers/media/video/saa7134/saa7134-video.c
> > @@ -2585,7 +2585,8 @@ void saa7134_irq_video_signalchange(struct saa7134_dev *dev)
> >  		/* no video signal -> mute audio */
> >  		if (dev->ctl_automute)
> >  			dev->automute = 1;
> > -		saa7134_tvaudio_setmute(dev);
> > +		if (dev->input)
> > +			saa7134_tvaudio_setmute(dev);
> >  	} else {
> >  		/* wake up tvaudio audio carrier scan thread */
> >  		saa7134_tvaudio_do_scan(dev);
> > ---
> > 
> > or
> > 
> > ---
> > diff --git a/drivers/media/video/saa7134/saa7134-tvaudio.c b/drivers/media/video/saa7134/saa7134-tvaudio.c
> > index 76b1640..75ee085 100644
> > --- a/drivers/media/video/saa7134/saa7134-tvaudio.c
> > +++ b/drivers/media/video/saa7134/saa7134-tvaudio.c
> > @@ -917,6 +917,8 @@ int saa7134_tvaudio_rx2mode(u32 rx)
> >  
> >  void saa7134_tvaudio_setmute(struct saa7134_dev *dev)
> >  {
> > +	if (!dev->input)
> > +		return;
> >  	switch (dev->pci->device) {
> >  	case PCI_DEVICE_ID_PHILIPS_SAA7130:
> >  	case PCI_DEVICE_ID_PHILIPS_SAA7134:
> > ---
> 
> 

