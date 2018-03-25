Return-path: <linux-media-owner@vger.kernel.org>
Received: from vps-vb.mhejs.net ([37.28.154.113]:41690 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752478AbeCYV1q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 17:27:46 -0400
From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: [PATCH v6 4/6] tuner-simple: allow setting mono radio mode
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <cover.1522012430.git.mail@maciej.szmigiero.name>
Message-ID: <f28448e8-e819-94cb-9830-f42dbd314858@maciej.szmigiero.name>
Date: Sun, 25 Mar 2018 23:27:43 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1522012430.git.mail@maciej.szmigiero.name>
Content-Type: text/plain; charset=iso-8859-2
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
index 36b88f820239..29c1473f2e9f 100644
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
