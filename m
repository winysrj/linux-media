Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:57187 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491AbZEQWz3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 18:55:29 -0400
Subject: Re: Fixed (Was:Re: saa7134/2.6.26 regression, noisy output)
From: hermann pitton <hermann-pitton@arcor.de>
To: "tomlohave@gmail.com" <tomlohave@gmail.com>,
	Benoit Istin <beistin@gmail.com>
Cc: Anders Eriksson <aeriksson@fastmail.fm>,
	Steven Toth <stoth@linuxtv.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <4A10168E.70205@gmail.com>
References: <20090503075609.0A73B2C4152@tippex.mynet.homeunix.org>
	 <1241389925.4912.32.camel@pc07.localdom.local>
	 <20090504091049.D931B2C4147@tippex.mynet.homeunix.org>
	 <1241438755.3759.100.camel@pc07.localdom.local>
	 <20090504195201.6ECF52C415B@tippex.mynet.homeunix.org>
	 <1241565988.16938.15.camel@pc07.localdom.local>
	 <20090507130055.E49D32C4165@tippex.mynet.homeunix.org>
	 <20090510141614.D4A9C2C416C@tippex.mynet.homeunix.org>
	 <20090515091827.864A12C4167@tippex.mynet.homeunix.org>
	 <1242438418.3813.15.camel@pc07.localdom.local>  <4A10168E.70205@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 18 May 2009 00:42:54 +0200
