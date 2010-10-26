Return-path: <mchehab@pedra>
Received: from skyboo.net ([82.160.187.4]:48814 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751561Ab0JZM7F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Oct 2010 08:59:05 -0400
Received: from localhost ([::1])
	by skyboo.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <manio@skyboo.net>)
	id 1PAiNf-0003Pu-Fn
	for linux-media@vger.kernel.org; Tue, 26 Oct 2010 14:12:01 +0200
Message-ID: <4CC6C587.2020109@skyboo.net>
Date: Tue, 26 Oct 2010 14:11:51 +0200
From: Mariusz Bialonczyk <manio@skyboo.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed;
 boundary="------------090202000106050804040804"
Subject: Prof 7301 (cx88/stv0900/stb6100) locking problem
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------090202000106050804040804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello
I have Prof 7301 PCI card. I am now using 2.6.36 kernel and switching
channel issue still exist. Mainly (when switching SD channels) the
card is locking frequency fine. But when switching from HD channels to
SD (some describe it as switching from DVB-S2 to DVB-S) the card
sometimes is locking several minutes.

This issue was reported on forums by many card owners, so it is not
related with ie. bad satellite installation (I was also testing it on
different sat. installation for sure - same results).

I am attaching kernel log with debug info from stv0900 and stb6100
modules when channel switching took 90 secs!

I'd like to get rid of this issue and I could help as much as I will
able to (including patching and testing).

regards,
-- 
Mariusz Bialonczyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net

--------------090202000106050804040804
Content-Type: text/plain;
 name="lock_problem.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lock_problem.log"

