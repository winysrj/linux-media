Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:50908 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab3KCPAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 10:00:03 -0500
Message-ID: <1383490799.8067.80.camel@baka>
Subject: Re: Hauppauge HVR-4400
From: Christoph Schwerdtfeger <linux@baka0815.de>
To: linux-media@vger.kernel.org
Date: Sun, 03 Nov 2013 15:59:59 +0100
In-Reply-To: <loom.20131023T184229-891@post.gmane.org>
References: <201005041400.10530.jan_moebius@web.de>
	 <z2q829197381005040636vbd2d7254n4674dcc21cc751f4@mail.gmail.com>
	 <loom.20131023T184229-891@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 23.10.2013, 16:58 +0000 schrieb Christoph
Schwerdtfeger:
> Devin Heitmueller <dheitmueller <at> kernellabs.com> writes:
> 
> > 
> > On Tue, May 4, 2010 at 8:00 AM, Jan Möbius <jan_moebius <at> web.de> wrote:
> > > Hi,
> > >
> > > im trying to get a Hauppauge HVR-4400 working on a Debian squeeze. It
> seems to
> > > be unsopported yet. Is there any driver which i don't know about?
> > 
> > There is no support currently for that card, and since it uses a
> > demodulator for which there is not currently a driver, much more work
> > will be required than simply adding a new board profile.
> > 
> > Devin
> > 
> 
> Well, DVB-S/S2 seems to be finally supported using a current kernel (3.11).
>
> But the card has multiple tuners (DVB-T/C and analogue as well) which are
> not recognized.
> 
> Is there any information I can give you to help support this card?

Ok, that DVB-C part was crap, there's no such tuner onboard. But there's
an analogue tuner onboard which seems to be recognized by the current
kernel:

[...]
[    2.894012] tveeprom 9-0050: Hauppauge model 121029, rev B2F5,
serial# 7264773
[    2.894014] tveeprom 9-0050: MAC address is 00:0d:fe:6e:da:05
[    2.894015] tveeprom 9-0050: tuner model is NXP 18271C2 (idx 155,
type 54)
[    2.894016] tveeprom 9-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L')
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    2.894017] tveeprom 9-0050: audio processor is CX23888 (idx 40)
[    2.894018] tveeprom 9-0050: decoder processor is CX23888 (idx 34)
[    2.894019] tveeprom 9-0050: has radio, has IR receiver, has no IR
transmitter
[    2.894020] cx23885[0]: warning: unknown hauppauge model #121029
[    2.894021] cx23885[0]: hauppauge eeprom: model=121029
[    2.894022] cx23885_dvb_register() allocating 1 frontend(s)
[...]


But I have no video device listed under /dev.

Is there any information on the analogue tuner and how to get it working
or some information on how to start write a driver?
I would like to try to put something together - probably killing the
card. ;-)

Any help and information on that topic is appreciated!

Kind regards
Christoph

