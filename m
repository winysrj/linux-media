Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:60075 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbeBHMof (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 07:44:35 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: yong.zhi@intel.com, Yang@nauris.fi.intel.com,
        Hyungwoo <hyungwoo.yang@intel.com>, Rapolu@nauris.fi.intel.com,
        Chiranjeevi <chiranjeevi.rapolu@intel.com>, andy.yeh@intel.com
Subject: [PATCH 0/5] Move finding the best match for size to V4L2 common
Date: Thu,  8 Feb 2018 14:44:23 +0200
Message-Id: <1518093868-3444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This set should make it a bit easier to support finding the right size in
sensor drivers. Two sensor drivers and vivid are converted as an example.

I've tested the vivid change only but the patches are effectively the same
and trivial.

Sakari Ailus (5):
  v4l: common: Add a function to obtain best size from a list
  vivid: Use v4l2_find_nearest_size
  v4l: common: Remove v4l2_find_nearest_format
  ov13858: Use v4l2_find_nearest_size
  ov5670: Use v4l2_find_nearest_size

 drivers/media/i2c/ov13858.c                  | 37 +++-------------------------
 drivers/media/i2c/ov5670.c                   | 34 +++----------------------
 drivers/media/platform/vivid/vivid-vid-cap.c |  6 ++---
 drivers/media/v4l2-core/v4l2-common.c        | 34 ++++++++++++++-----------
 include/media/v4l2-common.h                  | 34 ++++++++++++++++++-------
 5 files changed, 53 insertions(+), 92 deletions(-)

-- 
2.7.4
