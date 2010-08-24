Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:42376 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab0HXJUO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 05:20:14 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Onpfw-00015o-4b
	for linux-media@vger.kernel.org; Tue, 24 Aug 2010 11:20:12 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 24 Aug 2010 11:20:12 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 24 Aug 2010 11:20:12 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: MSI DigiVox Trio (Analog, DVB-C, DVB-T)
Date: Tue, 24 Aug 2010 11:20:02 +0200
Message-ID: <87vd704bb1.fsf@nemi.mork.no>
References: <4C736D15.9000000@matthias-larisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Matthias Larisch <mail@matthias-larisch.de> writes:

> Hello!
>
> I recently bought a DigiVox Trio by MSI. This card contains the
> following chips:
>
> nxp tda18271hdc2 (tuner)
> micronas drx 3926ka3 (demodulator, 3in1)
> em2884
> atmlh946 64c (eeprom)
> micronas avf 4910ba1
>
> so it is comparable to the Terratec Cinergy HTC USB XS HD and the
> TerraTec H5.
>
> There is basically everything missing:
> -EM2884 Support
> -DRX 3926 Support
> -AVF 4910 Support
>
> Is anyone working on any of them? I would really like to help to get
> some of this stuff working! I know how to code and have much interest in
> hardware/technology but no know how in linux-driver programming or
> tv-card programming. If there is anything I could do just tell me.

I believe Terratec's comment regarding the TerraTec H5 applies:
http://linux.terratec.de/tv_en.html

Sorry.  It's like this:  If you see "Micronas", then don't buy.



Bjørn

