Return-path: <linux-media-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:49216 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3I2LOT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Sep 2013 07:14:19 -0400
Message-ID: <524804DB.7020108@seznam.cz>
Date: Sun, 29 Sep 2013 12:45:47 +0200
From: =?ISO-8859-2?Q?Ji=F8=ED_Pinkava?= <j-pi@seznam.cz>
MIME-Version: 1.0
To: gennarone@gmail.com, m.chehab@samsung.com
CC: mkrufky@linuxtv.org, linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media] r820t: fix nint range check
References: <524804B3.9090505@seznam.cz>
In-Reply-To: <524804B3.9090505@seznam.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Use full range of VCO parameters, fixes tunning for some frequencies.
---
 drivers/media/tuners/r820t.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 1c23666..e25c720 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -637,7 +637,7 @@ static int r820t_set_pll(struct r820t_priv *priv,
enum v4l2_tuner_type type,
                vco_fra = pll_ref * 129 / 128;
        }
 
-       if (nint > 63) {
+       if (nint > 76) {
                tuner_info("No valid PLL values for %u kHz!\n", freq);
                return -EINVAL;
        }
-- 
1.8.3.2


