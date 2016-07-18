Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbcGRB43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 36/36] [media] v4l-with-ir.rst: update it to reflect the current status
Date: Sun, 17 Jul 2016 22:56:19 -0300
Message-Id: <2e97d6d3013fa0d44c322b6181ea4b8f8a519094.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This document were really old. Update it to reflect the current
status of the IR drivers for TV.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/v4l-with-ir.rst | 82 ++++++++++++-------------
 1 file changed, 40 insertions(+), 42 deletions(-)

diff --git a/Documentation/media/v4l-drivers/v4l-with-ir.rst b/Documentation/media/v4l-drivers/v4l-with-ir.rst
index 334174a52bda..613e1e79fc96 100644
--- a/Documentation/media/v4l-drivers/v4l-with-ir.rst
+++ b/Documentation/media/v4l-drivers/v4l-with-ir.rst
@@ -1,31 +1,34 @@
-infrared remote control support in video4linux drivers
+Infrared remote control support in video4linux drivers
 ======================================================
 
-Author: Gerd Hoffmann
-
-.. note::
-
-   This section is outdated.
+Authors: Gerd Hoffmann, Mauro Carvalho Chehab
 
 Basics
 ------
 
-Current versions use the linux input layer to support infrared
-remote controls.  I suggest to download my input layer tools
-from http://bytesex.org/snapshot/input-<date>.tar.gz
+Most analog and digital TV boards support remote controllers. Several of
+them have a microprocessor that receives the IR carriers, convert into
+pulse/space sequences and then to scan codes, returning such codes to
+userspace ("scancode mode"). Other boards return just the pulse/space
+sequences ("raw mode").
 
-Modules you have to load:
+The support for remote controller in scancode mode is provided by the
+standard Linux input layer. The support for raw mode is provided via LIRC.
 
-  saa7134	statically built in, i.e. just the driver :)
-  bttv		ir-kbd-gpio or ir-kbd-i2c depending on your
-		card.
+In order to check the support and test it, it is suggested to download
+the `v4l-utils <https://git.linuxtv.org/v4l-utils.git/>`_. It provides
+two tools to handle remote controllers:
 
-ir-kbd-gpio and ir-kbd-i2c don't support all cards lirc supports
-(yet), mainly for the reason that the code of lirc_i2c and lirc_gpio
-was very confusing and I decided to basically start over from scratch.
-Feel free to contact me in case of trouble.  Note that the ir-kbd-*
-modules work on 2.6.x kernels only through ...
+- ir-keytable: provides a way to query the remote controller, list the
+  protocols it supports, enable in-kernel support for IR decoder or
+  switch the protocol and to test the reception of scan codes;
 
+- ir-ctl: provide tools to handle remote controllers that support raw mode
+  via LIRC interface.
+
+Usually, the remote controller module is auto-loaded when the TV card is
+detected. However, for a few devices, you need to manually load the
+ir-kbd-i2c module.
 
 How it works
 ------------
@@ -36,40 +39,35 @@ layer, i.e. you'll see the keys of the remote as normal key strokes
 
 Using the event devices (CONFIG_INPUT_EVDEV) it is possible for
 applications to access the remote via /dev/input/event<n> devices.
-You might have to create the special files using "/sbin/MAKEDEV
-input".  The input layer tools mentioned above use the event device.
+The udev/systemd will automatically create the devices. If you install
+the `v4l-utils <https://git.linuxtv.org/v4l-utils.git/>`_, it may also
+automatically load a different keytable than the default one. Please see
+`v4l-utils <https://git.linuxtv.org/v4l-utils.git/>`_ ir-keytable.1
+man page for details.
 
-The input layer tools are nice for trouble shooting, i.e. to check
+The ir-keytable tool is nice for trouble shooting, i.e. to check
 whenever the input device is really present, which of the devices it
 is, check whenever pressing keys on the remote actually generates
-events and the like.  You can also use the kbd utility to change the
-keymaps (2.6.x kernels only through).
+events and the like.  You can also use any other input utility that changes
+the keymaps, like the input kbd utility.
 
 
 Using with lircd
 ================
 
-The cvs version of the lircd daemon supports reading events from the
-linux input layer (via event device).  The input layer tools tarball
-comes with a lircd config file.
+The latest versions of the lircd daemon supports reading events from the
+linux input layer (via event device). It also supports receiving IR codes
+in lirc mode.
 
 
 Using without lircd
 ===================
 
-XFree86 likely can be configured to recognise the remote keys.  Once I
-simply tried to configure one of the multimedia keyboards as input
-device, which had the effect that XFree86 recognised some of the keys
-of my remote control and passed volume up/down key presses as
-XF86AudioRaiseVolume and XF86AudioLowerVolume key events to the X11
-clients.
-
-It likely is possible to make that fly with a nice xkb config file,
-I know next to nothing about that through.
-
-
-Have fun,
-
-  Gerd
-
---
+Xorg recognizes several IR keycodes that have its numerical value lower
+than 247. With the advent of Wayland, the input driver got updated too,
+and should now accept all keycodes. Yet, you may want to just reasign
+the keycodes to something that your favorite media application likes.
+
+This can be done by setting
+`v4l-utils <https://git.linuxtv.org/v4l-utils.git/>`_ to load your own
+keytable in runtime. Please read  ir-keytable.1 man page for details.
-- 
2.7.4

