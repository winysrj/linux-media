Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34682 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402AbcGOKTU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 06:19:20 -0400
Date: Fri, 15 Jul 2016 07:19:13 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: Re: [RFC 00/16] Make use of kref in media device, grab references
 as needed
Message-ID: <20160715071913.009908a1@recife.lan>
In-Reply-To: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 15 Jul 2016 01:34:55 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi folks,
> 
> I've been working on this for some time now but only got the full patchset
> working some moments ago. The patchset properly, I believe, fixes the
> issue of removing a device whilst streaming.
> 
> Media device is refcounted and its memory is only released once the last
> reference is gone: unregistering is simply unregistering, it no longer
> should release memory which could be further accessed.
> 
> A video node or a sub-device node also gets a reference to the media
> device, i.e. the release function of the video device node will release
> its reference to the media device. The same goes for file handles to the
> media device.
> 
> As a side effect of refcounting the media device, it is allocate together
> with the media devnode. The driver may also rely its own resources to the
> media device. Alternatively there's also a priv field to hold drivers
> private pointer (for container_of() is an option in this case).
> 
> I've tested this by manually unbinding the omap3isp platform device while
> streaming. Driver changes are required for this to work; by not using
> dynamic allocation (i.e. media_device_alloc()) the old behaviour is still
> supported. This is still unlikely to be a grave problem as there are not
> that many device drivers that support physically removable devices. We've
> had this problem for other devices for many years without paying much
> notice --- that doesn't mean I don't think at least drivers for removable
> devices shouldn't be changed as part of the set later on, I'd just like to
> get review comments on the approach first.
> 
> The three patches that originally partially resolved some of these issues
> are reverted in the beginning of the set. I'm still posting this as an RFC
> mainly since the testing is somewhat limited so far.


I didn't look inside this patch series. Won't likely have time to
look at core changes before the end of the merge window. However,
I found several structural problems on this RFC:

1) Please do incremental changes, instead of reverting patches. It is
really hard for reviewers to be sure that nothing breaks when someone
simply reverts a previous approach and add its own.

2) Each individual patch should not cause regressions to none of
the existing drivers or to the core. The revert re-introduces bugs.

3) Each patch should not break compilation. Patch 06/16, for example,
changes the structure used by the release method:

-static void media_device_release(struct media_devnode *mdev)
+static void media_device_release(struct media_devnode *devnode)

Without touching a single driver. That means compilation breakages.
This is not acceptable upstream.

It should be touching *all* drivers that use the function altogether.

4) From a very quick look at the series, without trying to compile the
series (with would very likely break), it seems that all drivers that
uses the media controller should be migrated to the new way.

It means that you'll need to patch all drivers altogether as you're
changing the kAPI at the same patch you change it.

So, please rework your patch series to make it easier for everybody
to review and test it.

Thanks,
Mauro
