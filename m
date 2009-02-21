Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:39643 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbZBUAGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 19:06:46 -0500
Received: by bwz5 with SMTP id 5so3141428bwz.13
        for <linux-media@vger.kernel.org>; Fri, 20 Feb 2009 16:06:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1235172135.6647.4.camel@pc10.localdom.local>
References: <bcb3ef430902201229l2ece1a88k50d15e3886c29e01@mail.gmail.com>
	 <1235172135.6647.4.camel@pc10.localdom.local>
Date: Sat, 21 Feb 2009 01:06:44 +0100
Message-ID: <bcb3ef430902201606k50fe3036j8f82c3eecb6e2a47@mail.gmail.com>
Subject: Re: mantis build error on vanilla kernel 2.6.28.6 [Re: Terratec
	Cinergy C HD (PCI, DVB-C): how to make it work?]
From: MartinG <gronslet@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 21, 2009 at 12:22 AM, hermann pitton
<hermann-pitton@arcor.de> wrote:
> you can see changes on saa7134-alsa here.
> http://linuxtv.org/hg/v4l-dvb/log/359d95e1d541/linux/drivers/media/video/saa7134/saa7134-alsa.c
>
> Likely this kernel backport is missing.
> http://linuxtv.org/hg/v4l-dvb/rev/b4d664a2592a

Thank you for your reply!

I think I got it working, thanks to you. This is what I did (on the
vanilla 2.6.28.6 kernel):
$ cd mantis-5292a47772ad/
$ make distclean clean
$ cp v4l/saa7134-alsa.c  v4l/saa7134-alsa.c.orig
$ emacs -nw v4l/saa7134-alsa.c
Patch according to:
http://linuxtv.org/hg/v4l-dvb/diff/b4d664a2592a/linux/drivers/media/video/saa7134/saa7134-alsa.c
$ make -j2
(works)

# make install

remove all other (dvb) modules

# modprobe mantis

This gave me at least
/dev/dvb/adapter0/{demux0,dvr0,frontend0,net0}

But then the computer froze when I did:
# scandvb dvb-apps/util/scan/dvb-c/no-Oslo-Get
scanning dvb-apps/util/scan/dvb-c/no-Oslo-Get
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 241000000 6900000 0 5
initial transponder 272000000 6900000 0 5
initial transponder 280000000 6900000 0 5
initial transponder 290000000 6900000 0 5
initial transponder 298000000 6900000 0 5
initial transponder 306000000 6900000 0 5
initial transponder 314000000 6900000 0 5
initial transponder 322000000 6900000 0 5
initial transponder 330000000 6900000 0 5
initial transponder 338000000 6900000 0 5
initial transponder 346000000 6900000 0 5
initial transponder 354000000 6900000 0 5
initial transponder 362000000 6900000 0 5
initial transponder 370000000 6900000 0 5
initial transponder 378000000 6900000 0 5
initial transponder 386000000 6900000 0 5
initial transponder 394000000 6900000 0 5
initial transponder 410000000 6900000 0 5
initial transponder 442000000 6952000 0 5
initial transponder 482000000 6900000 0 5
initial transponder 498000000 6900000 0 5
>>> tune to: 241000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256

(total freeze here, not even ssh access to the box)

I think I had the scandvb tool from a binary install, maybe I'll try
to compile from sources.
And I'll try to read some more docs.

Thank you for helping me out on this!

-MartinG
