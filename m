Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37027
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752249AbcLOM5z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:57:55 -0500
Date: Thu, 15 Dec 2016 10:57:16 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg KH <greg@kroah.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH RFC] omap3isp: prevent releasing MC too early
Message-ID: <20161215105716.30186ff5@vento.lan>
In-Reply-To: <e4f884d2-9746-a728-3f75-1aa211721f5e@osg.samsung.com>
References: <20161214151406.20380-1-mchehab@s-opensource.com>
        <3043978.ViByGAdkJL@avalon>
        <20161215103734.716a0619@vento.lan>
        <e4f884d2-9746-a728-3f75-1aa211721f5e@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 15 Dec 2016 09:42:35 -0300
Javier Martinez Canillas <javier@osg.samsung.com> escreveu:

> Hello Mauro,
> 
> On 12/15/2016 09:37 AM, Mauro Carvalho Chehab wrote:
> 
> [snip]
> 
> > 
> > What happens is that omap3isp driver calls media_device_unregister()
> > too early. Right now, it is called at omap3isp_video_device_release(),
> > with happens when a driver unbind is ordered by userspace, and not after
> > the last usage of all /dev/video?? devices.
> > 
> > There are two possible fixes:
> > 
> > 1) at omap3isp_video_device_release(), streamoff all streams and mark
> > that the media device will be gone.

I actually meant to say: isp_unregister_entities() here.

> > 
> > 2) instead of using video_device_release_empty for the video->video.release,
> > create a omap3isp_video_device_release() that will call
> > media_device_unregister() when destroying the last /dev/video?? devnode.
> >  
> 
> There's also option (3), to have a proper refcounting to make sure that
> the media device node is not freed until all references to it are gone.

Yes, that's another alternative.

> I understand that's what Sakari's RFC patches do. I'll try to make some
> time tomorrow to test and review his patches.

The biggest problem with Sakari's patches is that it starts by 
reverting 3 patches, and this will cause regressions on existing
devices.

Development should be incremental.

I didn't review carefully his series (as it started the wrong way),
but I guess there's another problem on it: as OMAP3 remove entities
at isp_unregister_entities(), while adding a kref to media_device
will prevent an oops, the streamoff logic won't work anymore, as
the entities that were supposed to be at the graph will have been
removed by then.

Ok, we can roll the snow ball and add kref's to entities and links,
but IMHO, we're trying to kill a fly with a death star: instead,
the better is to just fix the driver in a way that it would be
streaming off everything at isp_unregister_entities(), before
dropping the entities and the media controller.

Regards,
Mauro
