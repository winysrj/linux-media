Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KooIH-0003eb-7x
	for linux-dvb@linuxtv.org; Sun, 12 Oct 2008 01:54:50 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
In-Reply-To: <1223753645.3125.57.camel@palomino.walls.org>
References: <1223741522.48f0d052c956b@webmail.free.fr>
	<1223753645.3125.57.camel@palomino.walls.org>
Date: Sun, 12 Oct 2008 01:47:39 +0200
Message-Id: <1223768859.2706.15.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134 bug in 64 bits system
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

Am Samstag, den 11.10.2008, 15:34 -0400 schrieb Andy Walls:
> On Sat, 2008-10-11 at 18:12 +0200, mathieu.taillefumier@free.fr wrote:
> > Hi devs,
> > 
> > I discover an annoying bug in the saa7134 module after using my tv card again.
> > The card is a cinergy ht pcmcia which works perfectly on both XP and fedora 10
> > (with a customized kernel 2.7.27-rc8) but fail to initialize the card correctly
> > on 64bits kernel (it is a lfs in this case with the same version of the kernel
> > and the same drivers for the tv card). The drivers I am using are the last
> > version of the mercurial repository. I attached the dmesg files for both 32bits
> > and 64bits (same arch).
> 
> With a diff of the dmesg files, I noticed things are being detected and
> configured slightly differently.  I'm not sure that's important, but
> this one in particular caught my eye:
> 
>     ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
>    -ACPI: Skipping IOAPIC probe due to 'noapic' option.
>    +ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
>    +IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
> 
> 
> Any particular reason you're specifying noapic for 32 bit and not for 64
> bit?
> 
> Again, I'm not sure if it's important, but if you are troubleshooting
> between 2 setups, you want to eliminate as many unknowns as possible by
> keeping things the same as much as you can.
> 
> 
> 
> > I try to track the problem and it seems that it is coming from the init function
> > of the driver in particular the line saa_readl(SAA7134_GPIO_GPSTATUS0>>2). the
> > gpio is wrong on 64 bits. The kernel indicates gpio is ffffffff instead of gpio
> > is 0 (which is the correct value).
> 
> The devices on a PCI bus return 0xffffffff when there is a PCI bus read
> error.
> 
> Given the error messages from line 731 on in the dmesg-64 file, I'd say
> the PCI bus is returning a lot of PCI read errors to the driver.  To
> verify, one could probably modify the saa_readl() macro in saa7134.h to
> a static inline function that also printk()'s out what was just read.
> (Not that that will help solve the problem.)
> 
> 
> >  So I do not know if it is problem in the
> > drivers or if the problem is coming from the kernel itself. 
> 
> I'm wagering it's a PCI bus configuration/setup problem.  (*guess*)
> 
> Given that it looks like your video card is a PCMCIA/CardBus card, maybe
> something with the Yenta driver is not right. (*Wild guess*)
> 
> This message, that only appeared in dmesg-64, may be of concern, since
> you're using a PCMCIA/CardBus card:
> 
>    cs: pcmcia_socket0: unable to apply power.
>    pccard: CardBus card inserted into slot 0
> 
> 
> 
> > I am willing to help
> > the devs to track down this bug so please let me know if you need some help.
> 
> Those are just WAGs as to what might be wrong.  More differential
> analysis of the dmesg and dmesg-64 files may help you narrow things
> down.  I will think you'll need to expand your search beyond the saa7134
> driver messages - to me they appear to be symptoms caused by a problem
> with something else.  Good luck.  

at least the device is totally death for any i2c stuff, means that Andy
is right, that it fails on prior PCI stuff already.

Coming up by default with a PCI latency of 0 also looks insane.

It is also not reproducible on a recent 2.6.26 _64 quad too.

Unload the drivers, put the device out, wait 35 seconds, load the
drivers again, insert that card and report it is still the same.

Thanks,
Hermann

> Regards,
> Andy
> 
> > Regards
> > 
> > Mathieu
> 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
