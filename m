Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34479 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcCXLYC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 07:24:02 -0400
Received: by mail-wm0-f50.google.com with SMTP id p65so269660340wmp.1
        for <linux-media@vger.kernel.org>; Thu, 24 Mar 2016 04:24:01 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org
Subject: [PATCH 3/3] [media] c8sectpfe: Rework firmware loading mechanism
Date: Thu, 24 Mar 2016 11:23:52 +0000
Message-Id: <1458818632-25552-4-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1458818632-25552-1-git-send-email-peter.griffin@linaro.org>
References: <1458818632-25552-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

c8sectpfe driver relied on CONFIG_FW_LOADER_USER_HELPER_FALLBACK option
for loading its xp70 firmware. A previous commit removed this Kconfig
option, as it is apparently harmful, but did not update the driver
code which relied on it.

This patch reworks the firmware loading into the start_feed callback.
At this point we can be sure the rootfs is present, thereby removing
the depedency on CONFIG_FW_LOADER_USER_HELPER_FALLBACK.

Fixes: 79f5b6ae960d ('[media] c8sectpfe: Remove select on CONFIG_FW_LOADER_USER_HELPER_FALLBACK')

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  | 65 ++++++++--------------
 1 file changed, 22 insertions(+), 43 deletions(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index acd0767..7dddf77 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -49,7 +49,7 @@ MODULE_FIRMWARE(FIRMWARE_MEMDMA);
 #define PID_TABLE_SIZE 1024
 #define POLL_MSECS 50
 
-static int load_c8sectpfe_fw_step1(struct c8sectpfei *fei);
+static int load_c8sectpfe_fw(struct c8sectpfei *fei);
 
 #define TS_PKT_SIZE 188
 #define HEADER_SIZE (4)
@@ -141,6 +141,7 @@ static int c8sectpfe_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 	struct channel_info *channel;
 	u32 tmp;
 	unsigned long *bitmap;
+	int ret;
 
 	switch (dvbdmxfeed->type) {
 	case DMX_TYPE_TS:
@@ -169,8 +170,9 @@ static int c8sectpfe_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 	}
 
 	if (!atomic_read(&fei->fw_loaded)) {
-		dev_err(fei->dev, "%s: c8sectpfe fw not loaded\n", __func__);
-		return -EINVAL;
+		ret = load_c8sectpfe_fw(fei);
+		if (ret)
+			return ret;
 	}
 
 	mutex_lock(&fei->lock);
@@ -265,8 +267,9 @@ static int c8sectpfe_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 	unsigned long *bitmap;
 
 	if (!atomic_read(&fei->fw_loaded)) {
-		dev_err(fei->dev, "%s: c8sectpfe fw not loaded\n", __func__);
-		return -EINVAL;
+		ret = load_c8sectpfe_fw(fei);
+		if (ret)
+			return ret;
 	}
 
 	mutex_lock(&fei->lock);
@@ -880,13 +883,6 @@ static int c8sectpfe_probe(struct platform_device *pdev)
 		goto err_clk_disable;
 	}
 
-	/* ensure all other init has been done before requesting firmware */
-	ret = load_c8sectpfe_fw_step1(fei);
-	if (ret) {
-		dev_err(dev, "Couldn't load slim core firmware\n");
-		goto err_clk_disable;
-	}
-
 	c8sectpfe_debugfs_init(fei);
 
 	return 0;
@@ -1091,15 +1087,14 @@ static void load_dmem_segment(struct c8sectpfei *fei, Elf32_Phdr *phdr,
 		phdr->p_memsz - phdr->p_filesz);
 }
 
-static int load_slim_core_fw(const struct firmware *fw, void *context)
+static int load_slim_core_fw(const struct firmware *fw, struct c8sectpfei *fei)
 {
-	struct c8sectpfei *fei = context;
 	Elf32_Ehdr *ehdr;
 	Elf32_Phdr *phdr;
 	u8 __iomem *dst;
 	int err = 0, i;
 
-	if (!fw || !context)
+	if (!fw || !fei)
 		return -EINVAL;
 
 	ehdr = (Elf32_Ehdr *)fw->data;
@@ -1151,29 +1146,35 @@ static int load_slim_core_fw(const struct firmware *fw, void *context)
 	return err;
 }
 
-static void load_c8sectpfe_fw_cb(const struct firmware *fw, void *context)
+static int load_c8sectpfe_fw(struct c8sectpfei *fei)
 {
-	struct c8sectpfei *fei = context;
+	const struct firmware *fw;
 	int err;
 
+	dev_info(fei->dev, "Loading firmware: %s\n", FIRMWARE_MEMDMA);
+
+	err = request_firmware(&fw, FIRMWARE_MEMDMA, fei->dev);
+	if (err)
+		return err;
+
 	err = c8sectpfe_elf_sanity_check(fei, fw);
 	if (err) {
 		dev_err(fei->dev, "c8sectpfe_elf_sanity_check failed err=(%d)\n"
 			, err);
-		goto err;
+		return err;
 	}
 
-	err = load_slim_core_fw(fw, context);
+	err = load_slim_core_fw(fw, fei);
 	if (err) {
 		dev_err(fei->dev, "load_slim_core_fw failed err=(%d)\n", err);
-		goto err;
+		return err;
 	}
 
 	/* now the firmware is loaded configure the input blocks */
 	err = configure_channels(fei);
 	if (err) {
 		dev_err(fei->dev, "configure_channels failed err=(%d)\n", err);
-		goto err;
+		return err;
 	}
 
 	/*
@@ -1186,28 +1187,6 @@ static void load_c8sectpfe_fw_cb(const struct firmware *fw, void *context)
 	writel(0x1,  fei->io + DMA_CPU_RUN);
 
 	atomic_set(&fei->fw_loaded, 1);
-err:
-	complete_all(&fei->fw_ack);
-}
-
-static int load_c8sectpfe_fw_step1(struct c8sectpfei *fei)
-{
-	int err;
-
-	dev_info(fei->dev, "Loading firmware: %s\n", FIRMWARE_MEMDMA);
-
-	init_completion(&fei->fw_ack);
-	atomic_set(&fei->fw_loaded, 0);
-
-	err = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
-				FIRMWARE_MEMDMA, fei->dev, GFP_KERNEL, fei,
-				load_c8sectpfe_fw_cb);
-
-	if (err) {
-		dev_err(fei->dev, "request_firmware_nowait err: %d.\n", err);
-		complete_all(&fei->fw_ack);
-		return err;
-	}
 
 	return 0;
 }
-- 
1.9.1

