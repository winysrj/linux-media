Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:62134 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750869AbdEaI6J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 04:58:09 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH v6 1/7] media: v4l2-ctrls: Reserve controls for MAX217X
Date: Wed, 31 May 2017 09:44:51 +0100
Message-Id: <20170531084457.4800-2-ramesh.shanmugasundaram@bp.renesas.com>
In-Reply-To: <20170531084457.4800-1-ramesh.shanmugasundaram@bp.renesas.com>
References: <20170531084457.4800-1-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reserve controls for MAX217X RF to Bits tuner family. These hybrid
radio receiver chips are highly programmable and hence reserving 32
controls.

Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/uapi/linux/v4l2-controls.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 0d2e1e01fbd5..83b28b41123f 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -180,6 +180,11 @@ enum v4l2_colorfx {
  * We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_TC358743_BASE		(V4L2_CID_USER_BASE + 0x1080)
 
+/* The base for the max217x driver controls.
+ * We reserve 32 controls for this driver
+ */
+#define V4L2_CID_USER_MAX217X_BASE		(V4L2_CID_USER_BASE + 0x1090)
+
 /* MPEG-class control IDs */
 /* The MPEG controls are applicable to all codec controls
  * and the 'MPEG' part of the define is historical */
-- 
2.12.2
