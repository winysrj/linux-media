Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34959 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbbIQKNH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2015 06:13:07 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel@stlinux.com, linux-media@vger.kernel.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] [media] c8sectpfe: fix return of garbage
Date: Thu, 17 Sep 2015 15:42:54 +0530
Message-Id: <1442484774-20449-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The variable err was never initialized, that means we had been checking
a garbage value in the for loop. Moreover if the segment is not outside
the firmware file then also we have been returning the garbage.
Initialize it to 0 so that on success we return the value and no need to
check in the for loop also as it is initially 0 and whenever that value
changes we have done a break from the loop.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 486aef5..8688fe2 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -1097,7 +1097,7 @@ static int load_slim_core_fw(const struct firmware *fw, void *context)
 	Elf32_Ehdr *ehdr;
 	Elf32_Phdr *phdr;
 	u8 __iomem *dst;
-	int err, i;
+	int err = 0, i;
 
 	if (!fw || !context)
 		return -EINVAL;
@@ -1106,7 +1106,7 @@ static int load_slim_core_fw(const struct firmware *fw, void *context)
 	phdr = (Elf32_Phdr *)(fw->data + ehdr->e_phoff);
 
 	/* go through the available ELF segments */
-	for (i = 0; i < ehdr->e_phnum && !err; i++, phdr++) {
+	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
 
 		/* Only consider LOAD segments */
 		if (phdr->p_type != PT_LOAD)
-- 
1.9.1

