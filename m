Return-Path: <SRS0=l98e=O4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4548BC43387
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 17:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06211214C6
	for <linux-media@archiver.kernel.org>; Wed, 19 Dec 2018 17:07:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="ttD/UwdS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729800AbeLSRHN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 19 Dec 2018 12:07:13 -0500
Received: from goldenrod.birch.relay.mailchannels.net ([23.83.209.74]:46121
        "EHLO goldenrod.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728426AbeLSRHM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Dec 2018 12:07:12 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 9EB8F1243E9;
        Wed, 19 Dec 2018 17:07:10 +0000 (UTC)
Received: from pdx1-sub0-mail-a53.g.dreamhost.com (unknown [100.96.35.77])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 3DA0E123B88;
        Wed, 19 Dec 2018 17:07:10 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a53.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Wed, 19 Dec 2018 17:07:10 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Fumbling-Squirrel: 438ceb1b5cef4a3d_1545239230445_2804944119
X-MC-Loop-Signature: 1545239230445:4271208317
X-MC-Ingress-Time: 1545239230444
Received: from pdx1-sub0-mail-a53.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a53.g.dreamhost.com (Postfix) with ESMTP id DA7328042D;
        Wed, 19 Dec 2018 09:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=aLMA8eXFLIUPNCp3pD7ifJCsp+k=; b=ttD/UwdS4D3
        k6pJ/ooPCcJDAAqa1LK/mHJC79JXvFfIZOIEwDqLWnKX+u9AzS4YdxodPMzo/8kW
        H85pp/3i4ERS7rRbxB9MhjzaX0DSai0v5K8TTS8+w5Y6RnF4nL8Zx6IRIUQbmtA/
        Zuw7pM6sKuUm0JAZjx9xLgpUUjr4gfpA=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a53.g.dreamhost.com (Postfix) with ESMTPSA id 6EB108041D;
        Wed, 19 Dec 2018 09:07:08 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a53
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org,
        markus.dobel@gmx.de, alexdeucher@gmail.com, zzam@gentoo.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH v3] cx23885: only reset DMA on problematic CPUs
Date:   Wed, 19 Dec 2018 11:07:01 -0600
Message-Id: <1545239221-9393-1-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545173976-16992-1-git-send-email-brad@nextdimension.cc>
References: <1545173976-16992-1-git-send-email-brad@nextdimension.cc>
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 15
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudejtddgleejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdludehmdenucfjughrpefhvffufffkofgjfhestddtredtredttdenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucffohhmrghinhepohhpvghnsggvnhgthhhmrghrkhhinhhgrdhorhhgnecukfhppeeiiedrledtrddukeelrdduieeinecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtrdhlohgtrghlughomhgrihhnpdhinhgvthepieeirdeltddrudekledrudeiiedprhgvthhurhhnqdhprghthhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqedpmhgrihhlfhhrohhmpegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtpdhnrhgtphhtthhopegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

It is reported that commit 95f408bbc4e4 ("media: cx23885: Ryzen DMA
related RiSC engine stall fixes") caused regresssions with other CPUs.

Ensure that the quirk will be applied only for the CPUs that
are known to cause problems.

A module option is added for explicit control of the behaviour.

Fixes: 95f408bbc4e4 ("media: cx23885: Ryzen DMA related RiSC engine stall fixes")

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Since v2:
- Replaced sizeof with ARRAY_SIZE
- Fixed column 80 checkpatch complaint
Changes since v1:
- Added module option for three way control
- Removed '7' from pci id description, Ryzen 3 is the same id

 drivers/media/pci/cx23885/cx23885-core.c | 55 ++++++++++++++++++++++++++++++--
 drivers/media/pci/cx23885/cx23885.h      |  2 ++
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 39804d8..e2e3649 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -23,6 +23,7 @@
 #include <linux/moduleparam.h>
 #include <linux/kmod.h>
 #include <linux/kernel.h>
+#include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
@@ -41,6 +42,18 @@ MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(CX23885_VERSION);
 
+/*
+ * Some platforms have been found to require periodic resetting of the DMA
+ * engine. Ryzen and XEON platforms are known to be affected. The symptom
+ * encountered is "mpeg risc op code error". Only Ryzen platforms employ
+ * this workaround if the option equals 1. The workaround can be explicitly
+ * disabled for all platforms by setting to 0, the workaround can be forced
+ * on for any platform by setting to 2.
+ */
+static unsigned int dma_reset_workaround = 1;
+module_param(dma_reset_workaround, int, 0644);
+MODULE_PARM_DESC(dma_reset_workaround, "periodic RiSC dma engine reset; 0-force disable, 1-driver detect (default), 2-force enable");
+
 static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
@@ -603,8 +616,13 @@ static void cx23885_risc_disasm(struct cx23885_tsport *port,
 
 static void cx23885_clear_bridge_error(struct cx23885_dev *dev)
 {
-	uint32_t reg1_val = cx_read(TC_REQ); /* read-only */
-	uint32_t reg2_val = cx_read(TC_REQ_SET);
+	uint32_t reg1_val, reg2_val;
+
+	if (!dev->need_dma_reset)
+		return;
+
+	reg1_val = cx_read(TC_REQ); /* read-only */
+	reg2_val = cx_read(TC_REQ_SET);
 
 	if (reg1_val && reg2_val) {
 		cx_write(TC_REQ, reg1_val);
@@ -2058,6 +2076,37 @@ void cx23885_gpio_enable(struct cx23885_dev *dev, u32 mask, int asoutput)
 	/* TODO: 23-19 */
 }
 
+static struct {
+	int vendor, dev;
+} const broken_dev_id[] = {
+	/* According with
+	 * https://openbenchmarking.org/system/1703021-RI-AMDZEN08075/Ryzen%207%201800X/lspci,
+	 * 0x1451 is PCI ID for the IOMMU found on Ryzen
+	 */
+	{ PCI_VENDOR_ID_AMD, 0x1451 },
+};
+
+static bool cx23885_does_need_dma_reset(void)
+{
+	int i;
+	struct pci_dev *pdev = NULL;
+
+	if (dma_reset_workaround == 0)
+		return false;
+	else if (dma_reset_workaround == 2)
+		return true;
+
+	for (i = 0; i < ARRAY_SIZE(broken_dev_id); i++) {
+		pdev = pci_get_device(broken_dev_id[i].vendor,
+					broken_dev_id[i].dev, NULL);
+		if (pdev) {
+			pci_dev_put(pdev);
+			return true;
+		}
+	}
+	return false;
+}
+
 static int cx23885_initdev(struct pci_dev *pci_dev,
 			   const struct pci_device_id *pci_id)
 {
@@ -2069,6 +2118,8 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	if (NULL == dev)
 		return -ENOMEM;
 
+	dev->need_dma_reset = cx23885_does_need_dma_reset();
+
 	err = v4l2_device_register(&pci_dev->dev, &dev->v4l2_dev);
 	if (err < 0)
 		goto fail_free;
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index d54c7ee..cf965ef 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -451,6 +451,8 @@ struct cx23885_dev {
 	/* Analog raw audio */
 	struct cx23885_audio_dev   *audio_dev;
 
+	/* Does the system require periodic DMA resets? */
+	unsigned int		need_dma_reset:1;
 };
 
 static inline struct cx23885_dev *to_cx23885(struct v4l2_device *v4l2_dev)
-- 
2.7.4

