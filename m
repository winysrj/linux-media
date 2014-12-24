Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:37191 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLXLhc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Dec 2014 06:37:32 -0500
Received: by mail-yk0-f173.google.com with SMTP id 19so3850221ykq.18
        for <linux-media@vger.kernel.org>; Wed, 24 Dec 2014 03:37:32 -0800 (PST)
From: Ismael Luceno <ismael@iodev.co.uk>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Ismael Luceno <ismael@iodev.co.uk>
Subject: [PATCH 3/3] solo6x10: Fix solo_eeprom_read retval type
Date: Wed, 24 Dec 2014 08:36:01 -0300
Message-Id: <1419420961-7819-3-git-send-email-ismael@iodev.co.uk>
In-Reply-To: <1419420961-7819-1-git-send-email-ismael@iodev.co.uk>
References: <1419420961-7819-1-git-send-email-ismael@iodev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
---
 drivers/media/pci/solo6x10/solo6x10-eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-eeprom.c b/drivers/media/pci/solo6x10/solo6x10-eeprom.c
index da25ce4..8e81186 100644
--- a/drivers/media/pci/solo6x10/solo6x10-eeprom.c
+++ b/drivers/media/pci/solo6x10/solo6x10-eeprom.c
@@ -103,7 +103,7 @@ unsigned int solo_eeprom_ewen(struct solo_dev *solo_dev, int w_en)
 __be16 solo_eeprom_read(struct solo_dev *solo_dev, int loc)
 {
 	int read_cmd = loc | (EE_READ_CMD << ADDR_LEN);
-	unsigned short retval = 0;
+	u16 retval = 0;
 	int i;
 
 	solo_eeprom_cmd(solo_dev, read_cmd);
-- 
2.2.0

