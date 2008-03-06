Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m26NU1Rb002339
	for <video4linux-list@redhat.com>; Thu, 6 Mar 2008 18:30:01 -0500
Received: from mail-in-07.arcor-online.net (mail-in-07.arcor-online.net
	[151.189.21.47])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m26NTRbK021515
	for <video4linux-list@redhat.com>; Thu, 6 Mar 2008 18:29:28 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <47D064B2.6010803@t-online.de>
References: <1204753679.6717.29.camel@pc08.localdom.local>
	<47D064B2.6010803@t-online.de>
Content-Type: text/plain
Date: Fri, 07 Mar 2008 00:21:34 +0100
Message-Id: <1204845694.8410.18.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134: Asus Tiger revision 1.0, subsys 1043:4857
	improvements
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Am Donnerstag, den 06.03.2008, 22:40 +0100 schrieb Hartmut Hackmann:
> Hi, Hermann
> 
> hermann pitton schrieb:
> > Hi, Harmut,
> > 
> > was able to purchase such a device recently.
> > 
> > For me it looks like they have been on OEM stuff only previously. 
> > The panel for the internal connectors is soldered, the analog audio out
> > is there too and fine.
> > 
> > For all what I could look up, it had never support for the PC-39 remote
> > we added for revision 2.0, since all seen so far comes up with gpio init
> > 0, the remote IRQ to sample from is never active.
> > 
> > Folks, please report if it comes with that RC5 style remote too.
> > 
> > It has a firmware eeprom.
> > 
> > It turns out, and some previous reports pointed to it without to become
> > speficic, but contradictions on what the ms driver does on antenna input
> > switching, that this one has only a male FM connector and a female RF
> > connector.
> > 
> > So, currently we force people with that card to put the DVB-T antenna
> > input on the male FM-connector, which might be quit inconvenient ...
> > 
> indeed ;-)
> 
> > If nobody disagrees, and also my thesis of the not ever delivered remote
> > is right, we should change the auto detection to use card=81, the
> > Philips Tiger reference design you developed on.
> > 
> > Cheers,
> > Hermann
> > 
> > 
> > Stuff currently in that machine. We have also one byte different in the
> > eeprom here.
> > 
> > Linux video capture interface: v2.00
> > saa7130/34: v4l2 driver version 0.2.14 loaded
> > saa7133[0]: found at 0000:01:07.0, rev: 208, irq: 17, latency: 32, mmio: 0xe8000000
> > saa7133[0]: subsystem: 1043:4857, board: Philips Tiger reference design [card=81,insmod option]
> > saa7133[0]: board init: gpio is 0
> > saa7133[0]: i2c eeprom 00: 43 10 57 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> > saa7133[0]: i2c eeprom 10: 00 01 20 00 ff 20 ff ff ff ff ff ff ff ff ff ff
> > saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 cb ff ff ff ff
> >                                                             ^^
> <snip>
> > tuner' 2-004b: chip found @ 0x96 (saa7133[0])
> > tda829x 2-004b: setting tuner address to 61
> > tda829x 2-004b: type set to tda8290+75a
> > saa7133[0]: registered device video0 [v4l2]
> > saa7133[0]: registered device vbi0
> > saa7133[0]: registered device radio0
> > saa7133[1]: found at 0000:01:08.0, rev: 208, irq: 19, latency: 32, mmio: 0xe8001000
> > saa7133[1]: subsystem: 1043:4862, board: ASUSTeK P7131 Dual [card=78,autodetected]
> > saa7133[1]: board init: gpio is 0   <------ remote sensor is broken, else 0x40000
> > input: saa7134 IR (ASUSTeK P7131 Dual) as /class/input/input6
> > tuner' 3-004b: chip found @ 0x96 (saa7133[1])
> > tda829x 3-004b: setting tuner address to 61
> > tda829x 3-004b: type set to tda8290+75a
> > saa7133[1]: i2c eeprom 00: 43 10 62 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> > saa7133[1]: i2c eeprom 10: 00 01 20 00 ff 20 ff ff ff ff ff ff ff ff ff ff
> > saa7133[1]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d6 ff ff ff ff
> >                                                             ^^
> <snip>
> 
> I guess you checked the entire eepron content ;-)
> According to the documentation i have, there is no config byte describing the
> assignment of antenna sockets. The document says that this byte is a checksum!!!
> I will try to get some information.
> I found one discrepancy:
> The Tiger uses LINE1 for the audio baseband inputs while the ASUS uses LINE2.
> Can you cross check this?
> 
> Best regards
>   Hartmut
> 

Hi Hartmut,

that was just some fallout in between and I`m sure to have the proper
testings already. That checksum game is interesting, but whatsoever is
such hidden something good for, except to cheat.

What gives me more to worry about recently is, that it is hard for me to
"illuminate" some last working status of the saa7134-empress in some
variant I have currently. (I'm down to bit specific operations)

If pioneers like Geert, Greg or Mans could provide me with some
saa7134_i2c debug on _start_ last known state and setting the fmt
successfully, might help.

Cheers,
Hermann








--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
