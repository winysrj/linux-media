Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5KFTWw9000657
	for <video4linux-list@redhat.com>; Fri, 20 Jun 2008 11:29:32 -0400
Received: from mailrelay005.isp.belgacom.be (mailrelay005.isp.belgacom.be
	[195.238.6.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5KFTIdg019266
	for <video4linux-list@redhat.com>; Fri, 20 Jun 2008 11:29:18 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Date: Fri, 20 Jun 2008 17:29:09 +0200
References: <484934FD.1080401@hhs.nl>
	<200806082323.41607.laurent.pinchart@skynet.be>
	<484C568C.1060703@hhs.nl>
In-Reply-To: <484C568C.1060703@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806201729.09963.laurent.pinchart@skynet.be>
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

sorry for the late reply. I got somehow side-tracked.

On Monday 09 June 2008, Hans de Goede wrote:
> Laurent Pinchart wrote:
> >> I'm using a Logitech sphere usb id: 046d:08cc
> >>
> >> Fedora kernel: kernel-2.6.25-8.fc9, which includes UVC (added by
> >> Fedora).
> >
> > That's a very buggy webcam. It has nasty firmware issues. See
> > http://www.quickcamteam.net/documentation/faq/logitech-webcam-linux-usb-i
> >ncompatibilities
>
> Ah, I already feared that much, so its not MS's fault it doesn't work out
> of the box with vista then :)
>
> >>> I would also appreciate if you could check the kernel log
> >>> for error messages after triggering the problem.
> >>
> >> No messages I'm afraid.
> >
> > Now that's weird. The only error path that can return -EIO print a
> > message to the kernel log. Could you please double check ?
>
> Done,
>
> There are some messages like this one:
> uvcvideo: Failed to query (135) UVC control 7 (unit 2) : -75 (exp. 2).

I'm afraid this is most probably caused by firmware bugs in the webcam. The 
driver can't do much about it.

> (Also with different numbers) but those seemed harmless to me, as I
> interpreted them as could not get brightness / contrast / hue / etc.

That's right.

> But maybe I misinterpreted them, sorry I should have reported them the first
> time.

No worries.

While I don't completely the possibility of having race conditions in the UVC 
driver (no piece of software is ever perfect), the problems you have 
encountered are caused by webcam firmware issues.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
