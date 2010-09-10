Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:20822 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab0IJNfT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 09:35:19 -0400
Date: Fri, 10 Sep 2010 15:35:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Steven Toth <stoth@kernellabs.com>
Subject: [PATCH 4/5] cx22702: Some things never change
Message-ID: <20100910153512.5850b9ed@hyperion.delvare>
In-Reply-To: <20100910151943.103f7423@hyperion.delvare>
References: <20100910151943.103f7423@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

The init sequence never changes so it can be marked const. Likewise,
cx22702_ops is a template and can thus be made read-only.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Steven Toth <stoth@kernellabs.com>
---
 drivers/media/dvb/frontends/cx22702.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.32-rc5.orig/drivers/media/dvb/frontends/cx22702.c	2009-10-17 14:49:50.000000000 +0200
+++ linux-2.6.32-rc5/drivers/media/dvb/frontends/cx22702.c	2009-10-18 11:44:09.000000000 +0200
@@ -54,7 +54,7 @@ MODULE_PARM_DESC(debug, "Enable verbose
 #define dprintk	if (debug) printk
 
 /* Register values to initialise the demod */
-static u8 init_tab[] = {
+static const u8 init_tab[] = {
 	0x00, 0x00, /* Stop aquisition */
 	0x0B, 0x06,
 	0x09, 0x01,
@@ -576,7 +576,7 @@ static void cx22702_release(struct dvb_f
 	kfree(state);
 }
 
-static struct dvb_frontend_ops cx22702_ops;
+static const struct dvb_frontend_ops cx22702_ops;
 
 struct dvb_frontend *cx22702_attach(const struct cx22702_config *config,
 	struct i2c_adapter *i2c)
@@ -608,7 +608,7 @@ error:
 }
 EXPORT_SYMBOL(cx22702_attach);
 
-static struct dvb_frontend_ops cx22702_ops = {
+static const struct dvb_frontend_ops cx22702_ops = {
 
 	.info = {
 		.name			= "Conexant CX22702 DVB-T",

-- 
Jean Delvare
