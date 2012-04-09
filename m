Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47290 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2DILle (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2012 07:41:34 -0400
Received: by wejx9 with SMTP id x9so2573919wej.19
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2012 04:41:32 -0700 (PDT)
Message-ID: <4F82CAEA.9030509@users.sourceforge.net>
Date: Mon, 09 Apr 2012 14:41:30 +0300
From: Alberto Mardegan <mardy@users.sourceforge.net>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Terratec Cinergy T XS
Content-Type: multipart/mixed;
 boundary="------------090504040407030708000807"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090504040407030708000807
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,
   I have the DVB-T USB stick written in the subject (ID 0ccd:0043), and 
I'd like to make it work with Linux.
The current version of the em28xx driver (both in the Linux kernel and 
in the media_tree git) gives an error after loading the firmware, as 
reported here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/460636

I modified the source so that the driver sets the read_not_reliable bit 
in the xc2028_ctrl structure, and that seems to help in getting past the 
firmware error. However, the /dev/dvb device is not created.
Since I'm new to DVB and V4L, can someone give me some hints on what 
could be going wrong?

I'm attaching the dmesg output after inserting the device.

Ciao,
   Alberto

--------------090504040407030708000807
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

[ 3514.238137] usb 1-1.3: new high speed USB device using ehci_hcd and address 5
[ 3514.379164] em28xx: New device TerraTec Electronic GmbH Cinergy T USB XS @ 480 Mbps (0ccd:0043, interface 0, class 0)
[ 3514.379167] em28xx: Video interface 0 found
[ 3514.379168] em28xx: DVB interface 0 found
[ 3514.379268] em28xx #0: chip ID is em2870
[ 3514.525653] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 43 00 c0 12 81 00 6a 24 8e 34
[ 3514.525668] em28xx #0: i2c eeprom 10: 00 00 06 57 02 0c 00 00 00 00 00 00 00 00 00 00
[ 3514.525681] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 01 00 00 00 00 00 5b 00 00 00
[ 3514.525693] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 06 c1 66 49
[ 3514.525706] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 3514.525718] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 3514.525730] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 43 00 69 00
[ 3514.525743] em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 20 00 54 00 20 00
[ 3514.525755] em28xx #0: i2c eeprom 80: 55 00 53 00 42 00 20 00 58 00 53 00 00 00 34 03
[ 3514.525767] em28xx #0: i2c eeprom 90: 54 00 65 00 72 00 72 00 61 00 54 00 65 00 63 00
[ 3514.525780] em28xx #0: i2c eeprom a0: 20 00 45 00 6c 00 65 00 63 00 74 00 72 00 6f 00
[ 3514.525792] em28xx #0: i2c eeprom b0: 6e 00 69 00 63 00 20 00 47 00 6d 00 62 00 48 00
[ 3514.525804] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 3514.525816] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 3514.525828] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 3514.525841] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 3514.525855] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x084c44df
[ 3514.525857] em28xx #0: EEPROM info:
[ 3514.525860] em28xx #0:	No audio on board.
[ 3514.525862] em28xx #0:	500mA max power
[ 3514.525865] em28xx #0:	Table at 0x06, strings=0x246a, 0x348e, 0x0000
[ 3514.527026] em28xx #0: Identified as Terratec Cinergy T XS (card=43)
[ 3514.527030] em28xx #0: 
[ 3514.527031] 
[ 3514.527034] em28xx #0: The support for this board weren't valid yet.
[ 3514.527037] em28xx #0: Please send a report of having this working
[ 3514.527039] em28xx #0: not to V4L mailing list (and/or to other addresses)
[ 3514.527041] 
[ 3514.532371] Chip ID is not zero. It is not a TEA5767
[ 3514.532536] tuner 17-0060: Tuner -1 found with type(s) Radio TV.
[ 3514.532683] xc2028 17-0060: creating new instance
[ 3514.532687] xc2028 17-0060: type set to XCeive xc2028/xc3028 tuner
[ 3514.535211] xc2028 17-0060: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 3514.587148] xc2028 17-0060: Loading firmware for type=BASE (1), id 0000000000000000.
[ 3515.676546] xc2028 17-0060: Loading firmware for type=(0), id 000000000000b700.
[ 3515.693610] SCODE (20000000), id 000000000000b700:
[ 3515.693617] xc2028 17-0060: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
[ 3515.824193] em28xx #0: v4l2 driver version 0.1.3
[ 3515.884068] xc2028 17-0060: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[ 3516.983649] (0), id 00000000000000ff:
[ 3516.983655] xc2028 17-0060: Loading firmware for type=(0), id 0000000100000007.
[ 3517.000627] xc2028 17-0060: Loading SCODE for type=MONO SCODE HAS_IF_5320 (60008000), id 0000000f00000007.
[ 3517.136140] em28xx #0: V4L2 video device registered as video1
[ 3517.137403] usbcore: registered new interface driver em28xx


--------------090504040407030708000807--
