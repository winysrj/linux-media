Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4424 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbZBVXYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 18:24:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC] How to pass camera Orientation to userspace
Date: Mon, 23 Feb 2009 00:24:16 +0100
Cc: Trent Piepho <xyzzy@speakeasy.org>, kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-omap@vger.kernel.org
References: <200902180030.52729.linux@baker-net.org.uk> <Pine.LNX.4.58.0902221419550.24268@shell2.speakeasy.net> <49A1D7B2.5070601@redhat.com>
In-Reply-To: <49A1D7B2.5070601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902230024.16709.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 22 February 2009 23:54:42 Hans de Goede wrote:
> Trent Piepho wrote:
> > On Sun, 22 Feb 2009, Hans de Goede wrote:
> >> Yes that is what we are talking about, the camera having a gravity
> >> switch (usually nothing as advanced as a gyroscope). Also the bits we
> >> are talking about are in a struct which communicates information one
> >> way, from the camera to userspace, so there is no way to clear the
> >> bits to make the camera do something.
> >
> > First, I'd like to say I agree with most that the installed orientation
> > of the camera sensor really is a different concept than the current
> > value of a gravity sensor.  It's not necessary, and maybe not even
> > desirable, to handle them in the same way.
> >
> > I do not see the advantage of using reserved bits instead of controls.
> >
> > The are a limited number of reserved bits.  In some structures there
> > are only a few left.  They will run out.  Then what?  Packing
> > non-standard sensor attributes and camera sensor meta-data into a few
> > reserved bits is not a sustainable policy.
> >
> > Controls on the other card are not limited and won't run out.
>
> Yes but these things are *not* controls, end of discussion. The control
> API is for controls, not to stuff all kind of cruft in.

I agree, these are not controls.

There is an option to use the current status field. There are enough bits 
free, that's not the problem. But the spec is explicit about the fact that 
these bits apply to the current input only, and that's not true for these 
new bits. We can change the spec in this regard of course, but then you 
have to document each bit of the status field whether it is valid for the 
current input only, or also if this isn't the current input. It's all a bit 
messy.

In addition, there are 4 reserved fields here and it is the first time in a 
very long time that we actually need one. And after all, that's why they 
are there in the first place.

I see three options:

1) stuff them into the status field after all.
2) take one of the reserved fields and make it a single 'flags' field.
3) take one of the reserved fields and make it a u16 capabilities and u16 
flags field.

Trent does have a point that we need to be careful not to add fields without 
a good reason. Choosing option 1 fits the bill, and the orientation also 
fits the 'status' name. Only the sensor mount orientation is not really a 
status. Although with some creative naming we might come close :-)

Hmm, let's see:

V4L2_IN_ST_HAS_SENSOR_INFO 	0x00000010
V4L2_IN_ST_SENSOR_HFLIPPED 	0x00000020
V4L2_IN_ST_SENSOR_VFLIPPED 	0x00000040

V4L2_IN_ST_HAS_PIVOT_INFO	0x00001000
V4L2_IN_ST_PIVOT_0 		0x00000000
V4L2_IN_ST_PIVOT_90 		0x00002000
V4L2_IN_ST_PIVOT_180 		0x00004000
V4L2_IN_ST_PIVOT_270 		0x00006000
V4L2_IN_ST_PIVOT_MSK 		0x00006000

Actually, that's not too bad.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
