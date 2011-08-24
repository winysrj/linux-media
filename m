Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55265 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab1HXSJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 14:09:02 -0400
Received: by fxh19 with SMTP id 19so1170359fxh.19
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2011 11:09:01 -0700 (PDT)
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: jasondong <jason.dong@ite.com.tw>
Subject: Re: [PATCH 1/1] Add driver support for ITE IT9135 device
Date: Wed, 24 Aug 2011 20:08:57 +0200
Cc: linux-media@vger.kernel.org
References: <1312539895.2763.33.camel@Jason-Linux>
In-Reply-To: <1312539895.2763.33.camel@Jason-Linux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108242008.57903.a.miskiewicz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 05 of August 2011, jasondong wrote:
> This is DVB USB Linux driver for ITEtech IT9135 base USB TV module.
> It supported the IT9135 AX and BX chip versions.

Hi,

The quick review by crop@freenode was:

"I quick check it and didnt like much since it is not plitted logically 
correct, as usb-bridge, demod and tuner. now all are rather much one big 
blob".

so I guess you have to split it into pieces in a way other dvb drivers already 
in kernel tree are done. Unfortunately I don't know which existing driver is 
the best example on how to do things.

ps. are the IT9135 docs available anywhere?

ps2. on current linus 3.1 git + your 2 patches it is at least detected (cannot 
test more yet - no dbv-t signal here; it's to be available in incoming days)

[ 1152.752132] usb 2-2: new high speed USB device number 10 using ehci_hcd
[ 1152.820365] hub 2-0:1.0: unable to enumerate USB device on port 2
[ 1153.156792] hub 6-0:1.0: unable to enumerate USB device on port 2
[ 1157.056107] usb 2-1: new high speed USB device number 11 using ehci_hcd
[ 1157.192287] usb 2-1: New USB device found, idVendor=048d, idProduct=9005
[ 1157.192297] usb 2-1: New USB device strings: Mfr=1, Product=0, 
SerialNumber=3
[ 1157.192304] usb 2-1: Manufacturer: ITE Technologies, Inc.
[ 1157.192309] usb 2-1: SerialNumber: AF0102020700001
[ 1157.193145] dvb-usb: found a 'ITEtech USB2.0 DVB-T Recevier' in cold state, 
will try to load a firmware
[ 1157.196882] dvb-usb: downloading firmware from file 'dvb-usb-it9135.fw'
[ 1157.198578] IT9135: This is IT9135 chip v1
[ 1157.198678] IT9135: ~~~ .Fw file only include Omega1 firmware, Scripts1&2!!
[ 1157.198684] IT9135: =========================================
[ 1157.198689] IT9135: DRIVER_RELEASE_VERSION:    v11.08.02.1
[ 1157.198694] IT9135: FW_RELEASE_VERSION:        V1_0_26_2
[ 1157.198700] IT9135: API_RELEASE_VERSION:       203.20110426.0
[ 1157.198705] IT9135: =========================================
[ 1157.504659] IT9135: it9135_device_init success!!
[ 1157.504686] dvb-usb: found a 'ITEtech USB2.0 DVB-T Recevier' in warm state.
[ 1157.504708] dvb-usb: will pass the complete MPEG2 transport stream to the 
software demuxer.
[ 1157.505522] DVB: registering new adapter (ITEtech USB2.0 DVB-T Recevier)
[ 1157.506763] DVB: registering adapter 0 frontend 0 (IT9135 USB DVB-T)...
[ 1157.506920] dvb-usb: ITEtech USB2.0 DVB-T Recevier successfully initialized 
and connected.
-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
