Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37677 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbeKHWUM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2018 17:20:12 -0500
Received: by mail-wr1-f65.google.com with SMTP id o15-v6so17471471wrv.4
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2018 04:44:52 -0800 (PST)
From: Neil Armstrong <narmstrong@baylibre.com>
To: Yasunari.Takiguchi@sony.com
Cc: Neil Armstrong <narmstrong@baylibre.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: cxd2880-spi: fix probe when dvb_attach fails
Date: Thu,  8 Nov 2018 13:44:48 +0100
Message-Id: <1541681088-7385-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When dvb_attach fails, probe returns 0, and remove crashes afterwards.
This patch sets the return value to -ENODEV when attach fails.

Fixes: bd24fcddf6b8 ("media: cxd2880-spi: Add support for CXD2880 SPI interface")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 drivers/media/spi/cxd2880-spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/spi/cxd2880-spi.c b/drivers/media/spi/cxd2880-spi.c
index 11ce510..c437309 100644
--- a/drivers/media/spi/cxd2880-spi.c
+++ b/drivers/media/spi/cxd2880-spi.c
@@ -536,6 +536,7 @@ cxd2880_spi_probe(struct spi_device *spi)
 
 	if (!dvb_attach(cxd2880_attach, &dvb_spi->dvb_fe, &config)) {
 		pr_err("cxd2880_attach failed\n");
+		ret = -ENODEV;
 		goto fail_attach;
 	}
 
-- 
2.7.4
