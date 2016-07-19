Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59576 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbcGSLuk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 07:50:40 -0400
Date: Tue, 19 Jul 2016 08:50:34 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: Re: [RFC 00/16] Make use of kref in media device, grab references
 as needed
Message-ID: <20160719085034.26f2ab6b@recife.lan>
In-Reply-To: <578DD673.2010601@linux.intel.com>
References: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
	<20160715071913.009908a1@recife.lan>
	<578DD673.2010601@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Jul 2016 10:27:47 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Mauro,
> 
> Thank you for your reply.
> 
> Mauro Carvalho Chehab wrote:
> > Em Fri, 15 Jul 2016 01:34:55 +0300
> > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> >   
> >> Hi folks,
> >>
> >> I've been working on this for some time now but only got the full patchset
> >> working some moments ago. The patchset properly, I believe, fixes the
> >> issue of removing a device whilst streaming.
> >>
> >> Media device is refcounted and its memory is only released once the last
> >> reference is gone: unregistering is simply unregistering, it no longer
> >> should release memory which could be further accessed.
> >>
> >> A video node or a sub-device node also gets a reference to the media
> >> device, i.e. the release function of the video device node will release
> >> its reference to the media device. The same goes for file handles to the
> >> media device.
> >>
> >> As a side effect of refcounting the media device, it is allocate together
> >> with the media devnode. The driver may also rely its own resources to the
> >> media device. Alternatively there's also a priv field to hold drivers
> >> private pointer (for container_of() is an option in this case).
> >>
> >> I've tested this by manually unbinding the omap3isp platform device while
> >> streaming. Driver changes are required for this to work; by not using
> >> dynamic allocation (i.e. media_device_alloc()) the old behaviour is still
> >> supported. This is still unlikely to be a grave problem as there are not
> >> that many device drivers that support physically removable devices. We've
> >> had this problem for other devices for many years without paying much
> >> notice --- that doesn't mean I don't think at least drivers for removable
> >> devices shouldn't be changed as part of the set later on, I'd just like to
> >> get review comments on the approach first.
> >>
> >> The three patches that originally partially resolved some of these issues
> >> are reverted in the beginning of the set. I'm still posting this as an RFC
> >> mainly since the testing is somewhat limited so far.  
> > 
> > 
> > I didn't look inside this patch series. Won't likely have time to
> > look at core changes before the end of the merge window. However,
> > I found several structural problems on this RFC:
> > 
> > 1) Please do incremental changes, instead of reverting patches. It is
> > really hard for reviewers to be sure that nothing breaks when someone
> > simply reverts a previous approach and add its own.  
> 
> I believe people are more familiar with the state of the code with the
> reverts than without them. 

What people are more familiar depends on what each person knows and
when he lastly looked at the code. Kernel's policy is to not build patches
based on what you think the others know, but, instead, we develop stuff
incrementally.

So, if you want such patch series to be reviewed and merged, you should
apply incremental changes, not destroy everything before applying
your stuff, because your work were based on a past version.

Btw, one of the things I'm missing on this series is what's the problem
you're still facing with the upstream version, as you didn't add any
descripton and OOPSes that you're noticing upstream.

Anyone reviewing this series would need to be able to reproduce such
problem, and add to their existing test case scenarios, to be sure
that the solution won't cause regressions to their own scenarios
and will solve for yours.

> The first two reverted patches I don't really
> have a problem with, but they depend on the third reverted patch which
> is more problematic and they'll no longer be needed afterwards. To
> refresh our memory:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg100355.html>
> <URL:http://www.spinics.net/lists/linux-media/msg100927.html>
> <URL:http://www.spinics.net/lists/linux-media/msg100952.html>
> 
> > 
> > 2) Each individual patch should not cause regressions to none of
> > the existing drivers or to the core. The revert re-introduces bugs.  
> 
> We've had the problem for five years without even realising it. What's
> merged now is a workaround that avoids *some* of the underlying problems.

I don't doubt that there are still underlying problems. Making
a race-free solution for the drivers bind/unbind scenario is not
trivial. Yet, as I said before, we need not only the patches but
the scenarios you're testing, for us to be able to reproduce your
problem and verify that your solution solves it, without causing
regressions to other test scenarios.

> With the current media-master, the system still crashes if the device is
> removed during video streaming. With this set (and appropriate driver
> changes) it does not. Driver changes alone are not enough to fix this
> either.

The best way to test such scenario would be, IMHO, to add patches for
some USB driver, like uvcvideo or au0828, as, there you can actually
physically remove the hardware while streaming.

One problem with OMAP3 driver is that the OMAP3 CPU is a single
core one. So, you won't see there any CPU concurrency issues.

> > 
> > 3) Each patch should not break compilation. Patch 06/16, for example,
> > changes the structure used by the release method:
> > 
> > -static void media_device_release(struct media_devnode *mdev)
> > +static void media_device_release(struct media_devnode *devnode)
> > 
> > Without touching a single driver. That means compilation breakages.
> > This is not acceptable upstream.
> > 
> > It should be touching *all* drivers that use the function altogether.  
> 
> This change you're referring to in patch 06/16 changes the name of the
> argument of a function to devnode. This change was missing from patch
> "[media] media-devnode: fix namespace mess".

What I'm saying is that, every time you change the arguments of a
function, *all* drivers using such function should be changed at the
same time, as otherwise, the Kernel won't build anymore after such
patch. I used patch 6/16 only as an example.

If this patch is, instead, a fixup for the "fix namespace mess"
patch, just submit it outside this RFC patch series.

> What comes to media_device_alloc() and media_device_get()/put(), their
> use is optional. Driver changes are needed at least for drivers that can
> be removed physically from the system. Once all drivers are converted,
> we can remove the old API.
> 
> > 
> > 4) From a very quick look at the series, without trying to compile the
> > series (with would very likely break), it seems that all drivers that
> > uses the media controller should be migrated to the new way.
> > 
> > It means that you'll need to patch all drivers altogether as you're
> > changing the kAPI at the same patch you change it.  
> 
> I want to first get the review comments on the API itself and then move
> the removable drivers to use it. Individual drivers may still have
> issues with removing devices while they're in use.

I can only review and test this patch series after:

1) knowing the test scenarios you're using and the OOPS you're
   getting;

2) having the changes applied to an USB driver, as my multi-core
   test machines only support USB devices.

-- 
Thanks,
Mauro
