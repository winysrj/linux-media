Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63591 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbbIRWeN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2015 18:34:13 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com
Cc: mchehab@osg.samsung.com, linux-arm-kernel@lists.infradead.org,
	kernel@stlinux.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] [media] c8sectpfe: Fix uninitialized variable in load_slim_core_fw()
Date: Sat, 19 Sep 2015 00:33:07 +0200
Message-Id: <1442615587-22260-1-git-send-email-cengelma@gmx.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Variable err in function load_slim_core_fw() is used without initializer.
Make sure that the result is deterministic. Detected by Coverity CID
1324265.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested only. Applies against linux-next.
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 486aef50d99b..cd146464a80c 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -1106,7 +1106,7 @@ static int load_slim_core_fw(const struct firmware *fw, void *context)
 	phdr = (Elf32_Phdr *)(fw->data + ehdr->e_phoff);
 
 	/* go through the available ELF segments */
-	for (i = 0; i < ehdr->e_phnum && !err; i++, phdr++) {
+	for (i = 0, err = 0; i < ehdr->e_phnum && !err; i++, phdr++) {
 
 		/* Only consider LOAD segments */
 		if (phdr->p_type != PT_LOAD)
-- 
1.9.1

