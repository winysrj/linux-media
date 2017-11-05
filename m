Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44688 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751241AbdKEOZ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 09:25:27 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 10/15] cx23885: Use semicolon after assignment instead of comma
Date: Sun,  5 Nov 2017 15:25:06 +0100
Message-Id: <20171105142511.16563-10-zzam@gentoo.org>
In-Reply-To: <20171105142511.16563-1-zzam@gentoo.org>
References: <20171105142511.16563-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

End assignments by semicolon instead of comma.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index b33ded461308..67ad04138183 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1852,8 +1852,8 @@ static int dvb_register(struct cx23885_tsport *port)
 			/* attach frontend */
 			memset(&si2165_pdata, 0, sizeof(si2165_pdata));
 			si2165_pdata.fe = &fe0->dvb.frontend;
-			si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL,
-			si2165_pdata.ref_freq_hz = 16000000,
+			si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL;
+			si2165_pdata.ref_freq_hz = 16000000;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2165", I2C_NAME_SIZE);
 			info.addr = 0x64;
-- 
2.15.0
