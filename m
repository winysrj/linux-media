Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57680 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbaIDChA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/37] it913x: avoid division by zero on error case
Date: Thu,  4 Sep 2014 05:36:12 +0300
Message-Id: <1409798205-25645-4-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Error on init leaves some internal divisor zero, which causes oops
later. Fix it by populating divisors even it fails.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tuner_it913x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/tuners/tuner_it913x.c b/drivers/media/tuners/tuner_it913x.c
index 3265d9a..cd20c5b 100644
--- a/drivers/media/tuners/tuner_it913x.c
+++ b/drivers/media/tuners/tuner_it913x.c
@@ -154,6 +154,9 @@ static int it913x_init(struct dvb_frontend *fe)
 		val = 16;
 		break;
 	case -ENODEV:
+		/* FIXME: these are just avoid divide by 0 */
+		state->tun_xtal = 2000;
+		state->tun_fdiv = 3;
 		return -ENODEV;
 	case 1:
 	default:
-- 
http://palosaari.fi/

