Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:40102 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752876AbdHTLxZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 07:53:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/4] vivid: fix incorrect HDMI input/output CEC logging
Date: Sun, 20 Aug 2017 13:53:18 +0200
Message-Id: <20170820115319.26244-4-hverkuil@xs4all.nl>
In-Reply-To: <20170820115319.26244-1-hverkuil@xs4all.nl>
References: <20170820115319.26244-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Only the first HDMI input has a CEC adapter, so just report 'HDMI 0' as
the HDMI input name.

For the HDMI outputs use bus_cnt instead of i as the output number.
The HDMI name now corresponds to what 'v4l2-ctl --list-outputs' reports.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index ef344b9a48af..5f316a5e38db 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -1201,8 +1201,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 				goto unreg_dev;
 			}
 			cec_s_phys_addr(adap, 0, false);
-			v4l2_info(&dev->v4l2_dev, "CEC adapter %s registered for HDMI input %d\n",
-				  dev_name(&adap->devnode.dev), i);
+			v4l2_info(&dev->v4l2_dev, "CEC adapter %s registered for HDMI input 0\n",
+				  dev_name(&adap->devnode.dev));
 		}
 #endif
 
@@ -1255,13 +1255,13 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 				dev->cec_tx_adap[bus_cnt] = NULL;
 				goto unreg_dev;
 			}
+			v4l2_info(&dev->v4l2_dev, "CEC adapter %s registered for HDMI output %d\n",
+				  dev_name(&adap->devnode.dev), bus_cnt);
 			bus_cnt++;
 			if (bus_cnt <= out_type_counter[HDMI])
 				cec_s_phys_addr(adap, bus_cnt << 12, false);
 			else
 				cec_s_phys_addr(adap, 0x1000, false);
-			v4l2_info(&dev->v4l2_dev, "CEC adapter %s registered for HDMI output %d\n",
-				  dev_name(&adap->devnode.dev), i);
 		}
 #endif
 
-- 
2.14.1
