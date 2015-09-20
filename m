Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.polytechnique.org ([129.104.30.34]:52589 "EHLO
	mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbbITOWq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2015 10:22:46 -0400
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	kernel@stlinux.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/2] [media] c8sectpfe: initialize err in load_slim_core_fw
Date: Sun, 20 Sep 2015 16:14:06 +0200
Message-Id: <1442758447-1474-1-git-send-email-nicolas.iooss_linux@m4x.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

load_slim_core_fw() uses a for loop with !err in its condition without
first initializing err.  Fix this by setting err to 0 in its definition.

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 486aef50d99b..a424339b18bc 100644
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
-- 
2.5.2

