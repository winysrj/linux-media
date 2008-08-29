Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KZBxj-0005lC-4K
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 23:57:00 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6D00KV1U9XU340@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 29 Aug 2008 17:56:22 -0400 (EDT)
Date: Fri, 29 Aug 2008 17:56:21 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <e32e0e5d0808291401x39932ab6q6086882e81547f84@mail.gmail.com>
To: Tim Lucas <lucastim@gmail.com>
Message-id: <48B87085.6050800@linuxtv.org>
MIME-version: 1.0
References: <e32e0e5d0808291401x39932ab6q6086882e81547f84@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
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
> Mijhail Moreyra wrote:
>  > Steven Toth wrote:
>  >> Mijhail Moreyra wrote:
>  >>> Steven Toth wrote:
>  >>>> Mijhail,
>  >>>>
>  >>>> http://linuxtv.org/hg/~stoth/cx23885-audio 
> <http://linuxtv.org/hg/%7Estoth/cx23885-audio>
>  >>>>
>  >>>> This tree contains your patch with some minor whitespace cleanups
>  >>>> and fixes for HUNK related merge issues due to the patch wrapping at
>  >>>> 80 cols.
>  >>>>
>  >>>> Please build this tree and retest in your environment to ensure I
>  >>>> did not break anything. Does this tree still work OK for you?
>  >>>>
>  >>>> After this I will apply some other minor cleanups then invite a few
>  >>>> other HVR1500 owners to begin testing.
>  >>>>
>  >>>> Thanks again.
>  >>>>
>  >>>> Regards,
>  >>>>
>  >>>> Steve
>  >>>
>  >>> Hi, sorry for the delay.
>  >>>
>  >>> I've tested the http://linuxtv.org/hg/~stoth/cx23885-audio 
> <http://linuxtv.org/hg/%7Estoth/cx23885-audio> tree and
>  >>> it doesn't work well.
>  >>>
>  >>> You seem to have removed a piece from my patch that avoids some 
> register
>  >>> modification in cx25840-core.c:cx23885_
> initialize()
>  >>>
>  >>> -       cx25840_write(client, 0x2, 0x76);
>  >>> +       if (state->rev != 0x0000) /* FIXME: How to detect the bridge
>  >>> type ??? */
>  >>> +               /* This causes image distortion on a true cx23885
>  >>> board */
>  >>> +               cx25840_write(client, 0x2, 0x76);
>  >>>
>  >>> As the patch says that register write causes a horrible image 
> distortion
>  >>> on my HVR-1500 which has a real cx23885 (not 23887, 23888, etc) board.
>  >>>
>  >>> I don't know if it's really required for any bridge as everything seems
>  >>> to be auto-configured by default, maybe it can be simply dropped.
>  >>>
>  >>> Other than that the cx23885-audio tree works well.
>  >>>
>  >>> WRT the whitespaces, 80 cols, etc; most are also in the sources I took
>  >>> as basis, so I didn't think they were a problem.
>  >>
>  >> That's a mistake, I'll add that later tonight, thanks for finding
>  >> this. I must of missed it when I had to tear apart your email because
>  >> of HUNK issues caused by patch line wrapping.
>  >>
>  >> Apart from this, is everything working as you expect?
>  >>
>  >> Regards,
>  >>
>  >> Steve
>  >>
>  >>
>  >
>  > OK.
>  >
>  > And sorry about the patch, I didn't know it was going to be broken that
>  > way by being sent by email.
>  >
>  >  >> Other than that the cx23885-audio tree works well.
>  >
> 
>  > Great, thanks for confirming.
> 
>  > Regards,
> 
>  > Steve
> 
> I'll try asking again since my replies in gmail were not including the 
> correct subject heading.
> Can this code for cx23885 analog support be adapted for the DViCO Fusion 
> HDTV7 Dual Express which also uses the cx23885?  Currently the driver 
> for that card is digital only and I am stuck with a free antiquated 
> large satellite system that is analog only in my apartment. I am willing 
> to put in the work if someone can point me in the right direction.  
> Thank you,

Wait until I get a chance to merge the cx25840 fix late tonight. Watch 
the stoth/cx23885-audio tree for a cx25840 fix appearing, then test the 
driver. Look in the driver, find the correct card=N option for the 
HVR1500 and load the driver on your system with that option .... then 
try analog.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
