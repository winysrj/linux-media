Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:52206 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbZBPEEm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 23:04:42 -0500
Date: Sun, 15 Feb 2009 20:04:40 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
In-Reply-To: <20090215232637.46732912@pedra.chehab.org>
Message-ID: <Pine.LNX.4.58.0902151956510.24268@shell2.speakeasy.net>
References: <200902142048.51863.linux@baker-net.org.uk>
 <alpine.LNX.2.00.0902141624410.315@banach.math.auburn.edu> <4997DB74.6000108@redhat.com>
 <200902151019.35555.hverkuil@xs4all.nl> <4997E05F.9080509@redhat.com>
 <20090215232637.46732912@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Feb 2009, Mauro Carvalho Chehab wrote:
> On Sun, 15 Feb 2009 10:29:03 +0100
> Hans de Goede <hdegoede@redhat.com> wrote:
> > > I think we should also be able to detect 90 and 270 degree rotations. Or at
> > > the very least prepare for it. It's a safe bet to assume that webcams will
> > > arrive that can detect portrait vs landscape orientation.
> > >
> >
> > Handling those (esp on the fly) will be rather hard as width and height then
> > get swapped. So lets worry about those when we need to. We will need an
> > additional flag for those cases anyways.
> >
> The camera rotation is something that is already needed, at least on some
> embedded devices, like those cellular phones whose display changes when you
> rotate the device.
>
> By looking at the v4l2_buffer struct, we currently have 4 reserved bytes. It
> has also one flags field, with several bits not used. I can see 2 possibilities to extend the API:
>
> 1) adding V4L2_BUF_FLAG_HFLIP and V4L2_BUF_FLAG_VFLIP flags. This would work
> for 90, 180 and 270 rotation;

HFLIP and VFLIP are only good for 0 and 180 degrees.  90 and 270 isn't the
same as flipping.

The problem I'm seeing here is that as people are using v4l2 for digital
cameras instead of tv capture there is more and more meta-data available.
Things like shutter speed, aperture, focus distance, and so on.  Just look
at all the EXIF data a digital camera provides.  Four bytes and two flags
are going to run out very quickly at this rate.

It's a shame there are not 8 bytes left, as then they could be used for a
pointer to an extended meta-data structure.
