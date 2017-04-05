Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41551
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932658AbdDESjN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 14:39:13 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [PATCH 1/2] [media] dvb_frontend: add kernel-doc tag for a missing parameter
Date: Wed,  5 Apr 2017 15:38:52 -0300
Message-Id: <f8da4aad552ec9423ca723404472cc3db0c125d7.1491417529.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset 1f862a68df24 ("[media] dvb_frontend: move kref to struct
dvb_frontend") added a kref to the struct dvb_frontend, but it
didn't document it.

Fixes: 1f862a68df24 ("[media] dvb_frontend: move kref to struct dvb_frontend")

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 482912d3b77a..fd916c693947 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -643,6 +643,7 @@ struct dtv_frontend_properties {
 /**
  * struct dvb_frontend - Frontend structure to be used on drivers.
  *
+ * @refcount:		pointer to struct kref
  * @ops:		embedded struct dvb_frontend_ops
  * @dvb:		pointer to struct dvb_adapter
  * @demodulator_priv:	demod private data
-- 
2.9.3
