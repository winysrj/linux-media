Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:43704 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758435Ab3BKXEx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 18:04:53 -0500
Received: by mail-la0-f53.google.com with SMTP id fr10so6201579lab.26
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2013 15:04:52 -0800 (PST)
Message-ID: <1360623891.5821.8.camel@tux>
Subject: [PATCH] [media] radio-si470x doc: add info about v4l2-ctl and
 sox+alsa
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org
Date: Mon, 11 Feb 2013 23:04:51 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch adds information about using v4l2-ctl utility to tune the si470x
radio and example how to use sox+alsa to redirect sound from radio sound
device to another sound device.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>


diff --git a/Documentation/video4linux/si470x.txt b/Documentation/video4linux/si470x.txt
index 3a7823e..98c3292 100644
--- a/Documentation/video4linux/si470x.txt
+++ b/Documentation/video4linux/si470x.txt
@@ -53,6 +53,9 @@ Testing is usually done with most application under Debian/testing:
 - kradio - Comfortable Radio Application for KDE
 - radio - ncurses-based radio application
 - mplayer - The Ultimate Movie Player For Linux
+- v4l2-ctl - Collection of command line video4linux utilities
+For example, you can use:
+v4l2-ctl -d /dev/radio0 --set-ctrl=volume=10,mute=0 --set-freq=95.21 --all
 
 There is also a library libv4l, which can be used. It's going to have a function
 for frequency seeking, either by using hardware functionality as in radio-si470x
@@ -75,8 +78,10 @@ commands. Please adjust the audio devices to your needs (/dev/dsp* and hw:x,x).
 If you just want to test audio (very poor quality):
 cat /dev/dsp1 > /dev/dsp
 
-If you use OSS try:
+If you use sox + OSS try:
 sox -2 --endian little -r 96000 -t oss /dev/dsp1 -t oss /dev/dsp
+or using sox + alsa:
+sox --endian little -c 2 -S -r 96000 -t alsa hw:1 -t alsa -r 96000 hw:0
 
 If you use arts try:
 arecord -D hw:1,0 -r96000 -c2 -f S16_LE | artsdsp aplay -B -


