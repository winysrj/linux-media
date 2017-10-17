Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:47727 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752629AbdJQGS5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 02:18:57 -0400
Received: by mail-wm0-f47.google.com with SMTP id t69so1481080wmt.2
        for <linux-media@vger.kernel.org>; Mon, 16 Oct 2017 23:18:57 -0700 (PDT)
Received: from [147.251.55.20] (comp55-20.vpn.muni.cz. [147.251.55.20])
        by smtp.googlemail.com with ESMTPSA id m16sm7332768edc.7.2017.10.16.23.18.55
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Oct 2017 23:18:55 -0700 (PDT)
To: linux-media@vger.kernel.org
From: deim31 <deim31@gmail.com>
Subject: get Pinnacle Systems MovieBox (510-USB) to work
Message-ID: <ba548614-360a-0091-797d-5aad3b7d745f@gmail.com>
Date: Tue, 17 Oct 2017 08:18:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Language: cs-CZ
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm trying to run Pinnacle Systems MovieBox (510-USB) on linux.

lsusb gives me:
ID 2304:0223 Pinnacle Systems, Inc. DazzleTV Sat BDA Device

tried modify kernel like:
https://www.linuxtv.org/pipermail/linux-dvb/2007-February/015779.html

(there is note about 0223)

My changes:
$ diff /usr/src/linux/drivers/media/dvb-core/dvb-usb-ids.h dvb-usb-ids.h
307d306
< #define USB_PID_PCTV_510            0x0223

$ diff /usr/src/linux/drivers/media/usb/dvb-usb/ttusb2.c ttusb2.c
638d637
<    { USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_510) },
691c690
<    .num_device_descs = 3,
---
>    .num_device_descs = 2,
701,704d699
<                 {   "Pinnacle 510 DVB-S USB2.0",
<                         { &ttusb2_table[2], NULL },
<                         { NULL },
<                 },

full dmesg:
https://paste.pound-python.org/show/dLUwdNRT04k61TDPM6QP/

relevant parts of dmesg:
[    0.777732] usb 3-2: new high-speed USB device number 2 using xhci_hcd
[    0.954800] usb 3-2: New USB device found, idVendor=2304, idProduct=0223
[    0.954803] usb 3-2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    0.954804] usb 3-2: Product: Pinnacle High Speed USB Device
[    0.954805] usb 3-2: Manufacturer: Pinnacle Systems, Inc.
[    4.320028] dvb-usb: recv bulk message failed: -110
[    4.320030] ttusb2: there might have been an error during control
message transfer. (rlen = 0, was 0)
[    6.368006] dvb-usb: recv bulk message failed: -110
[    6.368008] ttusb2: there might have been an error during control
message transfer. (rlen = 0, was 0)
[    6.368051] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[    6.368123] dvbdev: DVB: registering new adapter (Pinnacle 510 DVB-S
USB2.0)
[    8.416049] dvb-usb: recv bulk message failed: -110
[    8.416054] ttusb2: there might have been an error during control
message transfer. (rlen = 4, was 0)
[    8.416056] ttusb2: i2c transfer failed.
[    8.416066] dvb-usb: no frontend was attached by 'Pinnacle 510 DVB-S
USB2.0'
[   10.464023] dvb-usb: recv bulk message failed: -110
[   10.464027] ttusb2: there might have been an error during control
message transfer. (rlen = 0, was 0)
[   12.512017] dvb-usb: recv bulk message failed: -110
[   12.512021] ttusb2: there might have been an error during control
message transfer. (rlen = 0, was 0)
[   12.512026] dvb-usb: Pinnacle 510 DVB-S USB2.0 successfully
initialized and connected.
[   12.512082] usbcore: registered new interface driver dvb_usb_ttusb2

# ls -l /dev/dvb/adapter0/
celkem 0
crw-rw----+ 1 root video 212, 4 16. øíj 10.52 demux0
crw-rw----+ 1 root video 212, 5 16. øíj 10.52 dvr0
crw-rw----+ 1 root video 212, 7 16. øíj 10.52 net0

I don't know why module doesn't ask for firmware.
Is there a chance to get it to run?

Thanks deim
