Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38726 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbcGEBb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 20/41] Documentation: linux_tv: Fix a warning at lirc_dev_intro.rst
Date: Mon,  4 Jul 2016 22:30:55 -0300
Message-Id: <3c70d4f9d033f4d9ff9fe47c9012c0cd07d7395f.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documentation/linux_tv/media/rc/lirc_dev_intro.rst:17: WARNING: Inline substitution_reference start-string without end-string.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/rc/lirc_dev_intro.rst | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/linux_tv/media/rc/lirc_dev_intro.rst b/Documentation/linux_tv/media/rc/lirc_dev_intro.rst
index 520660114f99..9a784c8fe4ea 100644
--- a/Documentation/linux_tv/media/rc/lirc_dev_intro.rst
+++ b/Documentation/linux_tv/media/rc/lirc_dev_intro.rst
@@ -14,15 +14,15 @@ IR data to and fro, the essential fops are read, write and ioctl.
 
 Example dmesg output upon a driver registering w/LIRC:
 
+.. code-block:: none
+
     $ dmesg |grep lirc_dev
-
     lirc_dev: IR Remote Control driver registered, major 248
-
-    rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor
-    = 0
+    rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
 
 What you should see for a chardev:
 
+.. code-block:: none
+
     $ ls -l /dev/lirc*
-
     crw-rw---- 1 root root 248, 0 Jul 2 22:20 /dev/lirc0
-- 
2.7.4

