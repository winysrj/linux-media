Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:65377 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755194AbeCSN0Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 09:26:24 -0400
Date: Mon, 19 Mar 2018 10:26:17 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180319095544.7e235a3e@vento.lan>
In-Reply-To: <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
References: <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
        <20170509110440.GC28248@amd>
        <c4f61bc5-6650-9468-5fbf-8041403a0ef2@xs4all.nl>
        <20170516124519.GA25650@amd>
        <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl>
        <20180316205512.GA6069@amd>
        <c2a7e1f3-589d-7186-2a85-545bfa1c4536@xs4all.nl>
        <20180319102354.GA12557@amd>
        <20180319074715.5b700405@vento.lan>
        <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
        <20180319120043.GA20451@amd>
        <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 19 Mar 2018 13:15:22 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 03/19/2018 01:00 PM, Pavel Machek wrote:
> > Hi!
> >   
> >>> Pavel,
> >>>
> >>> I appreciate your efforts of adding support for mc-based devices to
> >>> libv4l.  
> > 
> > Thanks.
> >   
> >>> I guess the main poin that Hans is pointing is that we should take
> >>> extra care in order to avoid adding new symbols to libv4l ABI/API
> >>> without being sure that they'll be needed in long term, as removing
> >>> or changing the API is painful for app developers, and keeping it
> >>> ABI compatible with apps compiled against previous versions of the
> >>> library is very painful for us.  
> >>
> >> Indeed. Sorry if I wasn't clear on that.  
> > 
> > Aha, ok, no, I did not get that.
> >   
> >>> The hole idea is that generic applications shouldn't notice
> >>> if the device is using a mc-based device or not.  
> >>
> >> What is needed IMHO is an RFC that explains how you want to solve this
> >> problem, what the parser would look like, how this would configure a
> >> complex pipeline for use with libv4l-using applications, etc.
> >>
> >> I.e., a full design.
> >>
> >> And once everyone agrees that that design is solid, then it needs to be
> >> implemented.
> >>
> >> I really want to work with you on this, but I am not looking for partial
> >> solutions.  
> > 
> > Well, expecting design to be done for opensource development is a bit
> > unusual :-).  
> 
> Why? We have done that quite often in the past. Media is complex and you need
> to decide on a design up front.
> 
> > I really see two separate tasks
> > 
> > 1) support for configuring pipeline. I believe this is best done out
> > of libv4l2. It outputs description file, format below. Currently I
> > have implemented this is in Python. File format is below.  
> 
> You do need this, but why outside of libv4l2? I'm not saying I disagree
> with you, but you need to give reasons for that.
> 
> > 2) support for running libv4l2 on mc-based devices. I'd like to do
> > that.
> > 
> > Description file would look like. (# comments would not be not part of file).
> > 
> > V4L2MEDIADESC
> > 3 # number of files to open
> > /dev/video2
> > /dev/video6
> > /dev/video3  

"Easy" file formats usually means maintenance troubles as new
things are needed, and makes worse for users to write it. 
You should take a look at lib/libdvbv5/dvb-file.c, mainly at 
fill_entry() and dvb_read_file().

It has a parser there for things like:

[foo]
	bar = value

and it doesn't require external libraries. I considered writing it
as a small helper function, but it turns that parsing this format
is so simple that can easily be added anywhere else.

The advantage of such format is that it should be simple enough
to add more stuff there, and intuitive enough for end users.

> This won't work. The video nodes numbers (or even names) can change.

Yes. That all depends on how udev is set on a given system.
Btw, the logic should likely use libudev in order to get the
devname.

> Instead these should be entity names from the media controller.

Agreed that it should use MC. Yet, IMHO, the best would be to use
the entity function instead, as entity names might eventually
change on newer versions of the Kernel.

So, IMHO, entities should be described as:

	[entity entity1]
		name = foo
		function = bar

(again, user may specify just name, just function or both)

> > 3 # number of controls to map. Controls not mentioned here go to
> >   # device 0 automatically. Sorted by control id.
> >   # Device 0 
> > 00980913 1
> > 009a0003 1
> > 009a000a 2  

I would, instead, encode it as:

	[control white balance]
		control_id = 0x00980913
		entity = foo_entity_name

	[control exposure]
		control_id = V4L2_CID_EXPOSURE_ABSOLUTE
		entity = bar_entity_name
	...

Allowing both hexadecimal values and control macro names (can easily parsed 
from the header file, as we already do for other things with "make sync").

Makes a way easier for people to understand what that means and to write
such files.

> You really don't need to specify the files to open. All you need is to
> specify the entity ID and the list of controls that you need.
> 
> Then libv4l can just figure out which device node(s) to open for that.

The only file it could make sense to specify is the media
controller device or the name of the media controller device,
as more than one /dev/media? devnode could be present on a given
system.

I would actually support both, e. g.:

[media controller]

	name = foo
	devname = bar

Only "name" or "devname" would be required:
	- If "name" is blank, it would just use "devname";
	- If "devname" is blank, it would open all /dev/media?
	  devices until it matches "name";
	- If both are given, it would open "devname" and check
	  if "name" matches the media controller name, failing
	  otherwise.

> > 
> > We can parse that easily without requiring external libraries. Sorted
> > data allow us to do binary search.  
> 
> But none of this addresses setting up the initial video pipeline or
> changing formats. We probably want to support that as well.

It should probably be easy to add a generic pipeline descriptor
with a format like:

	[pipeline pipe1]
		link0 = SGRBG10 640x480: entity1:0 -> entity2:0[1]
		link1 = SGRBG10 640x480: entity2:2-> entity3:0[1]
		link2 = UYVY 640x480: entity3:1-> entity4:0[1]
		link3 = UYVY 640x480: entity4:1-> entity5:0[1]

		sink0 = UYVY 320x200: entity5:0[1]
		sink1 = UYVY 640x480: entity3:0[1]

> 
> For that matter: what is it exactly that we want to support? I.e. where do
> we draw the line?
> 
> A good test platform for this (outside the N900) is the i.MX6 platform.
> 
> Regards,
> 
> 	Hans



Thanks,
Mauro
