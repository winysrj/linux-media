Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53944 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753133AbcHZXom (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 19:44:42 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v3 00/21] Make use of kref in media device, grab references as needed
Date: Sat, 27 Aug 2016 02:43:08 +0300
Message-Id: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This is the third version of the RFC set to fix referencing in media
devices.

The lifetime of the media device (and media devnode) is now bound to that
of struct device embedded in it and its memory is only released once the
last reference is gone: unregistering is simply unregistering, it no
longer should release memory which could be further accessed.
                                                                                
A video node or a sub-device node also gets a reference to the media
device, i.e. the release function of the video device node will release
its reference to the media device. The same goes for file handles to the
media device.
                                                                                
As a side effect of this is that the media device, it is allocate together
with the media devnode. The driver may also rely its own resources to the
media device. Alternatively there's also a priv field to hold drivers
private pointer (for container_of() is an option in this case). We could
drop one of these options but currently both are possible.
                                                                                
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

changes since v2:

- Rework the set in order to make the changes more consistent, easier to
  understand and better ordered.

- Properly change referencing media_dev->dev (patch "media device: Get the
  media device driver's device" added).

- Only set the release() callback to media device if the new
  media_device_alloc() API is used. (The callback just printed a debug
  message before this series.)

- Call cdev_del() before removing the device (patch 7).

- Document media_device_init() and media_device_cleanup() as deprecated.

- Spelling fixes.

The to-do list includes changes to drivers that can be physically removed.
Drivers not using the new API can mostly ignore these changes, albeit
media_device_init() now grabs a reference to struct device of the media
device which must be released.

-- 
Kind regards,
Sakari
