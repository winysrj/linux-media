Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63869 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932781AbeAHQSC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 11:18:02 -0500
Date: Mon, 8 Jan 2018 14:17:52 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        hverkuil@xs4all.nl
Subject: Re: [ANN] Meeting notes on naming meeting 2017-10-11/13
Message-ID: <20180108141752.04e1f2c0@vento.lan>
In-Reply-To: <20180108134720.urmfzleeeyvmxlff@valkosipuli.retiisi.org.uk>
References: <20180108134720.urmfzleeeyvmxlff@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 8 Jan 2018 15:47:21 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi folks,
> 
> Here are the meeting notes on the IRC meeting that took place 11th and 13th
> last October. The brief summary is below, the full log can be found here:
> 
> <URL:http://www.retiisi.org.uk/v4l2/notes/v4l2-naming-2017-10-11.txt>
> 
> Attendees:
> 
> 	Laurent Pinchart
> 	Mauro Chehab
> 	Hans Verkuil
> 	Lars-Peter Clausen
> 	Sylwester Nawrocki
> 	Sakari Ailus
> 
> Notes:
> 
> - It was decided to call a group of multiple interconnected hardware
>   devices that that are designed to operate together as a "media hardware
>   complex". We haven't had a proper term for this in the past. Effectively
>   this means device that can be accessed through a given media device.

There is a note about that, though [1]:

[1] See https://linuxtv.org/irc/irclogger_log/v4l?date=2017-10-13,Fri&sel=288#l284


	pH5	I agree that "complex" should not be used where the focus is not on it being comprised of multiple interconnected parts. 	[12:29]
	sailus	I think that would mostly be only relevant when it comes to MC documentation, not V4L2.
		With V4L2 you can use "hardware device" since the user space API does not show how the hardware actually looks like. 

My understanding is that we'll use "hardware device" on most cases,
using the new "media hardware complex" (mostly) for MC.

> 
> - "Device", when it refers to a device node on a file system, shall be
>   replaced by "device node" in uAPI documentation if there's any ambiguity.
>   The same applies to "device" when it refers to hardware, i.e. "hardware
>   device". Further use of the "device" to refer either is fine as long as
>   there is no ambiguity of what it means.
> 
> - During the discussion on V4L2 sub-devices as V4L2 devices, the following
>   points were brought up:
> 
>   - V4L2 sub-device nodes are V4L2 device nodes in the following respects:
> 
>     - They share the same major number as V4L2 and they are implemented by
>       the V4L2 framework (as instantiated by drivers).
>     
>     - V4L2 sub-devices share some IOCTLs such as V4L2 controls with other
>       V4L2 device nodes.
>       
>     - They do share the "V4L2" in their name.
> 
>   - But there are some differences as well:
>   
>     - V4L2 sub-devices implement only a handful of IOCTLs, most of which
>       are uniformly implemented by all other V4L2 device node types (video,
>       radio, touch). E.g. QUERYCAP is not implemented for sub-devices
>       albeit there have been proposals to add this for unrelated reasons.

Although not explicitly said there, subdevs also have a set of ioctls that
are exclusive to it (like VIDIOC_SUBDEV_ENUM_MBUS_CODE). In other words,
as said there [2]:
	"the subdev API is different than the V4L2 API"

[2] https://linuxtv.org/irc/irclogger_log/v4l?date=2017-10-13,Fri&sel=338#l334

>     
>     - Historically V4L2 sub-device documentation has been always outside
>       the main V4L2 documentation (section 1 in particular). This is
>       primarily a documentation issue though.
> 
>     - Some V4L2 sub-device IOCTLs have different arguments from the V4L2
>       IOCTLs due to e.g. the fact that sub-devices are a control only
>       interface dealing with media bus formats whereas V4L2 video device
>       nodes deal with in-memory V4L2 formats. 
> - Documentation-wise, there's a common need to refer to V4L2 device nodes
>   which are not sub-device nodes as the rest have quite a bit in common.

>   In
>   this case, they should be called "V4L2 video device node" or "V4L2 radio
>   device node", or "V4L2 video/radio device nodes". This technically does
>   not include touch device nodes.

Yes :-(

After reviewing this today (and the corresponding IRC logs), I'm not happy
anymore with "V4L2 video/radio device nodes", as it still exclude things
(touch devices, vbi, sdr, and now, V4L2 metadata).

My 2018 version 2.0 view is that we're still lacking a term that will
cover what we need.

So, going one step back, we should either:

1) have a better name for: "all-but-subdev V4L2 device nodes" that will
   cover all current cases plus any new one (like v4l2 metadata) that
   will cover the cases where a "pure" V4L2 API is implemented and
   can be used to refer such devnodes on all V4L2 documentation but at
   Documentation/media/uapi/v4l/dev-subdev.rst;

or:

2) exclude subdev device nodes from V4L2 "pure-API" class of device
   nodes. E.g. something like:

	Documentation/media/uapi/{v4l/dev-subdev.rst -> subdev/subdev.rst}

   Dealing with subdev as separate part of the documentation, just like
   we did with the media controller.


I still think that (2) is the better way, as we won't need to review
whatever name we use as we add other types of V4L devices.

> - This distinction enables calling also V4L2 sub-device nodes as V4L2
>   device nodes, which was also agreed. The corresponding changes should be
>   made to the uAPI documentation.

> Let me know if there are inaccuracies or if you feel something is missing.
> It's been a while we had the meeting but this is why IRC meetings are
> great: you can write the meeting notes afterwards with pretty good
> accuracy. :-)
> 
> Also thanks to Mauro for reminding me we had no proper notes on the
> meeting.

Thank you for doing that! We should really address it in a way that
works for everybody.

Thanks,
Mauro
