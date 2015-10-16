Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:63278 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668AbbJPUcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 16:32:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Sergey Kozlov <serjk@netup.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] lnbh25: fix lnbh25_attach inline wrapper
Date: Fri, 16 Oct 2015 22:32:02 +0200
Message-ID: <10110482.QkOJ1nlAsE@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 'static inline' version of lnbh25_attach() has an incorrect
prototype which results in a build error when
CONFIG_DVB_LNBH25 is disabled:

In file included from /git/arm-soc/drivers/media/pci/netup_unidvb/netup_unidvb_core.c:36:0:
/git/arm-soc/drivers/media/dvb-frontends/lnbh25.h:46:86: error: unknown type name 'dvb_frontend'

This changes the code to have the correct prototype.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: e025273b86fb ("[media] lnbh25: LNBH25 SEC controller driver")
---
Found on ARM randconfig builds


diff --git a/drivers/media/dvb-frontends/lnbh25.h b/drivers/media/dvb-frontends/lnbh25.h
index 69f30e21f6b3..1f329ef05acc 100644
--- a/drivers/media/dvb-frontends/lnbh25.h
+++ b/drivers/media/dvb-frontends/lnbh25.h
@@ -43,7 +43,7 @@ struct dvb_frontend *lnbh25_attach(
 	struct lnbh25_config *cfg,
 	struct i2c_adapter *i2c);
 #else
-static inline dvb_frontend *lnbh25_attach(
+static inline struct dvb_frontend *lnbh25_attach(
 	struct dvb_frontend *fe,
 	struct lnbh25_config *cfg,
 	struct i2c_adapter *i2c)

