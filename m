Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n11LSLNv010177
	for <video4linux-list@redhat.com>; Sun, 1 Feb 2009 16:28:21 -0500
Received: from mailrelay006.isp.belgacom.be (mailrelay006.isp.belgacom.be
	[195.238.6.172])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n11LS6FD011257
	for <video4linux-list@redhat.com>; Sun, 1 Feb 2009 16:28:06 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Sun, 1 Feb 2009 22:27:45 +0100
References: <286e6b7c0902010957g62d19274u8bbe75932e6a1f9@mail.gmail.com>
In-Reply-To: <286e6b7c0902010957g62d19274u8bbe75932e6a1f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902012227.46111.laurent.pinchart@skynet.be>
Cc: 
Subject: Re: VIDIOCGMBUF "Invalid argument" (hasciicam on eee,
	2.6.27-8-eeepc)
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

Hi Dan,

On Sunday 01 February 2009, D wrote:
> Hi -
>
> I have an asus eee running eeebuntu 8.10, and I'm trying to get
> hasciicam [1] to work with the built-in UVC webcam. (All works fine
> when using "cheese" to confirm the webcam is working.) The hasciicam
> code calls the VIDIOCGMBUF ioctl and that's where it fails. Here's the
> code (from hasciicam.c):
>
>   if (ioctl (dev, VIDIOCGMBUF, &grab_map) == -1) {
>     perror("!! error in ioctl VIDIOCGMBUF: ");
>     return -1;
>   }
>
> ...where dev is pretty definitely open (we have already successfully
> called VIDIOCGCAP and suchlike), and grab_map is a struct of type
> video_mbuf as it should be. And here's the result:
>
>   !! error in ioctl VIDIOCGMBUF: Invalid argument
>
> Does this suggest that hasciicam is calling the ioctl incorrectly?
> (For example, in [2] it says "a user first sets the desired image size
> and depth properties" before calling it, although it doesn't spell out
> precisely how that is done.) Or does it mean this particular ioctl is
> not available on the given setup?
>
> I'd be grateful for any suggestions.

The UVC driver doesn't support the deprecated V4L1 API. The v4l1compat.so 
wrapper might help you, as it translates V4L1 calls to V4L2.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
