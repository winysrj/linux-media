Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48524 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbdLLPcW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 10:32:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 1/2] v4l: v4l2-dev: Add infrastructure to protect device unplug race
Date: Tue, 12 Dec 2017 17:32:24 +0200
Message-ID: <2042086.mPSt6QL5YS@avalon>
In-Reply-To: <20171212103932.73c542ce@vento.lan>
References: <20171116003349.19235-1-laurent.pinchart+renesas@ideasonboard.com> <20171123142101.GA5155@kroah.com> <20171212103932.73c542ce@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday, 12 December 2017 14:39:32 EET Mauro Carvalho Chehab wrote:
> Em Thu, 23 Nov 2017 15:21:01 +0100 Greg Kroah-Hartman escreveu:
> > On Thu, Nov 23, 2017 at 11:07:51AM -0200, Mauro Carvalho Chehab wrote:
> >> Em Thu, 16 Nov 2017 02:33:48 +0200 Laurent Pinchart escreveu:
> >>> Device unplug being asynchronous, it naturally races with operations
> >>> performed by userspace through ioctls or other file operations on
> >>> video device nodes.
> >>> 
> >>> This leads to potential access to freed memory or to other resources
> >>> during device access if unplug occurs during device access. To solve
> >>> this, we need to wait until all device access completes when
> >>> unplugging the device, and block all further access when the device is
> >>> being unplugged.
> >>> 
> >>> Three new functions are introduced. The video_device_enter() and
> >>> video_device_exit() functions must be used to mark entry and exit from
> >>> all code sections where the device can be accessed. The
> >>> video_device_unplug() function is then used in the unplug handler to
> >>> mark the device as being unplugged and wait for all access to
> >>> complete.
> >>> 
> >>> As an example mark the ioctl handler as a device access section. Other
> >>> file operations need to be protected too, and blocking ioctls (such as
> >>> VIDIOC_DQBUF) need to be handled as well.
> >>> 
> >>> Signed-off-by: Laurent Pinchart
> >>> <laurent.pinchart+renesas@ideasonboard.com>
> >>> ---
> >>> 
> >>>  drivers/media/v4l2-core/v4l2-dev.c | 57 ++++++++++++++++++++++++++++++
> >>>  include/media/v4l2-dev.h           | 47 ++++++++++++++++++++++++++++++
> >>>  2 files changed, 104 insertions(+)

[snip]

> >> I'm c/c Greg here, as I don't think, that, the way it is, it
> >> belongs at V4L2 core.
> >> 
> >> I mean: if this is a problem that affects all drivers, it would should,
> >> instead, be sitting at the driver's core.
> > 
> > What "problem" is trying to be solved here?  One where your specific
> > device type races with your specific user api?  Doesn't sound very
> > driver-core specific to me :)
> > 
> > As an example, what other bus/device type needs this?  If you can see
> > others that do, then sure, move it into the core.  But for just one, I
> > don't know if that's really needed here, do you?
> 
> The problem that this patch is trying to solve is related to
> hot-unplugging a platform device[1]. Quoting Laurent's comments about
> it on IRC:
> 
> 	"it applies to all platform devices at least"

Note how I said "at least" :-) I2C, SPI and PCI devices are affected too, and 
after a closer look at USB today I believe USB devices are affected as well.

> 	"I'm actually considering moving that code to the device core as
> 	 it applies to all drivers that have device nodes, but I'm not
> 	 sure that will be feasible it won't hurt other devices
> 	 it applies to I2C and SPI as well at least and PCI too"
> 
> [1] https://linuxtv.org/irc/irclogger_log/media-maint?date=2017-11-23,Thu
> 
> For USB drivers, hot-unplug seems to work fine for media drivers,
> although keeping it working require tests from time to time, as
> it is not hard to break hotplug support. so, currently, I don't see
> the need of anything like that for non-platform drivers.

I2C, SPI and PCI are non-platform drivers, and USB seems to be affected too. 
The race window is small, making it difficult to reproduce the problem, but 
with carefully placed delays it gets much easier to hit the race.

> My point here is that adding a new lock inside the media core that
> would be used for all media drivers, including the ones that don't need
> doesn't sound a good idea.

Why not, if it doesn't affect performances (or anything else) negatively ?

> So, if this is something that applies to all platform drivers (including
> non-media ones), or if are there anything that can be done at driver's core
> that would improve hotplug support for all buses, making it more stable or
> easier to implement, then it would make sense to improve the driver's core.
> If not, this sounds a driver-specific issue whose fix doesn't belong to the
> media core.

It's clearly not a driver-specific issue as most, if not all, drivers are 
affected.

I've replied to Greg's e-mail in this thread with more details, let's try to 
keep the discussion there to avoid splitting it in multiple sub-threads.

-- 
Regards,

Laurent Pinchart
