Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36963
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753090AbcLOMhp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:37:45 -0500
Date: Thu, 15 Dec 2016 10:37:34 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, javier@osg.samsung.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg KH <greg@kroah.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH RFC] omap3isp: prevent releasing MC too early
Message-ID: <20161215103734.716a0619@vento.lan>
In-Reply-To: <3043978.ViByGAdkJL@avalon>
References: <20161214151406.20380-1-mchehab@s-opensource.com>
        <3043978.ViByGAdkJL@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 15 Dec 2016 14:13:42 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> (CC'ing Greg)
> 
> On Wednesday 14 Dec 2016 13:14:06 Mauro Carvalho Chehab wrote:
> > Avoid calling streamoff without having the media structs allocated.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> The driver has a maintainer listed in MAINTAINERS, and you know that Sakari is 
> also actively involved here. You could have CC'ed us.

Yes, sure.

> 
> > ---
> > 
> > Javier,
> > 
> > Could you please test this patch?
> > 
> > Thanks!
> > Mauro
> > 
> >  drivers/media/platform/omap3isp/ispvideo.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/ispvideo.c
> > b/drivers/media/platform/omap3isp/ispvideo.c index
> > 7354469670b7..f60995ed0a1f 100644
> > --- a/drivers/media/platform/omap3isp/ispvideo.c
> > +++ b/drivers/media/platform/omap3isp/ispvideo.c
> > @@ -1488,11 +1488,17 @@ int omap3isp_video_register(struct isp_video *video,
> > struct v4l2_device *vdev) "%s: could not register video device (%d)\n",
> >  			__func__, ret);
> > 
> > +	/* Prevent destroying MC before unregistering */
> > +	kobject_get(vdev->v4l2_dev->mdev->devnode->dev.parent);  
> 
> This doesn't even compile. Please make sure to at least compile-test patches 
> you send for review, otherwise you end up wasting time for all reviewers and 
> testers. I assume you meant
> 
> 	kobject_get(&vdev->mdev->devnode->dev.parent->kobj);
> 
> and similarly below.

Yes.

Btw, Javier tested it yesterday with the above fix, but it didn't solve the
issue, because the problem is elsewhere.

What happens is that omap3isp driver calls media_device_unregister()
too early. Right now, it is called at omap3isp_video_device_release(),
with happens when a driver unbind is ordered by userspace, and not after
the last usage of all /dev/video?? devices.

There are two possible fixes:

1) at omap3isp_video_device_release(), streamoff all streams and mark
that the media device will be gone.

2) instead of using video_device_release_empty for the video->video.release,
create a omap3isp_video_device_release() that will call
media_device_unregister() when destroying the last /dev/video?? devnode.

I have a half-baked patch for (2). I'll try to finish it and do some
tests.

Unfortunately, I don't have any OMAP3 device that has a camera
module, except for a N9 device with a damaged display.

Sakari,

Is there a way for me to use the N9 device to test it without a
display? AFAIKT, the device is operational, and I *guess* it is
on developer's mode, but not really sure.

Thanks,
Mauro
