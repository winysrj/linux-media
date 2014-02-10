Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34051 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbaBJQMu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 11:12:50 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [REVIEW PATCH 1/8] xc2028: silence compiler warnings
Date: Mon, 10 Feb 2014 18:12:26 +0200
Message-Id: <1392048753-13292-2-git-send-email-crope@iki.fi>
In-Reply-To: <1392048753-13292-1-git-send-email-crope@iki.fi>
References: <1392048753-13292-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is now new tuner types which are not handled on that switch-case.
Print error if unknown tuner type is meet.

drivers/media/tuners/tuner-xc2028.c: In function ‘generic_set_freq’:
drivers/media/tuners/tuner-xc2028.c:1037:2: warning: enumeration value ‘V4L2_TUNER_ADC’ not handled in switch [-Wswitch]
  switch (new_type) {
  ^
drivers/media/tuners/tuner-xc2028.c:1037:2: warning: enumeration value ‘V4L2_TUNER_RF’ not handled in switch [-Wswitch]

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tuner-xc2028.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index cca508d..76a8165 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1107,6 +1107,9 @@ static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
 				offset += 200000;
 		}
 #endif
+	default:
+		tuner_err("Unsupported tuner type %d.\n", new_type);
+		break;
 	}
 
 	div = (freq - offset + DIV / 2) / DIV;
-- 
1.8.5.3

