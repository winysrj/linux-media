Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48447 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752990AbcLOOFE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 09:05:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg KH <greg@kroah.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH RFC] omap3isp: prevent releasing MC too early
Date: Thu, 15 Dec 2016 16:04:51 +0200
Message-ID: <2965200.xcWXyJedNO@avalon>
In-Reply-To: <20161215105716.30186ff5@vento.lan>
References: <20161214151406.20380-1-mchehab@s-opensource.com> <e4f884d2-9746-a728-3f75-1aa211721f5e@osg.samsung.com> <20161215105716.30186ff5@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 15 Dec 2016 10:57:16 Mauro Carvalho Chehab wrote:
> Em Thu, 15 Dec 2016 09:42:35 -0300 Javier Martinez Canillas escreveu:
> > On 12/15/2016 09:37 AM, Mauro Carvalho Chehab wrote:
> > 
> > [snip]
> > 
> >> What happens is that omap3isp driver calls media_device_unregister()
> >> too early. Right now, it is called at omap3isp_video_device_release(),
> >> with happens when a driver unbind is ordered by userspace, and not after
> >> the last usage of all /dev/video?? devices.
> >> 
> >> There are two possible fixes:
> >> 
> >> 1) at omap3isp_video_device_release(), streamoff all streams and mark
> >> that the media device will be gone.
> 
> I actually meant to say: isp_unregister_entities() here.
> 
> >> 2) instead of using video_device_release_empty for the
> >> video->video.release, create a omap3isp_video_device_release() that
> >> will call media_device_unregister() when destroying the last /dev/video??
> >> devnode.
> > 
> > There's also option (3), to have a proper refcounting to make sure that
> > the media device node is not freed until all references to it are gone.
> 
> Yes, that's another alternative.

And I think that's the only one that will bring us sanity in the long term.

> > I understand that's what Sakari's RFC patches do. I'll try to make some
> > time tomorrow to test and review his patches.
> 
> The biggest problem with Sakari's patches is that it starts by
> reverting 3 patches, and this will cause regressions on existing
> devices.
> 
> Development should be incremental.

Yes, it should, but there's also a reason git has a revert command. When 
patches are broken they should be reverted. Broken means that they do more 
harm than good. This is usually understood as introducing a bug worse than the 
gain the patch is supposed to bring. Broken can also mean that the patch makes 
incremental development of a proper solution very difficult while still 
failing to fix the initial problem completely. I believe the three patches in 
question fall into that category. And let's not take this personally, I don't 
care who have authored them, and there's certainly no shame getting a patch 
reverted. It should be considered as a review that comes after merge, it might 
not be the most pleasant one, but we I'm sure we all appreciate how reviews 
help use avoiding the same mistakes in the future and improving ourselves.

> I didn't review carefully his series (as it started the wrong way),

Please review it, as we need to get an agreement on the direction we want to 
take. Then we can discuss whether the reverts are really such a problem. I 
don't think inflicting ourselves the pain that would come with pure 
incremental development would bring us anything good, especially if we 
consider that we'll merge the reverts with the patch series that fixes the 
problem, so we're talking about bisection of unbind code paths that remained 
broken for years before the attempted fix, and are still broken with it as 
current code is racy anyway.

> but I guess there's another problem on it: as OMAP3 remove entities
> at isp_unregister_entities(), while adding a kref to media_device
> will prevent an oops, the streamoff logic won't work anymore, as
> the entities that were supposed to be at the graph will have been
> removed by then.

We need to fix drivers, that's for sure, and we're working on the OMAP3 ISP 
driver first as a proof of concept.

> Ok, we can roll the snow ball and add kref's to entities and links,
> but IMHO, we're trying to kill a fly with a death star: instead,
> the better is to just fix the driver in a way that it would be
> streaming off everything at isp_unregister_entities(), before
> dropping the entities and the media controller.

That won't be enough. Even if you're not entirely convinced by the reasons 
explained in this mail thread, remember that we will need sooner or later to 
implement support for media graph update at runtime. Refcounting will be 
needed, let's design it in the cleanest possible way.

-- 
Regards,

Laurent Pinchart

