Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1EDhZ5H025506
	for <video4linux-list@redhat.com>; Sat, 14 Feb 2009 08:43:35 -0500
Received: from huda.ljudmila.org (www.ljudmila.org [193.2.132.73])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1EDhFuv010620
	for <video4linux-list@redhat.com>; Sat, 14 Feb 2009 08:43:16 -0500
Date: Sat, 14 Feb 2009 14:43:08 +0100
From: Julian Oliver <julian@julianoliver.com>
To: video4linux-list@redhat.com
Message-ID: <20090214134308.GL7554@mail.ljudmila.org>
References: <20090213153047.GC7554@mail.ljudmila.org>
	<200902141425.19626.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902141425.19626.laurent.pinchart@skynet.be>
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

..on Sat, Feb 14, 2009 at 02:25:19PM +0100, Laurent Pinchart wrote:
> Hi Julian,
> 
> On Friday 13 February 2009 16:30:47 Julian Oliver wrote:
> > hola,
> >
> > i work a lot with computer vision and would very much like to use a
> > camcorder as a V4L2 device - ie as a high-quality 'webcam' - over the USB
> > bus.
> >
> > i am looking at a variety of camcorders but have found very little reliable
> > information as to which, if any, allow for stream playback at native
> > capture sizes, let alone as raw frames. instead i see complaints of high
> > quality camcorders yielding only 320x240.
> >
> > is there a site, or any advice/experience, someone on this list could
> > provide me to these ends?
> >
> > i do not have a FireWire port on my laptops but would consider a PCI
> > express adaptor to allow for capture in this manner as a second option.
> 
> I've heard of a few Panasonic camcorders (GS-37, GS-180, GS-320 and GS-500) 
> that are UVC compliant and can stream both recorded video (in DV format) or 
> live video (in MJPEG format). Unfortunately, live video streaming is limited 
> to 320x240.

right, i wondered if that would be the case.

> 
> Camcorders aren't really designed for live video streaming, so I'm not 
> surprised that Panasonic didn't bother supporting higher resolutions in MJPEG.
> 

fair enough. Firewire stream is perhaps my only option in that case, which means
looking at buying a DV camera and connecting it via a Firewire Express Card
adaptor (laptop).  

> I'm curious as to why you want to use a camcorder instead of a high-quality 
> USB video camera.

i have a QuickCam Pro 9000 which is certainly a good camera for indoor computer
vision work. outdoors however, where much of my new natural feature tracking
work is based now, it performs poorly. 

with this in mind i'm looking at camcorders as they come with manual controls
that will aid me in getting the best possible image. furthermore camcorders
often allow for the use of wide-angle lenses which increase the area in focus
relative to the captured frame overall.

that said, i am looking at industrial proof USB cameras like this:

	http://www.theimagingsource.com/en_US/products/cameras/usb-cmos-color/dfk21buc03/

.. which is apparently supported by the Unicap driver interface.

however as there is so little information about their relative performance on
Linux i'm reluctant to take the leap of faith and buy one.

if there is a better USB2.0 UVC friendly camera than the camera above or the
Logitech QuickCam Pro 9000 in the areas of colour accuracy, frame rate and
manual control - while allowing for use of additional lenses - i would be happy
to hear about it! price is not a concern at this stage.

thanks for your reply,

-- 
Julian Oliver
home: New Zealand
based: Madrid, Spain
currently: Madrid, Spain
about: http://julianoliver.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
