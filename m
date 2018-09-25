Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60080 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728721AbeIYSOc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 14:14:32 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 2/3] media: open.rst: better document device node naming
Date: Tue, 25 Sep 2018 09:06:52 -0300
Message-Id: <0938dc20b6496789bf7c36f0f0162c5b62a2663c.1537876293.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1537876293.git.mchehab+samsung@kernel.org>
References: <cover.1537876293.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
In-Reply-To: <cover.1537876293.git.mchehab+samsung@kernel.org>
References: <cover.1537876293.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Right now, only kAPI documentation describes the device naming.
However, such description is needed at the uAPI too. Add it,
and describe how to get an unique identify for a given device.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/media/uapi/v4l/open.rst | 44 +++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index afd116edb40d..7e7aad784388 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -7,12 +7,14 @@ Opening and Closing Devices
 ***************************
 
 
-Device Naming
-=============
+.. _v4l2_device_naming:
+
+V4L2 Device Node Naming
+=======================
 
 V4L2 drivers are implemented as kernel modules, loaded manually by the
 system administrator or automatically when a device is first discovered.
-The driver modules plug into the "videodev" kernel module. It provides
+The driver modules plug into the ``videodev`` kernel module. It provides
 helper functions and a common application interface specified in this
 document.
 
@@ -23,6 +25,42 @@ option CONFIG_VIDEO_FIXED_MINOR_RANGES. In that case minor numbers
 are allocated in ranges depending on the device node type (video, radio,
 etc.).
 
+The existing V4L2 device node types are:
+
+======================== ======================================================
+Default device node name Usage
+======================== ======================================================
+``/dev/videoX``		 Video input/output devices
+``/dev/vbiX``		 Vertical blank data (i.e. closed captions, teletext)
+``/dev/radioX``		 Radio tuners and modulators
+``/dev/swradioX``	 Software Defined Radio tuners and modulators
+``/dev/v4l-touchX``	 Touch sensors
+======================== ======================================================
+
+Where ``X`` is a non-negative number.
+
+.. note::
+
+   1. The actual device node name is system-dependent, as udev rules may apply.
+   2. There is no guarantee that ``X`` will remain the same for the same
+      device, as the number depends on the device driver's probe order.
+      If you need an unique name, udev default rules produce
+      ``/dev/v4l/by-id/`` and ``/dev/v4l/by-path/`` directories containing
+      links that can be used uniquely to identify a V4L2 device node::
+
+	$ tree /dev/v4l
+	/dev/v4l
+	├── by-id
+	│   └── usb-OmniVision._USB_Camera-B4.04.27.1-video-index0 -> ../../video0
+	└── by-path
+	    └── pci-0000:00:14.0-usb-0:2:1.0-video-index0 -> ../../video0
+
+   3. **V4L2 sub-device nodes** (e. g. ``/dev/v4l-sudevX``) provide a
+      different API and aren't considered as V4L2 device nodes.
+
+      They are covered at :ref:`subdev`.
+
+
 Many drivers support "video_nr", "radio_nr" or "vbi_nr" module
 options to select specific video/radio/vbi node numbers. This allows the
 user to request that the device node is named e.g. /dev/video5 instead
-- 
2.17.1
