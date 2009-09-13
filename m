Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:51910 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbZIMMDk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 08:03:40 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1Mmnny-0004JS-Il
	for linux-media@vger.kernel.org; Sun, 13 Sep 2009 14:03:42 +0200
Received: from host-78-14-94-28.cust-adsl.tiscali.it ([78.14.94.28])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 13 Sep 2009 14:03:42 +0200
Received: from avljawrowski by host-78-14-94-28.cust-adsl.tiscali.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 13 Sep 2009 14:03:42 +0200
To: linux-media@vger.kernel.org
From: Avl Jawrowski <avljawrowski@gmail.com>
Subject: Re: Problems with Pinnacle 310i (saa7134) and recent kernels
Date: Sun, 13 Sep 2009 12:02:56 +0000 (UTC)
Message-ID: <loom.20090913T115105-855@post.gmane.org>
References: <loom.20090718T135733-267@post.gmane.org>  <1248033581.3667.40.camel@pc07.localdom.local>  <loom.20090720T224156-477@post.gmane.org>  <1248146456.3239.6.camel@pc07.localdom.local>  <loom.20090722T123703-889@post.gmane.org>  <1248338430.3206.34.camel@pc07.localdom.local>  <loom.20090910T234610-403@post.gmane.org>  <1252630820.3321.14.camel@pc07.localdom.local>  <loom.20090912T211959-273@post.gmane.org> <1252815178.3259.39.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

hermann pitton <hermann-pitton <at> arcor.de> writes:

> 
> I'm sorry that we have some mess on some of such devices, but currently
> really nobody can help much further.
> 
> Mike and Hauppauge don't have any schematics for LNA and external
> antenna voltage switching for now, he assured it to me personally and we
> must live with the back hacks for now and try to further work through
> it.
> 
> However, mplayer should work as well, but my last checkout is a little
> out dated.
> 
> It will go to Nico anyway, he is usually at the list here.
> 
> If you can tell me on what you are, I might be able to confirm or not.

Do you mean the exact card I have? I can do some photos if they can help.
Unfortunately I don't have the original eeprom content.

In the matter of the IR, the modules seems to be loaded:

tda1004x               13048  1
saa7134_dvb            20772  0
videobuf_dvb            5644  1 saa7134_dvb
ir_kbd_i2c              5500  0
tda827x                 8880  2
tuner                  16960  1
saa7134               138436  1 saa7134_dvb
ir_common              41828  2 ir_kbd_i2c,saa7134
videobuf_dma_sg         9876  2 saa7134_dvb,saa7134
videobuf_core          13596  3 videobuf_dvb,saa7134,videobuf_dma_sg
tveeprom               10488  1 saa7134

But I can't find anything in /proc/bus/input/devices.

> The only other issue I'm aware of is that radio is broken since guessed
> 8 weeks on my tuners, only realized when testing on enabling external
> active antenna voltage for DVB-T on a/some 310i.
> 
> Might be anything, hm, hopefully I should not have caused it ;)

The radio works for me, even if there's much noise (I don't usually use it).
I'm using the internal audio cable.

> Cheers,
> Hermann

Thank you!

