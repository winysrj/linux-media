Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33974 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751415AbdJJLpe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 07:45:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v8 2/7] media: open.rst: better document device node naming
Date: Tue, 10 Oct 2017 08:45:18 -0300
Message-Id: <a842bd01f4390bbfd58400cae155a3b492d339c0.1507635716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507635716.git.mchehab@s-opensource.com>
References: <cover.1507635716.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1507635716.git.mchehab@s-opensource.com>
References: <cover.1507635716.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, only kAPI documentation describes the device naming.
However, such description is needed at the uAPI too. Add it,
and describe how to get an unique identify for a given device.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/open.rst | 53 ++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 7 deletions(-)

diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
index afd116edb40d..de2144277f55 100644
--- a/Documentation/media/uapi/v4l/open.rst
+++ b/Documentation/media/uapi/v4l/open.rst
@@ -7,14 +7,16 @@ Opening and Closing Devices
 ***************************
 
 
-Device Naming
-=============
+.. _v4l2_device_naming:
 
-V4L2 drivers are implemented as kernel modules, loaded manually by the
-system administrator or automatically when a device is first discovered.
-The driver modules plug into the "videodev" kernel module. It provides
-helper functions and a common application interface specified in this
-document.
+V4L2 Device Node Naming
+=======================
+
+V4L2 :term:`drivers <driver>` are implemented as kernel modules, loaded
+manually by the system administrator or automatically when a device is
+first discovered. The driver modules plug into the ``videodev`` kernel
+module. It provides helper functions and a common application interface
+specified in this document.
 
 Each driver thus loaded registers one or more device nodes with major
 number 81 and a minor number between 0 and 255. Minor numbers are
@@ -23,6 +25,43 @@ option CONFIG_VIDEO_FIXED_MINOR_RANGES. In that case minor numbers
 are allocated in ranges depending on the device node type (video, radio,
 etc.).
 
+The existing :term:`device node` types defined at V4L2 spec are:
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
+	??? by-id
+	?   ??? usb-OmniVision._USB_Camera-B4.04.27.1-video-index0 -> ../../video0
+	??? by-path
+	    ??? pci-0000:00:14.0-usb-0:2:1.0-video-index0 -> ../../video0
+
+   3. :term:`V4L2 sub-device` nodes (e. g. ``/dev/v4l-sudevX``) provide a
+      different API and aren't considered as
+      :term:`V4L2 device nodes <v4l2 device node>`.
+
+      They are covered at :ref:`subdev`.
+
+
 Many drivers support "video_nr", "radio_nr" or "vbi_nr" module
 options to select specific video/radio/vbi node numbers. This allows the
 user to request that the device node is named e.g. /dev/video5 instead
-- 
2.13.6
