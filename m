Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbcGHNEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 24/54] doc-rst: gen-errors: Improve table layout
Date: Fri,  8 Jul 2016 10:03:16 -0300
Message-Id: <df94711d323118d8fb95471095b77da28446c915.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a :widths: at the flat-table, to make it to look nicer.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/gen-errors.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/linux_tv/media/gen-errors.rst b/Documentation/linux_tv/media/gen-errors.rst
index 6dc76b2461df..6cd5d26f32ab 100644
--- a/Documentation/linux_tv/media/gen-errors.rst
+++ b/Documentation/linux_tv/media/gen-errors.rst
@@ -12,6 +12,7 @@ Generic Error Codes
 .. flat-table:: Generic error codes
     :header-rows:  0
     :stub-columns: 0
+    :widths: 1 16
 
 
     -  .. row 1
-- 
2.7.4

