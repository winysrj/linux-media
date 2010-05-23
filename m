Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1405 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab0EWOHM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 10:07:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Paulo Assis <pj.assis@gmail.com>
Subject: Re: [RFC] V4L2 Controls State Store/Restore File Format
Date: Sun, 23 May 2010 16:08:58 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTikMhseqvpIJHnmEUhouqvdYRaaUvE4jUFiAwgrH@mail.gmail.com> <201005231337.20698.hverkuil@xs4all.nl> <AANLkTikUvIIH9g0oJCHJU0HA-hqAXbWzaELoQZKiKE6U@mail.gmail.com>
In-Reply-To: <AANLkTikUvIIH9g0oJCHJU0HA-hqAXbWzaELoQZKiKE6U@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005231608.58277.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 23 May 2010 15:40:26 Paulo Assis wrote:
> Hans,
> 
> 2010/5/23 Hans Verkuil <hverkuil@xs4all.nl>:
> > On Thursday 20 May 2010 16:42:01 Paulo Assis wrote:
> >> Hi all,
> >>
> >> Below is a proposal for the file format to use when storing/restoring
> >> v4l2 controls state.
> >>
> >> I've some doubts concerning atomically set controls and string
> >> controls (see below)
> >> that may be inducing me on error.
> >> The format is intended to be generic enough to support any control
> >> class so I hope
> >> to receive comments for any special cases that I might have missed or
> >> overlooked.
> >> Don't worry about bashing on the proposal to hard I have a hard skin :-D
> >>
> >> Regards,
> >> Paulo
> >>
> >> ---------- Forwarded message ----------
> >> From: Hans de Goede <hdegoede@redhat.com>
> >> Date: 2010/5/20
> >> Subject: Re: [RFC] V4L2 Controls State Store/Restore File Format
> >> To: Paulo Assis <pj.assis@gmail.com>
> >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
> >> Martin_Rubli@logitech.com
> >>
> >>
> >> Hi Paulo,
> >>
> >> Clearly you've though quite a bit about this I had not realized
> >> this would be this complex (with ordering issues etc.).
> >>
> >> This looks like a good proposal to start with to me, I think it
> >> would be good to further discuss this on the linux-media list,
> >> where other v4l devs can read it and chime in.
> >>
> >> Regards,
> >>
> >> Hans
> >>
> >>
> >> On 05/20/2010 03:11 PM, Paulo Assis wrote:
> >> >
> >> > Hans,
> >> > Below is the RFC with my proposed control state file format for
> >> > store/restore functionality.
> >> > I have several doubts, mostly regarding controls that must be set
> >> > atomically with the extended control API.
> >> > The main question is:
> >> > How does an application know that a group of controls must be set atomically ?
> >> > Is this reported by the driver or is it something that the application
> >> > must know.
> >> >
> >> > Also for string controls, I've only seen two implementations on RDS
> >> > controls, so I've set these with low precedence/priority order
> >> > compared with other control types.
> >> >
> >> > Awaiting comments, bash it all you want :-)
> >> >
> >> > Regards,
> >> > Paulo
> >> > ______________________
> >> >
> >> > [RFC] V4L2 Controls State Store/Restore File Format
> >> >
> >> > VERSION
> >> >
> >> > 0.0.1
> >> >
> >> > ABSTRACT
> >> >
> >> > This document proposes a standard for the file format used by v4l2
> >> > applications to store/restore the controls state.
> >> > This unified file format allows sharing control profiles between
> >> > applications, making it much easier on both developers and users.
> >> >
> >> > INTRODUCTION
> >> >
> >> > V4l2 controls can be divided by classes and types.
> >> > Controls in different classes are not dependent between themselves, on
> >> > the other end if two controls belong to the same class they may or may
> >> > not be dependent.
> >> > A good example are automatic controls and their absolute counterparts,
> >> > e.g.: V4L2_CID_AUTOGAIN and V4L2_CID_GAIN.
> >> > Controls must be set following the dependency order, automatic
> >> > controls must be set first or else setting the absolute value may
> >> > fail, when that was not the intended behavior (auto disabled).
> >> > After a quick analyses of the v4l2 controls, we are left to conclude
> >> > that auto controls are in most cases of the
> >> > boolean type, with some exceptions like V4L2_CID_EXPOSURE_AUTO, that
> >> > is of the menu type.
> >> > So ordering control priority by control type seems logical and it can
> >> > be done in the following order:
> >> >
> >> > 1-V4L2_CTRL_TYPE_BOOLEAN
> >> > 2-V4L2_CTRL_TYPE_MENU
> >> > 3-V4L2_CTRL_TYPE_INTEGER
> >> > 4-V4L2_CTRL_TYPE_INTEGER64
> >> > 5-V4L2_CTRL_TYPE_STRING
> >
> > I'm not sure whether the ordering is needed, it sounds more like a driver bug
> > that you are trying to work around.
> >
> > When you retrieve the state of controls, then the value of the controls must be
> > valid. So you should be able to set it later. There are some dependencies,
> > for example selecting a particular MPEG video encoding might deactivate some
> > controls and activate others. But the INACTIVE flag should be used to mark that,
> > never the DISABLED flag. And you can still set inactive controls.
> >
> 
> How would this work for controls like "Exposure, Auto" ?
> In the cameras I've tested if we don't set it to manual first, changing
> "Exposure (Absolute)" fails. Maybe it's a uvcvideo a bug, I'm not sure.
> The same for "White Balance Temperature, Auto" and
> "White Balance Temperature".  They all return a EIO error.

That's definitely wrong. Either they should set the INACTIVE flag and just
accept the new value (possibly storing it internally), or they should set
the READONLY flag and return -EACCES or -EINVAL. The spec says -EINVAL but we
want to change that to -EACCES. -EIO should only be used for failing hardware.
I.e. i2c errors or something like that.

But as I said there is a wild variety of ways in which drivers handle controls.
It's why I'm working on the control framework and why I want to get that in
asap.

> 
> > For controls not belonging to the user class I would store and restore them
> > all using G/S_EXT_CTRLS. So for each class just get all controls that are both
> > readable and writable and not disabled, then get or set them in one call.
> >
> I'll have to test at least camera class controls and see if this works.
> 
> > For the user class controls you can do the same, but if that fails, then you
> > have to fallback to G/S_CTRL on a per-control basis.
> >
> I'll test this to!

Note that all or almost all drivers will currently fail when you try to use
G/S_EXT_CTRLS with user class controls. But the new framework will handle this
just fine.

> 
> 
> > The main problem at the moment is that control handling stinks. Which is why
> > I am working on a new control framework that will handle everything in the
> > v4l core greatly simplifying drivers and providing a unified and consistent
> > interface towards applications.
> >
> 
> Will this bring any changes to the API, or is just at the core level ?

There will be a few small changes to the API with respect to error codes.

The latest patch series is here:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/19318

Look at patch 3/15, section 'Differences from the Spec' (almost at the end
of the patch).

But most drivers that switch to this framework will probably behave differently
since most drivers behave inconsistently when it comes to corner cases. Such
as the EIO error code in your example.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
