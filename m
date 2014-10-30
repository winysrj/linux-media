Return-path: <linux-media-owner@vger.kernel.org>
Received: from pop3.pb.cz ([109.72.0.20]:57708 "EHLO pop3.pb.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758418AbaJ3KGg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 06:06:36 -0400
Received: from [192.168.1.15] (unknown [109.72.4.22])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by pop3.pb.cz (Postfix) with ESMTPS id D967682B92
	for <linux-media@vger.kernel.org>; Thu, 30 Oct 2014 10:40:58 +0100 (CET)
Message-ID: <545207AA.2080907@mizera.cz>
Date: Thu, 30 Oct 2014 10:40:58 +0100
From: kapetr@mizera.cz
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: AF9035 not builded from git
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

I have:
Bus 001 Device 004: ID 048d:9135 Integrated Technology Express, Inc. 
Zolid Mini DVB-T Stick

This is well supported DVB-T USB card - used successfully with
dvb-usb-af9035 module.

Till now.


After every kernel update I have to rebuild v4l driver.

After last time (with kernel 3.2.0-70-generic #105-Ubuntu SMP Wed Sep 24 
19:49:16 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux)

the build process has end successfully, but there is not builded this 
module, what I need ?-(

xxxxxxxxxxxxx

git clone --depth=1 git://linuxtv.org/media_build.git
cd media_build/
./build
sudo make install

xxxxxxxxxxxxx there are only these modules installed:

$ ll /lib/modules/3.2.0-70-generic/kernel/drivers/media/usb/dvb-usb/
celkem 1,1M
drwxr-xr-x  2 root root 4,0K шнj 30 09:34 ./
drwxr-xr-x 21 root root 4,0K шнj 30 09:34 ../
-rw-r--r--  1 root root  61K шнj 30 09:34 dvb-usb-af9005.ko
-rw-r--r--  1 root root 7,3K шнj 30 09:34 dvb-usb-af9005-remote.ko
-rw-r--r--  1 root root  31K шнj 30 09:34 dvb-usb-az6027.ko
-rw-r--r--  1 root root  14K шнj 30 09:34 dvb-usb-a800.ko
-rw-r--r--  1 root root  18K шнj 30 09:34 dvb-usb-cinergyT2.ko
-rw-r--r--  1 root root 100K шнj 30 09:34 dvb-usb-cxusb.ko
-rw-r--r--  1 root root  18K шнj 30 09:34 dvb-usb-dibusb-common.ko
-rw-r--r--  1 root root  32K шнj 30 09:34 dvb-usb-dibusb-mb.ko
-rw-r--r--  1 root root  14K шнj 30 09:34 dvb-usb-dibusb-mc.ko
-rw-r--r--  1 root root 210K шнj 30 09:34 dvb-usb-dib0700.ko
-rw-r--r--  1 root root  18K шнj 30 09:34 dvb-usb-digitv.ko
-rw-r--r--  1 root root  35K шнj 30 09:34 dvb-usb-dtt200u.ko
-rw-r--r--  1 root root  15K шнj 30 09:34 dvb-usb-dtv5100.ko
-rw-r--r--  1 root root  82K шнj 30 09:34 dvb-usb-dw2102.ko
-rw-r--r--  1 root root  25K шнj 30 09:34 dvb-usb-friio.ko
-rw-r--r--  1 root root  26K шнj 30 09:34 dvb-usb-gp8psk.ko
-rw-r--r--  1 root root  44K шнj 30 09:34 dvb-usb.ko
-rw-r--r--  1 root root  58K шнj 30 09:34 dvb-usb-m920x.ko
-rw-r--r--  1 root root  14K шнj 30 09:34 dvb-usb-nova-t-usb2.ko
-rw-r--r--  1 root root  21K шнj 30 09:34 dvb-usb-opera.ko
-rw-r--r--  1 root root  34K шнj 30 09:34 dvb-usb-pctv452e.ko
-rw-r--r--  1 root root  23K шнj 30 09:34 dvb-usb-technisat-usb2.ko
-rw-r--r--  1 root root  37K шнj 30 09:34 dvb-usb-ttusb2.ko
-rw-r--r--  1 root root  14K шнj 30 09:34 dvb-usb-umt-010.ko
-rw-r--r--  1 root root  26K шнj 30 09:34 dvb-usb-vp702x.ko
-rw-r--r--  1 root root  21K шнj 30 09:34 dvb-usb-vp7045.ko

$ ll /lib/modules/3.2.0-70-generic/kernel/drivers/media/usb/dvb-usb-v2/
celkem 324K
drwxr-xr-x  2 root root 4,0K шнj 30 09:34 ./
drwxr-xr-x 21 root root 4,0K шнj 30 09:34 ../
-rw-r--r--  1 root root  43K шнj 30 09:34 dvb-usb-af9015.ko
-rw-r--r--  1 root root  12K шнj 30 09:34 dvb-usb-au6610.ko
-rw-r--r--  1 root root  26K шнj 30 09:34 dvb-usb-az6007.ko
-rw-r--r--  1 root root  13K шнj 30 09:34 dvb-usb-ce6230.ko
-rw-r--r--  1 root root  15K шнj 30 09:34 dvb-usb-ec168.ko
-rw-r--r--  1 root root  12K шнj 30 09:34 dvb-usb-gl861.ko
-rw-r--r--  1 root root  36K шнj 30 09:34 dvb-usb-lmedm04.ko
-rw-r--r--  1 root root  82K шнj 30 09:34 dvb-usb-mxl111sf.ko
-rw-r--r--  1 root root  34K шнj 30 09:34 dvb_usb_v2.ko
-rw-r--r--  1 root root  15K шнj 30 09:34 mxl111sf-demod.ko
-rw-r--r--  1 root root  13K шнj 30 09:34 mxl111sf-tuner.ko

xxxxxxxxx


Thanks for help

--kapetr