Message-Id: <1242600174.3750.29.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Sonntag, den 17.05.2009, 15:52 +0200 schrieb tomlohave@gmail.com:
> hermann pitton a écrit :
> > Hi Anders,
> >
> > Am Freitag, den 15.05.2009, 11:18 +0200 schrieb Anders Eriksson:
> >   
> >> Success!
> >>
> >> I've tracked down the offending change. switch_addr takes on the wrong value
> >> and setting the LNA fails. Here's a i2c dump:
> >>
> >> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7133[0]: i2c xfer: < 20 ERROR: NO_DEVICE
> >> saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
> >> saa7133[0]: i2c xfer: < 86 ERROR: NO_DEVICE
> >> saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
> >> saa7133[0]: i2c xfer: < 96 >
> >> saa7133[0]: i2c xfer: < 96 00 >
> >> saa7133[0]: i2c xfer: < 97 =01 =01 =00 =11 =01 =04 =01 =85 >
> >> saa7133[0]: i2c xfer: < 96 1f >
> >> saa7133[0]: i2c xfer: < 97 =89 >
> >> tda8290_probe: tda8290 detected @ 1-004b
> >> tuner' 1-004b: tda829x detected
> >> tuner' 1-004b: Setting mode_mask to 0x0e
> >> tuner' 1-004b: chip found @ 0x96 (saa7133[0])
> >> tuner' 1-004b: tuner 0x4b: Tuner type absent
> >> tuner' i2c attach [addr=0x4b,client=(tuner unset)]
> >> tuner' 1-004b: Calling set_type_addr for type=54, addr=0xff, mode=0x04, config=0x01
> >> tuner' 1-004b: set addr for type -1
> >> tuner' 1-004b: defining GPIO callback
> >> saa7133[0]: i2c xfer: < 96 1f >
> >> saa7133[0]: i2c xfer: < 97 =89 >
> >> tda8290_probe: tda8290 detected @ 1-004b
> >> saa7133[0]: i2c xfer: < 96 2f >
> >> saa7133[0]: i2c xfer: < 97 =00 >
> >> saa7133[0]: i2c xfer: < 96 21 c0 >
> >> saa7133[0]: i2c xfer: < c1 ERROR: NO_DEVICE
> >> saa7133[0]: i2c xfer: < c3 =88 >
> >> saa7133[0]: i2c xfer: < c5 ERROR: NO_DEVICE
> >> saa7133[0]: i2c xfer: < c7 ERROR: NO_DEVICE
> >> saa7133[0]: i2c xfer: < 96 21 00 >
> >> tda829x 1-004b: setting tuner address to 61
> >> saa7133[0]: i2c xfer: < 96 21 c0 >
> >> saa7133[0]: i2c xfer: < c3 =08 >
> >> tda827x: tda827x_attach:
> >> tda827x: type set to Philips TDA827X
> >> saa7133[0]: i2c xfer: < c3 =08 >
> >> tda827x: tda827xa tuner found
> >> tda827x: tda827x_init:
> >> tda827x: tda827xa_sleep:
> >> saa7133[0]: i2c xfer: < c2 30 90 >
> >> saa7133[0]: i2c xfer: < 96 21 00 >
> >> tda829x 1-004b: type set to tda8290+75a
> >> saa7133[0]: i2c xfer: < 96 21 c0 >
> >> saa7133[0]: i2c xfer: < c2 00 00 00 00 dc 05 8b 0c 04 20 ff 00 00 4b >
> >> saa7133[0]: i2c xfer: < 96 21 00 >
> >> saa7133[0]: i2c xfer: < 96 20 01 >
> >> saa7133[0]: i2c xfer: < 96 30 6f >
> >> tuner' 1-004b: type set to tda8290+75a
> >> tuner' 1-004b: tv freq set to 400.00
> >> tda829x 1-004b: setting tda829x to system xx
> >> tda829x 1-004b: tda827xa config is 0x01
> >> saa7133[0]: i2c xfer: < 96 01 00 >
> >> saa7133[0]: i2c xfer: < 96 02 00 >
> >> saa7133[0]: i2c xfer: < 96 00 00 >
> >> saa7133[0]: i2c xfer: < 96 01 90 >
> >> saa7133[0]: i2c xfer: < 96 28 14 >
> >> saa7133[0]: i2c xfer: < 96 0f 88 >
> >> saa7133[0]: i2c xfer: < 96 05 04 >
> >> saa7133[0]: i2c xfer: < 96 0d 47 >
> >> saa7133[0]: i2c xfer: < 96 21 c0 >
> >> tda827x: setting tda827x to system xx
> >> tda827x: setting LNA to high gain
> >> saa7133[0]: i2c xfer: < 96 22 00 >
> >>                         ^ This address is c2 in all kernels <= 5823b3a63c7661272ea7fef7635955e2a50d17eb
> >>
> >>
> >> saa7133[0]: i2c xfer: < c2 00 32 f8 00 16 3b bb 1c 04 20 00 >
> >> saa7133[0]: i2c xfer: < c2 90 ff e0 00 99 >
> >> saa7133[0]: i2c xfer: < c2 a0 c0 >
> >> saa7133[0]: i2c xfer: < c2 30 10 >
> >> saa7133[0]: i2c xfer: < c3 =49 =a4 >
> >> tda827x: AGC2 gain is: 10
> >>                        ^ The gain reported on good kernels is 3 
> >>
> >> Looking at the source, the switch_addr to use in the later kernels is somehow 
> >> autodetected. How that's done, I've yet to fully understand, but somehow it 
> >> comes up with the wrong address.
> >>
> >> This patch (which obviously needs improvement) hardwires the address back to 
> >> its original value, and works for 2.6.30-rc5.
> >>
> >> diff --git a/drivers/media/common/tuners/tda8290.c b/drivers/media/common/tuners/tda8290.c
> >> index 064d14c..498cc7b 100644
> >> --- a/drivers/media/common/tuners/tda8290.c
> >> +++ b/drivers/media/common/tuners/tda8290.c
> >> @@ -635,7 +635,11 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
> >>  
> >>                 dvb_attach(tda827x_attach, fe, priv->tda827x_addr,
> >>                            priv->i2c_props.adap, &priv->cfg);
> >> +               tuner_info("ANDERS: setting switch_addr. was 0x%02x, new 0x%02x\n",priv->cfg.switch_addr,priv->i2c_props.addr);
> >>                 priv->cfg.switch_addr = priv->i2c_props.addr;
> >> +               priv->cfg.switch_addr = 0xc2 / 2;
> >> +               tuner_info("ANDERS: new 0x%02x\n",priv->cfg.switch_addr);
> >> +
> >>         }
> >>         if (fe->ops.tuner_ops.init)
> >>                 fe->ops.tuner_ops.init(fe);
> >>
> >>
> >> Could you please help me out and shed some light on what the proper fix is for 
> >> setting switch_addr? 
> >>
> >> Thanks,
> >> /Anders
> >>
> >>     
> >
> > thanks a lot for all your time and energy you did spend on this.
> >
> > I suggest we start collecting photographs of different LNA circuits on
> > the wiki.
> >
> > For now, Tom offered his support already off list, I think we should
> > start about the question, if that early Hauppauge HVR 1110 has such an
> > LNA type one at all, since this caused to not look at it further, as it
> > seemed to be without problems.
> >
> > Tom, I know you carefully worked on it, but can you reassure that this
> > LNA config one is really needed on your device?
> >
> >   
> Hello list,
> you are talking about tuner_config = 1 for the hvr 1110, right ?
> Changing this option doesn't affect the qualitie of the signal on tv
> see http://forum.ubuntu-fr.org/viewtopic.php?pid=1472261
> it 's an "old" discussion in french.

