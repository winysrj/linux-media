Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:14257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956Ab0I1StX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 14:49:23 -0400
Date: Tue, 28 Sep 2010 15:46:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/10] V4L/DVB: tda18271: Add some hint about what tda18217
 reg ID returned
Message-ID: <20100928154655.183af4b3@pedra>
In-Reply-To: <cover.1285699057.git.mchehab@redhat.com>
References: <cover.1285699057.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Instead of doing:

[   82.581639] tda18271 4-0060: creating new instance
[   82.588411] Unknown device detected @ 4-0060, device not supported.
[   82.594695] tda18271_attach: [4-0060|M] error -22 on line 1272
[   82.600530] tda18271 4-0060: destroying instance

Print:
[  468.740392] Unknown device (0) detected @ 4-0060, device not supported.

for the error message, to help detecting what's going wrong with the
device.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/tda18271-fe.c b/drivers/media/common/tuners/tda18271-fe.c
index 7955e49..77e3642 100644
--- a/drivers/media/common/tuners/tda18271-fe.c
+++ b/drivers/media/common/tuners/tda18271-fe.c
@@ -1177,7 +1177,7 @@ static int tda18271_get_id(struct dvb_frontend *fe)
 		break;
 	}
 
-	tda_info("%s detected @ %d-%04x%s\n", name,
+	tda_info("%s (%i) detected @ %d-%04x%s\n", name, regs[R_ID] & 0x7f,
 		 i2c_adapter_id(priv->i2c_props.adap),
 		 priv->i2c_props.addr,
 		 (0 == ret) ? "" : ", device not supported.");
-- 
1.7.1


