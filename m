Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62637 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbbAAQ60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Jan 2015 11:58:26 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so28235355wiv.0
        for <linux-media@vger.kernel.org>; Thu, 01 Jan 2015 08:58:25 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: pci: mantis: mantis_core.c:  Remove unused function
Date: Thu,  1 Jan 2015 17:55:01 +0100
Message-Id: <1420131301-30273-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the function write_eeprom_byte() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/media/pci/mantis/mantis_core.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/media/pci/mantis/mantis_core.c b/drivers/media/pci/mantis/mantis_core.c
index 684d906..82220ea 100644
--- a/drivers/media/pci/mantis/mantis_core.c
+++ b/drivers/media/pci/mantis/mantis_core.c
@@ -56,29 +56,6 @@ static int read_eeprom_byte(struct mantis_pci *mantis, u8 *data, u8 length)
 	return 0;
 }
 
-static int write_eeprom_byte(struct mantis_pci *mantis, u8 *data, u8 length)
-{
-	int err;
-
-	struct i2c_msg msg = {
-		.addr = 0x50,
-		.flags = 0,
-		.buf = data,
-		.len = length
-	};
-
-	err = i2c_transfer(&mantis->adapter, &msg, 1);
-	if (err < 0) {
-		dprintk(verbose, MANTIS_ERROR, 1,
-			"ERROR: i2c write: < err=%i length=0x%02x d0=0x%02x, d1=0x%02x >",
-			err, length, data[0], data[1]);
-
-		return err;
-	}
-
-	return 0;
-}
-
 static int get_mac_address(struct mantis_pci *mantis)
 {
 	int err;
-- 
1.7.10.4

