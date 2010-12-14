Return-path: <mchehab@gaivota>
Received: from smtp.work.de ([212.12.45.188]:48664 "EHLO smtp2.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab0LNSmD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 13:42:03 -0500
Message-ID: <4D07BA77.2050700@jusst.de>
Date: Tue, 14 Dec 2010 19:41:59 +0100
From: Julian Scheel <julian@jusst.de>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-2200 analog
References: <4CFE14A1.3040801@jusst.de> <1291726869.2073.5.camel@morgan.silverblock.net> <4D07A829.6080406@jusst.de>
In-Reply-To: <4D07A829.6080406@jusst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Am 14.12.2010 18:23, schrieb Julian Scheel:
> Am 07.12.2010 14:01, schrieb Andy Walls:
>> It appears to be in the media_tree.git repository on the
>> staging/for_v2.6.37-rc1 branch:
>>
>> http://git.linuxtv.org/media_tree.git?a=tree;f=drivers/media/video/saa7164;h=0acaa4ada45ae6881bfbb19447ae9db43f06ef9b;hb=staging/for_v2.6.37-rc1 
>>
>>
>> saa7164-cards.c appears to have analog entries added for HVR-2200's and
>> saa7164-encoder.c has a number of V4L ioctl()'s for MPEG streams.
> Is there any reason, why the additional card-information found here:
> http://www.kernellabs.com/hg/~stoth/saa7164-dev/
> is not yet in the kernel tree?

Actually after manually adding this changeset into linux-26.37-rc5 tree 
the card is detected and dmesg says:

[    3.653289] saa7164 driver loaded
[    3.653340] saa7164 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
[    3.654909] CORE saa7164[0]: subsystem: 0070:8940, board: Hauppauge 
WinTV-HVR2200 [card=9,autodetected]
[    3.654914] saa7164[0]/0: found at 0000:02:00.0, rev: 129, irq: 16, 
latency: 0, mmio: 0xfb000000
[    3.654919] saa7164 0000:02:00.0: setting latency timer to 64
[    3.813647] saa7164_downloadfirmware() no first image
[    3.814781] saa7164_downloadfirmware() Waiting for firmware upload 
(NXP7164-2010-03-10.1.fw)
[    3.839841] saa7164_downloadfirmware() firmware read 4019072 bytes.
[    3.839843] saa7164_downloadfirmware() firmware loaded.
[    3.839844] Firmware file header part 1:
[    3.839846]  .FirmwareSize = 0x0
[    3.839847]  .BSLSize = 0x0
[    3.839848]  .Reserved = 0x3d538
[    3.839849]  .Version = 0x3
[    3.839850] saa7164_downloadfirmware() SecBootLoader.FileSize = 4019072
[    3.839856] saa7164_downloadfirmware() FirmwareSize = 0x1fd6
[    3.839857] saa7164_downloadfirmware() BSLSize = 0x0
[    3.839858] saa7164_downloadfirmware() Reserved = 0x0
[    3.839860] saa7164_downloadfirmware() Version = 0x1661c00
[   10.693325] saa7164_downloadimage() Image downloaded, booting...
[   10.797316] saa7164_downloadimage() Image booted successfully.
[   10.797332] starting firmware download(2)
[   13.425188] saa7164_downloadimage() Image downloaded, booting...
[   15.089109] saa7164_downloadimage() Image booted successfully.
[   15.089128] firmware download complete.
[   15.129700] tveeprom 1-0000: Hauppauge model 89619, rev D3F2, serial# 
7259796
[   15.129703] tveeprom 1-0000: MAC address is 00:0d:fe:6e:c6:94
[   15.129704] tveeprom 1-0000: tuner model is NXP 18271C2_716x (idx 
152, type 4)
[   15.129707] tveeprom 1-0000: TV standards PAL(B/G) NTSC(M) PAL(I) 
SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
[   15.129709] tveeprom 1-0000: audio processor is SAA7164 (idx 43)
[   15.129710] tveeprom 1-0000: decoder processor is SAA7164 (idx 40)
[   15.129711] tveeprom 1-0000: has radio
[   15.129712] saa7164[0]: Hauppauge eeprom: model=89619
[   15.189491] tda18271 2-0060: creating new instance
[   15.194156] TDA18271HD/C2 detected @ 2-0060
[   15.446842] DVB: registering new adapter (saa7164)
[   15.446845] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN 
DVB-T)...
[   15.477568] tda18271 3-0060: creating new instance
[   15.482514] TDA18271HD/C2 detected @ 3-0060
[   15.733973] tda18271: performing RF tracking filter calibration
[   18.082962] tda18271: RF tracking filter calibration complete
[   18.083552] DVB: registering new adapter (saa7164)
[   18.083554] DVB: registering adapter 1 frontend 0 (NXP TDA10048HN 
DVB-T)...

dvb-devices are registered, but no video-devices. Any thoughts?
