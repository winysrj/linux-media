Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33367 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbbH1RxF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 13:53:05 -0400
Received: by wiae7 with SMTP id e7so3854495wia.0
        for <linux-media@vger.kernel.org>; Fri, 28 Aug 2015 10:53:04 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	valentinrothberg@gmail.com, hugues.fruchet@st.com
Subject: [PATCH v3 6/6] [media] c8sectpfe: Simplify for loop in load_slim_core_fw
Date: Fri, 28 Aug 2015 18:52:42 +0100
Message-Id: <1440784362-31217-7-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1440784362-31217-1-git-send-email-peter.griffin@linaro.org>
References: <1440784362-31217-1-git-send-email-peter.griffin@linaro.org>
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

