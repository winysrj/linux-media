Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57746 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab0G1NlM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 09:41:12 -0400
Received: by wyf19 with SMTP id 19so4127361wyf.19
        for <linux-media@vger.kernel.org>; Wed, 28 Jul 2010 06:41:04 -0700 (PDT)
Subject: DVBT +AF9015 +MXL5007t
From: hmd <tambatux@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 18:10:42 +0430
Message-ID: <1280324442.6066.5.camel@HDtv>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI all
I have a usb dvbt module with af9015 +mx5007t
both drivers exist in kernel but af9015.c needs to be patched
 
lsusb:
Bus 002 Device 003: ID 15a4:9016 Afatech Technologies, Inc. AF9015 DVB-T
USB2.0 stick
  
dmesg | grep 9015
[ 3407.599086] dvb_usb_af9015 2-4:1.0: usb_probe_interface
[ 3407.599095] dvb_usb_af9015 2-4:1.0: usb_probe_interface - got id
[ 3407.967209] af9015: tuner id:177 not supported, please report!
[ 3407.967270] dvb_usb_af9015 2-4:1.1: usb_probe_interface
[ 3407.967277] dvb_usb_af9015 2-4:1.1: usb_probe_interface - got id
[ 3407.968049] usbcore: registered new interface driver dvb_usb_af9015

driver adress:
v4l-dvb/linux/drivers/media/dvb/dvb-usb/af9015.c
v4l-dvb/linux/drivers/media/common/tuners/mxl5007.c


I dont know how do it
can any one help?
thanks

