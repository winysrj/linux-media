Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:49937 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbcHMONe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2016 10:13:34 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 3/7] doc-rst: add media/conf_nitpick.py
Date: Sat, 13 Aug 2016 16:12:44 +0200
Message-Id: <1471097568-25990-4-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

The media/conf_nitpick.py is a *build-theme* wich uses the nit-picking
mode of sphinx. To compile only the html of 'media' with the nit-picking
build use::

  make SPHINXDIRS=media SPHINX_CONF=conf_nitpick.py htmldocs

With this, the Documentation/conf.py is read first and updated with the
configuration values from the Documentation/media/conf_nitpick.py.

The origin media/conf_nitpick.py comes from Mauro's experimental
docs-next branch::

  https://git.linuxtv.org/mchehab/experimental.git mchehab/docs-next

BTW fixed python indentation in media/conf_nitpick.py.  Python
indentation is 4 spaces [1] and Python 3 disallows mixing the use of
tabs and spaces for indentation [2].

[1] https://www.python.org/dev/peps/pep-0008/#indentation
[2] https://www.python.org/dev/peps/pep-0008/#tabs-or-spaces

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/media/conf_nitpick.py | 93 +++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)
 create mode 100644 Documentation/media/conf_nitpick.py

diff --git a/Documentation/media/conf_nitpick.py b/Documentation/media/conf_nitpick.py
new file mode 100644
index 0000000..11beac2
--- /dev/null
+++ b/Documentation/media/conf_nitpick.py
@@ -0,0 +1,93 @@
+# -*- coding: utf-8; mode: python -*-
+
+project = 'Linux Media Subsystem Documentation'
+
+# It is possible to run Sphinx in nickpick mode with:
+nitpicky = True
+
+# within nit-picking build, do not refer to any intersphinx object
+intersphinx_mapping = {}
+
+# In nickpick mode, it will complain about lots of missing references that
+#
+# 1) are just typedefs like: bool, __u32, etc;
+# 2) It will complain for things like: enum, NULL;
+# 3) It will complain for symbols that should be on different
+#    books (but currently aren't ported to ReST)
+#
+# The list below has a list of such symbols to be ignored in nitpick mode
+#
+nitpick_ignore = [
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
+
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
+]
-- 
2.7.4

