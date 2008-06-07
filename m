Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m571YN5a025160
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 21:34:23 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m571YAIs002399
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 21:34:11 -0400
Date: Sat, 7 Jun 2008 03:33:41 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Michael Schimek <mschimek@gmx.at>
Message-ID: <20080607013340.GA2011@daniel.bse>
References: <200805262326.30501.hverkuil@xs4all.nl>
	<1211850976.3188.83.camel@palomino.walls.org>
	<200805270853.31287.hverkuil@xs4all.nl>
	<200805270900.20790.hverkuil@xs4all.nl>
	<1212791383.17465.742.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1212791383.17465.742.camel@localhost>
Cc: video4linux-list@redhat.com
Subject: Re: Need VIDIOC_CROPCAP clarification
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

On Sat, Jun 07, 2008 at 12:29:43AM +0200, Michael Schimek wrote:
> Well as the spec says, pixelaspect is the aspect ratio (y/x) of pixels
> sampled by the driver.
[...]
> That's what v4l2_crop counts, pixels as sampled by the hardware.

There is no need for the crop values to be related to sampled pixels
as long as one can calculate the DAR of a crop region.
The pixelaspect value may define virtual pixels that appear nowhere in
hard- and software. The region is associated with real pixels when
the user requests a width and height in VIDIOC_S_FMT.

> As Daniel wrote, another way to view this is that the active portion of
> the video is about 52 µs wide.

Actually it's defined in BT.1700 to be exactly 52µs.
For NTSC SMPTE 170M says 52.85555...µs.

> Of course there's no guarantee defrect will cover exactly 52 µs. An
> older chip may always capture 720 pixels at 13.5 MHz with no support for
> scaling or cropping whatsoever. But since all video capture drivers are
> supposed to support VIDIOC_CROPCAP, apps can still determine the pixel
> aspect and display captured images correctly.

Drivers may modify the region requested by the user even if it is the
defrect. So my request to make defrect cover the standardized active
area makes still sense for chips with a fixed area. Then applications
know how to clip in software to the active region.

Spec says:
"The driver first adjusts the requested dimensions against hardware
limits, i. e. the bounds given by the capture/output window, and it
rounds to the closest possible values of horizontal and vertical offset,
width and height."

> > [cropcap] does not take into account anamorphic 16:9 transmissions.
> 
> It's true cropcap assumes the pixel aspect (or sampling rate) will never
> change. PAL/NTSC/SECAM has a 4:3 picture aspect. Apps must find out by
> other means, perhaps WSS, if a 16:9 signal is transmitted instead, and
> ask the driver to scale the images accordingly or do that themselves.

Ack!
SMPTE 170M says 4:3 for NTSC and BT.1700 for NTSC and SECAM.
No word in BT.1700 about PAL aspect ratio.

> > The height of defrect should correspond to the active picture area.
> > In case of 625-line PAL/SECAM it should represent 576 lines.
> > It follows that
> > width = defrect.height * 4/3
> >         * v4l2_cropcap.pixelaspect.numerator
> >         / v4l2_cropcap.pixelaspect.denominator;
> > covers 52µs of a 64µs PAL/SECAM line.
> > 52µs equals 702 BT.601 pixels.
> 
> Not quite. Let's say defrect is 720x576 and pixelaspect is 54/59
> (PAL/SECAM BT.601).

I wrote "should" because that's what I think drivers would do in a
perfect world. See my above point about the driver modifying the
requested area.

> If you want to capture exactly what the driver samples (no scaling) just
> call VIDIOC_S_FMT width cropcap.defrect as the image size.

Nooo! Don't use cropcap values in VIDIOC_S_FMT.
Spec says:
"the driver writer is free to choose origin and units of the coordinate
system in the analog domain."

There is a problem with wanting to capture what is sampled without scaling.
A capture card may perform scaling by modifying the sampling frequency.
Then there is no sampling without scaling. A corresponding driver may
use nanoseconds for horizontal crop coordinates even if it can't capture
52000 pixels per line.

The cx88 chips have a Sample Rate Conversion register that allows exactly
this, although it is supposed to be used only for a handful of sample
rates because there are only four luma notches/chroma bandpasses to
choose from.

VIDIOCGCAP did return the maximum resolution. In v4l2 applications can
call _S_FMT/_TRY_FMT with huge width and height values and let the
driver reduce these to the supported maximum.

> Now the images will be 720 / 54 * 59 = 786 square pixels wide. That's
> more than 768 because you're still overscanning. What you really need
> is:
> 
> image width = 768;
> image height = 576;

And that's where I wanted defrect to tell us the region of interest and
not the hardware limitations.

> Let's say defrect is 1280x720 and pixelaspect is 1/1 (16:9 camera).
> Result: It scales images down from 960x720 to 768x576, cutting off 160
> pixels left and right.

In my perfect world applications apply that scaling logic only when
VIDIOC_G_STD returns a known standard. Webcams that don't conform to a
tv standard may return whatever is useful for defrect on that hardware.
Applications can then still compute the display aspect ratio of a crop
region.

> > The defrect.left+defrect.width/2 should be the center of the active
> > picture area.
> 
> That's required by the spec, also in the vertical direction. (Well, duh.
> What else would drivers capture by default.)

Is it? Spec says:
"this could be for example a 640 × 480 rectangle for NTSC, a 768 × 576
rectangle for PAL and SECAM centered over the active picture area."

Doesn't sound like a requirement.
If you want to make it one, I'll vote for you.

> Vertically the bttv and saa7134 driver count frame lines. Field lines
> would be admissible too, but considering these devices can capture
> interlaced images it makes sense to return defrect.height 480 and 576.

It makes sense as well to return defrect.height=486 for NTSC.

> An odd cropping height is not possible though.

Why?
Applications are still allowed to vertically scale the picture, so there
may be (or is enforced by the driver) an even number of lines in the end.

The spec says the field order could be confused if the vertical offset was
odd but then who knows which line belongs to which field after scaling?
If you want odd vertical offsets, ask the driver to interleave the fields.

> The vertical origin is given by counting ITU-R line numbers as in the
> VBI API, which simplifies things quite a bit. Specifically these drivers
> count ITU-R line numbers of the first field times two, so bttv's
> defrect.top is 23 * 2.
> 
> It may be nice if other drivers followed this convention, but apps
> cannot blindly rely on that. (They can check the driver name if exact
> cropping is important.) The cropping units are undefined by the spec
> because samples, microseconds or scan lines depend on the video standard
> and make no sense for a webcam.

Strange, I had the feeling you wanted to pass cropping units to VIDIOC_S_FMT...

Webcams usually have rows of pixels that can be counted.
Spec could be modified to have vertical units = scan lines for analog tv
standards and pixel rows for discrete image sensors.

Hopefully nobody invents image sensors with an irregular pixel distribution.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
