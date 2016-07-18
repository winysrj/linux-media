Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbcGRB4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 28/36] [media] doc-rst: add documentation for si470x
Date: Sun, 17 Jul 2016 22:56:11 -0300
Message-Id: <b4a41387beffc1539f4e081f0f65014a74f7c5ca.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert it to ReST and add to media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst  |  1 +
 Documentation/media/v4l-drivers/si470x.rst | 74 ++++++++++++++++++++++--------
 2 files changed, 56 insertions(+), 19 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 64556192f12a..5a582438b2c4 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -35,4 +35,5 @@ License".
 	radiotrack
 	saa7134
 	sh_mobile_ceu_camera
+	si470x
 	zr364xx
diff --git a/Documentation/media/v4l-drivers/si470x.rst b/Documentation/media/v4l-drivers/si470x.rst
index 98c32925eb39..955d8ca159fe 100644
--- a/Documentation/media/v4l-drivers/si470x.rst
+++ b/Documentation/media/v4l-drivers/si470x.rst
@@ -1,10 +1,14 @@
-Driver for USB radios for the Silicon Labs Si470x FM Radio Receivers
+.. include:: <isonum.txt>
 
-Copyright (c) 2009 Tobias Lorenz <tobias.lorenz@gmx.net>
+The Silicon Labs Si470x FM Radio Receivers driver
+=================================================
+
+Copyright |copy| 2009 Tobias Lorenz <tobias.lorenz@gmx.net>
 
 
 Information from Silicon Labs
-=============================
+-----------------------------
+
 Silicon Laboratories is the manufacturer of the radio ICs, that nowadays are the
 most often used radio receivers in cell phones. Usually they are connected with
 I2C. But SiLabs also provides a reference design, which integrates this IC,
@@ -16,9 +20,11 @@ http://www.silabs.com/usbradio
 
 
 Supported ICs
-=============
+-------------
+
 The following ICs have a very similar register set, so that they are or will be
 supported somewhen by the driver:
+
 - Si4700: FM radio receiver
 - Si4701: FM radio receiver, RDS Support
 - Si4702: FM radio receiver
@@ -30,14 +36,17 @@ supported somewhen by the driver:
 - Si4707: Dedicated weather band radio receiver with SAME decoder, RDS Support
 - Si4708: Smallest FM receivers
 - Si4709: Smallest FM receivers, RDS Support
+
 More information on these can be downloaded here:
 http://www.silabs.com/products/mcu/Pages/USBFMRadioRD.aspx
 
 
 Supported USB devices
-=====================
+---------------------
+
 Currently the following USB radios (vendor:product) with the Silicon Labs si470x
 chips are known to work:
+
 - 10c4:818a: Silicon Labs USB FM Radio Reference Design
 - 06e1:a155: ADS/Tech FM Radio Receiver (formerly Instant FM Music) (RDX-155-EF)
 - 1b80:d700: KWorld USB FM Radio SnapMusic Mobile 700 (FM700)
@@ -45,8 +54,10 @@ chips are known to work:
 
 
 Software
-========
+--------
+
 Testing is usually done with most application under Debian/testing:
+
 - fmtools - Utility for managing FM tuner cards
 - gnomeradio - FM-radio tuner for the GNOME desktop
 - gradio - GTK FM radio tuner
@@ -54,8 +65,12 @@ Testing is usually done with most application under Debian/testing:
 - radio - ncurses-based radio application
 - mplayer - The Ultimate Movie Player For Linux
 - v4l2-ctl - Collection of command line video4linux utilities
+
 For example, you can use:
-v4l2-ctl -d /dev/radio0 --set-ctrl=volume=10,mute=0 --set-freq=95.21 --all
+
+.. code-block:: none
+
+	v4l2-ctl -d /dev/radio0 --set-ctrl=volume=10,mute=0 --set-freq=95.21 --all
 
 There is also a library libv4l, which can be used. It's going to have a function
 for frequency seeking, either by using hardware functionality as in radio-si470x
@@ -69,30 +84,48 @@ There is currently no project for making TMC sentences human readable.
 
 
 Audio Listing
-=============
+-------------
+
 USB Audio is provided by the ALSA snd_usb_audio module. It is recommended to
 also select SND_USB_AUDIO, as this is required to get sound from the radio. For
 listing you have to redirect the sound, for example using one of the following
 commands. Please adjust the audio devices to your needs (/dev/dsp* and hw:x,x).
 
 If you just want to test audio (very poor quality):
-cat /dev/dsp1 > /dev/dsp
+
+.. code-block:: none
+
+	cat /dev/dsp1 > /dev/dsp
 
 If you use sox + OSS try:
-sox -2 --endian little -r 96000 -t oss /dev/dsp1 -t oss /dev/dsp
+
+.. code-block:: none
+
+	sox -2 --endian little -r 96000 -t oss /dev/dsp1 -t oss /dev/dsp
+
 or using sox + alsa:
-sox --endian little -c 2 -S -r 96000 -t alsa hw:1 -t alsa -r 96000 hw:0
+
+.. code-block:: none
+
+	sox --endian little -c 2 -S -r 96000 -t alsa hw:1 -t alsa -r 96000 hw:0
 
 If you use arts try:
-arecord -D hw:1,0 -r96000 -c2 -f S16_LE | artsdsp aplay -B -
+
+.. code-block:: none
+
+	arecord -D hw:1,0 -r96000 -c2 -f S16_LE | artsdsp aplay -B -
 
 If you use mplayer try:
-mplayer -radio adevice=hw=1.0:arate=96000 \
-	-rawaudio rate=96000 \
-	radio://<frequency>/capture
+
+.. code-block:: none
+
+	mplayer -radio adevice=hw=1.0:arate=96000 \
+		-rawaudio rate=96000 \
+		radio://<frequency>/capture
 
 Module Parameters
-=================
+-----------------
+
 After loading the module, you still have access to some of them in the sysfs
 mount under /sys/module/radio_si470x/parameters. The contents of read-only files
 (0444) are not updated, even if space, band and de are changed using private
@@ -100,7 +133,8 @@ video controls. The others are runtime changeable.
 
 
 Errors
-======
+------
+
 Increase tune_timeout, if you often get -EIO errors.
 
 When timed out or band limit is reached, hw_freq_seek returns -EAGAIN.
@@ -109,7 +143,8 @@ If you get any errors from snd_usb_audio, please report them to the ALSA people.
 
 
 Open Issues
-===========
+-----------
+
 V4L minor device allocation and parameter setting is not perfect. A solution is
 currently under discussion.
 
@@ -125,5 +160,6 @@ functions in the kernel.
 
 
 Other useful information and links
-==================================
+----------------------------------
+
 http://www.silabs.com/usbradio
-- 
2.7.4

