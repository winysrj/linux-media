Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60596 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbaHIU1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 16:27:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/14] it913x: avoid division by zero on error case
Date: Sat,  9 Aug 2014 23:27:07 +0300
Message-Id: <1407616032-2722-10-git-send-email-crope@iki.fi>
In-Reply-To: <1407616032-2722-1-git-send-email-crope@iki.fi>
References: <1407616032-2722-1-git-send-email-crope@iki.fi>
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

