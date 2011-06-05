Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62305 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1FEAfP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jun 2011 20:35:15 -0400
Received: by wya21 with SMTP id 21so2095247wya.19
        for <linux-media@vger.kernel.org>; Sat, 04 Jun 2011 17:35:14 -0700 (PDT)
Message-ID: <4DEACF3F.9090305@gmail.com>
Date: Sun, 05 Jun 2011 03:35:11 +0300
From: Mehmet Altan Pire <baybesteci@gmail.com>
MIME-Version: 1.0
To: tvboxspy@gmail.com, linux-media@vger.kernel.org
CC: linux-media@vger.kernel.org
Subject: DM04 USB DVB-S TUNER
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
I have "DM04 USB DVBS TUNER", using ubuntu with v4l media-build
drivers/modules but device  doesn't working (unknown device).

lsusb message:
ID 3344:22f0

under of the box:
DM04P2011050176

dmesg message:

[ 1930.244086] usb 1-8: new high speed USB device using ehci_hcd and
address 4
[ 1930.377256] usb 1-8: config 1 interface 0 altsetting 1 bulk endpoint
0x81 has invalid maxpacket 64
[ 1930.377270] usb 1-8: config 1 interface 0 altsetting 1 bulk endpoint
0x1 has invalid maxpacket 64
[ 1930.377280] usb 1-8: config 1 interface 0 altsetting 1 bulk endpoint
0x2 has invalid maxpacket 64
[ 1930.377291] usb 1-8: config 1 interface 0 altsetting 1 bulk endpoint
0x8A has invalid maxpacket 64


lsmod |grep dm04 message:

dvb_usb_lmedm04        19257  0
dvb_usb                18412  1 dvb_usb_lmedm04
dvb_core               87702  2 dvb_usb_lmedm04,dvb_usb
rc_core                17755  2 dvb_usb_lmedm04,dvb_usb

please help me, thanks...
