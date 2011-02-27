Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48439 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab1B0GPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 01:15:54 -0500
Received: by iyb26 with SMTP id 26so2016463iyb.19
        for <linux-media@vger.kernel.org>; Sat, 26 Feb 2011 22:15:53 -0800 (PST)
Subject: Hauppauge 950q issue
From: Kyle <kyle.kjfrancis.francis@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Feb 2011 20:15:50 -1000
Message-ID: <1298787350.2921.6.camel@kyle-Precision-WorkStation-380>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I was wondering if someone might be able to figure out what’s wrong with
my HVR-950q. When I can get it to work, it works just fine, but it seems
that after a restart in Ubuntu 10.10 x64 it won’t work for quite a while
(unable to determine how long specifically, but in the realm of hours to
days). It will work fine under windows after multiple reboots, so I’m
wondering if the linux firmware isn’t unloading properly or something.
When I start up mythtv again I get the following info from dmesg:

[ 22.832293] xc5000: xc5000_init()
[ 22.837041] xc5000: xc5000_is_firmware_loaded() returns False id =
0×2000
[ 22.837044] xc5000: waiting for firmware upload
(dvb-fe-xc5000-1.6.114.fw)…
[ 22.865012] xc5000: firmware read 12401 bytes.
[ 22.865015] xc5000: firmware uploading…
[ 22.865019] xc5000: xc5000_TunerReset()
[ 27.440072] 8:2:1: endpoint lacks sample rate attribute bit, cannot
set.
[ 27.461883] 8:2:1: endpoint lacks sample rate attribute bit, cannot
set.
[ 27.487738] 8:2:1: endpoint lacks sample rate attribute bit, cannot
set.
[ 31.671477] xc5000: firmware upload complete…
[ 31.671493] xc5000: xc_initialize()
[ 36.074720] xc5000: *** ADC envelope (0-1023) = 65535
[ 36.079462] xc5000: *** Frequency error = 1023984 Hz
[ 36.084462] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) =
65535
[ 36.094082] xc5000: *** HW: V0f.0f, FW: V0f.0f.ffff
[ 36.098826] xc5000: *** Horizontal sync frequency = 31244 Hz
[ 36.103575] xc5000: *** Frame lines = 65535
[ 36.108319] xc5000: *** Quality (0:56dB) = 65535
[ 36.427140] xc5000: xc5000_is_firmware_loaded() returns True id =
0xffff
[ 36.427147] xc5000: xc5000_set_params() frequency=629000000 (Hz)
[ 36.427151] xc5000: xc5000_set_params() ATSC
[ 36.427154] xc5000: xc5000_set_params() VSB modulation
[ 36.427158] xc5000: xc5000_set_params() frequency=627250000
(compensated)
[ 36.427162] xc5000: xc_SetSignalSource(0) Source = ANTENNA
[ 38.510023] xc5000: xc_SetTVStandard(0×8002,0x00c0)
[ 38.510029] xc5000: xc_SetTVStandard() Standard = DTV6
[ 42.900024] xc5000: xc_set_IF_frequency(freq_khz = 6000) freq_code =
0×1800
[ 45.130023] xc5000: xc_tune_channel(627250000)
[ 45.130028] xc5000: xc_set_RF_frequency(627250000)
[ 47.334695] xc5000: *** ADC envelope (0-1023) = 65535
[ 47.339438] xc5000: *** Frequency error = 1023984 Hz
[ 47.344186] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) =
65535
[ 47.353683] xc5000: *** HW: V0f.0f, FW: V0f.0f.ffff
[ 47.358427] xc5000: *** Horizontal sync frequency = 31244 Hz
[ 47.363175] xc5000: *** Frame lines = 65535
[ 47.367921] xc5000: *** Quality (0:56dB) = 65535

When the card does work right the line "[ 47.344186] xc5000: *** Lock
status (0-Wait, 1-Locked, 2-No-signal) = 65535" doesn't end with 65535
(can't remember exactly what cause it's been a little while since I've
fiddled with this.  Since it's 65535 that makes me wonder if it's some
sort of overflow or something.  Any help would be greatly appreciated!

-Kyle


