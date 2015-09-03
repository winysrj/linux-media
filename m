Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35573 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758115AbbICSKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Sep 2015 14:10:35 -0400
Received: by wicge5 with SMTP id ge5so82535114wic.0
        for <linux-media@vger.kernel.org>; Thu, 03 Sep 2015 11:10:34 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	hugues.fruchet@st.com
Subject: [PATCH v5 6/6] [media] c8sectpfe: Simplify for loop in load_slim_core_fw
Date: Thu,  3 Sep 2015 18:59:54 +0100
Message-Id: <1441303194-28211-7-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1441303194-28211-1-git-send-email-peter.griffin@linaro.org>
References: <1441303194-28211-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index c691e13..ce72ffb 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -1096,7 +1096,7 @@ static int load_slim_core_fw(const struct firmware *fw, void *context)
 	Elf32_Ehdr *ehdr;
 	Elf32_Phdr *phdr;
 	u8 __iomem *dst;
-	int err, i;
+	int err = 0, i;
 
 	if (!fw || !context)
 		return -EINVAL;
@@ -1105,7 +1105,7 @@ static int load_slim_core_fw(const struct firmware *fw, void *context)
 	phdr = (Elf32_Phdr *)(fw->data + ehdr->e_phoff);
 
 	/* go through the available ELF segments */
-	for (i = 0; i < ehdr->e_phnum && !err; i++, phdr++) {
+	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
 
 		/* Only consider LOAD segments */
 		if (phdr->p_type != PT_LOAD)
@@ -1118,7 +1118,7 @@ static int load_slim_core_fw(const struct firmware *fw, void *context)
 			dev_err(fei->dev,
 				"Segment %d is outside of firmware file\n", i);
 			err = -EINVAL;
-			break;
+			goto err;
 		}
 
 		/*
@@ -1146,6 +1146,7 @@ static int load_slim_core_fw(const struct firmware *fw, void *context)
 		}
 	}
 
+err:
 	release_firmware(fw);
 	return err;
 }
-- 
1.9.1

