Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1bon0133.outbound.protection.outlook.com ([157.56.111.133]:4360
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753206AbcAKHad (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 02:30:33 -0500
From: Fugang Duan <b38611@freescale.com>
To: <mchehab@osg.samsung.com>, <arnd@arndb.de>
CC: <linux-media@vger.kernel.org>, <wsa@the-dreams.de>,
	<hans.verkuil@cisco.com>, <fugang.duan@nxp.com>
Subject: [PATCH] [media] radio-si476x: add return value check to avoid dead code
Date: Mon, 11 Jan 2016 15:13:35 +0800
Message-ID: <1452496415-6226-1-git-send-email-b38611@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dead code found on below code:
    si476x_radio_add_new_custom(radio, SI476X_IDX_DIVERSITY_MODE);
    if (rval < 0)
            goto exit;

    si476x_radio_add_new_custom(radio, SI476X_IDX_INTERCHIP_LINK);
    if (rval < 0)  ====> Dead code !!!
            goto exit;

The piece of code miss return value check after calling .si476x_radio_add_new_custom(),
the patch fix it.

Signed-off-by: Fugang Duan <B38611@freescale.com>
---
 drivers/media/radio/radio-si476x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 859f0c0..271f725 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -1530,11 +1530,11 @@ static int si476x_radio_probe(struct platform_device *pdev)
 	if (si476x_core_has_diversity(radio->core)) {
 		si476x_ctrls[SI476X_IDX_DIVERSITY_MODE].def =
 			si476x_phase_diversity_mode_to_idx(radio->core->diversity_mode);
-		si476x_radio_add_new_custom(radio, SI476X_IDX_DIVERSITY_MODE);
+		rval = si476x_radio_add_new_custom(radio, SI476X_IDX_DIVERSITY_MODE);
 		if (rval < 0)
 			goto exit;
 
-		si476x_radio_add_new_custom(radio, SI476X_IDX_INTERCHIP_LINK);
+		rval = si476x_radio_add_new_custom(radio, SI476X_IDX_INTERCHIP_LINK);
 		if (rval < 0)
 			goto exit;
 	}
-- 
1.9.1

