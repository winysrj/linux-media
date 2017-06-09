Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:58597 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751527AbdFINXL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 09:23:11 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
Subject: [PATCH v2 0/2] Add explicit digital gain control, document gain controls better
Date: Fri,  9 Jun 2017 16:21:45 +0300
Message-Id: <1497014507-1835-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This set includes two patches: one that adds digital gain control and
another that better documents the relationship between the gain controls.

changes since v1:

- Say that the no-gain digital gain configuration is typically the
  default. This was slightly unclear in the previous version and could
  have been understood as the default being 0x100.

Sakari Ailus (2):
  v4l: ctrls: Add a control for digital gain
  v4l: controls: Improve documentation for V4L2_CID_GAIN

 Documentation/media/uapi/v4l/control.rst           | 6 ++++++
 Documentation/media/uapi/v4l/extended-controls.rst | 7 +++++++
 drivers/media/v4l2-core/v4l2-ctrls.c               | 1 +
 include/uapi/linux/v4l2-controls.h                 | 2 +-
 4 files changed, 15 insertions(+), 1 deletion(-)

-- 
2.7.4
