Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1EDMCfh019418
	for <video4linux-list@redhat.com>; Sat, 14 Feb 2009 08:22:12 -0500
Received: from mailrelay003.isp.belgacom.be (mailrelay003.isp.belgacom.be
	[195.238.6.53])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1EDLs2C007747
	for <video4linux-list@redhat.com>; Sat, 14 Feb 2009 08:21:54 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Sat, 14 Feb 2009 14:25:19 +0100
References: <20090213153047.GC7554@mail.ljudmila.org>
In-Reply-To: <20090213153047.GC7554@mail.ljudmila.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902141425.19626.laurent.pinchart@skynet.be>
Cc: 
Subject: Re: // live capture from camcorder over USB bus //
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

Hi Julian,

On Friday 13 February 2009 16:30:47 Julian Oliver wrote:
> hola,
>
> i work a lot with computer vision and would very much like to use a
> camcorder as a V4L2 device - ie as a high-quality 'webcam' - over the USB
> bus.
>
> i am looking at a variety of camcorders but have found very little reliable
> information as to which, if any, allow for stream playback at native
> capture sizes, let alone as raw frames. instead i see complaints of high
> quality camcorders yielding only 320x240.
>
> is there a site, or any advice/experience, someone on this list could
> provide me to these ends?
>
> i do not have a FireWire port on my laptops but would consider a PCI
> express adaptor to allow for capture in this manner as a second option.

I've heard of a few Panasonic camcorders (GS-37, GS-180, GS-320 and GS-500) 
that are UVC compliant and can stream both recorded video (in DV format) or 
live video (in MJPEG format). Unfortunately, live video streaming is limited 
to 320x240.

Camcorders aren't really designed for live video streaming, so I'm not 
surprised that Panasonic didn't bother supporting higher resolutions in MJPEG.

I'm curious as to why you want to use a camcorder instead of a high-quality 
USB video camera.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
