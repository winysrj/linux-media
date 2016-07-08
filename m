Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41347 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231AbcGHNEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 16/54] doc-rst: intro: remove obsolete headers
Date: Fri,  8 Jul 2016 10:03:08 -0300
Message-Id: <ea02106611311364cb6bf84693eb2475ad0c2ce5.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video, audio and OSD APIs are obsolete. V4L2 should be
used instead. So, remove them from this intro item.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/dvb/intro.rst | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/Documentation/linux_tv/media/dvb/intro.rst b/Documentation/linux_tv/media/dvb/intro.rst
index 72992940a057..b61081d00a9f 100644
--- a/Documentation/linux_tv/media/dvb/intro.rst
+++ b/Documentation/linux_tv/media/dvb/intro.rst
@@ -158,8 +158,6 @@ partial path like:
 
 .. code-block:: c
 
-	#include <linux/dvb/audio.h>
-
 	#include <linux/dvb/ca.h>
 
 	#include <linux/dvb/dmx.h>
@@ -168,9 +166,6 @@ partial path like:
 
 	#include <linux/dvb/net.h>
 
-	#include <linux/dvb/osd.h>
-
-	#include <linux/dvb/video.h>
 
 To enable applications to support different API version, an additional
 include file ``linux/dvb/version.h`` exists, which defines the constant
-- 
2.7.4

