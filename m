Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:40287 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507AbcHIVlp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 17:41:45 -0400
Subject: [PATCH 09/12] [media] stb0899: move code to "detach" callback
From: Max Kellermann <max.kellermann@gmail.com>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 09 Aug 2016 23:32:46 +0200
Message-ID: <147077836658.21835.8385691206139347968.stgit@woodpecker.blarg.de>
In-Reply-To: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
References: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ensure that STB0899_POSTPROC_GPIO_POWER is set synchronously.

Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/media/dvb-frontends/stb0899_drv.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
index 1d34e95..8dc4894 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.c
+++ b/drivers/media/dvb-frontends/stb0899_drv.c
@@ -614,13 +614,19 @@ static int stb0899_postproc(struct stb0899_state *state, u8 ctl, int enable)
 	return 0;
 }
 
-static void stb0899_release(struct dvb_frontend *fe)
+static void stb0899_detach(struct dvb_frontend *fe)
 {
 	struct stb0899_state *state = fe->demodulator_priv;
 
-	dprintk(state->verbose, FE_DEBUG, 1, "Release Frontend");
 	/* post process event */
 	stb0899_postproc(state, STB0899_POSTPROC_GPIO_POWER, 0);
+}
+
+static void stb0899_release(struct dvb_frontend *fe)
+{
+	struct stb0899_state *state = fe->demodulator_priv;
+
+	dprintk(state->verbose, FE_DEBUG, 1, "Release Frontend");
 	kfree(state);
 }
 
@@ -1603,6 +1609,7 @@ static const struct dvb_frontend_ops stb0899_ops = {
 					  FE_CAN_QPSK
 	},
 
+	.detach				= stb0899_detach,
 	.release			= stb0899_release,
 	.init				= stb0899_init,
 	.sleep				= stb0899_sleep,

