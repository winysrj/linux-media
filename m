Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:42733 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757157AbZCFANc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 19:13:32 -0500
Subject: Re: [linux-dvb] (no subject) - in fact Amiga OS4 and v4l-dvb
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <BLU137-W38DAAEF52124F0FB7ACA7082A40@phx.gbl>
References: <BLU137-W38DAAEF52124F0FB7ACA7082A40@phx.gbl>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 01:14:54 +0100
Message-Id: <1236298494.16392.53.camel@pc09.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Am Donnerstag, den 05.03.2009, 19:04 +0100 schrieb lars ouff:
> Hello, I am looking into the possibility of porting or writing a
> simple driver for the DVB-T part of the SAA7135 chip. I am merely
> doing some research for an eventual long-term hobby programming
> project.
> I have a little programming experience but have friends that are more
> experienced that will help. The driver will be for the AmigaOS4
> platform (PowerPC).

hmm, I know quite nothing about the recent Amiga OS4, but the GNU/Linux
saa7134 driver supports saa7130/34/33/35 and saa7131e PCI brigdes
currently. For DVB-T and DVB-S we rely on the dvb subsystem.

For almost all current silicon tuners and demodulators you will need
NDAs for register programming details too. (some Freescale support with
open specs was just added)

Given that the PCI interface seems to vanish soon on recent PCs,
depending on how long-term your efforts might be, you might end up
without any such devices on the markets anymore. The work on Linux
support started in 2002.

> The reason I'm mailing this list is to maybe get some help with where
> to start and what is needed. I read in the PDF for the chip that there
> is an SDK available for 3rd parties, is this freely available online?

As far I know there is still nothing freely available for the
programming details.

>  (I've mailed Gigabyte about it but don't expect swift response).
> I also read something about an alternative API for non Win systems.
> Amiga devs told me that writing a new driver will be the thing to do
> and not try to port a linux driver, comments? I'm asuming there is a
> ppc-linux driver? I've read some threads about the support for this
> chip in the linux world and it seems good. For decoding in AmigaOS4 we
> have ffmpeg and libfaad.
> 
> ______________________________________________________________________
Why reinvent the wheel when others already did the work and it is Open
Source? 

With the hidden auto detected devices the driver currently supports
about two hundred different PCI cards. We also support almost all tuners
currently on the markets also vbi/cc, external analog inputs and radio
and soon RDS. Also some cards with mpeg encoders. This was only possible
with our active community and people willing to help to add support for
new stuff and it is an still ongoing process.

You can use Linux PPC, maybe just CD/DVD live media or boot it from some
Flash media to have a try, if you already have some supported hardware.

I suggest to use xine/kaffeine for a painless try with GUI, but you must
take care to have the codecs distributions can't provide, but are legal
for individual use.

The Amiga devs probably have good reasons to suggest to write a new
driver, but I don't know about any details. Unfortunately linux-dvb is
not easy portable for Open Source m$ projects too, but our code is
there ;)

Maybe some at home in both worlds can give better pointers or you must
raise more detailed questions. For me CP/M was still good enough during
all that ...

Cheers,
Hermann





