Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53558 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbbCXMZS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 08:25:18 -0400
Message-ID: <551157AB.1090704@gmx.com>
Date: Tue, 24 Mar 2015 13:25:15 +0100
From: Ole Ernst <olebowle@gmx.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, Nibble Max <nibble.max@gmail.com>
CC: "olli.salonen" <olli.salonen@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: cx23885: DVBSky S952 dvb_register failed err = -22
References: <5504920C.7080806@gmx.com>, <55055E66.6040600@gmx.com>, <550563B2.9010306@iki.fi>, <201503170953368436904@gmail.com> <201503180940386096906@gmail.com> <55093FFC.9050602@gmx.com> <55105683.40809@iki.fi> <551081CF.3080901@gmx.com> <5510992C.8060608@iki.fi>
In-Reply-To: <5510992C.8060608@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Annti,

I generated a patch using git diff 8a56b6b..5786103 on your branch and
applied it to the current media_build tree, because I'm more experienced
with it as compared to building my own kernels. After installing it, I
removed m88ts2022.ko.gz shipped with my kernel and ran depmod -a. After
a power-down/up cycle I can see
/dev/dvb/adapter{0,1}/{demux,dvr,frontend,net}0. Unfortunately the
frontends time out while tunning to a channel.

Mär 24 10:32:54 htpc kernel: cx23885 driver version 0.0.4 loaded
Mär 24 10:32:54 htpc kernel: cx23885 0000:04:00.0: enabling device (0000
-> 0002)
Mär 24 10:32:54 htpc kernel: CORE cx23885[0]: subsystem: 4254:0952,
board: DVBSky S952 [card=50,autodetected]
Mär 24 10:32:54 htpc kernel: cx25840 3-0044: cx23885 A/V decoder found @
0x88 (cx23885[0])
Mär 24 10:32:55 htpc kernel: cx25840 3-0044: loaded
v4l-cx23885-avcore-01.fw firmware (16382 bytes)
Mär 24 10:32:55 htpc kernel: cx23885_dvb_register() allocating 1 frontend(s)
Mär 24 10:32:55 htpc kernel: cx23885[0]: cx23885 based dvb card
Mär 24 10:32:55 htpc kernel: i2c i2c-2: m88ds3103_attach: chip_id=70
Mär 24 10:32:55 htpc kernel: i2c i2c-2: Added multiplexed i2c bus 4
Mär 24 10:32:55 htpc kernel: ts2020 4-0060: Montage Technology TS2020
successfully identified
Mär 24 10:32:55 htpc kernel: DVB: registering new adapter (cx23885[0])
Mär 24 10:32:55 htpc kernel: cx23885 0000:04:00.0: DVB: registering
adapter 0 frontend 0 (Montage M88DS3103)...
Mär 24 10:32:55 htpc kernel: DVBSky S952 port 1 MAC address:
ff:ff:ff:ff:ff:ff
Mär 24 10:32:55 htpc kernel: cx23885_dvb_register() allocating 1 frontend(s)
Mär 24 10:32:55 htpc kernel: cx23885[0]: cx23885 based dvb card
Mär 24 10:32:55 htpc kernel: i2c i2c-1: m88ds3103_attach: chip_id=70
Mär 24 10:32:55 htpc kernel: i2c i2c-1: Added multiplexed i2c bus 5
Mär 24 10:32:55 htpc kernel: ts2020 5-0060: Montage Technology TS2020
successfully identified
Mär 24 10:32:55 htpc kernel: DVB: registering new adapter (cx23885[0])
Mär 24 10:32:55 htpc kernel: cx23885 0000:04:00.0: DVB: registering
adapter 1 frontend 0 (Montage M88DS3103)...
Mär 24 10:32:55 htpc kernel: DVBSky S952 port 2 MAC address:
ff:ff:ff:ff:ff:ff
Mär 24 10:32:55 htpc kernel: cx23885_dev_checkrevision() Hardware
revision = 0xa5
Mär 24 10:32:55 htpc kernel: cx23885[0]/0: found at 0000:04:00.0, rev:
4, irq: 17, latency: 0, mmio: 0xf7200000
Mär 24 10:32:59 htpc vdr[387]: [387] frontend 0/0 provides DVB-S,DVB-S2
with QPSK ("Montage M88DS3103")
Mär 24 10:32:59 htpc vdr[387]: [387] frontend 1/0 provides DVB-S,DVB-S2
with QPSK ("Montage M88DS3103")
Mär 24 10:32:59 htpc vdr[387]: [387] found 2 DVB devices
Mär 24 10:33:13 htpc vdr[387]: [406] frontend 0/0 timed out while tuning
to channel 2 (ZDF HD), tp 111361
Mär 24 10:33:40 htpc vdr[387]: [387] switching to channel 1 (Das Erste HD)
Mär 24 10:33:50 htpc vdr[387]: [406] frontend 0/0 timed out while tuning
to channel 1 (Das Erste HD), tp 111493
Mär 24 10:34:14 htpc vdr[387]: [387] switching to channel 2 (ZDF HD)
Mär 24 10:34:24 htpc vdr[387]: [406] frontend 0/0 timed out while tuning
to channel 2 (ZDF HD), tp 111361

This is what the output of the media-build-tree from dvbsky.net looks like:

