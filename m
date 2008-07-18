Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6ILBVGK013460
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 17:11:31 -0400
Received: from mailrelay001.isp.belgacom.be (mailrelay001.isp.belgacom.be
	[195.238.6.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6ILBK2t009434
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 17:11:21 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans Verkuil <hverkuil@xs4all.nl>
Date: Fri, 18 Jul 2008 23:11:17 +0200
References: <200807171237.38433.laurent.pinchart@skynet.be>
	<200807171303.33026.hverkuil@xs4all.nl>
In-Reply-To: <200807171303.33026.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807182311.17606.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
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

Hi Hans,

On Thursday 17 July 2008, Hans Verkuil wrote:
> On Thursday 17 July 2008 12:37:37 Laurent Pinchart wrote:
> > Although the V4L2 spec states that the minimum and maximum fields may
> > not be valid for control types other than V4L2_CTRL_TYPE_INTEGER, it
> > makes sense to set the bounds to 0 and 1 for boolean controls instead
> > of returning uninitialized values.
>
> Hi Laurent,
>
> Are you aware of the control support functions in v4l2-common.c? In my
> opinion it would be a good idea if you would try to use those. In
> particular adding the control definitions for the standard camera
> controls to v4l2-common.c so that every driver that uses those will get
> the same control strings and data.

I suppose you're referring to the v4l2_ctrl_* functions. I wasn't aware of 
them.

Some of them, such as v4l2_ctrl_get_menu() and v4l2_ctrl_query_fill(), are 
interesting to share control names across drivers, although they could make 
the kernel larger than necessary when only a single (or very few) V4L2 driver 
is compiled in.

Most of the other functions don't make much sense for the uvcvideo driver. For 
instance, the uvcvideo driver needs to associate private data with each menu 
item, so a static list of names isn't the best solution. Filling control 
information with standard minimum, maximum, step and default values is also 
not an option, as that information varies between UVC devices and is reported 
by the hardware directly.

> I also do not see any support for the V4L2_CID_CAMERA_CLASS control: it
> should return a description of the camera control class. It is used in
> e.g. v4l2-ctl --list-ctrls:
>
> User Controls
>
>                      brightness (int)  : min=0 max=255 step=1...
>
> where the string "User Controls" comes from the V4L2_CID_USER_CLASS.

What's the point of having a control that actually controls nothing ?

> I want to prevent having different driver present different control
> query results to the user, even though it's the same control.

Names should be standard, but boundaries can vary between devices.

> Testing with v4l2-ctl is a good way to verify that it is all working as
> it should. Also qv4l2 is a useful tool to see if the controls use the
> correct GUI elements. Note that this currently only builds for qt3.
> Mauro made a patch to allow it to build for qt4, but I haven't gotten
> around to testing that (sorry Mauro).

Thanks for the information, I'll try those applications.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
