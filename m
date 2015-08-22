Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40490 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Antti Palosaari <crope@iki.fi>, Arnd Bergmann <arnd@arndb.de>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 36/39] [media] dvb: Use DVBFE_ALGO_HW where applicable
Date: Sat, 22 Aug 2015 14:28:21 -0300
Message-Id: <2f192aacb062c7410f8b5e68964a185210439ad5.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb_frontend.c core defines a FE_ALGO_HW symbol that it is
never used. Also, both cx24123 returns 1 to get_algo() callback
instead of using DVBFE_ALGO_HW.

Probably, those are some left overs from some code cleanup.

Let's stop returning magic numbers and use the proper macro
value.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 842b9c8f80c6..c38ef1a72b4a 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -81,7 +81,6 @@ MODULE_PARM_DESC(dvb_mfe_wait_time, "Wait up to <mfe_wait_time> seconds on open(
 #define FESTATE_SEARCHING_SLOW (FESTATE_TUNING_SLOW | FESTATE_ZIGZAG_SLOW)
 #define FESTATE_LOSTLOCK (FESTATE_ZIGZAG_FAST | FESTATE_ZIGZAG_SLOW)
 
-#define FE_ALGO_HW		1
 /*
  * FESTATE_IDLE. No tuning parameters have been supplied and the loop is idling.
  * FESTATE_RETUNE. Parameters have been supplied, but we have not yet performed the first tune.
diff --git a/drivers/media/dvb-frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
index e18cf9e1185e..0fe7fb11124b 100644
--- a/drivers/media/dvb-frontends/cx24123.c
+++ b/drivers/media/dvb-frontends/cx24123.c
@@ -1011,7 +1011,7 @@ static int cx24123_tune(struct dvb_frontend *fe,
 
 static int cx24123_get_algo(struct dvb_frontend *fe)
 {
-	return 1; /* FE_ALGO_HW */
+	return DVBFE_ALGO_HW;
 }
 
 static void cx24123_release(struct dvb_frontend *fe)
diff --git a/drivers/media/dvb-frontends/s921.c b/drivers/media/dvb-frontends/s921.c
index b2d9fe13e1a0..d6a8fa63040b 100644
--- a/drivers/media/dvb-frontends/s921.c
+++ b/drivers/media/dvb-frontends/s921.c
@@ -466,7 +466,7 @@ static int s921_tune(struct dvb_frontend *fe,
 
 static int s921_get_algo(struct dvb_frontend *fe)
 {
-	return 1; /* FE_ALGO_HW */
+	return DVBFE_ALGO_HW;
 }
 
 static void s921_release(struct dvb_frontend *fe)
-- 
2.4.3

