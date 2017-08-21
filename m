Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:14077 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdHUHz3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 03:55:29 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: tfiga@chromium.org, yong.zhi@intel.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH v3 0/2] v4l2-compliance: Support for metadata output buffers
Date: Mon, 21 Aug 2017 10:55:22 +0300
Message-Id: <20170821075524.21048-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This set adds support for metadata output buffers in v4l2-compliance.

It depends on this kernel patch:

<URL:https://patchwork.linuxtv.org/patch/43308/>

since v2:

- Update V4L2_BUF_TYPE_LAST in v4l2-compliance.h

Sakari Ailus (2):
  Add metadata output definitions from metadata output patches
  v4l2-compliance: Add support for metadata output

 include/linux/videodev2.h                   |  2 ++
 utils/v4l2-compliance/v4l2-compliance.cpp   | 11 ++++++++---
 utils/v4l2-compliance/v4l2-compliance.h     |  2 +-
 utils/v4l2-compliance/v4l2-test-formats.cpp |  8 +++++++-
 4 files changed, 18 insertions(+), 5 deletions(-)

-- 
2.11.0
