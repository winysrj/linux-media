Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2435 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbZBPHoW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 02:44:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: Adding a control for Sensor Orientation
Date: Mon, 16 Feb 2009 08:44:26 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
References: <200902142048.51863.linux@baker-net.org.uk> <20090215232637.46732912@pedra.chehab.org> <Pine.LNX.4.58.0902151956510.24268@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0902151956510.24268@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902160844.26368.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 16 February 2009 05:04:40 Trent Piepho wrote:
> On Sun, 15 Feb 2009, Mauro Carvalho Chehab wrote:
> > On Sun, 15 Feb 2009 10:29:03 +0100
> >
> > Hans de Goede <hdegoede@redhat.com> wrote:
> > > > I think we should also be able to detect 90 and 270 degree
> > > > rotations. Or at the very least prepare for it. It's a safe bet to
> > > > assume that webcams will arrive that can detect portrait vs
> > > > landscape orientation.
> > >
> > > Handling those (esp on the fly) will be rather hard as width and
> > > height then get swapped. So lets worry about those when we need to.
> > > We will need an additional flag for those cases anyways.
> >
> > The camera rotation is something that is already needed, at least on
> > some embedded devices, like those cellular phones whose display changes
> > when you rotate the device.
> >
> > By looking at the v4l2_buffer struct, we currently have 4 reserved
> > bytes. It has also one flags field, with several bits not used. I can
> > see 2 possibilities to extend the API:
> >
> > 1) adding V4L2_BUF_FLAG_HFLIP and V4L2_BUF_FLAG_VFLIP flags. This would
> > work for 90, 180 and 270 rotation;
>
> HFLIP and VFLIP are only good for 0 and 180 degrees.  90 and 270 isn't
> the same as flipping.
>
> The problem I'm seeing here is that as people are using v4l2 for digital
> cameras instead of tv capture there is more and more meta-data available.
> Things like shutter speed, aperture, focus distance, and so on.  Just
> look at all the EXIF data a digital camera provides.  Four bytes and two
> flags are going to run out very quickly at this rate.
>
> It's a shame there are not 8 bytes left, as then they could be used for a
> pointer to an extended meta-data structure.

I think we have to distinguish between two separate types of data: fixed 
('the sensor is mounted upside-down', or 'the sensor always requires a 
hflip/vflip') and dynamic ('the user pivoted the camera 270 degrees').

The first is static data and I think we can just reuse the existing 
HFLIP/VFLIP controls: just make them READONLY to tell libv4l that libv4l 
needs to do the flipping.

The second is dynamic data and should be passed through v4l2_buffer since 
this can change on a per-frame basis. In this case add two bits to the 
v4l2_buffer's flags field:

V4L2_BUF_FLAG_ROTATION_MSK	0x0c00
V4L2_BUF_FLAG_ROTATION_0	0x0000
V4L2_BUF_FLAG_ROTATION_90	0x0400
V4L2_BUF_FLAG_ROTATION_180	0x0800
V4L2_BUF_FLAG_ROTATION_270	0x0c00

No need to use the reserved field.

This makes a lot more sense to me: static (or rarely changing) data does not 
belong to v4l2_buffer, that's what controls are for. And something dynamic 
like pivoting belongs to v4l2_buffer. This seems like a much cleaner API to 
me.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
