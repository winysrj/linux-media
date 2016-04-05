Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:50220 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbcDEDgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2016 23:36:11 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	perex@perex.cz, tiwai@suse.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	jh1009.sung@samsung.com, ricard.wanderlof@axis.com,
	julian@jusst.de, pierre-louis.bossart@linux.intel.com,
	clemens@ladisch.de, dominic.sacre@gmx.de, takamichiho@gmail.com,
	johan@oljud.se, geliangtang@163.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [RFC PATCH v2 0/5] Media Device Allocator API
Date: Mon,  4 Apr 2016 21:35:55 -0600
Message-Id: <cover.1459825702.git.shuahkh@osg.samsung.com>
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
tracked to avoid unregistering when one of the drivers does unregister. A new
num_drivers field in the struct media_device covers this case. The media device
should be unregistered only when the last unregister occurs with num_drivers
count zero.

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

I ran bind/unbind loop tests on uvcvideo, au0828, and snd-usb-audio while
running application that does ioctls. Didn't see any use-after-free errors
on media device. A couple of known issues seen:

1. When application exits, cdev_put() gets called after media device is
   released. This is a known issue to resolve and Media Device Allocator
   can't solve this one.
2. When au0828 module is removed and then ioctls fail when cdev_get() looks
   for the owning module as au0828 is very often the module that owns the
   media devnode. This is a cdev related issue that needs to be resolved and
   Media Device Allocator can't solve this one.

Shuah Khan (5):
  media: Add Media Device Allocator API
  media: Add driver count to keep track of media device registrations
  media: uvcvideo change to use Media Device Allocator API
  media: au0828 change to use Media Device Allocator API
  sound/usb: Use Media Controller API to share media resources

 drivers/media/Makefile                 |   3 +-
 drivers/media/media-dev-allocator.c    | 154 ++++++++++++++++
 drivers/media/media-device.c           |  49 ++++-
 drivers/media/media-devnode.c          |  10 +-
 drivers/media/usb/au0828/au0828-core.c |  40 +++--
 drivers/media/usb/au0828/au0828.h      |   1 +
 drivers/media/usb/uvc/uvc_driver.c     |  36 ++--
 drivers/media/usb/uvc/uvcvideo.h       |   3 +-
 include/media/media-dev-allocator.h    | 116 ++++++++++++
 include/media/media-device.h           |  31 ++++
 sound/usb/Kconfig                      |   4 +
 sound/usb/Makefile                     |   2 +
 sound/usb/card.c                       |  14 ++
 sound/usb/card.h                       |   3 +
 sound/usb/media.c                      | 320 +++++++++++++++++++++++++++++++++
 sound/usb/media.h                      |  73 ++++++++
 sound/usb/mixer.h                      |   3 +
 sound/usb/pcm.c                        |  28 ++-
 sound/usb/quirks-table.h               |   1 +
 sound/usb/stream.c                     |   2 +
 sound/usb/usbaudio.h                   |   6 +
 21 files changed, 862 insertions(+), 37 deletions(-)
 create mode 100644 drivers/media/media-dev-allocator.c
 create mode 100644 include/media/media-dev-allocator.h
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.5.0

