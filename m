Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:23230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab0J1Gds (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 02:33:48 -0400
Message-ID: <4CC91A3A.2070002@redhat.com>
Date: Thu, 28 Oct 2010 08:37:46 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFCl libv4l2 plugin API
References: <4CC9189E.3040700@redhat.com>
In-Reply-To: <4CC9189E.3040700@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On 10/28/2010 08:30 AM, Hans de Goede wrote:
> Hans de Goede wrote:
>  > Hi All,
>
> Hi Hans,
>
> Thanks for the RFC!
>
> I'd have a few comments and questions.
>
> The coding style for libv4l hasn't been defined as far as I understand.
> Should kernel coding style be assumed, or something else?

v4l-utils uses kernel coding style.

>
>  > RFC: a plugin API for libv4l2
>  > =============================
>  >
>  > During the Plumbers conference in 2009 various parties expresse interest
>  > in adding a plugin API to libv4l2. Some hardware can do some
>  > processing steps in hardware, but this needs to be setup from userspace
>  > and sometimes still need some regulation from userspace as streaming
>  > happens, hardware specific libv4l2 plugins could be a solution here.
>  >
>  > During the v4l summit in Helsinki this was discussed further and a
>  > simple and very generic plugin API was pitched. This is a first draft
>  > specification for this API.
>  >
>  >
>  > Basic libv4l2 principles
>  > ------------------------
>  >
>  > The basic unit libv4l2's API deals with is a /dev/video node represented
>  > by a fd. A libv4l2 plugin will sit in between libv4l2 itself and the
>  > actual /dev/video device node a fd refers to. It will be called each time
>  > libv4l2 wants to do an operation (read/write/ioctl/mmap/munmap) on the
>  > actual /dev/video node in question. When called the plugin can then choose
>  > to do one of the following:
>  > 1. Pass the call unmodified to the fd, and return the return value
>  > unmodifed
>  > (iow do nothing)
>  > 2. Modify some arguments in the call and pass it through
>  > 3. Modify the return(ed) value(s) of a passed through call
>  > 4. Not do any operation on the fd at all but instead completely fake it
>  > (which opens the possibility for "fake" v4l devices)
>  >
>  > Note that:
>  > 1. A plugin may decide between 1. - 4. on a per call basis depending on the
>  > operations arguments and / or state. This esp. is important with the ioctl
>  > operation where a plugin may want to intercept some ioctls but not all
>  > 2. If a plugin always wants to pass all calls through for a certain
>  > operation, it is allowed to simply not define a callback function for that
>  > operation
>  > 3. As libv4l2 does some "faking" itself esp. when it comes to format
>  > conversion a single libv4l2 call may result in multiple calls to the
>  > plugin,
>  > or to none at all.
>  >
>  > So to summarize the above: Anything goes :)
>
> Plugin internal data bound to file descriptors make probably sense for
> webcams, but we can have more complex setups than that. For example the
> OMAP 3 ISP driver. Several video nodes may be used to capture video, and
> there are dependencies between the nodes.
>
> Essentially this kind of plugin can handle one media device at a time,
> not a V4L2 device. For webcams etc. this would still be the same since
> libv4l isn't aware of media devices.
>
> However, the application is a V4L2 application which works on V4L2
> devices and may well be unaware of the media device. I don't think this
> is _necessarily_ a problem since the plugin can do whatever it sees fit
> for user's request; it could even open another video node.

Yes this is the whole idea, the app uses just one video node, like with
any regular v4l device, and then the plugin can open video nodes
for "sub-devices" to hook up all the plumbing to get a pipeline which
does what the app wants.

> For example, there is likely one device node a general purpose
> application is interested in in the OMAP 3 ISP driver.

Right.

> Obviously, there can be only one of this kind of media device control
> plugins at a time. Other plugins should have their say before that, so
> that the device appears a regular V4L2 device for those plugins as well.

The current "design" (the RFC) assumes only one plugin per /dev/video#
device, so no stacking of plugins on the same fd. It is possible to
have multiple plugins, but only one will get "attached" to a certain
fd. The idea here is that plugins are meant for doing certain hardware
specific stuff. And different /dev/video# nodes could relate
to completely different hardware, so we do need multiple plugins to
support this. But as the purpose of the plugins is to deal with certain
hardware specific things, having one plugin per type of hardware seems
enough.

> The order in which the plugins are executed matters also if they do
> image processing. The result may well be different.

As said, there can only be one plugin per fd.

> Perhaps it'd be good to experiment with one plugin per device first? :-)

Right, well one plugin per fd, as libv4l does everything at the fd level.

Note that currently besides this RFC the plugin support is completely
vaporware but it should be quite easy to implement the RFC, patches
welcome :)

Regards,

Hans
