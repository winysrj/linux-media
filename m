Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43738 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbaADOAg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 09:00:36 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v4 10/22] [media] tuner-xc2028: remove unused code
Date: Sat,  4 Jan 2014 08:55:39 -0200
Message-Id: <1388832951-11195-11-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

