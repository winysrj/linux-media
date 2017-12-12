Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47128 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbdLLOtI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 09:49:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 1/2] v4l: v4l2-dev: Add infrastructure to protect device unplug race
Date: Tue, 12 Dec 2017 16:49:10 +0200
Message-ID: <6414276.bWOzFEfRW5@avalon>
In-Reply-To: <8942419d-fc0e-7a82-cc35-a7960cd22800@xs4all.nl>
References: <20171116003349.19235-1-laurent.pinchart+renesas@ideasonboard.com> <20171116003349.19235-2-laurent.pinchart+renesas@ideasonboard.com> <8942419d-fc0e-7a82-cc35-a7960cd22800@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday, 17 November 2017 13:09:20 EET Hans Verkuil wrote:
> On 16/11/17 01:33, Laurent Pinchart wrote:
> > Device unplug being asynchronous, it naturally races with operations
> > performed by userspace through ioctls or other file operations on video
> > device nodes.
> > 
> > This leads to potential access to freed memory or to other resources
> > during device access if unplug occurs during device access. To solve
> > this, we need to wait until all device access completes when unplugging
> > the device, and block all further access when the device is being
> > unplugged.
> > 
> > Three new functions are introduced. The video_device_enter() and
> > video_device_exit() functions must be used to mark entry and exit from
> > all code sections where the device can be accessed. The
> > video_device_unplug() function is then used in the unplug handler to
> > mark the device as being unplugged and wait for all access to complete.
> > 
> > As an example mark the ioctl handler as a device access section. Other
> > file operations need to be protected too, and blocking ioctls (such as
> > VIDIOC_DQBUF) need to be handled as well.
> 
> As long as the queue field in struct video_device is filled in properly
> this shouldn't be a problem.
> 
> This looks pretty good, simple and straightforward.

Thank you.

> Do we need something similar for media_device? Other devices?

I believe so, which is why I'm wondering whether this shouldn't somehow go to 
the device core (and in the cdev core). Not all devices will need such an 
infrastructure as some subsystems already protect against device access after 
unbind (USB is one of them if I'm not mistaken), but it certainly shouldn't 
hurt.

DRM is also considering a similar implementation, but based on srcu to lower 
the performance penalty. I feel that's going a bit overboard but I have no 
numbers yet to confirm or infirm the suspicion.

> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/media/v4l2-core/v4l2-dev.c | 57 +++++++++++++++++++++++++++++++++
> >  include/media/v4l2-dev.h           | 47 +++++++++++++++++++++++++++++++
> >  2 files changed, 104 insertions(+)

[snip]

-- 
Regards,

Laurent Pinchart
