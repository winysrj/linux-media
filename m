Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m58GuNmZ010343
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 12:56:23 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m58GuBv8030969
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 12:56:11 -0400
Date: Sun, 8 Jun 2008 18:55:45 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Michael Schimek <mschimek@gmx.at>
Message-ID: <20080608165544.GB314@daniel.bse>
References: <200805262326.30501.hverkuil@xs4all.nl>
	<1211850976.3188.83.camel@palomino.walls.org>
	<200805270853.31287.hverkuil@xs4all.nl>
	<200805270900.20790.hverkuil@xs4all.nl>
	<1212791383.17465.742.camel@localhost>
	<20080607013340.GA2011@daniel.bse>
	<1212928036.17465.1043.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212928036.17465.1043.camel@localhost>
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

On Sun, Jun 08, 2008 at 02:27:16PM +0200, Michael Schimek wrote:
> I'd hope v4l2_cropcap tells me what the hardware is actually capable of,
> i.e. the maximum physical resolution, not interpolated pixels.

How many cards do support upscaling?
Defining crop units that way would make it impossible to make use of the
higher resolution in cropping after upscaling.

And it conflicts with the idea of using tv frame lines for vertical
units if the device can only capture one field.

> You think defrect should return the size and position of the active
> picture area in hardware units, not what the closest area is the
> hardware can actually capture?

Not necessarily in hardware units, but yes. Using hardware units would
suggest that the hardware is capable of cropping to that size.

> Well that's a possibility, but for once many drivers do not support
> VIDIOC_G/S_CROP, implying defrect is what they capture.

You mean drivers that support VIDIOC_CROPCAP without VIDIOC_G/S_CROP?
I see two possibilities:
1. add VIDIOC_G/S_CROP dummies
2. add to spec that drivers without VIDIOC_G/S_CROP capture bounds

> Well the idea was that all drivers support at least 1:1 scaling, defrect
> is what apps usually want to capture and what the hardware can actually
> capture, so defrect.width and .height is a valid image size and
> presumably the highest resolution image apps can get of the active
> picture area.

That makes me think about my old FAST MovieMachine Pro.
It does not have enough on board ram to capture both fields at full
resolution. It can downscale horizontally and vertically by dropping
pixels/lines in a Bresenham way. So it's either 448x576 or 704x372 maximum.
Using 13.5 MHz sample rate pixels horizontally and tv lines vertically as
crop units will make defrect too big to be a valid image size.
What do you suggest?

> That's right but I didn't pick the numbers. By default bttv always
> captured 480 lines and quite a few apps may depend on that. I guess most
> drivers capture 480 lines in NTSC-M mode, and most apps request 480
> scaled lines.

Ah those beautiful numbers divisibly by 16 needed for MPEG...
A workaround could be to decouple the startup crop region from defrect.
Then applications that don't know about cropping get 480 lines on open
while those that do can work with 486 lines. 

This is a problem for horizontal cropping as well, when the active
region is 702 pixels wide and scaling is impossible.

> The bt8x8 in particular
> cannot begin scaling on an even frame line and end on an odd frame line,
> of the opposite field, as an odd cropping height would suggest.

On bt8x8 you set the scaling factor and tell the hardware where to save
each line. You can't prevent the chip from using one more line for
scaling but you can set a scaling factor that maps 517 lines to 512
and then capture 512 lines.

> With known cropping units one can select an absolute position. Without
> that knowledge one can still move and resize the crop window relative to
> the default and pick scale factors.

So with unknown units one can still select the absolute position if defrect
is standardized.


The ability to capture without scaling could be implemented by other
means. One could for example pass v4l2_pix_format.width=0 to get the
unscaled width for the current crop region. Width and height should then
be tried independently to make it work with my old capture card.

  Daniel

P.S.: GMX hat -all im SPF TXT RR. Du solltest deren Mailserver benutzen.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
