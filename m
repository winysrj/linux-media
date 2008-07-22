Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6MLbw8x018776
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 17:37:58 -0400
Received: from smtp-vbr15.xs4all.nl (smtp-vbr15.xs4all.nl [194.109.24.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6MLax4e009576
	for <video4linux-list@redhat.com>; Tue, 22 Jul 2008 17:37:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Date: Tue, 22 Jul 2008 23:36:58 +0200
References: <200807171237.38433.laurent.pinchart@skynet.be>
	<200807182329.13328.hverkuil@xs4all.nl>
	<200807222323.25196.laurent.pinchart@skynet.be>
In-Reply-To: <200807222323.25196.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807222336.58429.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] uvcvideo: Return sensible min and max values when
	querying a boolean control.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Tuesday 22 July 2008 23:23:25 Laurent Pinchart wrote:
> On Friday 18 July 2008, Hans Verkuil wrote:
> > On Friday 18 July 2008 23:11:17 Laurent Pinchart wrote:
> > > On Thursday 17 July 2008, Hans Verkuil wrote:
> > > > On Thursday 17 July 2008 12:37:37 Laurent Pinchart wrote:
> > > > > Although the V4L2 spec states that the minimum and maximum
> > > > > fields may not be valid for control types other than
> > > > > V4L2_CTRL_TYPE_INTEGER, it makes sense to set the bounds to 0
> > > > > and 1 for boolean controls instead of returning uninitialized
> > > > > values.
> > > >
> > > > Are you aware of the control support functions in
> > > > v4l2-common.c? In my opinion it would be a good idea if you
> > > > would try to use those. In particular adding the control
> > > > definitions for the standard camera controls to v4l2-common.c
> > > > so that every driver that uses those will get the same control
> > > > strings and data.
> > >
> > > I suppose you're referring to the v4l2_ctrl_* functions. I wasn't
> > > aware of them.
> > >
> > > Some of them, such as v4l2_ctrl_get_menu() and
> > > v4l2_ctrl_query_fill(), are interesting to share control names
> > > across drivers, although they could make the kernel larger than
> > > necessary when only a single (or very few) V4L2 driver is
> > > compiled in.
> > >
> > > Most of the other functions don't make much sense for the
> > > uvcvideo driver. For instance, the uvcvideo driver needs to
> > > associate private data with each menu item, so a static list of
> > > names isn't the best solution. Filling control information with
> > > standard minimum, maximum, step and default values is also not an
> > > option, as that information varies between UVC devices and is
> > > reported by the hardware directly.
> >
> > I suspected as much, but see if there is some way to have a central
> > place to keep the standard camera control descriptions. The reason
> > for creating the functions in v4l2-common.c in the first place was
> > to attempt to limit the wild variations in namings that were (are)
> > in use.
>
> What about creating a new function
>
> const char *v4l2_ctrl_get_name(unsigned int id);
>
> that would be used both by v4l2_ctrl_query_fill() and directly by
> drivers with 'advanced' needs such as uvcvideo ? This could serve as
> a central control names repository.

Good idea.

> On a side note, I'm still not completely convinced that providing
> control names should be the responsibility of the kernel. A userspace
> library would do a better job at handling i18n.

Yes and no. First of all we need this since that was the way the API was 
designed about 10 years ago. So we are stuck with it. Personally, I do 
not think it is such a bad idea to have a kernel provide some sort of a 
description. You can still use the control ID as a mapping in a library 
to do the translation as long as you refrain from using the 
V4L2_CID_PRIVATE_BASE controls since the same private control can have 
a different meaning in different drivers. If a new driver appears with 
new controls and there is no translation available, then you can still 
fall back on what the kernel provides.

Note that with the extended controls API you can make driver-specific 
controls without having to use V4L2_CID_PRIVATE_BASE. Much cleaner 
IMHO.

> > > > I also do not see any support for the V4L2_CID_CAMERA_CLASS
> > > > control: it should return a description of the camera control
> > > > class. It is used in e.g. v4l2-ctl --list-ctrls:
> > > >
> > > > User Controls
> > > >
> > > >                      brightness (int)  : min=0 max=255
> > > > step=1...
> > > >
> > > > where the string "User Controls" comes from the
> > > > V4L2_CID_USER_CLASS.
> > >
> > > What's the point of having a control that actually controls
> > > nothing ?
> >
> > Try qv4l2: it's used as the caption for the control panels, or as
> > the caption in v4l2-ctl --list-ctrls. It's a user interface
> > element. The point it to let applications create control panel like
> > GUIs. And for that they need to know how to group them and what to
> > call those groups.
>
> Where can I get the latest version ? I'd prefer a tarball as I don't
> have mercurial installed.

Just in any hg tree, e.g.:

http://linuxtv.org/hg/v4l-dvb/archive/tip.tar.bz2

It's in the v4l2-apps directory (I think v4l2-apps should become a 
stand-alone tree, but that's another discussion).

> > > > I want to prevent having different driver present different
> > > > control query results to the user, even though it's the same
> > > > control.
> > >
> > > Names should be standard, but boundaries can vary between
> > > devices.
> >
> > True, that's why v4l2_ctrl_query_fill was made: boundaries are
> > passed to the function, but the description and type info is filled
> > in for you.
>
> I was referring to v4l2_ctrl_query_fill_std().
>
> > > > Testing with v4l2-ctl is a good way to verify that it is all
> > > > working as it should. Also qv4l2 is a useful tool to see if the
> > > > controls use the correct GUI elements. Note that this currently
> > > > only builds for qt3. Mauro made a patch to allow it to build
> > > > for qt4, but I haven't gotten around to testing that (sorry
> > > > Mauro).
> > >
> > > Thanks for the information, I'll try those applications.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