hmm, strange, since we got a different report too.

> This option, as far as i remenber, was not provided by me ...

Thomas, thanks for reply. Looking closer now you are right.
It came not in over you, but Mike picked it up from Benoit.

hg export 6746
# HG changeset patch
# User Michael Krufky <mkrufky@linuxtv.org>
# Date 1197003604 18000
# Node ID f43a48e8bf53bf6a83953e15631fd1f5049a34f0
# Parent  dd0e14aaa659375bfa4356d85ff7bf6308b9baa8
saa7134-dvb: fix tuning for WinTV HVR-1110

From: Benoit Istin <beistin@gmail.com>

There are several months my hvr1110 stop working.
This is very simple to fix, for my card revision at least, by setting a
missing field to the hauppauge_hvr_1110_config.

Signed-off-by: Benoit Istin <beistin@gmail.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

diff -r dd0e14aaa659 -r f43a48e8bf53 linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c   Thu Dec 06 22:33:08 2007 -0500
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c   Fri Dec 07 00:00:04 2007 -0500
@@ -662,6 +662,7 @@
        .if_freq       = TDA10046_FREQ_045,
        .i2c_gate      = 0x4b,
        .tuner_address = 0x61,
+       .tuner_config  = 1,
        .request_firmware = philips_tda1004x_request_firmware
 };

I must have noticed that it is still missing for analog then.
http://linuxtv.org/hg/v4l-dvb/annotate/b227949c41ad/linux/drivers/media/video/saa7134/saa7134-cards.c

> anyway with tuner debug=1 and .tuner_config=1 , i have no line with AGC 
> or LNA on dmesg

Anders already gave the debug options he does set.

> I have somme glitchs with hvr1110 on dvb (not analogic tv) and many for 
> one particular station call M6 (and i'm not the only one user, see 
> previous post on ubuntu-fr.org, with short or long distance from tv 
> relay) . Bug on 310i means potentially bug on hvr1110 as configuration 
> on hvr 1110 was made from 310i
> 
> and sorry for bad english

sorry for mine too.

On some cards LNA config 1 seems to make a difference and on others not
or is it only because already broken? Maybe we have different card
versions too, but you provided initial support for it and your report of
course still counts.

Under normal conditions you should expect that such cards are working
without any glitches. If your reception overall is on some limit, it is
somehow normal that one transponder starts to fail at first more
visible, if you have some glitches on the others already.

The sensitivity is not fully linear over the whole spectrum. I see this
on other tuners too, but the flaw there starts on different frequencies.

The antenna has of course an important role too and all sorts of RF
amplifiers involved. The other case is also often reported from other
cards already. It might happen, if close to the transmitter, that one
might need an attenuator.

Maybe try Anders' patch on recent.

Cheers,
Hermann


