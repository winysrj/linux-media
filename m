Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAENIW6h010987
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 18:18:32 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAENIHQ4003106
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 18:18:17 -0500
Received: by wf-out-1314.google.com with SMTP id 25so1591405wfc.6
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 15:18:16 -0800 (PST)
Message-ID: <d7e40be30811141518w15af2371p15195d2024bc9cb1@mail.gmail.com>
Date: Sat, 15 Nov 2008 10:18:16 +1100
From: "Ben Klein" <shacklein@gmail.com>
To: "Markus Rechberger" <mrechberger@gmail.com>, video4linux-list@redhat.com
In-Reply-To: <d7e40be30811141517p5700f803t731ec578f1cabd59@mail.gmail.com>
MIME-Version: 1.0
References: <491339D9.2010504@personnelware.com> <4913E9DB.8040801@hhs.nl>
	<200811071050.25149.hverkuil@xs4all.nl>
	<20081107161956.c096dd03.ospite@studenti.unina.it>
	<alpine.DEB.1.10.0811071416380.25756@vegas>
	<alpine.DEB.1.10.0811130651170.2643@vegas>
	<d9def9db0811130440t17b05c58q603a14e446e417e5@mail.gmail.com>
	<alpine.DEB.1.10.0811141033000.23321@vegas>
	<d9def9db0811140750s15969a1fh1272402de897944d@mail.gmail.com>
	<d7e40be30811141517p5700f803t731ec578f1cabd59@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: Re: USB Capture device
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

(oops, forgot to send this to the mailing list)

In general, there is no price advantage with getting a capture device
without a tuner. There are at least two reasons for this:

1) Less demand for just a capture device. People want to turn their
computers into idiot boxes

2) Most capture-only cards are (probably) TV tuners with the tuner disabled.
It's cheaper for them to make that way.

I got a cheap-and-nasty USB em28xx that pretty much *just* works, but it's
enough for me. It has a usb-audio device in it which seems to not sync up
with the video. The only em28xx card= options that work with it are for
cards with tuners (though that doesn't necessarily mean that the card has a
tuner).

I also have a PCI K-World Vstream Xpert DVB-T (cx88), which I selected due
to it having a good price and analogue capture. Turns out I've used the
analogue capture more than the digital reception. :) The analogue capture
*looks like* a full TV tuner with the tuner disabled, but I could be wrong
about this too.

2008/11/15 Markus Rechberger <mrechberger@gmail.com>

On Fri, Nov 14, 2008 at 4:37 PM, Keith Lawson <lawsonk@lawson-tech.com>
> wrote:
> >
> >
> > On Thu, 13 Nov 2008, Markus Rechberger wrote:
> > <snip>
> >>
> >> are you sure this device is tm6000 based? I just remember the same
> >> product package used for em2820 based devices.
> >>
> >> http://mcentral.de/wiki/index.php5/Em2880#Devices
> >
> > It's a TM5600 device. I've been able to capture video from it using the
> > tm5600/tm6000/tm6010 module from Mauro's mercurial repository
> > but I'm having an issue with green flickering a the top of the video, I'm
> > not sure if that's a driver issue or an mplayer issue.
> >
> > Are you aware of a em2820 based USB "dongle" device? I don't require a
> > tuner, I'm just trying to capture input from S-video and composite (RCA).
> >
>
> I just had a rough look right now, the prices vary alot between
> different manufacturers.
> I haven't seen a price advantage for devices without tuner actually.
> You might pick a few devices from that site and compare.
>
> br,
> Markus
>
> >>
> >> br,
> >> Markus
> >>
> >>> Thanks,
> >>> Keith.
> >>>
> >>> On Fri, 7 Nov 2008, Keith Lawson wrote:
> >>>
> >>>> Hello,
> >>>>
> >>>> Can anyone suggest a good USB catpure device that has S-Video input
> and
> >>>> a
> >>>> stable kernel driver? I've been playing with this device:
> >>>>
> >>>> http://www.diamondmm.com/VC500.php
> >>>>
> >>>> using the development drivers from
> >>>> http://linuxtv.org/hg/~mchehab/tm6010/<http://linuxtv.org/hg/%7Emchehab/tm6010/>
> >>>> but I haven't had any luck with S-Video (only composite).
> >>>>
> >>>> Can anyone suggest a device with stable drivers in 2.6.27.5?
> >>>>
> >>>> Thanks, Keith.
> >>>>
> >>>> --
> >>>> video4linux-list mailing list
> >>>> Unsubscribe
> >>>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> >>>> https://www.redhat.com/mailman/listinfo/video4linux-list
> >>>>
> >>>
> >>> --
> >>> video4linux-list mailing list
> >>> Unsubscribe
> >>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> >>> https://www.redhat.com/mailman/listinfo/video4linux-list
> >>>
> >>
> >
> > --
> > video4linux-list mailing list
> > Unsubscribe mailto:video4linux-list-request@redhat.com
> ?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
> >
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
