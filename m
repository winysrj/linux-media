Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:60535 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437AbZLWBu3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2009 20:50:29 -0500
Subject: Re: How to make a Zaapa LR301AP DVB-T card work
From: hermann pitton <hermann-pitton@arcor.de>
To: amlopezalonso@gmail.com
Cc: linux-media@vger.kernel.org
In-Reply-To: <200912221641.04526.amlopezalonso@gmail.com>
References: <200912191400.37814.amlopezalonso@gmail.com>
	 <200912201313.31384.amlopezalonso@gmail.com>
	 <1261428671.3208.10.camel@pc07.localdom.local>
	 <200912221641.04526.amlopezalonso@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 23 Dec 2009 02:50:35 +0100
Message-Id: <1261533035.4781.13.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Dienstag, den 22.12.2009, 16:41 +0000 schrieb Antonio Marcos López
Alonso:
> > 
> > Antonio,
> > 
> > the report for tda10046 firmware loading is missing. Was that OK?
> 
> Yes:
> 
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision 29 -- ok
> 
> > 
> > LR301 is a LifeView design. It is very common to see multiple other
> > subvendors for their cards, but they keep the original subdevice ID.
> > In this case 0x0301. The subvendor 0x4e42 is usually Typhoon/Anubis and
> > they are distributing clones of almost all LifeView cards.
> > 
> > Gpio init is the same like on the other known LR301 cards and eeprom
> > differs only for a few bytes, but not for tuner type, tuner and demod
> > address.
> > 
> > http://ubuntuforums.org/archive/index.php/t-328140.html
> > 
> > Since this design with a saa7134 chip and tda8274 DVB-T only tuner is very
> >  old, I don't expect an additional Low Noise Amplifier on it.
> > 
> > We can't detect such LNAs and on newer cards they can cause problems, if
> > not configured correctly and might cause "scan" to fail.
> > 
> > If you mean above other card types did previously work for your card,
> > use them and report.
> 
> No, I meant other "physical" cards. Just to ensure it is not likely to be an 
> aerial problem.

Good to know. However, the first revisions of silicon tuners like the
tda8274 can't compete with can tuners. Only the tda8275a hybrid can come
_close_ to a good can tuner like the FMD1216ME/I H-3 (MK3) on a well
designed PCB. Signal quality might be still not sufficient for your
card.

You also had parity errors on your first report, which likely indicate
problems on your mobo at least with this PCI slot and/or sharing
interrupts with other devices there.

> > Sorry, I don't have better ideas for your card so far.
> 
> I have not included the "tuner" parameter in the "options" line which I think 
> it could be the problem. Is this parameter mandatory? If so, which is the 
> proper one?
> 

No. You can force tuner types only for analog TV. The tda8274 is not a
hybrid tuner, it is only used for DVB-T. An early tda8275 hybrid with a
saa7134 chip would have a separate tda8290 chip for analog IF
demodulation. Without that no analog TV and no tuner type to set.

For DVB-T the tda8274 is treated like a tda8275.

Cheers,
Hermann


