Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46312 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbcGHVFV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 17:05:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/4] [media] doc-rst: reformat cec-api.rst
Date: Fri,  8 Jul 2016 18:05:11 -0300
Message-Id: <e972d3c87f3cc84f0d947e73d84b79a03cdabb91.1468011909.git.mchehab@s-opensource.com>
In-Reply-To: <e2460b1d579a6ea4f90cf2915da87b16b59e0082.1468011909.git.mchehab@s-opensource.com>
References: <e2460b1d579a6ea4f90cf2915da87b16b59e0082.1468011909.git.mchehab@s-opensource.com>
In-Reply-To: <e2460b1d579a6ea4f90cf2915da87b16b59e0082.1468011909.git.mchehab@s-opensource.com>
References: <e2460b1d579a6ea4f90cf2915da87b16b59e0082.1468011909.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the same format as the other parts.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/cec/cec-api.rst | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/cec/cec-api.rst b/Documentation/media/uapi/cec/cec-api.rst
index ffee32e0f906..7b7942281a60 100644
--- a/Documentation/media/uapi/cec/cec-api.rst
+++ b/Documentation/media/uapi/cec/cec-api.rst
@@ -1,5 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
+.. include:: <isonum.txt>
+
 .. _cec:
 
 #######
@@ -72,13 +74,17 @@ Function Reference
 **********************
 Revision and Copyright
 **********************
+Authors:
 
+- Verkuil, Hans <hans.verkuil@cisco.com>
 
-:author:    Verkuil Hans
-:address:   hans.verkuil@cisco.com
-:contrib:   Initial version.
+ - Initial version.
 
-**Copyright** 2016 : Hans Verkuil
+**Copyright** |copy| 2016 : Hans Verkuil
+
+****************
+Revision History
+****************
 
 :revision: 1.0.0 / 2016-03-17 (*hv*)
 
-- 
2.7.4

