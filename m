Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33090 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030478Ab2EQWei (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 18:34:38 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Oliver Endriss <o.endriss@gmx.de>,
	Ralph Metzler <rjkm@metzlerbros.de>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] em28xx: disable LNA - PCTV QuatroStick nano (520e)
Date: Fri, 18 May 2012 01:34:11 +0300
Message-Id: <1337294051-20363-2-git-send-email-crope@iki.fi>
In-Reply-To: <1337294051-20363-1-git-send-email-crope@iki.fi>
References: <1337294051-20363-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/video/em28xx/em28xx-dvb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index ea3810f..3a5b89d 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -336,6 +336,8 @@ struct drxk_config pctv_520e_drxk = {
 	.single_master = 1,
 	.microcode_name = "dvb-demod-drxk-pctv.fw",
 	.chunk_size = 58,
+	.antenna_dvbt = true, /* disable LNA */
+	.antenna_gpio = (1 << 2), /* disable LNA */
 };
 
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
-- 
1.7.7.6

