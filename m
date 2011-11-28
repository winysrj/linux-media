Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:62636 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab1K1Tqg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 14:46:36 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 2/5] tm6000: bugfix register setting
Date: Mon, 28 Nov 2011 20:46:17 +0100
Message-Id: <1322509580-14460-2-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/video/tm6000/tm6000-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-core.c b/drivers/media/video/tm6000/tm6000-core.c
index 9783616..c007e6d 100644
--- a/drivers/media/video/tm6000/tm6000-core.c
+++ b/drivers/media/video/tm6000/tm6000-core.c
@@ -125,14 +125,14 @@ int tm6000_set_reg_mask(struct tm6000_core *dev, u8 req, u16 value,
 	u8 new_index;
 
 	rc = tm6000_read_write_usb(dev, USB_DIR_IN | USB_TYPE_VENDOR, req,
-					value, index, buf, 1);
+					value, 0, buf, 1);
 
 	if (rc < 0)
 		return rc;
 
 	new_index = (buf[0] & ~mask) | (index & mask);
 
-	if (new_index == index)
+	if (new_index == buf[0])
 		return 0;
 
 	return tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR,
-- 
1.7.7

