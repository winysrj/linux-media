Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.telros.ru ([83.136.244.21]:60707 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab2HVGnS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 02:43:18 -0400
From: Volokh Konstantin <volokh84@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, volokh@telros.ru
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 03/10] staging: media: go7007: Non main code changing
Date: Wed, 22 Aug 2012 14:45:12 +0400
Message-Id: <1345632319-23224-3-git-send-email-volokh84@gmail.com>
In-Reply-To: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
References: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

types cast approved, max channels==4 (ADC), i2c_smbus_write_
  return s32 type

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/wis-tw2804.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-tw2804.c b/drivers/staging/media/go7007/wis-tw2804.c
index 13f0f63..0b49342 100644
--- a/drivers/staging/media/go7007/wis-tw2804.c
+++ b/drivers/staging/media/go7007/wis-tw2804.c
@@ -111,19 +111,22 @@ static u8 channel_registers[] = {
 	0xff, 0xff, /* Terminator (reg 0xff does not exist) */
 };
 
-static int write_reg(struct i2c_client *client, u8 reg, u8 value, int channel)
+static s32 write_reg(struct i2c_client *client, u8 reg, u8 value, u8 channel)
 {
 	return i2c_smbus_write_byte_data(client, reg | (channel << 6), value);
 }
 
-static int write_regs(struct i2c_client *client, u8 *regs, int channel)
+static int write_regs(struct i2c_client *client, u8 *regs, u8 channel)
 {
 	int i;
 
 	for (i = 0; regs[i] != 0xff; i += 2)
 		if (i2c_smbus_write_byte_data(client,
 				regs[i] | (channel << 6), regs[i + 1]) < 0)
-			return -1;
+			return -EINVAL;
+	return 0;
+}
+
 static s32 read_reg(struct i2c_client *client, u8 reg, u8 channel)
 {
 	return i2c_smbus_read_byte_data(client, (reg) | (channel << 6));
-- 
1.7.7.6

