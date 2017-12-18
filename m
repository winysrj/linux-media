Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47139 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759308AbdLRMai (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 07:30:38 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH v4 18/18] w1_netlink.h: add support for nested structs
Date: Mon, 18 Dec 2017 10:30:19 -0200
Message-Id: <b591384d6329894c87b0136beea70520050020b6.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that kernel-doc can hanle nested structs/unions, describe
such fields at w1_netlink_message_types.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/w1/w1_netlink.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/w1/w1_netlink.h b/drivers/w1/w1_netlink.h
index a36661cd1f05..f876772c0fb4 100644
--- a/drivers/w1/w1_netlink.h
+++ b/drivers/w1/w1_netlink.h
@@ -59,7 +59,11 @@ enum w1_netlink_message_types {
  * @type: one of enum w1_netlink_message_types
  * @status: kernel feedback for success 0 or errno failure value
  * @len: length of data following w1_netlink_msg
- * @id: union holding master bus id (msg.id) and slave device id (id[8]).
+ * @id: union holding bus master id (msg.id) and slave device id (id[8]).
+ * @id.id: Slave ID (8 bytes)
+ * @id.mst: bus master identification
+ * @id.mst.id: bus master ID
+ * @id.mst.res: bus master reserved
  * @data: start address of any following data
  *
  * The base message structure for w1 messages over netlink.
-- 
2.14.3
