Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:34210 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592AbZGUDYN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 23:24:13 -0400
Subject: Re: Problems with Pinnacle 310i (saa7134) and recent kernels
From: hermann pitton <hermann-pitton@arcor.de>
To: Avl Jawrowski <avljawrowski@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <loom.20090720T224156-477@post.gmane.org>
References: <loom.20090718T135733-267@post.gmane.org>
	 <1248033581.3667.40.camel@pc07.localdom.local>
	 <loom.20090720T224156-477@post.gmane.org>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 05:20:56 +0200
Message-Id: <1248146456.3239.6.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 20.07.2009, 23:30 +0000 schrieb Avl Jawrowski:
> Hi, thank you!
> 
> hermann pitton <hermann-pitton <at> arcor.de> writes:
> 
> > > tuner 1-004b: chip found @ 0x96 (saa7133[0])
> > > tda829x 1-004b: setting tuner address to 61
> > > tda829x 1-004b: type set to tda8290+75a
> > 
> > Nothing about the IR, but at least all tuner modules seem to be
> > correctly loaded.
> 
> Im not using the IR because for now I dont need it, but I will try it.
>  
> > What was your last good working kernel and was your eeprom already
> > failing there too, or is that new?
> 
> I don't remember the last working kernel.
> I tried to recompile 2.6.25 but I obtain this error:
> 
> DVB: Unable to find symbol tda10046_attach()
> saa7133[0]/dvb: frontend initialization failed
> 
> The eeprom was working a few months ago giving this messages:
> 
> saa7133[0]: found at 0000:01:02.0, rev: 209, irq: 19, latency: 64, mmio: 0xcfddf
> 800
> saa7133[0]: subsystem: ffff:ffff, board: UNKNOWN/GENERIC [card=0,autodetected]
> saa7133[0]: board init: gpio is 600e000
> saa7133[0]: i2c eeprom 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> 
> Even then the card was not recognised.
> 
> > Usually such is caused by bad contacts of the PCI slot or by a bad PSU,
> > but we have reports from a Pinnacle 50i with the same i2c remote.
> > 
> > It has i2c troubles (ARB_LOST) and then also problems on loading the
> > tuner modules correctly. With disable_ir=1 for saa7134 it became at
> > least somewhat usable again.
> >
> > But for the 310i is another problem reported starting with kernel
> > 2.6.26.
> > 
> > The 310i and the HVR1110 are the only cards with LowNoiseAmplifier
> > config = 1. Before 2.6.26 two buffers were sent to the tuner at 0x61,
> > doing some undocumented LNA configuration, since 2.6.26 they go to the
> > analog IF demodulator tda8290 at 0x4b.
> > 
> > This was bisected here on the list and is wrong for the 300i.
> > Thread is "2.6.26 regression ..."
> > 
> > The HVR1110 using the same new configuration seems to come in variants
> > with and without LNA and nobody knows, how to make a difference for
> > those cards. At least still no reports about troubles with the new LNA
> > configuration there.
> > 
> > The attached patch against recent mercurial master v4l-dvb at
> > linuxtv.org tries to restore the pre 2.6.26 behaviour for DVB-T on the
> > 300i.
> > 
> > It changes also the i2c remote address of the Upmost Purple TV from 0x7a
> > to 0x3d, since recent i2c on >= 2.6.30 complains about it as invalid
> > 7-bit address, just in case.
> > 
> > Good luck,
> > 
> > Hermann
> > 
> > 
> > Attachment (saa7134-try_to_improve_the_310i.patch): text/x-patch, 1925 bytes
> 
> I tried the patch with 2.6.30.2 on v4l-dvb-1cb6f19d2c9d, but I get only some
> errors (I have rebooted):
> 
> videodev: exports duplicate symbol video_unregister_device (owned by kernel)
> v4l2_common: exports duplicate symbol v4l2_chip_ident_i2c_client (owned by kerne
> l)
> saa7134: Unknown symbol v4l_bound_align_image
> 
> I get these errors even not applying the patch.
> 

there is no excuse for getting errors on linux ;)

Where you got this card from and did it ever work on the same machine
with m$ stuff?

Clean up your module mess, read again, and if the eeprom has still
nothing to tell than 1 for all, get rid of it.

Cheers,
Hermann


