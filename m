Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:43931 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753626AbdGUJCh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 05:02:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: [PATCH 0/4] media: set driver_version in media_device_init
Date: Fri, 21 Jul 2017 11:02:30 +0200
Message-Id: <20170721090234.6501-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Just a little thing that always annoyed me: the driver_version should
be set in media_device_init, not in the drivers themselves.

The version number never, ever gets updated in drivers. We saw that in
the other media subsystems and now the core always sets it, not drivers.

This works much better, and also works well when backporting the media
code to an older kernel using the media_build system, where the driver
version is set to the kernel version you are backporting from.

Note: the media_device driver_version does not appear to be set in the
omap3isp driver, so I assume it returns 0 as the version? Is that indeed
the case or did I miss something?

Regards,

	Hans

Hans Verkuil (4):
  media-device: set driver_version in media_device_init
  s3c-camif: don't set driver_version anymore
  uvc: don't set driver_version anymore
  atomisp2: don't set driver_version anymore

 drivers/media/media-device.c                              | 4 +---
 drivers/media/platform/s3c-camif/camif-core.c             | 1 -
 drivers/media/usb/uvc/uvc_driver.c                        | 1 -
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c | 5 +----
 4 files changed, 2 insertions(+), 9 deletions(-)

-- 
2.13.2
