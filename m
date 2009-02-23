Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36004 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbZBWLap (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 06:30:45 -0500
Date: Mon, 23 Feb 2009 08:30:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Hans de Goede <hdegoede@redhat.com>,
	kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>, linux-omap@vger.kernel.org
Subject: Re: [RFC] How to pass camera Orientation to userspace
Message-ID: <20090223083005.3afa64cd@pedra.chehab.org>
In-Reply-To: <200902230834.08295.hverkuil@xs4all.nl>
References: <200902180030.52729.linux@baker-net.org.uk>
	<200902230024.16709.hverkuil@xs4all.nl>
	<Pine.LNX.4.58.0902221525520.24268@shell2.speakeasy.net>
	<200902230834.08295.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 23 Feb 2009 08:34:08 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Monday 23 February 2009 00:56:40 Trent Piepho wrote:
> > On Mon, 23 Feb 2009, Hans Verkuil wrote:
> > > On Sunday 22 February 2009 23:54:42 Hans de Goede wrote:
> > > > Trent Piepho wrote:
> > > > > On Sun, 22 Feb 2009, Hans de Goede wrote:
> > > > >> Yes that is what we are talking about, the camera having a gravity
> > > > >> switch (usually nothing as advanced as a gyroscope). Also the bits
> > > > >> we are talking about are in a struct which communicates
> > > > >> information one way, from the camera to userspace, so there is no
> > > > >> way to clear the bits to make the camera do something.
> > > > >
> > > > > First, I'd like to say I agree with most that the installed
> > > > > orientation of the camera sensor really is a different concept than
> > > > > the current value of a gravity sensor.  It's not necessary, and
> > > > > maybe not even desirable, to handle them in the same way.
> > > > >
> > > > > I do not see the advantage of using reserved bits instead of
> > > > > controls.
> > > > >
> > > > > The are a limited number of reserved bits.  In some structures
> > > > > there are only a few left.  They will run out.  Then what?  Packing
> > > > > non-standard sensor attributes and camera sensor meta-data into a
> > > > > few reserved bits is not a sustainable policy.
> > > > >
> > > > > Controls on the other card are not limited and won't run out.
> > > >
> > > > Yes but these things are *not* controls, end of discussion. The
> > > > control API is for controls, not to stuff all kind of cruft in.
> > >
> > > I agree, these are not controls.
> > >
> > > There is an option to use the current status field. There are enough
> > > bits free, that's not the problem. But the spec is explicit about the
> > > fact that these bits apply to the current input only, and that's not
> > > true for these new bits. We can change the spec in this regard of
> > > course, but then you have to document each bit of the status field
> > > whether it is valid for the current input only, or also if this isn't
> > > the current input. It's all a bit messy.
> > >
> > > In addition, there are 4 reserved fields here and it is the first time
> > > in a very long time that we actually need one. And after all, that's
> > > why they are there in the first place.
> >
> > v4l2_capability: 5 of 32 cap bits left, 4 reserved words
> > v4l2_fmtdesc: 31 flag bits, 4 reserved words
> > v4l2_buffer: 22 flags bits, 1 reserved word
> > v4l2_framebuffer: 25 cap bits, 26 flag bits, no reserved words
> > v4l2_input: 4 reserved words
> > v4l2_output: 4 reserved words
> > v4l2_tuner: 27 cap bits, 4 reserved words
> >
> > > Trent does have a point that we need to be careful not to add fields
> > > without a good reason. Choosing option 1 fits the bill, and the
> > > orientation also fits the 'status' name. Only the sensor mount
> > > orientation is not really a status. Although with some creative naming
> > > we might come close :-)
> > >
> > > Hmm, let's see:
> > >
> > > V4L2_IN_ST_HAS_SENSOR_INFO 	0x00000010
> > > V4L2_IN_ST_SENSOR_HFLIPPED 	0x00000020
> > > V4L2_IN_ST_SENSOR_VFLIPPED 	0x00000040
> > >
> > > V4L2_IN_ST_HAS_PIVOT_INFO	0x00001000
> > > V4L2_IN_ST_PIVOT_0 		0x00000000
> > > V4L2_IN_ST_PIVOT_90 		0x00002000
> > > V4L2_IN_ST_PIVOT_180 		0x00004000
> > > V4L2_IN_ST_PIVOT_270 		0x00006000
> > > V4L2_IN_ST_PIVOT_MSK 		0x00006000
> >
> > One of my other points what the controls include meta-data.  What happens
> > when someone has an orientation sensor with 45 degree resolution?  A
> > control would just change the step size from 90 to 45.  Existing software
> > would already know what it means.  With this method you have to add:
> >
> > V4L2_IN_ST_HAS_PIVOT_45_INFO	0x00008000
> > V4L2_IN_ST_PIVOT_45		0x00010000
> > V4L2_IN_ST_PIVOT_135		0x00012000
> > V4L2_IN_ST_PIVOT_225		0x00014000
> > V4L2_IN_ST_PIVOT_315		0x00016000
> > V4L2_IN_ST_PIVOT_45_MSK		0x00016000
> >
> > Interpreting the pivot bits becomes more fun now.  Existing software
> > can do nothing with these extra bits.  It can tell the user nothing.
> 
> These bits deal exclusively with the sensor position and for the sole 
> purpose of deciding whether the image has to be rotated in hard/software to 
> get it the right-way up. In most cases this is limited to rotating 180 
> degrees, but omap has some memory management tricks to do the 90/270 degree 
> cases as well.

> This is not the same as having a full positioning 2D or 3D system in a 
> camera that can give you exact angles. I do not think that should be part 
> of v4l2. There isn't anything that v4l2 can do with that. An application 
> might use this information to setup special transformations to do such 
> rotates, and if the hardware can do that then that would be part of an 
> effects API or something like that. With non-90 degree angle you just run 
> into a totally different set of problems that are definitely out-of-scope.

We are trying to address 2 different situations using the same approach. After
thinking more about it, I suspect that we need two separate approaches. 

For the static info that a sensor is mounted on a different position on a
notebook case, for example. The same camera could be mounted on different
position for different hardwares and kernel will never know for sure, if the
vendor didn't care to change the USB ID for the rotated camera.

All kernel could provide is a HINT info, for some known cases, but it should be
possible to override this in userspace. For this case, the better userspace api
seems to be by using some flags at v4l2_input.

However, I'm starting to agree with one of the Hans de Goede opinions that this
information should be stored at userspace, since, on a large amount of cases,
like surveillance mounted cameras, or some hardware with a fixed commercial
webcam, like an ATM machine, this info is not stored anyware. The only way is
to allow users to edit a file pointing the webcam orientation for that device.

The second case is something like a gravity sensor. This can provide us 2D/3D
angles with 90 degrees stepping, but I don't doubt that more sophisticated
cameras will start to appear, having a more precise mechanism, to be used by
applications that could compensate a 2D/3D rotation on software.

In the trivial case of a 90 degrees step, IMO, the event interface seems to be
the better approach. However, if we really want to do motion compensation in
software, the only alternative is to have this information together with the
streaming meta-data.

Cheers,
Mauro
