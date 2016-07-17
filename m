Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60563 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbcGQRHU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 13:07:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 11/15] [media] doc-rst: add opera-firmware.rst to DVB docs
Date: Sun, 17 Jul 2016 14:07:06 -0300
Message-Id: <6e31b7c117a79928a3212eda2735eeeedc282d20.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file is shown OK with ReST. Yet, as we changed the
place where the get_dvb_firmware script is, we need to
update it.

While here, move the author's name to the beginning of the
file.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/index.rst          |  1 +
 Documentation/media/dvb-drivers/opera-firmware.rst | 14 +++++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index 06463c5f2ce6..0574c2e7e0ff 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -26,4 +26,5 @@ License".
 	dvb-usb
 	faq
 	lmedm04
+	opera-firmware
 	contributors
diff --git a/Documentation/media/dvb-drivers/opera-firmware.rst b/Documentation/media/dvb-drivers/opera-firmware.rst
index fb6683188ef7..41236b43c124 100644
--- a/Documentation/media/dvb-drivers/opera-firmware.rst
+++ b/Documentation/media/dvb-drivers/opera-firmware.rst
@@ -1,3 +1,8 @@
+Opera firmware
+==============
+
+Author: Marco Gittler <g.marco@freenet.de>
+
 To extract the firmware for the Opera DVB-S1 USB-Box
 you need to copy the files:
 
@@ -6,9 +11,11 @@ you need to copy the files:
 
 from the windriver disk into this directory.
 
-Then run
+Then run:
 
-./get_dvb_firmware opera1
+.. code-block:: none
+
+	scripts/get_dvb_firmware opera1
 
 and after that you have 2 files:
 
@@ -22,6 +29,3 @@ Copy them into /lib/firmware/ .
 After that the driver can load the firmware
 (if you have enabled firmware loading
 in kernel config and have hotplug running).
-
-
-Marco Gittler <g.marco@freenet.de>
-- 
2.7.4

