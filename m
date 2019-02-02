Return-Path: <SRS0=sYKt=QJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BFAC282D7
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 12:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 667712086C
	for <linux-media@archiver.kernel.org>; Sat,  2 Feb 2019 12:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfBBMKY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Feb 2019 07:10:24 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40179 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727876AbfBBMKY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Feb 2019 07:10:24 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.lab.pengutronix.de)
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gpu7i-0008DC-5X; Sat, 02 Feb 2019 13:10:14 +0100
Received: from mfe by dude02.lab.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1gpu7e-0002Oq-4Z; Sat, 02 Feb 2019 13:10:10 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     robh+dt@kernel.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com
Cc:     airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 2/5] media: v4l2-fwnode: add v4l2_fwnode_connector
Date:   Sat,  2 Feb 2019 13:10:01 +0100
Message-Id: <20190202121004.9014-3-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190202121004.9014-1-m.felsch@pengutronix.de>
References: <20190202121004.9014-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Currently every driver needs to parse the connector endpoints by it self.
This is the initial work to make this generic. The generic connector has
some common fields and some connector specific parts. The generic one
includes:
  - type
  - label
  - remote_port (the port where the connector is connected to)
  - remote_id   (the endpoint where the connector is connected to)

The specific fields are within a union, since only one of them can be
available at the time. Since this is the initial support the patch adds
only the analog-connector specific ones.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 include/media/v4l2-connector.h | 34 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-fwnode.h    | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)
 create mode 100644 include/media/v4l2-connector.h

diff --git a/include/media/v4l2-connector.h b/include/media/v4l2-connector.h
new file mode 100644
index 000000000000..967336e38215
--- /dev/null
+++ b/include/media/v4l2-connector.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * v4l2-connector.h
+ *
+ * V4L2 connector types.
+ *
+ * Copyright 2019 Pengutronix, Marco Felsch <kernel@pengutronix.de>
+ */
+
+#ifndef V4L2_CONNECTOR_H
+#define V4L2_CONNECTOR_H
+
+#define V4L2_CONNECTOR_MAX_LABEL 41
+
+/**
+ * enum v4l2_connector_type - connector type
+ * @V4L2_CON_UNKNOWN:   unknown connector type, no V4L2 connetor configuration
+ * @V4L2_CON_COMPOSITE: analog composite connector
+ * @V4L2_CON_SVIDEO:    analog svideo connector
+ * @V4L2_CON_VGA:       analog vga connector
+ * @V4L2_CON_DVI:	analog or digital dvi connector
+ * @V4L2_CON_HDMI:      digital hdmi connetor
+ */
+enum v4l2_connector_type {
+	V4L2_CON_UNKNOWN,
+	V4L2_CON_COMPOSITE,
+	V4L2_CON_SVIDEO,
+	V4L2_CON_VGA,
+	V4L2_CON_DVI,
+	V4L2_CON_HDMI,
+};
+
+#endif /* V4L2_CONNECTOR_H */
+
diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
index 6d9d9f1839ac..cf87e819800f 100644
--- a/include/media/v4l2-fwnode.h
+++ b/include/media/v4l2-fwnode.h
@@ -22,6 +22,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 
+#include <media/v4l2-connector.h>
 #include <media/v4l2-mediabus.h>
 #include <media/v4l2-subdev.h>
 
@@ -126,6 +127,38 @@ struct v4l2_fwnode_link {
 	unsigned int remote_port;
 };
 
+/**
+ * struct v4l2_fwnode_connector_analog - analog connector data structure
+ * @supported_tvnorms: tv norms this connector supports, set to V4L2_STD_ALL
+ *                     if no restrictions are specified.
+ */
+struct v4l2_fwnode_connector_analog {
+	v4l2_std_id supported_tvnorms;
+};
+
+/** struct v4l2_fwnode_connector - the connector data structure
+ * @remote_port: identifier of the port the remote endpoint belongs to
+ * @remote_id: identifier of the id the remote endpoint belongs to
+ * @label: connetor label
+ * @type: connector type
+ * @connector: union with connector configuration data struct
+ * @connector.analog: embedded &struct v4l2_fwnode_connector_analog.
+ *                    Used if connector is of type analog.
+ */
+struct v4l2_fwnode_connector {
+	/* common fields for all v4l2_fwnode_connectors */
+	unsigned int remote_port;
+	unsigned int remote_id;
+	char label[V4L2_CONNECTOR_MAX_LABEL];
+	enum v4l2_connector_type type;
+
+	/* connector specific fields */
+	union {
+		struct v4l2_fwnode_connector_analog analog;
+		/* future connectors */
+	} connector;
+};
+
 /**
  * v4l2_fwnode_endpoint_parse() - parse all fwnode node properties
  * @fwnode: pointer to the endpoint's fwnode handle
-- 
2.20.1

