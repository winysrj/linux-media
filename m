Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:60831 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932500AbcGDNfG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 09:35:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH 4/7] ezkit/cobalt: drop unused op_656_range setting
Date: Mon,  4 Jul 2016 15:34:49 +0200
Message-Id: <1467639292-1066-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
References: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The adv7604/adv7842 drivers now handle that register setting themselves
and need no input from platform data anymore.

This was a left-over from the time that the pixelport output format was
decided by the platform data.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
---
 arch/blackfin/mach-bf609/boards/ezkit.c  | 2 --
 drivers/media/pci/cobalt/cobalt-driver.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/arch/blackfin/mach-bf609/boards/ezkit.c b/arch/blackfin/mach-bf609/boards/ezkit.c
index aad5d74..9231e5a 100644
--- a/arch/blackfin/mach-bf609/boards/ezkit.c
+++ b/arch/blackfin/mach-bf609/boards/ezkit.c
@@ -1002,14 +1002,12 @@ static struct adv7842_output_format adv7842_opf[] = {
 	{
 		.op_ch_sel = ADV7842_OP_CH_SEL_BRG,
 		.op_format_sel = ADV7842_OP_FORMAT_SEL_SDR_ITU656_8,
-		.op_656_range = 1,
 		.blank_data = 1,
 		.insert_av_codes = 1,
 	},
 	{
 		.op_ch_sel = ADV7842_OP_CH_SEL_RGB,
 		.op_format_sel = ADV7842_OP_FORMAT_SEL_SDR_ITU656_16,
-		.op_656_range = 1,
 		.blank_data = 1,
 	},
 };
diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 8d6f04f..99ccc50 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -492,7 +492,6 @@ static int cobalt_subdevs_init(struct cobalt *cobalt)
 		.ain_sel = ADV7604_AIN7_8_9_NC_SYNC_3_1,
 		.bus_order = ADV7604_BUS_ORDER_BRG,
 		.blank_data = 1,
-		.op_656_range = 1,
 		.op_format_mode_sel = ADV7604_OP_FORMAT_MODE0,
 		.int1_config = ADV76XX_INT1_CONFIG_ACTIVE_HIGH,
 		.dr_str_data = ADV76XX_DR_STR_HIGH,
@@ -571,7 +570,6 @@ static int cobalt_subdevs_hsma_init(struct cobalt *cobalt)
 		.bus_order = ADV7842_BUS_ORDER_RBG,
 		.op_format_mode_sel = ADV7842_OP_FORMAT_MODE0,
 		.blank_data = 1,
-		.op_656_range = 1,
 		.dr_str_data = 3,
 		.dr_str_clk = 3,
 		.dr_str_sync = 3,
-- 
2.8.1

