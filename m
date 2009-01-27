Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:3177 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbZA0SRV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 13:17:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH] New V4L2 ioctls for OMAP class of Devices
Date: Tue, 27 Jan 2009 19:16:52 +0100
Cc: "Shah, Hardik" <hardik.shah@ti.com>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02F535EFE5@dbde02.ent.ti.com> <200901271415.58568.hverkuil@xs4all.nl> <Pine.LNX.4.58.0901271001480.17971@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0901271001480.17971@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271916.53224.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 27 January 2009 19:08:43 Trent Piepho wrote:
> On Tue, 27 Jan 2009, Hans Verkuil wrote:
> > > [Shah, Hardik] Hi Hans,
> > > I got your above point.  Now regarding the enum I am not sure about
> > > how to implement it.  Are you suggesting me to remove the control ID
> > > for rotation and implement in some other way.  Please let me know if
> > > I am missing something. Currently in driver I have implemented the
> > > rotation in below way {
> > >                 .id            = V4L2_CID_ROTATION,
> > >                 .name          = "Rotation",
> > >                 .minimum       = 0,
> > >                 .maximum       = 270,
> > >                 .step          = 90,
> > >                 .default_value = -1,
> > >                 .flags         = 0,
> > >                 .type          = V4L2_CTRL_TYPE_INTEGER,
> > > You want me to change V4L2_CTRL_TYPE_INTEGER to some enum or
> > > something.
> >
> > Change it to V4L2_CTRL_TYPE_MENU. See:
> > http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v
> >4l2.html#VIDIOC-QUERYCTRL
>
> Thinking about it more, I think an integer control like this might make
> more sense.  default_value should be changed to 0 of course.  Extracting
> the real meaning from the control setting is more obvious for the integer
> control than a menu.  And what if some hardware allows for rotations
> other than 90 degrees?

If the hardware can do rotations other than 90 degrees then we get into the 
area of video effects. In principle such a driver can implement this 
rotation control as an integer rather than a menu (apps are supposed to 
query the type of a control dynamically, after all). But for a case like 
this where there are only four values I think a menu-type control is much 
more user-friendly.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
