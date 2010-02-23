Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47406 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab0BWH3C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 02:29:02 -0500
Received: by gwj16 with SMTP id 16so383051gwj.19
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 23:29:01 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 23 Feb 2010 15:29:01 +0800
Message-ID: <6e8e83e21002222329n30941317v2c8abda1866d6a98@mail.gmail.com>
Subject: modprobe em28xx failed for MSI Vox II USB
From: Bee Hock Goh <beehock@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hope that someone can help me.


OS : Ubuntu Karmic Desktop i386
PC : Thinkpad X60(only testing as I will be running on Asrock ION box)

I have a MSI Vox II USB stick and trying to make it work on Ubuntu.

Followed the steps(http://www.linuxtv.org/wiki/index.php/Em28xx_devices)
in compiling the latest em28xx modules butencounter errors in loading
em28xx.ko.

sudo modprobe em28xx
FATAL: Error inserting em28xx
(/lib/modules/2.6.31-19-generic/kernel/drivers/media/video/em28xx/em28xx.ko):
Unknown symbol in module, or unknown parameter (see dmesg)

dmesg errors message

[ 1737.513177] em28xx: Unknown symbol ir_codes_ati_tv_wonder_hd_600
[ 1737.513984] em28xx: Unknown symbol ir_codes_pinnacle_pctv_hd
[ 1737.514187] em28xx: Unknown symbol ir_codes_kaiomy
[ 1737.515418] em28xx: Unknown symbol ir_codes_em_terratec
[ 1737.516437] em28xx: Unknown symbol ir_input_init
[ 1737.517669] em28xx: Unknown symbol ir_input_nokey
[ 1737.518230] em28xx: Unknown symbol ir_codes_evga_indtube
[ 1737.518579] em28xx: Unknown symbol ir_codes_hauppauge_new
[ 1737.519535] em28xx: Unknown symbol ir_codes_pinnacle_grey
[ 1737.520589] em28xx: Unknown symbol ir_input_keydown


lsusb

Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 003: ID 0483:2016 SGS Thomson Microelectronics Fingerprint Reader
Bus 005 Device 002: ID 0a5c:2110 Broadcom Corp. Bluetooth Controller
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 007: ID 413c:2003 Dell Computer Corp. Keyboard
Bus 001 Device 006: ID 09da:022b A4 Tech Co., Ltd
Bus 001 Device 003: ID 17ef:1000 Lenovo
Bus 001 Device 002: ID 6000:0001
<--------------------------------------------- this is the usb stick
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

thanks,
 Hock
