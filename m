Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:51467 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752120AbdJKRH2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 13:07:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] media: dtv-frontend.rst fix a typo: algoritms -> algorithms
Date: Wed, 11 Oct 2017 13:07:22 -0400
Message-Id: <b2fc98fc91647e4b7ec1ac90001729345ec3e790.1507741633.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

WARNING: 'algoritms' may be misspelled - perhaps 'algorithms'?
+responsible for tuning the device. It supports multiple algoritms to

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/dtv-frontend.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/kapi/dtv-frontend.rst b/Documentation/media/kapi/dtv-frontend.rst
index 9f67b7a7387d..f1a2fdaab5ba 100644
--- a/Documentation/media/kapi/dtv-frontend.rst
+++ b/Documentation/media/kapi/dtv-frontend.rst
@@ -119,7 +119,7 @@ Satellite TV reception is::
 .. |delta|   unicode:: U+00394
 
 The ``drivers/media/dvb-core/dvb_frontend.c`` has a kernel thread with is
-responsible for tuning the device. It supports multiple algoritms to
+responsible for tuning the device. It supports multiple algorithms to
 detect a channel, as defined at enum :c:func:`dvbfe_algo`.
 
 The algorithm to be used is obtained via ``.get_frontend_algo``. If the driver
-- 
2.13.6
