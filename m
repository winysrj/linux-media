Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:49970 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbcCZEiv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2016 00:38:51 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	perex@perex.cz, tiwai@suse.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	jh1009.sung@samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [RFC PATCH 0/4] Media Device Allocator API 
Date: Fri, 25 Mar 2016 22:38:41 -0600
Message-Id: <cover.1458966594.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are known problems with media device life time management. When media
device is released while an media ioctl is in progress, ioctls fail with
use-after-free errors and kernel hangs in some cases.

Media Device can be in any the following states:

- Allocated
- Registered (could be tied to more than one driver)
- Unregistered, not in use (media device file is not open)
- Unregistered, in use (media device file is not open)
- Released

When media device belongs to  more than one driver, registrations should be
refcounted to avoid unregistering when one of the drivers does unregister.
A refcount field in the struct media_device covers this case. Unregister on
a Media Allocator media device is a kref_put() call. The media device should
be unregistered only when the last unregister occurs.


When a media device is in use when it is unregistered, it should not be
released until the application exits when it detects the unregistered
status. Media device that is in use when it is unregistered is moved to
to_delete_list. When the last unregister occurs, media device is unregistered
and becomes an unregistered, still allocated device. Unregister marks the
device to be deleted.

When media device belongs to more than one driver, as both drivers could be
unbound/bound, driver should not end up getting stale media device that is
on its way out. Moving the unregistered media device to to_delete_list helps
this case as well.

I am sending this RFC series out for review. I tested to verify media ioctls
don't fail when media device is unregistered and it gets released when the
last reference goes. I still need to do more testing. I didb't fully test
if the media device gets deleted in all cases. So please consider this as
work in progress. I decided to send this out to get early review to see if
this solution is viable.

Shuah Khan (4):
  media: Add Media Device Allocator API
  media: Add Media Device Allocator API documentation
  media: Add refcount to keep track of media device registrations
  drivers: change au0828, uvcvideo, snd-usb-audio to use Media Device
    Allocator

 drivers/media/Makefile                 |   3 +-
 drivers/media/media-dev-allocator.c    | 153 +++++++++++++++++++++++++++++++++
 drivers/media/media-device.c           |  53 ++++++++++++
 drivers/media/media-devnode.c          |   3 +
 drivers/media/usb/au0828/au0828-core.c |   7 +-
 drivers/media/usb/au0828/au0828.h      |   1 +
 drivers/media/usb/uvc/uvc_driver.c     |  32 ++++---
 drivers/media/usb/uvc/uvcvideo.h       |   3 +-
 include/media/media-dev-allocator.h    | 113 ++++++++++++++++++++++++
 include/media/media-device.h           |  32 +++++++
 sound/usb/media.c                      |  10 ++-
 sound/usb/media.h                      |   1 +
 12 files changed, 390 insertions(+), 21 deletions(-)
 create mode 100644 drivers/media/media-dev-allocator.c
 create mode 100644 include/media/media-dev-allocator.h

-- 
2.5.0

