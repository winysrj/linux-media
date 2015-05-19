Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56464 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbbESLXx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 07:23:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jemma Denson <jdenson@gmail.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH 2/3] cx24120: declare cx24120_init() as static
Date: Tue, 19 May 2015 08:23:37 -0300
Message-Id: <4e701dc0aaf40c18c544185667224aa42e65baba.1432034614.git.mchehab@osg.samsung.com>
In-Reply-To: <8bf9e159ce96223ad404207d94e8e3742f2474de.1432034614.git.mchehab@osg.samsung.com>
References: <8bf9e159ce96223ad404207d94e8e3742f2474de.1432034614.git.mchehab@osg.samsung.com>
In-Reply-To: <8bf9e159ce96223ad404207d94e8e3742f2474de.1432034614.git.mchehab@osg.samsung.com>
References: <8bf9e159ce96223ad404207d94e8e3742f2474de.1432034614.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/cx24120.c:1182:5: warning: no previous prototype for 'cx24120_init' [-Wmissing-prototypes]
 int cx24120_init(struct dvb_frontend *fe)
     ^

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index 3ab8582e233b..2dcd93f63408 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -1179,7 +1179,7 @@ static int cx24120_set_vco(struct cx24120_state *state)
 	return cx24120_message_send(state, &cmd);
 }
 
-int cx24120_init(struct dvb_frontend *fe)
+static int cx24120_init(struct dvb_frontend *fe)
 {
 	const struct firmware *fw;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-- 
2.1.0

