Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36080 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752353AbdHMMpC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Aug 2017 08:45:02 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        awalls@md.metrocast.net, mkrufky@linuxtv.org, eric@anholt.net,
        stefan.wahren@i2se.com, gregkh@linuxfoundation.org,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, balbi@kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 6/6] [media] tuners: make snd_pcm_hardware const
Date: Sun, 13 Aug 2017 18:13:13 +0530
Message-Id: <1502628193-3343-7-git-send-email-bhumirks@gmail.com>
In-Reply-To: <1502628193-3343-1-git-send-email-bhumirks@gmail.com>
References: <1502628193-3343-1-git-send-email-bhumirks@gmail.com>
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
