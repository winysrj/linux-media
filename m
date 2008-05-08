Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m480aOoj031652
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 20:36:24 -0400
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m480aA50019684
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 20:36:11 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	Frederic CAND <frederic.cand@anevia.com>
In-Reply-To: <48222094.2020200@t-online.de>
References: <200805071436.03569.maximlevitsky@gmail.com>
	<48222094.2020200@t-online.de>
Content-Type: text/plain
Date: Thu, 08 May 2008 02:35:32 +0200
Message-Id: <1210206932.3136.33.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Video-4l-list <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [BUG] sound is unmuted by default with 2.6.26-rc1 on my
	FlyVideo 2000
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


Am Mittwoch, den 07.05.2008, 23:35 +0200 schrieb Hartmut Hackmann:
> Hi, Maxim
> 
> Maxim Levitsky schrieb:
> > Hi,
> > 
> > I was very busy, thus I didn't follow kernel development lately.
> > I skipped whole 2.6.25 cycle.
> > 
> > Now I have a bit more free time, so I updated kernel to 2.6.25, and then
> > to latest -git.
> > 
> > In latest git I noticed that sound output of my TV card is unmuted by default.
> > 
> > commit 7bff4b4d3ad2b9ff42b4087f409076035af1d165, clears all GPIO lines,
> > and on my card mute is implemented with external chip which is connected via GPIO,
> > and this results in the above bug.
> > 
> > The code that clears all gpios executed last, thus it undoes the saa7134_tvaudio_setmute
> > in saa7134_video_init2.
> > 
> > moving saa7134_tvaudio_setmute after gpio clearing doesn't help, bacause this function is
> > "smart" thus it remembers last mute state and touches the hardware only if this state changes.
> > (And first time it is called from video_mux, thus explict call from saa7134_video_init2 isn't necessary I think)
> > 
> > I once had trouble with this thing, when wrote the resume code, thus I added a flag (dev->insuspend
> > that made this function set mute state always when set.
> > (This is a bit hackish, but I had to use this flag anyway in other places, so I decided that this is ok)
> > 
> > I could remove this "smart" check, but I tested and found that this function is called qute often from tvaudio thread, and thus this check probably is correct.
> > 
> > 
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> 
> Hm, it clears the gpios defined in the gpiomask, not all...
> But i see the problem.
> The conflict is that on many recent hybrid cards, gpios are used to switch between
> analog and digital mode. And these need to be in a defined state even when analog
> mode never was activated. This was a bug.
> I am not sure yet but for me things look like we need the gpio initialization only
> at the first start and we can do this earlier.
> 
> Hartmut
> 

Hi,

Maxim is on a saa7130 only, but that helped to notice that problem,
since I don't have a saa7130 in use.

On all other saa713x we can avoid that failing mute, switching mute to
amux TV, or recent tuners go off, but not on that one, really depending
on the external analog mux gpio settings or faking mute_on by switching
to some unused input, but all in use here.

Unfortunately, Maxim then also can't comment much on lost stereo audio
on SECAM sub-standards we might have to deal with, since he only has
that tuner MONO output.

So, for now, I assume SECAM stereo is broken on 2.6.26.
Any reports are welcome with tuner and audio_debug enabled.

Anyone else seeing the implications not to be able to set the tuner type
independently from what is defined in the card's entry over hundreds of
devices anymore or did I miss something?

I was out door last days, but the saa7134 empress on SECAM_L is also
related to it. There is progress on latest, the oops on empress_querycap
doesn't happen anymore, remaining issues are like on 2.6.12 and now
clearly unsupported device specific on my side, since Frederic went
through some tests. Thanks! 

With multiple cards installed, the empress still reports at least a
wrong PCI device, what was my first assumption causing problems, but
hidden behind other stuff. The ioctls do work through the layer again.

Cheers,
Hermann










--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
