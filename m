Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3P246gr031063
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 22:04:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3P23tEn001586
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 22:03:55 -0400
Date: Thu, 24 Apr 2008 23:02:48 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Aidan Thornton" <makosoft@googlemail.com>
Message-ID: <20080424230248.27674778@gaivota>
In-Reply-To: <c8b4dbe10804241448x793faf1al7db73de8e0530cf0@mail.gmail.com>
References: <916086.24458.qm@web27912.mail.ukl.yahoo.com>
	<Pine.LNX.4.64.0804240658580.3725@bombadil.infradead.org>
	<c8b4dbe10804241448x793faf1al7db73de8e0530cf0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: em28xx/xc3028: changeset 7651 breaks analog audio?
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

On Thu, 24 Apr 2008 22:48:28 +0100
"Aidan Thornton" <makosoft@googlemail.com> wrote:

> Hi,
> 
> On Thu, Apr 24, 2008 at 12:01 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > On Thu, 24 Apr 2008, Edward J. Sheldrake wrote:
> >
> >
> > >
> > > > Please, try again, with with the enclosed patch. Let's see if stereo
> > > > will work
> > > > on your board.
> > > >
> > > > This should load the IF=6.24 firmware, non-MTS mode.
> > > >
> > >
> >
> >
> > > This did not work, all I could hear was silence, with clicking at 1
> > > second intervals. The clicking stopped after opening and closing
> > > mplayer a few times, but that's another issue.
> > >
> > > I've got a pdf and a small text file of product info (which I can't
> > > find any URLs for), which both say mono audio for analogue, also in
> > > Windows, Mono audio is the only available option, so I think stereo is
> > > not supported.
> > >
> > > Dmesg output attached, it's not loading mts firmware this time.
> > >
> >
> >  Thanks for your help, Edward. I've applied the patch that seems to be the
> > correct one. It will select the MTS firmware, so, only MONO will be
> > available. The proper SCODE table will be loaded.
> >
> >  Btw, it would be nice if you could also test DVB mode. It should be working
> > properly for HVR-900.
> >
> >  Cheers,
> >  Mauro.
> 
> Unfortunately, I think the B3C0 revision uses the drx379x demodulator,
> and AFAIK that's not supported yet - it probably has more in common
> with the Pinnacle 330e than the original revision. (I have the
> original A1C0  HVR-900, which I suspect is based on a reference
> design.)

I've just applied a patch we've received some time ago with drx379x demod. I'm not
sure what's the proper config for Hauppauge.

The drx379x doesn't seem ready for kernel submission. However, since we've
already merged what we have, we can apply this to v4l/dvb and work on it to fix
maybe for 2.6.27.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
