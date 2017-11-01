Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63109 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751525AbdKAMzQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 08:55:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Songjun Wu <songjun.wu@microchip.com>
Subject: [PATCH 01/14] media: atmel-isc: avoid returning a random value at isc_parse_dt()
Date: Wed,  1 Nov 2017 08:54:58 -0400
Message-Id: <3fdb933a333f0a2b8a4707ccea9c47e865c72233.1509540861.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
drivers/media/platform/atmel/atmel-isc.c:2097 isc_parse_dt() error: uninitialized symbol 'ret'.

The problem here is that of_graph_get_next_endpoint() can
potentially return NULL on its first pass, with would make
it return a random value, as ret is not initialized.

While here, use while(1) instead of for(; ;), as while is
the preferred syntax for such kind of loops.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/atmel/atmel-isc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 13f1c1c797b0..0c2635647f69 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -2039,10 +2039,10 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 
 	INIT_LIST_HEAD(&isc->subdev_entities);
 
-	for (; ;) {
+	while (1) {
 		epn = of_graph_get_next_endpoint(np, epn);
 		if (!epn)
-			break;
+			return 0;
 
 		rem = of_graph_get_remote_port_parent(epn);
 		if (!rem) {
-- 
2.13.6
