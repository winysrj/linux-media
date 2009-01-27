Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:54697 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbZA0SIo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 13:08:44 -0500
Date: Tue, 27 Jan 2009 10:08:43 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: "Shah, Hardik" <hardik.shah@ti.com>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] New V4L2 ioctls for OMAP class of Devices
In-Reply-To: <200901271415.58568.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0901271001480.17971@shell2.speakeasy.net>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02F535EFE5@dbde02.ent.ti.com>
 <200901271415.58568.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 27 Jan 2009, Hans Verkuil wrote:
> > [Shah, Hardik] Hi Hans,
> > I got your above point.  Now regarding the enum I am not sure about how
> > to implement it.  Are you suggesting me to remove the control ID for
> > rotation and implement in some other way.  Please let me know if I am
> > missing something. Currently in driver I have implemented the rotation in
> > below way {
> >                 .id            = V4L2_CID_ROTATION,
> >                 .name          = "Rotation",
> >                 .minimum       = 0,
> >                 .maximum       = 270,
> >                 .step          = 90,
> >                 .default_value = -1,
> >                 .flags         = 0,
> >                 .type          = V4L2_CTRL_TYPE_INTEGER,
> > You want me to change V4L2_CTRL_TYPE_INTEGER to some enum or something.
>
> Change it to V4L2_CTRL_TYPE_MENU. See:
> http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#VIDIOC-QUERYCTRL

Thinking about it more, I think an integer control like this might make
more sense.  default_value should be changed to 0 of course.  Extracting
the real meaning from the control setting is more obvious for the integer
control than a menu.  And what if some hardware allows for rotations other
than 90 degrees?
