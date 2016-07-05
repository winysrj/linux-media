Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38666 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbcGEBb1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 17/41] Documentation: linux_tv: move RC stuff to a separate dir
Date: Mon,  4 Jul 2016 22:30:52 -0300
Message-Id: <c1223ebdd3ff38d371b562736fc1c08906743370.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When we wrote the remote controller's section, we re-used the
V4L, just because we were lazy to create a brand new DocBook.

Yet, it is a little ackward to have it mixed with V4L. So,
move it to its own directory, in order to have it better
organized.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/index.rst                                        | 2 +-
 Documentation/linux_tv/media/{v4l => rc}/Remote_controllers_Intro.rst   | 0
 .../linux_tv/media/{v4l => rc}/Remote_controllers_table_change.rst      | 0
 Documentation/linux_tv/media/{v4l => rc}/Remote_controllers_tables.rst  | 0
 Documentation/linux_tv/media/{v4l => rc}/keytable.c.rst                 | 0
 Documentation/linux_tv/media/{v4l => rc}/lirc_dev_intro.rst             | 0
 Documentation/linux_tv/media/{v4l => rc}/lirc_device_interface.rst      | 0
 Documentation/linux_tv/media/{v4l => rc}/lirc_ioctl.rst                 | 0
 Documentation/linux_tv/media/{v4l => rc}/lirc_read.rst                  | 0
 Documentation/linux_tv/media/{v4l => rc}/lirc_write.rst                 | 0
 Documentation/linux_tv/media/{v4l => rc}/remote_controllers.rst         | 0
 .../linux_tv/media/{v4l => rc}/remote_controllers_sysfs_nodes.rst       | 0
 12 files changed, 1 insertion(+), 1 deletion(-)
 rename Documentation/linux_tv/media/{v4l => rc}/Remote_controllers_Intro.rst (100%)
 rename Documentation/linux_tv/media/{v4l => rc}/Remote_controllers_table_change.rst (100%)
 rename Documentation/linux_tv/media/{v4l => rc}/Remote_controllers_tables.rst (100%)
 rename Documentation/linux_tv/media/{v4l => rc}/keytable.c.rst (100%)
 rename Documentation/linux_tv/media/{v4l => rc}/lirc_dev_intro.rst (100%)
 rename Documentation/linux_tv/media/{v4l => rc}/lirc_device_interface.rst (100%)
 rename Documentation/linux_tv/media/{v4l => rc}/lirc_ioctl.rst (100%)
 rename Documentation/linux_tv/media/{v4l => rc}/lirc_read.rst (100%)
 rename Documentation/linux_tv/media/{v4l => rc}/lirc_write.rst (100%)
 rename Documentation/linux_tv/media/{v4l => rc}/remote_controllers.rst (100%)
 rename Documentation/linux_tv/media/{v4l => rc}/remote_controllers_sysfs_nodes.rst (100%)

diff --git a/Documentation/linux_tv/index.rst b/Documentation/linux_tv/index.rst
index 821be82dcb23..d3a243c86ba7 100644
--- a/Documentation/linux_tv/index.rst
+++ b/Documentation/linux_tv/index.rst
@@ -70,7 +70,7 @@ etc, please mail to:
 
     media/v4l/v4l2
     media/dvb/dvbapi
-    media/v4l/remote_controllers
+    media/rc/remote_controllers
     media/v4l/media-controller
     media/v4l/gen-errors
     media/v4l/fdl-appendix
diff --git a/Documentation/linux_tv/media/v4l/Remote_controllers_Intro.rst b/Documentation/linux_tv/media/rc/Remote_controllers_Intro.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/Remote_controllers_Intro.rst
rename to Documentation/linux_tv/media/rc/Remote_controllers_Intro.rst
diff --git a/Documentation/linux_tv/media/v4l/Remote_controllers_table_change.rst b/Documentation/linux_tv/media/rc/Remote_controllers_table_change.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/Remote_controllers_table_change.rst
rename to Documentation/linux_tv/media/rc/Remote_controllers_table_change.rst
diff --git a/Documentation/linux_tv/media/v4l/Remote_controllers_tables.rst b/Documentation/linux_tv/media/rc/Remote_controllers_tables.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/Remote_controllers_tables.rst
rename to Documentation/linux_tv/media/rc/Remote_controllers_tables.rst
diff --git a/Documentation/linux_tv/media/v4l/keytable.c.rst b/Documentation/linux_tv/media/rc/keytable.c.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/keytable.c.rst
rename to Documentation/linux_tv/media/rc/keytable.c.rst
diff --git a/Documentation/linux_tv/media/v4l/lirc_dev_intro.rst b/Documentation/linux_tv/media/rc/lirc_dev_intro.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/lirc_dev_intro.rst
rename to Documentation/linux_tv/media/rc/lirc_dev_intro.rst
diff --git a/Documentation/linux_tv/media/v4l/lirc_device_interface.rst b/Documentation/linux_tv/media/rc/lirc_device_interface.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/lirc_device_interface.rst
rename to Documentation/linux_tv/media/rc/lirc_device_interface.rst
diff --git a/Documentation/linux_tv/media/v4l/lirc_ioctl.rst b/Documentation/linux_tv/media/rc/lirc_ioctl.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/lirc_ioctl.rst
rename to Documentation/linux_tv/media/rc/lirc_ioctl.rst
diff --git a/Documentation/linux_tv/media/v4l/lirc_read.rst b/Documentation/linux_tv/media/rc/lirc_read.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/lirc_read.rst
rename to Documentation/linux_tv/media/rc/lirc_read.rst
diff --git a/Documentation/linux_tv/media/v4l/lirc_write.rst b/Documentation/linux_tv/media/rc/lirc_write.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/lirc_write.rst
rename to Documentation/linux_tv/media/rc/lirc_write.rst
diff --git a/Documentation/linux_tv/media/v4l/remote_controllers.rst b/Documentation/linux_tv/media/rc/remote_controllers.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/remote_controllers.rst
rename to Documentation/linux_tv/media/rc/remote_controllers.rst
diff --git a/Documentation/linux_tv/media/v4l/remote_controllers_sysfs_nodes.rst b/Documentation/linux_tv/media/rc/remote_controllers_sysfs_nodes.rst
similarity index 100%
rename from Documentation/linux_tv/media/v4l/remote_controllers_sysfs_nodes.rst
rename to Documentation/linux_tv/media/rc/remote_controllers_sysfs_nodes.rst
-- 
2.7.4

