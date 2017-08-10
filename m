Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:46472 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752894AbdHJWLY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 18:11:24 -0400
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: [PATCH 4/5] [media] tuner-simple: allow setting mono radio mode
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Message-ID: <ef31c30e-132e-5029-4a42-aadb1846fa5a@maciej.szmigiero.name>
Date: Thu, 10 Aug 2017 23:52:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For some types of tuners (Philips FMD1216ME(X) MK3 currently) we know that
letting TDA9887 output port 1 remain high (inactive) will switch FM radio
to mono mode.
Let's make use of this functionality - nothing changes for the default
stereo radio mode.

Tested on a Medion 95700 board which has a FMD1216ME tuner.

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
---
 drivers/media/tuners/tuner-simple.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/tuner-simple.c b/drivers/media/tuners/tuner-simple.c
index 3339b13dd3f5..568f108efac2 100644
--- a/drivers/media/tuners/tuner-simple.c
+++ b/drivers/media/tuners/tuner-simple.c
@@ -670,6 +670,7 @@ static int simple_set_radio_freq(struct dvb_frontend *fe,
 	int rc, j;
 	struct tuner_params *t_params;
 	unsigned int freq = params->frequency;
+	bool mono = params->audmode == V4L2_TUNER_MODE_MONO;
 
 	tun = priv->tun;
 
@@ -736,8 +737,8 @@ static int simple_set_radio_freq(struct dvb_frontend *fe,
 			config |= TDA9887_PORT2_ACTIVE;
 		if (t_params->intercarrier_mode)
 			config |= TDA9887_INTERCARRIER;
-/*		if (t_params->port1_set_for_fm_mono)
-			config &= ~TDA9887_PORT1_ACTIVE;*/
+		if (t_params->port1_set_for_fm_mono && mono)
+			config &= ~TDA9887_PORT1_ACTIVE;
 		if (t_params->fm_gain_normal)
 			config |= TDA9887_GAIN_NORMAL;
 		if (t_params->radio_if == 2)
