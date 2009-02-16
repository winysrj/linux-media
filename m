Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51150 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbZBPC1Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 21:27:25 -0500
Date: Sun, 15 Feb 2009 23:26:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
Message-ID: <20090215232637.46732912@pedra.chehab.org>
In-Reply-To: <4997E05F.9080509@redhat.com>
References: <200902142048.51863.linux@baker-net.org.uk>
	<alpine.LNX.2.00.0902141624410.315@banach.math.auburn.edu>
	<4997DB74.6000108@redhat.com>
	<200902151019.35555.hverkuil@xs4all.nl>
	<4997E05F.9080509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Feb 2009 10:29:03 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

> > I think we should also be able to detect 90 and 270 degree rotations. Or at 
> > the very least prepare for it. It's a safe bet to assume that webcams will 
> > arrive that can detect portrait vs landscape orientation.
> > 
> 
> Handling those (esp on the fly) will be rather hard as width and height then 
> get swapped. So lets worry about those when we need to. We will need an 
> additional flag for those cases anyways.
> 
The camera rotation is something that is already needed, at least on some
embedded devices, like those cellular phones whose display changes when you
rotate the device.

By looking at the v4l2_buffer struct, we currently have 4 reserved bytes. It
has also one flags field, with several bits not used. I can see 2 possibilities to extend the API:

1) adding V4L2_BUF_FLAG_HFLIP and V4L2_BUF_FLAG_VFLIP flags. This would work
for 90, 180 and 270 rotation;

2) spend a few bytes for storing the camera angle. If a camera have a precise
sensor, this could be used by some software to reduce the angle movements of a
moving camera. However, if we consider this case, we would also need to
consider other camera movements.

So, IMO, the two flags could be more appropriate.


Cheers,
Mauro
