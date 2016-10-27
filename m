Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52312 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936187AbcJ0Nuv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 09:50:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarit.de>
Subject: [PATCH] dtv-core: get rid of duplicated kernel-doc include
Date: Thu, 27 Oct 2016 06:28:53 -0200
Message-Id: <9dde2aa82f4e27c6432d55e8ffb2d313bd04a744.1477556665.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Somehow, two DVB headers were included twice. Remove the
duplication.

Reported-by: Markus Heiser <markus.heiser@darmarit.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-core.rst | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/Documentation/media/kapi/dtv-core.rst b/Documentation/media/kapi/dtv-core.rst
index a3c4642eabfc..ff86bf0abeae 100644
--- a/Documentation/media/kapi/dtv-core.rst
+++ b/Documentation/media/kapi/dtv-core.rst
@@ -8,14 +8,6 @@ Digital TV Common functions
 
 .. kernel-doc:: drivers/media/dvb-core/dvbdev.h
 
-
-
-.. kernel-doc:: drivers/media/dvb-core/dvb_math.h
-   :export: drivers/media/dvb-core/dvb_math.c
-
-.. kernel-doc:: drivers/media/dvb-core/dvbdev.h
-   :export: drivers/media/dvb-core/dvbdev.c
-
 Digital TV Ring buffer
 ----------------------
 
-- 
2.7.4


