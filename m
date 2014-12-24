Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:42736 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLXLh3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Dec 2014 06:37:29 -0500
Received: by mail-yh0-f54.google.com with SMTP id 29so4268101yhl.13
        for <linux-media@vger.kernel.org>; Wed, 24 Dec 2014 03:37:28 -0800 (PST)
From: Ismael Luceno <ismael@iodev.co.uk>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Ismael Luceno <ismael@iodev.co.uk>
Subject: [PATCH 2/3] solo6x10: Fix eeprom_* functions buffer's type
Date: Wed, 24 Dec 2014 08:36:00 -0300
Message-Id: <1419420961-7819-2-git-send-email-ismael@iodev.co.uk>
In-Reply-To: <1419420961-7819-1-git-send-email-ismael@iodev.co.uk>
References: <1419420961-7819-1-git-send-email-ismael@iodev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
---
 drivers/media/pci/solo6x10/solo6x10-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-core.c b/drivers/media/pci/solo6x10/solo6x10-core.c
index 8cbe6b4..570d119 100644
--- a/drivers/media/pci/solo6x10/solo6x10-core.c
+++ b/drivers/media/pci/solo6x10/solo6x10-core.c
@@ -182,7 +182,7 @@ static ssize_t eeprom_store(struct device *dev, struct device_attribute *attr,
 {
 	struct solo_dev *solo_dev =
 		container_of(dev, struct solo_dev, dev);
-	unsigned short *p = (unsigned short *)buf;
+	u16 *p = (u16 *)buf;
 	int i;
 
 	if (count & 0x1)
@@ -212,7 +212,7 @@ static ssize_t eeprom_show(struct device *dev, struct device_attribute *attr,
 {
 	struct solo_dev *solo_dev =
 		container_of(dev, struct solo_dev, dev);
-	unsigned short *p = (unsigned short *)buf;
+	u16 *p = (u16 *)buf;
 	int count = (full_eeprom ? 128 : 64);
 	int i;
 
-- 
2.2.0

