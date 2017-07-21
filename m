Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43240 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750756AbdGUK5K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 06:57:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: [PATCHv2 0/5] media: drop driver_version from media_device
Date: Fri, 21 Jul 2017 12:57:01 +0200
Message-Id: <20170721105706.40703-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Just a little thing that always annoyed me: the driver_version shouldn't
be set in drivers.

The version number never, ever gets updated in drivers. We saw that in
the other media subsystems and now the core always sets it, not drivers.

This works much better, and also works well when backporting the media
code to an older kernel using the media_build system, where the driver
version is set to the kernel version you are backporting from.

So just set the driver_version in media_device_get_info() to
LINUX_VERSION_CODE and drop the driver_version field from struct
media_device.

Regards,

	Hans

Changes since v2:

- just set driver_version in media_device_get_info() and drop it
  in struct media_device.
- combine two lines in atomisp_v4l2.c

Hans Verkuil (5):
  media-device: set driver_version directly
  s3c-camif: don't set driver_version
  uvc: don't set driver_version
  atomisp2: don't set driver_version
  media-device: remove driver_version

 drivers/media/media-device.c                              | 5 +----
 drivers/media/platform/s3c-camif/camif-core.c             | 1 -
 drivers/media/usb/uvc/uvc_driver.c                        | 1 -
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c | 6 +-----
 include/media/media-device.h                              | 2 --
 5 files changed, 2 insertions(+), 13 deletions(-)

-- 
2.13.2
