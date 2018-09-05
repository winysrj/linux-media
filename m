Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51133 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbeIEOab (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2018 10:30:31 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jacopo Mondi <jacopo@jmondi.org>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH v2 4/4] MAINTAINERS: add entry for i.MX PXP media mem2mem driver
Date: Wed,  5 Sep 2018 12:00:18 +0200
Message-Id: <20180905100018.27556-5-p.zabel@pengutronix.de>
In-Reply-To: <20180905100018.27556-1-p.zabel@pengutronix.de>
References: <20180905100018.27556-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a5b256b25905..2e23c644f5d3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8994,6 +8994,13 @@ F:	drivers/staging/media/imx/
 F:	include/linux/imx-media.h
 F:	include/media/imx.h
 
+MEDIA DRIVER FOR FREESCALE IMX PXP
+M:	Philipp Zabel <p.zabel@pengutronix.de>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/platform/imx-pxp.[ch]
+
 MEDIA DRIVERS FOR HELENE
 M:	Abylay Ospan <aospan@netup.ru>
 L:	linux-media@vger.kernel.org
-- 
2.18.0
