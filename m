Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:64003 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab0CDFkR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 00:40:17 -0500
Received: by gxk9 with SMTP id 9so985606gxk.8
        for <linux-media@vger.kernel.org>; Wed, 03 Mar 2010 21:40:15 -0800 (PST)
Date: Thu, 4 Mar 2010 14:40:37 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] fix broken I2C IR for Beholder
Message-ID: <20100304144037.2c6601d5@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/hZ.gFiqQHppgm9/IPSKVMEX"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/hZ.gFiqQHppgm9/IPSKVMEX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Fix broken I2C IR for TV cards of Beholder.

diff -r 37ff78330942 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Feb 28 16:59:57 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Thu Mar 04 08:35:15 2010 +0900
@@ -947,6 +947,7 @@
 		dev->init_data.name = "BeholdTV";
 		dev->init_data.get_key = get_key_beholdm6xx;
 		dev->init_data.ir_codes = &ir_codes_behold_table;
+		dev->init_data.type = IR_TYPE_NEC;
 		info.addr = 0x2d;
 #endif
 		break;

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.

--MP_/hZ.gFiqQHppgm9/IPSKVMEX
Content-Type: text/x-patch; name=behold_i2c_ir.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_i2c_ir.patch

diff -r 37ff78330942 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Feb 28 16:59:57 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Thu Mar 04 08:35:15 2010 +0900
@@ -947,6 +947,7 @@
 		dev->init_data.name = "BeholdTV";
 		dev->init_data.get_key = get_key_beholdm6xx;
 		dev->init_data.ir_codes = &ir_codes_behold_table;
+		dev->init_data.type = IR_TYPE_NEC;
 		info.addr = 0x2d;
 #endif
 		break;

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/hZ.gFiqQHppgm9/IPSKVMEX--
