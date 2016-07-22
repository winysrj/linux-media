Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40438 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbcGVPDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 11:03:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 09/11] [media] rename v4l2-framework.rst to v4l2-intro.rst
Date: Fri, 22 Jul 2016 12:03:05 -0300
Message-Id: <1cc9d83646da31d3b13c248f6f121ef58009ac8c.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
In-Reply-To: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
References: <c2765df5223e1b389c73271397865fbf8bae100e.1469199711.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the only remaining chapters at v4l2-framework are
the introduction ones, let' s rename the file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/kapi/v4l2-core.rst                          | 2 +-
 Documentation/media/kapi/{v4l2-framework.rst => v4l2-intro.rst} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename Documentation/media/kapi/{v4l2-framework.rst => v4l2-intro.rst} (100%)

diff --git a/Documentation/media/kapi/v4l2-core.rst b/Documentation/media/kapi/v4l2-core.rst
index c69d167bce7a..6285c18978d1 100644
--- a/Documentation/media/kapi/v4l2-core.rst
+++ b/Documentation/media/kapi/v4l2-core.rst
@@ -4,7 +4,7 @@ Video2Linux devices
 .. toctree::
     :maxdepth: 1
 
-    v4l2-framework
+    v4l2-intro
     v4l2-dev
     v4l2-controls
     v4l2-device
diff --git a/Documentation/media/kapi/v4l2-framework.rst b/Documentation/media/kapi/v4l2-intro.rst
similarity index 100%
rename from Documentation/media/kapi/v4l2-framework.rst
rename to Documentation/media/kapi/v4l2-intro.rst
-- 
2.7.4

