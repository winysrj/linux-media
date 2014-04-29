Return-path: <linux-media-owner@vger.kernel.org>
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:44941 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965168AbaD2TuW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Apr 2014 15:50:22 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, m.chehab@samsung.com, tj@kernel.org,
	olebowle@gmx.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH 4/4] media: em28xx dvb changes to initialze tuner token
Date: Tue, 29 Apr 2014 13:49:26 -0600
Message-Id: <ea4afb694b5c3983d0ddf23db26c258675665fef.1398797955.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1398797954.git.shuah.kh@samsung.com>
References: <cover.1398797954.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1398797954.git.shuah.kh@samsung.com>
References: <cover.1398797954.git.shuah.kh@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes to em28xx-dvb to initialze dvb fe tuner token when
dvb fe is registered. This will provide dvb fe the em28xx
tuner token devres for sharing tuner across analog and
digital functions.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index f599b18..829e7c8 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -916,6 +916,10 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 
 	dvb->adapter.priv = &dev->i2c_bus[dev->def_i2c_bus];
 
+	dvb->fe[0]->tuner_tkn = dev->tuner_tkn;
+	if (dvb->fe[1])
+		dvb->fe[1]->tuner_tkn = dev->tuner_tkn;
+
 	/* register frontend */
 	result = dvb_register_frontend(&dvb->adapter, dvb->fe[0]);
 	if (result < 0) {
-- 
1.7.10.4

