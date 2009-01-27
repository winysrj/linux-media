Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:42836 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbZA0S7G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 13:59:06 -0500
Date: Tue, 27 Jan 2009 10:59:04 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: "Shah, Hardik" <hardik.shah@ti.com>
cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH] New V4L2 ioctls for OMAP class of Devices
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB02F535ED08@dbde02.ent.ti.com>
Message-ID: <Pine.LNX.4.58.0901271031160.17971@shell2.speakeasy.net>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02F535ED08@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 27 Jan 2009, Shah, Hardik wrote:
> > 90 and 270 degrees would modify the image size. How would that be handled in
> > relationship with VIDIOC_S/G_FMT ?
> [Shah, Hardik] Hi Laurent,
> After setting the rotation degree user has to once again call the S_FMT
> with the height and width to allow S_FMT to take care of reversing the
> height and width of the panel and depending on that your crop window and
> display window will be set if the rotation is set to 90 or 270.  While the
> get format will give you same height and width set earlier.  Is this
> answer to your question?

That seems like a bad idea.  Consider the case the hardware does scaling
and rotation as separate steps.

The hardware receives a Rec. 601 standard 720x480 image to it's
scaling/rotation engine.

You have a selected a 640x480 image rotated 0 degrees.  This is ok.

You change the rotation to 90.

The hardware must re-program the scaler to produce a 480x640 image so that
after rotation it will remain 640x480.

Then you must call S_FMT to request 480x640, which re-programs the scaler
back to 640x480.

There are two problems here.  First, it's inefficient to reprogram the
scaler from 640x480 to 480x640 just to change it right back to 640x480
again.

But there is a much more serious problem.  Virtually all scaling hardware
has various limitations of what it can do.  For instance, it is very common
that the hardware can only shrink images, not enlarge them.  In the above
example, changing the rotation from 0 to 90 will fail, since doing so would
require scaling the 720x480 input to 480x640.  The hardware can't do that
as it involves enlarging from 480 lines to 640.

How would one change the rotation?  Use S_FMT to change to 480x640 first,
then change rotation?  That won't work because 480x640 at 0 degrees isn't
supported.

The basic problem here is that the limitations on image size for a
non-rotated image are different from the limitations of a rotated image.

I think the specification should say that changing the rotation is allowed
(not required, allowed) to change the image size.  Applications should call
G_FMT after changing rotation to see if driver decided to alter the image
size for efficiency or because of hardware limitations.  Any given image
size may be valid in some rotations but not in other rotations.

The *meaning* of width and height, i.e. how they relate to layout of data
in memory, do not change when the image is rotated.

Since changing the image size during capture is problematic, it should be
expected that trying to change the rotation during capture might return
EBUSY.
