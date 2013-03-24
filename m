Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4277 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab3CXJSX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 05:18:23 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id r2O9IJFx085446
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sun, 24 Mar 2013 10:18:22 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (marune.xs4all.nl [80.101.105.217])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id C94AC11E0154
	for <linux-media@vger.kernel.org>; Sun, 24 Mar 2013 10:18:18 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.10] Remove core DV_PRESET support.
Date: Sun, 24 Mar 2013 10:18:19 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303241018.19918.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are no more drivers that use the obsolete DV_PRESET API, so remove it
from the V4L2 core code and the V4L2 documentation.

This is unchanged from the last 5 patches in this original RFC patch series:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/60904

except for the new last patch that updates the version number and documents
the 3.10 changes.

Regards,

	Hans


The following changes since commit 69aa6f4ec669b9121057cc9e32cb10b5f744f6d6:

  [media] drivers: staging: davinci_vpfe: use resource_size() (2013-03-23 11:35:44 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git remove-preset

for you to fetch changes up to 181baa6d806a6d145dea2bfefde369ac75914172:

  DocBook/media/v4l: Update version number and document 3.10 changes. (2013-03-24 10:10:05 +0100)

----------------------------------------------------------------
Hans Verkuil (6):
      v4l2-common: remove obsolete v4l_fill_dv_preset_info
      v4l2-subdev: remove obsolete dv_preset ops.
      v4l2 core: remove the obsolete dv_preset support.
      DocBook/media/v4l: remove the documentation of the obsolete dv_preset API.
      videodev2.h: remove obsolete DV_PRESET API.
      DocBook/media/v4l: Update version number and document 3.10 changes.

 Documentation/DocBook/media/v4l/common.xml                 |   14 ---
 Documentation/DocBook/media/v4l/compat.xml                 |   17 +++-
 Documentation/DocBook/media/v4l/v4l2.xml                   |   15 ++-
 Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml |  240 ----------------------------------------------
 Documentation/DocBook/media/v4l/vidioc-enuminput.xml       |    5 -
 Documentation/DocBook/media/v4l/vidioc-enumoutput.xml      |    5 -
 Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml     |  113 ----------------------
 Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml |   78 ---------------
 drivers/media/v4l2-core/v4l2-common.c                      |   47 ---------
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c              |    4 -
 drivers/media/v4l2-core/v4l2-dev.c                         |    4 -
 drivers/media/v4l2-core/v4l2-ioctl.c                       |   27 +-----
 include/media/v4l2-common.h                                |    1 -
 include/media/v4l2-ioctl.h                                 |    9 --
 include/media/v4l2-subdev.h                                |   16 ----
 include/uapi/linux/videodev2.h                             |   54 -----------
 16 files changed, 29 insertions(+), 620 deletions(-)
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
