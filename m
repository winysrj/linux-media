Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43787 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941741AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 04/47] [media] conf_nitpick.py: add external vars to ignore list
Date: Thu,  8 Sep 2016 09:03:26 -0300
Message-Id: <e0561fefc33674e915f1934d2012b917af44a993.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There a some other types and functions that aren't declared
inside the media document but are elsewhere. Add them to the
ignore list.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/conf_nitpick.py | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/conf_nitpick.py b/Documentation/media/conf_nitpick.py
index 227deee68c88..4de9533ce361 100644
--- a/Documentation/media/conf_nitpick.py
+++ b/Documentation/media/conf_nitpick.py
@@ -21,8 +21,11 @@ nitpick_ignore = [
     ("c:func", "clock_gettime"),
     ("c:func", "close"),
     ("c:func", "container_of"),
+    ("c:func", "copy_from_user"),
+    ("c:func", "copy_to_user"),
     ("c:func", "determine_valid_ioctls"),
     ("c:func", "ERR_PTR"),
+    ("c:func", "i2c_new_device"),
     ("c:func", "ioctl"),
     ("c:func", "IS_ERR"),
     ("c:func", "mmap"),
@@ -37,6 +40,7 @@ nitpick_ignore = [
     ("c:func", "struct pollfd"),
     ("c:func", "usb_make_path"),
     ("c:func", "write"),
+
     ("c:type", "atomic_t"),
     ("c:type", "bool"),
     ("c:type", "boolean"),
@@ -72,10 +76,10 @@ nitpick_ignore = [
     ("c:type", "spi_device"),
     ("c:type", "spi_master"),
     ("c:type", "ssize_t"),
-    ("c:type", "struct fb_fix_screeninfo"),
-    ("c:type", "struct pollfd"),
-    ("c:type", "struct timeval"),
-    ("c:type", "struct video_capability"),
+    ("c:type", "fb_fix_screeninfo"),
+    ("c:type", "pollfd"),
+    ("c:type", "timeval"),
+    ("c:type", "video_capability"),
     ("c:type", "timeval"),
     ("c:type", "__u16"),
     ("c:type", "u16"),
@@ -87,6 +91,7 @@ nitpick_ignore = [
     ("c:type", "uint16_t"),
     ("c:type", "uint32_t"),
     ("c:type", "union"),
+    ("c:type", "__user"),
     ("c:type", "usb_device"),
     ("c:type", "video_system_t"),
 ]
-- 
2.7.4


