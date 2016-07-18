Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45796 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbcGRB41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 10/36] [media] doc-rst: convert fourcc to rst format
Date: Sun, 17 Jul 2016 22:55:53 -0300
Message-Id: <00748947f92e9b8cd64a934ec8b4d0fe1eb1cd2c.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix fourcc for it to be correcly parsed by Sphinx.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/fourcc.rst | 20 +++++++++-----------
 Documentation/media/v4l-drivers/index.rst  |  1 +
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/Documentation/media/v4l-drivers/fourcc.rst b/Documentation/media/v4l-drivers/fourcc.rst
index 41241af1ebfe..f7c8cefff02a 100644
--- a/Documentation/media/v4l-drivers/fourcc.rst
+++ b/Documentation/media/v4l-drivers/fourcc.rst
@@ -8,24 +8,22 @@ other three characters depends on the first one.
 
 Existing 4CCs may not obey these guidelines.
 
-Formats
-=======
-
 Raw bayer
 ---------
 
 The following first characters are used by raw bayer formats:
 
-	B: raw bayer, uncompressed
-	b: raw bayer, DPCM compressed
-	a: A-law compressed
-	u: u-law compressed
+- B: raw bayer, uncompressed
+- b: raw bayer, DPCM compressed
+- a: A-law compressed
+- u: u-law compressed
 
 2nd character: pixel order
-	B: BGGR
-	G: GBRG
-	g: GRBG
-	R: RGGB
+
+- B: BGGR
+- G: GBRG
+- g: GRBG
+- R: RGGB
 
 3rd character: uncompressed bits-per-pixel 0--9, A--
 
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index b18c02426a40..6391f1622e26 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -18,4 +18,5 @@ License".
 .. toctree::
 	:maxdepth: 5
 
+	fourcc
 	cardlist
-- 
2.7.4

