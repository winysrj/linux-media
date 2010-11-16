Return-path: <mchehab@pedra>
Received: from tur.go2.pl ([193.17.41.50]:49518 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934027Ab0KPJOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 04:14:22 -0500
Received: from moh1-ve1.go2.pl (moh1-ve1.go2.pl [193.17.41.131])
	by tur.go2.pl (o2.pl Mailer 2.0.1) with ESMTP id 53E4B23065F
	for <linux-media@vger.kernel.org>; Tue, 16 Nov 2010 10:14:19 +0100 (CET)
Received: from moh1-ve1.go2.pl (unknown [10.0.0.131])
	by moh1-ve1.go2.pl (Postfix) with ESMTP id E50AD620399
	for <linux-media@vger.kernel.org>; Tue, 16 Nov 2010 10:13:03 +0100 (CET)
Received: from o2.pl (unknown [10.0.0.120])
	by moh1-ve1.go2.pl (Postfix) with SMTP
	for <linux-media@vger.kernel.org>; Tue, 16 Nov 2010 10:13:01 +0100 (CET)
Subject: =?UTF-8?Q?Prof7301:_DVB-S->DVBS2_tunning_issue_?=
From: =?UTF-8?Q?warpme?= <warpme@o2.pl>
To: linux-media@vger.kernel.org
Mime-Version: 1.0
Message-ID: <42367006.65a45010.4ce24b1c.c41b0@o2.pl>
Date: Tue, 16 Nov 2010 10:13:00 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I'm using 2x ProfTuners7301 in my production environment (ArchLinux, 2.6.35.7, Myth27117).
Basically cards works OK, but I have repeatable tunning issue when I tune directly from tuned DVB-S2 transponder to DVB-S transponder. For every 3-5 attempts I have issue with lock (see log below).
There is no any issues when I tune to that DVB-S transponder from idle.
I have impression that issue is correlated with switching directly  from DVB-S2 to DVB-S (without idle phase between).
Is it possible that thus issue is result of driver issues ?
thx

Nov 16 07:47:35 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:35 mythtv kernel: stv0900_status: locked = 1
Nov 16 07:47:35 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:35 mythtv kernel: TS bitrate = 61 Mbit/sec 
Nov 16 07:47:35 mythtv kernel: DEMOD LOCK OK
Nov 16 07:47:35 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:35 mythtv kernel: stv0900_get_rf_level: RFLevel = -35
Nov 16 07:47:35 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:35 mythtv kernel: stv0900_get_standard: standard 1
Nov 16 07:47:35 mythtv kernel: stv0900_get_standard: standard 1
Nov 16 07:47:35 mythtv kernel: stv0900_set_tone: Off
Nov 16 07:47:35 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:35 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:35 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:35 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:35 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:35 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:35 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:35 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:35 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:35 mythtv kernel: stv0900_search: 
Nov 16 07:47:35 mythtv kernel: stv0900_algo
Nov 16 07:47:35 mythtv kernel: stv0900_set_symbol_rate: Mclk 135000000, SR 1000000, Dmd 0
Nov 16 07:47:35 mythtv kernel: stv0900_set_tuner: Frequency=969000
Nov 16 07:47:36 mythtv kernel: stv0900_set_tuner: Bandwidth=72000000
Nov 16 07:47:36 mythtv kernel: stv0900_set_search_standard
Nov 16 07:47:36 mythtv kernel: Search Standard = AUTO
Nov 16 07:47:36 mythtv kernel: stv0900_activate_s2_modcod_single
Nov 16 07:47:36 mythtv kernel: stv0900_set_viterbi_tracq
Nov 16 07:47:36 mythtv kernel: stv0900_set_viterbi_standard: ViterbiStandard = 
Nov 16 07:47:36 mythtv kernel: Auto
Nov 16 07:47:36 mythtv kernel: stv0900_blind_search_algo
Nov 16 07:47:36 mythtv kernel: stv0900_blind_check_agc2_min_level
Nov 16 07:47:36 mythtv kernel: stv0900_set_symbol_rate: Mclk 135000000, SR 1000000, Dmd 0
Nov 16 07:47:36 mythtv kernel: stv0900_blind_search_algo agc2_int=238 agc2_th=700 
Nov 16 07:47:36 mythtv kernel: lock: srate=796917760 r0=0x0 r1=0x0 r2=0x8 r3=0x30 
Nov 16 07:47:36 mythtv kernel: lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=969000 agc2=0x746 srate_coarse=25048828 tmg_cpt=10
Nov 16 07:47:36 mythtv kernel: lock: srate=765460480 r0=0x0 r1=0x0 r2=0x6c r3=0x2d 
Nov 16 07:47:36 mythtv kernel: lock: srate=749993984 r0=0x0 r1=0x0 r2=0x54 r3=0x2e 
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 3
Nov 16 07:47:36 mythtv kernel: Demod State = 3
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 3
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 3
Nov 16 07:47:36 mythtv kernel: Demod State = 3
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 3
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 3
Nov 16 07:47:36 mythtv kernel: Demod State = 3
Nov 16 07:47:36 mythtv kernel: Demod State = 3
Nov 16 07:47:36 mythtv kernel: Demod State = 3
Nov 16 07:47:36 mythtv kernel: Demod State = 3
Nov 16 07:47:36 mythtv kernel: Demod State = 3
Nov 16 07:47:36 mythtv kernel: Demod State = 0
Nov 16 07:47:36 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:37 mythtv kernel: lock: srate=870055936 r0=0x0 r1=0x0 r2=0xa0 r3=0x31 
Nov 16 07:47:37 mythtv kernel: lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=969000 agc2=0x7d1 srate_coarse=27347717 tmg_cpt=10
Nov 16 07:47:37 mythtv kernel: lock: srate=858259456 r0=0x0 r1=0x0 r2=0xe8 r3=0x32 
Nov 16 07:47:37 mythtv kernel: lock: srate=842268672 r0=0x0 r1=0x0 r2=0x64 r3=0x33 
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 0
Nov 16 07:47:37 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:38 mythtv kernel: lock: srate=945029120 r0=0x0 r1=0x0 r2=0x48 r3=0x37 
Nov 16 07:47:38 mythtv kernel: lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=969000 agc2=0x853 srate_coarse=29704284 tmg_cpt=10
Nov 16 07:47:38 mythtv kernel: lock: srate=941359104 r0=0x0 r1=0x0 r2=0x78 r3=0x38 
Nov 16 07:47:38 mythtv kernel: lock: srate=921436160 r0=0x0 r1=0x0 r2=0xf8 r3=0x38 
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 0
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:38 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:39 mythtv kernel: lock: srate=1003749376 r0=0x0 r1=0x0 r2=0xdc r3=0x3c 
Nov 16 07:47:39 mythtv kernel: lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=969000 agc2=0x8fb srate_coarse=31549987 tmg_cpt=10
Nov 16 07:47:39 mythtv kernel: lock: srate=1013186560 r0=0x0 r1=0x0 r2=0x4 r3=0x3c 
Nov 16 07:47:39 mythtv kernel: lock: srate=1017643008 r0=0x0 r1=0x0 r2=0x80 r3=0x3d 
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 3
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:39 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 0
Nov 16 07:47:40 mythtv kernel: Demod State = 3
Nov 16 07:47:40 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:40 mythtv kernel: lock: srate=8388608 r0=0x0 r1=0x0 r2=0x8c r3=0x0 
Nov 16 07:47:40 mythtv kernel: lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=969000 agc2=0xbd srate_coarse=263671 tmg_cpt=10
Nov 16 07:47:40 mythtv kernel: Search Fail
Nov 16 07:47:40 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:40 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:40 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:40 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:40 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:40 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:40 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:40 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:40 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:40 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:40 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:40 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:40 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:40 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:40 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:40 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:40 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:40 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:40 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:40 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:40 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:40 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:40 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:40 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:40 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:40 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:40 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:40 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:40 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:40 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:41 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:41 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:41 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:41 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:41 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:41 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:41 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:42 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:42 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:42 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:42 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:42 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:42 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:42 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:43 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:43 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:43 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:43 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:43 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:43 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:43 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:43 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:44 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:44 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:44 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:44 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:44 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:44 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:44 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:45 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:45 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:45 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:45 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:45 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:45 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:45 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:45 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:46 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:46 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:46 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:46 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:46 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:46 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:46 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:47 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:47 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:47 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:47 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:47 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:47 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:47 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:47 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:48 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:48 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:48 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:48 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:48 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:48 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:48 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:49 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:49 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:49 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:49 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:49 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:49 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:49 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:50 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:50 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:50 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:50 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:50 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:50 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:50 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:51 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:51 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:51 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:51 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:51 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:51 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:51 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:52 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:52 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:52 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:52 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:52 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:52 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:52 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:52 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:53 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:53 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:53 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:53 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:53 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:53 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:53 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:54 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:54 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:54 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:54 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:54 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:54 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:54 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:55 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:55 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:55 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:55 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:55 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:55 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:55 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:56 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:56 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:56 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:56 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:56 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:56 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:56 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:57 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:57 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:57 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:57 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:57 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:57 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:57 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:58 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:58 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:58 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:58 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:58 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:58 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:58 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:58 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:58 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:58 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:58 mythtv kernel: stv0900_read_status: 
Nov 16 07:47:58 mythtv kernel: stv0900_status: locked = 0
Nov 16 07:47:58 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:47:58 mythtv kernel: TS bitrate = 270 Mbit/sec 
Nov 16 07:47:58 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:58 mythtv kernel: stv0900_get_rf_level
Nov 16 07:47:58 mythtv kernel: stv0900_get_rf_level: RFLevel = -36
Nov 16 07:47:58 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:47:58 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:58 mythtv kernel: stv0900_get_standard: standard 4
Nov 16 07:47:58 mythtv kernel: stv0900_set_tone: Off
Nov 16 07:47:58 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:58 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:58 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:58 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:58 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:58 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:58 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:58 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:58 mythtv kernel: stb0900_set_property(..)
Nov 16 07:47:58 mythtv kernel: stv0900_search: 
Nov 16 07:47:58 mythtv kernel: stv0900_algo
Nov 16 07:47:58 mythtv kernel: stv0900_set_symbol_rate: Mclk 135000000, SR 1000000, Dmd 0
Nov 16 07:47:58 mythtv kernel: stv0900_set_tuner: Frequency=1046000
Nov 16 07:47:58 mythtv kernel: stv0900_set_tuner: Bandwidth=72000000
Nov 16 07:47:58 mythtv kernel: stv0900_set_search_standard
Nov 16 07:47:58 mythtv kernel: Search Standard = AUTO
Nov 16 07:47:58 mythtv kernel: stv0900_activate_s2_modcod_single
Nov 16 07:47:58 mythtv kernel: stv0900_set_viterbi_tracq
Nov 16 07:47:58 mythtv kernel: stv0900_set_viterbi_standard: ViterbiStandard = 
Nov 16 07:47:58 mythtv kernel: Auto
Nov 16 07:47:58 mythtv kernel: stv0900_blind_search_algo
Nov 16 07:47:58 mythtv kernel: stv0900_blind_check_agc2_min_level
Nov 16 07:47:58 mythtv kernel: stv0900_set_symbol_rate: Mclk 135000000, SR 1000000, Dmd 0
Nov 16 07:47:58 mythtv kernel: stv0900_blind_search_algo agc2_int=263 agc2_th=700 
Nov 16 07:47:58 mythtv kernel: lock: srate=809500672 r0=0x0 r1=0x0 r2=0x4c r3=0x30 
Nov 16 07:47:58 mythtv kernel: lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1046000 agc2=0x7e9 srate_coarse=25444335 tmg_cpt=10
Nov 16 07:47:58 mythtv kernel: lock: srate=785907712 r0=0x0 r1=0x0 r2=0x40 r3=0x30 
Nov 16 07:47:58 mythtv kernel: lock: srate=762052608 r0=0x0 r1=0x0 r2=0x80 r3=0x2f 
Nov 16 07:47:58 mythtv kernel: Demod State = 0
Nov 16 07:47:58 mythtv kernel: Demod State = 3
Nov 16 07:47:58 mythtv kernel: Demod State = 3
Nov 16 07:47:58 mythtv kernel: Demod State = 3
Nov 16 07:47:58 mythtv kernel: Demod State = 3
Nov 16 07:47:58 mythtv kernel: Demod State = 0
Nov 16 07:47:58 mythtv kernel: Demod State = 0
Nov 16 07:47:58 mythtv kernel: Demod State = 3
Nov 16 07:47:58 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:47:59 mythtv kernel: lock: srate=867696640 r0=0x0 r1=0x0 r2=0xe0 r3=0x33 
Nov 16 07:47:59 mythtv kernel: lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1046000 agc2=0x871 srate_coarse=27273559 tmg_cpt=10
Nov 16 07:47:59 mythtv kernel: lock: srate=866123776 r0=0x0 r1=0x0 r2=0xac r3=0x34 
Nov 16 07:47:59 mythtv kernel: lock: srate=862191616 r0=0x0 r1=0x0 r2=0x38 r3=0x34 
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 3
Nov 16 07:47:59 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: Demod State = 3
Nov 16 07:48:00 mythtv kernel: Demod State = 0
Nov 16 07:48:00 mythtv kernel: DEMOD LOCK FAIL
Nov 16 07:48:01 mythtv kernel: lock: srate=981729280 r0=0x0 r1=0x0 r2=0x8 r3=0x3a 
Nov 16 07:48:01 mythtv kernel: lock: I2C_DEMOD_MODE_FIELD =0. Search started. tuner freq=1046000 agc2=0x942 srate_coarse=30857849 tmg_cpt=10
Nov 16 07:48:01 mythtv kernel: lock: srate=974127104 r0=0x0 r1=0x0 r2=0xc4 r3=0x39 
Nov 16 07:48:01 mythtv kernel: lock: srate=958398464 r0=0x0 r1=0x0 r2=0x54 r3=0x3a 
Nov 16 07:48:01 mythtv kernel: Demod State = 0
Nov 16 07:48:01 mythtv kernel: Demod State = 0
Nov 16 07:48:01 mythtv kernel: Demod State = 3
Nov 16 07:48:01 mythtv kernel: Demod State = 0
Nov 16 07:48:01 mythtv kernel: Demod State = 0
Nov 16 07:48:01 mythtv kernel: Demod State = 0
Nov 16 07:48:01 mythtv kernel: Demod State = 3
Nov 16 07:48:01 mythtv kernel: Demod State = 3
Nov 16 07:48:01 mythtv kernel: Demod State = 0
Nov 16 07:48:01 mythtv kernel: Demod State = 0
Nov 16 07:48:01 mythtv kernel: Demod State = 3
Nov 16 07:48:01 mythtv kernel: Demod State = 0
Nov 16 07:48:01 mythtv kernel: Demod State = 0
Nov 16 07:48:01 mythtv kernel: Demod State = 0
Nov 16 07:48:01 mythtv kernel: Demod State = 3
Nov 16 07:48:01 mythtv kernel: Demod State = 0
Nov 16 07:48:01 mythtv kernel: Demod State = 0
Nov 16 07:48:01 mythtv kernel: Demod State = 0
Nov 16 07:48:01 mythtv kernel: Demod State = 0
Nov 16 07:48:01 mythtv kernel: Demod State = 3
Nov 16 07:48:01 mythtv kernel: Demod State = 3
Nov 16 07:48:01 mythtv kernel: Demod State = 3
Nov 16 07:48:01 mythtv kernel: Demod State = 3
Nov 16 07:48:01 mythtv kernel: Demod State = 3
Nov 16 07:48:01 mythtv kernel: Demod State = 3
Nov 16 07:48:01 mythtv kernel: DEMOD LOCK OK
Nov 16 07:48:01 mythtv kernel: stv0900_get_standard: standard 0
Nov 16 07:48:01 mythtv kernel: stv0900_get_tuner_freq: Frequency=1046012
Nov 16 07:48:01 mythtv kernel: lock: srate=874842661 r0=0x38 r1=0xa r2=0x25 r3=0x34 
Nov 16 07:48:01 mythtv kernel: stv0900_get_signal_params: modcode=0x9 
Nov 16 07:48:01 mythtv kernel: stv0900_get_tuner_freq: Frequency=1046012
Nov 16 07:48:01 mythtv kernel: stv0900_get_signal_params: range 12
Nov 16 07:48:01 mythtv kernel: stv0900_track_optimization
Nov 16 07:48:01 mythtv kernel: lock: srate=874843161 r0=0x19 r1=0xc r2=0x25 r3=0x34 
Nov 16 07:48:01 mythtv kernel: stv0900_track_optimization: found DVB-S or DSS
Nov 16 07:48:01 mythtv kernel: stv0900_set_symbol_rate: Mclk 135000000, SR 27499680, Dmd 0
Nov 16 07:48:01 mythtv kernel: stv0900_set_bandwidth: Bandwidth=47124568
Nov 16 07:48:01 mythtv kernel: Demod State = 3
Nov 16 07:48:01 mythtv kernel: DEMOD LOCK OK
Nov 16 07:48:01 mythtv kernel: stv0900_set_viterbi_tracq
Nov 16 07:48:01 mythtv kernel: stv0900_wait_for_lock
Nov 16 07:48:01 mythtv kernel: Demod State = 3
Nov 16 07:48:01 mythtv kernel: DEMOD LOCK OK
Nov 16 07:48:01 mythtv kernel: stv0900_get_fec_lock
Nov 16 07:48:01 mythtv kernel: stv0900_get_fec_lock: DEMOD FEC LOCK OK
Nov 16 07:48:01 mythtv kernel: stv0900_wait_for_lock: Timer = 0, time_out = 100
Nov 16 07:48:01 mythtv kernel: stv0900_wait_for_lock: DEMOD LOCK OK
Nov 16 07:48:01 mythtv kernel: Search Success
Nov 16 07:48:01 mythtv kernel: stv0900_read_status: 
Nov 16 07:48:01 mythtv kernel: stv0900_status: locked = 1
Nov 16 07:48:01 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:48:01 mythtv kernel: TS bitrate = 265 Mbit/sec 
Nov 16 07:48:01 mythtv kernel: DEMOD LOCK OK
Nov 16 07:48:01 mythtv kernel: stv0900_read_status: 
Nov 16 07:48:01 mythtv kernel: stv0900_status: locked = 1
Nov 16 07:48:01 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:48:01 mythtv kernel: TS bitrate = 263 Mbit/sec 
Nov 16 07:48:01 mythtv kernel: DEMOD LOCK OK
Nov 16 07:48:01 mythtv kernel: stv0900_read_status: 
Nov 16 07:48:01 mythtv kernel: stv0900_status: locked = 1
Nov 16 07:48:01 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:48:01 mythtv kernel: TS bitrate = 249 Mbit/sec 
Nov 16 07:48:01 mythtv kernel: DEMOD LOCK OK
Nov 16 07:48:01 mythtv kernel: stv0900_get_rf_level
Nov 16 07:48:01 mythtv kernel: stv0900_get_rf_level: RFLevel = -35
Nov 16 07:48:01 mythtv kernel: stv0900_carr_get_quality
Nov 16 07:48:01 mythtv kernel: stv0900_get_standard: standard 0
Nov 16 07:48:01 mythtv kernel: stv0900_get_standard: standard 0
Nov 16 07:48:04 mythtv kernel: stv0900_read_status: 
Nov 16 07:48:04 mythtv kernel: stv0900_status: locked = 1
Nov 16 07:48:04 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:48:04 mythtv kernel: TS bitrate = 59 Mbit/sec 
Nov 16 07:48:04 mythtv kernel: DEMOD LOCK OK
Nov 16 07:48:15 mythtv kernel: stv0900_read_status: 
Nov 16 07:48:15 mythtv kernel: stv0900_status: locked = 1
Nov 16 07:48:15 mythtv kernel: stv0900_get_mclk_freq: Calculated Mclk = 135000000
Nov 16 07:48:15 mythtv kernel: TS bitrate = 46 Mbit/sec 
Nov 16 07:48:15 mythtv kernel: DEMOD LOCK OK
         
