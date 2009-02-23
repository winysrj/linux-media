Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2832 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbZBWHec (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 02:34:32 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [RFC] How to pass camera Orientation to userspace
Date: Mon, 23 Feb 2009 08:34:08 +0100
Cc: Hans de Goede <hdegoede@redhat.com>,
	kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-omap@vger.kernel.org
References: <200902180030.52729.linux@baker-net.org.uk> <200902230024.16709.hverkuil@xs4all.nl> <Pine.LNX.4.58.0902221525520.24268@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0902221525520.24268@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902230834.08295.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 23 February 2009 00:56:40 Trent Piepho wrote:
> On Mon, 23 Feb 2009, Hans Verkuil wrote:
> > On Sunday 22 February 2009 23:54:42 Hans de Goede wrote:
> > > Trent Piepho wrote:
> > > > On Sun, 22 Feb 2009, Hans de Goede wrote:
> > > >> Yes that is what we are talking about, the camera having a gravity
> > > >> switch (usually nothing as advanced as a gyroscope). Also the bits
> > > >> we are talking about are in a struct which communicates
> > > >> information one way, from the camera to userspace, so there is no
> > > >> way to clear the bits to make the camera do something.
> > > >
> > > > First, I'd like to say I agree with most that the installed
> > > > orientation of the camera sensor really is a different concept than
> > > > the current value of a gravity sensor.  It's not necessary, and
> > > > maybe not even desirable, to handle them in the same way.
> > > >
> > > > I do not see the advantage of using reserved bits instead of
> > > > controls.
> > > >
> > > > The are a limited number of reserved bits.  In some structures
> > > > there are only a few left.  They will run out.  Then what?  Packing
> > > > non-standard sensor attributes and camera sensor meta-data into a
> > > > few reserved bits is not a sustainable policy.
> > > >
> > > > Controls on the other card are not limited and won't run out.
> > >
> > > Yes but these things are *not* controls, end of discussion. The
> > > control API is for controls, not to stuff all kind of cruft in.
> >
> > I agree, these are not controls.
> >
> > There is an option to use the current status field. There are enough
> > bits free, that's not the problem. But the spec is explicit about the
> > fact that these bits apply to the current input only, and that's not
> > true for these new bits. We can change the spec in this regard of
> > course, but then you have to document each bit of the status field
> > whether it is valid for the current input only, or also if this isn't
> > the current input. It's all a bit messy.
> >
> > In addition, there are 4 reserved fields here and it is the first time
> > in a very long time that we actually need one. And after all, that's
> > why they are there in the first place.
>
> v4l2_capability: 5 of 32 cap bits left, 4 reserved words
> v4l2_fmtdesc: 31 flag bits, 4 reserved words
> v4l2_buffer: 22 flags bits, 1 reserved word
> v4l2_framebuffer: 25 cap bits, 26 flag bits, no reserved words
> v4l2_input: 4 reserved words
> v4l2_output: 4 reserved words
> v4l2_tuner: 27 cap bits, 4 reserved words
>
> > Trent does have a point that we need to be careful not to add fields
> > without a good reason. Choosing option 1 fits the bill, and the
> > orientation also fits the 'status' name. Only the sensor mount
> > orientation is not really a status. Although with some creative naming
> > we might come close :-)
> >
> > Hmm, let's see:
> >
> > V4L2_IN_ST_HAS_SENSOR_INFO 	0x00000010
> > V4L2_IN_ST_SENSOR_HFLIPPED 	0x00000020
> > V4L2_IN_ST_SENSOR_VFLIPPED 	0x00000040
> >
> > V4L2_IN_ST_HAS_PIVOT_INFO	0x00001000
> > V4L2_IN_ST_PIVOT_0 		0x00000000
> > V4L2_IN_ST_PIVOT_90 		0x00002000
> > V4L2_IN_ST_PIVOT_180 		0x00004000
> > V4L2_IN_ST_PIVOT_270 		0x00006000
> > V4L2_IN_ST_PIVOT_MSK 		0x00006000
>
> One of my other points what the controls include meta-data.  What happens
> when someone has an orientation sensor with 45 degree resolution?  A
> control would just change the step size from 90 to 45.  Existing software
> would already know what it means.  With this method you have to add:
>
> V4L2_IN_ST_HAS_PIVOT_45_INFO	0x00008000
> V4L2_IN_ST_PIVOT_45		0x00010000
> V4L2_IN_ST_PIVOT_135		0x00012000
> V4L2_IN_ST_PIVOT_225		0x00014000
> V4L2_IN_ST_PIVOT_315		0x00016000
> V4L2_IN_ST_PIVOT_45_MSK		0x00016000
>
> Interpreting the pivot bits becomes more fun now.  Existing software
> can do nothing with these extra bits.  It can tell the user nothing.

These bits deal exclusively with the sensor position and for the sole 
purpose of deciding whether the image has to be rotated in hard/software to 
get it the right-way up. In most cases this is limited to rotating 180 
degrees, but omap has some memory management tricks to do the 90/270 degree 
cases as well.

This is not the same as having a full positioning 2D or 3D system in a 
camera that can give you exact angles. I do not think that should be part 
of v4l2. There isn't anything that v4l2 can do with that. An application 
might use this information to setup special transformations to do such 
rotates, and if the hardware can do that then that would be part of an 
effects API or something like that. With non-90 degree angle you just run 
into a totally different set of problems that are definitely out-of-scope.

> Next, add camera aperture.  f/0.7 to f/64 in both half stop and third
> stop increments.  Getting low on bits already.
>
> Suppose I have just three or four sensors on my camera.  That's not all
> that much.  A typical digital camera has more than that.  They're
> probably connected by something slow, like I2C.  Maybe non-trivial
> calculations are needed to use the data, like most demod's SNR registers.
>  Each time I query the input the driver must query and calculate the
> value of ALL the sensors. Even though I only can about one of them. 
> Controls can be queried individually.

Note that I am not averse to this idea in general. It would be easy to setup 
a separate class of 'controls' containing meta data that work the same as 
controls, but are just called differently. It has always been in the back 
of my mind that it would be a pretty good match, functionality-wise.

But in this case it just fits very well in the existing v4l2_input struct. 
These bits are specific to each input, so VIDIOC_ENUMINPUTS is the perfect 
match for that. If you want to do this with controls, then you would end up 
with a control for each input. Hardly elegant.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
