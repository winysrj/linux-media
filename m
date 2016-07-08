Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41343 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbcGHNEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 15/54] doc-rst: dvb/intro: Better show the needed include blocks
Date: Fri,  8 Jul 2016 10:03:07 -0300
Message-Id: <534f3d0e86be4175e983b86484e591d07cc9a5a5.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The include blocks were not properly displayed. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/dvb/intro.rst | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/intro.rst b/Documentation/linux_tv/media/dvb/intro.rst
index 06b568b80f7a..72992940a057 100644
--- a/Documentation/linux_tv/media/dvb/intro.rst
+++ b/Documentation/linux_tv/media/dvb/intro.rst
@@ -160,34 +160,16 @@ partial path like:
 
 	#include <linux/dvb/audio.h>
 
-
-.. code-block:: c
-
 	#include <linux/dvb/ca.h>
 
-
-.. code-block:: c
-
 	#include <linux/dvb/dmx.h>
 
-
-.. code-block:: c
-
 	#include <linux/dvb/frontend.h>
 
-
-.. code-block:: c
-
 	#include <linux/dvb/net.h>
 
-
-.. code-block:: c
-
 	#include <linux/dvb/osd.h>
 
-
-.. code-block:: c
-
 	#include <linux/dvb/video.h>
 
 To enable applications to support different API version, an additional
-- 
2.7.4

