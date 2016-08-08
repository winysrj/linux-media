Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:52564 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbcHHNPZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Aug 2016 09:15:25 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/3] doc-rst: add stand-alone conf.py to media folder
Date: Mon,  8 Aug 2016 15:14:59 +0200
Message-Id: <1470662100-6927-3-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1470662100-6927-1-git-send-email-markus.heiser@darmarit.de>
References: <1470662100-6927-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

With the media/conf.py, the media folder can be build and distributed
stand-alone. BTW fixed python indentation in media/conf_nitpick.py.
Python indentation is 4 spaces [1] and Python 3 disallows mixing the use
of tabs and spaces for indentation.

[1] https://www.python.org/dev/peps/pep-0008/#indentation
[2] https://www.python.org/dev/peps/pep-0008/#tabs-or-spaces

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/media/conf.py         |   3 +
 Documentation/media/conf_nitpick.py | 150 +++++++++++++++++++-----------------
 2 files changed, 81 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/media/conf.py

diff --git a/Documentation/media/conf.py b/Documentation/media/conf.py
new file mode 100644
index 0000000..62bdba2
--- /dev/null
+++ b/Documentation/media/conf.py
@@ -0,0 +1,3 @@
+# -*- coding: utf-8; mode: python -*-
+
+project = 'Linux Media Subsystem Documentation'
diff --git a/Documentation/media/conf_nitpick.py b/Documentation/media/conf_nitpick.py
index 9034d7f..e794e3d 100644
--- a/Documentation/media/conf_nitpick.py
+++ b/Documentation/media/conf_nitpick.py
@@ -1,4 +1,10 @@
-nitpicky=True
+# -*- coding: utf-8; mode: python -*-
+
+project = 'Linux Media Subsystem Documentation'
+# within nit-picking build, do not refer to any intersphinx object
+intersphinx_mapping = {}
+
+nitpicky = True
 
 # It is possible to run Sphinx in nickpick mode with:
 #	make SPHINXOPTS=-n htmldocs
