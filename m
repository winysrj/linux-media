Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55025 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab0JQPiM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 11:38:12 -0400
Received: by iwn35 with SMTP id 35so62845iwn.19
        for <linux-media@vger.kernel.org>; Sun, 17 Oct 2010 08:38:11 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 17 Oct 2010 11:38:07 -0400
Message-ID: <AANLkTi=LedNdgYkBa2Si3dpnnMDqPv=zr=AVx3GkM3GD@mail.gmail.com>
Subject: Proftuners S2-8000 support
From: "T. Taner" <tanerinux@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I have recently purchased Proftuners S2-8000 PCI-e card which consist of :

* CX23885 pci-e interface
* STB6100 Frontend
* STV0900 Demodulator

Vendor company supposed that card has Linux support via additional
patch in their support page. I applied patch to v4l-dvb and
s2-liplianin repositories. Patched source compiled and modules loaded
successfully, but it didn't work properly. I got mass of error
messages below, during launching VDR application.

Insructions: http://www.proftuners.com/driver8000.html
Patch: http://www.proftuners.com/sites/default/files/prof8000.patch

kernel.log
-----------------------------------
stv0900_search:
stv0900_algo
stv0900_set_symbol_rate: Mclk 4500000, SR 1000000, Dmd 0
stv0900_set_tuner: Frequency=1146000
stv0900_set_tuner: Bandwidth=72000000
stv0900_algo: NO AGC1, POWERI, POWERQ
Search Fail
stv0900_read_status:
stv0900_status: locked = 0
stv0900_get_mclk_freq: Calculated Mclk = 4500000
TS bitrate = 0 Mbit/sec
DEMOD LOCK FAIL
stv0900_search:
stv0900_algo
stv0900_set_symbol_rate: Mclk 4500000, SR 1000000, Dmd 0
stv0900_set_tuner: Frequency=1146000
stv0900_set_tuner: Bandwidth=72000000
stv0900_algo: NO AGC1, POWERI, POWERQ
Search Fail
stv0900_read_status:
stv0900_status: locked = 0
stv0900_get_mclk_freq: Calculated Mclk = 4500000
TS bitrate = 0 Mbit/sec
DEMOD LOCK FAIL
-----------------------------------

Here is the log messages during card has been detected:
-----------------------------------
Octt 16 17:27:39 localhost kernel: cx23885 driver version 0.0.2 loaded
Oct 16 17:27:39 localhost kernel: cx23885 0000:03:00.0: PCI INT A ->
Link[LN2A] -> GSI 18 (level, low) -> IRQ 18
Oct 16 17:27:39 localhost kernel: CORE cx23885[0]: subsystem:
8000:3034, board: Prof Revolution DVB-S2 8000 [card=29,autodetected]
Oct 16 17:03:34 localhost kernel: cx23885_dvb_register() allocating 1
frontend(s)
Oct 16 17:03:34 localhost kernel: cx23885[0]: cx23885 based dvb card
Oct 16 17:03:34 localhost kernel: stv0900_init_internal
Oct 16 17:03:34 localhost kernel: stv0900_init_internal: Create New
Internal Structure!
Oct 16 17:03:34 localhost kernel: stv0900_st_dvbs2_single
Oct 16 17:03:34 localhost kernel: stv0900_stop_all_s2_modcod
Oct 16 17:03:34 localhost kernel: stv0900_activate_s2_modcod_single
Oct 16 17:03:34 localhost kernel: stv0900_set_ts_parallel_serial
Oct 16 17:03:34 localhost kernel: stv0900_set_mclk: Mclk set to
135000000, Quartz = 27000000
Oct 16 17:03:34 localhost kernel: stv0900_get_mclk_freq: Calculated
Mclk = 4500000
Oct 16 17:03:34 localhost kernel: stv0900_get_mclk_freq: Calculated
Mclk = 4500000
Oct 16 17:03:34 localhost kernel: stv0900_attach: Attaching STV0900
demodulator(0)
Oct 16 17:03:34 localhost kernel: stb6100_attach: Attaching STB6100
Oct 16 17:03:34 localhost kernel: DVB: registering new adapter (cx23885[0])
Oct 16 17:03:34 localhost kernel: DVB: registering adapter 0 frontend
0 (STV0900 frontend)...
Oct 16 17:03:34 localhost kernel: cx23885_dev_checkrevision() Hardware
revision = 0xb0
Oct 16 17:03:34 localhost kernel: cx23885[0]/0: found at 0000:03:00.0,
rev: 2, irq: 18, latency: 0, mmio: 0xfbe00000
Oct 16 17:03:34 localhost kernel: cx23885 0000:03:00.0: setting
latency timer to 64
-----------------------------------

Kernel: 2.6.35  x64
Distro: Archlinux/Gentoo x64
App: VDR 1.7.16

Thanks.