Mär 24 10:41:30 htpc kernel: cx23885 driver version 0.0.4 loaded
Mär 24 10:41:30 htpc kernel: cx23885 0000:04:00.0: enabling device (0000
-> 0002)
Mär 24 10:41:30 htpc kernel: CORE cx23885[0]: subsystem: 4254:0952,
board: DVBSky S952 [card=50,autodetected]
Mär 24 10:41:30 htpc kernel: cx25840 3-0044: cx23885 A/V decoder found @
0x88 (cx23885[0])
Mär 24 10:41:31 htpc kernel: cx25840 3-0044: loaded
v4l-cx23885-avcore-01.fw firmware (16382 bytes)
Mär 24 10:41:31 htpc kernel: cx23885_dvb_register() allocating 1 frontend(s)
Mär 24 10:41:31 htpc kernel: cx23885[0]: cx23885 based dvb card
Mär 24 10:41:31 htpc kernel: DS3000 chip version: d0 attached.
Mär 24 10:41:31 htpc kernel: TS202x chip version[1]: 80 attached.
Mär 24 10:41:31 htpc kernel: TS202x chip version[2]: 81 attached.
Mär 24 10:41:31 htpc kernel: m88ds3103_load_firmware: Waiting for
firmware upload (dvb-fe-ds3103.fw)...
Mär 24 10:41:31 htpc kernel: m88ds3103_load_firmware: Waiting for
firmware upload(2)...
Mär 24 10:41:32 htpc kernel: DVB: registering new adapter (cx23885[0])
Mär 24 10:41:32 htpc kernel: cx23885 0000:04:00.0: DVB: registering
adapter 0 frontend 0 (Montage DS3103/TS2022)...
Mär 24 10:41:32 htpc kernel: DVBSky S952 port 1 MAC address:
ff:ff:ff:ff:ff:ff
Mär 24 10:41:32 htpc kernel: cx23885_dvb_register() allocating 1 frontend(s)
Mär 24 10:41:32 htpc kernel: cx23885[0]: cx23885 based dvb card
Mär 24 10:41:32 htpc kernel: DS3000 chip version: d0 attached.
Mär 24 10:41:32 htpc kernel: TS202x chip version[1]: 80 attached.
Mär 24 10:41:32 htpc kernel: TS202x chip version[2]: 81 attached.
Mär 24 10:41:32 htpc kernel: m88ds3103_load_firmware: Waiting for
firmware upload (dvb-fe-ds3103.fw)...
Mär 24 10:41:32 htpc kernel: m88ds3103_load_firmware: Waiting for
firmware upload(2)...
Mär 24 10:41:33 htpc kernel: DVB: registering new adapter (cx23885[0])
Mär 24 10:41:33 htpc kernel: cx23885 0000:04:00.0: DVB: registering
adapter 1 frontend 0 (Montage DS3103/TS2022)...
Mär 24 10:41:33 htpc kernel: DVBSky S952 port 2 MAC address:
ff:ff:ff:ff:ff:ff
Mär 24 10:41:33 htpc kernel: cx23885_dev_checkrevision() Hardware
revision = 0xa5
Mär 24 10:41:33 htpc kernel: cx23885[0]/0: found at 0000:04:00.0, rev:
4, irq: 17, latency: 0, mmio: 0xf7200000
Mär 24 10:41:35 htpc vdr[384]: [384] frontend 0/0 provides DVB-S,DVB-S2
with QPSK ("Montage DS3103/TS2022")
Mär 24 10:41:35 htpc vdr[384]: [384] frontend 1/0 provides DVB-S,DVB-S2
with QPSK ("Montage DS3103/TS2022")
Mär 24 10:41:35 htpc vdr[384]: [384] found 2 DVB devices
Mär 24 10:41:40 htpc vdr[384]: [384] switching to channel 2 (ZDF HD)
Mär 24 10:43:16 htpc vdr[384]: [384] switching to channel 1 (Das Erste HD)

It looks as if the firmware dvb-fe-ds3103.fw is not getting downloaded
with your patch. I thought there shouldn't be nodes in /dev/dvb/ in this
case?
To roll back I reinstalled the old tree, moving the original
m88ts2022.ko.gz back in and running depmod -a. Rebooting didn't bring
the S952 up, it said:

Mär 24 10:39:07 htpc kernel: Unable to find Montage chip
Mär 24 10:39:07 htpc kernel: cx23885[0]: frontend initialization failed
Mär 24 10:39:07 htpc kernel: cx23885_dvb_register() dvb_register failed
err = -22
Mär 24 10:39:07 htpc kernel: cx23885_dev_setup() Failed to register dvb
adapters on VID_B

So maybe it left it in a strange/undefined state? I had to poweroff the
machine and start from there. Afterwards everything is fine again.

Thanks,
Ole

Am 23.03.2015 um 23:52 schrieb Antti Palosaari:
> On 03/23/2015 11:12 PM, Ole Ernst wrote:
>> Very much appreciated, thanks Antti! Let me know, if you need someone to
>> test your patches.
> 
> Could you test that tree?
> http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=ts2020
> 
> git clone -b ts2020 git://linuxtv.org/anttip/media_tree.git
> 
> then compile and install whole kernel
> 
> regards
> Antti
