Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38062 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754366AbeCGKNm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 05:13:42 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
Subject: [PATCH 1/3] media: cxd2880: Makefile: remove an include
Date: Wed,  7 Mar 2018 05:13:34 -0500
Message-Id: <e61591875b7b626085c079499ac1c4663bfe510e.1520417613.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is not needed anymore to include the dvb-core directory,
as all the public headers that used to be there was moved
to include/media.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/cxd2880/Makefile | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cxd2880/Makefile b/drivers/media/dvb-frontends/cxd2880/Makefile
index 65a5d37f28cc..c6baa4caba19 100644
--- a/drivers/media/dvb-frontends/cxd2880/Makefile
+++ b/drivers/media/dvb-frontends/cxd2880/Makefile
@@ -15,5 +15,4 @@ cxd2880-objs := cxd2880_common.o \
 
 obj-$(CONFIG_DVB_CXD2880) += cxd2880.o
 
-ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
-- 
2.14.3
