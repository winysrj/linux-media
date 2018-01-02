Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:59078 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750736AbeABJwL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 04:52:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Max Kellermann <max.kellermann@gmail.com>,
        Wolfgang Rohdewald <wolfgang@rohdewald.de>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: don't drop front-end reference count for ->detach
Date: Tue,  2 Jan 2018 10:48:54 +0100
Message-Id: <20180102095154.3424890-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A bugfix introduce a link failure in configurations without CONFIG_MODULES:

In file included from drivers/media/usb/dvb-usb/pctv452e.c:20:0:
drivers/media/usb/dvb-usb/pctv452e.c: In function 'pctv452e_frontend_attach':
drivers/media/dvb-frontends/stb0899_drv.h:151:36: error: weak declaration of 'stb0899_attach' being applied to a already existing, static definition

The problem is that the !IS_REACHABLE() declaration of stb0899_attach()
is a 'static inline' definition that clashes with the weak definition.

I further observed that the bugfix was only done for one of the five users
of stb0899_attach(), the other four still have the problem.  This reverts
the bugfix and instead addresses the problem by not dropping the reference
count when calling '->detach()', instead we call this function directly
in dvb_frontend_put() before dropping the kref on the front-end.

Cc: Max Kellermann <max.kellermann@gmail.com>
Cc: Wolfgang Rohdewald <wolfgang@rohdewald.de>
Fixes: f686c14364ad ("[media] stb0899: move code to "detach" callback")
Fixes: 6cdeaed3b142 ("media: dvb_usb_pctv452e: module refcount changes were unbalanced")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/dvb-core/dvb_frontend.c | 4 +++-
 drivers/media/usb/dvb-usb/pctv452e.c  | 8 --------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 87fc1bcae5ae..fe10b6f4d3e0 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -164,6 +164,9 @@ static void dvb_frontend_free(struct kref *ref)
 
 static void dvb_frontend_put(struct dvb_frontend *fe)
 {
+	/* call detach before dropping the reference count */
+	if (fe->ops.detach)
+		fe->ops.detach(fe);
 	/*
 	 * Check if the frontend was registered, as otherwise
 	 * kref was not initialized yet.
@@ -2965,7 +2968,6 @@ void dvb_frontend_detach(struct dvb_frontend* fe)
 	dvb_frontend_invoke_release(fe, fe->ops.release_sec);
 	dvb_frontend_invoke_release(fe, fe->ops.tuner_ops.release);
 	dvb_frontend_invoke_release(fe, fe->ops.analog_ops.release);
-	dvb_frontend_invoke_release(fe, fe->ops.detach);
 	dvb_frontend_put(fe);
 }
 EXPORT_SYMBOL(dvb_frontend_detach);
diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index 0af74383083d..ae793dac4964 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -913,14 +913,6 @@ static int pctv452e_frontend_attach(struct dvb_usb_adapter *a)
 						&a->dev->i2c_adap);
 	if (!a->fe_adap[0].fe)
 		return -ENODEV;
-
-	/*
-	 * dvb_frontend will call dvb_detach for both stb0899_detach
-	 * and stb0899_release but we only do dvb_attach(stb0899_attach).
-	 * Increment the module refcount instead.
-	 */
-	symbol_get(stb0899_attach);
-
 	if ((dvb_attach(lnbp22_attach, a->fe_adap[0].fe,
 					&a->dev->i2c_adap)) == NULL)
 		err("Cannot attach lnbp22\n");
-- 
2.9.0
