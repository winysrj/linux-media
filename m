Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38224 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbdHLMMr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Aug 2017 08:12:47 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mkrufky@linuxtv.org, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] tuners: make tda18271_std_map const
Date: Sat, 12 Aug 2017 17:42:36 +0530
Message-Id: <1502539956-20977-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const as they are only used during a copy operation.
Done using Coccinelle.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/tuners/tda18271-maps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/tda18271-maps.c b/drivers/media/tuners/tda18271-maps.c
index 7d11467..9679804 100644
--- a/drivers/media/tuners/tda18271-maps.c
+++ b/drivers/media/tuners/tda18271-maps.c
@@ -1182,7 +1182,7 @@ int tda18271_lookup_map(struct dvb_frontend *fe,
 
 /*---------------------------------------------------------------------*/
 
-static struct tda18271_std_map tda18271c1_std_map = {
+static const struct tda18271_std_map tda18271c1_std_map = {
 	.fm_radio = { .if_freq = 1250, .fm_rfn = 1, .agc_mode = 3, .std = 0,
 		      .if_lvl = 0, .rfagc_top = 0x2c, }, /* EP3[4:0] 0x18 */
 	.atv_b    = { .if_freq = 6750, .fm_rfn = 0, .agc_mode = 1, .std = 6,
@@ -1215,7 +1215,7 @@ int tda18271_lookup_map(struct dvb_frontend *fe,
 		      .if_lvl = 1, .rfagc_top = 0x37, }, /* EP3[4:0] 0x1f */
 };
 
-static struct tda18271_std_map tda18271c2_std_map = {
+static const struct tda18271_std_map tda18271c2_std_map = {
 	.fm_radio = { .if_freq = 1250, .fm_rfn = 1, .agc_mode = 3, .std = 0,
 		      .if_lvl = 0, .rfagc_top = 0x2c, }, /* EP3[4:0] 0x18 */
 	.atv_b    = { .if_freq = 6000, .fm_rfn = 0, .agc_mode = 1, .std = 5,
-- 
1.9.1
