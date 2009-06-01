Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n51N2dAe023716
	for <video4linux-list@redhat.com>; Mon, 1 Jun 2009 19:02:39 -0400
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net
	[151.189.21.54])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n51N2LDT008382
	for <video4linux-list@redhat.com>; Mon, 1 Jun 2009 19:02:21 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: S P <xmisterhu@gmail.com>
In-Reply-To: <745af8a00906011553v69455099j9da74a82754b592c@mail.gmail.com>
References: <745af8a00906011105x7a69b478obbab7c738aaa9e06@mail.gmail.com>
	<4A2433E2.4050807@alstadheim.priv.no>
	<745af8a00906011553v69455099j9da74a82754b592c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 02 Jun 2009 00:49:55 +0200
Message-Id: <1243896595.3719.60.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: saa7134 surveillance
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

Hi,

Am Dienstag, den 02.06.2009, 00:53 +0200 schrieb S P:
> I have 2.6.28 version kernel(The default with ubuntu jaunty). But I
> had checked the documentation of 2.6.29 and saw that the v4l framework
> redesinged a bit...so I have to compile the 2.6.29 kernel to see all
> the cameras? Nice...but I will try.
> Anyway: Thanks for the reply!
> 
> Regards, Peter Sarkozi

that won't help.

We had always support for at least eight saa713x chips.

Do you have four such chips on the board or eight?

Cheers,
Hermann


> 2009/6/1 Håkon Alstadheim <hakon@alstadheim.priv.no>:
> > S P wrote:
> >>
> >> Hi!
> >> I have a surveillance card with saa7134 chips. It should be able to
> >> see 8 cameras at a time, but there is only 4 video devices in /dev of
> >> this card.
> >> These devices are working fine, each device's channel 0(there isn't
> >> any other channel of these devices) is an input for a camera.
> >> So, how could I manage it to be 8 devices?
> >>
> >>
> >
> > Kernel-version ? Newer kernels allow you to set v4l subsystem to "allocate
> > minor device numbers dynamically". This is supposed to allow more than 4
> > devices on a single card, according to the help-text of the 2.6.29 kernel I
> > just compiled.
> >
> > Caveat: All this is from memory, ~24hours old.
> >
> > --
> > Håkon Alstadheim
> > 47 35 39 38
> >
> >
> >
> > --


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
