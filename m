Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m58DA72n009138
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 09:10:08 -0400
Received: from viefep11-int.chello.at (viefep11-int.chello.at [62.179.121.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m58D9ohK019483
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 09:09:50 -0400
From: Michael Schimek <mschimek@gmx.at>
To: Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
In-Reply-To: <20080607013340.GA2011@daniel.bse>
References: <200805262326.30501.hverkuil@xs4all.nl>
	<1211850976.3188.83.camel@palomino.walls.org>
	<200805270853.31287.hverkuil@xs4all.nl>
	<200805270900.20790.hverkuil@xs4all.nl>
	<1212791383.17465.742.camel@localhost>
	<20080607013340.GA2011@daniel.bse>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sun, 08 Jun 2008 14:27:16 +0200
Message-Id: <1212928036.17465.1043.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Need VIDIOC_CROPCAP clarification
Reply-To: mschimek@gmx.at
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

On Sat, 2008-06-07 at 03:33 +0200, Daniel Glöckner wrote:
> There is no need for the crop values to be related to sampled pixels
> as long as one can calculate the DAR of a crop region.
> The pixelaspect value may define virtual pixels that appear nowhere in
> hard- and software.

I'd hope v4l2_cropcap tells me what the hardware is actually capable of,
i.e. the maximum physical resolution, not interpolated pixels.

> Drivers may modify the region requested by the user even if it is the
> defrect. So my request to make defrect cover the standardized active
> area makes still sense for chips with a fixed area. Then applications
> know how to clip in software to the active region.

You think defrect should return the size and position of the active
picture area in hardware units, not what the closest area is the
hardware can actually capture?

Well that's a possibility, but for once many drivers do not support
VIDIOC_G/S_CROP, implying defrect is what they capture.

> > Not quite. Let's say defrect is 720x576 and pixelaspect is 54/59
> > (PAL/SECAM BT.601).
> 
> I wrote "should" because that's what I think drivers would do in a
> perfect world. See my above point about the driver modifying the
> requested area.

Sorry it was late. You're right of course.

> > If you want to capture exactly what the driver samples (no scaling) just
> > call VIDIOC_S_FMT width cropcap.defrect as the image size.
> 
> Nooo! Don't use cropcap values in VIDIOC_S_FMT.
> Spec says:
> "the driver writer is free to choose origin and units of the coordinate
> system in the analog domain."

Well the idea was that all drivers support at least 1:1 scaling, defrect
is what apps usually want to capture and what the hardware can actually
capture, so defrect.width and .height is a valid image size and
presumably the highest resolution image apps can get of the active
picture area.

> There is a problem with wanting to capture what is sampled without scaling.
> A capture card may perform scaling by modifying the sampling frequency.

Which one for example? I've only ever seen cards with discrete sampling
frequencies.

> Then there is no sampling without scaling.

But there is still a maximum sampling frequency which limits the number
of "pixels" that can be cropped.

>  A corresponding driver may
> use nanoseconds for horizontal crop coordinates even if it can't capture
> 52000 pixels per line.
>
> The cx88 chips have a Sample Rate Conversion register that allows exactly
> this, although it is supposed to be used only for a handful of sample
> rates because there are only four luma notches/chroma bandpasses to
> choose from.

I'm not convinced that selecting the horizontal cropping start and end
with nanosecond precision is more useful than to know how many vertical
lines the hardware can actually distinguish.

> VIDIOCGCAP did return the maximum resolution. In v4l2 applications can
> call _S_FMT/_TRY_FMT with huge width and height values and let the
> driver reduce these to the supported maximum.

As I understand it VIDIOCGCAP returns the minimum and maximum scaled
image size.

> > > The defrect.left+defrect.width/2 should be the center of the active
> > > picture area.
> > 
> > That's required by the spec, also in the vertical direction. (Well, duh.
> > What else would drivers capture by default.)
> 
> Is it? Spec says:
> "this could be for example a 640 × 480 rectangle for NTSC, a 768 × 576
> rectangle for PAL and SECAM centered over the active picture area."
> 
> Doesn't sound like a requirement.
> If you want to make it one, I'll vote for you.

I expressed that badly. What I meant to say was "defrect shall provide
co-ordinates which cover all of the picture, for example x by y pixels
which are centered over the picture by virtue of covering all of it." I
really want to replace "the picture" by "exactly what the respective
video standard defines as the active picture area" but in reality the
term may not apply, and many drivers do not or cannot aim that
accurately.

> > Vertically the bttv and saa7134 driver count frame lines. Field lines
> > would be admissible too, but considering these devices can capture
> > interlaced images it makes sense to return defrect.height 480 and 576.
> 
> It makes sense as well to return defrect.height=486 for NTSC.

That's right but I didn't pick the numbers. By default bttv always
captured 480 lines and quite a few apps may depend on that. I guess most
drivers capture 480 lines in NTSC-M mode, and most apps request 480
scaled lines.

> > An odd cropping height is not possible though.
> 
> Why?
> Applications are still allowed to vertically scale the picture, so there
> may be (or is enforced by the driver) an even number of lines in the end.
>
> The spec says the field order could be confused if the vertical offset was
> odd but then who knows which line belongs to which field after scaling?
> If you want odd vertical offsets, ask the driver to interleave the fields.

I'm not sure what you argue for. Frame lines reflect the vertical
resolution of the hardware. Properly drivers should scale the fields
separately, which does not affect their order. The bt8x8 in particular
cannot begin scaling on an even frame line and end on an odd frame line,
of the opposite field, as an odd cropping height would suggest. An odd
vertical offset may swap the fields, if the source is interlaced, which
is an unnecessary complication on top of the already intricate enum
v4l2_field.

> > It may be nice if other drivers followed this convention, but apps
> > cannot blindly rely on that. (They can check the driver name if exact
> > cropping is important.) The cropping units are undefined by the spec
> > because samples, microseconds or scan lines depend on the video standard
> > and make no sense for a webcam.
>
> Strange, I had the feeling you wanted to pass cropping units to
> VIDIOC_S_FMT...

With known cropping units one can select an absolute position. Without
that knowledge one can still move and resize the crop window relative to
the default and pick scale factors. What's the problem?

> Webcams usually have rows of pixels that can be counted.
> Spec could be modified to have vertical units = scan lines for analog
> tv standards and pixel rows for discrete image sensors.

If that covers all hardware and can be required without breaking drivers
I won't object.

Michael


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
