Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60541 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbcGQRHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 13:07:17 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 02/15] [media] doc-rst: move DVB introduction to a separate file
Date: Sun, 17 Jul 2016 14:06:57 -0300
Message-Id: <f8cd359895450f15c235b05ac3d697360d0734ba.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of keeping the introduction together with the
index, move it to a separate file, and add it via toctree
at the index.

The information there are outdated, so update it to point
to the right links.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/index.rst | 71 +++++++------------------------
 Documentation/media/dvb-drivers/intro.rst | 21 +++++++++
 2 files changed, 36 insertions(+), 56 deletions(-)
 create mode 100644 Documentation/media/dvb-drivers/intro.rst

diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index 89965041a266..6ec5549d2f07 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -1,62 +1,21 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. include:: <isonum.txt>
+
+#############################################
 Linux Digital Video Broadcast (DVB) subsystem
-=============================================
+#############################################
 
-The main development site and CVS repository for these
-drivers is https://linuxtv.org.
+**Copyright** |copy| 2001-2016 : LinuxTV Developers
 
-The developer mailing list linux-dvb is also hosted there,
-see https://linuxtv.org/lists.php. Please check
-the archive https://linuxtv.org/pipermail/linux-dvb/
-and the Wiki https://linuxtv.org/wiki/
-before asking newbie questions on the list.
+Permission is granted to copy, distribute and/or modify this document
+under the terms of the GNU Free Documentation License, Version 1.1 or
+any later version published by the Free Software Foundation. A copy of
+the license is included in the chapter entitled "GNU Free Documentation
+License".
 
-API documentation, utilities and test/example programs
-are available as part of the old driver package for Linux 2.4
-(linuxtv-dvb-1.0.x.tar.gz), or from CVS (module DVB).
-We plan to split this into separate packages, but it's not
-been done yet.
 
-https://linuxtv.org/downloads/
+.. toctree::
+	:maxdepth: 5
 
-What's inside this directory:
-
-"avermedia.txt"
-contains detailed information about the
-Avermedia DVB-T cards. See also "bt8xx.txt".
-
-"bt8xx.txt"
-contains detailed information about the
-various bt8xx based "budget" DVB cards.
-
-"cards.txt"
-contains a list of supported hardware.
-
-"ci.txt"
-contains detailed information about the
-CI module as part from TwinHan cards and Clones.
-
-"contributors.txt"
-is the who-is-who of DVB development.
-
-"faq.txt"
-contains frequently asked questions and their answers.
-
-"get_dvb_firmware"
-script to download and extract firmware for those devices
-that require it.
-
-"ttusb-dec.txt"
-contains detailed information about the
-TT DEC2000/DEC3000 USB DVB hardware.
-
-"udev.txt"
-how to get DVB and udev up and running.
-
-"README.dvb-usb"
-contains detailed information about the DVB USB cards.
-
-"README.flexcop"
-contains detailed information about the
-Technisat- and Flexcop B2C2 drivers.
-
-Good luck and have fun!
+	intro
diff --git a/Documentation/media/dvb-drivers/intro.rst b/Documentation/media/dvb-drivers/intro.rst
new file mode 100644
index 000000000000..7681835ea76d
--- /dev/null
+++ b/Documentation/media/dvb-drivers/intro.rst
@@ -0,0 +1,21 @@
+Introdution
+===========
+
+The main development site and GIT repository for these
+drivers is https://linuxtv.org.
+
+The DVB mailing list linux-dvb is hosted at vger. Please see
+http://vger.kernel.org/vger-lists.html#linux-media for details.
+
+There are also some other old lists hosted at https://linuxtv.org/lists.php. Please check the archive https://linuxtv.org/pipermail/linux-dvb/.
+
+The media subsystem Wiki is hosted at https://linuxtv.org/wiki/.
+Please check it before asking newbie questions on the list.
+
+API documentation is documented at the Kernel. You'll also find useful
+documentation at: https://linuxtv.org/docs.php.
+
+You may also find useful material at https://linuxtv.org/downloads/.
+
+In order to get firmware from proprietary drivers, there's a script at
+the kernel tree, at scripts/get_dvb_firmware.
-- 
2.7.4

