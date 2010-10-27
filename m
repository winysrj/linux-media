Return-path: <mchehab@pedra>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:30640 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188Ab0J0NsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 09:48:23 -0400
Message-ID: <4CC82D98.2030003@maxwell.research.nokia.com>
Date: Wed, 27 Oct 2010 16:48:08 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Yordan Kamenov <ykamenov@mm-sol.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: RFCl libv4l2 plugin API
References: <4C2CA010.70907@redhat.com>
In-Reply-To: <4C2CA010.70907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans de Goede wrote:
> Hi All,

Hi Hans,

Thanks for the RFC!

I'd have a few comments and questions.

The coding style for libv4l hasn't been defined as far as I understand.
Should kernel coding style be assumed, or something else?

> RFC: a plugin API for libv4l2
> =============================
> 
> During the Plumbers conference in 2009 various parties expresse interest
> in adding a plugin API to libv4l2. Some hardware can do some
> processing steps in hardware, but this needs to be setup from userspace
> and sometimes still need some regulation from userspace as streaming
> happens, hardware specific libv4l2 plugins could be a solution here.
> 
> During the v4l summit in Helsinki this was discussed further and a
> simple and very generic plugin API was pitched. This is a first draft
> specification for this API.
> 
> 
> Basic libv4l2 principles
> ------------------------
> 
> The basic unit libv4l2's API deals with is a /dev/video node represented
> by a fd. A libv4l2 plugin will sit in between libv4l2 itself and the
> actual /dev/video device node a fd refers to. It will be called each time
> libv4l2 wants to do an operation (read/write/ioctl/mmap/munmap) on the
> actual /dev/video node in question. When called the plugin can then choose
> to do one of the following:
> 1. Pass the call unmodified to the fd, and return the return value
> unmodifed
>    (iow do nothing)
> 2. Modify some arguments in the call and pass it through
> 3. Modify the return(ed) value(s) of a passed through call
> 4. Not do any operation on the fd at all but instead completely fake it
>    (which opens the possibility for "fake" v4l devices)
> 
> Note that:
> 1. A plugin may decide between 1. - 4. on a per call basis depending on the
> operations arguments and / or state. This esp. is important with the ioctl
> operation where a plugin may want to intercept some ioctls but not all
> 2. If a plugin always wants to pass all calls through for a certain
> operation, it is allowed to simply not define a callback function for that
> operation
> 3. As libv4l2 does some "faking" itself esp. when it comes to format
> conversion a single libv4l2 call may result in multiple calls to the
> plugin,
> or to none at all.
> 
> So to summarize the above: Anything goes :)

Plugin internal data bound to file descriptors make probably sense for
webcams, but we can have more complex setups than that. For example the
OMAP 3 ISP driver. Several video nodes may be used to capture video, and
there are dependencies between the nodes.

Essentially this kind of plugin can handle one media device at a time,
not a V4L2 device. For webcams etc. this would still be the same since
libv4l isn't aware of media devices.

However, the application is a V4L2 application which works on V4L2
devices and may well be unaware of the media device. I don't think this
is _necessarily_ a problem since the plugin can do whatever it sees fit
for user's request; it could even open another video node.

For example, there is likely one device node a general purpose
application is interested in in the OMAP 3 ISP driver.

Obviously, there can be only one of this kind of media device control
plugins at a time. Other plugins should have their say before that, so
that the device appears a regular V4L2 device for those plugins as well.

The order in which the plugins are executed matters also if they do
image processing. The result may well be different.

Perhaps it'd be good to experiment with one plugin per device first? :-)

What do you think?

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
