Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53790 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbaDEUYD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Apr 2014 16:24:03 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 4/4] xc2028: add missing break to switch
Date: Sat,  5 Apr 2014 23:23:44 +0300
Message-Id: <1396729424-17576-5-git-send-email-crope@iki.fi>
In-Reply-To: <1396729424-17576-1-git-send-email-crope@iki.fi>
References: <1396729424-17576-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Coverity CID 1196501: Missing break in switch (MISSING_BREAK)

I introduced that bug recently by commit
96a5b3a869e3dc7d55bf04a48a8dca8a4025787e.
As a result, it will flood unintentionally error message to log.

Reported-by: <scan-admin@coverity.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tuner-xc2028.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 76a8165..6ef93ee 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1107,6 +1107,7 @@ static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
 				offset += 200000;
 		}
 #endif
+		break;
 	default:
 		tuner_err("Unsupported tuner type %d.\n", new_type);
 		break;
-- 
1.9.0

