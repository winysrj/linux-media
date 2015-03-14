Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62939 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbbCNTzK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 15:55:10 -0400
Message-ID: <5504920C.7080806@gmx.com>
Date: Sat, 14 Mar 2015 20:54:52 +0100
From: Ole Ernst <olebowle@gmx.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: nibble.max@gmail.com, crope@iki.fi, olli.salonen@iki.fi
Subject: cx23885: DVBSky S952 dvb_register failed err = -22
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

using linux-3.19.1-1 (Archlinux) I get the following output while
booting without the media-build-tree provided by DVBSky:

cx23885 driver version 0.0.4 loaded
cx23885 0000:04:00.0: enabling device (0000 -> 0002)
CORE cx23885[0]: subsystem: 4254:0952, board: DVBSky S952
[card=50,autodetected]
cx25840 3-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
cx25840 3-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
i2c i2c-2: m88ds3103_attach: chip_id=70
i2c i2c-2: Added multiplexed i2c bus 4
cx23885_dvb_register() dvb_register failed err = -22
cx23885_dev_setup() Failed to register dvb adapters on VID_B
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
i2c i2c-1: m88ds3103_attach: chip_id=70
i2c i2c-1: Added multiplexed i2c bus 4
cx23885_dvb_register() dvb_register failed err = -22
cx23885_dev_setup() Failed to register dvb on VID_C
cx23885_dev_checkrevision() Hardware revision = 0xa5
cx23885[0]/0: found at 0000:04:00.0, rev: 4, irq: 17, latency: 0, mmio:
0xf7200000

Obviously there are no device in /dev/dvb. Using the media-build-tree
works just fine though. The following firmware files are installed in
/usr/lib/firmware:
dvb-demod-m88ds3103.fw
dvb-demod-m88rs6000.fw
dvb-demod-si2168-a20-01.fw
dvb-demod-si2168-a30-01.fw
dvb-demod-si2168-b40-01.fw
dvb-fe-ds300x.fw
dvb-fe-ds3103.fw
dvb-fe-rs6000.fw
dvb-tuner-si2158-a20-01.fw

Output of lspci -vvvnn:
https://gist.githubusercontent.com/olebowle/6a4108363a9d1f7dd033/raw/lscpi

I also set the module parameters debug, i2c_debug, irq_debug and
irq_debug in cx23885.
The output is pretty verbose and can be found here:
https://gist.githubusercontent.com/olebowle/6a4108363a9d1f7dd033/raw/debug.log

Thanks,
Ole
