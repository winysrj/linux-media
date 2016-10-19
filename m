Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40284 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943308AbcJSOzm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:55:42 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        p.zabel@pengutronix.de, niklas.soderlund@ragnatech.se
Subject: [PATCH v2 1/1] doc-rst: v4l: Add documentation on CSI-2 bus configuration
Date: Wed, 19 Oct 2016 15:59:54 +0300
Message-Id: <1476881994-32118-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1476870150.3054.28.camel@pengutronix.de>
References: <1476870150.3054.28.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the interface between the CSI-2 transmitter and receiver drivers.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Hi Philipp,

Indeed the pixel rate is used by some driver as well.

How about this one instead?

The HTML page is available here (without CCS unfortunately):

<URL:http://www.retiisi.org.uk/v4l2/tmp/csi2.html>

since v1:
 
- Add PIXEL_RATE to the required controls.

- Document how pixel rate is calculated from the link frequency.

 Documentation/media/kapi/csi2.rst  | 59 ++++++++++++++++++++++++++++++++++++++
 Documentation/media/media_kapi.rst |  1 +
 2 files changed, 60 insertions(+)
 create mode 100644 Documentation/media/kapi/csi2.rst

diff --git a/Documentation/media/kapi/csi2.rst b/Documentation/media/kapi/csi2.rst
new file mode 100644
index 0000000..31f927d
--- /dev/null
+++ b/Documentation/media/kapi/csi2.rst
@@ -0,0 +1,59 @@
+MIPI CSI-2
+==========
+
+CSI-2 is a data bus intended for transferring images from cameras to
+the host SoC. It is defined by the `MIPI alliance`_.
+
+.. _`MIPI alliance`: http://www.mipi.org/
+
+Transmitter drivers
+-------------------
+
+CSI-2 transmitter, such as a sensor or a TV tuner, drivers need to
+provide the CSI-2 receiver with information on the CSI-2 bus
+configuration. These include the V4L2_CID_LINK_FREQ and
+V4L2_CID_PIXEL_RATE controls and
+(:c:type:`v4l2_subdev_video_ops`->s_stream() callback). These
+interface elements must be present on the sub-device represents the
+CSI-2 transmitter.
+
+The V4L2_CID_LINK_FREQ control is used to tell the receiver driver the
+frequency (and not the symbol rate) of the link. The
+V4L2_CID_PIXEL_RATE is may be used by the receiver to obtain the pixel
+rate the transmitter uses. The
+:c:type:`v4l2_subdev_video_ops`->s_stream() callback provides an
+ability to start and stop the stream.
+
+The value of the V4L2_CID_PIXEL_RATE is calculated as follows::
+
+	pixel_rate = link_freq * 2 * nr_of_lanes
+
+where
+
+.. list-table:: variables in pixel rate calculation
+   :header-rows: 1
+
+   * - variable or constant
+     - description
+   * - link_freq
+     - The value of the V4L2_CID_LINK_FREQ integer64 menu item.
+   * - nr_of_lanes
+     - Number of data lanes used on the CSI-2 link. This can
+       be obtained from the OF endpoint configuration.
+   * - 2
+     - Two bits are transferred per clock cycle per lane.
+
+The transmitter drivers must configure the CSI-2 transmitter to *LP-11
+mode* whenever the transmitter is powered on but not active. Some
+transmitters do this automatically but some have to be explicitly
+programmed to do so.
+
+Receiver drivers
+----------------
+
+Before the receiver driver may enable the CSI-2 transmitter by using
+the :c:type:`v4l2_subdev_video_ops`->s_stream(), it must have powered
+the transmitter up by using the
+:c:type:`v4l2_subdev_core_ops`->s_power() callback. This may take
+place either indirectly by using :c:func:`v4l2_pipeline_pm_use` or
+directly.
diff --git a/Documentation/media/media_kapi.rst b/Documentation/media/media_kapi.rst
index f282ca2..bc06389 100644
--- a/Documentation/media/media_kapi.rst
+++ b/Documentation/media/media_kapi.rst
@@ -33,3 +33,4 @@ For more details see the file COPYING in the source distribution of Linux.
     kapi/rc-core
     kapi/mc-core
     kapi/cec-core
+    kapi/csi2
-- 
2.7.4

