Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45856 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbcGRB4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 19/36] [media] doc-rst: Add ivtv documentation
Date: Sun, 17 Jul 2016 22:56:02 -0300
Message-Id: <2a744b0d7b84063192231922bfc684fa459b7464.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert ivtv documentation to rst, update the links there
and add to media/v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/index.rst |   1 +
 Documentation/media/v4l-drivers/ivtv.rst  | 209 +++++++++++++++++-------------
 2 files changed, 121 insertions(+), 89 deletions(-)

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 333f84b9c17e..99409c6e2518 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -26,4 +26,5 @@ License".
 	cx88
 	davinci-vpbe
 	fimc
+	ivtv
 	zr364xx
diff --git a/Documentation/media/v4l-drivers/ivtv.rst b/Documentation/media/v4l-drivers/ivtv.rst
index 2579b5b709ed..3ba464c4f9bf 100644
--- a/Documentation/media/v4l-drivers/ivtv.rst
+++ b/Documentation/media/v4l-drivers/ivtv.rst
@@ -1,26 +1,32 @@
 
-ivtv release notes
-==================
+The ivtv driver
+===============
+
+Author: Hans Verkuil <hverkuil@xs4all.nl>
 
 This is a v4l2 device driver for the Conexant cx23415/6 MPEG encoder/decoder.
 The cx23415 can do both encoding and decoding, the cx23416 can only do MPEG
 encoding. Currently the only card featuring full decoding support is the
 Hauppauge PVR-350.
 
-NOTE: this driver requires the latest encoder firmware (version 2.06.039, size
-376836 bytes). Get the firmware from here:
+.. note::
 
-http://dl.ivtvdriver.org/ivtv/firmware/
+   #) This driver requires the latest encoder firmware (version 2.06.039, size
+      376836 bytes). Get the firmware from here:
 
-NOTE: 'normal' TV applications do not work with this driver, you need
-an application that can handle MPEG input such as mplayer, xine, MythTV,
-etc.
+      https://linuxtv.org/downloads/firmware/#conexant
+
+   #) 'normal' TV applications do not work with this driver, you need
+      an application that can handle MPEG input such as mplayer, xine, MythTV,
+      etc.
 
 The primary goal of the IVTV project is to provide a "clean room" Linux
 Open Source driver implementation for video capture cards based on the
 iCompression iTVC15 or Conexant CX23415/CX23416 MPEG Codec.
 
-Features:
+Features
+--------
+
  * Hardware mpeg2 capture of broadcast video (and sound) via the tuner or
    S-Video/Composite and audio line-in.
  * Hardware mpeg2 capture of FM radio where hardware support exists
@@ -31,7 +37,9 @@ Features:
    this into the captured MPEG stream.
  * Supports raw YUV and PCM input.
 
-Additional features for the PVR-350 (CX23415 based):
+Additional features for the PVR-350 (CX23415 based)
+---------------------------------------------------
+
  * Provides hardware mpeg2 playback
  * Provides comprehensive OSD (On Screen Display: ie. graphics overlaying the
    video signal)
@@ -40,20 +48,22 @@ Additional features for the PVR-350 (CX23415 based):
  * Supports raw YUV output.
 
 IMPORTANT: In case of problems first read this page:
-	   http://www.ivtvdriver.org/index.php/Troubleshooting
+	https://help.ubuntu.com/community/Install_IVTV_Troubleshooting
 
-See also:
+See also
+--------
 
-Homepage + Wiki
-http://www.ivtvdriver.org
+https://linuxtv.org
 
 IRC
-irc://irc.freenode.net/ivtv-dev
+---
+
+irc://irc.freenode.net/#v4l
 
 ----------------------------------------------------------
 
 Devices
-=======
+-------
 
 A maximum of 12 ivtv boards are allowed at the moment.
 
@@ -65,25 +75,28 @@ The radio0 device may or may not be present, depending on whether the
 card has a radio tuner or not.
 
 Here is a list of the base v4l devices:
