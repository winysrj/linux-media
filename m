Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:33150 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965062AbcHJSzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:55:04 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] [media] drxd_hard: Add missing error code assignment before test
Date: Wed, 10 Aug 2016 07:54:41 +0200
Message-Id: <1470808481-17534-1-git-send-email-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is likely that checking the result of the 2nd 'read16' is expected here.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/media/dvb-frontends/drxk_hard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index b975da099929..c595adc61c6f 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6448,7 +6448,7 @@ static int get_strength(struct drxk_state *state, u64 *strength)
 			return status;
 
 		/* SCU c.o.c. */
-		read16(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A, &scu_coc);
+		status = read16(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A, &scu_coc);
 		if (status < 0)
 			return status;
 
-- 
2.7.4


---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus

