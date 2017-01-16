Return-path: <linux-media-owner@vger.kernel.org>
Received: from sender153-mail.zoho.com ([74.201.84.153]:25431 "EHLO
        sender153-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751212AbdAPNdD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 08:33:03 -0500
Message-ID: <587CCB8B.4000106@zoho.com>
Date: Mon, 16 Jan 2017 14:32:59 +0100
From: em28xx PCTV 520e <em28xx_520e@zoho.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em28xx failed with kernel 3.14.79
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm using a PCTV 520e usb dvb-c device at an ODROID-C2, running ubuntu 
with kernel 3.14.79. I'd like to use the lates media build drivers. 
However, if I do so, I get the following output with dmesg:

[  132.288365] usb 1-1.1: new high-speed USB device number 4 using dwc_otg
[  133.443178] media: Linux media interface: v0.10
[  133.453273] Linux video capture interface: v2.00
[  133.464065] em28xx 1-1.1:1.0: New device PCTV Systems PCTV 520e @ 480 
Mbps (2013:0251, interface 0, class 0)
[  133.468343] em28xx 1-1.1:1.0: Audio interface 0 found (Vendor Class)
[  133.474549] em28xx 1-1.1:1.0: Video interface 0 found: isoc
[  133.480107] em28xx 1-1.1:1.0: DVB interface 0 found: isoc
[  133.485572] em28xx 1-1.1:1.0: chip ID is em2884
[  133.816085] em28xx 1-1.1:1.0: EEPROM ID = 26 00 03 00, EEPROM hash = 
0x0dff3afa
[  133.816096] em28xx 1-1.1:1.0: EEPROM info:
[  133.816102] em28xx 1-1.1:1.0:        microcode start address = 
0x0004, boot configuration = 0x03
[  133.825210] em28xx 1-1.1:1.0:        I2S audio, 5 sample rates
[  133.825223] em28xx 1-1.1:1.0:        500mA max power
[  133.825229] em28xx 1-1.1:1.0:        Table at offset 0x39, 
strings=0x1aa0, 0x14ba, 0x1ace
[  133.825467] em28xx 1-1.1:1.0: Identified as PCTV QuatroStick nano 
(520e) (card=86)
[  133.825474] em28xx 1-1.1:1.0: Currently, V4L2 is not supported on 
this model
[  133.826871] em28xx 1-1.1:1.0: dvb set to isoc mode.
[  133.831978] usbcore: registered new interface driver em28xx
[  133.839161] em28xx 1-1.1:1.0: Binding audio extension
[  133.839175] em28xx 1-1.1:1.0: em28xx-audio.c: Copyright (C) 2006 
Markus Rechberger
[  133.839180] em28xx 1-1.1:1.0: em28xx-audio.c: Copyright (C) 2007-2016 
Mauro Carvalho Chehab
[  133.839238] em28xx 1-1.1:1.0: Endpoint 0x83 high-speed on intf 0 alt 
7 interval = 8, size 196
[  133.839243] em28xx 1-1.1:1.0: Number of URBs: 1, with 64 packets and 
192 size
[  133.839582] em28xx 1-1.1:1.0: Audio extension successfully initialized
[  133.839592] em28xx: Registered (Em28xx Audio Extension) extension
[  133.850876] WARNING: You are using an experimental version of the 
media stack.
                 As the driver is backported to an older kernel, it 
doesn't offer
                 enough quality for its usage in production.
                 Use it with care.
                Latest git patches (needed if you report a bug to 
linux-media@vger.kernel.org):
                 40eca140c404505c09773d1c6685d818cb55ab1a [media] 
mn88473: add DVB-T2 PLP support
                 bd361f5de2b338218c276d17a510701a16075deb Merge tag 
'v4.10-rc1' into patchwork
                 7ce7d89f48834cefece7804d38fc5d85382edf77 Linux 4.10-rc1
[  133.904216] em28xx: Registered (Em28xx dvb Extension) extension
[  133.913570] em28xx 1-1.1:1.0: Registering input extension
[  133.918431] em28xx 1-1.1:1.0: submit of audio urb failed (error=-90)
[  133.947980] Registered IR keymap rc-pinnacle-pctv-hd
[  133.948248] input: 1-1.1:1.0 IR as 
/devices/platform/dwc2_b/usb1/1-1/1-1.1/1-1.1:1.0/rc/rc0/input4
[  133.948451] rc rc0: 1-1.1:1.0 IR as 
/devices/platform/dwc2_b/usb1/1-1/1-1.1/1-1.1:1.0/rc/rc0
[  133.948860] em28xx 1-1.1:1.0: Input extension successfully initalized
[  133.948866] em28xx: Registered (Em28xx Input Extension) extension

Finally, there is no /dev/dvb/... created. I guess because of the

   [  133.918431] em28xx 1-1.1:1.0: submit of audio urb failed (error=-90)

message.

Can any1 help me with this?

regards