-crw-rw----    1 root     video     81,   0 Jun 19 22:22 /dev/video0
-crw-rw----    1 root     video     81,  16 Jun 19 22:22 /dev/video16
-crw-rw----    1 root     video     81,  24 Jun 19 22:22 /dev/video24
-crw-rw----    1 root     video     81,  32 Jun 19 22:22 /dev/video32
-crw-rw----    1 root     video     81,  48 Jun 19 22:22 /dev/video48
-crw-rw----    1 root     video     81,  64 Jun 19 22:22 /dev/radio0
-crw-rw----    1 root     video     81, 224 Jun 19 22:22 /dev/vbi0
-crw-rw----    1 root     video     81, 228 Jun 19 22:22 /dev/vbi8
-crw-rw----    1 root     video     81, 232 Jun 19 22:22 /dev/vbi16
+
+.. code-block:: none
+
+	crw-rw----    1 root     video     81,   0 Jun 19 22:22 /dev/video0
+	crw-rw----    1 root     video     81,  16 Jun 19 22:22 /dev/video16
+	crw-rw----    1 root     video     81,  24 Jun 19 22:22 /dev/video24
+	crw-rw----    1 root     video     81,  32 Jun 19 22:22 /dev/video32
+	crw-rw----    1 root     video     81,  48 Jun 19 22:22 /dev/video48
+	crw-rw----    1 root     video     81,  64 Jun 19 22:22 /dev/radio0
+	crw-rw----    1 root     video     81, 224 Jun 19 22:22 /dev/vbi0
+	crw-rw----    1 root     video     81, 228 Jun 19 22:22 /dev/vbi8
+	crw-rw----    1 root     video     81, 232 Jun 19 22:22 /dev/vbi16
 
 Base devices
-============
+------------
 
 For every extra card you have the numbers increased by one. For example,
 /dev/video0 is listed as the 'base' encoding capture device so we have:
 
- /dev/video0  is the encoding capture device for the first card (card 0)
- /dev/video1  is the encoding capture device for the second card (card 1)
- /dev/video2  is the encoding capture device for the third card (card 2)
+- /dev/video0  is the encoding capture device for the first card (card 0)
+- /dev/video1  is the encoding capture device for the second card (card 1)
+- /dev/video2  is the encoding capture device for the third card (card 2)
 
 Note that if the first card doesn't have a feature (eg no decoder, so no
 video16, the second card will still use video17. The simple rule is 'add
@@ -94,93 +107,111 @@ whatever). Otherwise the device numbers can get confusing. The ivtv
 'ivtv_first_minor' module option can be used for that.
 
 
-/dev/video0
-The encoding capture device(s).
-Read-only.
+- /dev/video0
 
-Reading from this device gets you the MPEG1/2 program stream.
-Example:
+  The encoding capture device(s).
 
-cat /dev/video0 > my.mpg (you need to hit ctrl-c to exit)
+  Read-only.
 
+  Reading from this device gets you the MPEG1/2 program stream.
+  Example:
 
-/dev/video16
-The decoder output device(s)
-Write-only. Only present if the MPEG decoder (i.e. CX23415) exists.
+  .. code-block:: none
 
-An mpeg2 stream sent to this device will appear on the selected video
-display, audio will appear on the line-out/audio out.  It is only
-available for cards that support video out. Example:
+	cat /dev/video0 > my.mpg (you need to hit ctrl-c to exit)
 
-cat my.mpg >/dev/video16
 
+- /dev/video16
 
-/dev/video24
-The raw audio capture device(s).
-Read-only
+  The decoder output device(s)
 
-The raw audio PCM stereo stream from the currently selected
-tuner or audio line-in.  Reading from this device results in a raw
-(signed 16 bit Little Endian, 48000 Hz, stereo pcm) capture.
-This device only captures audio. This should be replaced by an ALSA
-device in the future.
-Note that there is no corresponding raw audio output device, this is
-not supported in the decoder firmware.
+  Write-only. Only present if the MPEG decoder (i.e. CX23415) exists.
 
+  An mpeg2 stream sent to this device will appear on the selected video
+  display, audio will appear on the line-out/audio out.  It is only
+  available for cards that support video out. Example:
 