11:19:00 [120005.070769] stv0900_read_status: 
11:19:00 [120005.074695] stv0900_status: locked = 1
11:19:00 [120005.078607] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:00 [120005.078608] TS bitrate = 59 Mbit/sec 
11:19:00 [120005.078610] DEMOD LOCK OK
11:19:01 [120006.094661] stv0900_read_status: 
11:19:01 [120006.098566] stv0900_status: locked = 1
11:19:01 [120006.102500] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:01 [120006.102502] TS bitrate = 59 Mbit/sec 
11:19:01 [120006.102503] DEMOD LOCK OK
11:19:02 [120007.118655] stv0900_read_status: 
11:19:02 [120007.122582] stv0900_status: locked = 1
11:19:02 [120007.126581] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:02 [120007.126583] TS bitrate = 59 Mbit/sec 
11:19:02 [120007.126584] DEMOD LOCK OK
11:19:03 [120008.142685] stv0900_read_status: 
11:19:03 [120008.146652] stv0900_status: locked = 1
11:19:03 [120008.150639] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:03 [120008.150641] TS bitrate = 59 Mbit/sec 
11:19:03 [120008.150642] DEMOD LOCK OK
11:19:04 [120009.166645] stv0900_read_status: 
11:19:04 [120009.170548] stv0900_status: locked = 1
11:19:04 [120009.174477] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:04 [120009.174478] TS bitrate = 59 Mbit/sec 
11:19:04 [120009.174479] DEMOD LOCK OK
11:19:05 [120010.190737] stv0900_read_status: 
11:19:05 [120010.194732] stv0900_status: locked = 1
11:19:05 [120010.198664] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:05 [120010.198666] TS bitrate = 59 Mbit/sec 
11:19:05 [120010.198667] DEMOD LOCK OK
11:19:06 [120011.214731] stv0900_read_status: 
11:19:06 [120011.218670] stv0900_status: locked = 1
11:19:06 [120011.222649] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:06 [120011.222651] TS bitrate = 59 Mbit/sec 
11:19:06 [120011.222652] DEMOD LOCK OK
11:19:07 [120012.242723] stv0900_read_status: 
11:19:07 [120012.246640] stv0900_status: locked = 1
11:19:07 [120012.250582] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:07 [120012.250584] TS bitrate = 59 Mbit/sec 
11:19:07 [120012.250585] DEMOD LOCK OK
11:19:08 [120013.270720] stv0900_read_status: 
11:19:08 [120013.274674] stv0900_status: locked = 1
11:19:08 [120013.278607] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:08 [120013.278609] TS bitrate = 59 Mbit/sec 
11:19:08 [120013.278610] DEMOD LOCK OK
11:19:09 [120014.298722] stv0900_read_status: 
11:19:09 [120014.302674] stv0900_status: locked = 1
11:19:09 [120014.306641] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:09 [120014.306643] TS bitrate = 59 Mbit/sec 
11:19:09 [120014.306644] DEMOD LOCK OK
11:19:10 [120015.326719] stv0900_read_status: 
11:19:10 [120015.330606] stv0900_status: locked = 1
11:19:10 [120015.334523] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:10 [120015.334525] TS bitrate = 59 Mbit/sec 
11:19:10 [120015.334526] DEMOD LOCK OK
11:19:11 [120016.354698] stv0900_read_status: 
11:19:11 [120016.358628] stv0900_status: locked = 1
11:19:11 [120016.362513] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:11 [120016.362515] TS bitrate = 59 Mbit/sec 
11:19:11 [120016.362516] DEMOD LOCK OK
11:19:12 [120017.382709] stv0900_read_status: 
11:19:12 [120017.386639] stv0900_status: locked = 1
11:19:12 [120017.390570] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:12 [120017.390572] TS bitrate = 59 Mbit/sec 
11:19:12 [120017.390573] DEMOD LOCK OK
11:19:13 [120018.410701] stv0900_read_status: 
11:19:13 [120018.414603] stv0900_status: locked = 1
11:19:13 [120018.418536] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:13 [120018.418538] TS bitrate = 59 Mbit/sec 
11:19:13 [120018.418539] DEMOD LOCK OK
11:19:14 [120018.650709] stv0900_read_status: 
11:19:14 [120018.654619] stv0900_status: locked = 1
11:19:14 [120018.658639] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:14 [120018.658640] TS bitrate = 59 Mbit/sec 
11:19:14 [120018.658641] DEMOD LOCK OK
11:19:14 [120018.658647] stb0900_set_property(..)
11:19:14 [120018.658655] stb0900_set_property(..)
11:19:14 [120018.658656] stb0900_set_property(..)
11:19:14 [120018.658657] stb0900_set_property(..)
11:19:14 [120018.658658] stb0900_set_property(..)
11:19:14 [120018.658660] stb0900_set_property(..)
11:19:14 [120018.658661] stb0900_set_property(..)
11:19:14 [120018.658662] stb0900_set_property(..)
11:19:14 [120018.658663] stb0900_set_property(..)
11:19:14 [120018.658701] stv0900_search: 
11:19:14 [120018.658704] stv0900_algo
11:19:14 [120018.665816] stv0900_set_symbol_rate: Mclk 135000000, SR 1000000, Dmd 0
11:19:14 [120018.671398] stb6100_read_regs:     Read from 0x60
11:19:14 [120018.671400] stb6100_read_regs:         LD: 0x81
11:19:14 [120018.671402] stb6100_read_regs:         VCO: 0x65
11:19:14 [120018.671403] stb6100_read_regs:         NI: 0x38
11:19:14 [120018.671404] stb6100_read_regs:         NF: 0x2f
11:19:14 [120018.671406] stb6100_read_regs:         K: 0x3d
11:19:14 [120018.671407] stb6100_read_regs:         G: 0x39
11:19:14 [120018.671408] stb6100_read_regs:         F: 0xd3
11:19:14 [120018.671410] stb6100_read_regs:         DLB: 0xdc
11:19:14 [120018.671411] stb6100_read_regs:         TEST1: 0x8f
11:19:14 [120018.671412] stb6100_read_regs:         FCCK: 0x0d
11:19:14 [120018.671414] stb6100_read_regs:         LPEN: 0xfb
11:19:14 [120018.671415] stb6100_read_regs:         TEST3: 0xde
11:19:14 [120018.671417] stb6100_set_frequency: Get frontend parameters
11:19:14 [120018.671419] stb6100_write_reg_range:     Write @ 0x60: [1:11]
11:19:14 [120018.671421] stb6100_write_reg_range:         VCO: 0x65
11:19:14 [120018.671422] stb6100_write_reg_range:         NI: 0x38
11:19:14 [120018.671423] stb6100_write_reg_range:         NF: 0x2f
11:19:14 [120018.671425] stb6100_write_reg_range:         K: 0x3d
11:19:14 [120018.671426] stb6100_write_reg_range:         G: 0x39
11:19:14 [120018.671428] stb6100_write_reg_range:         F: 0xd3
11:19:14 [120018.671429] stb6100_write_reg_range:         DLB: 0xdc
11:19:14 [120018.671430] stb6100_write_reg_range:         TEST1: 0x8f
11:19:14 [120018.671432] stb6100_write_reg_range:         FCCK: 0x0d
11:19:14 [120018.671433] stb6100_write_reg_range:         LPEN: 0xeb
11:19:14 [120018.671435] stb6100_write_reg_range:         TEST3: 0xde
11:19:14 [120018.673837] stb6100_set_frequency: frequency = 1643000, srate = 27499505, g = 9, odiv = 0, psd2 = 1, fxtal = 27000, osm = 6, fvco = 3286000, N(I) = 60, N(F) = 436
11:19:14 [120018.679041] stb6100_write_reg_range:     Write @ 0x60: [1:11]
11:19:14 [120018.679044] stb6100_write_reg_range:         VCO: 0xe6
11:19:14 [120018.679046] stb6100_write_reg_range:         NI: 0x3c
11:19:14 [120018.679047] stb6100_write_reg_range:         NF: 0xb4
11:19:14 [120018.679049] stb6100_write_reg_range:         K: 0x3d
11:19:14 [120018.679050] stb6100_write_reg_range:         G: 0x39
11:19:14 [120018.679051] stb6100_write_reg_range:         F: 0xd3
11:19:14 [120018.679053] stb6100_write_reg_range:         DLB: 0xdc
11:19:14 [120018.679054] stb6100_write_reg_range:         TEST1: 0x8f
11:19:14 [120018.679056] stb6100_write_reg_range:         FCCK: 0x4d
11:19:14 [120018.679057] stb6100_write_reg_range:         LPEN: 0xeb
11:19:14 [120018.679058] stb6100_write_reg_range:         TEST3: 0xde
11:19:14 [120018.686721] stb6100_write_reg_range:     Write @ 0x60: [10:1]
11:19:14 [120018.686724] stb6100_write_reg_range:         LPEN: 0xfb
11:19:14 [120018.687304] stb6100_write_reg_range:     Write @ 0x60: [1:1]
11:19:14 [120018.687306] stb6100_write_reg_range:         VCO: 0x86
11:19:14 [120018.702694] stb6100_write_reg_range:     Write @ 0x60: [1:1]
11:19:14 [120018.702697] stb6100_write_reg_range:         VCO: 0x66
11:19:14 [120018.703265] stb6100_write_reg_range:     Write @ 0x60: [1:9]
11:19:14 [120018.703266] stb6100_write_reg_range:         VCO: 0x66
11:19:14 [120018.703268] stb6100_write_reg_range:         NI: 0x3c
11:19:14 [120018.703269] stb6100_write_reg_range:         NF: 0xb4
11:19:14 [120018.703271] stb6100_write_reg_range:         K: 0x3d
11:19:14 [120018.703272] stb6100_write_reg_range:         G: 0x39
11:19:14 [120018.703273] stb6100_write_reg_range:         F: 0xd3
11:19:14 [120018.703275] stb6100_write_reg_range:         DLB: 0xdc
11:19:14 [120018.703276] stb6100_write_reg_range:         TEST1: 0x8f
11:19:14 [120018.703278] stb6100_write_reg_range:         FCCK: 0x0d
11:19:14 [120018.808388] stv0900_set_tuner: Frequency=1643000
11:19:14 [120018.810075] stb6100_set_bandwidth: set bandwidth to 72000000 Hz
11:19:14 [120018.810078] stb6100_write_reg_range:     Write @ 0x60: [9:1]
11:19:14 [120018.810080] stb6100_write_reg_range:         FCCK: 0x4d
11:19:14 [120018.810651] stb6100_write_reg_range:     Write @ 0x60: [6:1]
11:19:14 [120018.810652] stb6100_write_reg_range:         F: 0xdf
11:19:14 [120018.818693] stb6100_write_reg_range:     Write @ 0x60: [9:1]
11:19:14 [120018.818697] stb6100_write_reg_range:         FCCK: 0x0d
11:19:14 [120018.821009] stv0900_set_tuner: Bandwidth=72000000
11:19:14 [120018.826398] stv0900_set_search_standard
11:19:14 [120018.826399] Search Standard = AUTO
11:19:14 [120018.835214] stv0900_activate_s2_modcod_single
11:19:14 [120018.847149] stv0900_set_viterbi_tracq
11:19:14 [120018.851617] stv0900_set_viterbi_standard: ViterbiStandard = 
11:19:14 [120018.851618] Auto
11:19:14 [120018.853109] stv0900_blind_search_algo
11:19:14 [120018.853110] stv0900_blind_check_agc2_min_level
11:19:14 [120018.861514] stv0900_set_symbol_rate: Mclk 135000000, SR 1000000, Dmd 0
11:19:14 [120019.185551] stv0900_blind_search_algo agc2_int=274 agc2_th=700 
11:19:14 [120019.298637] lock: srate=808189952 r0=0x0 r1=0x0 r2=0x34 r3=0x2f 
11:19:14 [120019.298640] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x884 srate_coarse=25403137 tmg_cpt=10
11:19:14 [120019.306191] lock: srate=816054272 r0=0x0 r1=0x0 r2=0xcc r3=0x31 
11:19:14 [120019.313751] lock: srate=797966336 r0=0x0 r1=0x0 r2=0x18 r3=0x30 
11:19:14 [120019.331188] Demod State = 0
11:19:14 [120019.347636] Demod State = 3
11:19:14 [120019.363631] Demod State = 3
11:19:14 [120019.379631] Demod State = 0
11:19:14 [120019.395631] Demod State = 0
11:19:14 [120019.411631] Demod State = 0
11:19:14 [120019.427638] Demod State = 0
11:19:14 [120019.443635] Demod State = 0
11:19:14 [120019.459713] Demod State = 0
11:19:14 [120019.475630] Demod State = 3
11:19:14 [120019.491676] Demod State = 3
11:19:14 [120019.507656] Demod State = 0
11:19:14 [120019.525753] Demod State = 0
11:19:14 [120019.539664] Demod State = 0
11:19:15 [120019.555743] Demod State = 3
11:19:15 [120019.571687] Demod State = 3
11:19:15 [120019.591657] Demod State = 3
11:19:15 [120019.607657] Demod State = 0
11:19:15 [120019.623665] Demod State = 3
11:19:15 [120019.639658] Demod State = 0
11:19:15 [120019.656195] Demod State = 0
11:19:15 [120019.671666] Demod State = 0
11:19:15 [120019.687666] Demod State = 0
11:19:15 [120019.703665] Demod State = 0
11:19:15 [120019.721963] Demod State = 0
11:19:15 [120019.735652] Demod State = 0
11:19:15 [120019.751645] Demod State = 0
11:19:15 [120019.767641] Demod State = 3
11:19:15 [120019.783636] Demod State = 0
11:19:15 [120019.799749] Demod State = 0
11:19:15 [120019.815775] Demod State = 0
11:19:15 [120019.831732] Demod State = 0
11:19:15 [120019.847699] Demod State = 3
11:19:15 [120019.863544] Demod State = 3
11:19:15 [120019.879569] Demod State = 3
11:19:15 [120019.895529] Demod State = 0
11:19:15 [120019.911553] Demod State = 3
11:19:15 [120019.927532] Demod State = 3
11:19:15 [120019.943565] Demod State = 3
11:19:15 [120019.959530] Demod State = 3
11:19:15 [120019.975532] Demod State = 0
11:19:15 [120019.991543] Demod State = 0
11:19:15 [120020.007534] Demod State = 0
11:19:15 [120020.023662] Demod State = 3
11:19:15 [120020.039644] Demod State = 0
11:19:15 [120020.055755] Demod State = 3
11:19:15 [120020.071676] Demod State = 0
11:19:15 [120020.087636] Demod State = 0
11:19:15 [120020.103628] Demod State = 0
11:19:15 [120020.119751] Demod State = 0
11:19:15 [120020.135534] Demod State = 0
11:19:15 [120020.151531] Demod State = 3
11:19:15 [120020.167528] Demod State = 0
11:19:15 [120020.183552] Demod State = 0
11:19:15 [120020.199526] Demod State = 0
11:19:15 [120020.215534] Demod State = 0
11:19:15 [120020.231526] Demod State = 0
11:19:15 [120020.247542] Demod State = 0
11:19:15 [120020.263558] Demod State = 3
11:19:15 [120020.279526] Demod State = 3
11:19:15 [120020.295606] Demod State = 0
11:19:15 [120020.311520] Demod State = 0
11:19:15 [120020.327531] Demod State = 0
11:19:15 [120020.343527] Demod State = 3
11:19:15 [120020.359526] Demod State = 0
11:19:15 [120020.375528] Demod State = 0
11:19:15 [120020.391523] Demod State = 0
11:19:15 [120020.407529] Demod State = 0
11:19:15 [120020.423664] Demod State = 0
11:19:15 [120020.439625] Demod State = 0
11:19:15 [120020.454683] DEMOD LOCK FAIL
11:19:16 [120020.562511] lock: srate=870580224 r0=0x0 r1=0x0 r2=0x10 r3=0x34 
11:19:16 [120020.562514] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x90b srate_coarse=27364196 tmg_cpt=10
11:19:16 [120020.570247] lock: srate=878182400 r0=0x0 r1=0x0 r2=0x2c r3=0x34 
11:19:16 [120020.577979] lock: srate=869531648 r0=0x0 r1=0x0 r2=0x48 r3=0x33 
11:19:16 [120020.595196] Demod State = 0
11:19:16 [120020.611626] Demod State = 3
11:19:16 [120020.627629] Demod State = 3
11:19:16 [120020.643642] Demod State = 0
11:19:16 [120020.659628] Demod State = 0
11:19:16 [120020.675628] Demod State = 3
11:19:16 [120020.691629] Demod State = 0
11:19:16 [120020.707629] Demod State = 3
11:19:16 [120020.723641] Demod State = 0
11:19:16 [120020.739630] Demod State = 0
11:19:16 [120020.755625] Demod State = 3
11:19:16 [120020.771701] Demod State = 0
11:19:16 [120020.790470] Demod State = 0
11:19:16 [120020.803685] Demod State = 0
11:19:16 [120020.819665] Demod State = 3
11:19:16 [120020.835644] Demod State = 0
11:19:16 [120020.851623] Demod State = 0
11:19:16 [120020.867624] Demod State = 0
11:19:16 [120020.883647] Demod State = 0
11:19:16 [120020.899628] Demod State = 0
11:19:16 [120020.915627] Demod State = 0
11:19:16 [120020.931632] Demod State = 0
11:19:16 [120020.947632] Demod State = 0
11:19:16 [120020.963639] Demod State = 0
11:19:16 [120020.979665] Demod State = 3
11:19:16 [120020.995626] Demod State = 3
11:19:16 [120021.011632] Demod State = 0
11:19:16 [120021.027631] Demod State = 0
11:19:16 [120021.043628] Demod State = 0
11:19:16 [120021.059631] Demod State = 0
11:19:16 [120021.075663] Demod State = 0
11:19:16 [120021.091632] Demod State = 0
11:19:16 [120021.107625] Demod State = 0
11:19:16 [120021.123645] Demod State = 0
11:19:16 [120021.139625] Demod State = 0
11:19:16 [120021.155633] Demod State = 0
11:19:16 [120021.171646] Demod State = 3
11:19:16 [120021.187629] Demod State = 0
11:19:16 [120021.203631] Demod State = 3
11:19:16 [120021.219635] Demod State = 3
11:19:16 [120021.235628] Demod State = 0
11:19:16 [120021.251628] Demod State = 0
11:19:16 [120021.267625] Demod State = 0
11:19:16 [120021.283626] Demod State = 0
11:19:16 [120021.299623] Demod State = 0
11:19:16 [120021.315628] Demod State = 3
11:19:16 [120021.331632] Demod State = 0
11:19:16 [120021.347679] Demod State = 0
11:19:16 [120021.363629] Demod State = 0
11:19:16 [120021.379659] Demod State = 3
11:19:16 [120021.395627] Demod State = 0
11:19:16 [120021.411626] Demod State = 0
11:19:16 [120021.427625] Demod State = 3
11:19:16 [120021.443626] Demod State = 0
11:19:16 [120021.459623] Demod State = 0
11:19:16 [120021.475627] Demod State = 0
11:19:16 [120021.491625] Demod State = 0
11:19:16 [120021.507626] Demod State = 3
11:19:16 [120021.523638] Demod State = 3
11:19:16 [120021.539632] Demod State = 0
11:19:17 [120021.555628] Demod State = 0
11:19:17 [120021.571650] Demod State = 3
11:19:17 [120021.587627] Demod State = 0
11:19:17 [120021.603666] Demod State = 0
11:19:17 [120021.619626] Demod State = 0
11:19:17 [120021.635642] Demod State = 0
11:19:17 [120021.651627] Demod State = 0
11:19:17 [120021.667626] Demod State = 0
11:19:17 [120021.683632] Demod State = 3
11:19:17 [120021.699626] Demod State = 3
11:19:17 [120021.714682] DEMOD LOCK FAIL
11:19:17 [120021.822693] lock: srate=964165632 r0=0x0 r1=0x0 r2=0x3c r3=0x39 
11:19:17 [120021.822696] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x9b4 srate_coarse=30305786 tmg_cpt=10
11:19:17 [120021.830321] lock: srate=954466304 r0=0x0 r1=0x0 r2=0x70 r3=0x3a 
11:19:17 [120021.837871] lock: srate=957612032 r0=0x0 r1=0x0 r2=0x4 r3=0x38 
11:19:17 [120021.855067] Demod State = 0
11:19:17 [120021.871625] Demod State = 0
11:19:17 [120021.887621] Demod State = 0
11:19:17 [120021.903622] Demod State = 0
11:19:17 [120021.919629] Demod State = 0
11:19:17 [120021.935624] Demod State = 0
11:19:17 [120021.951624] Demod State = 0
11:19:17 [120021.967622] Demod State = 0
11:19:17 [120021.983623] Demod State = 0
11:19:17 [120021.999623] Demod State = 0
11:19:17 [120022.015624] Demod State = 0
11:19:17 [120022.031625] Demod State = 0
11:19:17 [120022.047636] Demod State = 3
11:19:17 [120022.063620] Demod State = 0
11:19:17 [120022.079623] Demod State = 0
11:19:17 [120022.095625] Demod State = 0
11:19:17 [120022.111620] Demod State = 3
11:19:17 [120022.127622] Demod State = 3
11:19:17 [120022.143624] Demod State = 0
11:19:17 [120022.159621] Demod State = 3
11:19:17 [120022.175622] Demod State = 0
11:19:17 [120022.191633] Demod State = 0
11:19:17 [120022.207625] Demod State = 0
11:19:17 [120022.224846] Demod State = 3
11:19:17 [120022.243684] Demod State = 0
11:19:17 [120022.259675] Demod State = 0
11:19:17 [120022.275684] Demod State = 0
11:19:17 [120022.291668] Demod State = 3
11:19:17 [120022.309669] Demod State = 0
11:19:17 [120022.325831] Demod State = 0
11:19:17 [120022.339756] Demod State = 0
11:19:17 [120022.355686] Demod State = 3
11:19:17 [120022.372571] Demod State = 3
11:19:17 [120022.387687] Demod State = 0
11:19:17 [120022.403685] Demod State = 0
11:19:17 [120022.419685] Demod State = 3
11:19:17 [120022.435637] Demod State = 3
11:19:17 [120022.451671] Demod State = 3
11:19:17 [120022.467696] Demod State = 3
11:19:17 [120022.483679] Demod State = 0
11:19:17 [120022.499708] Demod State = 0
11:19:17 [120022.515688] Demod State = 0
11:19:17 [120022.531688] Demod State = 0
11:19:18 [120022.547689] Demod State = 0
11:19:18 [120022.563687] Demod State = 0
11:19:18 [120022.579679] Demod State = 0
11:19:18 [120022.595673] Demod State = 3
11:19:18 [120022.611650] Demod State = 0
11:19:18 [120022.627680] Demod State = 0
11:19:18 [120022.643689] Demod State = 0
11:19:18 [120022.659688] Demod State = 0
11:19:18 [120022.675768] Demod State = 0
11:19:18 [120022.691743] Demod State = 0
11:19:18 [120022.707731] Demod State = 0
11:19:18 [120022.723680] Demod State = 3
11:19:18 [120022.739677] Demod State = 3
11:19:18 [120022.759687] Demod State = 0
11:19:18 [120022.775649] Demod State = 0
11:19:18 [120022.791531] Demod State = 3
11:19:18 [120022.807560] Demod State = 0
11:19:18 [120022.823524] Demod State = 0
11:19:18 [120022.839510] Demod State = 0
11:19:18 [120022.855558] Demod State = 0
11:19:18 [120022.871519] Demod State = 0
11:19:18 [120022.887563] Demod State = 0
11:19:18 [120022.903528] Demod State = 3
11:19:18 [120022.919531] Demod State = 0
11:19:18 [120022.935538] Demod State = 3
11:19:18 [120022.951515] Demod State = 0
11:19:18 [120022.967524] Demod State = 3
11:19:18 [120022.982604] DEMOD LOCK FAIL
11:19:18 [120023.090545] lock: srate=1064304640 r0=0x0 r1=0x0 r2=0xa8 r3=0x3e 
11:19:18 [120023.090557] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0xa80 srate_coarse=33453369 tmg_cpt=10
11:19:18 [120023.098103] lock: srate=1056178176 r0=0x0 r1=0x0 r2=0x8c r3=0x3e 
11:19:18 [120023.105643] lock: srate=1061945344 r0=0x0 r1=0x0 r2=0xc8 r3=0x3d 
11:19:18 [120023.122849] Demod State = 0
11:19:18 [120023.139549] Demod State = 3
11:19:18 [120023.155537] Demod State = 0
11:19:18 [120023.171512] Demod State = 0
11:19:18 [120023.187512] Demod State = 3
11:19:18 [120023.203522] Demod State = 0
11:19:18 [120023.219511] Demod State = 0
11:19:18 [120023.235535] Demod State = 0
11:19:18 [120023.251513] Demod State = 0
11:19:18 [120023.267513] Demod State = 0
11:19:18 [120023.283520] Demod State = 3
11:19:18 [120023.299518] Demod State = 0
11:19:18 [120023.315537] Demod State = 0
11:19:18 [120023.331516] Demod State = 0
11:19:18 [120023.347515] Demod State = 3
11:19:18 [120023.363521] Demod State = 0
11:19:18 [120023.379510] Demod State = 3
11:19:18 [120023.395559] Demod State = 3
11:19:18 [120023.411514] Demod State = 3
11:19:18 [120023.427675] Demod State = 0
11:19:18 [120023.443636] Demod State = 3
11:19:18 [120023.459654] Demod State = 0
11:19:18 [120023.475631] Demod State = 0
11:19:18 [120023.491645] Demod State = 3
11:19:18 [120023.507623] Demod State = 0
11:19:18 [120023.523636] Demod State = 0
11:19:18 [120023.539632] Demod State = 0
11:19:19 [120023.555674] Demod State = 0
11:19:19 [120023.571613] Demod State = 3
11:19:19 [120023.587654] Demod State = 0
11:19:19 [120023.603622] Demod State = 0
11:19:19 [120023.619620] Demod State = 3
11:19:19 [120023.635717] Demod State = 3
11:19:19 [120023.651523] Demod State = 3
11:19:19 [120023.667516] Demod State = 3
11:19:19 [120023.683518] Demod State = 0
11:19:19 [120023.699525] Demod State = 3
11:19:19 [120023.715709] Demod State = 0
11:19:19 [120023.731517] Demod State = 0
11:19:19 [120023.747618] Demod State = 0
11:19:19 [120023.763527] Demod State = 3
11:19:19 [120023.779536] Demod State = 0
11:19:19 [120023.795886] Demod State = 3
11:19:19 [120023.811615] Demod State = 0
11:19:19 [120023.827648] Demod State = 3
11:19:19 [120023.843633] Demod State = 0
11:19:19 [120023.859634] Demod State = 0
11:19:19 [120023.877173] Demod State = 0
11:19:19 [120023.891642] Demod State = 0
11:19:19 [120023.907761] Demod State = 0
11:19:19 [120023.923654] Demod State = 0
11:19:19 [120023.939700] Demod State = 0
11:19:19 [120023.955769] Demod State = 3
11:19:19 [120023.971651] Demod State = 3
11:19:19 [120023.987660] Demod State = 3
11:19:19 [120024.003616] Demod State = 0
11:19:19 [120024.019616] Demod State = 0
11:19:19 [120024.035621] Demod State = 3
11:19:19 [120024.051676] Demod State = 0
11:19:19 [120024.067632] Demod State = 3
11:19:19 [120024.083618] Demod State = 3
11:19:19 [120024.099633] Demod State = 0
11:19:19 [120024.115635] Demod State = 0
11:19:19 [120024.131639] Demod State = 0
11:19:19 [120024.147622] Demod State = 0
11:19:19 [120024.163643] Demod State = 0
11:19:19 [120024.179645] Demod State = 3
11:19:19 [120024.195631] Demod State = 3
11:19:19 [120024.211648] Demod State = 0
11:19:19 [120024.227624] Demod State = 0
11:19:19 [120024.242675] DEMOD LOCK FAIL
11:19:19 [120024.350951] lock: srate=8388608 r0=0x0 r1=0x0 r2=0x80 r3=0x0 
11:19:19 [120024.350954] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0xd7 srate_coarse=263671 tmg_cpt=10
11:19:19 [120024.380716] Search Fail
11:19:19 [120024.380719] stv0900_read_status: 
11:19:19 [120024.381661] stv0900_status: locked = 0
11:19:19 [120024.385485] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:19 [120024.385487] TS bitrate = 270 Mbit/sec 
11:19:19 [120024.385488] DEMOD LOCK FAIL
11:19:19 [120024.385512] stv0900_read_status: 
11:19:19 [120024.386463] stv0900_status: locked = 0
11:19:19 [120024.390265] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:19 [120024.390267] TS bitrate = 270 Mbit/sec 
11:19:19 [120024.390268] DEMOD LOCK FAIL
11:19:20 [120025.406670] stv0900_read_status: 
11:19:20 [120025.407624] stv0900_status: locked = 0
11:19:20 [120025.411428] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:20 [120025.411429] TS bitrate = 270 Mbit/sec 
11:19:20 [120025.411430] DEMOD LOCK FAIL
11:19:21 [120026.426678] stv0900_read_status: 
11:19:21 [120026.427629] stv0900_status: locked = 0
11:19:21 [120026.431424] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:21 [120026.431426] TS bitrate = 270 Mbit/sec 
11:19:21 [120026.431427] DEMOD LOCK FAIL
11:19:22 [120027.446667] stv0900_read_status: 
11:19:22 [120027.447627] stv0900_status: locked = 0
11:19:22 [120027.451486] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:22 [120027.451488] TS bitrate = 270 Mbit/sec 
11:19:22 [120027.451489] DEMOD LOCK FAIL
11:19:23 [120028.466658] stv0900_read_status: 
11:19:23 [120028.467617] stv0900_status: locked = 0
11:19:23 [120028.471429] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:23 [120028.471430] TS bitrate = 270 Mbit/sec 
11:19:23 [120028.471432] DEMOD LOCK FAIL
11:19:24 [120029.486731] stv0900_read_status: 
11:19:24 [120029.487719] stv0900_status: locked = 0
11:19:24 [120029.491544] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:24 [120029.491546] TS bitrate = 270 Mbit/sec 
11:19:24 [120029.491547] DEMOD LOCK FAIL
11:19:25 [120030.506652] stv0900_read_status: 
11:19:25 [120030.507611] stv0900_status: locked = 0
11:19:25 [120030.511384] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:25 [120030.511385] TS bitrate = 270 Mbit/sec 
11:19:25 [120030.511386] DEMOD LOCK FAIL
11:19:26 [120031.526660] stv0900_read_status: 
11:19:26 [120031.527643] stv0900_status: locked = 0
11:19:26 [120031.531514] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:26 [120031.531516] TS bitrate = 270 Mbit/sec 
11:19:26 [120031.531517] DEMOD LOCK FAIL
11:19:28 [120032.546646] stv0900_read_status: 
11:19:28 [120032.547628] stv0900_status: locked = 0
11:19:28 [120032.551480] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:28 [120032.551482] TS bitrate = 270 Mbit/sec 
11:19:28 [120032.551483] DEMOD LOCK FAIL
11:19:29 [120033.570632] stv0900_read_status: 
11:19:29 [120033.571603] stv0900_status: locked = 0
11:19:29 [120033.575451] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:29 [120033.575452] TS bitrate = 270 Mbit/sec 
11:19:29 [120033.575453] DEMOD LOCK FAIL
11:19:30 [120034.594633] stv0900_read_status: 
11:19:30 [120034.595620] stv0900_status: locked = 0
11:19:30 [120034.599480] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:30 [120034.599482] TS bitrate = 270 Mbit/sec 
11:19:30 [120034.599483] DEMOD LOCK FAIL
11:19:31 [120035.619050] stv0900_read_status: 
11:19:31 [120035.621031] stv0900_status: locked = 0
11:19:31 [120035.624895] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:31 [120035.624897] TS bitrate = 270 Mbit/sec 
11:19:31 [120035.624898] DEMOD LOCK FAIL
11:19:32 [120036.646618] stv0900_read_status: 
11:19:32 [120036.647599] stv0900_status: locked = 0
11:19:32 [120036.651475] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:32 [120036.651477] TS bitrate = 270 Mbit/sec 
11:19:32 [120036.651478] DEMOD LOCK FAIL
11:19:33 [120037.670612] stv0900_read_status: 
11:19:33 [120037.671592] stv0900_status: locked = 0
11:19:33 [120037.677600] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:33 [120037.677602] TS bitrate = 270 Mbit/sec 
11:19:33 [120037.677603] DEMOD LOCK FAIL
11:19:34 [120038.698612] stv0900_read_status: 
11:19:34 [120038.699600] stv0900_status: locked = 0
11:19:34 [120038.703455] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:34 [120038.703457] TS bitrate = 270 Mbit/sec 
11:19:34 [120038.703458] DEMOD LOCK FAIL
11:19:35 [120039.726604] stv0900_read_status: 
11:19:35 [120039.727590] stv0900_status: locked = 0
11:19:35 [120039.731578] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:35 [120039.731579] TS bitrate = 270 Mbit/sec 
11:19:35 [120039.731581] DEMOD LOCK FAIL
11:19:36 [120040.754604] stv0900_read_status: 
11:19:36 [120040.757702] stv0900_status: locked = 0
11:19:36 [120040.761604] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:36 [120040.761605] TS bitrate = 270 Mbit/sec 
11:19:36 [120040.761607] DEMOD LOCK FAIL
11:19:37 [120041.782590] stv0900_read_status: 
11:19:37 [120041.783575] stv0900_status: locked = 0
11:19:37 [120041.791745] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:37 [120041.791747] TS bitrate = 270 Mbit/sec 
11:19:37 [120041.791748] DEMOD LOCK FAIL
11:19:38 [120042.814581] stv0900_read_status: 
11:19:38 [120042.815537] stv0900_status: locked = 0
11:19:38 [120042.819354] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:38 [120042.819356] TS bitrate = 270 Mbit/sec 
11:19:38 [120042.819357] DEMOD LOCK FAIL
11:19:39 [120043.842569] stv0900_read_status: 
11:19:39 [120043.843520] stv0900_status: locked = 0
11:19:39 [120043.847307] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:39 [120043.847308] TS bitrate = 270 Mbit/sec 
11:19:39 [120043.847310] DEMOD LOCK FAIL
11:19:40 [120044.870568] stv0900_read_status: 
11:19:40 [120044.871515] stv0900_status: locked = 0
11:19:40 [120044.875291] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:40 [120044.875292] TS bitrate = 270 Mbit/sec 
11:19:40 [120044.875293] DEMOD LOCK FAIL
11:19:41 [120045.890563] stv0900_read_status: 
11:19:41 [120045.891528] stv0900_status: locked = 0
11:19:41 [120045.895342] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:41 [120045.895344] TS bitrate = 270 Mbit/sec 
11:19:41 [120045.895345] DEMOD LOCK FAIL
11:19:42 [120046.910563] stv0900_read_status: 
11:19:42 [120046.911512] stv0900_status: locked = 0
11:19:42 [120046.915291] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:42 [120046.915292] TS bitrate = 270 Mbit/sec 
11:19:42 [120046.915294] DEMOD LOCK FAIL
11:19:43 [120047.930558] stv0900_read_status: 
11:19:43 [120047.931507] stv0900_status: locked = 0
11:19:43 [120047.935285] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:43 [120047.935287] TS bitrate = 270 Mbit/sec 
11:19:43 [120047.935288] DEMOD LOCK FAIL
11:19:44 [120048.950551] stv0900_read_status: 
11:19:44 [120048.951507] stv0900_status: locked = 0
11:19:44 [120048.955284] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:44 [120048.955286] TS bitrate = 270 Mbit/sec 
11:19:44 [120048.955287] DEMOD LOCK FAIL
11:19:45 [120049.970543] stv0900_read_status: 
11:19:45 [120049.971491] stv0900_status: locked = 0
11:19:45 [120049.975266] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:45 [120049.975268] TS bitrate = 270 Mbit/sec 
11:19:45 [120049.975269] DEMOD LOCK FAIL
11:19:46 [120050.990539] stv0900_read_status: 
11:19:46 [120050.991492] stv0900_status: locked = 0
11:19:46 [120050.995266] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:46 [120050.995267] TS bitrate = 270 Mbit/sec 
11:19:46 [120050.995268] DEMOD LOCK FAIL
11:19:47 [120052.010527] stv0900_read_status: 
11:19:47 [120052.011473] stv0900_status: locked = 0
11:19:47 [120052.015251] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:47 [120052.015253] TS bitrate = 270 Mbit/sec 
11:19:47 [120052.015254] DEMOD LOCK FAIL
11:19:48 [120053.030524] stv0900_read_status: 
11:19:48 [120053.031472] stv0900_status: locked = 0
11:19:48 [120053.035250] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:48 [120053.035251] TS bitrate = 270 Mbit/sec 
11:19:48 [120053.035252] DEMOD LOCK FAIL
11:19:49 [120054.050520] stv0900_read_status: 
11:19:49 [120054.051474] stv0900_status: locked = 0
11:19:49 [120054.055272] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:49 [120054.055273] TS bitrate = 270 Mbit/sec 
11:19:49 [120054.055274] DEMOD LOCK FAIL
11:19:50 [120055.070508] stv0900_read_status: 
11:19:50 [120055.071460] stv0900_status: locked = 0
11:19:50 [120055.075339] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:50 [120055.075341] TS bitrate = 270 Mbit/sec 
11:19:50 [120055.075342] DEMOD LOCK FAIL
11:19:51 [120056.094508] stv0900_read_status: 
11:19:51 [120056.095461] stv0900_status: locked = 0
11:19:51 [120056.099268] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:51 [120056.099270] TS bitrate = 270 Mbit/sec 
11:19:51 [120056.099271] DEMOD LOCK FAIL
11:19:52 [120057.118501] stv0900_read_status: 
11:19:52 [120057.119455] stv0900_status: locked = 0
11:19:52 [120057.123273] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:52 [120057.123275] TS bitrate = 270 Mbit/sec 
11:19:52 [120057.123276] DEMOD LOCK FAIL
11:19:53 [120058.142503] stv0900_read_status: 
11:19:53 [120058.143453] stv0900_status: locked = 0
11:19:53 [120058.147233] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:53 [120058.147235] TS bitrate = 270 Mbit/sec 
11:19:53 [120058.147236] DEMOD LOCK FAIL
11:19:54 [120059.166508] stv0900_read_status: 
11:19:54 [120059.167475] stv0900_status: locked = 0
11:19:54 [120059.171339] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:54 [120059.171341] TS bitrate = 270 Mbit/sec 
11:19:54 [120059.171342] DEMOD LOCK FAIL
11:19:55 [120060.190500] stv0900_read_status: 
11:19:55 [120060.191462] stv0900_status: locked = 0
11:19:55 [120060.195438] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:55 [120060.195440] TS bitrate = 270 Mbit/sec 
11:19:55 [120060.195441] DEMOD LOCK FAIL
11:19:56 [120061.219297] stv0900_read_status: 
11:19:56 [120061.220265] stv0900_status: locked = 0
11:19:56 [120061.224107] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:56 [120061.224109] TS bitrate = 270 Mbit/sec 
11:19:56 [120061.224110] DEMOD LOCK FAIL
11:19:57 [120062.246490] stv0900_read_status: 
11:19:57 [120062.247452] stv0900_status: locked = 0
11:19:57 [120062.253504] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:57 [120062.253506] TS bitrate = 270 Mbit/sec 
11:19:57 [120062.253507] DEMOD LOCK FAIL
11:19:58 [120063.274485] stv0900_read_status: 
11:19:58 [120063.275457] stv0900_status: locked = 0
11:19:58 [120063.279303] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:58 [120063.279305] TS bitrate = 270 Mbit/sec 
11:19:58 [120063.279306] DEMOD LOCK FAIL
11:19:59 [120064.302478] stv0900_read_status: 
11:19:59 [120064.303441] stv0900_status: locked = 0
11:19:59 [120064.307316] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:19:59 [120064.307318] TS bitrate = 270 Mbit/sec 
11:19:59 [120064.307319] DEMOD LOCK FAIL
11:20:00 [120065.330473] stv0900_read_status: 
11:20:00 [120065.331423] stv0900_status: locked = 0
11:20:00 [120065.335195] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:00 [120065.335197] TS bitrate = 270 Mbit/sec 
11:20:00 [120065.335198] DEMOD LOCK FAIL
11:20:01 [120066.358358] stv0900_read_status: 
11:20:01 [120066.359322] stv0900_status: locked = 0
11:20:01 [120066.363104] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:01 [120066.363105] TS bitrate = 270 Mbit/sec 
11:20:01 [120066.363107] DEMOD LOCK FAIL
11:20:02 [120067.378456] stv0900_read_status: 
11:20:02 [120067.379423] stv0900_status: locked = 0
11:20:02 [120067.383290] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:02 [120067.383292] TS bitrate = 270 Mbit/sec 
11:20:02 [120067.383293] DEMOD LOCK FAIL
11:20:03 [120068.398448] stv0900_read_status: 
11:20:03 [120068.399403] stv0900_status: locked = 0
11:20:03 [120068.403196] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:03 [120068.403197] TS bitrate = 270 Mbit/sec 
11:20:03 [120068.403199] DEMOD LOCK FAIL
11:20:04 [120069.418441] stv0900_read_status: 
11:20:04 [120069.419396] stv0900_status: locked = 0
11:20:04 [120069.423174] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:04 [120069.423175] TS bitrate = 270 Mbit/sec 
11:20:04 [120069.423177] DEMOD LOCK FAIL
11:20:05 [120070.438435] stv0900_read_status: 
11:20:05 [120070.439387] stv0900_status: locked = 0
11:20:05 [120070.443168] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:05 [120070.443170] TS bitrate = 270 Mbit/sec 
11:20:05 [120070.443171] DEMOD LOCK FAIL
11:20:06 [120071.458428] stv0900_read_status: 
11:20:06 [120071.459380] stv0900_status: locked = 0
11:20:06 [120071.463156] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:06 [120071.463158] TS bitrate = 270 Mbit/sec 
11:20:06 [120071.463159] DEMOD LOCK FAIL
11:20:07 [120072.478426] stv0900_read_status: 
11:20:07 [120072.479376] stv0900_status: locked = 0
11:20:07 [120072.483184] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:07 [120072.483185] TS bitrate = 270 Mbit/sec 
11:20:07 [120072.483187] DEMOD LOCK FAIL
11:20:08 [120073.498424] stv0900_read_status: 
11:20:08 [120073.499368] stv0900_status: locked = 0
11:20:08 [120073.503143] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:08 [120073.503144] TS bitrate = 270 Mbit/sec 
11:20:08 [120073.503145] DEMOD LOCK FAIL
11:20:09 [120074.518592] stv0900_read_status: 
11:20:09 [120074.519575] stv0900_status: locked = 0
11:20:09 [120074.523414] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:09 [120074.523416] TS bitrate = 270 Mbit/sec 
11:20:09 [120074.523417] DEMOD LOCK FAIL
11:20:10 [120075.538416] stv0900_read_status: 
11:20:10 [120075.539362] stv0900_status: locked = 0
11:20:11 [120075.543138] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:11 [120075.543139] TS bitrate = 270 Mbit/sec 
11:20:11 [120075.543141] DEMOD LOCK FAIL
11:20:12 [120076.558407] stv0900_read_status: 
11:20:12 [120076.559357] stv0900_status: locked = 0
11:20:12 [120076.563146] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:12 [120076.563148] TS bitrate = 270 Mbit/sec 
11:20:12 [120076.563149] DEMOD LOCK FAIL
11:20:13 [120077.578300] stv0900_read_status: 
11:20:13 [120077.579245] stv0900_status: locked = 0
11:20:13 [120077.583022] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:13 [120077.583023] TS bitrate = 270 Mbit/sec 
11:20:13 [120077.583024] DEMOD LOCK FAIL
11:20:14 [120078.602299] stv0900_read_status: 
11:20:14 [120078.603249] stv0900_status: locked = 0
11:20:14 [120078.607032] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:14 [120078.607034] TS bitrate = 270 Mbit/sec 
11:20:14 [120078.607035] DEMOD LOCK FAIL
11:20:15 [120079.626297] stv0900_read_status: 
11:20:15 [120079.627265] stv0900_status: locked = 0
11:20:15 [120079.631044] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:15 [120079.631046] TS bitrate = 270 Mbit/sec 
11:20:15 [120079.631047] DEMOD LOCK FAIL
11:20:16 [120080.650403] stv0900_read_status: 
11:20:16 [120080.651348] stv0900_status: locked = 0
11:20:16 [120080.655130] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:16 [120080.655131] TS bitrate = 270 Mbit/sec 
11:20:16 [120080.655132] DEMOD LOCK FAIL
11:20:17 [120081.674490] stv0900_read_status: 
11:20:17 [120081.675436] stv0900_status: locked = 0
11:20:17 [120081.679211] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:17 [120081.679212] TS bitrate = 270 Mbit/sec 
11:20:17 [120081.679213] DEMOD LOCK FAIL
11:20:18 [120082.698384] stv0900_read_status: 
11:20:18 [120082.699352] stv0900_status: locked = 0
11:20:18 [120082.703159] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:18 [120082.703160] TS bitrate = 270 Mbit/sec 
11:20:18 [120082.703161] DEMOD LOCK FAIL
11:20:19 [120083.722386] stv0900_read_status: 
11:20:19 [120083.723373] stv0900_status: locked = 0
11:20:19 [120083.727251] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:19 [120083.727252] TS bitrate = 270 Mbit/sec 
11:20:19 [120083.727253] DEMOD LOCK FAIL
11:20:19 [120084.382383] stv0900_search: 
11:20:19 [120084.382386] stv0900_algo
11:20:19 [120084.389397] stv0900_set_symbol_rate: Mclk 135000000, SR 1000000, Dmd 0
11:20:19 [120084.397234] stb6100_read_regs:     Read from 0x60
11:20:19 [120084.397236] stb6100_read_regs:         LD: 0x81
11:20:19 [120084.397238] stb6100_read_regs:         VCO: 0x66
11:20:19 [120084.397239] stb6100_read_regs:         NI: 0x3c
11:20:19 [120084.397241] stb6100_read_regs:         NF: 0xb4
11:20:19 [120084.397242] stb6100_read_regs:         K: 0x3d
11:20:19 [120084.397244] stb6100_read_regs:         G: 0x39
11:20:19 [120084.397245] stb6100_read_regs:         F: 0xdf
11:20:19 [120084.397246] stb6100_read_regs:         DLB: 0xdc
11:20:19 [120084.397248] stb6100_read_regs:         TEST1: 0x8f
11:20:19 [120084.397249] stb6100_read_regs:         FCCK: 0x0d
11:20:19 [120084.397251] stb6100_read_regs:         LPEN: 0xfb
11:20:19 [120084.397252] stb6100_read_regs:         TEST3: 0xde
11:20:19 [120084.397254] stb6100_set_frequency: Get frontend parameters
11:20:19 [120084.397256] stb6100_write_reg_range:     Write @ 0x60: [1:11]
11:20:19 [120084.397258] stb6100_write_reg_range:         VCO: 0x66
11:20:19 [120084.397259] stb6100_write_reg_range:         NI: 0x3c
11:20:19 [120084.397261] stb6100_write_reg_range:         NF: 0xb4
11:20:19 [120084.397262] stb6100_write_reg_range:         K: 0x3d
11:20:19 [120084.397263] stb6100_write_reg_range:         G: 0x39
11:20:19 [120084.397265] stb6100_write_reg_range:         F: 0xdf
11:20:19 [120084.397266] stb6100_write_reg_range:         DLB: 0xdc
11:20:19 [120084.397268] stb6100_write_reg_range:         TEST1: 0x8f
11:20:19 [120084.397269] stb6100_write_reg_range:         FCCK: 0x0d
11:20:19 [120084.397271] stb6100_write_reg_range:         LPEN: 0xeb
11:20:19 [120084.397272] stb6100_write_reg_range:         TEST3: 0xde
11:20:19 [120084.399718] stb6100_set_frequency: frequency = 1643000, srate = 27499505, g = 9, odiv = 0, psd2 = 1, fxtal = 27000, osm = 6, fvco = 3286000, N(I) = 60, N(F) = 436
11:20:19 [120084.406373] stb6100_write_reg_range:     Write @ 0x60: [1:11]
11:20:19 [120084.406377] stb6100_write_reg_range:         VCO: 0xe6
11:20:19 [120084.406379] stb6100_write_reg_range:         NI: 0x3c
11:20:19 [120084.406380] stb6100_write_reg_range:         NF: 0xb4
11:20:19 [120084.406381] stb6100_write_reg_range:         K: 0x3d
11:20:19 [120084.406383] stb6100_write_reg_range:         G: 0x39
11:20:19 [120084.406384] stb6100_write_reg_range:         F: 0xdf
11:20:19 [120084.406386] stb6100_write_reg_range:         DLB: 0xdc
11:20:19 [120084.406387] stb6100_write_reg_range:         TEST1: 0x8f
11:20:19 [120084.406388] stb6100_write_reg_range:         FCCK: 0x4d
11:20:19 [120084.406390] stb6100_write_reg_range:         LPEN: 0xeb
11:20:19 [120084.406391] stb6100_write_reg_range:         TEST3: 0xde
11:20:19 [120084.414378] stb6100_write_reg_range:     Write @ 0x60: [10:1]
11:20:19 [120084.414381] stb6100_write_reg_range:         LPEN: 0xfb
11:20:19 [120084.415002] stb6100_write_reg_range:     Write @ 0x60: [1:1]
11:20:19 [120084.415003] stb6100_write_reg_range:         VCO: 0x86
11:20:19 [120084.430374] stb6100_write_reg_range:     Write @ 0x60: [1:1]
11:20:19 [120084.430377] stb6100_write_reg_range:         VCO: 0x66
11:20:19 [120084.430988] stb6100_write_reg_range:     Write @ 0x60: [1:9]
11:20:19 [120084.430989] stb6100_write_reg_range:         VCO: 0x66
11:20:19 [120084.430991] stb6100_write_reg_range:         NI: 0x3c
11:20:19 [120084.430992] stb6100_write_reg_range:         NF: 0xb4
11:20:19 [120084.430994] stb6100_write_reg_range:         K: 0x3d
11:20:19 [120084.430995] stb6100_write_reg_range:         G: 0x39
11:20:19 [120084.430996] stb6100_write_reg_range:         F: 0xdf
11:20:19 [120084.430998] stb6100_write_reg_range:         DLB: 0xdc
11:20:19 [120084.430999] stb6100_write_reg_range:         TEST1: 0x8f
11:20:19 [120084.431001] stb6100_write_reg_range:         FCCK: 0x0d
11:20:19 [120084.536138] stv0900_set_tuner: Frequency=1643000
11:20:19 [120084.537888] stb6100_set_bandwidth: set bandwidth to 72000000 Hz
11:20:19 [120084.537891] stb6100_write_reg_range:     Write @ 0x60: [9:1]
11:20:19 [120084.537893] stb6100_write_reg_range:         FCCK: 0x4d
11:20:19 [120084.538471] stb6100_write_reg_range:     Write @ 0x60: [6:1]
11:20:19 [120084.538472] stb6100_write_reg_range:         F: 0xdf
11:20:20 [120084.546379] stb6100_write_reg_range:     Write @ 0x60: [9:1]
11:20:20 [120084.546383] stb6100_write_reg_range:         FCCK: 0x0d
11:20:20 [120084.548748] stv0900_set_tuner: Bandwidth=72000000
11:20:20 [120084.554187] stv0900_set_search_standard
11:20:20 [120084.554188] Search Standard = AUTO
11:20:20 [120084.563395] stv0900_activate_s2_modcod_single
11:20:20 [120084.577870] stv0900_set_viterbi_tracq
11:20:20 [120084.582442] stv0900_set_viterbi_standard: ViterbiStandard = 
11:20:20 [120084.582443] Auto
11:20:20 [120084.583986] stv0900_blind_search_algo
11:20:20 [120084.583988] stv0900_blind_check_agc2_min_level
11:20:20 [120084.592520] stv0900_set_symbol_rate: Mclk 135000000, SR 1000000, Dmd 0
11:20:20 [120084.958017] stv0900_blind_search_algo agc2_int=277 agc2_th=700 
11:20:20 [120085.071589] lock: srate=823918592 r0=0x0 r1=0x0 r2=0x4c r3=0x30 
11:20:20 [120085.071592] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x894 srate_coarse=25897521 tmg_cpt=10
11:20:20 [120085.079488] lock: srate=804519936 r0=0x0 r1=0x0 r2=0x24 r3=0x31 
11:20:20 [120085.087411] lock: srate=815005696 r0=0x0 r1=0x0 r2=0x78 r3=0x31 
11:20:20 [120085.107400] Demod State = 0
11:20:20 [120085.125460] Demod State = 0
11:20:20 [120085.139357] Demod State = 0
11:20:20 [120085.155333] Demod State = 3
11:20:20 [120085.171397] Demod State = 0
11:20:20 [120085.187314] Demod State = 0
11:20:20 [120085.203330] Demod State = 0
11:20:20 [120085.219330] Demod State = 3
11:20:20 [120085.235316] Demod State = 0
11:20:20 [120085.251304] Demod State = 3
11:20:20 [120085.267339] Demod State = 3
11:20:20 [120085.283375] Demod State = 0
11:20:20 [120085.299361] Demod State = 0
11:20:20 [120085.315460] Demod State = 0
11:20:20 [120085.331365] Demod State = 0
11:20:20 [120085.347447] Demod State = 0
11:20:20 [120085.363381] Demod State = 0
11:20:20 [120085.379359] Demod State = 0
11:20:20 [120085.395340] Demod State = 0
11:20:20 [120085.411305] Demod State = 3
11:20:20 [120085.427335] Demod State = 0
11:20:20 [120085.443335] Demod State = 0
11:20:20 [120085.459335] Demod State = 0
11:20:20 [120085.475333] Demod State = 3
11:20:20 [120085.491333] Demod State = 3
11:20:20 [120085.507336] Demod State = 0
11:20:20 [120085.523375] Demod State = 0
11:20:20 [120085.539335] Demod State = 3
11:20:21 [120085.555360] Demod State = 0
11:20:21 [120085.571378] Demod State = 3
11:20:21 [120085.587416] Demod State = 0
11:20:21 [120085.604273] Demod State = 3
11:20:21 [120085.619363] Demod State = 3
11:20:21 [120085.636307] Demod State = 3
11:20:21 [120085.651360] Demod State = 0
11:20:21 [120085.667358] Demod State = 0
11:20:21 [120085.683321] Demod State = 3
11:20:21 [120085.699290] Demod State = 3
11:20:21 [120085.715214] Demod State = 0
11:20:21 [120085.731246] Demod State = 0
11:20:21 [120085.747212] Demod State = 0
11:20:21 [120085.763201] Demod State = 3
11:20:21 [120085.779205] Demod State = 0
11:20:21 [120085.795210] Demod State = 3
11:20:21 [120085.811204] Demod State = 0
11:20:21 [120085.827205] Demod State = 0
11:20:21 [120085.843210] Demod State = 0
11:20:21 [120085.859200] Demod State = 3
11:20:21 [120085.875203] Demod State = 0
11:20:21 [120085.891193] Demod State = 3
11:20:21 [120085.907212] Demod State = 0
11:20:21 [120085.923336] Demod State = 3
11:20:21 [120085.939309] Demod State = 3
11:20:21 [120085.955350] Demod State = 0
11:20:21 [120085.971339] Demod State = 0
11:20:21 [120085.987328] Demod State = 3
11:20:21 [120086.003331] Demod State = 3
11:20:21 [120086.019331] Demod State = 0
11:20:21 [120086.035322] Demod State = 3
11:20:21 [120086.051201] Demod State = 0
11:20:21 [120086.067207] Demod State = 0
11:20:21 [120086.083215] Demod State = 0
11:20:21 [120086.099204] Demod State = 0
11:20:21 [120086.115230] Demod State = 0
11:20:21 [120086.131199] Demod State = 3
11:20:21 [120086.147201] Demod State = 0
11:20:21 [120086.163221] Demod State = 0
11:20:21 [120086.179280] Demod State = 3
11:20:21 [120086.195205] Demod State = 3
11:20:21 [120086.211199] Demod State = 3
11:20:21 [120086.226253] DEMOD LOCK FAIL
11:20:21 [120086.334367] lock: srate=860618752 r0=0x0 r1=0x0 r2=0x98 r3=0x33 
11:20:21 [120086.334370] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x908 srate_coarse=27051086 tmg_cpt=10
11:20:21 [120086.341959] lock: srate=846200832 r0=0x0 r1=0x0 r2=0xd8 r3=0x32 
11:20:21 [120086.349622] lock: srate=870318080 r0=0x0 r1=0x0 r2=0x84 r3=0x33 
11:20:21 [120086.366859] Demod State = 0
11:20:21 [120086.383197] Demod State = 3
11:20:21 [120086.399209] Demod State = 3
11:20:21 [120086.415329] Demod State = 3
11:20:21 [120086.431306] Demod State = 3
11:20:21 [120086.447310] Demod State = 0
11:20:21 [120086.463296] Demod State = 0
11:20:21 [120086.479195] Demod State = 0
11:20:21 [120086.495227] Demod State = 0
11:20:21 [120086.511197] Demod State = 3
11:20:21 [120086.527203] Demod State = 3
11:20:22 [120086.543231] Demod State = 0
11:20:22 [120086.559203] Demod State = 3
11:20:22 [120086.575254] Demod State = 0
11:20:22 [120086.591198] Demod State = 3
11:20:22 [120086.607222] Demod State = 0
11:20:22 [120086.623205] Demod State = 3
11:20:22 [120086.639198] Demod State = 0
11:20:22 [120086.655219] Demod State = 0
11:20:22 [120086.671201] Demod State = 0
11:20:22 [120086.687198] Demod State = 0
11:20:22 [120086.703208] Demod State = 0
11:20:22 [120086.719210] Demod State = 3
11:20:22 [120086.735223] Demod State = 0
11:20:22 [120086.751217] Demod State = 0
11:20:22 [120086.767227] Demod State = 0
11:20:22 [120086.783303] Demod State = 0
11:20:22 [120086.799302] Demod State = 0
11:20:22 [120086.815290] Demod State = 0
11:20:22 [120086.831301] Demod State = 0
11:20:22 [120086.847302] Demod State = 3
11:20:22 [120086.863301] Demod State = 0
11:20:22 [120086.879303] Demod State = 0
11:20:22 [120086.895299] Demod State = 0
11:20:22 [120086.911305] Demod State = 0
11:20:22 [120086.927304] Demod State = 3
11:20:22 [120086.943300] Demod State = 0
11:20:22 [120086.959301] Demod State = 3
11:20:22 [120086.975302] Demod State = 3
11:20:22 [120086.991304] Demod State = 0
11:20:22 [120087.007303] Demod State = 0
11:20:22 [120087.023564] Demod State = 0
11:20:22 [120087.039326] Demod State = 0
11:20:22 [120087.055313] Demod State = 0
11:20:22 [120087.071194] Demod State = 0
11:20:22 [120087.087209] Demod State = 0
11:20:22 [120087.103203] Demod State = 0
11:20:22 [120087.119324] Demod State = 0
11:20:22 [120087.135234] Demod State = 3
11:20:22 [120087.151195] Demod State = 0
11:20:22 [120087.167193] Demod State = 3
11:20:22 [120087.183207] Demod State = 0
11:20:22 [120087.199219] Demod State = 0
11:20:22 [120087.215321] Demod State = 3
11:20:22 [120087.231343] Demod State = 0
11:20:22 [120087.247397] Demod State = 0
11:20:22 [120087.263345] Demod State = 3
11:20:22 [120087.279353] Demod State = 0
11:20:22 [120087.295400] Demod State = 0
11:20:22 [120087.311376] Demod State = 0
11:20:22 [120087.327429] Demod State = 0
11:20:22 [120087.343325] Demod State = 3
11:20:22 [120087.359306] Demod State = 3
11:20:22 [120087.375336] Demod State = 0
11:20:22 [120087.391334] Demod State = 0
11:20:22 [120087.407333] Demod State = 0
11:20:22 [120087.425432] Demod State = 0
11:20:22 [120087.439426] Demod State = 0
11:20:22 [120087.455303] Demod State = 0
11:20:22 [120087.471239] Demod State = 3
11:20:22 [120087.486359] DEMOD LOCK FAIL
11:20:23 [120087.594453] lock: srate=979107840 r0=0x0 r1=0x0 r2=0x30 r3=0x3a 
11:20:23 [120087.594457] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x9ac srate_coarse=30775451 tmg_cpt=10
11:20:23 [120087.602006] lock: srate=978321408 r0=0x0 r1=0x0 r2=0x5c r3=0x39 
11:20:23 [120087.609542] lock: srate=957612032 r0=0x0 r1=0x0 r2=0x78 r3=0x39 
11:20:23 [120087.626899] Demod State = 0
11:20:23 [120087.643327] Demod State = 0
11:20:23 [120087.659295] Demod State = 0
11:20:23 [120087.675524] Demod State = 0
11:20:23 [120087.691347] Demod State = 0
11:20:23 [120087.707350] Demod State = 3
11:20:23 [120087.727347] Demod State = 3
11:20:23 [120087.743408] Demod State = 0
11:20:23 [120087.759355] Demod State = 3
11:20:23 [120087.775354] Demod State = 0
11:20:23 [120087.791344] Demod State = 0
11:20:23 [120087.807359] Demod State = 3
11:20:23 [120087.825528] Demod State = 3
11:20:23 [120087.843353] Demod State = 0
11:20:23 [120087.859341] Demod State = 0
11:20:23 [120087.875438] Demod State = 0
11:20:23 [120087.891330] Demod State = 3
11:20:23 [120087.907328] Demod State = 0
11:20:23 [120087.923328] Demod State = 3
11:20:23 [120087.939300] Demod State = 3
11:20:23 [120087.955337] Demod State = 3
11:20:23 [120087.971295] Demod State = 3
11:20:23 [120087.987293] Demod State = 0
11:20:23 [120088.003301] Demod State = 0
11:20:23 [120088.019303] Demod State = 0
11:20:23 [120088.035297] Demod State = 3
11:20:23 [120088.051330] Demod State = 0
11:20:23 [120088.067354] Demod State = 0
11:20:23 [120088.083330] Demod State = 0
11:20:23 [120088.099280] Demod State = 3
11:20:23 [120088.115188] Demod State = 3
11:20:23 [120088.131188] Demod State = 0
11:20:23 [120088.147196] Demod State = 0
11:20:23 [120088.163190] Demod State = 3
11:20:23 [120088.179189] Demod State = 3
11:20:23 [120088.195187] Demod State = 0
11:20:23 [120088.211186] Demod State = 0
11:20:23 [120088.227189] Demod State = 3
11:20:23 [120088.243199] Demod State = 0
11:20:23 [120088.259188] Demod State = 0
11:20:23 [120088.275186] Demod State = 0
11:20:23 [120088.291188] Demod State = 3
11:20:23 [120088.307188] Demod State = 0
11:20:23 [120088.323385] Demod State = 0
11:20:23 [120088.339286] Demod State = 0
11:20:23 [120088.355287] Demod State = 3
11:20:23 [120088.371290] Demod State = 3
11:20:23 [120088.387291] Demod State = 0
11:20:23 [120088.403287] Demod State = 0
11:20:23 [120088.419290] Demod State = 0
11:20:23 [120088.435322] Demod State = 0
11:20:23 [120088.451302] Demod State = 3
11:20:23 [120088.467299] Demod State = 0
11:20:23 [120088.483289] Demod State = 3
11:20:23 [120088.499309] Demod State = 0
11:20:23 [120088.515298] Demod State = 0
11:20:23 [120088.531304] Demod State = 0
11:20:24 [120088.547298] Demod State = 3
11:20:24 [120088.563321] Demod State = 3
11:20:24 [120088.579296] Demod State = 0
11:20:24 [120088.595318] Demod State = 3
11:20:24 [120088.611299] Demod State = 3
11:20:24 [120088.627293] Demod State = 3
11:20:24 [120088.643301] Demod State = 0
11:20:24 [120088.659312] Demod State = 0
11:20:24 [120088.675322] Demod State = 3
11:20:24 [120088.691183] Demod State = 3
11:20:24 [120088.707185] Demod State = 3
11:20:24 [120088.723214] Demod State = 3
11:20:24 [120088.739188] Demod State = 0
11:20:24 [120088.754249] DEMOD LOCK FAIL
11:20:24 [120088.862431] lock: srate=1048576000 r0=0x0 r1=0x0 r2=0x84 r3=0x3e 
11:20:24 [120088.862434] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0xa7b srate_coarse=32958984 tmg_cpt=10
11:20:24 [120088.869967] lock: srate=1040187392 r0=0x0 r1=0x0 r2=0xa0 r3=0x3f 
11:20:24 [120088.877538] lock: srate=1042808832 r0=0x0 r1=0x0 r2=0xb8 r3=0x3e 
11:20:24 [120088.894740] Demod State = 0
11:20:24 [120088.911296] Demod State = 0
11:20:24 [120088.927323] Demod State = 0
11:20:24 [120088.943321] Demod State = 0
11:20:24 [120088.959301] Demod State = 0
11:20:24 [120088.975313] Demod State = 0
11:20:24 [120088.991288] Demod State = 0
11:20:24 [120089.007289] Demod State = 0
11:20:24 [120089.023289] Demod State = 0
11:20:24 [120089.039304] Demod State = 3
11:20:24 [120089.055372] Demod State = 3
11:20:24 [120089.071300] Demod State = 0
11:20:24 [120089.087304] Demod State = 0
11:20:24 [120089.103344] Demod State = 0
11:20:24 [120089.119341] Demod State = 0
11:20:24 [120089.135333] Demod State = 0
11:20:24 [120089.151305] Demod State = 0
11:20:24 [120089.167283] Demod State = 3
11:20:24 [120089.183286] Demod State = 3
11:20:24 [120089.199290] Demod State = 0
11:20:24 [120089.215317] Demod State = 0
11:20:24 [120089.231294] Demod State = 3
11:20:24 [120089.247287] Demod State = 0
11:20:24 [120089.263280] Demod State = 0
11:20:24 [120089.279288] Demod State = 0
11:20:24 [120089.295280] Demod State = 0
11:20:24 [120089.311282] Demod State = 0
11:20:24 [120089.327287] Demod State = 0
11:20:24 [120089.343283] Demod State = 0
11:20:24 [120089.359286] Demod State = 3
11:20:24 [120089.375285] Demod State = 3
11:20:24 [120089.391287] Demod State = 3
11:20:24 [120089.407284] Demod State = 0
11:20:24 [120089.423286] Demod State = 0
11:20:24 [120089.439277] Demod State = 3
11:20:24 [120089.455280] Demod State = 3
11:20:24 [120089.471284] Demod State = 3
11:20:24 [120089.487285] Demod State = 3
11:20:24 [120089.503424] Demod State = 0
11:20:24 [120089.521010] Demod State = 0
11:20:24 [120089.535350] Demod State = 0
11:20:25 [120089.551315] Demod State = 0
11:20:25 [120089.567370] Demod State = 3
11:20:25 [120089.583334] Demod State = 3
11:20:25 [120089.599323] Demod State = 3
11:20:25 [120089.616586] Demod State = 3
11:20:25 [120089.631269] Demod State = 3
11:20:25 [120089.647288] Demod State = 3
11:20:25 [120089.663288] Demod State = 0
11:20:25 [120089.679360] Demod State = 0
11:20:25 [120089.695284] Demod State = 3
11:20:25 [120089.711281] Demod State = 0
11:20:25 [120089.727295] Demod State = 0
11:20:25 [120089.743313] Demod State = 0
11:20:25 [120089.759278] Demod State = 3
11:20:25 [120089.775295] Demod State = 0
11:20:25 [120089.791279] Demod State = 3
11:20:25 [120089.807287] Demod State = 3
11:20:25 [120089.823309] Demod State = 0
11:20:25 [120089.839285] Demod State = 0
11:20:25 [120089.855283] Demod State = 0
11:20:25 [120089.871325] Demod State = 0
11:20:25 [120089.887333] Demod State = 0
11:20:25 [120089.903309] Demod State = 0
11:20:25 [120089.919329] Demod State = 3
11:20:25 [120089.935354] Demod State = 3
11:20:25 [120089.951337] Demod State = 0
11:20:25 [120089.967337] Demod State = 0
11:20:25 [120089.985479] Demod State = 3
11:20:25 [120090.003403] Demod State = 3
11:20:25 [120090.018350] DEMOD LOCK FAIL
11:20:25 [120090.131235] lock: srate=8388608 r0=0x0 r1=0x0 r2=0x80 r3=0x0 
11:20:25 [120090.131238] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0xe4 srate_coarse=263671 tmg_cpt=10
11:20:25 [120090.164412] Search Fail
11:20:25 [120090.164414] stv0900_read_status: 
11:20:25 [120090.165384] stv0900_status: locked = 0
11:20:25 [120090.169265] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:25 [120090.169266] TS bitrate = 270 Mbit/sec 
11:20:25 [120090.169267] DEMOD LOCK FAIL
11:20:25 [120090.169284] stv0900_read_status: 
11:20:25 [120090.170230] stv0900_status: locked = 0
11:20:25 [120090.174038] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:25 [120090.174040] TS bitrate = 270 Mbit/sec 
11:20:25 [120090.174041] DEMOD LOCK FAIL
11:20:26 [120090.666349] stv0900_search: 
11:20:26 [120090.666352] stv0900_algo
11:20:26 [120090.673331] stv0900_set_symbol_rate: Mclk 135000000, SR 1000000, Dmd 0
11:20:26 [120090.678969] stb6100_read_regs:     Read from 0x60
11:20:26 [120090.678971] stb6100_read_regs:         LD: 0x81
11:20:26 [120090.678973] stb6100_read_regs:         VCO: 0x66
11:20:26 [120090.678974] stb6100_read_regs:         NI: 0x3c
11:20:26 [120090.678976] stb6100_read_regs:         NF: 0xb4
11:20:26 [120090.678977] stb6100_read_regs:         K: 0x3d
11:20:26 [120090.678979] stb6100_read_regs:         G: 0x39
11:20:26 [120090.678980] stb6100_read_regs:         F: 0xdf
11:20:26 [120090.678981] stb6100_read_regs:         DLB: 0xdc
11:20:26 [120090.678983] stb6100_read_regs:         TEST1: 0x8f
11:20:26 [120090.678985] stb6100_read_regs:         FCCK: 0x0d
11:20:26 [120090.678986] stb6100_read_regs:         LPEN: 0xfb
11:20:26 [120090.678988] stb6100_read_regs:         TEST3: 0xde
11:20:26 [120090.678989] stb6100_set_frequency: Get frontend parameters
11:20:26 [120090.678991] stb6100_write_reg_range:     Write @ 0x60: [1:11]
11:20:26 [120090.678993] stb6100_write_reg_range:         VCO: 0x66
11:20:26 [120090.678995] stb6100_write_reg_range:         NI: 0x3c
11:20:26 [120090.678996] stb6100_write_reg_range:         NF: 0xb4
11:20:26 [120090.678998] stb6100_write_reg_range:         K: 0x3d
11:20:26 [120090.678999] stb6100_write_reg_range:         G: 0x39
11:20:26 [120090.679000] stb6100_write_reg_range:         F: 0xdf
11:20:26 [120090.679002] stb6100_write_reg_range:         DLB: 0xdc
11:20:26 [120090.679004] stb6100_write_reg_range:         TEST1: 0x8f
11:20:26 [120090.679005] stb6100_write_reg_range:         FCCK: 0x0d
11:20:26 [120090.679007] stb6100_write_reg_range:         LPEN: 0xeb
11:20:26 [120090.679008] stb6100_write_reg_range:         TEST3: 0xde
11:20:26 [120090.681400] stb6100_set_frequency: frequency = 1643000, srate = 27499505, g = 9, odiv = 0, psd2 = 1, fxtal = 27000, osm = 6, fvco = 3286000, N(I) = 60, N(F) = 436
11:20:26 [120090.686351] stb6100_write_reg_range:     Write @ 0x60: [1:11]
11:20:26 [120090.686355] stb6100_write_reg_range:         VCO: 0xe6
11:20:26 [120090.686356] stb6100_write_reg_range:         NI: 0x3c
11:20:26 [120090.686358] stb6100_write_reg_range:         NF: 0xb4
11:20:26 [120090.686359] stb6100_write_reg_range:         K: 0x3d
11:20:26 [120090.686360] stb6100_write_reg_range:         G: 0x39
11:20:26 [120090.686362] stb6100_write_reg_range:         F: 0xdf
11:20:26 [120090.686363] stb6100_write_reg_range:         DLB: 0xdc
11:20:26 [120090.686365] stb6100_write_reg_range:         TEST1: 0x8f
11:20:26 [120090.686366] stb6100_write_reg_range:         FCCK: 0x4d
11:20:26 [120090.686367] stb6100_write_reg_range:         LPEN: 0xeb
11:20:26 [120090.686369] stb6100_write_reg_range:         TEST3: 0xde
11:20:26 [120090.694350] stb6100_write_reg_range:     Write @ 0x60: [10:1]
11:20:26 [120090.694353] stb6100_write_reg_range:         LPEN: 0xfb
11:20:26 [120090.695032] stb6100_write_reg_range:     Write @ 0x60: [1:1]
11:20:26 [120090.695033] stb6100_write_reg_range:         VCO: 0x86
11:20:26 [120090.710349] stb6100_write_reg_range:     Write @ 0x60: [1:1]
11:20:26 [120090.710352] stb6100_write_reg_range:         VCO: 0x66
11:20:26 [120090.710964] stb6100_write_reg_range:     Write @ 0x60: [1:9]
11:20:26 [120090.710965] stb6100_write_reg_range:         VCO: 0x66
11:20:26 [120090.710967] stb6100_write_reg_range:         NI: 0x3c
11:20:26 [120090.710968] stb6100_write_reg_range:         NF: 0xb4
11:20:26 [120090.710970] stb6100_write_reg_range:         K: 0x3d
11:20:26 [120090.710971] stb6100_write_reg_range:         G: 0x39
11:20:26 [120090.710973] stb6100_write_reg_range:         F: 0xdf
11:20:26 [120090.710974] stb6100_write_reg_range:         DLB: 0xdc
11:20:26 [120090.710975] stb6100_write_reg_range:         TEST1: 0x8f
11:20:26 [120090.710977] stb6100_write_reg_range:         FCCK: 0x0d
11:20:26 [120090.816189] stv0900_set_tuner: Frequency=1643000
11:20:26 [120090.817929] stb6100_set_bandwidth: set bandwidth to 72000000 Hz
11:20:26 [120090.817932] stb6100_write_reg_range:     Write @ 0x60: [9:1]
11:20:26 [120090.817934] stb6100_write_reg_range:         FCCK: 0x4d
11:20:26 [120090.818515] stb6100_write_reg_range:     Write @ 0x60: [6:1]
11:20:26 [120090.818517] stb6100_write_reg_range:         F: 0xdf
11:20:26 [120090.826341] stb6100_write_reg_range:     Write @ 0x60: [9:1]
11:20:26 [120090.826344] stb6100_write_reg_range:         FCCK: 0x0d
11:20:26 [120090.828763] stv0900_set_tuner: Bandwidth=72000000
11:20:26 [120090.834195] stv0900_set_search_standard
11:20:26 [120090.834196] Search Standard = AUTO
11:20:26 [120090.843367] stv0900_activate_s2_modcod_single
11:20:26 [120090.857832] stv0900_set_viterbi_tracq
11:20:26 [120090.866666] stv0900_set_viterbi_standard: ViterbiStandard = 
11:20:26 [120090.866668] Auto
11:20:26 [120090.868177] stv0900_blind_search_algo
11:20:26 [120090.868178] stv0900_blind_check_agc2_min_level
11:20:26 [120090.876748] stv0900_set_symbol_rate: Mclk 135000000, SR 1000000, Dmd 0
11:20:26 [120091.235851] stv0900_blind_search_algo agc2_int=277 agc2_th=700 
11:20:26 [120091.354719] lock: srate=796393472 r0=0x0 r1=0x0 r2=0x98 r3=0x2f 
11:20:26 [120091.354723] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x870 srate_coarse=25032348 tmg_cpt=10
11:20:26 [120091.362291] lock: srate=834404352 r0=0x0 r1=0x0 r2=0x94 r3=0x2f 
11:20:26 [120091.369959] lock: srate=792461312 r0=0x0 r1=0x0 r2=0x8c r3=0x30 
11:20:26 [120091.387212] Demod State = 0
11:20:26 [120091.403306] Demod State = 0
11:20:26 [120091.419320] Demod State = 3
11:20:26 [120091.435576] Demod State = 0
11:20:26 [120091.451321] Demod State = 0
11:20:26 [120091.467307] Demod State = 0
11:20:26 [120091.483311] Demod State = 0
11:20:26 [120091.499329] Demod State = 0
11:20:26 [120091.515336] Demod State = 0
11:20:26 [120091.531344] Demod State = 0
11:20:27 [120091.547305] Demod State = 0
11:20:27 [120091.563314] Demod State = 0
11:20:27 [120091.579278] Demod State = 0
11:20:27 [120091.595281] Demod State = 0
11:20:27 [120091.611315] Demod State = 0
11:20:27 [120091.627286] Demod State = 3
11:20:27 [120091.644504] Demod State = 3
11:20:27 [120091.663304] Demod State = 0
11:20:27 [120091.679319] Demod State = 0
11:20:27 [120091.695389] Demod State = 0
11:20:27 [120091.711324] Demod State = 0
11:20:27 [120091.729437] Demod State = 3
11:20:27 [120091.747320] Demod State = 0
11:20:27 [120091.763332] Demod State = 0
11:20:27 [120091.779323] Demod State = 0
11:20:27 [120091.795334] Demod State = 0
11:20:27 [120091.811363] Demod State = 0
11:20:27 [120091.827326] Demod State = 0
11:20:27 [120091.843332] Demod State = 0
11:20:27 [120091.859314] Demod State = 0
11:20:27 [120091.875342] Demod State = 0
11:20:27 [120091.892412] Demod State = 0
11:20:27 [120091.907318] Demod State = 0
11:20:27 [120091.923327] Demod State = 3
11:20:27 [120091.939367] Demod State = 0
11:20:27 [120091.955327] Demod State = 0
11:20:27 [120091.971322] Demod State = 3
11:20:27 [120091.989493] Demod State = 0
11:20:27 [120092.003320] Demod State = 3
11:20:27 [120092.021410] Demod State = 3
11:20:27 [120092.039325] Demod State = 0
11:20:27 [120092.055342] Demod State = 0
11:20:27 [120092.071383] Demod State = 0
11:20:27 [120092.087406] Demod State = 0
11:20:27 [120092.103295] Demod State = 0
11:20:27 [120092.121387] Demod State = 0
11:20:27 [120092.135313] Demod State = 0
11:20:27 [120092.153385] Demod State = 3
11:20:27 [120092.171295] Demod State = 3
11:20:27 [120092.187331] Demod State = 0
11:20:27 [120092.203383] Demod State = 3
11:20:27 [120092.221382] Demod State = 0
11:20:27 [120092.235396] Demod State = 0
11:20:27 [120092.253421] Demod State = 3
11:20:27 [120092.271314] Demod State = 0
11:20:27 [120092.289463] Demod State = 3
11:20:27 [120092.307339] Demod State = 0
11:20:27 [120092.323355] Demod State = 3
11:20:27 [120092.339356] Demod State = 0
11:20:27 [120092.355328] Demod State = 3
11:20:27 [120092.371321] Demod State = 0
11:20:27 [120092.387418] Demod State = 0
11:20:27 [120092.403303] Demod State = 0
11:20:27 [120092.421384] Demod State = 0
11:20:27 [120092.435324] Demod State = 3
11:20:27 [120092.453432] Demod State = 3
11:20:27 [120092.471324] Demod State = 0
11:20:27 [120092.487289] Demod State = 0
11:20:27 [120092.503325] Demod State = 0
11:20:27 [120092.521383] Demod State = 0
11:20:27 [120092.534334] DEMOD LOCK FAIL
11:20:28 [120092.646126] lock: srate=854589440 r0=0x0 r1=0x0 r2=0x84 r3=0x33 
11:20:28 [120092.646130] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x900 srate_coarse=26861572 tmg_cpt=10
11:20:28 [120092.655999] lock: srate=871366656 r0=0x0 r1=0x0 r2=0x4 r3=0x33 
11:20:28 [120092.663754] lock: srate=869007360 r0=0x0 r1=0x0 r2=0x68 r3=0x34 
11:20:28 [120092.685613] Demod State = 0
11:20:28 [120092.699323] Demod State = 3
11:20:28 [120092.715863] Demod State = 3
11:20:28 [120092.731271] Demod State = 3
11:20:28 [120092.747262] Demod State = 0
11:20:28 [120092.763276] Demod State = 0
11:20:28 [120092.779280] Demod State = 0
11:20:28 [120092.795291] Demod State = 0
11:20:28 [120092.811272] Demod State = 0
11:20:28 [120092.827274] Demod State = 0
11:20:28 [120092.843274] Demod State = 3
11:20:28 [120092.859270] Demod State = 0
11:20:28 [120092.875276] Demod State = 3
11:20:28 [120092.891274] Demod State = 0
11:20:28 [120092.907288] Demod State = 3
11:20:28 [120092.923269] Demod State = 0
11:20:28 [120092.939265] Demod State = 0
11:20:28 [120092.955277] Demod State = 0
11:20:28 [120092.971277] Demod State = 3
11:20:28 [120092.987275] Demod State = 0
11:20:28 [120093.003276] Demod State = 0
11:20:28 [120093.019275] Demod State = 0
11:20:28 [120093.035275] Demod State = 3
11:20:28 [120093.051268] Demod State = 3
11:20:28 [120093.067347] Demod State = 0
11:20:28 [120093.083282] Demod State = 0
11:20:28 [120093.099278] Demod State = 3
11:20:28 [120093.115514] Demod State = 3
11:20:28 [120093.131272] Demod State = 3
11:20:28 [120093.147293] Demod State = 0
11:20:28 [120093.163273] Demod State = 0
11:20:28 [120093.179278] Demod State = 0
11:20:28 [120093.195331] Demod State = 0
11:20:28 [120093.211268] Demod State = 0
11:20:28 [120093.227272] Demod State = 0
11:20:28 [120093.243323] Demod State = 3
11:20:28 [120093.259315] Demod State = 3
11:20:28 [120093.275324] Demod State = 0
11:20:28 [120093.291377] Demod State = 0
11:20:28 [120093.309449] Demod State = 0
11:20:28 [120093.323395] Demod State = 0
11:20:28 [120093.339370] Demod State = 0
11:20:28 [120093.355863] Demod State = 0
11:20:28 [120093.371311] Demod State = 0
11:20:28 [120093.387317] Demod State = 0
11:20:28 [120093.403362] Demod State = 3
11:20:28 [120093.419318] Demod State = 0
11:20:28 [120093.435299] Demod State = 0
11:20:28 [120093.451272] Demod State = 3
11:20:28 [120093.467273] Demod State = 0
11:20:28 [120093.483301] Demod State = 0
11:20:28 [120093.499267] Demod State = 0
11:20:28 [120093.515273] Demod State = 0
11:20:28 [120093.531312] Demod State = 0
11:20:29 [120093.547273] Demod State = 0
11:20:29 [120093.563273] Demod State = 0
11:20:29 [120093.579277] Demod State = 0
11:20:29 [120093.595274] Demod State = 0
11:20:29 [120093.611271] Demod State = 0
11:20:29 [120093.627268] Demod State = 0
11:20:29 [120093.643264] Demod State = 0
11:20:29 [120093.659284] Demod State = 0
11:20:29 [120093.675275] Demod State = 0
11:20:29 [120093.691278] Demod State = 0
11:20:29 [120093.707272] Demod State = 3
11:20:29 [120093.723281] Demod State = 0
11:20:29 [120093.739291] Demod State = 0
11:20:29 [120093.755289] Demod State = 0
11:20:29 [120093.771294] Demod State = 0
11:20:29 [120093.787276] Demod State = 3
11:20:29 [120093.802322] DEMOD LOCK FAIL
11:20:29 [120093.913252] lock: srate=964165632 r0=0x0 r1=0x0 r2=0xe4 r3=0x39 
11:20:29 [120093.913255] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x9d2 srate_coarse=30305786 tmg_cpt=10
11:20:29 [120093.920998] lock: srate=979369984 r0=0x0 r1=0x0 r2=0x50 r3=0x3a 
11:20:29 [120093.930993] lock: srate=964689920 r0=0x0 r1=0x0 r2=0x90 r3=0x39 
11:20:29 [120093.948794] Demod State = 0
11:20:29 [120093.963353] Demod State = 0
11:20:29 [120093.979331] Demod State = 0
11:20:29 [120093.995314] Demod State = 0
11:20:29 [120094.011316] Demod State = 0
11:20:29 [120094.029468] Demod State = 3
11:20:29 [120094.047316] Demod State = 0
11:20:29 [120094.063315] Demod State = 0
11:20:29 [120094.079357] Demod State = 3
11:20:29 [120094.096518] Demod State = 3
11:20:29 [120094.115307] Demod State = 0
11:20:29 [120094.131314] Demod State = 0
11:20:29 [120094.147316] Demod State = 0
11:20:29 [120094.163320] Demod State = 0
11:20:29 [120094.179312] Demod State = 0
11:20:29 [120094.195264] Demod State = 3
11:20:29 [120094.211261] Demod State = 3
11:20:29 [120094.227257] Demod State = 0
11:20:29 [120094.243255] Demod State = 3
11:20:29 [120094.259285] Demod State = 0
11:20:29 [120094.275268] Demod State = 3
11:20:29 [120094.291276] Demod State = 3
11:20:29 [120094.307268] Demod State = 3
11:20:29 [120094.323262] Demod State = 0
11:20:29 [120094.339273] Demod State = 0
11:20:29 [120094.355289] Demod State = 3
11:20:29 [120094.371263] Demod State = 0
11:20:29 [120094.387262] Demod State = 0
11:20:29 [120094.403285] Demod State = 0
11:20:29 [120094.419270] Demod State = 0
11:20:29 [120094.435271] Demod State = 0
11:20:29 [120094.451270] Demod State = 3
11:20:29 [120094.467282] Demod State = 3
11:20:29 [120094.483269] Demod State = 0
11:20:29 [120094.499280] Demod State = 0
11:20:29 [120094.515262] Demod State = 3
11:20:29 [120094.531263] Demod State = 0
11:20:30 [120094.547267] Demod State = 0
11:20:30 [120094.563262] Demod State = 3
11:20:30 [120094.579280] Demod State = 3
11:20:30 [120094.595267] Demod State = 3
11:20:30 [120094.611314] Demod State = 3
11:20:30 [120094.627267] Demod State = 3
11:20:30 [120094.643275] Demod State = 0
11:20:30 [120094.659268] Demod State = 0
11:20:30 [120094.675261] Demod State = 3
11:20:30 [120094.691274] Demod State = 0
11:20:30 [120094.707286] Demod State = 0
11:20:30 [120094.723276] Demod State = 0
11:20:30 [120094.739265] Demod State = 3
11:20:30 [120094.755385] Demod State = 0
11:20:30 [120094.771304] Demod State = 0
11:20:30 [120094.787263] Demod State = 0
11:20:30 [120094.803284] Demod State = 3
11:20:30 [120094.819368] Demod State = 3
11:20:30 [120094.835380] Demod State = 0
11:20:30 [120094.853516] Demod State = 0
11:20:30 [120094.867362] Demod State = 0
11:20:30 [120094.883333] Demod State = 3
11:20:30 [120094.899310] Demod State = 3
11:20:30 [120094.915282] Demod State = 3
11:20:30 [120094.931276] Demod State = 0
11:20:30 [120094.947262] Demod State = 0
11:20:30 [120094.963295] Demod State = 3
11:20:30 [120094.979255] Demod State = 0
11:20:30 [120094.995258] Demod State = 3
11:20:30 [120095.011259] Demod State = 3
11:20:30 [120095.027258] Demod State = 0
11:20:30 [120095.043258] Demod State = 0
11:20:30 [120095.059286] Demod State = 0
11:20:30 [120095.074315] DEMOD LOCK FAIL
11:20:30 [120095.182287] lock: srate=1054343168 r0=0x0 r1=0x0 r2=0x1c r3=0x3f 
11:20:30 [120095.182291] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0xa88 srate_coarse=33140258 tmg_cpt=10
11:20:30 [120095.189842] lock: srate=1047527424 r0=0x0 r1=0x0 r2=0x8c r3=0x3e 
11:20:30 [120095.197403] lock: srate=1044119552 r0=0x0 r1=0x0 r2=0xc8 r3=0x3f 
11:20:30 [120095.214672] Demod State = 0
11:20:30 [120095.231259] Demod State = 3
11:20:30 [120095.247256] Demod State = 0
11:20:30 [120095.263246] Demod State = 0
11:20:30 [120095.279255] Demod State = 0
11:20:30 [120095.295256] Demod State = 0
11:20:30 [120095.311250] Demod State = 0
11:20:30 [120095.327249] Demod State = 0
11:20:30 [120095.343244] Demod State = 3
11:20:30 [120095.359256] Demod State = 3
11:20:30 [120095.375256] Demod State = 3
11:20:30 [120095.391257] Demod State = 0
11:20:30 [120095.407255] Demod State = 0
11:20:30 [120095.423244] Demod State = 3
11:20:30 [120095.439256] Demod State = 3
11:20:30 [120095.455257] Demod State = 0
11:20:30 [120095.471250] Demod State = 0
11:20:30 [120095.487254] Demod State = 3
11:20:30 [120095.503244] Demod State = 0
11:20:30 [120095.519288] Demod State = 0
11:20:30 [120095.535254] Demod State = 0
11:20:31 [120095.551268] Demod State = 0
11:20:31 [120095.567362] Demod State = 0
11:20:31 [120095.583279] Demod State = 0
11:20:31 [120095.599260] Demod State = 0
11:20:31 [120095.615252] Demod State = 0
11:20:31 [120095.631455] Demod State = 0
11:20:31 [120095.647256] Demod State = 3
11:20:31 [120095.663264] Demod State = 0
11:20:31 [120095.679274] Demod State = 0
11:20:31 [120095.695255] Demod State = 3
11:20:31 [120095.711273] Demod State = 0
11:20:31 [120095.727254] Demod State = 0
11:20:31 [120095.743255] Demod State = 0
11:20:31 [120095.759248] Demod State = 0
11:20:31 [120095.775246] Demod State = 0
11:20:31 [120095.791247] Demod State = 0
11:20:31 [120095.807251] Demod State = 0
11:20:31 [120095.823253] Demod State = 0
11:20:31 [120095.839252] Demod State = 3
11:20:31 [120095.855254] Demod State = 3
11:20:31 [120095.871256] Demod State = 3
11:20:31 [120095.887256] Demod State = 3
11:20:31 [120095.903249] Demod State = 3
11:20:31 [120095.919279] Demod State = 0
11:20:31 [120095.935313] Demod State = 0
11:20:31 [120095.952574] Demod State = 0
11:20:31 [120095.967305] Demod State = 0
11:20:31 [120095.983318] Demod State = 0
11:20:31 [120095.999310] Demod State = 0
11:20:31 [120096.015303] Demod State = 0
11:20:31 [120096.031318] Demod State = 0
11:20:31 [120096.047301] Demod State = 0
11:20:31 [120096.063328] Demod State = 0
11:20:31 [120096.079273] Demod State = 0
11:20:31 [120096.095298] Demod State = 3
11:20:31 [120096.111319] Demod State = 0
11:20:31 [120096.127350] Demod State = 0
11:20:31 [120096.143311] Demod State = 3
11:20:31 [120096.159309] Demod State = 0
11:20:31 [120096.177411] Demod State = 0
11:20:31 [120096.191326] Demod State = 3
11:20:31 [120096.207364] Demod State = 3
11:20:31 [120096.223274] Demod State = 3
11:20:31 [120096.239291] Demod State = 0
11:20:31 [120096.255304] Demod State = 0
11:20:31 [120096.271352] Demod State = 0
11:20:31 [120096.287298] Demod State = 3
11:20:31 [120096.303276] Demod State = 3
11:20:31 [120096.319254] Demod State = 0
11:20:31 [120096.334314] DEMOD LOCK FAIL
11:20:31 [120096.442185] lock: srate=8388608 r0=0x0 r1=0x0 r2=0x80 r3=0x0 
11:20:31 [120096.442188] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0xe1 srate_coarse=263671 tmg_cpt=10
11:20:31 [120096.470556] Search Fail
11:20:31 [120096.470558] stv0900_read_status: 
11:20:31 [120096.471500] stv0900_status: locked = 0
11:20:31 [120096.475360] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:31 [120096.475362] TS bitrate = 270 Mbit/sec 
11:20:31 [120096.475363] DEMOD LOCK FAIL
11:20:31 [120096.475379] stv0900_read_status: 
11:20:31 [120096.476330] stv0900_status: locked = 0
11:20:31 [120096.480123] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:31 [120096.480125] TS bitrate = 270 Mbit/sec 
11:20:31 [120096.480126] DEMOD LOCK FAIL
11:20:32 [120096.974312] stv0900_search: 
11:20:32 [120096.974315] stv0900_algo
11:20:32 [120096.978996] stv0900_set_symbol_rate: Mclk 135000000, SR 1000000, Dmd 0
11:20:32 [120096.984476] stb6100_read_regs:     Read from 0x60
11:20:32 [120096.984479] stb6100_read_regs:         LD: 0x81
11:20:32 [120096.984480] stb6100_read_regs:         VCO: 0x66
11:20:32 [120096.984482] stb6100_read_regs:         NI: 0x3c
11:20:32 [120096.984483] stb6100_read_regs:         NF: 0xb4
11:20:32 [120096.984484] stb6100_read_regs:         K: 0x3d
11:20:32 [120096.984486] stb6100_read_regs:         G: 0x39
11:20:32 [120096.984487] stb6100_read_regs:         F: 0xdf
11:20:32 [120096.984488] stb6100_read_regs:         DLB: 0xdc
11:20:32 [120096.984490] stb6100_read_regs:         TEST1: 0x8f
11:20:32 [120096.984491] stb6100_read_regs:         FCCK: 0x0d
11:20:32 [120096.984493] stb6100_read_regs:         LPEN: 0xfb
11:20:32 [120096.984494] stb6100_read_regs:         TEST3: 0xde
11:20:32 [120096.984496] stb6100_set_frequency: Get frontend parameters
11:20:32 [120096.984498] stb6100_write_reg_range:     Write @ 0x60: [1:11]
11:20:32 [120096.984499] stb6100_write_reg_range:         VCO: 0x66
11:20:32 [120096.984501] stb6100_write_reg_range:         NI: 0x3c
11:20:32 [120096.984502] stb6100_write_reg_range:         NF: 0xb4
11:20:32 [120096.984504] stb6100_write_reg_range:         K: 0x3d
11:20:32 [120096.984505] stb6100_write_reg_range:         G: 0x39
11:20:32 [120096.984507] stb6100_write_reg_range:         F: 0xdf
11:20:32 [120096.984508] stb6100_write_reg_range:         DLB: 0xdc
11:20:32 [120096.984510] stb6100_write_reg_range:         TEST1: 0x8f
11:20:32 [120096.984511] stb6100_write_reg_range:         FCCK: 0x0d
11:20:32 [120096.984512] stb6100_write_reg_range:         LPEN: 0xeb
11:20:32 [120096.984514] stb6100_write_reg_range:         TEST3: 0xde
11:20:32 [120096.986868] stb6100_set_frequency: frequency = 1643000, srate = 27499505, g = 9, odiv = 0, psd2 = 1, fxtal = 27000, osm = 6, fvco = 3286000, N(I) = 60, N(F) = 436
11:20:32 [120096.994309] stb6100_write_reg_range:     Write @ 0x60: [1:11]
11:20:32 [120096.994312] stb6100_write_reg_range:         VCO: 0xe6
11:20:32 [120096.994314] stb6100_write_reg_range:         NI: 0x3c
11:20:32 [120096.994315] stb6100_write_reg_range:         NF: 0xb4
11:20:32 [120096.994317] stb6100_write_reg_range:         K: 0x3d
11:20:32 [120096.994318] stb6100_write_reg_range:         G: 0x39
11:20:32 [120096.994319] stb6100_write_reg_range:         F: 0xdf
11:20:32 [120096.994321] stb6100_write_reg_range:         DLB: 0xdc
11:20:32 [120096.994322] stb6100_write_reg_range:         TEST1: 0x8f
11:20:32 [120096.994324] stb6100_write_reg_range:         FCCK: 0x4d
11:20:32 [120096.994325] stb6100_write_reg_range:         LPEN: 0xeb
11:20:32 [120096.994327] stb6100_write_reg_range:         TEST3: 0xde
11:20:32 [120097.002328] stb6100_write_reg_range:     Write @ 0x60: [10:1]
11:20:32 [120097.002331] stb6100_write_reg_range:         LPEN: 0xfb
11:20:32 [120097.002904] stb6100_write_reg_range:     Write @ 0x60: [1:1]
11:20:32 [120097.002906] stb6100_write_reg_range:         VCO: 0x86
11:20:32 [120097.018304] stb6100_write_reg_range:     Write @ 0x60: [1:1]
11:20:32 [120097.018307] stb6100_write_reg_range:         VCO: 0x66
11:20:32 [120097.018878] stb6100_write_reg_range:     Write @ 0x60: [1:9]
11:20:32 [120097.018879] stb6100_write_reg_range:         VCO: 0x66
11:20:32 [120097.018881] stb6100_write_reg_range:         NI: 0x3c
11:20:32 [120097.018882] stb6100_write_reg_range:         NF: 0xb4
11:20:32 [120097.018883] stb6100_write_reg_range:         K: 0x3d
11:20:32 [120097.018885] stb6100_write_reg_range:         G: 0x39
11:20:32 [120097.018886] stb6100_write_reg_range:         F: 0xdf
11:20:32 [120097.018887] stb6100_write_reg_range:         DLB: 0xdc
11:20:32 [120097.018888] stb6100_write_reg_range:         TEST1: 0x8f
11:20:32 [120097.018890] stb6100_write_reg_range:         FCCK: 0x0d
11:20:32 [120097.123996] stv0900_set_tuner: Frequency=1643000
11:20:32 [120097.125683] stb6100_set_bandwidth: set bandwidth to 72000000 Hz
11:20:32 [120097.125685] stb6100_write_reg_range:     Write @ 0x60: [9:1]
11:20:32 [120097.125687] stb6100_write_reg_range:         FCCK: 0x4d
11:20:32 [120097.126264] stb6100_write_reg_range:     Write @ 0x60: [6:1]
11:20:32 [120097.126266] stb6100_write_reg_range:         F: 0xdf
11:20:32 [120097.134308] stb6100_write_reg_range:     Write @ 0x60: [9:1]
11:20:32 [120097.134311] stb6100_write_reg_range:         FCCK: 0x0d
11:20:32 [120097.136566] stv0900_set_tuner: Bandwidth=72000000
11:20:32 [120097.141827] stv0900_set_search_standard
11:20:32 [120097.141828] Search Standard = AUTO
11:20:32 [120097.150628] stv0900_activate_s2_modcod_single
11:20:32 [120097.162629] stv0900_set_viterbi_tracq
11:20:32 [120097.167118] stv0900_set_viterbi_standard: ViterbiStandard = 
11:20:32 [120097.167120] Auto
11:20:32 [120097.168608] stv0900_blind_search_algo
11:20:32 [120097.168610] stv0900_blind_check_agc2_min_level
11:20:32 [120097.176849] stv0900_set_symbol_rate: Mclk 135000000, SR 1000000, Dmd 0
11:20:32 [120097.501379] stv0900_blind_search_algo agc2_int=274 agc2_th=700 
11:20:33 [120097.614541] lock: srate=785383424 r0=0x0 r1=0x0 r2=0xa4 r3=0x30 
11:20:33 [120097.614544] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x87c srate_coarse=24686279 tmg_cpt=10
11:20:33 [120097.622189] lock: srate=810549248 r0=0x0 r1=0x0 r2=0x30 r3=0x30 
11:20:33 [120097.630003] lock: srate=790102016 r0=0x0 r1=0x0 r2=0xc r3=0x2f 
11:20:33 [120097.647376] Demod State = 0
11:20:33 [120097.663272] Demod State = 3
11:20:33 [120097.679268] Demod State = 0
11:20:33 [120097.695263] Demod State = 0
11:20:33 [120097.711277] Demod State = 0
11:20:33 [120097.727308] Demod State = 3
11:20:33 [120097.743277] Demod State = 0
11:20:33 [120097.759278] Demod State = 0
11:20:33 [120097.775310] Demod State = 0
11:20:33 [120097.791275] Demod State = 0
11:20:33 [120097.807273] Demod State = 3
11:20:33 [120097.823334] Demod State = 0
11:20:33 [120097.839269] Demod State = 0
11:20:33 [120097.855277] Demod State = 0
11:20:33 [120097.871307] Demod State = 3
11:20:33 [120097.887303] Demod State = 0
11:20:33 [120097.903347] Demod State = 0
11:20:33 [120097.919299] Demod State = 0
11:20:33 [120097.935381] Demod State = 3
11:20:33 [120097.953488] Demod State = 0
11:20:33 [120097.967289] Demod State = 0
11:20:33 [120097.983273] Demod State = 3
11:20:33 [120097.999295] Demod State = 3
11:20:33 [120098.015299] Demod State = 0
11:20:33 [120098.031258] Demod State = 3
11:20:33 [120098.047187] Demod State = 0
11:20:33 [120098.063182] Demod State = 0
11:20:33 [120098.079143] Demod State = 0
11:20:33 [120098.095174] Demod State = 0
11:20:33 [120098.111198] Demod State = 0
11:20:33 [120098.127156] Demod State = 0
11:20:33 [120098.143148] Demod State = 0
11:20:33 [120098.159181] Demod State = 0
11:20:33 [120098.175145] Demod State = 3
11:20:33 [120098.191182] Demod State = 0
11:20:33 [120098.207182] Demod State = 0
11:20:33 [120098.223158] Demod State = 3
11:20:33 [120098.239143] Demod State = 0
11:20:33 [120098.255180] Demod State = 0
11:20:33 [120098.271164] Demod State = 3
11:20:33 [120098.287358] Demod State = 3
11:20:33 [120098.303256] Demod State = 0
11:20:33 [120098.319271] Demod State = 0
11:20:33 [120098.335253] Demod State = 0
11:20:33 [120098.351329] Demod State = 3
11:20:33 [120098.367248] Demod State = 3
11:20:33 [120098.383258] Demod State = 0
11:20:33 [120098.399277] Demod State = 0
11:20:33 [120098.415239] Demod State = 0
11:20:33 [120098.431250] Demod State = 0
11:20:33 [120098.447273] Demod State = 0
11:20:33 [120098.463277] Demod State = 3
11:20:33 [120098.479267] Demod State = 3
11:20:33 [120098.495273] Demod State = 0
11:20:33 [120098.511285] Demod State = 0
11:20:33 [120098.527269] Demod State = 0
11:20:34 [120098.543281] Demod State = 0
11:20:34 [120098.559378] Demod State = 3
11:20:34 [120098.575268] Demod State = 0
11:20:34 [120098.591282] Demod State = 3
11:20:34 [120098.607270] Demod State = 0
11:20:34 [120098.623278] Demod State = 0
11:20:34 [120098.639269] Demod State = 0
11:20:34 [120098.655274] Demod State = 3
11:20:34 [120098.671289] Demod State = 3
11:20:34 [120098.687292] Demod State = 3
11:20:34 [120098.703280] Demod State = 0
11:20:34 [120098.719308] Demod State = 3
11:20:34 [120098.735262] Demod State = 3
11:20:34 [120098.751314] Demod State = 0
11:20:34 [120098.766297] DEMOD LOCK FAIL
11:20:34 [120098.874840] lock: srate=849084416 r0=0x0 r1=0x0 r2=0x74 r3=0x33 
11:20:34 [120098.874843] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x8f9 srate_coarse=26688537 tmg_cpt=10
11:20:34 [120098.882454] lock: srate=867958784 r0=0x0 r1=0x0 r2=0x8 r3=0x33 
11:20:34 [120098.890177] lock: srate=852230144 r0=0x0 r1=0x0 r2=0x64 r3=0x33 
11:20:34 [120098.907526] Demod State = 0
11:20:34 [120098.923259] Demod State = 0
11:20:34 [120098.939259] Demod State = 3
11:20:34 [120098.955341] Demod State = 0
11:20:34 [120098.971255] Demod State = 0
11:20:34 [120098.987400] Demod State = 0
11:20:34 [120099.003267] Demod State = 0
11:20:34 [120099.019303] Demod State = 0
11:20:34 [120099.035265] Demod State = 0
11:20:34 [120099.051277] Demod State = 0
11:20:34 [120099.067288] Demod State = 0
11:20:34 [120099.083278] Demod State = 0
11:20:34 [120099.099274] Demod State = 0
11:20:34 [120099.115325] Demod State = 3
11:20:34 [120099.131295] Demod State = 0
11:20:34 [120099.147293] Demod State = 0
11:20:34 [120099.163262] Demod State = 0
11:20:34 [120099.179238] Demod State = 3
11:20:34 [120099.195244] Demod State = 0
11:20:34 [120099.211244] Demod State = 3
11:20:34 [120099.227262] Demod State = 0
11:20:34 [120099.243240] Demod State = 0
11:20:34 [120099.259244] Demod State = 3
11:20:34 [120099.275245] Demod State = 3
11:20:34 [120099.291260] Demod State = 0
11:20:34 [120099.307248] Demod State = 0
11:20:34 [120099.323260] Demod State = 3
11:20:34 [120099.339242] Demod State = 3
11:20:34 [120099.355246] Demod State = 0
11:20:34 [120099.371238] Demod State = 0
11:20:34 [120099.387289] Demod State = 0
11:20:34 [120099.403264] Demod State = 3
11:20:34 [120099.419289] Demod State = 0
11:20:34 [120099.435446] Demod State = 3
11:20:34 [120099.451287] Demod State = 3
11:20:34 [120099.467265] Demod State = 3
11:20:34 [120099.483235] Demod State = 0
11:20:34 [120099.499135] Demod State = 3
11:20:34 [120099.515134] Demod State = 3
11:20:34 [120099.531169] Demod State = 0
11:20:35 [120099.547174] Demod State = 0
11:20:35 [120099.564108] Demod State = 3
11:20:35 [120099.579319] Demod State = 3
11:20:35 [120099.595295] Demod State = 0
11:20:35 [120099.612087] Demod State = 0
11:20:35 [120099.627381] Demod State = 0
11:20:35 [120099.643296] Demod State = 0
11:20:35 [120099.659273] Demod State = 3
11:20:35 [120099.675306] Demod State = 0
11:20:35 [120099.691292] Demod State = 0
11:20:35 [120099.707295] Demod State = 3
11:20:35 [120099.723284] Demod State = 3
11:20:35 [120099.739265] Demod State = 0
11:20:35 [120099.755284] Demod State = 0
11:20:35 [120099.771306] Demod State = 3
11:20:35 [120099.789462] Demod State = 0
11:20:35 [120099.803247] Demod State = 0
11:20:35 [120099.819154] Demod State = 0
11:20:35 [120099.835134] Demod State = 0
11:20:35 [120099.851471] Demod State = 0
11:20:35 [120099.867268] Demod State = 0
11:20:35 [120099.883261] Demod State = 3
11:20:35 [120099.899270] Demod State = 3
11:20:35 [120099.915261] Demod State = 0
11:20:35 [120099.931256] Demod State = 3
11:20:35 [120099.947260] Demod State = 0
11:20:35 [120099.963259] Demod State = 0
11:20:35 [120099.979258] Demod State = 3
11:20:35 [120099.995372] Demod State = 0
11:20:35 [120100.011253] Demod State = 3
11:20:35 [120100.026376] DEMOD LOCK FAIL
11:20:35 [120100.134741] lock: srate=966524928 r0=0x0 r1=0x0 r2=0x58 r3=0x39 
11:20:35 [120100.134745] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x9cb srate_coarse=30379943 tmg_cpt=10
11:20:35 [120100.142373] lock: srate=964427776 r0=0x0 r1=0x0 r2=0x8c r3=0x38 
11:20:35 [120100.149991] lock: srate=958922752 r0=0x0 r1=0x0 r2=0x90 r3=0x3a 
11:20:35 [120100.167536] Demod State = 0
11:20:35 [120100.183260] Demod State = 0
11:20:35 [120100.199256] Demod State = 0
11:20:35 [120100.215262] Demod State = 0
11:20:35 [120100.231275] Demod State = 0
11:20:35 [120100.247258] Demod State = 3
11:20:35 [120100.263294] Demod State = 0
11:20:35 [120100.279259] Demod State = 3
11:20:35 [120100.295257] Demod State = 3
11:20:35 [120100.311262] Demod State = 3
11:20:35 [120100.327259] Demod State = 0
11:20:35 [120100.343255] Demod State = 0
11:20:35 [120100.359264] Demod State = 3
11:20:35 [120100.375264] Demod State = 0
11:20:35 [120100.391259] Demod State = 0
11:20:35 [120100.407264] Demod State = 0
11:20:35 [120100.423258] Demod State = 0
11:20:35 [120100.439257] Demod State = 3
11:20:35 [120100.455259] Demod State = 0
11:20:35 [120100.471264] Demod State = 0
11:20:35 [120100.487276] Demod State = 0
11:20:35 [120100.503260] Demod State = 0
11:20:35 [120100.519280] Demod State = 3
11:20:35 [120100.535255] Demod State = 0
11:20:36 [120100.551310] Demod State = 0
11:20:36 [120100.567314] Demod State = 0
11:20:36 [120100.583303] Demod State = 3
11:20:36 [120100.601371] Demod State = 0
11:20:36 [120100.615267] Demod State = 0
11:20:36 [120100.631286] Demod State = 0
11:20:36 [120100.648398] Demod State = 3
11:20:36 [120100.663355] Demod State = 0
11:20:36 [120100.679311] Demod State = 0
11:20:36 [120100.695374] Demod State = 0
11:20:36 [120100.711251] Demod State = 0
11:20:36 [120100.727241] Demod State = 0
11:20:36 [120100.743233] Demod State = 0
11:20:36 [120100.759234] Demod State = 0
11:20:36 [120100.775232] Demod State = 0
11:20:36 [120100.791233] Demod State = 0
11:20:36 [120100.807264] Demod State = 0
11:20:36 [120100.823263] Demod State = 0
11:20:36 [120100.839454] Demod State = 0
11:20:36 [120100.855283] Demod State = 0
11:20:36 [120100.871260] Demod State = 3
11:20:36 [120100.889407] Demod State = 0
11:20:36 [120100.903278] Demod State = 3
11:20:36 [120100.921355] Demod State = 0
11:20:36 [120100.935284] Demod State = 0
11:20:36 [120100.951281] Demod State = 3
11:20:36 [120100.967241] Demod State = 3
11:20:36 [120100.983333] Demod State = 0
11:20:36 [120100.999285] Demod State = 0
11:20:36 [120101.015366] Demod State = 3
11:20:36 [120101.031290] Demod State = 3
11:20:36 [120101.047323] Demod State = 3
11:20:36 [120101.063387] Demod State = 0
11:20:36 [120101.079359] Demod State = 0
11:20:36 [120101.095311] Demod State = 3
11:20:36 [120101.111292] Demod State = 3
11:20:36 [120101.127314] Demod State = 0
11:20:36 [120101.143288] Demod State = 0
11:20:36 [120101.159291] Demod State = 0
11:20:36 [120101.175289] Demod State = 0
11:20:36 [120101.193497] Demod State = 0
11:20:36 [120101.207336] Demod State = 0
11:20:36 [120101.223260] Demod State = 3
11:20:36 [120101.239282] Demod State = 0
11:20:36 [120101.255287] Demod State = 0
11:20:36 [120101.271329] Demod State = 0
11:20:36 [120101.286282] DEMOD LOCK FAIL
11:20:36 [120101.397440] lock: srate=1061945344 r0=0x0 r1=0x0 r2=0x4c r3=0x3f 
11:20:36 [120101.397443] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0xa8c srate_coarse=33379211 tmg_cpt=10
11:20:36 [120101.405239] lock: srate=1047527424 r0=0x0 r1=0x0 r2=0x9c r3=0x3e 
11:20:36 [120101.413074] lock: srate=1045692416 r0=0x0 r1=0x0 r2=0x94 r3=0x3e 
11:20:36 [120101.432920] Demod State = 0
11:20:36 [120101.447363] Demod State = 0
11:20:36 [120101.463288] Demod State = 0
11:20:36 [120101.479285] Demod State = 0
11:20:36 [120101.495615] Demod State = 0
11:20:36 [120101.511162] Demod State = 3
11:20:36 [120101.527137] Demod State = 3
11:20:37 [120101.543141] Demod State = 0
11:20:37 [120101.559176] Demod State = 0
11:20:37 [120101.575257] Demod State = 0
11:20:37 [120101.591272] Demod State = 0
11:20:37 [120101.607254] Demod State = 0
11:20:37 [120101.623263] Demod State = 0
11:20:37 [120101.639253] Demod State = 0
11:20:37 [120101.655274] Demod State = 0
11:20:37 [120101.671267] Demod State = 0
11:20:37 [120101.687253] Demod State = 0
11:20:37 [120101.703337] Demod State = 3
11:20:37 [120101.719795] Demod State = 0
11:20:37 [120101.735261] Demod State = 0
11:20:37 [120101.751292] Demod State = 3
11:20:37 [120101.767274] Demod State = 0
11:20:37 [120101.783264] Demod State = 0
11:20:37 [120101.799249] Demod State = 0
11:20:37 [120101.815271] Demod State = 0
11:20:37 [120101.831269] Demod State = 0
11:20:37 [120101.847257] Demod State = 0
11:20:37 [120101.863260] Demod State = 3
11:20:37 [120101.879264] Demod State = 0
11:20:37 [120101.895254] Demod State = 3
11:20:37 [120101.911252] Demod State = 3
11:20:37 [120101.927257] Demod State = 0
11:20:37 [120101.943242] Demod State = 3
11:20:37 [120101.959227] Demod State = 0
11:20:37 [120101.975232] Demod State = 3
11:20:37 [120101.991235] Demod State = 0
11:20:37 [120102.007235] Demod State = 0
11:20:37 [120102.023225] Demod State = 0
11:20:37 [120102.039234] Demod State = 0
11:20:37 [120102.055227] Demod State = 3
11:20:37 [120102.071231] Demod State = 0
11:20:37 [120102.087223] Demod State = 0
11:20:37 [120102.103224] Demod State = 3
11:20:37 [120102.119221] Demod State = 0
11:20:37 [120102.135255] Demod State = 3
11:20:37 [120102.151243] Demod State = 0
11:20:37 [120102.167230] Demod State = 3
11:20:37 [120102.183233] Demod State = 0
11:20:37 [120102.199286] Demod State = 0
11:20:37 [120102.215227] Demod State = 0
11:20:37 [120102.231226] Demod State = 3
11:20:37 [120102.247222] Demod State = 0
11:20:37 [120102.263223] Demod State = 3
11:20:37 [120102.279226] Demod State = 0
11:20:37 [120102.295227] Demod State = 0
11:20:37 [120102.311230] Demod State = 3
11:20:37 [120102.327230] Demod State = 3
11:20:37 [120102.343227] Demod State = 0
11:20:37 [120102.359225] Demod State = 0
11:20:37 [120102.375222] Demod State = 0
11:20:37 [120102.391225] Demod State = 0
11:20:37 [120102.407219] Demod State = 0
11:20:37 [120102.423228] Demod State = 0
11:20:37 [120102.439226] Demod State = 0
11:20:37 [120102.455238] Demod State = 0
11:20:37 [120102.471264] Demod State = 3
11:20:37 [120102.487225] Demod State = 0
11:20:37 [120102.503227] Demod State = 0
11:20:37 [120102.519225] Demod State = 0
11:20:37 [120102.535221] Demod State = 0
11:20:38 [120102.550282] DEMOD LOCK FAIL
11:20:38 [120102.658215] lock: srate=8650752 r0=0x0 r1=0x0 r2=0x80 r3=0x0 
11:20:38 [120102.658218] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0xd7 srate_coarse=271911 tmg_cpt=10
11:20:38 [120102.686719] Search Fail
11:20:38 [120102.686721] stv0900_read_status: 
11:20:38 [120102.687680] stv0900_status: locked = 0
11:20:38 [120102.691530] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:38 [120102.691531] TS bitrate = 270 Mbit/sec 
11:20:38 [120102.691532] DEMOD LOCK FAIL
11:20:38 [120102.691548] stv0900_read_status: 
11:20:38 [120102.692497] stv0900_status: locked = 0
11:20:38 [120102.696274] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:38 [120102.696276] TS bitrate = 270 Mbit/sec 
11:20:38 [120102.696277] DEMOD LOCK FAIL
11:20:38 [120103.190275] stv0900_search: 
11:20:38 [120103.190278] stv0900_algo
11:20:38 [120103.194962] stv0900_set_symbol_rate: Mclk 135000000, SR 1000000, Dmd 0
11:20:38 [120103.200439] stb6100_read_regs:     Read from 0x60
11:20:38 [120103.200441] stb6100_read_regs:         LD: 0x81
11:20:38 [120103.200442] stb6100_read_regs:         VCO: 0x66
11:20:38 [120103.200444] stb6100_read_regs:         NI: 0x3c
11:20:38 [120103.200445] stb6100_read_regs:         NF: 0xb4
11:20:38 [120103.200447] stb6100_read_regs:         K: 0x3d
11:20:38 [120103.200448] stb6100_read_regs:         G: 0x39
11:20:38 [120103.200449] stb6100_read_regs:         F: 0xdf
11:20:38 [120103.200451] stb6100_read_regs:         DLB: 0xdc
11:20:38 [120103.200452] stb6100_read_regs:         TEST1: 0x8f
11:20:38 [120103.200453] stb6100_read_regs:         FCCK: 0x0d
11:20:38 [120103.200455] stb6100_read_regs:         LPEN: 0xfb
11:20:38 [120103.200456] stb6100_read_regs:         TEST3: 0xde
11:20:38 [120103.200458] stb6100_set_frequency: Get frontend parameters
11:20:38 [120103.200460] stb6100_write_reg_range:     Write @ 0x60: [1:11]
11:20:38 [120103.200461] stb6100_write_reg_range:         VCO: 0x66
11:20:38 [120103.200463] stb6100_write_reg_range:         NI: 0x3c
11:20:38 [120103.200464] stb6100_write_reg_range:         NF: 0xb4
11:20:38 [120103.200465] stb6100_write_reg_range:         K: 0x3d
11:20:38 [120103.200467] stb6100_write_reg_range:         G: 0x39
11:20:38 [120103.200468] stb6100_write_reg_range:         F: 0xdf
11:20:38 [120103.200470] stb6100_write_reg_range:         DLB: 0xdc
11:20:38 [120103.200471] stb6100_write_reg_range:         TEST1: 0x8f
11:20:38 [120103.200472] stb6100_write_reg_range:         FCCK: 0x0d
11:20:38 [120103.200474] stb6100_write_reg_range:         LPEN: 0xeb
11:20:38 [120103.200475] stb6100_write_reg_range:         TEST3: 0xde
11:20:38 [120103.202828] stb6100_set_frequency: frequency = 1643000, srate = 27499505, g = 9, odiv = 0, psd2 = 1, fxtal = 27000, osm = 6, fvco = 3286000, N(I) = 60, N(F) = 436
11:20:38 [120103.210273] stb6100_write_reg_range:     Write @ 0x60: [1:11]
11:20:38 [120103.210276] stb6100_write_reg_range:         VCO: 0xe6
11:20:38 [120103.210278] stb6100_write_reg_range:         NI: 0x3c
11:20:38 [120103.210279] stb6100_write_reg_range:         NF: 0xb4
11:20:38 [120103.210281] stb6100_write_reg_range:         K: 0x3d
11:20:38 [120103.210282] stb6100_write_reg_range:         G: 0x39
11:20:38 [120103.210284] stb6100_write_reg_range:         F: 0xdf
11:20:38 [120103.210285] stb6100_write_reg_range:         DLB: 0xdc
11:20:38 [120103.210286] stb6100_write_reg_range:         TEST1: 0x8f
11:20:38 [120103.210288] stb6100_write_reg_range:         FCCK: 0x4d
11:20:38 [120103.210289] stb6100_write_reg_range:         LPEN: 0xeb
11:20:38 [120103.210291] stb6100_write_reg_range:         TEST3: 0xde
11:20:38 [120103.218275] stb6100_write_reg_range:     Write @ 0x60: [10:1]
11:20:38 [120103.218278] stb6100_write_reg_range:         LPEN: 0xfb
11:20:38 [120103.218848] stb6100_write_reg_range:     Write @ 0x60: [1:1]
11:20:38 [120103.218850] stb6100_write_reg_range:         VCO: 0x86
11:20:38 [120103.234280] stb6100_write_reg_range:     Write @ 0x60: [1:1]
11:20:38 [120103.234283] stb6100_write_reg_range:         VCO: 0x66
11:20:38 [120103.234859] stb6100_write_reg_range:     Write @ 0x60: [1:9]
11:20:38 [120103.234860] stb6100_write_reg_range:         VCO: 0x66
11:20:38 [120103.234862] stb6100_write_reg_range:         NI: 0x3c
11:20:38 [120103.234863] stb6100_write_reg_range:         NF: 0xb4
11:20:38 [120103.234865] stb6100_write_reg_range:         K: 0x3d
11:20:38 [120103.234866] stb6100_write_reg_range:         G: 0x39
11:20:38 [120103.234867] stb6100_write_reg_range:         F: 0xdf
11:20:38 [120103.234869] stb6100_write_reg_range:         DLB: 0xdc
11:20:38 [120103.234870] stb6100_write_reg_range:         TEST1: 0x8f
11:20:38 [120103.234872] stb6100_write_reg_range:         FCCK: 0x0d
11:20:38 [120103.339995] stv0900_set_tuner: Frequency=1643000
11:20:38 [120103.341681] stb6100_set_bandwidth: set bandwidth to 72000000 Hz
11:20:38 [120103.341684] stb6100_write_reg_range:     Write @ 0x60: [9:1]
11:20:38 [120103.341686] stb6100_write_reg_range:         FCCK: 0x4d
11:20:38 [120103.342258] stb6100_write_reg_range:     Write @ 0x60: [6:1]
11:20:38 [120103.342259] stb6100_write_reg_range:         F: 0xdf
11:20:38 [120103.350264] stb6100_write_reg_range:     Write @ 0x60: [9:1]
11:20:38 [120103.350266] stb6100_write_reg_range:         FCCK: 0x0d
11:20:38 [120103.352602] stv0900_set_tuner: Bandwidth=72000000
11:20:38 [120103.357914] stv0900_set_search_standard
11:20:38 [120103.357915] Search Standard = AUTO
11:20:38 [120103.366752] stv0900_activate_s2_modcod_single
11:20:38 [120103.378698] stv0900_set_viterbi_tracq
11:20:38 [120103.383165] stv0900_set_viterbi_standard: ViterbiStandard = 
11:20:38 [120103.383166] Auto
11:20:38 [120103.384657] stv0900_blind_search_algo
11:20:38 [120103.384658] stv0900_blind_check_agc2_min_level
11:20:38 [120103.392954] stv0900_set_symbol_rate: Mclk 135000000, SR 1000000, Dmd 0
11:20:39 [120103.717131] stv0900_blind_search_algo agc2_int=274 agc2_th=700 
11:20:39 [120103.830152] lock: srate=817102848 r0=0x0 r1=0x0 r2=0x5c r3=0x31 
11:20:39 [120103.830155] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x88a srate_coarse=25683288 tmg_cpt=10
11:20:39 [120103.837700] lock: srate=795869184 r0=0x0 r1=0x0 r2=0xd4 r3=0x2e 
11:20:39 [120103.845250] lock: srate=776732672 r0=0x0 r1=0x0 r2=0xa8 r3=0x2f 
11:20:39 [120103.862612] Demod State = 0
11:20:39 [120103.879211] Demod State = 0
11:20:39 [120103.895212] Demod State = 3
11:20:39 [120103.911215] Demod State = 0
11:20:39 [120103.927212] Demod State = 0
11:20:39 [120103.943220] Demod State = 0
11:20:39 [120103.959218] Demod State = 3
11:20:39 [120103.975212] Demod State = 0
11:20:39 [120103.991226] Demod State = 0
11:20:39 [120104.007209] Demod State = 0
11:20:39 [120104.023213] Demod State = 0
11:20:39 [120104.039210] Demod State = 0
11:20:39 [120104.055218] Demod State = 0
11:20:39 [120104.071265] Demod State = 3
11:20:39 [120104.087253] Demod State = 0
11:20:39 [120104.103259] Demod State = 0
11:20:39 [120104.119259] Demod State = 0
11:20:39 [120104.135255] Demod State = 0
11:20:39 [120104.151253] Demod State = 0
11:20:39 [120104.167251] Demod State = 0
11:20:39 [120104.183241] Demod State = 0
11:20:39 [120104.199219] Demod State = 3
11:20:39 [120104.215217] Demod State = 0
11:20:39 [120104.231234] Demod State = 0
11:20:39 [120104.247214] Demod State = 0
11:20:39 [120104.263260] Demod State = 3
11:20:39 [120104.279210] Demod State = 3
11:20:39 [120104.295211] Demod State = 3
11:20:39 [120104.311219] Demod State = 0
11:20:39 [120104.327205] Demod State = 0
11:20:39 [120104.343223] Demod State = 0
11:20:39 [120104.359212] Demod State = 0
11:20:39 [120104.375211] Demod State = 0
11:20:39 [120104.391219] Demod State = 0
11:20:39 [120104.407205] Demod State = 3
11:20:39 [120104.423219] Demod State = 0
11:20:39 [120104.439210] Demod State = 0
11:20:39 [120104.455214] Demod State = 0
11:20:39 [120104.471227] Demod State = 3
11:20:39 [120104.487206] Demod State = 0
11:20:39 [120104.503297] Demod State = 0
11:20:39 [120104.519207] Demod State = 0
11:20:39 [120104.535205] Demod State = 0
11:20:40 [120104.551248] Demod State = 0
11:20:40 [120104.567212] Demod State = 3
11:20:40 [120104.583118] Demod State = 3
11:20:40 [120104.599266] Demod State = 0
11:20:40 [120104.615105] Demod State = 3
11:20:40 [120104.631106] Demod State = 0
11:20:40 [120104.647118] Demod State = 3
11:20:40 [120104.663107] Demod State = 0
11:20:40 [120104.679119] Demod State = 0
11:20:40 [120104.695107] Demod State = 3
11:20:40 [120104.711108] Demod State = 0
11:20:40 [120104.727107] Demod State = 0
11:20:40 [120104.743144] Demod State = 3
11:20:40 [120104.759106] Demod State = 0
11:20:40 [120104.775212] Demod State = 3
11:20:40 [120104.791214] Demod State = 0
11:20:40 [120104.807213] Demod State = 0
11:20:40 [120104.823212] Demod State = 0
11:20:40 [120104.839208] Demod State = 3
11:20:40 [120104.855210] Demod State = 0
11:20:40 [120104.871212] Demod State = 0
11:20:40 [120104.887224] Demod State = 0
11:20:40 [120104.903208] Demod State = 3
11:20:40 [120104.919213] Demod State = 3
11:20:40 [120104.935216] Demod State = 0
11:20:40 [120104.951229] Demod State = 0
11:20:40 [120104.967278] Demod State = 0
11:20:40 [120104.982267] DEMOD LOCK FAIL
11:20:40 [120105.090289] lock: srate=881328128 r0=0x0 r1=0x0 r2=0x28 r3=0x33 
11:20:40 [120105.090292] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x8ff srate_coarse=27702026 tmg_cpt=10
11:20:40 [120105.097840] lock: srate=854851584 r0=0x0 r1=0x0 r2=0x24 r3=0x33 
11:20:40 [120105.105384] lock: srate=877658112 r0=0x0 r1=0x0 r2=0x50 r3=0x33 
11:20:40 [120105.122561] Demod State = 0
11:20:40 [120105.139375] Demod State = 3
11:20:40 [120105.155212] Demod State = 3
11:20:40 [120105.171246] Demod State = 0
11:20:40 [120105.187267] Demod State = 0
11:20:40 [120105.203207] Demod State = 0
11:20:40 [120105.219207] Demod State = 3
11:20:40 [120105.235210] Demod State = 0
11:20:40 [120105.251222] Demod State = 3
11:20:40 [120105.267210] Demod State = 0
11:20:40 [120105.283210] Demod State = 0
11:20:40 [120105.299213] Demod State = 0
11:20:40 [120105.315216] Demod State = 3
11:20:40 [120105.331219] Demod State = 3
11:20:40 [120105.347205] Demod State = 3
11:20:40 [120105.363212] Demod State = 0
11:20:40 [120105.379213] Demod State = 0
11:20:40 [120105.395213] Demod State = 0
11:20:40 [120105.411214] Demod State = 3
11:20:40 [120105.427201] Demod State = 0
11:20:40 [120105.443212] Demod State = 3
11:20:40 [120105.459207] Demod State = 0
11:20:40 [120105.475236] Demod State = 0
11:20:40 [120105.491230] Demod State = 0
11:20:40 [120105.507236] Demod State = 3
11:20:40 [120105.523246] Demod State = 0
11:20:40 [120105.539230] Demod State = 0
11:20:41 [120105.555254] Demod State = 0
11:20:41 [120105.571246] Demod State = 0
11:20:41 [120105.588716] Demod State = 3
11:20:41 [120105.603247] Demod State = 0
11:20:41 [120105.619295] Demod State = 0
11:20:41 [120105.635249] Demod State = 0
11:20:41 [120105.653342] Demod State = 3
11:20:41 [120105.671226] Demod State = 3
11:20:41 [120105.687238] Demod State = 3
11:20:41 [120105.703232] Demod State = 0
11:20:41 [120105.719232] Demod State = 0
11:20:41 [120105.735232] Demod State = 3
11:20:41 [120105.753334] Demod State = 3
11:20:41 [120105.771231] Demod State = 0
11:20:41 [120105.787231] Demod State = 0
11:20:41 [120105.803227] Demod State = 0
11:20:41 [120105.819233] Demod State = 3
11:20:41 [120105.835289] Demod State = 0
11:20:41 [120105.853334] Demod State = 3
11:20:41 [120105.871288] Demod State = 3
11:20:41 [120105.887234] Demod State = 3
11:20:41 [120105.903228] Demod State = 0
11:20:41 [120105.919227] Demod State = 0
11:20:41 [120105.935226] Demod State = 3
11:20:41 [120105.951221] Demod State = 0
11:20:41 [120105.967205] Demod State = 0
11:20:41 [120105.983215] Demod State = 3
11:20:41 [120105.999203] Demod State = 0
11:20:41 [120106.015195] Demod State = 0
11:20:41 [120106.031094] Demod State = 0
11:20:41 [120106.047105] Demod State = 3
11:20:41 [120106.063130] Demod State = 3
11:20:41 [120106.079136] Demod State = 0
11:20:41 [120106.095096] Demod State = 0
11:20:41 [120106.111096] Demod State = 0
11:20:41 [120106.127099] Demod State = 3
11:20:41 [120106.143122] Demod State = 0
11:20:41 [120106.159097] Demod State = 0
11:20:41 [120106.175128] Demod State = 0
11:20:41 [120106.191101] Demod State = 0
11:20:41 [120106.207216] Demod State = 0
11:20:41 [120106.223225] Demod State = 3
11:20:41 [120106.239208] Demod State = 0
11:20:41 [120106.254259] DEMOD LOCK FAIL
11:20:41 [120106.362296] lock: srate=963117056 r0=0x0 r1=0x0 r2=0x0 r3=0x3a 
11:20:41 [120106.362299] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0x9da srate_coarse=30272827 tmg_cpt=10
11:20:41 [120106.369846] lock: srate=990117888 r0=0x0 r1=0x0 r2=0x10 r3=0x3a 
11:20:41 [120106.377391] lock: srate=963379200 r0=0x0 r1=0x0 r2=0x58 r3=0x39 
11:20:41 [120106.394734] Demod State = 0
11:20:41 [120106.411200] Demod State = 0
11:20:41 [120106.427198] Demod State = 0
11:20:41 [120106.443208] Demod State = 0
11:20:41 [120106.459206] Demod State = 0
11:20:41 [120106.475217] Demod State = 3
11:20:41 [120106.491284] Demod State = 0
11:20:41 [120106.507206] Demod State = 0
11:20:41 [120106.523219] Demod State = 3
11:20:41 [120106.539207] Demod State = 3
11:20:42 [120106.555209] Demod State = 0
11:20:42 [120106.571221] Demod State = 0
11:20:42 [120106.587200] Demod State = 0
11:20:42 [120106.603233] Demod State = 3
11:20:42 [120106.619318] Demod State = 0
11:20:42 [120106.635106] Demod State = 0
11:20:42 [120106.651811] Demod State = 3
11:20:42 [120106.667128] Demod State = 0
11:20:42 [120106.683146] Demod State = 3
11:20:42 [120106.699095] Demod State = 0
11:20:42 [120106.715147] Demod State = 0
11:20:42 [120106.731096] Demod State = 0
11:20:42 [120106.747130] Demod State = 0
11:20:42 [120106.763203] Demod State = 0
11:20:42 [120106.779215] Demod State = 3
11:20:42 [120106.795206] Demod State = 0
11:20:42 [120106.811198] Demod State = 0
11:20:42 [120106.827206] Demod State = 0
11:20:42 [120106.843202] Demod State = 0
11:20:42 [120106.859204] Demod State = 0
11:20:42 [120106.875204] Demod State = 3
11:20:42 [120106.891195] Demod State = 0
11:20:42 [120106.907291] Demod State = 0
11:20:42 [120106.923209] Demod State = 0
11:20:42 [120106.939219] Demod State = 3
11:20:42 [120106.955407] Demod State = 3
11:20:42 [120106.971198] Demod State = 3
11:20:42 [120106.987227] Demod State = 0
11:20:42 [120107.003200] Demod State = 0
11:20:42 [120107.019222] Demod State = 0
11:20:42 [120107.035197] Demod State = 0
11:20:42 [120107.051213] Demod State = 3
11:20:42 [120107.067292] Demod State = 3
11:20:42 [120107.083199] Demod State = 0
11:20:42 [120107.099195] Demod State = 3
11:20:42 [120107.115195] Demod State = 0
11:20:42 [120107.131196] Demod State = 3
11:20:42 [120107.147199] Demod State = 3
11:20:42 [120107.163199] Demod State = 3
11:20:42 [120107.179194] Demod State = 0
11:20:42 [120107.195197] Demod State = 0
11:20:42 [120107.211197] Demod State = 0
11:20:42 [120107.227193] Demod State = 0
11:20:42 [120107.243196] Demod State = 0
11:20:42 [120107.259194] Demod State = 3
11:20:42 [120107.275193] Demod State = 3
11:20:42 [120107.291197] Demod State = 0
11:20:42 [120107.307192] Demod State = 0
11:20:42 [120107.323192] Demod State = 3
11:20:42 [120107.339220] Demod State = 0
11:20:42 [120107.355217] Demod State = 0
11:20:42 [120107.371194] Demod State = 3
11:20:42 [120107.387217] Demod State = 0
11:20:42 [120107.403194] Demod State = 0
11:20:42 [120107.419217] Demod State = 3
11:20:42 [120107.435195] Demod State = 0
11:20:42 [120107.451210] Demod State = 3
11:20:42 [120107.467193] Demod State = 3
11:20:42 [120107.483187] Demod State = 0
11:20:42 [120107.499195] Demod State = 0
11:20:42 [120107.514247] DEMOD LOCK FAIL
11:20:43 [120107.622433] lock: srate=1065091072 r0=0x0 r1=0x0 r2=0xb0 r3=0x3e 
11:20:43 [120107.622436] lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1643000 agc2=0xa87 srate_coarse=33478088 tmg_cpt=10
11:20:43 [120107.629982] lock: srate=1058013184 r0=0x0 r1=0x0 r2=0x7c r3=0x3f 
11:20:43 [120107.637519] lock: srate=1051197440 r0=0x0 r1=0x0 r2=0xfc r3=0x3e 
11:20:43 [120107.654802] Demod State = 0
11:20:43 [120107.671195] Demod State = 0
11:20:43 [120107.687224] Demod State = 0
11:20:43 [120107.703189] Demod State = 0
11:20:43 [120107.719226] Demod State = 0
11:20:43 [120107.735198] Demod State = 3
11:20:43 [120107.751224] Demod State = 0
11:20:43 [120107.767220] Demod State = 3
11:20:43 [120107.783235] Demod State = 0
11:20:43 [120107.799226] Demod State = 0
11:20:43 [120107.815229] Demod State = 3
11:20:43 [120107.831216] Demod State = 3
11:20:43 [120107.847216] Demod State = 0
11:20:43 [120107.863591] Demod State = 3
11:20:43 [120107.879222] Demod State = 0
11:20:43 [120107.895244] Demod State = 0
11:20:43 [120107.911222] Demod State = 0
11:20:43 [120107.927223] Demod State = 0
11:20:43 [120107.943275] Demod State = 3
11:20:43 [120107.959227] Demod State = 3
11:20:43 [120107.975227] Demod State = 3
11:20:43 [120107.991214] Demod State = 0
11:20:43 [120108.007213] Demod State = 0
11:20:43 [120108.025480] Demod State = 0
11:20:43 [120108.039221] Demod State = 3
11:20:43 [120108.040183] DEMOD LOCK OK
11:20:43 [120108.094348] stv0900_get_standard: standard 0
11:20:43 [120108.098413] stb6100_read_regs:     Read from 0x60
11:20:43 [120108.098416] stb6100_read_regs:         LD: 0x81
11:20:43 [120108.098417] stb6100_read_regs:         VCO: 0x66
11:20:43 [120108.098419] stb6100_read_regs:         NI: 0x3c
11:20:43 [120108.098420] stb6100_read_regs:         NF: 0xb4
11:20:43 [120108.098421] stb6100_read_regs:         K: 0x3d
11:20:43 [120108.098423] stb6100_read_regs:         G: 0x39
11:20:43 [120108.098424] stb6100_read_regs:         F: 0xdf
11:20:43 [120108.098425] stb6100_read_regs:         DLB: 0xdc
11:20:43 [120108.098427] stb6100_read_regs:         TEST1: 0x8f
11:20:43 [120108.098428] stb6100_read_regs:         FCCK: 0x0d
11:20:43 [120108.098430] stb6100_read_regs:         LPEN: 0xfb
11:20:43 [120108.098431] stb6100_read_regs:         TEST3: 0xde
11:20:43 [120108.098434] stb6100_get_frequency: frequency = 1642992 kHz, odiv = 0, psd2 = 1, fxtal = 27000 kHz, fvco = 3285984 kHz, N(I) = 60, N(F) = 436
11:20:43 [120108.100166] stv0900_get_tuner_freq: Frequency=1642992
11:20:43 [120108.110822] lock: srate=874922973 r0=0x5d r1=0x42 r2=0x26 r3=0x34 
11:20:43 [120108.118578] stv0900_get_signal_params: modcode=0x7 
11:20:43 [120108.125718] stb6100_read_regs:     Read from 0x60
11:20:43 [120108.125720] stb6100_read_regs:         LD: 0x81
11:20:43 [120108.125721] stb6100_read_regs:         VCO: 0x66
11:20:43 [120108.125722] stb6100_read_regs:         NI: 0x3c
11:20:43 [120108.125724] stb6100_read_regs:         NF: 0xb4
11:20:43 [120108.125725] stb6100_read_regs:         K: 0x3d
11:20:43 [120108.125727] stb6100_read_regs:         G: 0x39
11:20:43 [120108.125728] stb6100_read_regs:         F: 0xdf
11:20:43 [120108.125729] stb6100_read_regs:         DLB: 0xdc
11:20:43 [120108.125731] stb6100_read_regs:         TEST1: 0x8f
11:20:43 [120108.125732] stb6100_read_regs:         FCCK: 0x0d
11:20:43 [120108.125734] stb6100_read_regs:         LPEN: 0xfb
11:20:43 [120108.125735] stb6100_read_regs:         TEST3: 0xde
11:20:43 [120108.125738] stb6100_get_frequency: frequency = 1642992 kHz, odiv = 0, psd2 = 1, fxtal = 27000 kHz, fvco = 3285984 kHz, N(I) = 60, N(F) = 436
11:20:43 [120108.127471] stv0900_get_tuner_freq: Frequency=1642992
11:20:43 [120108.127472] stv0900_get_signal_params: range 12
11:20:43 [120108.127474] stv0900_track_optimization
11:20:43 [120108.135346] lock: srate=874921978 r0=0xcd r1=0x3f r2=0x26 r3=0x34 
11:20:43 [120108.138253] stv0900_track_optimization: found DVB-S or DSS
11:20:43 [120108.158082] stv0900_set_symbol_rate: Mclk 135000000, SR 27499251, Dmd 0
11:20:43 [120108.169011] stb6100_set_bandwidth: set bandwidth to 47123988 Hz
11:20:43 [120108.169013] stb6100_write_reg_range:     Write @ 0x60: [9:1]
11:20:43 [120108.169015] stb6100_write_reg_range:         FCCK: 0x4d
11:20:43 [120108.169581] stb6100_write_reg_range:     Write @ 0x60: [6:1]
11:20:43 [120108.169583] stb6100_write_reg_range:         F: 0xd3
11:20:43 [120108.178256] stb6100_write_reg_range:     Write @ 0x60: [9:1]
11:20:43 [120108.178267] stb6100_write_reg_range:         FCCK: 0x0d
11:20:43 [120108.180559] stv0900_set_bandwidth: Bandwidth=47123988
11:20:43 [120108.235215] Demod State = 3
11:20:43 [120108.236180] DEMOD LOCK OK
11:20:43 [120108.236951] stv0900_set_viterbi_tracq
11:20:43 [120108.257903] stv0900_wait_for_lock
11:20:43 [120108.258851] Demod State = 3
11:20:43 [120108.259893] DEMOD LOCK OK
11:20:43 [120108.259895] stv0900_get_fec_lock
11:20:43 [120108.261836] stv0900_get_fec_lock: DEMOD FEC LOCK OK
11:20:43 [120108.261838] stv0900_wait_for_lock: Timer = 0, time_out = 100
11:20:43 [120108.270247] stv0900_wait_for_lock: DEMOD LOCK OK
11:20:43 [120108.272580] Search Success
11:20:43 [120108.272582] stv0900_read_status: 
11:20:43 [120108.276621] stv0900_status: locked = 1
11:20:43 [120108.280575] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:43 [120108.280576] TS bitrate = 263 Mbit/sec 
11:20:43 [120108.280577] DEMOD LOCK OK
11:20:43 [120108.280593] stv0900_read_status: 
11:20:43 [120108.284524] stv0900_status: locked = 1
11:20:43 [120108.288475] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:43 [120108.288476] TS bitrate = 263 Mbit/sec 
11:20:43 [120108.288477] DEMOD LOCK OK
11:20:44 [120108.778249] stv0900_read_status: 
11:20:44 [120108.782205] stv0900_status: locked = 1
11:20:44 [120108.786169] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:44 [120108.786170] TS bitrate = 177 Mbit/sec 
11:20:44 [120108.786171] DEMOD LOCK OK
11:20:44 [120109.286249] stv0900_read_status: 
11:20:44 [120109.294509] stv0900_status: locked = 1
11:20:44 [120109.298470] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:44 [120109.298472] TS bitrate = 121 Mbit/sec 
11:20:44 [120109.298473] DEMOD LOCK OK
11:20:44 [120109.310140] stv0900_read_status: 
11:20:44 [120109.313996] stv0900_status: locked = 1
11:20:44 [120109.317872] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:44 [120109.317874] TS bitrate = 119 Mbit/sec 
11:20:44 [120109.317875] DEMOD LOCK OK
11:20:45 [120109.798245] stv0900_read_status: 
11:20:45 [120109.802207] stv0900_status: locked = 1
11:20:45 [120109.806150] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:45 [120109.806151] TS bitrate = 90 Mbit/sec 
11:20:45 [120109.806152] DEMOD LOCK OK
11:20:45 [120110.306241] stv0900_read_status: 
11:20:45 [120110.314547] stv0900_status: locked = 1
11:20:45 [120110.318578] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:45 [120110.318580] TS bitrate = 70 Mbit/sec 
11:20:45 [120110.318581] DEMOD LOCK OK
11:20:45 [120110.338144] stv0900_read_status: 
11:20:45 [120110.342012] stv0900_status: locked = 1
11:20:45 [120110.345879] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:45 [120110.345880] TS bitrate = 68 Mbit/sec 
11:20:45 [120110.345882] DEMOD LOCK OK
11:20:46 [120110.818243] stv0900_read_status: 
11:20:46 [120110.822242] stv0900_status: locked = 1
11:20:46 [120110.826267] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:46 [120110.826269] TS bitrate = 58 Mbit/sec 
11:20:46 [120110.826270] DEMOD LOCK OK
11:20:46 [120111.326237] stv0900_read_status: 
11:20:46 [120111.330274] stv0900_status: locked = 1
11:20:46 [120111.338576] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:46 [120111.338578] TS bitrate = 52 Mbit/sec 
11:20:46 [120111.338579] DEMOD LOCK OK
11:20:46 [120111.358237] stv0900_read_status: 
11:20:46 [120111.362096] stv0900_status: locked = 1
11:20:46 [120111.365955] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:46 [120111.365957] TS bitrate = 51 Mbit/sec 
11:20:46 [120111.365958] DEMOD LOCK OK
11:20:47 [120111.838236] stv0900_read_status: 
11:20:47 [120111.842283] stv0900_status: locked = 1
11:20:47 [120111.848414] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:47 [120111.848416] TS bitrate = 47 Mbit/sec 
11:20:47 [120111.848417] DEMOD LOCK OK
11:20:47 [120112.346246] stv0900_read_status: 
11:20:47 [120112.350226] stv0900_status: locked = 1
11:20:47 [120112.354254] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:47 [120112.354255] TS bitrate = 45 Mbit/sec 
11:20:47 [120112.354256] DEMOD LOCK OK
11:20:47 [120112.382228] stv0900_read_status: 
11:20:47 [120112.386112] stv0900_status: locked = 1
11:20:47 [120112.389993] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:47 [120112.389994] TS bitrate = 44 Mbit/sec 
11:20:47 [120112.389995] DEMOD LOCK OK
11:20:48 [120112.854231] stv0900_read_status: 
11:20:48 [120112.858240] stv0900_status: locked = 1
11:20:48 [120112.862210] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:48 [120112.862211] TS bitrate = 42 Mbit/sec 
11:20:48 [120112.862212] DEMOD LOCK OK
11:20:48 [120113.362228] stv0900_read_status: 
11:20:48 [120113.366187] stv0900_status: locked = 1
11:20:48 [120113.370265] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:48 [120113.370267] TS bitrate = 43 Mbit/sec 
11:20:48 [120113.370268] DEMOD LOCK OK
11:20:48 [120113.406226] stv0900_read_status: 
11:20:48 [120113.410124] stv0900_status: locked = 1
11:20:48 [120113.414006] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:48 [120113.414008] TS bitrate = 42 Mbit/sec 
11:20:48 [120113.414009] DEMOD LOCK OK
11:20:49 [120113.870227] stv0900_read_status: 
11:20:49 [120113.874234] stv0900_status: locked = 1
11:20:49 [120113.878271] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:49 [120113.878273] TS bitrate = 40 Mbit/sec 
11:20:49 [120113.878274] DEMOD LOCK OK
11:20:49 [120114.378453] stv0900_read_status: 
11:20:49 [120114.385457] stv0900_status: locked = 1
11:20:49 [120114.389511] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:49 [120114.389513] TS bitrate = 42 Mbit/sec 
11:20:49 [120114.389514] DEMOD LOCK OK
11:20:49 [120114.430205] stv0900_read_status: 
11:20:49 [120114.434078] stv0900_status: locked = 1
11:20:49 [120114.438048] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:49 [120114.438049] TS bitrate = 41 Mbit/sec 
11:20:49 [120114.438050] DEMOD LOCK OK
11:20:50 [120114.886269] stv0900_read_status: 
11:20:50 [120114.891307] stv0900_status: locked = 1
11:20:50 [120114.895307] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:50 [120114.895308] TS bitrate = 41 Mbit/sec 
11:20:50 [120114.895309] DEMOD LOCK OK
11:20:50 [120115.394251] stv0900_read_status: 
11:20:50 [120115.400462] stv0900_status: locked = 1
11:20:50 [120115.404438] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:50 [120115.404440] TS bitrate = 41 Mbit/sec 
11:20:50 [120115.404441] DEMOD LOCK OK
11:20:50 [120115.454211] stv0900_read_status: 
11:20:50 [120115.458107] stv0900_status: locked = 1
11:20:50 [120115.461991] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:50 [120115.461993] TS bitrate = 41 Mbit/sec 
11:20:50 [120115.461994] DEMOD LOCK OK
11:20:51 [120115.902217] stv0900_read_status: 
11:20:51 [120115.906235] stv0900_status: locked = 1
11:20:51 [120115.910221] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:51 [120115.910222] TS bitrate = 41 Mbit/sec 
11:20:51 [120115.910223] DEMOD LOCK OK
11:20:51 [120116.410213] stv0900_read_status: 
11:20:51 [120116.414191] stv0900_status: locked = 1
11:20:51 [120116.418216] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:51 [120116.418217] TS bitrate = 41 Mbit/sec 
11:20:51 [120116.418218] DEMOD LOCK OK
11:20:51 [120116.478211] stv0900_read_status: 
11:20:51 [120116.482087] stv0900_status: locked = 1
11:20:51 [120116.485957] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:51 [120116.485959] TS bitrate = 41 Mbit/sec 
11:20:51 [120116.485960] DEMOD LOCK OK
11:20:52 [120116.918211] stv0900_read_status: 
11:20:52 [120116.924325] stv0900_status: locked = 1
11:20:52 [120116.928419] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:52 [120116.928420] TS bitrate = 41 Mbit/sec 
11:20:52 [120116.928421] DEMOD LOCK OK
11:20:52 [120117.426203] stv0900_read_status: 
11:20:52 [120117.430186] stv0900_status: locked = 1
11:20:52 [120117.434166] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:52 [120117.434168] TS bitrate = 41 Mbit/sec 
11:20:52 [120117.434169] DEMOD LOCK OK
11:20:52 [120117.502205] stv0900_read_status: 
11:20:52 [120117.506085] stv0900_status: locked = 1
11:20:52 [120117.509948] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:52 [120117.509950] TS bitrate = 41 Mbit/sec 
11:20:52 [120117.509951] DEMOD LOCK OK
11:20:53 [120117.934201] stv0900_read_status: 
11:20:53 [120117.938214] stv0900_status: locked = 1
11:20:53 [120117.942225] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:53 [120117.942227] TS bitrate = 41 Mbit/sec 
11:20:53 [120117.942228] DEMOD LOCK OK
11:20:53 [120118.442202] stv0900_read_status: 
11:20:53 [120118.446238] stv0900_status: locked = 1
11:20:53 [120118.452453] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:53 [120118.452455] TS bitrate = 41 Mbit/sec 
11:20:53 [120118.452456] DEMOD LOCK OK
11:20:53 [120118.526215] stv0900_read_status: 
11:20:53 [120118.530091] stv0900_status: locked = 1
11:20:53 [120118.533980] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:53 [120118.533981] TS bitrate = 41 Mbit/sec 
11:20:53 [120118.533982] DEMOD LOCK OK
11:20:54 [120118.950196] stv0900_read_status: 
11:20:54 [120118.954237] stv0900_status: locked = 1
11:20:54 [120118.958248] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:54 [120118.958249] TS bitrate = 41 Mbit/sec 
11:20:54 [120118.958250] DEMOD LOCK OK
11:20:54 [120119.458196] stv0900_read_status: 
11:20:54 [120119.462245] stv0900_status: locked = 1
11:20:54 [120119.466244] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:54 [120119.466245] TS bitrate = 41 Mbit/sec 
11:20:54 [120119.466246] DEMOD LOCK OK
11:20:55 [120119.550208] stv0900_read_status: 
11:20:55 [120119.554206] stv0900_status: locked = 1
11:20:55 [120119.558230] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:55 [120119.558232] TS bitrate = 41 Mbit/sec 
11:20:55 [120119.558233] DEMOD LOCK OK
11:20:55 [120119.966195] stv0900_read_status: 
11:20:55 [120119.970240] stv0900_status: locked = 1
11:20:55 [120119.974190] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:55 [120119.974191] TS bitrate = 41 Mbit/sec 
11:20:55 [120119.974193] DEMOD LOCK OK
11:20:55 [120120.474196] stv0900_read_status: 
11:20:55 [120120.480371] stv0900_status: locked = 1
11:20:55 [120120.484297] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:55 [120120.484299] TS bitrate = 41 Mbit/sec 
11:20:55 [120120.484300] DEMOD LOCK OK
11:20:56 [120120.574199] stv0900_read_status: 
11:20:56 [120120.578248] stv0900_status: locked = 1
11:20:56 [120120.582206] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:56 [120120.582207] TS bitrate = 41 Mbit/sec 
11:20:56 [120120.582208] DEMOD LOCK OK
11:20:56 [120120.982214] stv0900_read_status: 
11:20:56 [120120.986296] stv0900_status: locked = 1
11:20:56 [120120.990305] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:56 [120120.990307] TS bitrate = 41 Mbit/sec 
11:20:56 [120120.990308] DEMOD LOCK OK
11:20:56 [120121.490188] stv0900_read_status: 
11:20:56 [120121.494129] stv0900_status: locked = 1
11:20:56 [120121.498100] stv0900_get_mclk_freq: Calculated Mclk = 135000000
11:20:56 [120121.498102] TS bitrate = 41 Mbit/sec 
11:20:56 [120121.498103] DEMOD LOCK OK

--------------090202000106050804040804--
