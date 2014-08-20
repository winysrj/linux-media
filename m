Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4025 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbaHTW7m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/29] af9015: fix sparse warning
Date: Thu, 21 Aug 2014 00:59:03 +0200
Message-Id: <1408575568-20562-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/dvb-usb-v2/af9015.c:422:38: warning: cast to restricted __le32

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 5ca738a..16c0b7d 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -419,7 +419,7 @@ static int af9015_eeprom_hash(struct dvb_usb_device *d)
 	/* calculate checksum */
 	for (i = 0; i < AF9015_EEPROM_SIZE / sizeof(u32); i++) {
 		state->eeprom_sum *= GOLDEN_RATIO_PRIME_32;
-		state->eeprom_sum += le32_to_cpu(((u32 *)buf)[i]);
+		state->eeprom_sum += le32_to_cpu(((__le32 *)buf)[i]);
 	}
 
 	for (i = 0; i < AF9015_EEPROM_SIZE; i += 16)
-- 
2.1.0.rc1

