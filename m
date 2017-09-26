Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55761
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S969509AbdIZR73 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 13:59:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 10/10] [RFC] w1_netlink.h: add support for nested structs
Date: Tue, 26 Sep 2017 14:59:20 -0300
Message-Id: <6e7255bf2c5c1908716cfdf2b894a6f4682fe964.1506448061.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506448061.git.mchehab@s-opensource.com>
References: <cover.1506448061.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506448061.git.mchehab@s-opensource.com>
References: <cover.1506448061.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Describe nested struct/union fields

NOTE: This is a pure test patch, meant to validate if the
parsing logic for nested structs is working properly.

I've no idea if the random text I added there is correct!

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/w1/w1_netlink.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/w1/w1_netlink.h b/drivers/w1/w1_netlink.h
index a36661cd1f05..e781d1109cd7 100644
--- a/drivers/w1/w1_netlink.h
+++ b/drivers/w1/w1_netlink.h
@@ -60,6 +60,10 @@ enum w1_netlink_message_types {
  * @status: kernel feedback for success 0 or errno failure value
  * @len: length of data following w1_netlink_msg
  * @id: union holding master bus id (msg.id) and slave device id (id[8]).
+ * @id.id: Slave ID (8 bytes)
+ * @id.mst: master bus identification
+ * @id.mst.id: master bus ID
+ * @id.mst.res: master bus reserved
  * @data: start address of any following data
  *
  * The base message structure for w1 messages over netlink.
-- 
2.13.5
