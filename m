Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:57425 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbbJPUbN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 16:31:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Kozlov Sergey <serjk@netup.ru>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] [media] horus3a: fix horus3a_attach inline wrapper
Date: Fri, 16 Oct 2015 22:30:59 +0200
Message-ID: <7188906.Hi9qi0FZQC@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 'static inline' version of horus3a_attach() is incorrectly
copied from another file, which results in a build error when
CONFIG_DVB_HORUS3A is disabled:

In file included from /git/arm-soc/drivers/media/pci/netup_unidvb/netup_unidvb_core.c:34:0:
media/dvb-frontends/horus3a.h:51:13: warning: 'struct cxd2820r_config' declared inside parameter list
media/dvb-frontends/horus3a.h:51:13: warning: its scope is only this definition or declaration, which is probably not what you want
media/pci/netup_unidvb/netup_unidvb_core.c: In function 'netup_unidvb_dvb_init':
media/pci/netup_unidvb/netup_unidvb_core.c:417:279: warning: passing argument 1 of '__a' from incompatible pointer type [-Wincompatible-pointer-types]
media/pci/netup_unidvb/netup_unidvb_core.c:417:279: note: expected 'const struct cxd2820r_config *' but argument is of type 'struct dvb_frontend *'
media/pci/netup_unidvb/netup_unidvb_core.c:417:298: warning: passing argument 2 of '__a' from incompatible pointer type [-Wincompatible-pointer-types]
media/pci/netup_unidvb/netup_unidvb_core.c:417:298: note: expected 'struct i2c_adapter *' but argument is of type 'struct horus3a_config *'
media/pci/netup_unidvb/netup_unidvb_core.c:417:275: error: too many arguments to function '__a'

This changes the code to have the correct prototype.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: a5d32b358254 ("[media] horus3a: Sony Horus3A DVB-S/S2 tuner driver")
---
Found on ARM randconfig builds

diff --git a/drivers/media/dvb-frontends/horus3a.h b/drivers/media/dvb-frontends/horus3a.h
index b055319d532e..c1e2d1834b78 100644
--- a/drivers/media/dvb-frontends/horus3a.h
+++ b/drivers/media/dvb-frontends/horus3a.h
@@ -46,8 +46,8 @@ extern struct dvb_frontend *horus3a_attach(struct dvb_frontend *fe,
 					const struct horus3a_config *config,
 					struct i2c_adapter *i2c);
 #else
-static inline struct dvb_frontend *horus3a_attach(
-					const struct cxd2820r_config *config,
+static inline struct dvb_frontend *horus3a_attach(struct dvb_frontend *fe,
+					const struct horus3a_config *config,
 					struct i2c_adapter *i2c)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);

