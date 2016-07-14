Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40436 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752092AbcGNWfX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 18:35:23 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [RFC 00/16] Make use of kref in media device, grab references as needed
Date: Fri, 15 Jul 2016 01:34:55 +0300
Message-Id: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

I've been working on this for some time now but only got the full patchset
working some moments ago. The patchset properly, I believe, fixes the
issue of removing a device whilst streaming.

Media device is refcounted and its memory is only released once the last
reference is gone: unregistering is simply unregistering, it no longer
should release memory which could be further accessed.

A video node or a sub-device node also gets a reference to the media
device, i.e. the release function of the video device node will release
its reference to the media device. The same goes for file handles to the
media device.

As a side effect of refcounting the media device, it is allocate together
with the media devnode. The driver may also rely its own resources to the
media device. Alternatively there's also a priv field to hold drivers
private pointer (for container_of() is an option in this case).

I've tested this by manually unbinding the omap3isp platform device while
streaming. Driver changes are required for this to work; by not using
dynamic allocation (i.e. media_device_alloc()) the old behaviour is still
supported. This is still unlikely to be a grave problem as there are not
that many device drivers that support physically removable devices. We've
had this problem for other devices for many years without paying much
notice --- that doesn't mean I don't think at least drivers for removable
devices shouldn't be changed as part of the set later on, I'd just like to
get review comments on the approach first.

The three patches that originally partially resolved some of these issues
are reverted in the beginning of the set. I'm still posting this as an RFC
mainly since the testing is somewhat limited so far.

-- 
Kind regards,
Sakari

