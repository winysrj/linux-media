Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:60971 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbZJCSze (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 14:55:34 -0400
Received: by ey-out-2122.google.com with SMTP id 4so364405eyf.19
        for <linux-media@vger.kernel.org>; Sat, 03 Oct 2009 11:54:26 -0700 (PDT)
Message-ID: <4AC79FE0.6030008@gmail.com>
Date: Sat, 03 Oct 2009 21:02:56 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: mchehab@redhat.com, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] tuner-simple: possible read buffer overflow?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prevent read from t_params->ranges[-1].

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
This is only required when t_params->count can be 0, can it?

Roel

diff --git a/drivers/media/common/tuners/tuner-simple.c b/drivers/media/common/tuners/tuner-simple.c
index 8abbcc5..e679d5f 100644
--- a/drivers/media/common/tuners/tuner-simple.c
+++ b/drivers/media/common/tuners/tuner-simple.c
@@ -266,7 +266,7 @@ static int simple_config_lookup(struct dvb_frontend *fe,
 			continue;
 		break;
 	}
-	if (i == t_params->count) {
+	if (i == t_params->count && i) {
 		tuner_dbg("frequency out of range (%d > %d)\n",
 			  *frequency, t_params->ranges[i - 1].limit);
 		*frequency = t_params->ranges[--i].limit;
