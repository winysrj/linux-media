Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7JHrJbE022991
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 13:53:19 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.226])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7JHrHro008070
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 13:53:17 -0400
Received: by rv-out-0506.google.com with SMTP id f6so123884rvb.51
	for <video4linux-list@redhat.com>; Tue, 19 Aug 2008 10:53:16 -0700 (PDT)
Message-ID: <2df568dc0808191053y2edcf62dode0c88b89f66397d@mail.gmail.com>
Date: Tue, 19 Aug 2008 11:53:16 -0600
From: "Gordon Smith" <spider.karma+video4linux-list@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <2df568dc0808191016w4c45f3a9lf70ef62a80198e2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2df568dc0808181516g49377e0fj73c104696d8616d4@mail.gmail.com>
	<1219112190.4107.5.camel@pc10.localdom.local>
	<2df568dc0808191016w4c45f3a9lf70ef62a80198e2e@mail.gmail.com>
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

On Tue, Aug 19, 2008 at 11:16 AM, Gordon Smith
<spider.karma+video4linux-list@gmail.com> wrote:
>
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
>
> >
> > Are you using a known card, which is assumed to be supported and which
> > tuner is on it?
>
> I have a RTD Technologies VFG7350 that has been supported for some
> time. I don't think there is a tuner, we use camera feeds for input.
>
> >
> > Did you try the recent v4l-dvb and maybe use qv4l2 to control the
> > devices?
>
> I'm not up to speed on DVB, but this card isn't on the supported
> hardware list and as far as I can guess, it never will be since it
> does not have digital input?
>

I now see V4L2 must be a part of v4l-dvb.

> I can see if qv4l2 functions with this card.
>
> >
> > Cheers,
> > Hermann
> >
> >
> >
> >
> > --
> > video4linux-list mailing list
> > Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
