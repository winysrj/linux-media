Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1LLra70022706
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 16:53:36 -0500
Received: from mailrelay009.isp.belgacom.be (mailrelay009.isp.belgacom.be
	[195.238.6.176])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1LLr5iA001304
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 16:53:05 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Thu, 21 Feb 2008 22:59:38 +0100
References: <47BC8BFC.2000602@kaiser-linux.li>
	<175f5a0f0802210443i6f1d46afm730b9f3b27121ed1@mail.gmail.com>
	<47BDC928.4040409@kaiser-linux.li>
In-Reply-To: <47BDC928.4040409@kaiser-linux.li>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802212259.38624.laurent.pinchart@skynet.be>
Cc: 
Subject: Re: V4L2_PIX_FMT_RAW
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

Hi Thomas and Harri,

On Thursday 21 February 2008, Thomas Kaiser wrote:
> H. Willstrand wrote:
> > On Thu, Feb 21, 2008 at 1:00 PM, Thomas Kaiser
> >
> > <linux-dvb@kaiser-linux.li> wrote:
> >> H. Willstrand wrote:
> >>  > On Thu, Feb 21, 2008 at 2:20 AM, Daniel Glöckner <daniel-gl@gmx.net> 
wrote:
> >>  >> On Thu, Feb 21, 2008 at 01:02:39AM +0100, H. Willstrand wrote:
> >>  >>  > What's the problem with having a name of the formalized data in
> >>  >>  > the video stream? ie raw do not mean undefined.
> >>  >>
> >>  >>  I thought you wanted to avoid having to define V4L2_PIX_FMT_x for
> >>  >> an exploding number of proprietary formats that are quite similar
> >>  >> but still incompatible. It makes sense for formats that are used by
> >>  >> more than one driver.
> >>  >
> >>  > Correct, the number of unique pixel formats should be kept down.
> >>  > Again, comparing with digital cameras there are >200 proprietary
> >>  > formats and there is a "clean-up" on-going where the "market" is
> >>  > aiming for a OpenRAW.
> >>  >
> >>  > However, by declaring a generic RAW format (which is then driver
> >>  > specific) doesn't help the user mode app developers. Calling a
> >>  > multitude of libraries to see if you get lucky might not be a good
> >>  > idea.
> >>  >
> >>  > Still, I'm suspectious about the definition "raw" used here.
> >>  > RAW should mean unprocessed image data:
> >>  > * no white balance adjustment
> >>  > * no color saturation adjustments
> >>  > * no contrast adjustments
> >>  > * no sharpness improvements
> >>  > * no compression with loss
> >>
> >>  Yes, raw means "as it is" no stripping, decoding  or removing of SOF
> >> headers are done in the driver. May be V4L2_PIX_FMT_AII (AII -> As It
> >> Is) is the better name?
> >
> > I struggle with the probability to find several CCD's having similar
> > formats. There aren't so many manifactors of CCD's but they truelly
> > can generate divergeting formats. Worst case scenario means >200
> > V4L2_PIX_FMT_RAW_...
> >
> > I think RAW is a OK name, the question is if the subcomponents of the
> > RAW formats has similarities, if so they might be standardized.
> > Looking into different Sony CCD's it's clearly possible, but after the
> > CCD the data has to be buffered, packaged and transmitted which of
> > course can be done in several ways...
> >
> > Cheers,
> > Harri
> >
> >>  > So, by looking for similarities in the "raw" formats where available
> >>  > there should be a potential to consolidate them.
> >>  >
> >>  >>  > I don't see how separate RAW ioctl's will add value to the V4l2
> >>  >>  > API, it fits into the current API.
> >>  >>
> >>  >>  Yes, it does. Each driver having multiple raw formats just needs a
> >>  >>  private control id to select one.
> >>  >
> >>  > I was more thinking about the VIDIOC_S_RAW stuff, a VIDIOC_S_FMT
> >>  > should do the job.
> >>  > I.e. I think there should be strong reasons to break V4L2 API
> >>  > behavior.
> >>  >
> >>  > Harri
>
> Actually, in a webcam you have the image sensor and a usb bridge. Usually,
> the sensor capture a picture in Bayer pattern. This gets forwarded to the
> usb bridge. The usb bridge may or may not transfer the picture to an other
> format and/or compress it with a standard compression algo or a proprietary
> compression algo. The resulting data stream will be transmitted over the
> usb interface.
>
> I just would like to get this resulting stream to user space without
> manipulation/conversion/decoding of the stream in the kernel module.

For most USB devices the resulting stream will be completely unusable. USB 
provides packet boundary information that would be lost. Except when the data 
transmitted over USB is stream-based (MPEG 2/4 for instance), the resulting 
stream will have headers intermixed with data with no way to tell them apart.

> That means we don't know what the format is in this data which comes trough
> the usb interface. That's way I call it raw.

That's not true. If you really don't know what format the data are in, there 
is little point in getting the data.

Video frames can be in a standard format (MJPEG, RGB, ...) or in a proprietary 
format (mostly device-specific compression formats). That format is 
identified at the V4L2 level by a four character code (fourcc). A quick look 
at videodev2.h shows that several vendor-specific formats are defined 
(SN9C10x compression, pwc compression, ...). New formats should be added as 
new devices hit the market.

> At the moment with V4L2, I have to forward a stream to user space which is
> in a format v4l2 knows. That means I have sometimes to do heavy data
> processing in the kernel module to decode/convert the data from the usb
> stream to a known v4l2 video format.

Nothing in V4L2 prevents you from using a private fourcc, although it would be 
easier to submit new fourcc's for inclusion in V4L2. As long as the userspace 
application supports the format and recognises its fourcc your kernel driver 
will only have to handle the USB headers (which are part of the protocol, not 
the format) and won't have to touch the video frame data at all.

> That's way I want a official way to forward the untouched usb stream to
> user space!

Just define a new fourcc and use it to identify your data format.

> How the user space application has to react on this stream is an other
> story, I think. But there will be some way to tell the usespace application
> what to do with this "unknown" stream, I am sure.

With a defined fourcc the stream won't be "unknown".

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