-/dev/video32
-The raw video capture device(s)
-Read-only
+  .. code-block:: none
 
-The raw YUV video output from the current video input. The YUV format
-is non-standard (V4L2_PIX_FMT_HM12).
+	cat my.mpg >/dev/video16
 
-Note that the YUV and PCM streams are not synchronized, so they are of
-limited use.
 
+- /dev/video24
 
-/dev/video48
-The raw video display device(s)
-Write-only. Only present if the MPEG decoder (i.e. CX23415) exists.
+  The raw audio capture device(s).
 
-Writes a YUV stream to the decoder of the card.
+  Read-only
 
+  The raw audio PCM stereo stream from the currently selected
+  tuner or audio line-in.  Reading from this device results in a raw
+  (signed 16 bit Little Endian, 48000 Hz, stereo pcm) capture.
+  This device only captures audio. This should be replaced by an ALSA
+  device in the future.
+  Note that there is no corresponding raw audio output device, this is
+  not supported in the decoder firmware.
 
-/dev/radio0
-The radio tuner device(s)
-Cannot be read or written.
 
-Used to enable the radio tuner and tune to a frequency. You cannot
-read or write audio streams with this device.  Once you use this
-device to tune the radio, use /dev/video24 to read the raw pcm stream
-or /dev/video0 to get an mpeg2 stream with black video.
+- /dev/video32
 
+  The raw video capture device(s)
 
-/dev/vbi0
-The 'vertical blank interval' (Teletext, CC, WSS etc) capture device(s)
-Read-only
+  Read-only
 
-Captures the raw (or sliced) video data sent during the Vertical Blank
-Interval. This data is used to encode teletext, closed captions, VPS,
-widescreen signalling, electronic program guide information, and other
-services.
+  The raw YUV video output from the current video input. The YUV format
+  is non-standard (V4L2_PIX_FMT_HM12).
 
+  Note that the YUV and PCM streams are not synchronized, so they are of
+  limited use.
 
-/dev/vbi8
-Processed vbi feedback device(s)
-Read-only. Only present if the MPEG decoder (i.e. CX23415) exists.
 
-The sliced VBI data embedded in an MPEG stream is reproduced on this
-device. So while playing back a recording on /dev/video16, you can
-read the embedded VBI data from /dev/vbi8.
+- /dev/video48
 
+  The raw video display device(s)
 
-/dev/vbi16
-The vbi 'display' device(s)
-Write-only. Only present if the MPEG decoder (i.e. CX23415) exists.
+  Write-only. Only present if the MPEG decoder (i.e. CX23415) exists.
 
-Can be used to send sliced VBI data to the video-out connector.
+  Writes a YUV stream to the decoder of the card.
 
----------------------------------
 
-Hans Verkuil <hverkuil@xs4all.nl>
+- /dev/radio0
+
+  The radio tuner device(s)
+
+  Cannot be read or written.
+
+  Used to enable the radio tuner and tune to a frequency. You cannot
+  read or write audio streams with this device.  Once you use this
+  device to tune the radio, use /dev/video24 to read the raw pcm stream
+  or /dev/video0 to get an mpeg2 stream with black video.
+
+
+- /dev/vbi0
+
+  The 'vertical blank interval' (Teletext, CC, WSS etc) capture device(s)
+
+  Read-only
+
+  Captures the raw (or sliced) video data sent during the Vertical Blank
+  Interval. This data is used to encode teletext, closed captions, VPS,
+  widescreen signalling, electronic program guide information, and other
+  services.
+
+
+- /dev/vbi8
+
+  Processed vbi feedback device(s)
+
+  Read-only. Only present if the MPEG decoder (i.e. CX23415) exists.
+
+  The sliced VBI data embedded in an MPEG stream is reproduced on this
+  device. So while playing back a recording on /dev/video16, you can
+  read the embedded VBI data from /dev/vbi8.
+
+
+- /dev/vbi16
+
+  The vbi 'display' device(s)
+
+  Write-only. Only present if the MPEG decoder (i.e. CX23415) exists.
+
+  Can be used to send sliced VBI data to the video-out connector.
-- 
2.7.4

