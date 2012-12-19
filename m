Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab2LSPB3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Dec 2012 10:01:29 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qBJF1Tq1001217
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 19 Dec 2012 10:01:29 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] DocBook: fix an index reference
Date: Wed, 19 Dec 2012 13:01:05 -0200
Message-Id: <1355929265-15606-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Error: no ID for constraint linkend: V4L2-PIX-FMT-NV12MT-16X16.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/v4l/pixfmt-nv12m.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml b/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
index a990b34..f3a3d45 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-nv12m.xml
@@ -6,7 +6,7 @@
       <refnamediv>
 	<refname id="V4L2-PIX-FMT-NV12M"><constant>V4L2_PIX_FMT_NV12M</constant></refname>
 	<refname id="V4L2-PIX-FMT-NV21M"><constant>V4L2_PIX_FMT_NV21M</constant></refname>
-	<refname id="V4L2-PIX-FMT-NV12MT_16X16"><constant>V4L2_PIX_FMT_NV12MT_16X16</constant></refname>
+	<refname id="V4L2-PIX-FMT-NV12MT-16X16"><constant>V4L2_PIX_FMT_NV12MT_16X16</constant></refname>
 	<refpurpose>Variation of <constant>V4L2_PIX_FMT_NV12</constant> and <constant>V4L2_PIX_FMT_NV21</constant> with planes
 	  non contiguous in memory. </refpurpose>
       </refnamediv>
-- 
1.7.11.7

