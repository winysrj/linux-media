Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KZv2c-0000wy-7S
	for linux-dvb@linuxtv.org; Mon, 01 Sep 2008 00:05:04 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6H00A5HJZFG1E0@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 31 Aug 2008 18:04:28 -0400 (EDT)
Date: Sun, 31 Aug 2008 18:04:27 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <e32e0e5d0808301456v4b5ca363l5a121b426438bd64@mail.gmail.com>
To: Tim Lucas <lucastim@gmail.com>, linux-dvb <linux-dvb@linuxtv.org>
Message-id: <48BB156B.4070609@linuxtv.org>
MIME-version: 1.0
References: <e32e0e5d0808291401x39932ab6q6086882e81547f84@mail.gmail.com>
	<48B87085.6050800@linuxtv.org> <48B8972A.3020501@linuxtv.org>
	<e32e0e5d0808301411w1ae01563y65ce27d6c43e2beb@mail.gmail.com>
	<e32e0e5d0808301456v4b5ca363l5a121b426438bd64@mail.gmail.com>
Subject: Re: [linux-dvb] [PATCH] cx23885 analog TV and audio support for
 HVR-1500
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Tim Lucas wrote:
> On Sat, Aug 30, 2008 at 2:11 PM, Tim Lucas <lucastim@gmail.com 
> <mailto:lucastim@gmail.com>> wrote:
> 
>     On Fri, Aug 29, 2008 at 5:41 PM, Steven Toth <stoth@linuxtv.org
>     <mailto:stoth@linuxtv.org>> wrote:
> 
>         Steven Toth wrote:
> 
>             Tim Lucas wrote:
> 
>                 Mijhail Moreyra wrote:
>                  > Steven Toth wrote:
>                  >> Mijhail Moreyra wrote:
>                  >>> Steven Toth wrote:
>                  >>>> Mijhail,
>                  >>>>
>                  >>>> http://linuxtv.org/hg/~stoth/cx23885-audio
>                 <http://linuxtv.org/hg/%7Estoth/cx23885-audio>
>                  >>>>
>                  >>>> This tree contains your patch with some minor
>                 whitespace cleanups
>                  >>>> and fixes for HUNK related merge issues due to the
>                 patch wrapping at
>                  >>>> 80 cols.
>                  >>>>
>                  >>>> Please build this tree and retest in your
>                 environment to ensure I
>                  >>>> did not break anything. Does this tree still work
>                 OK for you?
>                  >>>>
>                  >>>> After this I will apply some other minor cleanups
>                 then invite a few
>                  >>>> other HVR1500 owners to begin testing.
>                  >>>>
>                  >>>> Thanks again.
>                  >>>>
>                  >>>> Regards,
>                  >>>>
>                  >>>> Steve
>                  >>>
>                  >>> Hi, sorry for the delay.
>                  >>>
>                  >>> I've tested the
>                 http://linuxtv.org/hg/~stoth/cx23885-audio
>                 <http://linuxtv.org/hg/%7Estoth/cx23885-audio> tree and
>                  >>> it doesn't work well.
>                  >>>
>                  >>> You seem to have removed a piece from my patch that
>                 avoids some register
>                  >>> modification in cx25840-core.c:cx23885_
>                 initialize()
>                  >>>
>                  >>> -       cx25840_write(client, 0x2, 0x76);
>                  >>> +       if (state->rev != 0x0000) /* FIXME: How to
>                 detect the bridge
>                  >>> type ??? */
>                  >>> +               /* This causes image distortion on
>                 a true cx23885
>                  >>> board */
>                  >>> +               cx25840_write(client, 0x2, 0x76);
>                  >>>
>                  >>> As the patch says that register write causes a
>                 horrible image distortion
>                  >>> on my HVR-1500 which has a real cx23885 (not 23887,
>                 23888, etc) board.
>                  >>>
>                  >>> I don't know if it's really required for any bridge
>                 as everything seems
>                  >>> to be auto-configured by default, maybe it can be
>                 simply dropped.
>                  >>>
>                  >>> Other than that the cx23885-audio tree works well.
>                  >>>
>                  >>> WRT the whitespaces, 80 cols, etc; most are also in
>                 the sources I took
>                  >>> as basis, so I didn't think they were a problem.
>                  >>
>                  >> That's a mistake, I'll add that later tonight,
>                 thanks for finding
>                  >> this. I must of missed it when I had to tear apart
>                 your email because
>                  >> of HUNK issues caused by patch line wrapping.
>                  >>
>                  >> Apart from this, is everything working as you expect?
>                  >>
>                  >> Regards,
>                  >>
>                  >> Steve
>                  >>
>                  >>
>                  >
>                  > OK.
>                  >
>                  > And sorry about the patch, I didn't know it was going
>                 to be broken that
>                  > way by being sent by email.
>                  >
>                  >  >> Other than that the cx23885-audio tree works well.
>                  >
> 
>                  > Great, thanks for confirming.
> 
>                  > Regards,
> 
>                  > Steve
> 
>                 I'll try asking again since my replies in gmail were not
>                 including the correct subject heading.
>                 Can this code for cx23885 analog support be adapted for
>                 the DViCO Fusion HDTV7 Dual Express which also uses the
>                 cx23885?  Currently the driver for that card is digital
>                 only and I am stuck with a free antiquated large
>                 satellite system that is analog only in my apartment. I
>                 am willing to put in the work if someone can point me in
>                 the right direction.  Thank you,
> 
> 
>             Wait until I get a chance to merge the cx25840 fix late
>             tonight. Watch the stoth/cx23885-audio tree for a cx25840
>             fix appearing, then test the driver. Look in the driver,
>             find the correct card=N option for the HVR1500 and load the
>             driver on your system with that option .... then try analog.
> 
> 
>         Tim,
> 
>         The audio fix has now been applied to
>         http://linuxtv.org/hg/~stoth/cx23885-audio.
> 
>         Try loading the card as the HVR1500 and see what happens.
> 
>         Mijhail, if you could download and compile the cx23885-audio
>         tree one more time I would be grateful.
> 
>         Regards,
> 
>         Steve
> 
> 
>     OK, this may seem silly, but I'm not sure how to load the driver for
>     that card.  I think I need to edit /etc/modprobe.d/options and add
>     the line cx23885 card=6, but it still autodetected my dvico card.
>      Is there something else I need to do?  Thanks for your help.
> 
>          --Tim
> 
> 
> I forgot the word options in front of cx23385 card=6.  Now I get the 
> following when I run dmesg
> 
> 30.865821] CORE cx23885[0]: subsystem: 18ac:d618, board: Hauppauge 
> WinTV-HVR1500 [card=6,insmod option]
> [   31.130230] cx23885[0]: i2c bus 0 registered
> [   31.130250] cx23885[0]: i2c bus 1 registered
> [   31.130269] cx23885[0]: i2c bus 2 registered
> [   31.156635] tveeprom 2-0050: Encountered bad packet header [ff]. 
> Corrupt or not a Hauppauge eeprom.
> [   31.156637] cx23885[0]: warning: unknown hauppauge model #0
> [   31.156639] cx23885[0]: hauppauge eeprom: model=0
> [   31.305018] cx23885[0]: cx23885 based dvb card
> [   31.345882] cx23885[0]: frontend initialization failed
> [   31.345884] cx23885_dvb_register() dvb_register failed err = -1
> [   31.345886] cx23885_dev_setup() Failed to register dvb on VID_C
> [   31.345889] cx23885_dev_checkrevision() Hardware revision = 0xb0
> [   31.345895] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 21, 
> latency: 0, mmio: 0xfd800000
> 
> I suppose I need to do something else to get the driver to load correctly.

No, that's loaded fine.

Ignore the digital VIDC attach errors. How is analog TV working?

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
