Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41493 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbcGHNEG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 19/54] doc-rst: media-controller.rst: add missing copy symbol
Date: Fri,  8 Jul 2016 10:03:11 -0300
Message-Id: <9336831ec4688c0ef2e0b123a532030b9b2caf03.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like V4L and DVB parts, add the copyright symbol.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/mediactl/media-controller.rst | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/linux_tv/media/mediactl/media-controller.rst b/Documentation/linux_tv/media/mediactl/media-controller.rst
index 1877d68044b8..8758308997a7 100644
--- a/Documentation/linux_tv/media/mediactl/media-controller.rst
+++ b/Documentation/linux_tv/media/mediactl/media-controller.rst
@@ -1,5 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
+.. include:: <isonum.txt>
+
 .. _media_common:
 
 ####################
@@ -56,8 +58,9 @@ Authors:
 
  - MEDIA_IOC_G_TOPOLOGY documentation and documentation improvements.
 
-**Copyright** 2010 : Laurent Pinchart
-**Copyright** 2015-2016 : Mauro Carvalho Chehab
+**Copyright** |copy| 2010 : Laurent Pinchart
+
+**Copyright** |copy| 2015-2016 : Mauro Carvalho Chehab
 
 ****************
 Revision History
-- 
2.7.4

