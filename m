Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:62652 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3AHVKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 16:10:20 -0500
Received: by mail-ie0-f169.google.com with SMTP id c14so1171841ieb.0
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2013 13:10:20 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?Q?C=C3=A9dric_Girard?= <girard.cedric@gmail.com>
Date: Tue, 8 Jan 2013 22:02:20 +0100
Message-ID: <CA+rnASviBDZVk9KJPYD1jLoHUbeyWwL+D5oSyvYVHKZFOSUAkw@mail.gmail.com>
Subject: No Signal with TerraTec Cinergy T PCIe dual
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Since a few weeks, I am unable to use my TerraTec Cinergy T PCIe dual
card anymore. On the kernel and drivers side, everything seems to be
working as expected but I get no signal from any channel.

It used to work and I have done too many updates recently to be able
to pinpoint to from which point it stopped to work.
Plugging the same cable to my TV tuner I get perfect reception so no
change in signal quality.

I am running Arch Linux with linux 3.7.1 on an x86_64 architecture.

Following are some logs.

Kernel logs when loading cx23885 module:
###
[93752.708088] cx23885 driver version 0.0.3 loaded
[93752.708954] CORE cx23885[0]: subsystem: 153b:117e, board: TerraTec
Cinergy T PCIe Dual [card=34,autodetected]
[93752.847421] cx25840 12-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
[93753.502291] cx25840 12-0044: loaded v4l-cx23885-avcore-01.fw
firmware (16382 bytes)
[93753.518236] cx23885_dvb_register() allocating 1 frontend(s)
[93753.518242] cx23885[0]: cx23885 based dvb card
[93753.533378] drxk: status = 0x639160d9
[93753.533383] drxk: detected a drx-3916k, spin A3, xtal 20.250 MHz
[93753.606391] DRXK driver version 0.9.4300
[93753.630635] drxk: frontend initialized.
[93753.667152] mt2063_attach: Attaching MT2063
[93753.667156] DVB: registering new adapter (cx23885[0])
[93753.667161] cx23885 0000:03:00.0: DVB: registering adapter 0
frontend 0 (DRXK DVB-T)...
[93753.670728] cx23885_dvb_register() allocating 1 frontend(s)
[93753.670732] cx23885[0]: cx23885 based dvb card
[93753.686602] drxk: status = 0x639130d9
[93753.686605] drxk: detected a drx-3913k, spin A3, xtal 20.250 MHz
[93753.759577] DRXK driver version 0.9.4300
[93753.783845] drxk: frontend initialized.
[93753.783852] mt2063_attach: Attaching MT2063
[93753.783854] DVB: registering new adapter (cx23885[0])
[93753.783858] cx23885 0000:03:00.0: DVB: registering adapter 1
frontend 0 (DRXK DVB-C DVB-T)...
[93753.784284] cx23885_dev_checkrevision() Hardware revision = 0xa5
[93753.784290] cx23885[0]/0: found at 0000:03:00.0, rev: 4, irq: 18,
latency: 0, mmio: 0xfb800000
###

Kernel logs when scanning
###
[93853.705675] mt2063: detected a mt2063 B3
###

"femon -H -a0" output:
###
FE: DRXK DVB-T (DVBT)
Problem retrieving frontend information: Resource temporarily unavailable
status SCV   | signal  49% | snr   0% | ber 2014507767 | unc 1 |
###

Meaningful bits of an strace of the same command
###
ioctl(3, FE_READ_STATUS, 0x7fff69172ef0) = 0
ioctl(3, FE_READ_BER, 0x7fff69173018)   = -1 EAGAIN (Resource
temporarily unavailable)
ioctl(3, FE_READ_SIGNAL_STRENGTH, 0x7fff6917301c) = -1 EAGAIN
(Resource temporarily unavailable)
ioctl(3, FE_READ_SNR, 0x7fff6917301e)   = -1 EAGAIN (Resource
temporarily unavailable)
ioctl(3, FE_READ_UNCORRECTED_BLOCKS, 0x7fff69173020) = -1 EAGAIN
(Resource temporarily unavailable)
###

w_scan give "no signal" result.
dvbscan give "Unable to query frontend status"

Any hint to where I should look would be welcome!

Regards,

--
Cédric Girard
