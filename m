Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1O1qw8S013205
	for <video4linux-list@redhat.com>; Sat, 23 Feb 2008 20:52:58 -0500
Received: from mail8.sea5.speakeasy.net (mail8.sea5.speakeasy.net
	[69.17.117.10])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1O1qPKu011661
	for <video4linux-list@redhat.com>; Sat, 23 Feb 2008 20:52:26 -0500
Date: Sat, 23 Feb 2008 17:52:19 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Chris MacGregor <chris-video4linux-list@cybermato.com>
In-Reply-To: <47C0C7B8.20608@cybermato.com>
Message-ID: <Pine.LNX.4.58.0802231739210.30835@shell2.speakeasy.net>
References: <47C0C7B8.20608@cybermato.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] usbvideo: usbvideo.c should check
 palette in VIDIOCSPICT (resend again)
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

On Sat, 23 Feb 2008, Chris MacGregor wrote:
> From: Chris MacGregor <chris-usbvideo-patch-080216-3@cybermato.com>
>
> This change makes VIDIOCSPICT return EINVAL if the requested palette (format)
> doesn't match anything in paletteBits; this is essentially the same check as
> is already made in VIDIOCMCAPTURE.  The patch is against 2.6.24.2.
>

> The risk, of course, is that this patch will break existing v4l clients that
> accidentally pass non-zero garbage in the video_picture.palette field when
> calling VIDIOCSPICT, but which pass a valid format to VIDIOCMCAPTURE.

This concept of setting the format with VIDIOCMCAPTURE isn't something
that's defined in the V4L1 specs, but some software like vlc tries it
because it worked (not anymore) with the bttv driver.

I'm almost certain that the v4l1 compat module, and therefore all the
drivers that use it for v4l1 support, already works this way; returning
EINVAL for invalid formats (those that fail the v4l2 try format ioctl) in
VIDIOCSPICT.

> One could make the argument that a similar check should be made on the depth
> field, but vlc doesn't mess with it and I'm not feeling that ambitious today.

You should probably NOT add this.  In fact, bttv had this check and I
removed it, as it broke vlc!  vlc, and most software, just leaves the depth
field 0 or uninitialized, as it seems like it was intended as an output
from the driver, not an input.  Though, as usual, the v4l1 spec is vague on
this issue.  The format already defines the depth, so specifying it a
second times seems pointless.  It is slightly useful as an output from the
driver, so that software that the data is only going to pass through can
know the size without needing to know about any particular formats.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
