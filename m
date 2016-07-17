Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60562 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbcGQRHU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 13:07:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 14/15] [media] doc-rst: convert udev chapter to rst
Date: Sun, 17 Jul 2016 14:07:09 -0300
Message-Id: <70e8d3e999548f798108228fcbf8366652bff06f.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This chapter is outdated. I almost removed, but, as we're lacking
documentation about how to make DVB devices persistent, I opted,
instead, to keep it, and add a note about that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/index.rst |  1 +
 Documentation/media/dvb-drivers/udev.rst  | 31 +++++++++++++++++++++++--------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index dbc41950d328..14da36fe4d01 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -29,4 +29,5 @@ License".
 	opera-firmware
 	technisat
 	ttusb-dec
+	udev
 	contributors
diff --git a/Documentation/media/dvb-drivers/udev.rst b/Documentation/media/dvb-drivers/udev.rst
index 412305b7c557..7d7d5d82108a 100644
--- a/Documentation/media/dvb-drivers/udev.rst
+++ b/Documentation/media/dvb-drivers/udev.rst
@@ -1,9 +1,22 @@
+UDEV rules for DVB
+==================
+
+.. note::
+
+   #) This documentation is outdated. Udev on modern distributions auto-detect
+      the DVB devices.
+
+   #) **TODO:** change this document to explain how to make DVB devices
+      persistent, as, when a machine has multiple devices, they may be detected
+      on different orders, which could cause apps that relies on the device
+      numbers to fail.
+
 The DVB subsystem currently registers to the sysfs subsystem using the
 "class_simple" interface.
 
 This means that only the basic information like module loading parameters
 are presented through sysfs. Other things that might be interesting are
-currently *not* available.
+currently **not** available.
 
 Nevertheless it's now possible to add proper udev rules so that the
 DVB device nodes are created automatically.
@@ -21,10 +34,11 @@ The script should be called "dvb.sh" and should be placed into a script
 dir where udev can execute it, most likely /etc/udev/scripts/
 
 So, create a new file /etc/udev/scripts/dvb.sh and add the following:
-------------------------------schnipp------------------------------------------------
-#!/bin/sh
-/bin/echo $1 | /bin/sed -e 's,dvb\([0-9]\)\.\([^0-9]*\)\([0-9]\),dvb/adapter\1/\2\3,'
-------------------------------schnipp------------------------------------------------
+
+.. code-block:: none
+
+	#!/bin/sh
+	/bin/echo $1 | /bin/sed -e 's,dvb\([0-9]\)\.\([^0-9]*\)\([0-9]\),dvb/adapter\1/\2\3,'
 
 Don't forget to make the script executable with "chmod".
 
@@ -34,9 +48,10 @@ directory for rule files. The main udev configuration file /etc/udev/udev.conf
 will tell you the directory where the rules are, most likely it's /etc/udev/rules.d/
 
 Create a new rule file in that directory called "dvb.rule" and add the following line:
-------------------------------schnipp------------------------------------------------
-KERNEL="dvb*", PROGRAM="/etc/udev/scripts/dvb.sh %k", NAME="%c"
-------------------------------schnipp------------------------------------------------
+
+.. code-block:: none
+
+	KERNEL="dvb*", PROGRAM="/etc/udev/scripts/dvb.sh %k", NAME="%c"
 
 If you want more control over the device nodes (for example a special group membership)
 have a look at "man udev".
-- 
2.7.4

