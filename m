Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24782 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751605AbdHPMWq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 08:22:46 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, hverkuil@xs4all.nl
Subject: [PATCH v2 1/2] docs-rst: media: Document s_stream() video op usage for MC enabled devices
Date: Wed, 16 Aug 2017 15:20:17 +0300
Message-Id: <1502886018-31488-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1502886018-31488-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1502886018-31488-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we begin to add support for systems with Media controller pipelines
controlled by more than one device driver, it is essential that we
precisely define the responsibilities of each component in the stream
control and common practices.

Specifically, streaming control is done per sub-device and sub-device
drivers themselves are responsible for streaming setup in upstream
sub-devices.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 Documentation/media/kapi/v4l2-subdev.rst | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/media/kapi/v4l2-subdev.rst b/Documentation/media/kapi/v4l2-subdev.rst
index e1f0b72..45088ad 100644
--- a/Documentation/media/kapi/v4l2-subdev.rst
+++ b/Documentation/media/kapi/v4l2-subdev.rst
@@ -262,6 +262,35 @@ is called. After all subdevices have been located the .complete() callback is
 called. When a subdevice is removed from the system the .unbind() method is
 called. All three callbacks are optional.
 
+Streaming control on Media controller enabled devices
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+Starting and stopping the stream are somewhat complex operations that
+often require walking the media graph to enable streaming on
+sub-devices which the pipeline consists of. This involves interaction
+between multiple drivers, sometimes more than two.
+
+The ``.s_stream()`` op in :c:type:`v4l2_subdev_video_ops` is responsible
+for starting and stopping the stream on the sub-device it is called
+on. A device driver is only responsible for calling the ``.s_stream()`` ops
+of the adjacent sub-devices that are connected to its sink pads
+through an enabled link. A driver may not call ``.s_stream()`` op
+of any other sub-device further up in the pipeline, for instance.
+
+This means that a sub-device driver is thus in direct control of
+whether the upstream sub-devices start (or stop) streaming before or
+after the sub-device itself is set up for streaming.
+
+.. note::
+
+   As the ``.s_stream()`` callback is called recursively through the
+   sub-devices along the pipeline, it is important to keep the
+   recursion as short as possible. To this end, drivers are encouraged
+   to avoid recursively calling ``.s_stream()`` internally to reduce
+   stack usage. Instead, the ``.s_stream()`` op of the directly
+   connected sub-devices should come from the callback through which
+   the driver was first called.
+
 V4L2 sub-device userspace API
 -----------------------------
 
-- 
2.7.4
