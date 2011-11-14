Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2855 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1KNSVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 13:21:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] board-dm646x-evm.c: wrong register used in setup_vpif_input_channel_mode
Date: Mon, 14 Nov 2011 19:20:49 +0100
Message-Id: <986dc5c6de4525aa3427ccded735d8e982080b0e.1321294701.git.hans.verkuil@cisco.com>
In-Reply-To: <1321294849-2738-1-git-send-email-hverkuil@xs4all.nl>
References: <1321294849-2738-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The function setup_vpif_input_channel_mode() used the VSCLKDIS register
instead of VIDCLKCTL. This meant that when in HD mode videoport channel 0
used a different clock from channel 1.

Clearly a copy-and-paste error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/mach-davinci/board-dm646x-evm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 337c45e..607a527 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -563,7 +563,7 @@ static int setup_vpif_input_channel_mode(int mux_mode)
 	int val;
 	u32 value;
 
-	if (!vpif_vsclkdis_reg || !cpld_client)
+	if (!vpif_vidclkctl_reg || !cpld_client)
 		return -ENXIO;
 
 	val = i2c_smbus_read_byte(cpld_client);
@@ -571,7 +571,7 @@ static int setup_vpif_input_channel_mode(int mux_mode)
 		return val;
 
 	spin_lock_irqsave(&vpif_reg_lock, flags);
-	value = __raw_readl(vpif_vsclkdis_reg);
+	value = __raw_readl(vpif_vidclkctl_reg);
 	if (mux_mode) {
 		val &= VPIF_INPUT_TWO_CHANNEL;
 		value |= VIDCH1CLK;
@@ -579,7 +579,7 @@ static int setup_vpif_input_channel_mode(int mux_mode)
 		val |= VPIF_INPUT_ONE_CHANNEL;
 		value &= ~VIDCH1CLK;
 	}
-	__raw_writel(value, vpif_vsclkdis_reg);
+	__raw_writel(value, vpif_vidclkctl_reg);
 	spin_unlock_irqrestore(&vpif_reg_lock, flags);
 
 	err = i2c_smbus_write_byte(cpld_client, val);
-- 
1.7.7

