Return-path: <linux-media-owner@vger.kernel.org>
Received: from jablonecka.jablonka.cz ([91.219.244.36]:49226 "EHLO
	jablonecka.jablonka.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab3I2LOW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Sep 2013 07:14:22 -0400
Message-ID: <52480506.6090706@seznam.cz>
Date: Sun, 29 Sep 2013 12:46:30 +0200
From: =?ISO-8859-2?Q?Ji=F8=ED_Pinkava?= <j-pi@seznam.cz>
MIME-Version: 1.0
To: gennarone@gmail.com, m.chehab@samsung.com
CC: mkrufky@linuxtv.org, linux-media@vger.kernel.org
Subject: Subject: [PATCH 2/2] [media] r820t: simplify divisor calculation
References: <524804B3.9090505@seznam.cz> <524804DB.7020108@seznam.cz>
In-Reply-To: <524804DB.7020108@seznam.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


---
 drivers/media/tuners/r820t.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index e25c720..36dc63e 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -596,13 +596,9 @@ static int r820t_set_pll(struct r820t_priv *priv,
enum v4l2_tuner_type type,
        while (mix_div <= 64) {
                if (((freq * mix_div) >= vco_min) &&
                   ((freq * mix_div) < vco_max)) {
-                       div_buf = mix_div;
-                       while (div_buf > 2) {
-                               div_buf = div_buf >> 1;
-                               div_num++;
-                       }
                        break;
                }
+               ++div_num;
                mix_div = mix_div << 1;
        }
 
-- 
1.8.3.2


