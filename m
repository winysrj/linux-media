Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17259 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964841AbbLOLE3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 06:04:29 -0500
Date: Tue, 15 Dec 2015 14:04:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Tommi Franttila <tommi.franttila@intel.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] v4l2-device: fix a missing error code
Message-ID: <20151215110307.GB9594@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to set "err = -ENOMEM" here.

Fixes: 38b11f19667a ('[media] v4l2-core: create MC interfaces for devnodes')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 85f724b..85b1e98 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -266,8 +266,10 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 			link = media_create_intf_link(&sd->entity,
 						      &vdev->intf_devnode->intf,
 						      MEDIA_LNK_FL_ENABLED);
-			if (!link)
+			if (!link) {
+				err = -ENOMEM;
 				goto clean_up;
+			}
 		}
 #endif
 		sd->devnode = vdev;
