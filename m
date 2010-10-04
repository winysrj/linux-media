Return-path: <mchehab@pedra>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:45539 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573Ab0JDBAf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Oct 2010 21:00:35 -0400
Subject: Re: [linux-dvb] Asus MyCinema P7131 Dual support
From: hermann pitton <hermann-pitton@arcor.de>
To: Dejan Rodiger <dejan.rodiger@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTimdpehorJb+YrDuRgL7vSbF9Bn5iQS_g5TqF35F@mail.gmail.com>
References: <25861669.1285195582100.JavaMail.ngmail@webmail18.arcor-online.net>
	 <AANLkTimdpehorJb+YrDuRgL7vSbF9Bn5iQS_g5TqF35F@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 04 Oct 2010 02:49:26 +0200
Message-Id: <1286153366.3131.40.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Dejan,

Am Montag, den 04.10.2010, 01:48 +0200 schrieb Dejan Rodiger:
> Hi Hermann,
> 
> I finally found the time to wire analog antena and I checked it with
> my TV if it is working correctly.
> Since I am using local cable provider which didn't upgrade their
> system in 10 years and they are still broadcast in analog, I had a
> problem off finding channel list, so in the end I tried tvtime-scanner
> and it found about 58 channels. But, out of this 58 most of them were
> not good (no signal). I was able to finetune few programs. My main
> programs (local Croatian TV stations) were not found. Maybe I need to
> finetune every found station.

that doesn't sound good. The card should just work.

Anyone else still out there with the same?

Or are we finally destroyed by so called "compile fixes" and linux
"next" stuff ?

> I also tried zapping which crashed my X.

Yeah, goes on since years, but has still good vbi :)

dunno, if Michael has further plans on that.

> I am also lost in setting mythtv. I set analog tunner on /dev/video0.
> But I think I have a problem of setting the channel list for my local
> cable provider. Is it possible to scan whole list or something. If you
> have any reading recommendation to set this, I would be helpfull
> 
> Thanks
> --
> Dejan Rodiger
> S: callto://drodiger

For DVB-T try "kaffeine" or low level tools. Allow full delay for tuning
and locking.

If that fails, and no other well known other hardware restrictions are
in place, we have some broken code.

I do have a triple Asus 3in1 OEM with the same LNA config as that first
hybrid board has.

If really broken, not noticed yet here, but also not used since long, we
can meet on some same code base and track it down.

Cheers,
Hermann


