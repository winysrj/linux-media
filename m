Return-path: <linux-media-owner@vger.kernel.org>
Received: from atl4mhob07.myregisteredsite.com ([209.17.115.45]:46746 "EHLO
	atl4mhob07.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964948AbbHKMVQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 08:21:16 -0400
Received: from mailpod.hostingplatform.com ([10.30.71.205])
	by atl4mhob07.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id t7BCLBfR008483
	for <linux-media@vger.kernel.org>; Tue, 11 Aug 2015 08:21:11 -0400
From: Mike Looijmans <mike.looijmans@topic.nl>
To: hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	lars@metafoo.de, Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH] i2c/adv7511: Fix license, set to GPL v2
Date: Tue, 11 Aug 2015 14:21:07 +0200
Message-Id: <1439295667-6716-1-git-send-email-mike.looijmans@topic.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Header claims GPL v2, so make the MODULE_LICENSE reflect that properly.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
 drivers/media/i2c/adv7511.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 95bcd40..497ee00 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -40,7 +40,7 @@ MODULE_PARM_DESC(debug, "debug level (0-2)");
 
 MODULE_DESCRIPTION("Analog Devices ADV7511 HDMI Transmitter Device Driver");
 MODULE_AUTHOR("Hans Verkuil");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL v2");
 
 #define MASK_ADV7511_EDID_RDY_INT   0x04
 #define MASK_ADV7511_MSEN_INT       0x40
-- 
1.9.1

