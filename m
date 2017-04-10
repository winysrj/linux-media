Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:43216 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752761AbdDJT1W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 15:27:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 14/15] buffer.rst: clarify how V4L2_CTRL_FLAG_MODIFY_LAYOUT/GRABBER are used
Date: Mon, 10 Apr 2017 21:26:50 +0200
Message-Id: <20170410192651.18486-15-hverkuil@xs4all.nl>
In-Reply-To: <20170410192651.18486-1-hverkuil@xs4all.nl>
References: <20170410192651.18486-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Explain when the V4L2_CTRL_FLAG_MODIFY_LAYOUT and
V4L2_CTRL_FLAG_MODIFY_GRABBER flags should be used.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/buffer.rst | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 64613d935edd..ae6ee73f151c 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -48,10 +48,16 @@ The set of information needed to interpret the content of a buffer (e.g. the
 pixel format, the line stride, the tiling orientation or the rotation) is
 collectively referred to in the rest of this section as the buffer layout.
 
+Controls that can modify the buffer layout shall set the
+``V4L2_CTRL_FLAG_MODIFY_LAYOUT`` flag.
+
 Modifying formats or controls that influence the buffer size or layout require
 the stream to be stopped. Any attempt at such a modification while the stream
 is active shall cause the ioctl setting the format or the control to return
-the ``EBUSY`` error code.
+the ``EBUSY`` error code. In that case drivers shall also set the
+``V4L2_CTRL_FLAG_GRABBED`` flag when calling
+:c:func:`VIDIOC_QUERYCTRL` or :c:func:`VIDIOC_QUERY_EXT_CTRL` for such a
+control while the stream is active.
 
 .. note::
 
@@ -67,7 +73,8 @@ the ``EBUSY`` error code.
 Controls that only influence the buffer layout can be modified at any time
 when the stream is stopped. As they don't influence the buffer size, no
 special handling is needed to synchronize those controls with buffer
-allocation.
+allocation and the ``V4L2_CTRL_FLAG_GRABBED`` flag is cleared once the
+stream is stopped.
 
 Formats and controls that influence the buffer size interact with buffer
 allocation. The simplest way to handle this is for drivers to always require
@@ -75,8 +82,10 @@ buffers to be reallocated in order to change those formats or controls. In
 that case, to perform such changes, userspace applications shall first stop
 the video stream with the :c:func:`VIDIOC_STREAMOFF` ioctl if it is running
 and free all buffers with the :c:func:`VIDIOC_REQBUFS` ioctl if they are
-allocated. The format or controls can then be modified, and buffers shall then
-be reallocated and the stream restarted. A typical ioctl sequence is
+allocated. After freeing all buffers the ``V4L2_CTRL_FLAG_GRABBED`` flag
+for controls is cleared. The format or controls can then be modified, and
+buffers shall then be reallocated and the stream restarted. A typical ioctl
+sequence is
 
  #. VIDIOC_STREAMOFF
  #. VIDIOC_REQBUFS(0)
-- 
2.11.0
