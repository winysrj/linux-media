Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34138 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753797AbeCWL5X (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 04/30] media: vpss: fix annotations for vpss_regs_base2
Date: Fri, 23 Mar 2018 07:56:50 -0400
Message-Id: <8395597fa4ecb0cab9241a399d78d5d3a95d928f.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix those warnings:

	drivers/media/platform/davinci/vpss.c:510:25: warning: incorrect type in argument 1 (different address spaces)
	drivers/media/platform/davinci/vpss.c:510:25:    expected void volatile [noderef] <asn:2>*addr
	drivers/media/platform/davinci/vpss.c:510:25:    got unsigned int [usertype] *static [toplevel] [assigned] vpss_regs_base2
	drivers/media/platform/davinci/vpss.c:520:34: warning: incorrect type in assignment (different address spaces)
	drivers/media/platform/davinci/vpss.c:520:34:    expected unsigned int [usertype] *static [toplevel] [assigned] vpss_regs_base2
	drivers/media/platform/davinci/vpss.c:520:34:    got void [noderef] <asn:2>*
	drivers/media/platform/davinci/vpss.c:522:54: warning: incorrect type in argument 2 (different address spaces)
	drivers/media/platform/davinci/vpss.c:522:54:    expected void volatile [noderef] <asn:2>*addr
	drivers/media/platform/davinci/vpss.c:522:54:    got unsigned int [usertype] *static [toplevel] [assigned] vpss_regs_base2

Weird enough, vpss_regs_base0 and vpss_regs_base1 were
properly annotated.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/vpss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index b73886519f4f..19cf6853411e 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -116,7 +116,7 @@ struct vpss_hw_ops {
 struct vpss_oper_config {
 	__iomem void *vpss_regs_base0;
 	__iomem void *vpss_regs_base1;
-	resource_size_t *vpss_regs_base2;
+	__iomem void *vpss_regs_base2;
 	enum vpss_platform_type platform;
 	spinlock_t vpss_lock;
 	struct vpss_hw_ops hw_ops;
-- 
2.14.3
