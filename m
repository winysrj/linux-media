Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QEwfl0017466
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 10:58:41 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4QEwOCv002460
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 10:58:25 -0400
Received: by ug-out-1314.google.com with SMTP id s2so455124uge.6
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 07:58:24 -0700 (PDT)
Date: Mon, 26 May 2008 16:58:30 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080526145830.GA22459@ska.dandreoli.com>
References: <20080525020028.GA22425@ska.dandreoli.com>
	<20080526073959.5a624288@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526073959.5a624288@gaivota>
Cc: Linux Driver Developers <devel@driverdev.osuosl.org>,
	video4linux-list@redhat.com
Subject: Re: TW6800 based video capture boards
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Mon, May 26, 2008 at 07:39:59AM -0300, Mauro Carvalho Chehab wrote:
> On Sun, 25 May 2008 04:00:28 +0200 Domenico Andreoli <cavokz@gmail.com> wrote:
> 
> >   I have some shining boards based on Techwell TW6802 and a "working"
> > V4L2 driver provided by the producer. Ah.. I have also the specs of
> > those TW6802 chips. Everything has been purchased by my employer.
> > 
> > Now I am eager to publish everything but I can't right now. My employer
> > would not understand and I would be in a difficult position. He already
> > knows that those drivers are based on GPL software and then _are_ GPL
> > at all the effects but he still needs to completely understand how it
> > works. Those guys are always happy to use Linux for free but at the
> > time of giving anything back...
> > 
> > To make the long story short, I want to rewrite them. So, how do
> > you judge my (legal) position? Yes, you are not a lawyer but I would
> > appreciate any related advice anyway ;)
> 
> I think this will depend if you have a signed NDA or not, and what are their
> terms. Better to consult a lawyer ;)

No NDA has been signed by me but I still do not know all the details
of the agreement.

In the meanwhile I am cleaning the "patch" trying to reduce noise and
hoping to not break anything. This also helps me to dig into their changes.

> > Since I am a kernel newbie I am expecting to receive lots of "leave
> > V4L2 to expert coders..." but I will try anyway. You are warned :)
> 
> Just do your work and submit us the code. We'll analyze it and point for
> issues, if needed ;) If you have any doubts about V4L2, I can help you.

The given driver is not a patch but a zip of the modified bt8xx directory
taken from 2.6.18. Their changes do not integrate with existing bttv
driver, which has been cannibalized as if one would use V4L only with
their cards. You want a different kernel version, you unzip the driver
in the new tree, easy.

These TW6800 chips must somewhat resemble Bt848/878, the given driver
is based on bttv. Anyway they differ in many points, some are trivial
changes while other are more substantial. My impression is that the
design of TW6800 shares some points with the one of Bt848 but it is
fundamentally a different beast.

If support to TW6800 has to be provided in the bttv driver, it seem the
most logical choice at the first glance, the bttv's framework needs to
be changed accordingly.

For instance, in bttv-gpio.c those few helper function work with
registers at a different location, everything else is left as the
original bttv driver. So supposing to provide and additional set of
functions specific to TW6800 they should be called instead of the
original generic bttv Bt848 ones ony for TW6800 cards at runtime. A
new bttv_ops entry, if anything like this exists.

I have also some thoughts for bttv-risc.c. What is it? It is used
to generate any RISC op-codes to be downloaded on the board? It seem
responsible for DMA operations.

There is the biggest chunk of changes in bttv-driver.c but I still have
to dig into it.

Finally, the bttv driver needs a restyle for V4L2, right? So it would
be a shame to use it to fork the TW6800 support, wouldn't it? Which
are the plans here?

I have a strong interest in this area, I am available to test any patch.

Regards,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
