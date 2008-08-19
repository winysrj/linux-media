Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7JKoEOJ018418
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 16:50:15 -0400
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7JKo3Sj008586
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 16:50:03 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Gordon Smith <spider.karma+video4linux-list@gmail.com>
In-Reply-To: <2df568dc0808191016w4c45f3a9lf70ef62a80198e2e@mail.gmail.com>
References: <2df568dc0808181516g49377e0fj73c104696d8616d4@mail.gmail.com>
	<1219112190.4107.5.camel@pc10.localdom.local>
	<2df568dc0808191016w4c45f3a9lf70ef62a80198e2e@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 22:49:35 +0200
Message-Id: <1219178975.5621.39.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: saa7134_empress hang on close()
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


Am Dienstag, den 19.08.2008, 11:16 -0600 schrieb Gordon Smith:
> On Mon, Aug 18, 2008 at 8:16 PM, hermann pitton <hermann-pitton@arcor.de> wrote:
> >
> > Hi Gordon,
> >
> > Am Montag, den 18.08.2008, 16:16 -0600 schrieb Gordon Smith:
> > > Hello -
> > >
> > > I have a saa7134 based video capture card running in kernel
> > > 2.6.24.4(gentoo). I can view raw and compressed video on both channels
> > > of the card
> > > using xawtv and mplayer.
> > >
> > > However, any program reading a compressed stream that attempts to exit,
> > > hangs and is unkillable. This includes cat, mplayer, and the example V4L2
> > > program capture.c.
> > >
> > > I removed capture code from capture.c (because, unlike mplayer, it doesn't
> > > capture) and left only open() and close() and found that it hangs on
> > > close().
> > >
> > > Any thoughts on how I might solve this problem?
> > >
> >
> > you might have seen the ongoing debugging and improvements to get the
> > saa7134-empress back and better.
> 
> I have seen some recent activity, but didn't know it was altogether
> broken, if that is what you are saying. Is there a searchable archive
> of this list? I've been unable to find one.

Most of us don't have functional empress cards and so it happens that
for long periods of time new code might stay untested since such devices
seem to be fairly rare.

At least it was broken after the ioctl2 conversion of saa7134 and the
later conversion of saa7134-empress had some more troubles too. These
have been addressed then by Dmitri Belimov who is trying to get a new
card up and Hans Verkuil later too.

The first who noticed some problems was Frederic Cand at the linux-dvb
ML and we found some so far last working version.

http://linuxtv.org/pipermail/linux-dvb/2008-May/025910.html

The snapshot there before the ioctl2 conversion did also make sure in
this case to be able to force SECAM-L to have sound. This was lost for a
while too, but was fixed by Hans later and is back now.

For searchable archives you can try
http://marc.info/?l=linux-video&r=1&b=200808&w=2
or
http://www.spinics.net/lists

and there are more, but the linux-dvb ML with Frederic starting in June
and marc.info with a good search engine should find all so far.

> >
> > Are you using a known card, which is assumed to be supported and which
> > tuner is on it?
> 
> I have a RTD Technologies VFG7350 that has been supported for some
> time. I don't think there is a tuner, we use camera feeds for input.

That's fine. The card should be auto detected and is supported.
Four Composite and two S-Video inputs and empress encoder, no tuner.

> >
> > Did you try the recent v4l-dvb and maybe use qv4l2 to control the
> > devices?
> 
> I'm not up to speed on DVB, but this card isn't on the supported
> hardware list and as far as I can guess, it never will be since it
> does not have digital input?

As you noticed already, has nothing to do with linux-dvb, but has
support under video4linux with the saa7134 driver. We share stuff under
v4l-dvb these days because of the huge amount of hybrid devices.

> I can see if qv4l2 functions with this card.

Looks quite comfortable and improved with recent v4l-dvb from
linuxtv.org. Dmitry got his new card working now and I don't have any
fully supported yet, my test abilities are very limited therefore.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
