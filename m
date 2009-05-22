Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.sissa.it ([147.122.11.135]:53637 "EHLO smtp.sissa.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZEVQZX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 12:25:23 -0400
From: Nicola Soranzo <nsoranzo@tiscali.it>
To: Linux Media <linux-media@vger.kernel.org>
Subject: [PATCH] tuner-core: remove unused variable
Date: Fri, 22 May 2009 18:25:34 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221825.34542.nsoranzo@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trivial fix for this warning, introduced by changeset 7f2eea75118b:

/home/nicola/v4l-dvb-archive/v4l/tuner-core.c: In function 'set_type':
/home/nicola/v4l-dvb-archive/v4l/tuner-core.c:429: warning: unused variable 'xc_tuner_ops'

Priority: normal

Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>

---
diff -r 315bc4b65b4f -r 040b6da1f887 linux/drivers/media/video/tuner-core.c
--- a/linux/drivers/media/video/tuner-core.c	Sun May 17 12:28:55 2009 +0000
+++ b/linux/drivers/media/video/tuner-core.c	Fri May 22 18:11:17 2009 +0200
@@ -426,8 +426,6 @@
 		break;
 	case TUNER_XC5000:
 	{
-		struct dvb_tuner_ops *xc_tuner_ops;
-
 		xc5000_cfg.i2c_address	  = t->i2c->addr;
 		/* if_khz will be set when the digital dvb_attach() occurs */
 		xc5000_cfg.if_khz	  = 0;

