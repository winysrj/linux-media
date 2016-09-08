Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44120 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965758AbcIHMEa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 12/47] [media] conf_nitpick.py: ignore external functions used on mediactl
Date: Thu,  8 Sep 2016 09:03:34 -0300
Message-Id: <e6dfd82177fbb9dd6fc51f74b56091039dbedd86.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some functions/macros used by the mediactl documentation
that are alien to the media subsystem. Ignore them.

After this patch, the media core will only complain about this
static function:
	Documentation/media/kapi/mc-core.rst:97: WARNING: c:func reference target not found: media_devnode_release

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/conf_nitpick.py | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/media/conf_nitpick.py b/Documentation/media/conf_nitpick.py
index 4de9533ce361..1c7928abace5 100644
--- a/Documentation/media/conf_nitpick.py
+++ b/Documentation/media/conf_nitpick.py
@@ -28,6 +28,7 @@ nitpick_ignore = [
     ("c:func", "i2c_new_device"),
     ("c:func", "ioctl"),
     ("c:func", "IS_ERR"),
+    ("c:func", "KERNEL_VERSION"),
     ("c:func", "mmap"),
     ("c:func", "open"),
     ("c:func", "pci_name"),
@@ -66,6 +67,7 @@ nitpick_ignore = [
     ("c:type", "off_t"),
     ("c:type", "pci_dev"),
     ("c:type", "pdvbdev"),
+    ("c:type", "platform_device"),
     ("c:type", "pollfd"),
     ("c:type", "poll_table_struct"),
     ("c:type", "s32"),
@@ -93,5 +95,6 @@ nitpick_ignore = [
     ("c:type", "union"),
     ("c:type", "__user"),
     ("c:type", "usb_device"),
+    ("c:type", "usb_interface"),
     ("c:type", "video_system_t"),
 ]
-- 
2.7.4


