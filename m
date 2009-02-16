Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:55502 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZBPQJ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 11:09:28 -0500
Date: Mon, 16 Feb 2009 08:09:27 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
In-Reply-To: <42583.62.70.2.252.1234792848.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.58.0902160759330.24268@shell2.speakeasy.net>
References: <42583.62.70.2.252.1234792848.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Feb 2009, Hans Verkuil wrote:
> >> If you want to add two bits with
> >> mount information, feel free. But don't abuse them for pivot
> >> information.
> >> If you want that, then add another two bits for the rotation:
> >
> > Ok, this seems good. But if we want to distinguish between static sensor
> > mount
> > information, and dynamic sensor orientation changing due to pivotting,
> > then I
> > think we should only put the pivot flags in the buffer flags, and the
> > static
> > flags should be in the VIDIOC_QUERYCAP capabilities flag, what do you
> > think of
> > that?
>
> That's for driver global information. This type of information is
> input-specific (e.g. input 1 might be from an S-Video input and does not
> require v/hflip, and input 2 is from a sensor and does require v/hflip).
> So struct v4l2_input seems a good place for it.

A control could the return configuration of the current input.

I don't see this as a new and novel use of controls.  If V4L2_CID_VFLIP is
set to 1, then the image is vertically flipped.  What else would it mean?
What does it mean now that's different?
