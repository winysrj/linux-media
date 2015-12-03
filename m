Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36398 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbbLCSXb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2015 13:23:31 -0500
Received: by wmww144 with SMTP id w144so32826646wmw.1
        for <linux-media@vger.kernel.org>; Thu, 03 Dec 2015 10:23:30 -0800 (PST)
Received: from pc-olivier (APuteaux-653-1-229-208.w86-195.abo.wanadoo.fr. [86.195.120.208])
        by smtp.googlemail.com with ESMTPSA id b82sm91136wmf.9.2015.12.03.10.23.29
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 03 Dec 2015 10:23:29 -0800 (PST)
Message-ID: <1449167008.1681.0.camel@gmail.com>
Subject: Problem with avermedia Volar Black HD (af9015) : recognised but not
 scanning
From: oddebian <oddebian@gmail.com>
To: linux-media@vger.kernel.org
Date: Thu, 03 Dec 2015 19:23:28 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have an old avermedia Volar Black HD (af9015) that still works pretty
well in windows 8 (it scans the whole dvb-t muxes in less than one
minute and the image is perfect even in HD).
When I try it on linux, it takes 12 minutes to scan with w_scan, and
despite showing lines such as :
updating transponder:
   (QAM_64   f = 4294967 kHz I999B8C999D0T8G32Y0) 0x405A
to (QAM_64   f = 4294967 kHz I999B8C999D0T8G8Y0) 0x405A
undefined coderate HP
in the end, it says :

tune to: QAM_AUTO f = 482000 kHz I999B8C999D999T999G999Y999 
(time: 12:13) ----------no signal----------
tune to: QAM_AUTO f = 482000 kHz I999B8C999D999T999G999Y999  (no signal)
(time: 12:14) ----------no signal----------
tune to: QAM_64   f = 4294967 kHz I999B8C999D0T8G8Y0 
(time: 12:16) skipped: (freq 4294967286 unsupported by driver)
tune to: QAM_AUTO f = 482166 kHz I999B8C999D999T999G999Y999 
(time: 12:16) ----------no signal----------
tune to: QAM_AUTO f = 482166 kHz I999B8C999D999T999G999Y999  (no signal)
(time: 12:17) ----------no signal----------

ERROR: Sorry - i couldn't get any working frequency/transponder
Nothing to scan!!


The problem is the same on my destop pc (debian 8, kernel
3.16.0-4-amd64) and on a Raspberry 1 (Linux osmc 4.2.3-3-osmc, or
openelec).
I tried also with tvheadend, but scan does not work either.

The firmware is correct and installed in /lib/firmware.
Dmesg shows that the usb device is well detected, with no errors :
[   13.846959] usb 1-5: dvb_usb_v2: found a 'AverMedia AVerTV Volar
Black HD (A850)' in cold state
[   13.847467] usb 1-5: firmware: direct-loading firmware
dvb-usb-af9015.fw
[   13.847474] usb 1-5: dvb_usb_v2: downloading firmware from file
'dvb-usb-af9015.fw'
[   13.917176] usb 1-5: dvb_usb_v2: found a 'AverMedia AVerTV Volar
Black HD (A850)' in warm state
[   14.327175] usb 1-5: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[   14.335086] usb 1-5: DVB: registering adapter 0 frontend 0 (Afatech
AF9013)...
[   14.345704] usb 1-5: dvb_usb_v2: 'AverMedia AVerTV Volar Black HD
(A850)' successfully initialized and connected
[   14.345795] usbcore: registered new interface driver dvb_usb_af9015

And lsusb :
Bus 001 Device 003: ID 07ca:850a AVerMedia Technologies, Inc. AverTV
Volar Black HD (A850)

I must say it is very frustrating to see a device still supported in
windows 8, and working perfectly, but not working anymore in linux
despite stated as supported in
http://www.linuxtv.org/wiki/index.php/AVerTV_Volar_Black_HD_%28A850%29

Thanks in advance for any idea that could help !
OD


