Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60386 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752439AbdFPPP5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 11:15:57 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: tfiga@chromium.org, yong.zhi@intel.com
Subject: [RFC 0/2] Add V4L2_BUF_TYPE_META_OUTPUT buffer type
Date: Fri, 16 Jun 2017 18:14:19 +0300
Message-Id: <1497626061-2129-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_BUF_TYPE_META_OUTPUT buffer type complements the metadata buffer
types support for OUTPUT buffers, capture being already supported. This is
intended for similar cases than V4L2_BUF_TYPE_META_CAPTURE but for output
buffers, e.g. device parameters that may be complex and highly
hierarchical data structure. Statistics are a current use case for
metadata capture buffers.

There's a warning related to references from make htmldocs; I'll fix that
in v2 / non-RFC version.

Sakari Ailus (2):
  v4l: Add support for V4L2_BUF_TYPE_META_OUTPUT
  docs-rst: v4l: Document V4L2_BUF_TYPE_META_OUTPUT interface

 Documentation/media/uapi/v4l/buffer.rst          |  3 +++
 Documentation/media/uapi/v4l/dev-meta.rst        | 32 ++++++++++++++----------
 Documentation/media/uapi/v4l/vidioc-querycap.rst |  3 +++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c    |  2 ++
 drivers/media/v4l2-core/v4l2-ioctl.c             | 25 ++++++++++++++++++
 drivers/media/v4l2-core/videobuf2-v4l2.c         |  1 +
 include/media/v4l2-ioctl.h                       | 17 +++++++++++++
 include/uapi/linux/videodev2.h                   |  2 ++
 8 files changed, 72 insertions(+), 13 deletions(-)

-- 
2.7.4
