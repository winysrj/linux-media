Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579AbaJ3JyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 05:54:20 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?=5C=22David=20H=C3=A4rdeman=5C=22?= <david@hardeman.nu>,
	James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?q?=5C=22Antti=20Sepp=C3=A4l=C3=A4=5C=22?=
	<a.seppala@gmail.com>
Subject: [PATCH] [media] rc5-decoder: BZ#85721: Fix RC5-SZ decoding
Date: Thu, 30 Oct 2014 07:54:12 -0200
Message-Id: <799eec4754378141225f1997a581fb42818fcfb4.1414662837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset e87b540be2dd broke RC5-SZ decoding, as it forgot to add
the extra bit check for the enabled protocols at the beginning of
the logic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 2ef763928ca4..84fa6e9b59a1 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -53,7 +53,7 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	u32 scancode;
 	enum rc_type protocol;
 
-	if (!(dev->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X)))
+	if (!(dev->enabled_protocols & (RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ)))
 		return 0;
 
 	if (!is_timing_event(ev)) {
-- 
1.9.3

