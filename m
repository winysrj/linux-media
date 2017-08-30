Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35968 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751521AbdH3Ltt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 07:49:49 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org
Subject: [PATCH v6 3/5] docs-rst: v4l: Include Qualcomm CAMSS in documentation build
Date: Wed, 30 Aug 2017 14:49:44 +0300
Message-Id: <20170830114946.17743-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20170830114946.17743-1-sakari.ailus@linux.intel.com>
References: <20170830114946.17743-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Qualcomm CAMSS was left out from documentation build. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/media/v4l-drivers/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 10f2ce42ece2..5c202e23616b 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -50,6 +50,7 @@ For more details see the file COPYING in the source distribution of Linux.
 	philips
 	pvrusb2
 	pxa_camera
+	qcom_camss
 	radiotrack
 	rcar-fdp1
 	saa7134
-- 
2.11.0
