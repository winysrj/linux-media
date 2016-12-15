Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47803 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932595AbcLOKie (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 05:38:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [RFC v3 00/21] Make use of kref in media device, grab references as needed
Date: Thu, 15 Dec 2016 12:39:09 +0200
Message-ID: <1604260.508DyjIRC9@avalon>
In-Reply-To: <2384102b-33d4-7c97-e9bd-69e875dc651e@osg.samsung.com>
References: <20161109154608.1e578f9e@vento.lan> <20161213102447.60990b1c@vento.lan> <2384102b-33d4-7c97-e9bd-69e875dc651e@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday 13 Dec 2016 15:23:53 Shuah Khan wrote:
> On 12/13/2016 05:24 AM, Mauro Carvalho Chehab wrote:
> > Em Tue, 13 Dec 2016 12:53:05 +0200 Sakari Ailus escreveu:
> >> On Tue, Nov 29, 2016 at 09:13:05AM -0200, Mauro Carvalho Chehab wrote:
> >>> Hi Sakari,
> >>> 
> >>> I answered you point to point below, but I suspect that you missed how
> >>> the current approach works. So, I decided to write a quick summary here.
> >>> 
> >>> The character devices /dev/media? are created via cdev, with relies on a
> >>> kobject per device, with has an embedded struct kref inside.
> >>> 
> >>> Also, each kobj at /dev/media0, /dev/media1, ... is associated with a
> >>> 
> >>> struct device, when the code does:
> >>> 	devnode->cdev.kobj.parent = &devnode->dev.kobj;
> >>> 
> >>> before calling cdev_add().
> >>> 
> >>> The current lifetime management is actually based on cdev's kobject's
> >>> refcount, provided by its embedded kref.
> >>> 
> >>> The kref warrants that any data associated with /dev/media0 won't be
> >>> freed if there are any pending system call. In other words, when
> >>> cdev_del() is called, it will remove /dev/media0 from the filesystem,
> >>> and
> >>> will call kobject_put().
> >>> 
> >>> If the refcount is zero, it will call devnode->dev.release(). If the
> >>> kobject refcount is not zero, the data won't be freed.
> >>> 
> >>> So, in the best case scenario, there's no opened file descriptors
> >>> by the time media device node is unregistered. So, it will free
> >>> everything.
> >>> 
> >>> In the worse case scenario, e. g. when the driver is removed or
> >>> unbind while /dev/media0 has some opened file descriptor(s),
> >>> the cdev logic will do the proper lifetime management.
> >>> 
> >>> On such case, /dev/media0 disappears from the file system, so another
> >>> open
> >>> is not possible anymore. The data structures will remain allocated until
> >>> all associated file descriptors are not closed.
> >>> 
> >>> When all file descriptors are closed, the data will be freed.
> >>> 
> >>> On that time, it will call an optional dev.release() callback,
> >>> responsible to free any other data struct that the driver allocated.
> >> 
> >> The patchset does not change this. It's not a question of the
> >> media_devnode struct either. That's not an issue.
> >> 
> >> The issue is rather what else can be accessed through the media device
> >> and other interfaces. As IOCTLs are not serialised with device removal
> >> (which now releases much of the data structures)
> > 
> > Huh? ioctls are serialized with struct device removal. The Driver core
> > warrants that.

Code references please.
 
> >> there's a high chance of accessing
> >> released memory (or mutexes that have been already destroyed). An example
> >> of that is here, stopping a running pipeline after unbinding the device.
> >> What happens there is that the media device is released whilst it's in
> >> use through the video device.
> >> 
> >> <URL:http://www.retiisi.org.uk/v4l2/tmp/media-ref-dmesg2.txt>
> > 
> > It is not clear from the logs what the driver tried to do, but
> > that sounds like a driver's bug, with was not prepared to properly
> > handle unbinds.
> > 
> > The problem here is that isp_video_release() is called by V4L2
> > release logic, and not by the MC one:
> > 
> > static const struct v4l2_file_operations isp_video_fops = {
> > 	.owner		= THIS_MODULE,
> > 	.open		= isp_video_open,
> > 	.release	= isp_video_release,
> > 	.poll		= vb2_fop_poll,
> > 	.unlocked_ioctl	= video_ioctl2,
> > 	.mmap		= vb2_fop_mmap,
> > };
> > 
> > It seems that the driver's logic allows it to be called before or
> > after destroying the MC.
> 
> Right isp_video_release() will definitely be called after driver is
> gone which means media device is gone and the device itself.

Certainly not after the driver is gone (as in the module being unloaded from 
memory), but it can be called after the device is unbound from the driver, 
yes.

> Both au0828 and em28xx have these release handlers. Neither one uses
> devm resource for their device structs.

And no driver exposing objects to userspace-accessible code paths should. I've 
been pointing at how devm_kzalloc() is abused for more than a year now, it's 
nice to see that people slowly start listening.

> Also, both em28xx and au0828 keep disconnected state and have logic
> to detect the state of the driver and device. em28xx holds reference
> to v4l2->ref

That's very, very wrong. The v4l2_device::ref field must *not* be touched by 
drivers. Acquiring and releasing references to v4l2_device instances must be 
done with v4l2_device_get() and v4l2_device_put(), and the structure has a 
release handler that drivers can use. Why do people write such horrible code 
that pokes at private fields ?

> and releases the reference in em28xx_v4l2_close() which is
> its v4l2_file_operations .release handler. It also makes sure to not
> touch device hardware if device is disconnected.
> 
> Also, media graph access is done only when it has a valid media_device.
> au0828 allocates media_device struct and it gets free'd when it does
> its unregister sequence. Subsequent calls will check if it is null.

This is very wrong too. Don't try to handle data structures being pulled from 
under the driver's feet at random times. At best you will end up with races. 
Data structures must instead be properly refcounted.

> It also does checks to see if media_device is registered or not in
> some cases.
> 
> isp_video_release() isn't safe to be called after isp device is gone,
> leave alone media_device. Since isp is a devm resource, it is long
> gone when device_release() release managed resources.
> 
> I agree with Mauro that this is a driver problem.

No. There *is* a driver problem caused by devm_kzalloc() usage, and that 
problem *must* be fixed, but the media device life time management is also 
completely broken in core code.

> Mauro and I did lot of work to get the USB drivers (em28xx and au0828) to
> handle disconnect and unbind cases even before the media controller support
> was added to them.
> 
> I think what needs to happen is:
> 
> 1. Remove devm use from omap3

Absolutely.

> 2. Make sure media graph isn't accessed after media_device is unregistered

No way. We need to access the graph from the release handlers of the 
userspace-exposed structures (videodev and possibly media_device). The 
media_device structure must *not* disappear at unregistration time.

> 3. Take reference to v4l2 device to be able to make sanity checks from
>    isp_video_release() to determine if media_device is still around and
>    then do stop stream etc. It has to keep state.
> 
> I agree with Mauro that this is a driver problem. Mauro and I did lot
> of work to get the USB drivers (em28xx and au0828) to handle disconnect
> and unbind cases even before the media controller support was added to
> them.
> 
> Please don't pursue this RFC series that makes mc-core changes until
> ompa3 driver problems are addressed. There is no need to change the
> core unless it is necessary.

It is necessary as has been explained countless times, and will become more 
and more necessary as media_device instances get shared between multiple 
drivers, which is currently attempted *without* reference counting.

> I would be happy to help, unfortunately I don't have a omap3 device
> to fix and test problems. I am unable to find any omap3 devices. The
> one I have isn't good.

-- 
Regards,

Laurent Pinchart

