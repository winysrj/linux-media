Return-path: <linux-media-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:48123 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754211Ab3I3ONF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 10:13:05 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <s.nawrocki@samsung.com>
CC: <m.chehab@samsung.com>, <kernel@pengutronix.de>,
	<shawn.guo@linaro.org>, <linux-media@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] platform: Kconfig: Select SRAM for VIDEO_CODA
Date: Mon, 30 Sep 2013 11:12:22 -0300
Message-ID: <1380550342-27530-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Running the coda driver without CONFIG_SRAM selected leads to the following 
probe error:

coda 63ff4000.vpu: iram pool not available
coda: probe of 63ff4000.vpu failed with error -12

In order to avoid it, select CONFIG_SRAM inside VIDEO_CODA.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index c7caf94..8b2467d 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -143,6 +143,7 @@ if V4L_MEM2MEM_DRIVERS
 config VIDEO_CODA
 	tristate "Chips&Media Coda multi-standard codec IP"
 	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
+	select SRAM
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	---help---
-- 
1.8.1.2


