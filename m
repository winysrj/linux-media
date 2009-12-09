Return-path: <linux-media-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([62.179.121.38]:19467 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926AbZLIUzx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 15:55:53 -0500
Message-ID: <4B200ED9.8050806@waechter.wiz.at>
Date: Wed, 09 Dec 2009 21:55:53 +0100
From: =?UTF-8?B?TWF0dGhpYXMgV8OkY2h0ZXI=?= <matthias@waechter.wiz.at>
MIME-Version: 1.0
To: Newsy Paper <newspaperman_germany@yahoo.com>
CC: linux-media@vger.kernel.org
Subject: Re: no locking on dvb-s2 22000 2/3 8PSK transponder on Astra 19.2E
 with tt s2-3200
References: <211341.40316.qm@web23206.mail.ird.yahoo.com>
In-Reply-To: <211341.40316.qm@web23206.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 09.12.2009 21:15, schrieb Newsy Paper:
> no matter if I use Igors or Manus driver, there's no lock on 11303 h 22000 2/3 8psk. Other users at vdr-portal report same problem.
> The strange thing is that all other transponders that use 22000 2/3 8psk do work but this transponder doesn't. It worked fine until december 3rd when uplink moved to Vienna. I think they changed a parameter like rolloff or inversion and the dvb-s2 part of stb6100 is buggy.

Reviewing the code and having enabled debugging options for stb6100, I
am puzzled about the high bandwidth values.

I thought that the bandwidth of the frontend would always be around the
bandwidth of the transponder, plus some minimum locking range. 11303h is
a 26 MHz transponder, so I wonder about the excess in bandwidth: 39.7
MHz is requested, 40 MHz bandwidth is the result. I would expect a value
of 22 MSps * (1+0.35) Hz/S = 29.7 MHz (which is more than the
transponder’s 26 MHz, though ?) but less than 40 MHz as in the example
below. If too much bandwidth hits the decoder, it may be facing aliasing
from neighbor channels, but I don’t know if that is the root cause of
the problems. This is http://jusst.de/hg/v4l-dvb/ as advised by Manu.

Tuning to a 27.500 MSps transponder results in a whoppin’ 62 MHz
bandwidth setting. Is this reasonable?

>  kernel: stb6100_set_bandwidth: set bandwidth to 39700000 Hz
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [9:1]
>  kernel: stb6100_write_reg_range:         FCCK: 0x4d
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [6:1]
>  kernel: stb6100_write_reg_range:         F: 0xcf
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [9:1]
>  kernel: stb6100_write_reg_range:         FCCK: 0x0d
>  kernel: stb6100_read_regs:     Read from 0x60
>  kernel: stb6100_read_regs:         LD: 0x81
>  kernel: stb6100_read_regs:         VCO: 0x64
>  kernel: stb6100_read_regs:         NI: 0x34
>  kernel: stb6100_read_regs:         NF: 0x2f
>  kernel: stb6100_read_regs:         K: 0x3d
>  kernel: stb6100_read_regs:         G: 0x39
>  kernel: stb6100_read_regs:         F: 0xcf
>  kernel: stb6100_read_regs:         DLB: 0xdc
>  kernel: stb6100_read_regs:         TEST1: 0x8f
>  kernel: stb6100_read_regs:         FCCK: 0x0d
>  kernel: stb6100_read_regs:         LPEN: 0xfb
>  kernel: stb6100_read_regs:         TEST3: 0xde
>  kernel: stb6100_get_bandwidth: bandwidth = 40000000 Hz
>  kernel: stb6100_read_regs:     Read from 0x60
>  kernel: stb6100_read_regs:         LD: 0x81
>  kernel: stb6100_read_regs:         VCO: 0x64
>  kernel: stb6100_read_regs:         NI: 0x34
>  kernel: stb6100_read_regs:         NF: 0x2f
>  kernel: stb6100_read_regs:         K: 0x3d
>  kernel: stb6100_read_regs:         G: 0x39
>  kernel: stb6100_read_regs:         F: 0xcf
>  kernel: stb6100_read_regs:         DLB: 0xdc
>  kernel: stb6100_read_regs:         TEST1: 0x8f
>  kernel: stb6100_read_regs:         FCCK: 0x0d
>  kernel: stb6100_read_regs:         LPEN: 0xfb
>  kernel: stb6100_read_regs:         TEST3: 0xde
>  kernel: stb6100_set_frequency: Get frontend parameters
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [1:11]
>  kernel: stb6100_write_reg_range:         VCO: 0x64
>  kernel: stb6100_write_reg_range:         NI: 0x34
>  kernel: stb6100_write_reg_range:         NF: 0x2f
>  kernel: stb6100_write_reg_range:         K: 0x3d
>  kernel: stb6100_write_reg_range:         G: 0x39
>  kernel: stb6100_write_reg_range:         F: 0xcf
>  kernel: stb6100_write_reg_range:         DLB: 0xdc
>  kernel: stb6100_write_reg_range:         TEST1: 0x8f
>  kernel: stb6100_write_reg_range:         FCCK: 0x0d
>  kernel: stb6100_write_reg_range:         LPEN: 0xeb
>  kernel: stb6100_write_reg_range:         TEST3: 0xde
>  kernel: stb6100_set_frequency: frequency = 1552000, srate = 22000000, g = 9, odiv = 0, psd2 = 1, fxtal = 27000, osm = 6, fvco = 3104000, N(I) = 57, N(F) = 247
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [1:11]
>  kernel: stb6100_write_reg_range:         VCO: 0xe6
>  kernel: stb6100_write_reg_range:         NI: 0x39
>  kernel: stb6100_write_reg_range:         NF: 0xf7
>  kernel: stb6100_write_reg_range:         K: 0x3c
>  kernel: stb6100_write_reg_range:         G: 0x39
>  kernel: stb6100_write_reg_range:         F: 0xcf
>  kernel: stb6100_write_reg_range:         DLB: 0xdc
>  kernel: stb6100_write_reg_range:         TEST1: 0x8f
>  kernel: stb6100_write_reg_range:         FCCK: 0x4d
>  kernel: stb6100_write_reg_range:         LPEN: 0xeb
>  kernel: stb6100_write_reg_range:         TEST3: 0xde
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [10:1]
>  kernel: stb6100_write_reg_range:         LPEN: 0xfb
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [1:1]
>  kernel: stb6100_write_reg_range:         VCO: 0x86
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [1:1]
>  kernel: stb6100_write_reg_range:         VCO: 0x66
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [1:9]
>  kernel: stb6100_write_reg_range:         VCO: 0x66
>  kernel: stb6100_write_reg_range:         NI: 0x39
>  kernel: stb6100_write_reg_range:         NF: 0xf7
>  kernel: stb6100_write_reg_range:         K: 0x3c
>  kernel: stb6100_write_reg_range:         G: 0x39
>  kernel: stb6100_write_reg_range:         F: 0xcf
>  kernel: stb6100_write_reg_range:         DLB: 0xdc
>  kernel: stb6100_write_reg_range:         TEST1: 0x8f
>  kernel: stb6100_write_reg_range:         FCCK: 0x0d
>  kernel: stb6100_read_regs:     Read from 0x60
>  kernel: stb6100_read_regs:         LD: 0x81
>  kernel: stb6100_read_regs:         VCO: 0x66
>  kernel: stb6100_read_regs:         NI: 0x39
>  kernel: stb6100_read_regs:         NF: 0xf7
>  kernel: stb6100_read_regs:         K: 0x3c
>  kernel: stb6100_read_regs:         G: 0x39
>  kernel: stb6100_read_regs:         F: 0xcf
>  kernel: stb6100_read_regs:         DLB: 0xdc
>  kernel: stb6100_read_regs:         TEST1: 0x8f
>  kernel: stb6100_read_regs:         FCCK: 0x0d
>  kernel: stb6100_read_regs:         LPEN: 0xfb
>  kernel: stb6100_read_regs:         TEST3: 0xde
>  kernel: stb6100_get_frequency: frequency = 1552025 kHz, odiv = 0, psd2 = 1, fxtal = 27000 kHz, fvco = 3104050 kHz, N(I) = 57, N(F) = 247
>  vdr: [24313] frontend 0 timed out while tuning to channel 1, tp 111302
>  kernel: stb6100_set_bandwidth: set bandwidth to 39700000 Hz
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [9:1]
>  kernel: stb6100_write_reg_range:         FCCK: 0x4d
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [6:1]
>  kernel: stb6100_write_reg_range:         F: 0xcf
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [9:1]
>  kernel: stb6100_write_reg_range:         FCCK: 0x0d
>  kernel: stb6100_read_regs:     Read from 0x60
>  kernel: stb6100_read_regs:         LD: 0x81
>  kernel: stb6100_read_regs:         VCO: 0x66
>  kernel: stb6100_read_regs:         NI: 0x39
>  kernel: stb6100_read_regs:         NF: 0xf7
>  kernel: stb6100_read_regs:         K: 0x3c
>  kernel: stb6100_read_regs:         G: 0x39
>  kernel: stb6100_read_regs:         F: 0xcf
>  kernel: stb6100_read_regs:         DLB: 0xdc
>  kernel: stb6100_read_regs:         TEST1: 0x8f
>  kernel: stb6100_read_regs:         FCCK: 0x0d
>  kernel: stb6100_read_regs:         LPEN: 0xfb
>  kernel: stb6100_read_regs:         TEST3: 0xde
>  kernel: stb6100_get_bandwidth: bandwidth = 40000000 Hz
>  kernel: stb6100_read_regs:     Read from 0x60
>  kernel: stb6100_read_regs:         LD: 0x81
>  kernel: stb6100_read_regs:         VCO: 0x66
>  kernel: stb6100_read_regs:         NI: 0x39
>  kernel: stb6100_read_regs:         NF: 0xf7
>  kernel: stb6100_read_regs:         K: 0x3c
>  kernel: stb6100_read_regs:         G: 0x39
>  kernel: stb6100_read_regs:         F: 0xcf
>  kernel: stb6100_read_regs:         DLB: 0xdc
>  kernel: stb6100_read_regs:         TEST1: 0x8f
>  kernel: stb6100_read_regs:         FCCK: 0x0d
>  kernel: stb6100_read_regs:         LPEN: 0xfb
>  kernel: stb6100_read_regs:         TEST3: 0xde
>  kernel: stb6100_set_frequency: Get frontend parameters
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [1:11]
>  kernel: stb6100_write_reg_range:         VCO: 0x66
>  kernel: stb6100_write_reg_range:         NI: 0x39
>  kernel: stb6100_write_reg_range:         NF: 0xf7
>  kernel: stb6100_write_reg_range:         K: 0x3c
>  kernel: stb6100_write_reg_range:         G: 0x39
>  kernel: stb6100_write_reg_range:         F: 0xcf
>  kernel: stb6100_write_reg_range:         DLB: 0xdc
>  kernel: stb6100_write_reg_range:         TEST1: 0x8f
>  kernel: stb6100_write_reg_range:         FCCK: 0x0d
>  kernel: stb6100_write_reg_range:         LPEN: 0xeb
>  kernel: stb6100_write_reg_range:         TEST3: 0xde
>  kernel: stb6100_set_frequency: frequency = 1552000, srate = 22000000, g = 9, odiv = 0, psd2 = 1, fxtal = 27000, osm = 6, fvco = 3104000, N(I) = 57, N(F) = 247
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [1:11]
>  kernel: stb6100_write_reg_range:         VCO: 0xe6
>  kernel: stb6100_write_reg_range:         NI: 0x39
>  kernel: stb6100_write_reg_range:         NF: 0xf7
>  kernel: stb6100_write_reg_range:         K: 0x3c
>  kernel: stb6100_write_reg_range:         G: 0x39
>  kernel: stb6100_write_reg_range:         F: 0xcf
>  kernel: stb6100_write_reg_range:         DLB: 0xdc
>  kernel: stb6100_write_reg_range:         TEST1: 0x8f
>  kernel: stb6100_write_reg_range:         FCCK: 0x4d
>  kernel: stb6100_write_reg_range:         LPEN: 0xeb
>  kernel: stb6100_write_reg_range:         TEST3: 0xde
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [10:1]
>  kernel: stb6100_write_reg_range:         LPEN: 0xfb
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [1:1]
>  kernel: stb6100_write_reg_range:         VCO: 0x86
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [1:1]
>  kernel: stb6100_write_reg_range:         VCO: 0x66
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [1:9]
>  kernel: stb6100_write_reg_range:         VCO: 0x66
>  kernel: stb6100_write_reg_range:         NI: 0x39
>  kernel: stb6100_write_reg_range:         NF: 0xf7
>  kernel: stb6100_write_reg_range:         K: 0x3c
>  kernel: stb6100_write_reg_range:         G: 0x39
>  kernel: stb6100_write_reg_range:         F: 0xcf
>  kernel: stb6100_write_reg_range:         DLB: 0xdc
>  kernel: stb6100_write_reg_range:         TEST1: 0x8f
>  kernel: stb6100_write_reg_range:         FCCK: 0x0d
>  kernel: stb6100_read_regs:     Read from 0x60
>  kernel: stb6100_read_regs:         LD: 0x81
>  kernel: stb6100_read_regs:         VCO: 0x66
>  kernel: stb6100_read_regs:         NI: 0x39
>  kernel: stb6100_read_regs:         NF: 0xf7
>  kernel: stb6100_read_regs:         K: 0x3c
>  kernel: stb6100_read_regs:         G: 0x39
>  kernel: stb6100_read_regs:         F: 0xcf
>  kernel: stb6100_read_regs:         DLB: 0xdc
>  kernel: stb6100_read_regs:         TEST1: 0x8f
>  kernel: stb6100_read_regs:         FCCK: 0x0d
>  kernel: stb6100_read_regs:         LPEN: 0xfb
>  kernel: stb6100_read_regs:         TEST3: 0xde
>  kernel: stb6100_get_frequency: frequency = 1552025 kHz, odiv = 0, psd2 = 1, fxtal = 27000 kHz, fvco = 3104050 kHz, N(I) = 57, N(F) = 247
>  kernel: stb6100_set_bandwidth: set bandwidth to 39700000 Hz
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [9:1]
>  kernel: stb6100_write_reg_range:         FCCK: 0x4d
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [6:1]
>  kernel: stb6100_write_reg_range:         F: 0xcf
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [9:1]
>  kernel: stb6100_write_reg_range:         FCCK: 0x0d
>  kernel: stb6100_read_regs:     Read from 0x60
>  kernel: stb6100_read_regs:         LD: 0x81
>  kernel: stb6100_read_regs:         VCO: 0x66
>  kernel: stb6100_read_regs:         NI: 0x39
>  kernel: stb6100_read_regs:         NF: 0xf7
>  kernel: stb6100_read_regs:         K: 0x3c
>  kernel: stb6100_read_regs:         G: 0x39
>  kernel: stb6100_read_regs:         F: 0xcf
>  kernel: stb6100_read_regs:         DLB: 0xdc
>  kernel: stb6100_read_regs:         TEST1: 0x8f
>  kernel: stb6100_read_regs:         FCCK: 0x0d
>  kernel: stb6100_read_regs:         LPEN: 0xfb
>  kernel: stb6100_read_regs:         TEST3: 0xde
>  kernel: stb6100_get_bandwidth: bandwidth = 40000000 Hz
>  kernel: stb6100_read_regs:     Read from 0x60
>  kernel: stb6100_read_regs:         LD: 0x81
>  kernel: stb6100_read_regs:         VCO: 0x66
>  kernel: stb6100_read_regs:         NI: 0x39
>  kernel: stb6100_read_regs:         NF: 0xf7
>  kernel: stb6100_read_regs:         K: 0x3c
>  kernel: stb6100_read_regs:         G: 0x39
>  kernel: stb6100_read_regs:         F: 0xcf
>  kernel: stb6100_read_regs:         DLB: 0xdc
>  kernel: stb6100_read_regs:         TEST1: 0x8f
>  kernel: stb6100_read_regs:         FCCK: 0x0d
>  kernel: stb6100_read_regs:         LPEN: 0xfb
>  kernel: stb6100_read_regs:         TEST3: 0xde
>  kernel: stb6100_set_frequency: Get frontend parameters
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [1:11]
>  kernel: stb6100_write_reg_range:         VCO: 0x66
>  kernel: stb6100_write_reg_range:         NI: 0x39
>  kernel: stb6100_write_reg_range:         NF: 0xf7
>  kernel: stb6100_write_reg_range:         K: 0x3c
>  kernel: stb6100_write_reg_range:         G: 0x39
>  kernel: stb6100_write_reg_range:         F: 0xcf
>  kernel: stb6100_write_reg_range:         DLB: 0xdc
>  kernel: stb6100_write_reg_range:         TEST1: 0x8f
>  kernel: stb6100_write_reg_range:         FCCK: 0x0d
>  kernel: stb6100_write_reg_range:         LPEN: 0xeb
>  kernel: stb6100_write_reg_range:         TEST3: 0xde
>  kernel: stb6100_set_frequency: frequency = 1552000, srate = 22000000, g = 9, odiv = 0, psd2 = 1, fxtal = 27000, osm = 6, fvco = 3104000, N(I) = 57, N(F) = 247
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [1:11]
>  kernel: stb6100_write_reg_range:         VCO: 0xe6
>  kernel: stb6100_write_reg_range:         NI: 0x39
>  kernel: stb6100_write_reg_range:         NF: 0xf7
>  kernel: stb6100_write_reg_range:         K: 0x3c
>  kernel: stb6100_write_reg_range:         G: 0x39
>  kernel: stb6100_write_reg_range:         F: 0xcf
>  kernel: stb6100_write_reg_range:         DLB: 0xdc
>  kernel: stb6100_write_reg_range:         TEST1: 0x8f
>  kernel: stb6100_write_reg_range:         FCCK: 0x4d
>  kernel: stb6100_write_reg_range:         LPEN: 0xeb
>  kernel: stb6100_write_reg_range:         TEST3: 0xde
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [10:1]
>  kernel: stb6100_write_reg_range:         LPEN: 0xfb
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [1:1]
>  kernel: stb6100_write_reg_range:         VCO: 0x86
>  kernel: stb6100_write_reg_range:     Write @ 0x60: [1:9]
>  kernel: stb6100_write_reg_range:         VCO: 0x66
>  kernel: stb6100_write_reg_range:         NI: 0x39
>  kernel: stb6100_write_reg_range:         NF: 0xf7
>  kernel: stb6100_write_reg_range:         K: 0x3c
>  kernel: stb6100_write_reg_range:         G: 0x39
>  kernel: stb6100_write_reg_range:         F: 0xcf
>  kernel: stb6100_write_reg_range:         DLB: 0xdc
>  kernel: stb6100_write_reg_range:         TEST1: 0x8f
>  kernel: stb6100_write_reg_range:         FCCK: 0x0d
>  kernel: stb6100_read_regs:     Read from 0x60
>  kernel: stb6100_read_regs:         LD: 0x81
>  kernel: stb6100_read_regs:         VCO: 0x66
>  kernel: stb6100_read_regs:         NI: 0x39
>  kernel: stb6100_read_regs:         NF: 0xf7
>  kernel: stb6100_read_regs:         K: 0x3c
>  kernel: stb6100_read_regs:         G: 0x39
>  kernel: stb6100_read_regs:         F: 0xcf
>  kernel: stb6100_read_regs:         DLB: 0xdc
>  kernel: stb6100_read_regs:         TEST1: 0x8f
>  kernel: stb6100_read_regs:         FCCK: 0x0d
>  kernel: stb6100_read_regs:         LPEN: 0xfb
>  kernel: stb6100_read_regs:         TEST3: 0xde
>  kernel: stb6100_get_frequency: frequency = 1552025 kHz, odiv = 0, psd2 = 1, fxtal = 27000 kHz, fvco = 3104050 kHz, N(I) = 57, N(F) = 247
[…]

– Matthias
