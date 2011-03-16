Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab1CPUYi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 16:24:38 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2GKOcJ9000987
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 16:24:38 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 3/6] ir-kbd-i2c: pass device code w/key in hauppauge case
Date: Wed, 16 Mar 2011 16:24:28 -0400
Message-Id: <1300307071-19665-4-git-send-email-jarod@redhat.com>
In-Reply-To: <1300307071-19665-1-git-send-email-jarod@redhat.com>
References: <1300307071-19665-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The new hauppauge key tables use both device code button code.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/video/ir-kbd-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 672935f..3ab875d 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -108,7 +108,7 @@ static int get_key_haup_common(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw,
 		start, range, toggle, dev, code);
 
 	/* return key */
-	*ir_key = code;
+	*ir_key = (dev << 8) | code;
 	*ir_raw = ircode;
 	return 1;
 }
-- 
1.7.1