> 
> 
> 
> On Thu, Sep 23, 2010 at 00:46,  <hermann-pitton@arcor.de> wrote:
> >
> >
> > Hi Dejan,
> >
> > ----- Original Nachricht ----
> > Von:     Dejan Rodiger <dejan.rodiger@gmail.com>
> > An:      hermann pitton <hermann-pitton@arcor.de>
> > Datum:   22.09.2010 13:20
> > Betreff: Re: [linux-dvb] Asus MyCinema P7131 Dual support
> >
> >> Hi Herman,
> >>
> >> here is dmesg output without forcing card=78.
> >> As I see it uses card=112, autodetected
> >>
> >> [   16.043345] IR RC6 protocol handler initialized
> >> [   16.173473] IR JVC protocol handler initialized
> >> [   16.236641] IR Sony protocol handler initialized
> >> [   16.433187] lirc_dev: IR Remote Control driver registered, major 250
> >> [   16.572705] IR LIRC bridge handler initialized
> >> [   16.894983] Linux video capture interface: v2.00
> >> [   16.957585] saa7130/34: v4l2 driver version 0.2.16 loaded
> >> [   16.958300] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
> >> [   16.958306]   alloc irq_desc for 18 on node 0
> >> [   16.958309]   alloc kstat_irqs on node 0
> >> [   16.958320] saa7134 0000:01:06.0: PCI INT A -> Link[APC3] -> GSI 18
> >> (level, low) -> IRQ 18
> >> [   16.958327] saa7133[0]: found at 0000:01:06.0, rev: 209, irq: 18,
> >> latency: 32, mmio: 0xfdeff000
> >> [   16.958334] saa7133[0]: subsystem: 1043:4876, board: ASUSTeK P7131
> >> Hybrid [card=112,autodetected]
> >> [   16.958378] saa7133[0]: board init: gpio is 0
> >> [   17.010075] Registered IR keymap rc-asus-pc39
> >> [   17.010197] input: saa7134 IR (ASUSTeK P7131 Hybri as
> >> /devices/pci0000:00/0000:00:09.0/0000:01:06.0/rc/rc0/input4
> >> [   17.010268] rc0: saa7134 IR (ASUSTeK P7131 Hybri as
> >> /devices/pci0000:00/0000:00:09.0/0000:01:06.0/rc/rc0
> >> [   17.190477] saa7133[0]: i2c eeprom 00: 43 10 76 48 54 20 1c 00 43
> >> 43 a9 1c 55 d2 b2 92
> >> [   17.190490] saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff
> >> ff ff ff ff ff ff ff
> >> [   17.190502] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08
> >> ff 00 d5 ff ff ff ff
> >> [   17.190513] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
> >> ff ff ff ff ff ff ff
> >> [   17.190524] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 55
> >> 50 ff ff ff ff ff ff
> >> [   17.190534] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
> >> ff ff ff ff ff ff ff
> >> [   17.190545] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
> >> ff ff ff ff ff ff ff
> >> [   17.190556] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
> >> ff ff ff ff ff ff ff
> >> [   17.190566] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
> >> ff ff ff ff ff ff ff
> >> [   17.190577] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
> >> ff ff ff ff ff ff ff
> >> [   17.190587] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
> >> ff ff ff ff ff ff ff
> >> [   17.190598] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
> >> ff ff ff ff ff ff ff
> >> [   17.190609] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
> >> ff ff ff ff ff ff ff
> >> [   17.190620] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
> >> ff ff ff ff ff ff ff
> >> [   17.190630] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
> >> ff ff ff ff ff ff ff
> >> [   17.190641] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
> >> ff ff ff ff ff ff ff
> >>
> >> [   17.610120] tuner 2-004b: chip found @ 0x96 (saa7133[0])
> >>
> >> [   17.780037] tda829x 2-004b: setting tuner address to 61
> >> [   17.940020] tda829x 2-004b: type set to tda8290+75a
> >>
> >> [   24.000114] saa7133[0]: registered device video0 [v4l2]
> >> [   24.000150] saa7133[0]: registered device vbi0
> >> [   24.000182] saa7133[0]: registered device radio0
> >> [   24.027730] saa7134 ALSA driver for DMA sound loaded
> >> [   24.027770] saa7133[0]/alsa: saa7133[0] at 0xfdeff000 irq 18
> >> registered as card -2
> >>
> >> [   25.900159] DVB: registering new adapter (saa7133[0])
> >> [   25.900165] DVB: registering adapter 0 frontend 0 (Philips
> >> TDA10046H DVB-T)...
> >>
> >> [   26.710050] tda1004x: setting up plls for 48MHz sampling clock
> >> [   27.710043] tda1004x: found firmware revision 29 -- ok
> >>
> >>
> >> --
> >> Dejan Rodiger
> >> M: +385917829076
> >> S: callto://drodiger
> >>
> >
> > all looks fine now.
> >
> > With auto detection you should have correct LNA support for analog tuning and DVB-T.
> >
> > You need to connect the DVB-T signal to the FM/RF antenna input and the analog TV signal
> > to the cable RF input..
> >
> > If you plug in the remote receiver, gpio 0x040000 will switch to high.
> >
> > Does this help any further?
> >
> > What went wrong previously, making you think you might have to force for example card = 78 ?
> >
> > I can revive almost all of the Asus cards on the saa713x driver if needed.
> >
> > Have fun, hopefully.
> >
> > Cheers,
> > Hermann
> >
> >
> >>
> >> On Wed, Sep 22, 2010 at 01:13, hermann pitton <hermann-pitton@arcor.de>
> >> wrote:
> >> > Hi Dejan,
> >> >
> >> > Am Dienstag, den 21.09.2010, 10:07 +0200 schrieb Dejan Rodiger:
> >> >> Hi,
> >> >>
> >> >> I am using Ubuntu linux 10.10 with the latest kernel 2.6.35-22-generic
> >> >> on x86_64. I have installed nonfree firmware which should support this
> >> >> card, but to be sure, can somebody confirm that my TV card is
> >> >> supported in Analog or DVB mode?
> >> >>
> >> >> sudo lspci -vnn
> >> >> 01:06.0 Multimedia controller [0480]: Philips Semiconductors
> >> >> SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
> >> >>         Subsystem: ASUSTeK Computer Inc. My Cinema-P7131 Hybrid
> >> >> [1043:4876]
> >> >>         Flags: bus master, medium devsel, latency 32, IRQ 18
> >> >>         Memory at fdeff000 (32-bit, non-prefetchable) [size=2K]
> >> >>         Capabilities: [40] Power Management version 2
> >> >>         Kernel driver in use: saa7134
> >> >>         Kernel modules: saa7134
> >> >>
> >> >> It says Hybrid, but I put the following in
> >> >> the /etc/modprobe.d/saa7134.conf
> >> >> options saa7134 card=78 tuner=54
> >> >>
> >> >>
> >> >> Thanks
> >> >> --
> >> >> Dejan Rodiger
> >> >> S: callto://drodiger
> >> >
> >> > don't have time to follow this closely anymore.
> >> >
> >> > But forcing it to card=78 is plain wrong. It has an early additional LNA
> >> > in confirmed config = 2 status.
> >> >
> >> > Your card should be auto detected and previously always was, based on
> >> > what we have in saa7134-cards.c and further for it. (saa7134-dvb and
> >> > related tuner/demod stuff)
> >> >
> >> >        }, {
> >> >                .vendor       = PCI_VENDOR_ID_PHILIPS,
> >> >                .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
> >> >                .subvendor    = 0x1043,
> >> >                .subdevice    = 0x4876,
> >> >                .driver_data  = SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA,
> >> >        },{
> >> >
> >> > I remember for sure, that this card was fully functional for all use
> >> > cases and it was not easy to get it there. I don't have it.
> >> >
> >> > Please provide the "dmesg" for failing auto detection without forcing
> >> > some card = number as a starting point.
> >> >
> >> > I for sure want to see this board fully functional again.
> >> >
> >> > Cheers,
> >> > Hermann
> >> >
> >
> >
> > Heute erleben, was morgen Trend wird - das kann man auf der IFA in Berlin. Oder auf arcor.de: Wir stellen Ihnen die wichtigsten News, Trends und Gadgets der IFA vor. Natürlich mit dabei: das brandneue IPTV-Angebot von Vodafone! Alles rund um die Internationale Funkausstellung in Berlin finden Sie hier: http://www.arcor.de/rd/footer.ifa2010
> >

