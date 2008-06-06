Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m56Mt7lX010023
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 18:55:07 -0400
Received: from mailrelay002.isp.belgacom.be (mailrelay002.isp.belgacom.be
	[195.238.6.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m56MsvlG028539
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 18:54:57 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Date: Sat, 7 Jun 2008 00:54:50 +0200
References: <484934FD.1080401@hhs.nl>
	<200806061519.50350.laurent.pinchart@skynet.be>
	<48494770.7060503@hhs.nl>
In-Reply-To: <48494770.7060503@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806070054.51210.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com
Subject: Re: uvc open/close race (Was Re: v4l1 compat wrapper version 0.3)
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

Hi Hans,

On Friday 06 June 2008, Hans de Goede wrote:
> Laurent Pinchart wrote:
> > Hi Hans,
> >
> > On Friday 06 June 2008 15:00, Hans de Goede wrote:
> >> Hi All,
> >>
> >> Ok, this one _really_ works with ekiga (and still works fine with
> >> spcaview) and also works with camorama with selected cams (not working
> >> on some cams due to a camorama bug).
> >>
> >> Changes:
> >> * Don't allow multiple opens, in theory our code can handle it, but not
> >> all v4l2 devices like it (ekiga does it and uvc doesn't like it).
> >
> > Could you please elaborate ? Have you noticed a bug in the UVC driver ?
> > It should support multiple opens.
>
> A good question, which I kinda knew I had coming. So now it has been asked
> I've spend some time tracking this down. There seems to be an open/close
> race somewhere in the UVC driver, ekiga does many open/close cycles in
> quick succession during probing.
>
> It seems my no multiple opens code slows it down just enough to stop the
> race, but indeed multiple opens does not seem to be the real problem.
>
> I've attached a program which reproduces it.

Thanks for the test software.

> I've commented out the fork as 
> that does not seem necessary to reproduce this, just very quickly doing
> open/some-io/close, open/some-io/close seems to be enough to trigger this,
> here is the output on my machine:
>
> [hans@localhost v4l1-compat-0.4]$ ./test
> [hans@localhost v4l1-compat-0.4]$ ./test
> [hans@localhost v4l1-compat-0.4]$ ./test
> [hans@localhost v4l1-compat-0.4]$ ./test
> TRY_FMT 2: Input/output error
> [hans@localhost v4l1-compat-0.4]$ ./test
> TRY_FMT 1: Input/output error
> [hans@localhost v4l1-compat-0.4]$ ./test
> TRY_FMT 1: Input/output error
> [hans@localhost v4l1-compat-0.4]$ ./test
> TRY_FMT 1: Input/output error
> [hans@localhost v4l1-compat-0.4]$
>
> Notice how after the first time it gets the I/O error, it never recovers
> and from now on every first TRY_FMT fails.
>
> Some notes:
> 1) TRY_FMT should really never do I/O (but then I guess the
>     problem would still persists with S_FMT)

Why not ? The UVC specification defines probe requests to negotiate the 
streaming format. Unlike for most other devices, the UVC model requires I/O 
in TRY_FMT.

> 2) I've also seen it fail at TRY_FMT 1 without first failing
>     a TRY_FMT 2, I guess that was just me doing arrow-up -> enter to
> quickly :)

Could you please tell me what webcam you used, as well as what kernel version 
you are running ? I would also appreciate if you could check the kernel log 
for error messages after triggering the problem.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
