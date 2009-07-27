Return-path: <linux-media-owner@vger.kernel.org>
Received: from best-of-bremen.com ([217.160.217.225]:37145 "HELO
	p15135933.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751596AbZG0TgZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2009 15:36:25 -0400
From: Martin Konopka <martin.konopka@mknetz.de>
To: hermann pitton <hermann-pitton@arcor.de>
Subject: Re: Pinnacle PCTV 310i active antenna
Date: Mon, 27 Jul 2009 21:36:19 +0200
References: <200907011701.43079.martin.konopka@mknetz.de> <1246753081.822.16.camel@pc07.localdom.local>
In-Reply-To: <1246753081.822.16.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907272136.19668.martin.konopka@mknetz.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann,

I'm using kernel 2.6.28-11 on a mythbuntu distribution.  I tried to load the 
drivers with the card=50 option and antenna_pwr=1.

[ 8745.007384] saa7133[0]: subsystem: 11bd:002f, board: Pinnacle PCTV 300i 
DVB-T + PAL [card=50,insmod option]
[ 8745.007628] saa7133[0]: board init: gpio is 600c000
[ 8745.007641] saa7133[0]: gpio: mode=0x0008000 in=0x6004000 out=0x0008000 
[pre-init]
[ 8745.148374] tuner' 1-004b: chip found @ 0x96 (saa7133[0])

[..]

[ 8802.196576] dvb_init() allocating 1 frontend
[ 8802.196583] saa7133[0]/dvb: pinnacle 300i dvb setup
[ 8802.196845] mt352_read_register: readreg error (reg=127, ret==-5)
[ 8802.196953] saa7133[0]/dvb: frontend initialization failed

The antenna power is not activated. I then installed microsoft stuff. To my 
horror it turned out that the active antenna switch is greyed out in 
Pinnacle's TV application. 

So the card obviously does not have an active antenna, although the manual 
mentions it. Probably copy and paste from the 300i manual.

Regards,

Martin

Am Sonntag, 5. Juli 2009 02:18:01 schrieben Sie:
> Hi Martin,
>
> Am Mittwoch, den 01.07.2009, 17:01 +0200 schrieb Martin Konopka:
> > Hi all,
> >
> > my Pinnacle 310i is working well with linux, except for the active
> > antenna that is attached to it. I need it in order to watch some weaker
> > channels. Is there any way to activate the antenna power of this card
> > with recent drivers? The Windows software has an option to do that.
>
> on which kernel you are currently?
>
> We have some reports, that what was assumed to be support for an
> additional LNA on it is broken on 2.6.26 and onwards, IIRC.
>
> There are no previous reports for such an active antenna switch for the
> 310i I do believe, but Gerd had such an option for the earlier 300i.
> (card=50)
>
> If you don't have any further details, like gpio settings reported from
> DScaler's regspy, you might try to force the use of that card, nothing
> won't work, but eventually you get voltage to the antenna. ("modinfo
> saa7134-dvb")
>
> Cheers,
> Hermann


