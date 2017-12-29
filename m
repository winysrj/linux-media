Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64527 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750820AbdL2NiC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 08:38:02 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/4] media: dvb_vb2: get rid of DVB_BUF_TYPE_OUTPUT
Date: Fri, 29 Dec 2017 08:37:54 -0500
Message-Id: <15128beef1ce3d48565f44756ff4a2077ac97a01.1514554610.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514554610.git.mchehab@s-opensource.com>
References: <cover.1514554610.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514554610.git.mchehab@s-opensource.com>
References: <cover.1514554610.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is currently unused. So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/dvb_vb2.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/media/dvb_vb2.h b/include/media/dvb_vb2.h
index 7a529844c5e1..ef4a802f7435 100644
--- a/include/media/dvb_vb2.h
+++ b/include/media/dvb_vb2.h
@@ -24,7 +24,6 @@
 
 enum dvb_buf_type {
 	DVB_BUF_TYPE_CAPTURE        = 1,
-	DVB_BUF_TYPE_OUTPUT         = 2,
 };
 
 #define DVB_VB2_STATE_NONE (0x0)
-- 
2.14.3
