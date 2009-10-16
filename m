Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:49472 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038AbZJPWBU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 18:01:20 -0400
Subject: Re: tuner type
From: hermann pitton <hermann-pitton@arcor.de>
To: avalone@web.de
Cc: linux-media@vger.kernel.org
In-Reply-To: <1309684974@web.de>
References: <1309684974@web.de>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 17 Oct 2009 00:00:30 +0200
Message-Id: <1255730430.3319.31.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dirk,

Am Freitag, den 16.10.2009, 10:32 +0200 schrieb avalone@web.de:
> Thanks alot, Herman.
> What does ctx mean? I use opensuse 11.0.

you will find the CTX (Creatix) revision and version printed on the
board and also on a sticker on the card, mostly at the modem or ISDN
part. With that information and the second and third line printed on the
tuner, I should know which card you have.

Do you have it in an original blue MSI/Medion PCI slot.
At least variants with the Cologne ISDN chip (Kölner Dom Pictogramm) are
close to impossible to become stable in regular PCI slots.

They all have the same PCI subsystem, I have six different cards alone,
and we just detect the three different tuner types over the eeprom
content, since all other inputs are the same.

DVB-T support started with CTX917, 918 and 921 cardbus.
 
> So you say, it's not tuner=5 and not 63. So something in between?

If you read on the second line of the tuner label FM1216ME/I H-3, I
expect yours is from Singapore, others are from Indonesia etc ..., it is
a tuner=38. MK3 MultiEurope with tda9887. Works from Portugal/Ireland to
Vladivostok.

> I tired 51, if I remember it right. It worked, but sometimes there were muting breakes in between, but maybe it's just my vcr. 
> Can you name me a lightweight capture program? Maybe even something where you can adjust bitrate and container format? Best would be a command-line program.
> Thanks alot.
> ps. I'm from Germany, so maybe it's a german tuner?
> 
> best regards,
> 
> Dirk

On 2.6.25 and 2.6.26 were several known bugs introduced. First the user
could not set the detailed TV subnorm anymore, then the user was not
able to force a tuner type anymore and also the eeprom detection of the
tuner on the saa7134 was broken.

Further, if tuner stuff was not build as modules, there was an oops and
I'm still aware of more, but not related to your tuner.

This is all fixed, but it would take me time, to check how far it made
it into old distro kernels and stable vanilla revisions.

Try with at least 2.6.27 or compile current v4l-dvb and remove/backup
your old media modules folder. Currently you need at least a 2.6.26 to
compile latest.

Cheers,
Hermann


