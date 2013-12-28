Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50192 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3L1MQ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 12/24] tuner-xc2028: remove unused code
Date: Sat, 28 Dec 2013 10:16:04 -0200
Message-Id: <1388232976-20061-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

This macro is not used. remove it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/tuner-xc2028.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 4be5cf808a40..1057da54c6e0 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -134,15 +134,6 @@ struct xc2028_data {
 	_rc;								\
 })
 
-#define i2c_rcv(priv, buf, size) ({					\
-	int _rc;							\
-	_rc = tuner_i2c_xfer_recv(&priv->i2c_props, buf, size);		\
-	if (size != _rc)						\
-		tuner_err("i2c input error: rc = %d (should be %d)\n",	\
-			   _rc, (int)size); 				\
-	_rc;								\
-})
-
 #define i2c_send_recv(priv, obuf, osize, ibuf, isize) ({		\
 	int _rc;							\
 	_rc = tuner_i2c_xfer_send_recv(&priv->i2c_props, obuf, osize,	\
-- 
1.8.3.1

