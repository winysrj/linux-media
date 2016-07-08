Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41345 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbcGHNEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 17/54] doc-rst: media-controller: fix conversion issues
Date: Fri,  8 Jul 2016 10:03:09 -0300
Message-Id: <83f9a55a22c7faaa84d6bc794dbfa96db3aa2b31.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make it look just like v4l and DVB parts.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/mediactl/media-controller.rst | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/Documentation/linux_tv/media/mediactl/media-controller.rst b/Documentation/linux_tv/media/mediactl/media-controller.rst
index 49fb76cafcab..8b8af483c5e9 100644
--- a/Documentation/linux_tv/media/mediactl/media-controller.rst
+++ b/Documentation/linux_tv/media/mediactl/media-controller.rst
@@ -15,6 +15,7 @@ Media Controller
 
 .. toctree::
     :maxdepth: 1
+    :numbered:
 
     media-controller-intro
     media-controller-model
@@ -45,13 +46,18 @@ Function Reference
 Revision and Copyright
 **********************
 
+Authors:
 
-:author:    Pinchart Laurent
-:address:   laurent.pinchart@ideasonboard.com
-:contrib:   Initial version.
+- Pinchart, Laurent <laurent.pinchart@ideasonboard.com>
+
+ - Initial version.
 
 **Copyright** 2010 : Laurent Pinchart
 
+****************
+Revision History
+****************
+
 :revision: 1.0.0 / 2010-11-10 (*lp*)
 
 Initial revision
-- 
2.7.4

