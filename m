Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38669 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbcGEBb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 18/41] Documentation: linux_tv: move MC stuff to a separate dir
Date: Mon,  4 Jul 2016 22:30:53 -0300
Message-Id: <7fa745b26ef1ee9f6a46790b5ba60e312d08da20.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When we wrote the media controller's section, we re-used the
V4L, just because we were lazy to create a brand new DocBook.

Yet, it is a little ackward to have it mixed with V4L. So,
move it to its own directory, in order to have it better
organized.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/index.rst                                        | 2 +-
 .../linux_tv/media/{v4l => mediactl}/media-controller-intro.rst         | 0
 .../linux_tv/media/{v4l => mediactl}/media-controller-model.rst         | 0
 Documentation/linux_tv/media/{v4l => mediactl}/media-controller.rst     | 0
 Documentation/linux_tv/media/{v4l => mediactl}/media-func-close.rst     | 0
 Documentation/linux_tv/media/{v4l => mediactl}/media-func-ioctl.rst     | 0
 Documentation/linux_tv/media/{v4l => mediactl}/media-func-open.rst      | 0
 .../linux_tv/media/{v4l => mediactl}/media-ioc-device-info.rst          | 0
 .../linux_tv/media/{v4l => mediactl}/media-ioc-enum-entities.rst        | 0
 Documentation/linux_tv/media/{v4l => mediactl}/media-ioc-enum-links.rst | 0
 Documentation/linux_tv/media/{v4l => mediactl}/media-ioc-g-topology.rst | 0
 Documentation/linux_tv/media/{v4l => mediactl}/media-ioc-setup-link.rst | 0
 Documentation/linux_tv/media/{v4l => mediactl}/media-types.rst          | 0
 13 files changed, 1 insertion(+), 1 deletion(-)
 rename Documentation/linux_tv/media/{v4l => mediactl}/media-controller-intro.rst (100%)
 rename Documentation/linux_tv/media/{v4l => mediactl}/media-controller-model.rst (100%)
 rename Documentation/linux_tv/media/{v4l => mediactl}/media-controller.rst (100%)
 rename Documentation/linux_tv/media/{v4l => mediactl}/media-func-close.rst (100%)
 rename Documentation/linux_tv/media/{v4l => mediactl}/media-func-ioctl.rst (100%)
 rename Documentation/linux_tv/media/{v4l => mediactl}/media-func-open.rst (100%)
 rename Documentation/linux_tv/media/{v4l => mediactl}/media-ioc-device-info.rst (100%)
 rename Documentation/linux_tv/media/{v4l => mediactl}/media-ioc-enum-entities.rst (100%)
 rename Documentation/linux_tv/media/{v4l => mediactl}/media-ioc-enum-links.rst (100%)
 rename Documentation/linux_tv/media/{v4l => mediactl}/media-ioc-g-topology.rst (100%)
 rename Documentation/linux_tv/media/{v4l => mediactl}/media-ioc-setup-link.rst (100%)
 rename Documentation/linux_tv/media/{v4l => mediactl}/media-types.rst (100%)

diff --git a/Documentation/linux_tv/index.rst b/Documentation/linux_tv/index.rst
index d3a243c86ba7..91c4ce570cb9 100644
--- a/Documentation/linux_tv/index.rst
+++ b/Documentation/linux_tv/index.rst
@@ -71,7 +71,7 @@ etc, please mail to:
     media/v4l/v4l2
     media/dvb/dvbapi
     media/rc/remote_controllers
-    media/v4l/media-controller
+    media/mediactl/media-controller
     media/v4l/gen-errors
     media/v4l/fdl-appendix
 
diff --git a/Documentation/linux_tv/media/v4l/media-controller-intro.rst b/Documentation/linux_tv/media/mediactl/media-controller-intro.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/media-controller-intro.rst
rename to Documentation/linux_tv/media/mediactl/media-controller-intro.rst
diff --git a/Documentation/linux_tv/media/v4l/media-controller-model.rst b/Documentation/linux_tv/media/mediactl/media-controller-model.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/media-controller-model.rst
rename to Documentation/linux_tv/media/mediactl/media-controller-model.rst
diff --git a/Documentation/linux_tv/media/v4l/media-controller.rst b/Documentation/linux_tv/media/mediactl/media-controller.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/media-controller.rst
rename to Documentation/linux_tv/media/mediactl/media-controller.rst
diff --git a/Documentation/linux_tv/media/v4l/media-func-close.rst b/Documentation/linux_tv/media/mediactl/media-func-close.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/media-func-close.rst
rename to Documentation/linux_tv/media/mediactl/media-func-close.rst
diff --git a/Documentation/linux_tv/media/v4l/media-func-ioctl.rst b/Documentation/linux_tv/media/mediactl/media-func-ioctl.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/media-func-ioctl.rst
rename to Documentation/linux_tv/media/mediactl/media-func-ioctl.rst
diff --git a/Documentation/linux_tv/media/v4l/media-func-open.rst b/Documentation/linux_tv/media/mediactl/media-func-open.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/media-func-open.rst
rename to Documentation/linux_tv/media/mediactl/media-func-open.rst
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-device-info.rst b/Documentation/linux_tv/media/mediactl/media-ioc-device-info.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/media-ioc-device-info.rst
rename to Documentation/linux_tv/media/mediactl/media-ioc-device-info.rst
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst b/Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/media-ioc-enum-entities.rst
rename to Documentation/linux_tv/media/mediactl/media-ioc-enum-entities.rst
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst b/Documentation/linux_tv/media/mediactl/media-ioc-enum-links.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/media-ioc-enum-links.rst
rename to Documentation/linux_tv/media/mediactl/media-ioc-enum-links.rst
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-g-topology.rst b/Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/media-ioc-g-topology.rst
rename to Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst
diff --git a/Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst b/Documentation/linux_tv/media/mediactl/media-ioc-setup-link.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/media-ioc-setup-link.rst
rename to Documentation/linux_tv/media/mediactl/media-ioc-setup-link.rst
diff --git a/Documentation/linux_tv/media/v4l/media-types.rst b/Documentation/linux_tv/media/mediactl/media-types.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/media-types.rst
rename to Documentation/linux_tv/media/mediactl/media-types.rst
-- 
2.7.4

