Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46984 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdLLOon (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 09:44:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 1/2] v4l: v4l2-dev: Add infrastructure to protect device unplug race
Date: Tue, 12 Dec 2017 16:44:45 +0200
Message-ID: <40897199.iaITco888f@avalon>
In-Reply-To: <7bbe2742-90e5-bad9-313b-102e2747885c@ideasonboard.com>
References: <20171116003349.19235-1-laurent.pinchart+renesas@ideasonboard.com> <20171116123236.kqvpoglodhs45x6l@valkosipuli.retiisi.org.uk> <7bbe2742-90e5-bad9-313b-102e2747885c@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Thursday, 16 November 2017 16:47:11 EET Kieran Bingham wrote:
> On 16/11/17 12:32, Sakari Ailus wrote:
> > Hi Laurent,
> > 
> > Thank you for the initiative to bring up and address the matter!
> 
> I concur - this looks like a good start towards managing the issue.
> 
> One potential thing spotted on top of Sakari's review inline below, of
> course I suspect this was more of a prototype/consideration patch.
> 
> > On Thu, Nov 16, 2017 at 02:33:48AM +0200, Laurent Pinchart wrote:
> >> Device unplug being asynchronous, it naturally races with operations
> >> performed by userspace through ioctls or other file operations on video
> >> device nodes.
> >> 
> >> This leads to potential access to freed memory or to other resources
> >> during device access if unplug occurs during device access. To solve
> >> this, we need to wait until all device access completes when unplugging
> >> the device, and block all further access when the device is being
> >> unplugged.
> >> 
> >> Three new functions are introduced. The video_device_enter() and
> >> video_device_exit() functions must be used to mark entry and exit from
> >> all code sections where the device can be accessed. The
> > 
> > I wonder if it'd help splitting this patch into two: one that introduces
> > the mechanism and the other that uses it. Up to you.
> > 
> > Nevertheless, it'd be better to have other system calls covered as well.
> > 
> >> video_device_unplug() function is then used in the unplug handler to
> >> mark the device as being unplugged and wait for all access to complete.
> >> 
> >> As an example mark the ioctl handler as a device access section. Other
> >> file operations need to be protected too, and blocking ioctls (such as
> >> VIDIOC_DQBUF) need to be handled as well.
> >> 
> >> Signed-off-by: Laurent Pinchart
> >> <laurent.pinchart+renesas@ideasonboard.com>
> >> ---
> >> 
> >>  drivers/media/v4l2-core/v4l2-dev.c | 57 ++++++++++++++++++++++++++++++++
> >>  include/media/v4l2-dev.h           | 47 +++++++++++++++++++++++++++++++
> >>  2 files changed, 104 insertions(+)
> >> 
> >> diff --git a/drivers/media/v4l2-core/v4l2-dev.c
> >> b/drivers/media/v4l2-core/v4l2-dev.c index c647ba648805..c73c6d49e7cf
> >> 100644
> >> --- a/drivers/media/v4l2-core/v4l2-dev.c
> >> +++ b/drivers/media/v4l2-core/v4l2-dev.c

[snip]

> >> @@ -351,6 +397,10 @@ static long v4l2_ioctl(struct file *filp, unsigned
> >> int cmd, unsigned long arg)
> >>  	struct video_device *vdev = video_devdata(filp);
> >>  	int ret = -ENODEV;
> > 
> > You could leave ret unassigned here.
> > 
> >> +	ret = video_device_enter(vdev);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >>  	if (vdev->fops->unlocked_ioctl) {
> >>  		struct mutex *lock = v4l2_ioctl_get_lock(vdev, cmd);
> >> 
> >> @@ -358,11 +408,14 @@ static long v4l2_ioctl(struct file *filp, unsigned
> >> int cmd, unsigned long arg)
> >>  			return -ERESTARTSYS;
> 
> It looks like that return -ERESTARTSYS might need a video_device_exit() too?

Oops. Of course. I'll fix that. Thanks for catching the issue.

> >>  		if (video_is_registered(vdev))
> >>  			ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
> >> +		else
> >> +			ret = -ENODEV;
> >>  		if (lock)
> >>  			mutex_unlock(lock);
> >>  	} else
> >>  		ret = -ENOTTY;
> >> 
> >> +	video_device_exit(vdev);
> >>  	return ret;
> >>  }

-- 
Regards,

Laurent Pinchart
