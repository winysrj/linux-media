Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62443 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759102Ab3D3JRA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Apr 2013 05:17:00 -0400
Received: by mail-pa0-f42.google.com with SMTP id kl13so248286pab.15
        for <linux-media@vger.kernel.org>; Tue, 30 Apr 2013 02:16:59 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org, Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 1/1] [media] s5c73m3: Fix whitespace related warnings
Date: Tue, 30 Apr 2013 14:34:09 +0530
Message-Id: <1367312649-28950-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silences the following type of warning:
WARNING: space prohibited before semicolon

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
index 6f3a9c0..8079e26 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
@@ -73,7 +73,7 @@ int s5c73m3_spi_write(struct s5c73m3 *state, const void *addr,
 
 	memset(padding, 0, sizeof(padding));
 
-	for (i = 0; i < count ; i++) {
+	for (i = 0; i < count; i++) {
 		r = spi_xmit(spi_dev, (void *)addr + j, tx_size, SPI_DIR_TX);
 		if (r < 0)
 			return r;
@@ -98,7 +98,7 @@ int s5c73m3_spi_read(struct s5c73m3 *state, void *addr,
 	unsigned int i, j = 0;
 	int r = 0;
 
-	for (i = 0; i < count ; i++) {
+	for (i = 0; i < count; i++) {
 		r = spi_xmit(spi_dev, addr + j, tx_size, SPI_DIR_RX);
 		if (r < 0)
 			return r;
-- 
1.7.9.5

