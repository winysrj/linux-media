Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:58794 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbbALTKL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 14:10:11 -0500
From: Benjamin Larsson <benjamin@southpole.se>
To: mchehab@osg.samsung.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] r820t: enable flt_ext_wide for SYS_DVBC_ANNEX_A standard
Date: Mon, 12 Jan 2015 20:10:02 +0100
Message-Id: <1421089803-6136-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/tuners/r820t.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 8e040cf..c94c6a3 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -969,7 +969,7 @@ static int r820t_set_tv_standard(struct r820t_priv *priv,
 		ext_enable = 0x40;	/* r30[6]=1 ext enable; r30[5]:1 ext at lna max-1 */
 		loop_through = 0x00;	/* r5[7], lt on */
 		lt_att = 0x00;		/* r31[7], lt att enable */
-		flt_ext_widest = 0x00;	/* r15[7]: flt_ext_wide off */
+		flt_ext_widest = 0x80;	/* r15[7]: flt_ext_wide on */
 		polyfil_cur = 0x60;	/* r25[6:5]:min */
 	} else {
 		if (bw <= 6) {
-- 
2.1.0

