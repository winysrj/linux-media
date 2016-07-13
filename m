Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbcGMNxD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 09:53:03 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 2/2] [media] doc-rst: increase depth of the main index
Date: Wed, 13 Jul 2016 10:52:24 -0300
Message-Id: <4de33984f6584cbb04e0c2bea8aa5a4c8bcbd2b1.1468417933.git.mchehab@s-opensource.com>
In-Reply-To: <47e23fda1c738e648d2a5470e1dacdc62ce788a5.1468417933.git.mchehab@s-opensource.com>
References: <47e23fda1c738e648d2a5470e1dacdc62ce788a5.1468417933.git.mchehab@s-opensource.com>
In-Reply-To: <47e23fda1c738e648d2a5470e1dacdc62ce788a5.1468417933.git.mchehab@s-opensource.com>
References: <47e23fda1c738e648d2a5470e1dacdc62ce788a5.1468417933.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is useful to have an index with all the book contents somewhere,
as it makes easier to seek for something. So, increase maxdepth
to 5 for the main index at the beginning of the book.

While here, remove the genindex content, as it is bogus.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/media_uapi.rst | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
index 527c6deb1a19..5e872c8297b0 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -15,8 +15,10 @@ the license is included in the chapter entitled "GNU Free Documentation
 License".
 
 
+.. contents::
+
 .. toctree::
-    :maxdepth: 1
+    :maxdepth: 5
 
     intro
     uapi/v4l/v4l2
@@ -26,10 +28,3 @@ License".
     uapi/cec/cec-api
     uapi/gen-errors
     uapi/fdl-appendix
-
-.. only:: html
-
-  Retrieval
-  =========
-
-  * :ref:`genindex`
-- 
2.7.4

