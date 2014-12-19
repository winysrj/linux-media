Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:56937 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398AbaLSM3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 07:29:48 -0500
Received: from [10.61.169.145] (173-38-208-170.cisco.com [173.38.208.170])
	by tschai.lan (Postfix) with ESMTPSA id A6C5A2A002F
	for <linux-media@vger.kernel.org>; Fri, 19 Dec 2014 13:29:32 +0100 (CET)
Message-ID: <54941A37.8040002@xs4all.nl>
Date: Fri, 19 Dec 2014 13:29:43 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.20] v4l2-subdev cleanups
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches are identical to patches 1, 2, 3 and 5 of this RFC patch series:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg82712.html

Except for updating the obviously wrong subject line of patch 3.

Regards,

	Hans

The following changes since commit 427ae153c65ad7a08288d86baf99000569627d03:

  [media] bq/c-qcam, w9966, pms: move to staging in preparation for removal (2014-12-16 23:21:44 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.20e

for you to fetch changes up to c2db336edbcc29bb5eb991c47be6d1524d7857c8:

  media/i2c/Kconfig: drop superfluous MEDIA_CONTROLLER (2014-12-19 12:44:54 +0100)

----------------------------------------------------------------
Hans Verkuil (4):
      v4l2 subdev: replace get/set_crop by get/set_selection
      v4l2-subdev: drop get/set_crop pad ops
      v4l2-subdev: drop unused op enum_mbus_fsizes
      media/i2c/Kconfig: drop superfluous MEDIA_CONTROLLER

 drivers/media/i2c/Kconfig                       |  6 +++---
 drivers/media/i2c/mt9m032.c                     | 42 ++++++++++++++++++++++----------------
 drivers/media/i2c/mt9p031.c                     | 41 +++++++++++++++++++++----------------
 drivers/media/i2c/mt9t001.c                     | 41 +++++++++++++++++++++----------------
 drivers/media/i2c/mt9v032.c                     | 43 ++++++++++++++++++++++-----------------
 drivers/media/i2c/s5k6aa.c                      | 44 +++++++++++++++++++++++----------------
 drivers/media/v4l2-core/v4l2-subdev.c           |  8 --------
 drivers/staging/media/davinci_vpfe/dm365_isif.c | 69 ++++++++++++++++++++++++++++++++------------------------------
 include/media/v4l2-subdev.h                     |  6 ------
 9 files changed, 159 insertions(+), 141 deletions(-)
