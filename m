Return-path: <mchehab@gaivota>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57500 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0L3XIY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 18:08:24 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	spi-devel-general@lists.sourceforge.net,
	devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 06/15]drivers:staging:xgifb:vb_setmode.c Typo change diable to disable.
Date: Thu, 30 Dec 2010 15:07:55 -0800
Message-Id: <1293750484-1161-6-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1293750484-1161-5-git-send-email-justinmattock@gmail.com>
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-3-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-4-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-5-git-send-email-justinmattock@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The below patch fixes a typo "diable" to "disable". Please let me know if this 
is correct or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/xgifb/vb_setmode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 7016fdd..fb49641 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1920,7 +1920,7 @@ void XGI_SetCRT1FIFO(unsigned short ModeNo,
 
 	data = XGINew_GetReg1(pVBInfo->P3c4, 0x3D);
 	data &= 0xfe;
-	XGINew_SetReg1(pVBInfo->P3c4, 0x3D, data); /* diable auto-threshold */
+	XGINew_SetReg1(pVBInfo->P3c4, 0x3D, data); /* disable auto-threshold */
 
 	if (ModeNo > 0x13) {
 		XGINew_SetReg1(pVBInfo->P3c4, 0x08, 0x34);
-- 
1.6.5.2.180.gc5b3e

