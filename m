Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57898 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758987AbbBHURl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Feb 2015 15:17:41 -0500
MIME-Version: 1.0
Message-ID: <trinity-50c1b2fb-3f4b-43e8-9eae-85e905ff7834-1423426659156@3capp-gmx-bs34>
From: =?UTF-8?Q?=22Sebastian_S=C3=BCsens=22?= <S.Suesens@gmx.de>
To: linux-media@vger.kernel.org
Subject: TechnoTrend TT-TVStick CT2-4400v2 no firmware load
Content-Type: text/plain; charset=UTF-8
Date: Sun, 8 Feb 2015 21:17:39 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I use kernel 3.13.0 and the media_build "4e1a67e4a6c8ab71f416ea32059c92171407ba5d".

I get following messages by dmesg:

[ 1543.444128] usb 2-4: new high-speed USB device number 4 using ehci-pci
[ 1543.577069] usb 2-4: New USB device found, idVendor=0b48, idProduct=3014
[ 1543.577088] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 1543.577098] usb 2-4: Product: TechnoTrend USB-Stick
[ 1543.577106] usb 2-4: Manufacturer: CityCom GmbH
[ 1543.577114] usb 2-4: SerialNumber: 20131128
[ 1543.764126] usb 2-4: dvb_usb_v2: found a 'TechnoTrend TVStick CT2-4400' in warm state
[ 1543.764317] usb 2-4: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
[ 1543.764387] DVB: registering new adapter (TechnoTrend TVStick CT2-4400)
[ 1543.765811] usb 2-4: dvb_usb_v2: MAC address: bc:ea:2b:44:02:7c
[ 1543.772724] i2c i2c-2: Added multiplexed i2c bus 3
[ 1543.772734] si2168 2-0064: Silicon Labs Si2168 successfully attached
[ 1543.777532] si2157 3-0060: Silicon Labs Si2147/2148/2157/2158 successfully attached
[ 1543.777579] usb 2-4: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
[ 1543.777824] Registered IR keymap rc-tt-1500
[ 1543.778051] input: TechnoTrend TVStick CT2-4400 as /devices/pci0000:00/0000:00:13.2/usb2/2-4/rc/rc0/input18
[ 1543.778368] rc0: TechnoTrend TVStick CT2-4400 as /devices/pci0000:00/0000:00:13.2/usb2/2-4/rc/rc0
[ 1543.778382] usb 2-4: dvb_usb_v2: schedule remote query interval to 300 msecs
[ 1543.778396] usb 2-4: dvb_usb_v2: 'TechnoTrend TVStick CT2-4400' successfully initialized and connected

I see no message about the firmware loading is this correct?
