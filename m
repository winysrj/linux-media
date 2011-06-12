Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:58636 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751569Ab1FLR61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 13:58:27 -0400
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-media@vger.kernel.org
Subject: firmware segfault with 'Terratec Cinergy T USB XXS (HD)/ T3'
Date: Sun, 12 Jun 2011 19:58:22 +0200
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106121958.22865.toralf.foerster@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

When I plugin that USB receiver into a docked ThinkPad T400, s2ram it and
resume it, I got this line within /var/log/message :

2011-06-12T19:49:10.030+02:00 n22 kernel: firmware[29666]: segfault at 46 ip b770b0a8 sp bfb21560 error 4 in libc-2.12.2.so[b76af000+156000]
2011-06-12T19:49:10.000+02:00 n22 udevd-work[29659]: 'firmware --firmware=dvb-usb-dib0700-1.20.fw --devpath=/devices/pci0000:00/0000:00:1a.7/usb1/1-1/firmware/1-1' unexpected exit with 
status 0x008b


Furthermore in the upper left corner a cursor is blinking and the system stays
in this mode until I plug off the USB stick. Then after a while the KDE desktop
is back.


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
