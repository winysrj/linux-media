Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbcGSH2F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 03:28:05 -0400
Subject: Re: [RFC 00/16] Make use of kref in media device, grab references as
 needed
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
References: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
 <20160715071913.009908a1@recife.lan>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <578DD673.2010601@linux.intel.com>
Date: Tue, 19 Jul 2016 10:27:47 +0300
MIME-Version: 1.0
In-Reply-To: <20160715071913.009908a1@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for your reply.

Mauro Carvalho Chehab wrote:
> Em Fri, 15 Jul 2016 01:34:55 +0300
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
>> Hi folks,
>>
>> I've been working on this for some time now but only got the full patchset
>> working some moments ago. The patchset properly, I believe, fixes the
>> issue of removing a device whilst streaming.
>>
>> Media device is refcounted and its memory is only released once the last
>> reference is gone: unregistering is simply unregistering, it no longer
>> should release memory which could be further accessed.
>>
>> A video node or a sub-device node also gets a reference to the media
>> device, i.e. the release function of the video device node will release
>> its reference to the media device. The same goes for file handles to the
>> media device.
>>
>> As a side effect of refcounting the media device, it is allocate together
>> with the media devnode. The driver may also rely its own resources to the
>> media device. Alternatively there's also a priv field to hold drivers
>> private pointer (for container_of() is an option in this case).
>>
>> I've tested this by manually unbinding the omap3isp platform device while
>> streaming. Driver changes are required for this to work; by not using
>> dynamic allocation (i.e. media_device_alloc()) the old behaviour is still
>> supported. This is still unlikely to be a grave problem as there are not
>> that many device drivers that support physically removable devices. We've
>> had this problem for other devices for many years without paying much
>> notice --- that doesn't mean I don't think at least drivers for removable
>> devices shouldn't be changed as part of the set later on, I'd just like to
>> get review comments on the approach first.
>>
>> The three patches that originally partially resolved some of these issues
>> are reverted in the beginning of the set. I'm still posting this as an RFC
>> mainly since the testing is somewhat limited so far.
> 
> 
> I didn't look inside this patch series. Won't likely have time to
> look at core changes before the end of the merge window. However,
> I found several structural problems on this RFC:
> 
> 1) Please do incremental changes, instead of reverting patches. It is
> really hard for reviewers to be sure that nothing breaks when someone
> simply reverts a previous approach and add its own.

I believe people are more familiar with the state of the code with the
reverts than without them. The first two reverted patches I don't really
have a problem with, but they depend on the third reverted patch which
is more problematic and they'll no longer be needed afterwards. To
refresh our memory:

<URL:http://www.spinics.net/lists/linux-media/msg100355.html>
<URL:http://www.spinics.net/lists/linux-media/msg100927.html>
<URL:http://www.spinics.net/lists/linux-media/msg100952.html>

> 
> 2) Each individual patch should not cause regressions to none of
> the existing drivers or to the core. The revert re-introduces bugs.

We've had the problem for five years without even realising it. What's
merged now is a workaround that avoids *some* of the underlying problems.

With the current media-master, the system still crashes if the device is
removed during video streaming. With this set (and appropriate driver
changes) it does not. Driver changes alone are not enough to fix this
either.

> 
> 3) Each patch should not break compilation. Patch 06/16, for example,
> changes the structure used by the release method:
> 
> -static void media_device_release(struct media_devnode *mdev)
> +static void media_device_release(struct media_devnode *devnode)
> 
> Without touching a single driver. That means compilation breakages.
> This is not acceptable upstream.
> 
> It should be touching *all* drivers that use the function altogether.

This change you're referring to in patch 06/16 changes the name of the
argument of a function to devnode. This change was missing from patch
"[media] media-devnode: fix namespace mess".

What comes to media_device_alloc() and media_device_get()/put(), their
use is optional. Driver changes are needed at least for drivers that can
be removed physically from the system. Once all drivers are converted,
we can remove the old API.

> 
> 4) From a very quick look at the series, without trying to compile the
> series (with would very likely break), it seems that all drivers that
> uses the media controller should be migrated to the new way.
> 
> It means that you'll need to patch all drivers altogether as you're
> changing the kAPI at the same patch you change it.

I want to first get the review comments on the API itself and then move
the removable drivers to use it. Individual drivers may still have
issues with removing devices while they're in use.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