@@ -10,76 +16,76 @@ nitpicky=True
 # The list below has a list of such symbols to be ignored in nitpick mode
 #
 nitpick_ignore = [
-	("c:func", "clock_gettime"),
-	("c:func", "close"),
-	("c:func", "container_of"),
-	("c:func", "determine_valid_ioctls"),
-	("c:func", "ERR_PTR"),
-	("c:func", "ioctl"),
-	("c:func", "IS_ERR"),
-	("c:func", "mmap"),
-	("c:func", "open"),
-	("c:func", "pci_name"),
-	("c:func", "poll"),
-	("c:func", "PTR_ERR"),
-	("c:func", "read"),
-	("c:func", "release"),
-	("c:func", "set"),
-	("c:func", "struct fd_set"),
-	("c:func", "struct pollfd"),
-	("c:func", "usb_make_path"),
-	("c:func", "write"),
-	("c:type", "atomic_t"),
-	("c:type", "bool"),
-	("c:type", "buf_queue"),
-	("c:type", "device"),
-	("c:type", "device_driver"),
-	("c:type", "device_node"),
-	("c:type", "enum"),
-	("c:type", "file"),
-	("c:type", "i2c_adapter"),
-	("c:type", "i2c_board_info"),
-	("c:type", "i2c_client"),
-	("c:type", "ktime_t"),
-	("c:type", "led_classdev_flash"),
-	("c:type", "list_head"),
-	("c:type", "lock_class_key"),
-	("c:type", "module"),
-	("c:type", "mutex"),
-	("c:type", "pci_dev"),
-	("c:type", "pdvbdev"),
-	("c:type", "poll_table_struct"),
-	("c:type", "s32"),
-	("c:type", "s64"),
-	("c:type", "sd"),
-	("c:type", "spi_board_info"),
-	("c:type", "spi_device"),
-	("c:type", "spi_master"),
-	("c:type", "struct fb_fix_screeninfo"),
-	("c:type", "struct pollfd"),
-	("c:type", "struct timeval"),
-	("c:type", "struct video_capability"),
-	("c:type", "u16"),
-	("c:type", "u32"),
-	("c:type", "u64"),
-	("c:type", "u8"),
-	("c:type", "union"),
-	("c:type", "usb_device"),
+    ("c:func", "clock_gettime"),
+    ("c:func", "close"),
+    ("c:func", "container_of"),
+    ("c:func", "determine_valid_ioctls"),
+    ("c:func", "ERR_PTR"),
+    ("c:func", "ioctl"),
+    ("c:func", "IS_ERR"),
+    ("c:func", "mmap"),
+    ("c:func", "open"),
+    ("c:func", "pci_name"),
+    ("c:func", "poll"),
+    ("c:func", "PTR_ERR"),
+    ("c:func", "read"),
+    ("c:func", "release"),
+    ("c:func", "set"),
+    ("c:func", "struct fd_set"),
+    ("c:func", "struct pollfd"),
+    ("c:func", "usb_make_path"),
+    ("c:func", "write"),
+    ("c:type", "atomic_t"),
+    ("c:type", "bool"),
+    ("c:type", "buf_queue"),
+    ("c:type", "device"),
+    ("c:type", "device_driver"),
+    ("c:type", "device_node"),
+    ("c:type", "enum"),
+    ("c:type", "file"),
+    ("c:type", "i2c_adapter"),
+    ("c:type", "i2c_board_info"),
+    ("c:type", "i2c_client"),
+    ("c:type", "ktime_t"),
+    ("c:type", "led_classdev_flash"),
+    ("c:type", "list_head"),
+    ("c:type", "lock_class_key"),
+    ("c:type", "module"),
+    ("c:type", "mutex"),
+    ("c:type", "pci_dev"),
+    ("c:type", "pdvbdev"),
+    ("c:type", "poll_table_struct"),
+    ("c:type", "s32"),
+    ("c:type", "s64"),
+    ("c:type", "sd"),
+    ("c:type", "spi_board_info"),
+    ("c:type", "spi_device"),
+    ("c:type", "spi_master"),
+    ("c:type", "struct fb_fix_screeninfo"),
+    ("c:type", "struct pollfd"),
+    ("c:type", "struct timeval"),
+    ("c:type", "struct video_capability"),
+    ("c:type", "u16"),
+    ("c:type", "u32"),
+    ("c:type", "u64"),
+    ("c:type", "u8"),
+    ("c:type", "union"),
+    ("c:type", "usb_device"),
 
-	("cpp:type", "boolean"),
-	("cpp:type", "fd"),
-	("cpp:type", "fd_set"),
-	("cpp:type", "int16_t"),
-	("cpp:type", "NULL"),
-	("cpp:type", "off_t"),
-	("cpp:type", "pollfd"),
-	("cpp:type", "size_t"),
-	("cpp:type", "ssize_t"),
-	("cpp:type", "timeval"),
-	("cpp:type", "__u16"),
-	("cpp:type", "__u32"),
-	("cpp:type", "__u64"),
-	("cpp:type", "uint16_t"),
-	("cpp:type", "uint32_t"),
-	("cpp:type", "video_system_t"),
+    ("cpp:type", "boolean"),
+    ("cpp:type", "fd"),
+    ("cpp:type", "fd_set"),
+    ("cpp:type", "int16_t"),
+    ("cpp:type", "NULL"),
+    ("cpp:type", "off_t"),
+    ("cpp:type", "pollfd"),
+    ("cpp:type", "size_t"),
+    ("cpp:type", "ssize_t"),
+    ("cpp:type", "timeval"),
+    ("cpp:type", "__u16"),
+    ("cpp:type", "__u32"),
+    ("cpp:type", "__u64"),
+    ("cpp:type", "uint16_t"),
+    ("cpp:type", "uint32_t"),
+    ("cpp:type", "video_system_t"),
 ]
-- 
2.7.4

