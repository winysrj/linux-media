Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbcGHNEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 13/54] doc-rst: dvbapi: Fix conversion issues
Date: Fri,  8 Jul 2016 10:03:05 -0300
Message-Id: <32b37440dd3dc40bf8d9e1cf7742247367d86479.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion of this file didn't happen too well. We want
the items numbered, and format it just like what we did with
part 1 of the document.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/dvb/dvbapi.rst | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/dvbapi.rst b/Documentation/linux_tv/media/dvb/dvbapi.rst
index ad800404ae9f..3a7d39e98fa3 100644
--- a/Documentation/linux_tv/media/dvb/dvbapi.rst
+++ b/Documentation/linux_tv/media/dvb/dvbapi.rst
@@ -12,6 +12,7 @@ LINUX DVB API
 
 .. toctree::
     :maxdepth: 1
+    :numbered:
 
     intro
     frontend
@@ -32,28 +33,34 @@ LINUX DVB API
 Revision and Copyright
 **********************
 
+Authors:
 
-:author:    Metzler Ralph (*J. K.*)
-:address:   rjkm@metzlerbros.de
+- J. K. Metzler, Ralph <rjkm@metzlerbros.de>
 
-:author:    Metzler Marcus (*O. C.*)
-:address:   rjkm@metzlerbros.de
+ - Original author of the DVB API documentation.
 
-:author:    Chehab Mauro (*Carvalho*)
-:address:   m.chehab@samsung.com
-:contrib:   Ported document to Docbook XML.
+- O. C. Metzler, Marcus <rjkm@metzlerbros.de>
 
-**Copyright** |copy| 2002, 2003 : Convergence GmbH
+ - Original author of the DVB API documentation.
+
+- Carvalho Chehab, Mauro <m.chehab@kernel.org>
+
+ - Ported document to Docbook XML, addition of DVBv5 API, documentation gaps fix.
+
+**Copyright** |copy| 2002-2003 : Convergence GmbH
 
 **Copyright** |copy| 2009-2016 : Mauro Carvalho Chehab
 
+****************
+Revision History
+****************
+
 :revision: 2.1.0 / 2015-05-29 (*mcc*)
 
 DocBook improvements and cleanups, in order to document the system calls
 on a more standard way and provide more description about the current
 DVB API.
 
-
 :revision: 2.0.4 / 2011-05-06 (*mcc*)
 
 Add more information about DVB APIv5, better describing the frontend
-- 
2.7.4

