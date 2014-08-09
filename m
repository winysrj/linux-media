Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48073 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaHIU1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 16:27:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 10/14] it913x: fix IT9135 AX sleep
Date: Sat,  9 Aug 2014 23:27:08 +0300
Message-Id: <1407616032-2722-11-git-send-email-crope@iki.fi>
In-Reply-To: <1407616032-2722-1-git-send-email-crope@iki.fi>
References: <1407616032-2722-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Old IT9135 AX needs a little bit different register settings for
sleep than newer IT9135 BX. This has been broken always, as power
management of the whole driver, but it started to be problem as I
fixed clock. Earlier clock was disabled very first on sleep and
rest of the commands were skipped by the chip as no clock, leaving
tuner full power state. When I fixed clocks these PM bugs started
raising out as I/O errors.

Cc: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tuner_it913x.c      |  6 +++++-
 drivers/media/tuners/tuner_it913x_priv.h | 11 +++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/tuner_it913x.c b/drivers/media/tuners/tuner_it913x.c
index cd20c5b..281d8c5 100644
--- a/drivers/media/tuners/tuner_it913x.c
+++ b/drivers/media/tuners/tuner_it913x.c
@@ -371,7 +371,11 @@ static int it9137_set_params(struct dvb_frontend *fe)
 static int it913x_sleep(struct dvb_frontend *fe)
 {
 	struct it913x_state *state = fe->tuner_priv;
-	return it913x_script_loader(state, it9137_tuner_off);
+
+	if (state->chip_ver == 0x01)
+		return it913x_script_loader(state, it9135ax_tuner_off);
+	else
+		return it913x_script_loader(state, it9137_tuner_off);
 }
 
 static int it913x_release(struct dvb_frontend *fe)
diff --git a/drivers/media/tuners/tuner_it913x_priv.h b/drivers/media/tuners/tuner_it913x_priv.h
index 8e85a61..cc6f4b1 100644
--- a/drivers/media/tuners/tuner_it913x_priv.h
+++ b/drivers/media/tuners/tuner_it913x_priv.h
@@ -36,6 +36,17 @@ struct it913xset {	u32 pro;
 			u8 count;
 };
 
+/* Tuner setting scripts for IT9135 AX */
+static struct it913xset it9135ax_tuner_off[] = {
+	{PRO_DMOD, 0xec40, {0x00}, 0x01}, /* Power Down Tuner */
+	{PRO_DMOD, 0xec02, {0x3f}, 0x01},
+	{PRO_DMOD, 0xec03, {0x1f}, 0x01},
+	{PRO_DMOD, 0xec04, {0x3f}, 0x01},
+	{PRO_DMOD, 0xec05, {0x3f}, 0x01},
+	{PRO_DMOD, 0xec3f, {0x01}, 0x01},
+	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
+};
+
 /* Tuner setting scripts (still keeping it9137) */
 static struct it913xset it9137_tuner_off[] = {
 	{PRO_DMOD, 0xec40, {0x00}, 0x01}, /* Power Down Tuner */
-- 
http://palosaari.fi/

