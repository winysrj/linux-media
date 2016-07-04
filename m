Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44706 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbcGDLrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 01/51] Documentation: linuxt_tv: update the documentation year
Date: Mon,  4 Jul 2016 08:46:22 -0300
Message-Id: <1791aa4c33a39667902d7890b095c7651ffa7ab5.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RST version was produced in 2016. So, update it where
it was still pointing to the wrong year.

While here, added the missing (copyright) symbols.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/conf.py              | 2 +-
 Documentation/linux_tv/index.rst            | 4 +++-
 Documentation/linux_tv/media/dvb/dvbapi.rst | 6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/linux_tv/conf.py b/Documentation/linux_tv/conf.py
index 8013c921256b..ea5f6ef25d6b 100644
--- a/Documentation/linux_tv/conf.py
+++ b/Documentation/linux_tv/conf.py
@@ -25,7 +25,7 @@ kernel_doc_mode = "kernel-doc"
 # ------------------------------------------------------------------------------
 
 project   = u'LINUX MEDIA INFRASTRUCTURE API'
-copyright = u'2009-2015 : LinuxTV Developers'
+copyright = u'2009-2016 : LinuxTV Developers'
 author    = u'The LinuxTV Developers'
 
 # The version info for the project you're documenting, acts as replacement for
diff --git a/Documentation/linux_tv/index.rst b/Documentation/linux_tv/index.rst
index 42b3d4520942..e6df371243d8 100644
--- a/Documentation/linux_tv/index.rst
+++ b/Documentation/linux_tv/index.rst
@@ -1,10 +1,12 @@
 .. -*- coding: utf-8; mode: rst -*-
 
+.. include:: <isonum.txt>
+
 ##############################
 LINUX MEDIA INFRASTRUCTURE API
 ##############################
 
-**Copyright** 2009-2015 : LinuxTV Developers
+**Copyright** |copy| 2009-2016 : LinuxTV Developers
 
 Permission is granted to copy, distribute and/or modify this document
 under the terms of the GNU Free Documentation License, Version 1.1 or
diff --git a/Documentation/linux_tv/media/dvb/dvbapi.rst b/Documentation/linux_tv/media/dvb/dvbapi.rst
index 5e513ac86052..daeeb4d64917 100644
--- a/Documentation/linux_tv/media/dvb/dvbapi.rst
+++ b/Documentation/linux_tv/media/dvb/dvbapi.rst
@@ -1,5 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
+.. include:: <isonum.txt>
+
 .. _dvbapi:
 
 #############
@@ -41,9 +43,9 @@ Revision and Copyright
 :address:   m.chehab@samsung.com
 :contrib:   Ported document to Docbook XML.
 
-**Copyright** 2002, 2003 : Convergence GmbH
+**Copyright** |copy| 2002, 2003 : Convergence GmbH
 
-**Copyright** 2009-2015 : Mauro Carvalho Chehab
+**Copyright** |copy| 2009-2016 : Mauro Carvalho Chehab
 
 :revision: 2.1.0 / 2015-05-29 (*mcc*)
 
-- 
2.7.4


