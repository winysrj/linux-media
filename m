Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50273 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbeJEFQn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 01:16:43 -0400
From: Sean Young <sean@mess.org>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: [PATCH] media: cec: name for RC passthrough device does not need 'RC for'
Date: Thu,  4 Oct 2018 23:21:13 +0100
Message-Id: <20181004222113.13600-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An RC device is does not need to be called 'RC for'. Simply the name
will suffice.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/cec/cec-core.c | 6 ++----
 include/media/cec.h          | 2 --
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 74596f089ec9..e4edc930d4ed 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -307,12 +307,10 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	snprintf(adap->device_name, sizeof(adap->device_name),
-		 "RC for %s", name);
 	snprintf(adap->input_phys, sizeof(adap->input_phys),
-		 "%s/input0", name);
+		 "%s/input0", adap->name);
 
-	adap->rc->device_name = adap->device_name;
+	adap->rc->device_name = adap->name;
 	adap->rc->input_phys = adap->input_phys;
 	adap->rc->input_id.bustype = BUS_CEC;
 	adap->rc->input_id.vendor = 0;
diff --git a/include/media/cec.h b/include/media/cec.h
index 9f382f0c2970..73ed28b076ce 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -198,9 +198,7 @@ struct cec_adapter {
 	u16 phys_addrs[15];
 	u32 sequence;
 
-	char device_name[32];
 	char input_phys[32];
-	char input_drv[32];
 };
 
 static inline void *cec_get_drvdata(const struct cec_adapter *adap)
-- 
2.17.1
