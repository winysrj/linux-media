Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2260 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754859AbdCIPTm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 10:19:42 -0500
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 9C63320067
        for <linux-media@vger.kernel.org>; Thu,  9 Mar 2017 17:19:39 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] docs-rst: media: Document refcount field in struct dvb_frontend
Date: Thu,  9 Mar 2017 17:19:32 +0200
Message-Id: <1489072772-13708-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The refcount field was added to the struct but it was not documented.
Document it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/dvb-core/dvb_frontend.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 482912d..907a05b 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -643,6 +643,8 @@ struct dtv_frontend_properties {
 /**
  * struct dvb_frontend - Frontend structure to be used on drivers.
  *
+ * @refcount:		refcount to keep track of struct dvb_frontend
+ *			references
  * @ops:		embedded struct dvb_frontend_ops
  * @dvb:		pointer to struct dvb_adapter
  * @demodulator_priv:	demod private data
-- 
2.7.4
