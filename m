Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:39307 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752206Ab1FDHrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jun 2011 03:47:55 -0400
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-media@vger.kernel.org
Subject: DIB7000 : kernel: firmware[577]: segfault at ...
Date: Sat, 4 Jun 2011 09:47:50 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106040947.51008.toralf.foerster@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

today I observed a hang of my ThinkPad T400 (docked), when I tried to wakeup 
it from s2ram (and even the magic Sysrq keys doesn't work). However as soon as 
I plugged off the USB stick  'Terratec Cinergy T USB XXS (HD)/ T3' the system 
continued to resume.

Within the /var/log/messages there's one interesting line :

2011-06-04T09:35:57.787+02:00 n22 kernel: firmware[577]: segfault at 46 ip 
b77200a8 sp bf898ff0 error 4 in libc-2.12.2.so[b76c4000+156000]

Anything else what I can look for ?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
