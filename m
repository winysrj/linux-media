Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55301 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1E2Mbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2011 08:31:36 -0400
Received: by bwz15 with SMTP id 15so2267367bwz.19
        for <linux-media@vger.kernel.org>; Sun, 29 May 2011 05:31:35 -0700 (PDT)
From: Steinel Andreas <a.steinel@googlemail.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Subject: Remote control TechnoTrend S2-3650 CI not working
Date: Sun, 29 May 2011 14:31:31 +0200
Message-Id: <6C4E9A3B-EDC2-487B-90F9-734A0C349A4B@gmail.com>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

I use the aforementioned USB DVB-S2 box and watching works fine. In the wiki (http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI) is stated (and also some posts on the mailing list suggest) that the remote should work too, yet I unfortunately cannot get it to work.

I'm running Debian Squeeze (default kernel - 2.6.32-5-amd64) with a recent S2 checkout


$ hg summary
parent: 15387:41388e396e0f tip
 dm1105: GPIO handling added, I2C on GPIO added, LNB control through GPIO reworked
Zweig: default
Übernehme: 1 modifiziert, 2 unbekannt
Aktualisiere: (aktuell)


$ hg log | head -4 
Änderung:        15387:41388e396e0f
Marke:           tip
Nutzer:          Igor M. Liplianin <liplianin@me.by>
Datum:           Mon May 23 00:50:21 2011 +0300


$ hg diff   
diff -r 41388e396e0f linux/drivers/media/dvb/dvb-usb/pctv452e.c
--- a/linux/drivers/media/dvb/dvb-usb/pctv452e.c	Mon May 23 00:50:21 2011 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/pctv452e.c	Sun May 29 13:55:34 2011 +0200
@@ -1353,7 +1353,7 @@
 	.rc_key_map		= tt_connect_s2_3600_rc_key,
 	.rc_key_map_size	= ARRAY_SIZE(tt_connect_s2_3600_rc_key),
 	.rc_query		= pctv452e_rc_query,
-	.rc_interval		= 500,
+	.rc_interval		= 100,
 
 	.num_adapters		= 1,
 	.adapter = {{


The device is recognized (dmesg):
[ 7849.369145] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:12.2/usb1/1-1/input/input10


The input device is created as expected:
$ cat /sys/devices/pci0000:00/0000:00:12.2/usb1/1-1/input/input10/event8/uevent
MAJOR=13
MINOR=72
DEVNAME=input/event8


$ ls -l /dev/input/event8 
crw-rw-r-- 1 root video 13, 72 29. Mai 13:37 /dev/input/event8


$ cat /etc/default/inputlirc 
# Options to be passed to inputlirc.
EVENTS="/dev/input/by-path/pci-0000:00:12.2-event-ir"
OPTIONS="-m 0 -g"


$ ls -l /dev/input/by-path/pci-0000:00:12.2-event-ir
lrwxrwxrwx 1 root root 9 29. Mai 13:37 /dev/input/by-path/pci-0000:00:12.2-event-ir -> ../event8


irw /dev/lircd does not show any input from the remote. I also checked the remote with a camera and it does emit infra red light.

Any suggestion or advice?

Best,
Andreas Steinel

