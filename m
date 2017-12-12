Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47318 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752354AbdLLOya (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 09:54:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH/RFC 1/2] v4l: v4l2-dev: Add infrastructure to protect device unplug race
Date: Tue, 12 Dec 2017 16:54:32 +0200
Message-ID: <11553186.BHtCKiYHsT@avalon>
In-Reply-To: <20171123110751.72f76d7d@vento.lan>
References: <20171116003349.19235-1-laurent.pinchart+renesas@ideasonboard.com> <20171116003349.19235-2-laurent.pinchart+renesas@ideasonboard.com> <20171123110751.72f76d7d@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday, 23 November 2017 15:07:51 EET Mauro Carvalho Chehab wrote:
> Em Thu, 16 Nov 2017 02:33:48 +0200 Laurent Pinchart escreveu:
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
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/media/v4l2-core/v4l2-dev.c | 57 +++++++++++++++++++++++++++++++++
> >  include/media/v4l2-dev.h           | 47 +++++++++++++++++++++++++++++++
> >  2 files changed, 104 insertions(+)

[snip]

> I'm c/c Greg here, as I don't think, that, the way it is, it
> belongs at V4L2 core.
> 
> I mean: if this is a problem that affects all drivers, it would should,
> instead, be sitting at the driver's core.
> 
> If, otherwise, this is specific to rcar-vin (and other platform drivers),
> that's likely should be inside the drivers that require it.
> 
> That's said, I remember we had to add some things in the past for
> USB drivers hot unplug to happen softly. I don't remember the specifics
> anymore, but it was solved by both a V4L2 core and changes at USB
> drivers.
> 
> One of the things that it was added, on that time, was this patch:
> 
> 	commit ae6cfaace120f4330715b56265ce0e4a710e1276
> 	Author: Hans Verkuil <hverkuil@xs4all.nl>
> 	Date:   Sat Mar 14 08:28:45 2009 -0300
> 
> 	    V4L/DVB (11044): v4l2-device: add v4l2_device_disconnect
> 
> So, I would expect that a change at V4L2 core (or at driver core) that
> would be applied would also be affecting USB drivers disconnect logic
> and v4l2_device_disconnect() function.

I wasn't aware of v4l2_device_disconnect(), thank you for pointing it out.

I don't know what the full history behind that function is, but I don't see 
why it's needed. struct device instances are refcounted, the struct device 
corresponding to a USB device or USB interface doesn't get freed when a device 
is disconnected as long as a reference is present. We take such a reference in 
v4l2_device_register(), so there should be no problem.

[snip]

-- 
Regards,

Laurent Pinchart
