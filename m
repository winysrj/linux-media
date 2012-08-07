Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52727 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480Ab2HGCrx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:47:53 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432709vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:47:52 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 07/24] xc5000: properly report i2c write failures
Date: Mon,  6 Aug 2012 22:46:57 -0400
Message-Id: <1344307634-11673-8-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic as written would *never* actually return an error condition, since
the loop would run until the counter hit zero but the check was for a value
less than zero.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/common/tuners/xc5000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index f660e33..a7fa17e 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -341,7 +341,7 @@ static int xc_write_reg(struct xc5000_priv *priv, u16 regAddr, u16 i2cData)
 			}
 		}
 	}
-	if (WatchDogTimer < 0)
+	if (WatchDogTimer <= 0)
 		result = XC_RESULT_I2C_WRITE_FAILURE;
 
 	return result;
-- 
1.7.1

