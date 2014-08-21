Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3924 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaHUUTz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 16:19:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/12] em28xx: fix sparse warnings
Date: Thu, 21 Aug 2014 22:19:34 +0200
Message-Id: <1408652376-39525-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
References: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/em28xx/em28xx-core.c:297:16: warning: cast to restricted __le16
drivers/media/usb/em28xx/em28xx-cards.c:2249:20: warning: symbol 'em28xx_bcount' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 2 +-
 drivers/media/usb/em28xx/em28xx-core.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index a7e24848..230d6a2 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2246,7 +2246,7 @@ struct em28xx_board em28xx_boards[] = {
 };
 EXPORT_SYMBOL_GPL(em28xx_boards);
 
-const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
+static const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
 /* table of devices that work with this driver */
 struct usb_device_id em28xx_id_table[] = {
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 523d7e9..225a735 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -279,7 +279,7 @@ int em28xx_read_ac97(struct em28xx *dev, u8 reg)
 {
 	int ret;
 	u8 addr = (reg & 0x7f) | 0x80;
-	u16 val;
+	__le16 val;
 
 	ret = em28xx_is_ac97_ready(dev);
 	if (ret < 0)
-- 
2.1.0.rc1

