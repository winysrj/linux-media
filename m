Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:55291 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754576AbZBUBh3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 20:37:29 -0500
Subject: Re: mantis build error on vanilla kernel 2.6.28.6 [Re: Terratec
	Cinergy C HD (PCI, DVB-C): how to make it work?]
From: hermann pitton <hermann-pitton@arcor.de>
To: MartinG <gronslet@gmail.com>
Cc: Linux Media <linux-media@vger.kernel.org>
In-Reply-To: <bcb3ef430902201606k50fe3036j8f82c3eecb6e2a47@mail.gmail.com>
References: <bcb3ef430902201229l2ece1a88k50d15e3886c29e01@mail.gmail.com>
	 <1235172135.6647.4.camel@pc10.localdom.local>
	 <bcb3ef430902201606k50fe3036j8f82c3eecb6e2a47@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 21 Feb 2009 02:38:31 +0100
Message-Id: <1235180311.6647.21.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Samstag, den 21.02.2009, 01:06 +0100 schrieb MartinG:
> On Sat, Feb 21, 2009 at 12:22 AM, hermann pitton
> <hermann-pitton@arcor.de> wrote:
> > you can see changes on saa7134-alsa here.
> > http://linuxtv.org/hg/v4l-dvb/log/359d95e1d541/linux/drivers/media/video/saa7134/saa7134-alsa.c
> >
> > Likely this kernel backport is missing.
> > http://linuxtv.org/hg/v4l-dvb/rev/b4d664a2592a
> 
> Thank you for your reply!
> 
> I think I got it working, thanks to you. This is what I did (on the
> vanilla 2.6.28.6 kernel):
> $ cd mantis-5292a47772ad/
> $ make distclean clean
> $ cp v4l/saa7134-alsa.c  v4l/saa7134-alsa.c.orig
> $ emacs -nw v4l/saa7134-alsa.c
> Patch according to:
> http://linuxtv.org/hg/v4l-dvb/diff/b4d664a2592a/linux/drivers/media/video/saa7134/saa7134-alsa.c
> $ make -j2
> (works)
> 
> # make install
> 
> remove all other (dvb) modules
> 
> # modprobe mantis
> 
> This gave me at least
> /dev/dvb/adapter0/{demux0,dvr0,frontend0,net0}
> 
> But then the computer froze when I did:
> # scandvb dvb-apps/util/scan/dvb-c/no-Oslo-Get
> scanning dvb-apps/util/scan/dvb-c/no-Oslo-Get
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 241000000 6900000 0 5
> initial transponder 272000000 6900000 0 5
> initial transponder 280000000 6900000 0 5
> initial transponder 290000000 6900000 0 5
> initial transponder 298000000 6900000 0 5
> initial transponder 306000000 6900000 0 5
> initial transponder 314000000 6900000 0 5
> initial transponder 322000000 6900000 0 5
> initial transponder 330000000 6900000 0 5
> initial transponder 338000000 6900000 0 5
> initial transponder 346000000 6900000 0 5
> initial transponder 354000000 6900000 0 5
> initial transponder 362000000 6900000 0 5
> initial transponder 370000000 6900000 0 5
> initial transponder 378000000 6900000 0 5
> initial transponder 386000000 6900000 0 5
> initial transponder 394000000 6900000 0 5
> initial transponder 410000000 6900000 0 5
> initial transponder 442000000 6952000 0 5
> initial transponder 482000000 6900000 0 5
> initial transponder 498000000 6900000 0 5
> >>> tune to: 241000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
> 
> (total freeze here, not even ssh access to the box)
> 
> I think I had the scandvb tool from a binary install, maybe I'll try
> to compile from sources.
> And I'll try to read some more docs.
> 
> Thank you for helping me out on this!
> 
> -MartinG

I am sorry for that.

To give an example.

If we are seated in a chair looking to the wall in front of us or better
to the horizon in the height of our eyes, without moving our eyes we can
see something like 180 degrees horizontally.

If we move our eyes we can see already a lot in our backs, if we move
our heads we can see already almost all in our backs, to move the body
is a further step only taken if really needed.

Now, from the first just sitting there, the vertical reception is a
little different, at least for me. Without moving the eyes we can see
our feet, not that sharp, but enough to be aware of.

In the upper direction it seems to be a little bit different, only the
half of what is present on the bottom is visible without moving ...

This seems to be a part of the conditio humanum we share with others :)

It is the same with out of kernel drivers.

Await Manu's instructions what to use for testing and if a 2.6.28 is
safe.

Cheers,
Hermann


