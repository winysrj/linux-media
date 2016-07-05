Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38730 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbcGEBb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 19/41] Documentation: linux_tv: promote generic documents to the parent dir
Date: Mon,  4 Jul 2016 22:30:54 -0300
Message-Id: <79b451783cc0ab1ba962025299587628cb1e692a.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The generic error codes and licensing sections are general to the
entire media book. They should not be inside the v4l dir. So,
promote them to the parent directory.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/index.rst                        | 4 ++--
 Documentation/linux_tv/media/{v4l => }/fdl-appendix.rst | 0
 Documentation/linux_tv/media/{v4l => }/gen-errors.rst   | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename Documentation/linux_tv/media/{v4l => }/fdl-appendix.rst (100%)
 rename Documentation/linux_tv/media/{v4l => }/gen-errors.rst (100%)

diff --git a/Documentation/linux_tv/index.rst b/Documentation/linux_tv/index.rst
index 91c4ce570cb9..4815ad6fc6b9 100644
--- a/Documentation/linux_tv/index.rst
+++ b/Documentation/linux_tv/index.rst
@@ -72,8 +72,8 @@ etc, please mail to:
     media/dvb/dvbapi
     media/rc/remote_controllers
     media/mediactl/media-controller
-    media/v4l/gen-errors
-    media/v4l/fdl-appendix
+    media/gen-errors
+    media/fdl-appendix
 
 .. only:: html
 
diff --git a/Documentation/linux_tv/media/v4l/fdl-appendix.rst b/Documentation/linux_tv/media/fdl-appendix.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/fdl-appendix.rst
rename to Documentation/linux_tv/media/fdl-appendix.rst
diff --git a/Documentation/linux_tv/media/v4l/gen-errors.rst b/Documentation/linux_tv/media/gen-errors.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/gen-errors.rst
rename to Documentation/linux_tv/media/gen-errors.rst
-- 
2.7.4

