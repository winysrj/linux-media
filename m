Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41425 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbcGHNEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 25/54] doc-rst: remote_controllers: fix conversion issues
Date: Fri,  8 Jul 2016 10:03:17 -0300
Message-Id: <1c719e648d7f1162906747bc90fbc1b9051c95d1.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make it look like V4L, DVB and MC docbooks initial page.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/rc/remote_controllers.rst | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/Documentation/linux_tv/media/rc/remote_controllers.rst b/Documentation/linux_tv/media/rc/remote_controllers.rst
index 4b36e992f59a..bccceb1e28c3 100644
--- a/Documentation/linux_tv/media/rc/remote_controllers.rst
+++ b/Documentation/linux_tv/media/rc/remote_controllers.rst
@@ -1,5 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
+.. include:: <isonum.txt>
+
 .. _remotes:
 
 #####################
@@ -15,6 +17,7 @@ Remote Controllers
 
 .. toctree::
     :maxdepth: 1
+    :numbered:
 
     Remote_controllers_Intro
     remote_controllers_sysfs_nodes
@@ -27,12 +30,17 @@ Remote Controllers
 Revision and Copyright
 **********************
 
+Authors:
 
-:author:    Chehab Mauro (*Carvalho*)
-:address:   m.chehab@samsung.com
-:contrib:   Initial version.
+- Carvalho Chehab, Mauro <mchehab@kernel.org>
 
-**Copyright** 2009-2014 : Mauro Carvalho Chehab
+ - Initial version.
+
+**Copyright** |copy| 2009-2016 : Mauro Carvalho Chehab
+
+****************
+Revision History
+****************
 
 :revision: 3.15 / 2014-02-06 (*mcc*)
 
-- 
2.7.4

