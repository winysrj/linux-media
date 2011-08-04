Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:54089 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1HDHOb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:31 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 19/21] [staging] tm6000: Enable audio clock in radio mode.
Date: Thu,  4 Aug 2011 09:14:17 +0200
Message-Id: <1312442059-23935-20-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/staging/tm6000/tm6000-stds.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
index f44451b..9a4145d 100644
--- a/drivers/staging/tm6000/tm6000-stds.c
+++ b/drivers/staging/tm6000/tm6000-stds.c
@@ -357,6 +357,7 @@ static int tm6000_set_audio_std(struct tm6000_core *dev)
 		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe);
 		tm6000_set_reg(dev, TM6010_REQ08_R1E_A_GAIN_DEEMPH_OUT, 0x13);
 		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
+		tm6000_set_reg(dev, TM6010_REQ07_RFE_POWER_DOWN, 0xff);
 		return 0;
 	}
 
-- 
1.7.6

