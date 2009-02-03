Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:4080 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbZBCDZo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 22:25:44 -0500
Received: by fg-out-1718.google.com with SMTP id 16so777701fgg.17
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2009 19:25:42 -0800 (PST)
Subject: [PATCH] radio-si470x Documentation: add note about mplayer
From: Alexey Klimov <klimov.linux@gmail.com>
To: Tobias Lorenz <tobias.lorenz@gmx.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 03 Feb 2009 06:25:35 +0300
Message-Id: <1233631535.5730.12.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, all

This small patch adds information about si470x radio listening.
Probably, it's useful to add such notes in doc file, right ?
Feel free to change words in the right way due to my possible bad
english.

---
Patch adds information in si470x doc file about mplayer using to
listening to the radio with this radio device.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r aba639a17195 linux/Documentation/video4linux/si470x.txt
--- a/linux/Documentation/video4linux/si470x.txt	Mon Feb 02 21:09:06 2009 +0300
+++ b/linux/Documentation/video4linux/si470x.txt	Tue Feb 03 06:20:29 2009 +0300
@@ -52,6 +52,8 @@
 - gradio - GTK FM radio tuner
 - kradio - Comfortable Radio Application for KDE
 - radio - ncurses-based radio application
+- mplayer - media player for Linux http://www.mplayerhq.hu/
+(see Audio Listening section below)
 
 There is also a library libv4l, which can be used. It's going to have a function
 for frequency seeking, either by using hardware functionality as in radio-si470x
@@ -80,6 +82,12 @@
 If you use arts try:
 arecord -D hw:1,0 -r96000 -c2 -f S16_LE | artsdsp aplay -B -
 
+You can also try mplayer:
+mplayer radio://95.23/capture -radio adevice=hw=1.0:arate=96000 -rawaudio rate=96000
+Of course, you should place right "adevice=hw=x.x" option, and you can read
+man mplayer to know more about others parameters. Mplayer handles both v4l2-radio
+control and sound redirecting, that's why this method is interesting.
+
 
 Module Parameters
 =================




-- 
Best regards, Klimov Alexey

