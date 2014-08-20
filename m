Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4362 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbaHTW7o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/29] radio-tea5764: fix sparse warnings
Date: Thu, 21 Aug 2014 00:59:04 +0200
Message-Id: <1408575568-20562-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/radio/radio-tea5764.c:168:24: warning: cast to restricted __be16
drivers/media/radio/radio-tea5764.c:168:24: warning: cast to restricted __be16
drivers/media/radio/radio-tea5764.c:168:24: warning: cast to restricted __be16
drivers/media/radio/radio-tea5764.c:168:24: warning: cast to restricted __be16
drivers/media/radio/radio-tea5764.c:185:20: warning: incorrect type in assignment (different base types)
drivers/media/radio/radio-tea5764.c:186:20: warning: incorrect type in assignment (different base types)
drivers/media/radio/radio-tea5764.c:187:20: warning: incorrect type in assignment (different base types)
drivers/media/radio/radio-tea5764.c:188:20: warning: incorrect type in assignment (different base types)
drivers/media/radio/radio-tea5764.c:189:20: warning: incorrect type in assignment (different base types)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-tea5764.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 9250496..cc39901 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -124,11 +124,11 @@ struct tea5764_regs {
 
 struct tea5764_write_regs {
 	u8 intreg;				/* INTMSK */
-	u16 frqset;				/* FRQSETMSB & FRQSETLSB */
-	u16 tnctrl;				/* TNCTRL1 & TNCTRL2 */
-	u16 testreg;				/* TESTBITS & TESTMODE */
-	u16 rdsctrl;				/* RDSCTRL1 & RDSCTRL2 */
-	u16 rdsbbl;				/* PAUSEDET & RDSBBL */
+	__be16 frqset;				/* FRQSETMSB & FRQSETLSB */
+	__be16 tnctrl;				/* TNCTRL1 & TNCTRL2 */
+	__be16 testreg;				/* TESTBITS & TESTMODE */
+	__be16 rdsctrl;				/* RDSCTRL1 & RDSCTRL2 */
+	__be16 rdsbbl;				/* PAUSEDET & RDSBBL */
 } __attribute__ ((packed));
 
 #ifdef CONFIG_RADIO_TEA5764_XTAL
@@ -165,7 +165,7 @@ static int tea5764_i2c_read(struct tea5764_device *radio)
 	if (i2c_transfer(radio->i2c_client->adapter, msgs, 1) != 1)
 		return -EIO;
 	for (i = 0; i < sizeof(struct tea5764_regs) / sizeof(u16); i++)
-		p[i] = __be16_to_cpu(p[i]);
+		p[i] = __be16_to_cpu((__force __be16)p[i]);
 
 	return 0;
 }
-- 
2.1.0.rc1

