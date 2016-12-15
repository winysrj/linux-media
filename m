Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48264 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755985AbcLONYJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 08:24:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, javier@osg.samsung.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg KH <greg@kroah.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH RFC] omap3isp: prevent releasing MC too early
Date: Thu, 15 Dec 2016 15:24:44 +0200
Message-ID: <5206822.pU16mdzeII@avalon>
In-Reply-To: <20161215103734.716a0619@vento.lan>
References: <20161214151406.20380-1-mchehab@s-opensource.com> <3043978.ViByGAdkJL@avalon> <20161215103734.716a0619@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 15 Dec 2016 10:37:34 Mauro Carvalho Chehab wrote:
> Em Thu, 15 Dec 2016 14:13:42 +0200 Laurent Pinchart escreveu:
> > On Wednesday 14 Dec 2016 13:14:06 Mauro Carvalho Chehab wrote:
> >> Avoid calling streamoff without having the media structs allocated.
> >> 
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > 
> > The driver has a maintainer listed in MAINTAINERS, and you know that
> > Sakari is also actively involved here. You could have CC'ed us.
> 
> Yes, sure.
> 
> >> ---
> >> 
> >> Javier,
> >> 
> >> Could you please test this patch?
> >> 
> >> Thanks!
> >> Mauro
> >> 
> >>  drivers/media/platform/omap3isp/ispvideo.c | 10 ++++++++--
> >>  1 file changed, 8 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> >> b/drivers/media/platform/omap3isp/ispvideo.c index
> >> 7354469670b7..f60995ed0a1f 100644
> >> --- a/drivers/media/platform/omap3isp/ispvideo.c
> >> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> >> @@ -1488,11 +1488,17 @@ int omap3isp_video_register(struct isp_video
> >> *video, struct v4l2_device *vdev) "%s: could not register video device
> >> (%d)\n",> > 
> >>  			__func__, ret);
> >> 
> >> +	/* Prevent destroying MC before unregistering */
> >> +	kobject_get(vdev->v4l2_dev->mdev->devnode->dev.parent);
> > 
> > This doesn't even compile. Please make sure to at least compile-test
> > patches you send for review, otherwise you end up wasting time for all
> > reviewers and testers. I assume you meant
> > 
> > 	kobject_get(&vdev->mdev->devnode->dev.parent->kobj);
> > 
> > and similarly below.
> 
> Yes.
> 
> Btw, Javier tested it yesterday with the above fix, but it didn't solve the
> issue, because the problem is elsewhere.
> 
> What happens is that omap3isp driver calls media_device_unregister()
> too early. Right now, it is called at omap3isp_video_device_release(),

No, it's called from isp_unregister_entities() <- isp_remove() <- platform 
driver .remove.

> with happens when a driver unbind is ordered by userspace, and not after
> the last usage of all /dev/video?? devices.

That's the right place to *unregister* the media device, but of course not the 
right place to *free* it. Unregistering the media device means marking it as 
closed for business, ensuring at least that any new userspace request will be 
rejected. It doesn't mean that memory should be freed at that point, the 
object must still remain accessible in the kernel for as long as it has users.

> There are two possible fixes:
> 
> 1) at omap3isp_video_device_release(),

There's no such function. I assume you mean isp_remove().

> streamoff all streams and mark that the media device will be gone.

The hardware should certainly be stopped at .remove() time, but trying to fake 
a userspace API call there through the driver's back is another case of 
bypassing API layers, it's more a hack than a clean fix.

> 2) instead of using video_device_release_empty for the video->video.release,
> create a omap3isp_video_device_release() that will call
> media_device_unregister() when destroying the last /dev/video?? devnode.

As explained above, the media device should be unregistered at .remove() time. 
It should be freed at .remove() time.

The media device can be accessed through multiple means. Aside from the 
userspace API exposed through a devnode, we also store the media device 
pointer in v4l2_device, as well as in videodev and v4l2_subdev through the 
embedded media_entity. videodev and v4l2_subdev expose a userspace API that 
require a .release() handler for the corresponding device nodes (note that I'm 
talking about the file operations release handler, not the release handler for 
the structures themselves), and that .release() handler is implemented in a 
way that does or can dereference the media_device object.

For instance, the v4l2_subdev release handler subdev_close() contains the 
following code

        if (sd->internal_ops && sd->internal_ops->close)
                sd->internal_ops->close(sd, subdev_fh);
#if defined(CONFIG_MEDIA_CONTROLLER)
        if (sd->v4l2_dev->mdev)
                media_entity_put(&sd->entity);
#endif

that both accesses media objects directly, and allow the driver to do through 
its subdev .close() operation handler. The videodev .release() handler 
v4l2_release() has the same issue with

        if (vdev->fops->release)
                ret = vdev->fops->release(filp);

and then calls video_put() that ends up invoking v4l2_device_release() which 
does touch the media_device and then the struct videodev .release() operation, 
again implemented by drivers (although that one should just be one or multiple 
kfree in most cases).

There are lots of way in which the media_device structure can be accessed, 
sometimes probably for bad reasons, but most of the time for legitimate 
reasons. Instead of chasing them down all (which we will never be able to do 
as we're talking about driver code), we should make sure that media_device 
gets properly refcounted and only freed when safe.

We could in theory implement refcounting in the drivers, by implementing 
.release() handler for all the structure that hold a reference to media_device 
(v4l2_device, videodev and v4l2_subdev as explained above). The drivers would 
then need to count how many of those structures are still in use (as a driver 
can create multiple video nodes and/or subdev nodes for instance) and only 
free the media_device when that counter reaches 0.

That would however be really really wrong, as it would require complex code 
very prone to race conditions (anyone who has worked with USB devices should 
know that) in all drivers, including platform drivers whose unbind gets rarely 
tested. We should instead simplify it for drivers and implement that reference 
counting in the core.

> I have a half-baked patch for (2). I'll try to finish it and do some
> tests.
> 
> Unfortunately, I don't have any OMAP3 device that has a camera
> module, except for a N9 device with a damaged display.
> 
> Sakari,
> 
> Is there a way for me to use the N9 device to test it without a
> display? AFAIKT, the device is operational, and I *guess* it is
> on developer's mode, but not really sure.

-- 
Regards,

Laurent Pinchart

