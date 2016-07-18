Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45794 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbcGRB41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 04/36] [media] doc-rst: move framework docs to kAPI documentation
Date: Sun, 17 Jul 2016 22:55:47 -0300
Message-Id: <f6ebc2d341b57b233368ae8d6a0e4087e724cb10.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those documentation are part of the kAPI one. Move to the right
place.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../{video4linux/v4l2-controls.txt => media/kapi/v4l2-controls.rst}     | 0
 .../{video4linux/v4l2-framework.txt => media/kapi/v4l2-framework.rst}   | 0
 Documentation/media/media_drivers.rst                                   | 2 ++
 3 files changed, 2 insertions(+)
 rename Documentation/{video4linux/v4l2-controls.txt => media/kapi/v4l2-controls.rst} (100%)
 rename Documentation/{video4linux/v4l2-framework.txt => media/kapi/v4l2-framework.rst} (100%)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/media/kapi/v4l2-controls.rst
similarity index 100%
rename from Documentation/video4linux/v4l2-controls.txt
rename to Documentation/media/kapi/v4l2-controls.rst
diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/media/kapi/v4l2-framework.rst
similarity index 100%
rename from Documentation/video4linux/v4l2-framework.txt
rename to Documentation/media/kapi/v4l2-framework.rst
diff --git a/Documentation/media/media_drivers.rst b/Documentation/media/media_drivers.rst
index e2388f02d2b8..5941fea2607e 100644
--- a/Documentation/media/media_drivers.rst
+++ b/Documentation/media/media_drivers.rst
@@ -17,6 +17,8 @@ License".
 .. toctree::
     :maxdepth: 5
 
+    kapi/v4l2-framework
+    kapi/v4l2-controls
     kapi/v4l2-core
     kapi/dtv-core
     kapi/rc-core
-- 
2.7.4

