Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41438 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbcGHNEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 23/54] doc-rst: media-ioc-enum-entities: better format the table
Date: Fri,  8 Jul 2016 10:03:15 -0300
Message-Id: <2ceb5d7bc902ac2900781e43fa92ae2fdb8e30a6.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a :widths: at the flat-table, to improve the visual.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst b/Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst
index f11c45ad7278..ae88f46b3a9e 100644
--- a/Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst
+++ b/Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst
@@ -54,6 +54,7 @@ id's until they get an error.
 .. flat-table:: struct media_entity_desc
     :header-rows:  0
     :stub-columns: 0
+    :widths: 1 1 1 1 8
 
 
     -  .. row 1
-- 
2.7.4

