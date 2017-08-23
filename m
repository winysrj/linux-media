Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60384 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbdHWVUM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 17:20:12 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [RFC 1/3] dvb_frontend: Rename the dvb_frontend_init() function
Date: Thu, 24 Aug 2017 00:20:37 +0300
Message-Id: <20170823212039.27751-2-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170823212039.27751-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170823212039.27751-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need the dvb_frontend_init() name for a new function that will
initialize a frontend structure. Rename the existing function.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index e3fff8f64d37..f8caedc83d70 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -309,7 +309,7 @@ static void dvb_frontend_clear_events(struct dvb_frontend *fe)
 	mutex_unlock(&events->mtx);
 }
 
-static void dvb_frontend_init(struct dvb_frontend *fe)
+static void dvb_frontend_initialise(struct dvb_frontend *fe)
 {
 	dev_dbg(fe->dvb->device,
 			"%s: initialising adapter %i frontend %i (%s)...\n",
@@ -645,7 +645,7 @@ static int dvb_frontend_thread(void *data)
 	fepriv->wakeup = 0;
 	fepriv->reinitialise = 0;
 
-	dvb_frontend_init(fe);
+	dvb_frontend_initialise(fe);
 
 	set_freezable();
 	while (1) {
@@ -671,7 +671,7 @@ static int dvb_frontend_thread(void *data)
 			break;
 
 		if (fepriv->reinitialise) {
-			dvb_frontend_init(fe);
+			dvb_frontend_initialise(fe);
 			if (fe->ops.set_tone && fepriv->tone != -1)
 				fe->ops.set_tone(fe, fepriv->tone);
 			if (fe->ops.set_voltage && fepriv->voltage != -1)
-- 
Regards,

Laurent Pinchart
