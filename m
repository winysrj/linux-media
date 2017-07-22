Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34605 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755095AbdGVLbA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Jul 2017 07:31:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: [PATCHv3 0/6] media: drop driver_version from media_device
Date: Sat, 22 Jul 2017 13:30:51 +0200
Message-Id: <20170722113057.45202-1-hverkuil@xs4all.nl>
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

In addition do the same with media_version, that too is never updated
when it should.

Regards,

	Hans

Changes since v2:

- remove obsolete comment about driver_version from media/media-device.h
- add patch to make the same change for media_version

Changes since v1:

- just set driver_version in media_device_get_info() and drop it
  in struct media_device.
- combine two lines in atomisp_v4l2.c

Hans Verkuil (6):
  media-device: set driver_version directly
  s3c-camif: don't set driver_version
  uvc: don't set driver_version
  atomisp2: don't set driver_version
  media-device: remove driver_version
  media: drop use of MEDIA_API_VERSION

 drivers/media/media-device.c                              | 6 +-----
 drivers/media/platform/s3c-camif/camif-core.c             | 1 -
 drivers/media/usb/uvc/uvc_driver.c                        | 1 -
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c | 6 +-----
 include/media/media-device.h                              | 7 -------
 include/uapi/linux/media.h                                | 5 +++--
 6 files changed, 5 insertions(+), 21 deletions(-)

-- 
2.13.2
