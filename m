Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:35083 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751200AbdGOMau (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 08:30:50 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: drop senseless message
Message-ID: <64ff00d3-7a61-36b5-1615-327f03e4c0f9@xs4all.nl>
Date: Sat, 15 Jul 2017 14:30:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Especially the '0.10' version number is confusing since CEC_ADAP_G_CAPS
returns a completely different version number.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index b516d599d6c4..57f171161db7 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -386,11 +386,8 @@ EXPORT_SYMBOL_GPL(cec_delete_adapter);
  */
 static int __init cec_devnode_init(void)
 {
-	int ret;
+	int ret = alloc_chrdev_region(&cec_dev_t, 0, CEC_NUM_DEVICES, CEC_NAME);

-	pr_info("Linux cec interface: v0.10\n");
-	ret = alloc_chrdev_region(&cec_dev_t, 0, CEC_NUM_DEVICES,
-				  CEC_NAME);
 	if (ret < 0) {
 		pr_warn("cec: unable to allocate major\n");
 		return ret;
-- 
2.11.0
