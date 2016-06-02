Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35783 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161298AbcFBSDO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2016 14:03:14 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel@stlinux.com, linux-media@vger.kernel.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] [media] c8sectpfe: fix memory leak
Date: Thu,  2 Jun 2016 19:02:55 +0530
Message-Id: <1464874375-12114-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We have assigned memory while requesting the firmware but if the sanity
check fails then we are not releasing the firmware.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 7dddf77..30c148b 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -1161,6 +1161,7 @@ static int load_c8sectpfe_fw(struct c8sectpfei *fei)
 	if (err) {
 		dev_err(fei->dev, "c8sectpfe_elf_sanity_check failed err=(%d)\n"
 			, err);
+		release_firmware(fw);
 		return err;
 	}
 
-- 
1.9.1

