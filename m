Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33148
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752149AbdI0Vku (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:40:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH v2 01/37] media: dvb_frontend: only use kref after initialized
Date: Wed, 27 Sep 2017 18:40:02 -0300
Message-Id: <70ccb0c4b0f5d6678437226042c81f60d12667df.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506547906.git.mchehab@s-opensource.com>
References: <cover.1506547906.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Laurent, when a DVB frontend need to register
two drivers (e. g. a tuner and a demod), if the second driver
fails to register (for example because it was not compiled),
the error handling logic frees the frontend by calling
dvb_frontend_detach(). That used to work fine, but changeset
1f862a68df24 ("[media] dvb_frontend: move kref to struct dvb_frontend")
added a kref at struct dvb_frontend. So, now, instead of just
freeing the data, the error handling do a kref_put().

That works fine only after dvb_register_frontend() succeeds.

While it would be possible to add a helper function that
would be initializing earlier the kref, that would require
changing every single DVB frontend on non-trivial ways, and
would make frontends different than other drivers.

So, instead of doing that, let's focus on the real issue:
only call kref_put() after kref_init(). That's easy to
check, as, when the dvb frontend is successfuly registered,
it will allocate its own private struct. So, if such
struct is allocated, it means that it is safe to use
kref_put(). If not, then nobody is using yet the frontend,
and it is safe to just deallocate it.

Fixes: 1f862a68df24 ("[media] dvb_frontend: move kref to struct dvb_frontend")
Reported-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2fcba1616168..9139d01ba7ed 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -141,22 +141,39 @@ struct dvb_frontend_private {
 static void dvb_frontend_invoke_release(struct dvb_frontend *fe,
 					void (*release)(struct dvb_frontend *fe));
 
-static void dvb_frontend_free(struct kref *ref)
+static void __dvb_frontend_free(struct dvb_frontend *fe)
 {
-	struct dvb_frontend *fe =
-		container_of(ref, struct dvb_frontend, refcount);
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
+	if (!fepriv)
+		return;
+
 	dvb_free_device(fepriv->dvbdev);
 
 	dvb_frontend_invoke_release(fe, fe->ops.release);
 
 	kfree(fepriv);
+	fe->frontend_priv = NULL;
+}
+
+static void dvb_frontend_free(struct kref *ref)
+{
+	struct dvb_frontend *fe =
+		container_of(ref, struct dvb_frontend, refcount);
+
+	__dvb_frontend_free(fe);
 }
 
 static void dvb_frontend_put(struct dvb_frontend *fe)
 {
-	kref_put(&fe->refcount, dvb_frontend_free);
+	/*
+	 * Check if the frontend was registered, as otherwise
+	 * kref was not initialized yet.
+	 */
+	if (fe->frontend_priv)
+		kref_put(&fe->refcount, dvb_frontend_free);
+	else
+		__dvb_frontend_free(fe);
 }
 
 static void dvb_frontend_get(struct dvb_frontend *fe)
-- 
2.13.5
