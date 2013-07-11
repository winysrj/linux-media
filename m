Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-auth.no-ip.com ([8.23.224.61]:12956 "EHLO
	out.smtp-auth.no-ip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754723Ab3GKDwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jul 2013 23:52:22 -0400
From: "Carl-Fredrik Sundstrom" <cf@blueflowamericas.com>
To: "'Steven Toth'" <stoth@kernellabs.com>
Cc: "'Devin Heitmueller'" <dheitmueller@kernellabs.com>,
	<linux-media@vger.kernel.org>
References: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com>	<CAGoCfiyjeqxVV8A_MM-iV58=s48FEhNPA=5MPg3WAOAKs8d2iA@mail.gmail.com>	<011901ce73ab$9b81cce0$d28566a0$@blueflowamericas.com>	<CALzAhNV7Cv9SR1C2mpgtLTwxD_grCZeOWc6O-2XpJEAKg1mX6w@mail.gmail.com>	<017101ce7c5b$6899c860$39cd5920$@blueflowamericas.com>	<CALzAhNVo0gi1HZ5TH9oXnUpgsqKa+YL=uGLvQNYxqj6gLd2upw@mail.gmail.com>	<017801ce7d0e$73eeff60$5bccfe20$@blueflowamericas.com> <CALzAhNULmGJSXvGogBFV4KXFH4OBvSydbJQ_7PbAnMAmwByjjA@mail.gmail.com>
In-Reply-To: <CALzAhNULmGJSXvGogBFV4KXFH4OBvSydbJQ_7PbAnMAmwByjjA@mail.gmail.com>
Subject: RE: lgdt3304
Date: Wed, 10 Jul 2013 22:51:44 -0500
Message-ID: <019d01ce7de9$f620cdc0$e2626940$@blueflowamericas.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Thanks Steven for all the support,

Now I got the master slave to work and I can scan the local FOX channel with
azap

tridentsx@tridentsx-P5K-E:~/.kde/share/apps/kaffeine$ azap FOX
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 599028615 Hz
video pid 0x0031, audio pid 0x0034
status 01 | signal 0000 | snr 0000 | ber 00000000 | unc 0000ca8b | 
status 1f | signal 8e53 | snr 00c4 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1f | signal 907a | snr 00c5 | ber 00000000 | unc 00000165 |
FE_HAS_LOCK
status 1f | signal 8dc8 | snr 00c4 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK
status 1f | signal 8d3f | snr 00c1 | ber 00000000 | unc 00000000 |
FE_HAS_LOCK

However when I try to view or scan channels in mplayer or kaffeine it can't
find them and there 
are some timeouts Similar to the ones I got in scan utility. 

kaffeine(5476) DvbScanFilter::timerEvent: timeout while reading section;
type = 3 pid = 8187 
kaffeine(5476) DvbScanFilter::timerEvent: timeout while reading section;
type = 0 pid = 0 
kaffeine(5476) DvbScanFilter::timerEvent: timeout while reading section;
type = 3 pid = 8187 

Playing dvb://.
dvb_tune Freq: 599028615
dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 3 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 2 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 1 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, return 0 bytes
Failed to recognize file format.

When I use the scan tool I get the following for every channel that I can
get a lock on in azap

>>> tune to: 473028615:8VSB
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x1ffb


Below is a kernel  trace at the same time. It seems the tuning is successful
still no channels are output at the end of scan.


[ 4800.196989] tda18271_tune: [1-0060|M] freq = 473028615, ifc = 3250, bw =
6000000, agc_mode = 3, std = 4
[ 4800.196992] tda18271_agc: [1-0060|M] no agc configuration provided
[ 4800.196996] tda18271_set_standby_mode: [1-0060|M] sm = 0, sm_lt = 0,
sm_xt = 0
[ 4800.199133] tda18271_dump_regs: [1-0060|M] === TDA18271 REG DUMP ===
[ 4800.199136] tda18271_dump_regs: [1-0060|M] ID_BYTE            = 0x84
[ 4800.199140] tda18271_dump_regs: [1-0060|M] THERMO_BYTE        = 0x48
[ 4800.199143] tda18271_dump_regs: [1-0060|M] POWER_LEVEL_BYTE   = 0x80
[ 4800.199146] tda18271_dump_regs: [1-0060|M] EASY_PROG_BYTE_1   = 0xde
[ 4800.199149] tda18271_dump_regs: [1-0060|M] EASY_PROG_BYTE_2   = 0xb4
[ 4800.199152] tda18271_dump_regs: [1-0060|M] EASY_PROG_BYTE_3   = 0x1c
[ 4800.199155] tda18271_dump_regs: [1-0060|M] EASY_PROG_BYTE_4   = 0x64
[ 4800.199157] tda18271_dump_regs: [1-0060|M] EASY_PROG_BYTE_5   = 0x86
[ 4800.199160] tda18271_dump_regs: [1-0060|M] CAL_POST_DIV_BYTE  = 0x98
[ 4800.199163] tda18271_dump_regs: [1-0060|M] CAL_DIV_BYTE_1     = 0x69
[ 4800.199166] tda18271_dump_regs: [1-0060|M] CAL_DIV_BYTE_2     = 0x40
[ 4800.199169] tda18271_dump_regs: [1-0060|M] CAL_DIV_BYTE_3     = 0x00
[ 4800.199172] tda18271_dump_regs: [1-0060|M] MAIN_POST_DIV_BYTE = 0xb1
[ 4800.199175] tda18271_dump_regs: [1-0060|M] MAIN_DIV_BYTE_1    = 0x79
[ 4800.199178] tda18271_dump_regs: [1-0060|M] MAIN_DIV_BYTE_2    = 0xa8
[ 4800.199181] tda18271_dump_regs: [1-0060|M] MAIN_DIV_BYTE_3    = 0x08
[ 4800.199184] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_1    = 0xfc
[ 4800.199187] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_2    = 0x01
[ 4800.199190] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_3    = 0x84
[ 4800.199192] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_4    = 0x41
[ 4800.199195] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_5    = 0x01
[ 4800.199198] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_6    = 0x84
[ 4800.199201] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_7    = 0x41
[ 4800.199204] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_8    = 0x07
[ 4800.199207] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_9  W = 0x00
[ 4800.199210] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_10   = 0x29
[ 4800.199213] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_11   = 0x96
[ 4800.199216] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_12   = 0x13
[ 4800.199219] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_13   = 0xbd
[ 4800.199222] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_14   = 0x11
[ 4800.199224] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_15   = 0x85
[ 4800.199227] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_16 W = 0x00
[ 4800.199230] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_17 W = 0x4c
[ 4800.199233] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_18   = 0x0c
[ 4800.199236] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_19 W = 0x00
[ 4800.199239] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_20 W = 0x20
[ 4800.199242] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_21   = 0xb3
[ 4800.199245] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_22   = 0x37
[ 4800.199248] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_23   = 0xb0
[ 4800.199251] tda18271_set_standby_mode: [1-0060|M] sm = 0, sm_lt = 0,
sm_xt = 0
[ 4800.201715] tda18271_dump_regs: [1-0060|M] === TDA18271 REG DUMP ===
[ 4800.201718] tda18271_dump_regs: [1-0060|M] ID_BYTE            = 0x84
[ 4800.201721] tda18271_dump_regs: [1-0060|M] THERMO_BYTE        = 0x50
[ 4800.201725] tda18271_dump_regs: [1-0060|M] POWER_LEVEL_BYTE   = 0x80
[ 4800.201728] tda18271_dump_regs: [1-0060|M] EASY_PROG_BYTE_1   = 0xde
[ 4800.201731] tda18271_dump_regs: [1-0060|M] EASY_PROG_BYTE_2   = 0xb4
[ 4800.201734] tda18271_dump_regs: [1-0060|M] EASY_PROG_BYTE_3   = 0x1c
[ 4800.201737] tda18271_dump_regs: [1-0060|M] EASY_PROG_BYTE_4   = 0x64
[ 4800.201740] tda18271_dump_regs: [1-0060|M] EASY_PROG_BYTE_5   = 0x86
[ 4800.201743] tda18271_dump_regs: [1-0060|M] CAL_POST_DIV_BYTE  = 0x98
[ 4800.201746] tda18271_dump_regs: [1-0060|M] CAL_DIV_BYTE_1     = 0x69
[ 4800.201749] tda18271_dump_regs: [1-0060|M] CAL_DIV_BYTE_2     = 0x40
[ 4800.201752] tda18271_dump_regs: [1-0060|M] CAL_DIV_BYTE_3     = 0x00
[ 4800.201755] tda18271_dump_regs: [1-0060|M] MAIN_POST_DIV_BYTE = 0xb1
[ 4800.201758] tda18271_dump_regs: [1-0060|M] MAIN_DIV_BYTE_1    = 0x79
[ 4800.201761] tda18271_dump_regs: [1-0060|M] MAIN_DIV_BYTE_2    = 0xa8
[ 4800.201764] tda18271_dump_regs: [1-0060|M] MAIN_DIV_BYTE_3    = 0x08
[ 4800.201766] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_1    = 0xfc
[ 4800.201769] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_2    = 0x01
[ 4800.201772] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_3    = 0x84
[ 4800.201775] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_4    = 0x41
[ 4800.201778] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_5    = 0x01
[ 4800.201781] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_6    = 0x84
[ 4800.201784] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_7    = 0x41
[ 4800.201787] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_8    = 0x07
[ 4800.201790] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_9  W = 0x00
[ 4800.201793] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_10   = 0x29
[ 4800.201796] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_11   = 0x96
[ 4800.201799] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_12   = 0x13
[ 4800.201802] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_13   = 0xbd
[ 4800.201805] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_14   = 0x11
[ 4800.201808] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_15   = 0x85
[ 4800.201811] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_16 W = 0x00
[ 4800.201814] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_17 W = 0x4c
[ 4800.201817] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_18   = 0x0c
[ 4800.201820] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_19 W = 0x00
[ 4800.201823] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_20 W = 0x20
[ 4800.201826] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_21   = 0xb3
[ 4800.201829] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_22   = 0x37
[ 4800.201832] tda18271_dump_regs: [1-0060|M] EXTENDED_BYTE_23   = 0xb0
[ 4800.201835] tda18271_lookup_thermometer: [1-0060|M] (0) tm = 60
[ 4800.202320] tda18271_lookup_map: [1-0060|M] (281) rf_cal: 0x15
[ 4800.202326] tda18271_lookup_rf_band: [1-0060|M] (0) rfmax = 47900000 <
freq = 473028615, rf1_def = 46000, rf2_def = 0, rf3_def = 0, rf1 = 46000,
rf2 = 0, rf3 = 0, rf_a1 = 0, rf_a2 = 0, rf_b1 = -18, rf_b2 = 0
[ 4800.202332] tda18271_lookup_rf_band: [1-0060|M] (1) rfmax = 61100000 <
freq = 473028615, rf1_def = 52200, rf2_def = 0, rf3_def = 0, rf1 = 52200,
rf2 = 0, rf3 = 0, rf_a1 = 0, rf_a2 = 0, rf_b1 = -7, rf_b2 = 0
[ 4800.202338] tda18271_lookup_rf_band: [1-0060|M] (2) rfmax = 152600000 <
freq = 473028615, rf1_def = 70100, rf2_def = 136800, rf3_def = 0, rf1 =
70100, rf2 = 136800, rf3 = 0, rf_a1 = 0, rf_a2 = 0, rf_b1 = 1, rf_b2 = 0
[ 4800.202344] tda18271_lookup_rf_band: [1-0060|M] (3) rfmax = 164700000 <
freq = 473028615, rf1_def = 156700, rf2_def = 0, rf3_def = 0, rf1 = 156700,
rf2 = 0, rf3 = 0, rf_a1 = 0, rf_a2 = 0, rf_b1 = -7, rf_b2 = 0
[ 4800.202349] tda18271_lookup_rf_band: [1-0060|M] (4) rfmax = 203500000 <
freq = 473028615, rf1_def = 186250, rf2_def = 0, rf3_def = 0, rf1 = 186250,
rf2 = 0, rf3 = 0, rf_a1 = 0, rf_a2 = 0, rf_b1 = -4, rf_b2 = 0
[ 4800.202355] tda18271_lookup_rf_band: [1-0060|M] (5) rfmax = 457800000 <
freq = 473028615, rf1_def = 230000, rf2_def = 345000, rf3_def = 426000, rf1
= 230000, rf2 = 345000, rf3 = 426000, rf_a1 = 0, rf_a2 = 0, rf_b1 = 0, rf_b2
= 1
[ 4800.202358] tda18271_lookup_rf_band: [1-0060|M] (6) rf_band = 06
[ 4800.202362] tda18271_lookup_map: [1-0060|M] (54) rf_cal_dc_over_dt: 0x12
[ 4800.202893] tda18271_lookup_map: [1-0060|M] (2) ir_measure: 0x06
[ 4800.202897] tda18271_lookup_map: [1-0060|M] (6) bp_filter: 0x06
[ 4800.202900] tda18271_lookup_map: [1-0060|M] (6) rf_band: 0x06
[ 4800.202904] tda18271_lookup_map: [1-0060|M] (63) gain_taper: 0x19
[ 4800.203180] tda18271_lookup_pll_map: [1-0060|M] (31) main_pll: post div =
0x20, div = 0x10
[ 4800.236205] lgdt3305_set_modulation: 
[ 4800.236211] lgdt3305_read_reg: reg: 0x0000
[ 4800.236761] lgdt3305_write_reg: reg: 0x0000, val: 0x03
[ 4800.237057] lgdt3305_passband_digital_agc: agc ref: 0x32c4
[ 4800.237060] lgdt3305_write_reg: reg: 0x0012, val: 0x32
[ 4800.237433] lgdt3305_write_reg: reg: 0x0013, val: 0xc4
[ 4800.237810] lgdt3305_agc_setup: lockdten = 0, acqen = 0
[ 4800.237812] lgdt3305_write_reg: reg: 0x0314, val: 0xe1
[ 4800.238186] lgdt3305_set_reg_bit: reg: 0x030e, bit: 2, level: 0
[ 4800.238188] lgdt3305_read_reg: reg: 0x030e
[ 4800.238745] lgdt3305_write_reg: reg: 0x030e, val: 0x18
[ 4800.239041] lgdt3305_rfagc_loop: ifbw: 0x8000
[ 4800.239044] lgdt3305_write_reg: reg: 0x0308, val: 0x80
[ 4800.239416] lgdt3305_write_reg: reg: 0x0309, val: 0x00
[ 4800.239793] lgdt3305_write_reg: reg: 0x030d, val: 0x00
[ 4800.240176] lgdt3305_write_reg: reg: 0x0106, val: 0x4f
[ 4800.240552] lgdt3305_write_reg: reg: 0x0107, val: 0x0c
[ 4800.240927] lgdt3305_write_reg: reg: 0x0108, val: 0xac
[ 4800.241304] lgdt3305_write_reg: reg: 0x0109, val: 0xba
[ 4800.241680] lgdt3305_spectral_inversion: (1)
[ 4800.241683] lgdt3305_write_reg: reg: 0x0126, val: 0xf9
[ 4800.242057] lgdt3305_mpeg_mode: (1)
[ 4800.242060] lgdt3305_set_reg_bit: reg: 0x050e, bit: 5, level: 1
[ 4800.242062] lgdt3305_read_reg: reg: 0x050e
[ 4800.242616] lgdt3305_write_reg: reg: 0x050e, val: 0x7b
[ 4800.242911] lgdt3305_mpeg_mode_polarity: edge = 1, valid = 1
[ 4800.242913] lgdt3305_read_reg: reg: 0x050e
[ 4800.243471] lgdt3305_write_reg: reg: 0x050e, val: 0x7b
[ 4800.243767] lgdt3305_soft_reset: 
[ 4800.243770] lgdt3305_set_reg_bit: reg: 0x0002, bit: 0, level: 0
[ 4800.243772] lgdt3305_read_reg: reg: 0x0002
[ 4800.244333] lgdt3305_write_reg: reg: 0x0002, val: 0x9a
[ 4800.268013] lgdt3305_set_reg_bit: reg: 0x0002, bit: 0, level: 1
[ 4800.268017] lgdt3305_read_reg: reg: 0x0002
[ 4800.268479] lgdt3305_write_reg: reg: 0x0002, val: 0x9b
[ 4800.397037] lgdt3305_read_reg: reg: 0x0003
[ 4800.397499] lgdt3305_read_status: SIGNALEXIST INLOCK 
[ 4800.397502] lgdt3305_read_reg: reg: 0x011d
[ 4800.397979] lgdt3305_read_cr_lock_status: (1) CLOCKVSB
[ 4800.397998] function : dvb_dmxdev_filter_set, PID=0x1ffb, flags=05,
timeout=0
[ 4800.436025] function : dvb_dmxdev_filter_set, PID=0x0000, flags=05,
timeout=0
[ 4800.768016] lgdt3305_read_reg: reg: 0x0003
[ 4800.768479] lgdt3305_read_status: SIGNALEXIST INLOCK SYNCLOCK NOFECERR
SNRGOOD 
[ 4800.768482] lgdt3305_read_reg: reg: 0x011d
[ 4800.768959] lgdt3305_read_cr_lock_status: (1) CLOCKVSB
[ 4800.768961] lgdt3305_get_frontend: 
[ 4802.132014] lgdt3305_read_reg: reg: 0x0003
[ 4802.132477] lgdt3305_read_status: SIGNALEXIST INLOCK SYNCLOCK NOFECERR
SNRGOOD 
[ 4802.132480] lgdt3305_read_reg: reg: 0x011d
[ 4802.132955] lgdt3305_read_cr_lock_status: (1) CLOCKVSB
[ 4803.508016] lgdt3305_read_reg: reg: 0x0003
[ 4803.508479] lgdt3305_read_status: SIGNALEXIST INLOCK SYNCLOCK NOFECERR
SNRGOOD 
[ 4803.508482] lgdt3305_read_reg: reg: 0x011d
[ 4803.508957] lgdt3305_read_cr_lock_status: (1) CLOCKVSB
[ 4804.900042] lgdt3305_read_reg: reg: 0x0003
[ 4804.900506] lgdt3305_read_status: SIGNALEXIST INLOCK SYNCLOCK NOFECERR
SNRGOOD 
[ 4804.900508] lgdt3305_read_reg: reg: 0x011d
[ 4804.900984] lgdt3305_read_cr_lock_status: (1) CLOCKVSB
[ 4806.292015] lgdt3305_read_reg: reg: 0x0003
[ 4806.292479] lgdt3305_read_status: SIGNALEXIST INLOCK SYNCLOCK NOFECERR
SNRGOOD 
[ 4806.292481] lgdt3305_read_reg: reg: 0x011d
[ 4806.292957] lgdt3305_read_cr_lock_status: (1) CLOCKVSB
[ 4807.448098] lgdt3305_get_tune_settings: 
[ 4807.448120] lgdt3304_set_parameters: (479028615, 7)
[ 4807.448129] tda18271_tune: [1-0060|M] freq = 479028615, ifc = 3250, bw =
6000000, agc_mode = 3, std = 4
[ 4807.448133] tda18271_agc: [1-0060|M] no agc configuration provided







-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Steven Toth
Sent: Wednesday, July 10, 2013 8:51 AM
To: Carl-Fredrik Sundstrom
Cc: Devin Heitmueller; linux-media@vger.kernel.org
Subject: Re: lgdt3304

On Tue, Jul 9, 2013 at 9:40 PM, Carl-Fredrik Sundstrom
<cf@blueflowamericas.com> wrote:
>
> I don't have digital cable only over the air ATSC. No one else on this 
> list has this card ?

You are very welcome, thank you.

We generally recommend Linux users purchase cards that are already supported
(or semi supported), such as the HVR2250. If you're keen enough to tackle
adding support for a new board then that's great news, but very few people
usually have experience with hardware not yet supported.

The channels.conf is capable of support digital cable and ATSC, simply
change the modulation scheme and your target frequency and try again.

A quick google for an equivalent ATSC channels.conf provides a lot of useful
information.

Create your channels.conf to match your target frequencies in Hz and use
azap to debug.

Eg.

KPAX-CW:177028615:8VSB:65:68:2

>
> Thanks /// Carl
>
> -----Original Message-----
> From: linux-media-owner@vger.kernel.org 
> [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Steven Toth
> Sent: Tuesday, July 09, 2013 9:54 AM
> To: Carl-Fredrik Sundstrom
> Cc: Devin Heitmueller; linux-media@vger.kernel.org
> Subject: Re: lgdt3304
>
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>>>> tune to: 57028615:8VSB
>> WARNING: >>> tuning failed!!!
>>>>> tune to: 57028615:8VSB (tuning failed)
>
> I don't have a box in front of me but that's usually a sign that the 
> frequency details you are passing in are bogus, so the tuner driver is 
> rejecting it.
>
> Check your command line tuning tools and args.
>
> Here's a one line channels.conf for azap (US digital cable) that works 
> fine, and the azap console output:
>
> ch86:597000000:QAM_256:0:0:101
>
> stoth@mythbackend:~/.azap$ azap ch86
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 597000000 Hz
> video pid 0x0000, audio pid 0x0000
> status 00 | signal 0000 | snr b770 | ber 00000000 | unc 00000000 | 
> status 1f
> | signal 0154 | snr 0154 | ber 000000ad | unc 000000ad | FE_HAS_LOCK 
> | status
> 1f | signal 0156 | snr 0156 | ber 00000000 | unc 00000000 | 
> FE_HAS_LOCK
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com

--
Steven Toth - Kernel Labs
http://www.kernellabs.com
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

