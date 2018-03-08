Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:42454 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935069AbeCHJst (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2018 04:48:49 -0500
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        devicetree@vger.kernel.org, heiko@sntech.de,
        Jacob Chen <jacob2.chen@rock-chips.com>,
        Jacob Chen <jacob-chen@rock-chips.com>
Subject: [PATCH v6 02/17] media: doc: add document for rkisp1 meta buffer format
Date: Thu,  8 Mar 2018 17:47:52 +0800
Message-Id: <20180308094807.9443-3-jacob-chen@iotwrt.com>
In-Reply-To: <20180308094807.9443-1-jacob-chen@iotwrt.com>
References: <20180308094807.9443-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacob Chen <jacob2.chen@rock-chips.com>

This commit add docuemnt for rkisp1 meta buffer format

Signed-off-by: Jacob Chen <jacob-chen@rock-chips.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/meta-formats.rst        |  2 ++
 .../media/uapi/v4l/pixfmt-meta-rkisp1-params.rst     | 20 ++++++++++++++++++++
 .../media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst       | 18 ++++++++++++++++++
 3 files changed, 40 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-params.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst

diff --git a/Documentation/media/uapi/v4l/meta-formats.rst b/Documentation/media/uapi/v4l/meta-formats.rst
index 0c4e1ecf5879..44e7edbf1dae 100644
--- a/Documentation/media/uapi/v4l/meta-formats.rst
+++ b/Documentation/media/uapi/v4l/meta-formats.rst
@@ -15,3 +15,5 @@ These formats are used for the :ref:`metadata` interface only.
     pixfmt-meta-uvc
     pixfmt-meta-vsp1-hgo
     pixfmt-meta-vsp1-hgt
+    pixfmt-meta-rkisp1-params
+    pixfmt-meta-rkisp1-stat
diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-params.rst b/Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-params.rst
new file mode 100644
index 000000000000..2ff4f4309795
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-params.rst
@@ -0,0 +1,20 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _v4l2-meta-fmt-rkisp1-params:
+
+*******************************
+V4L2_META_FMT_RK_ISP1_PARAMS
+*******************************
+
+Rockchip ISP1 Parameters Data
+
+Description
+===========
+
+This format describes input parameters for the Rockchip ISP1.
+
+It uses c-struct :c:type:`rkisp1_isp_params_cfg`, which is defined in
+the ``linux/rkisp1-config.h`` header file, see it for details.
+
+The parameters consist of multiple modules.
+The module won't be updated if the correspond bit was not set in module_*_update.
diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst b/Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst
new file mode 100644
index 000000000000..dca8befe58f1
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst
@@ -0,0 +1,18 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _v4l2-meta-fmt-rkisp1-stat:
+
+*******************************
+V4L2_META_FMT_RK_ISP1_STAT_3A
+*******************************
+
+Rockchip ISP1 Statistics Data
+
+Description
+===========
+
+This format describes image color statistics information generated by the Rockchip
+ISP1.
+
+It use c-struct :c:type:`rkisp1_stat_buffer`, which is defined in
+the ``linux/cifisp_stat.h`` header file, see it for details.
-- 
2.16.1
