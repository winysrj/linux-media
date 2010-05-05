Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58571 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab0EEF60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 01:58:26 -0400
Received: by fxm10 with SMTP id 10so3899754fxm.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 22:58:25 -0700 (PDT)
Date: Wed, 5 May 2010 07:58:18 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-media@vger.kernel.org
Cc: Manu Abraham <manu@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch -next] dvb/stv6110x: cleanup error handling
Message-ID: <20100505055818.GC27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "stv6110x" is NULL so we can just return directly without calling
kfree().  Also I changed the printk() to make checkpatch.pl happy.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/dvb/frontends/stv6110x.c b/drivers/media/dvb/frontends/stv6110x.c
index 2f9cd24..42591ce 100644
--- a/drivers/media/dvb/frontends/stv6110x.c
+++ b/drivers/media/dvb/frontends/stv6110x.c
@@ -363,8 +363,8 @@ struct stv6110x_devctl *stv6110x_attach(struct dvb_frontend *fe,
 	u8 default_regs[] = {0x07, 0x11, 0xdc, 0x85, 0x17, 0x01, 0xe6, 0x1e};
 
 	stv6110x = kzalloc(sizeof (struct stv6110x_state), GFP_KERNEL);
-	if (stv6110x == NULL)
-		goto error;
+	if (!stv6110x)
+		return NULL;
 
 	stv6110x->i2c		= i2c;
 	stv6110x->config	= config;
@@ -392,12 +392,8 @@ struct stv6110x_devctl *stv6110x_attach(struct dvb_frontend *fe,
 	fe->tuner_priv		= stv6110x;
 	fe->ops.tuner_ops	= stv6110x_ops;
 
-	printk("%s: Attaching STV6110x \n", __func__);
+	printk(KERN_INFO "%s: Attaching STV6110x\n", __func__);
 	return stv6110x->devctl;
-
-error:
-	kfree(stv6110x);
-	return NULL;
 }
 EXPORT_SYMBOL(stv6110x_attach);
 
