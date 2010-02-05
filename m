Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:56160 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933988Ab0BEWs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 17:48:57 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 9/12] tm6000: remove unused function
Date: Fri,  5 Feb 2010 23:48:13 +0100
Message-Id: <1265410096-11788-8-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1265410096-11788-7-git-send-email-stefan.ringel@arcor.de>
References: <1265410096-11788-1-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-2-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-3-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-4-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-5-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-6-git-send-email-stefan.ringel@arcor.de>
 <1265410096-11788-7-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

---
 drivers/staging/tm6000/tm6000.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index d713c48..e88836d 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -212,7 +212,6 @@ int tm6000_read_write_usb (struct tm6000_core *dev, u8 reqtype, u8 req,
 int tm6000_get_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_set_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index);
 int tm6000_init (struct tm6000_core *dev);
-int tm6000_init_after_firmware (struct tm6000_core *dev);
 
 int tm6000_init_analog_mode (struct tm6000_core *dev);
 int tm6000_init_digital_mode (struct tm6000_core *dev);
-- 
1.6.4.2

