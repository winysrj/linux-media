Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:55645 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754874AbcJNLnR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 07:43:17 -0400
Subject: [PATCH 3/5] [media] winbond-cir: Move assignments for three variables
 in wbcir_shutdown()
To: linux-media@vger.kernel.org,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <285954ec-280f-8a5a-5189-eb2471b4339c@users.sourceforge.net>
Date: Fri, 14 Oct 2016 13:43:09 +0200
MIME-Version: 1.0
In-Reply-To: <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 14 Oct 2016 10:40:12 +0200

Move the setting for the local variables "mask", "match" and "rc6_csl"
behind the source code for a condition check by this function
at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/winbond-cir.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index fd997f0..9d05e17 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -702,17 +702,17 @@ wbcir_shutdown(struct pnp_dev *device)
 	bool do_wake = true;
 	u8 match[11];
 	u8 mask[11];
-	u8 rc6_csl = 0;
+	u8 rc6_csl;
 	int i;
 
-	memset(match, 0, sizeof(match));
-	memset(mask, 0, sizeof(mask));
-
 	if (wake_sc == INVALID_SCANCODE || !device_may_wakeup(dev)) {
 		do_wake = false;
 		goto finish;
 	}
 
+	rc6_csl = 0;
+	memset(match, 0, sizeof(match));
+	memset(mask, 0, sizeof(mask));
 	switch (protocol) {
 	case IR_PROTOCOL_RC5:
 		if (wake_sc > 0xFFF) {
-- 
2.10.1

