Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23075 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751172AbdHUHsT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 03:48:19 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: tfiga@chromium.org, yong.zhi@intel.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH v2 0/2] v4l2-compliance: Support for metadata output buffers
Date: Mon, 21 Aug 2017 10:48:11 +0300
Message-Id: <20170821074813.20934-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This set adds support for metadata output buffers in v4l2-compliance.

It depends on this kernel patch:

<URL:https://patchwork.linuxtv.org/patch/43308/>

Sakari Ailus (2):
  Add metadata output definitions from metadata output patches
  v4l2-compliance: Add support for metadata output

 include/linux/videodev2.h                   |  2 ++
 utils/v4l2-compliance/v4l2-compliance.cpp   | 11 ++++++++---
 utils/v4l2-compliance/v4l2-test-formats.cpp |  8 +++++++-
 3 files changed, 17 insertions(+), 4 deletions(-)

-- 
2.11.0
