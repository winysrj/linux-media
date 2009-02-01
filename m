Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n11HxSiZ008550
	for <video4linux-list@redhat.com>; Sun, 1 Feb 2009 12:59:38 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n11HvMTI013613
	for <video4linux-list@redhat.com>; Sun, 1 Feb 2009 12:57:53 -0500
Received: by fg-out-1718.google.com with SMTP id 19so402928fgg.7
	for <video4linux-list@redhat.com>; Sun, 01 Feb 2009 09:57:12 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 1 Feb 2009 17:57:11 +0000
Message-ID: <286e6b7c0902010957g62d19274u8bbe75932e6a1f9@mail.gmail.com>
From: D <d.a.nstowell+v4l@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: VIDIOCGMBUF "Invalid argument" (hasciicam on eee, 2.6.27-8-eeepc)
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

Hi -

I have an asus eee running eeebuntu 8.10, and I'm trying to get
hasciicam [1] to work with the built-in UVC webcam. (All works fine
when using "cheese" to confirm the webcam is working.) The hasciicam
code calls the VIDIOCGMBUF ioctl and that's where it fails. Here's the
code (from hasciicam.c):

  if (ioctl (dev, VIDIOCGMBUF, &grab_map) == -1) {
    perror("!! error in ioctl VIDIOCGMBUF: ");
    return -1;
  }

...where dev is pretty definitely open (we have already successfully
called VIDIOCGCAP and suchlike), and grab_map is a struct of type
video_mbuf as it should be. And here's the result:

  !! error in ioctl VIDIOCGMBUF: Invalid argument

Does this suggest that hasciicam is calling the ioctl incorrectly?
(For example, in [2] it says "a user first sets the desired image size
and depth properties" before calling it, although it doesn't spell out
precisely how that is done.) Or does it mean this particular ioctl is
not available on the given setup?

I'd be grateful for any suggestions.

Thanks
Dan

kernel 2.6.27-8-eeepc

[1] http://ascii.dyne.org/
[2] http://www.linuxtv.org/downloads/video4linux/API/V4L1_API.html
-- 
http://www.mcld.co.uk

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
