Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:55805
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757632AbaGWJ5Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 05:57:16 -0400
From: Sonic Zhang <sonic.adi@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
CC: <linux-media@vger.kernel.org>,
	<adi-buildroot-devel@lists.sourceforge.net>,
	Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 3/3] v4l2: blackfin: select proper pinctrl state in ppi_set_params if CONFIG_PINCTRL is enabled
Date: Wed, 23 Jul 2014 17:57:16 +0800
Message-ID: <1406109436-23922-3-git-send-email-sonic.adi@gmail.com>
In-Reply-To: <1406109436-23922-1-git-send-email-sonic.adi@gmail.com>
References: <1406109436-23922-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sonic Zhang <sonic.zhang@analog.com>

Multiple pinctrl states are defined for 8, 16 and 24 data pin groups in PPI peripheral.
The driver should select correct group before set up further PPI parameters.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/media/platform/blackfin/ppi.c | 17 +++++++++++++++++
 include/media/blackfin/ppi.h          |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/media/platform/blackfin/ppi.c b/drivers/media/platform/blackfin/ppi.c
index 90c4a93..cff63e5 100644
--- a/drivers/media/platform/blackfin/ppi.c
+++ b/drivers/media/platform/blackfin/ppi.c
@@ -206,6 +206,20 @@ static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params)
 	int dma_config, bytes_per_line;
 	int hcount, hdelay, samples_per_line;
 
+#ifdef CONFIG_PINCTRL
+	static const char * const pin_state[] = {"8bit", "16bit", "24bit"};
+	struct pinctrl *pctrl;
+	struct pinctrl_state *pstate;
+
+	if (params->dlen > 24 || params->dlen <= 0)
+		return -EINVAL;
+	pctrl = devm_pinctrl_get(ppi->dev);
+	pstate = pinctrl_lookup_state(pctrl,
+				      pin_state[(params->dlen + 7) / 8 - 1]);
+	if (pinctrl_select_state(pctrl, pstate))
+		return -EINVAL;
+#endif
+
 	bytes_per_line = params->width * params->bpp / 8;
 	/* convert parameters unit from pixels to samples */
 	hcount = params->width * params->bpp / params->dlen;
@@ -316,10 +330,12 @@ struct ppi_if *ppi_create_instance(struct platform_device *pdev,
 	if (!info || !info->pin_req)
 		return NULL;
 
+#ifndef CONFIG_PINCTRL
 	if (peripheral_request_list(info->pin_req, KBUILD_MODNAME)) {
 		dev_err(&pdev->dev, "request peripheral failed\n");
 		return NULL;
 	}
+#endif
 
 	ppi = kzalloc(sizeof(*ppi), GFP_KERNEL);
 	if (!ppi) {
@@ -329,6 +345,7 @@ struct ppi_if *ppi_create_instance(struct platform_device *pdev,
 	}
 	ppi->ops = &ppi_ops;
 	ppi->info = info;
+	ppi->dev = &pdev->dev;
 
 	pr_info("ppi probe success\n");
 	return ppi;
diff --git a/include/media/blackfin/ppi.h b/include/media/blackfin/ppi.h
index 61a283f..4900bae 100644
--- a/include/media/blackfin/ppi.h
+++ b/include/media/blackfin/ppi.h
@@ -83,6 +83,7 @@ struct ppi_info {
 };
 
 struct ppi_if {
+	struct device *dev;
 	unsigned long ppi_control;
 	const struct ppi_ops *ops;
 	const struct ppi_info *info;
-- 
1.8.2.3

