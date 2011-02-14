Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:21349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab1BNVLl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:11:41 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1ELBf5m029342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:11:41 -0500
Received: from pedra (vpn-239-121.phx2.redhat.com [10.3.239.121])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1EL3TGB012908
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:11:40 -0500
Date: Mon, 14 Feb 2011 19:03:18 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 11/14] [media] tuner-core: Don't use a static var for
 xc5000_cfg
Message-ID: <20110214190318.423d6693@pedra>
In-Reply-To: <cover.1297716906.git.mchehab@redhat.com>
References: <cover.1297716906.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

A static var is evil, especially if a device has two boards with
xc5000. Instead, just like the other drivers, use stack to store
its config during setup.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 70ff416..16939ca 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -66,7 +66,6 @@ module_param_string(ntsc, ntsc, sizeof(ntsc), 0644);
  * Static vars
  */
 
-static struct xc5000_config xc5000_cfg;
 static LIST_HEAD(tuner_list);
 
 /*
@@ -338,9 +337,12 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		break;
 	case TUNER_XC5000:
 	{
-		xc5000_cfg.i2c_address	  = t->i2c->addr;
-		/* if_khz will be set when the digital dvb_attach() occurs */
-		xc5000_cfg.if_khz	  = 0;
+		struct xc5000_config xc5000_cfg = {
+			.i2c_address = t->i2c->addr,
+			/* if_khz will be set at dvb_attach() */
+			.if_khz	  = 0,
+		};
+
 		if (!dvb_attach(xc5000_attach,
 				&t->fe, t->i2c->adapter, &xc5000_cfg))
 			goto attach_failed;
-- 
1.7.1


