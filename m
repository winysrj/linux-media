Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34534 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967208Ab2EQWWK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 18:22:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] em28xx: simple comment fix
Date: Fri, 18 May 2012 01:22:02 +0300
Message-Id: <1337293322-19155-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/video/em28xx/em28xx-dvb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 3a5b89d..16410ac 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -476,8 +476,8 @@ static void terratec_h5_init(struct em28xx *dev)
 static void pctv_520e_init(struct em28xx *dev)
 {
 	/*
-	 * Init TDA8295(?) analog demodulator. Looks like I2C traffic to
-	 * digital demodulator and tuner are routed via TDA8295.
+	 * Init AVF4910B analog decoder. Looks like I2C traffic to
+	 * digital demodulator and tuner are routed via AVF4910B.
 	 */
 	int i;
 	struct {
-- 
1.7.7.6

