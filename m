Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:46275 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbZJLLIU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 07:08:20 -0400
Received: from localhost (localhost.crans.org [127.0.0.1])
	by rouge.crans.org (Postfix) with ESMTP id A1E458069
	for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 13:07:42 +0200 (CEST)
Received: from rouge.crans.org ([10.231.136.3])
	by localhost (rouge.crans.org [10.231.136.3]) (amavisd-new, port 10024)
	with LMTP id YlceNivipCkA for <linux-media@vger.kernel.org>;
	Mon, 12 Oct 2009 13:07:42 +0200 (CEST)
Received: from [192.168.1.10] (64.pool85-50-72.dynamic.orange.es [85.50.72.64])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rouge.crans.org (Postfix) with ESMTP id 2F5728065
	for <linux-media@vger.kernel.org>; Mon, 12 Oct 2009 13:07:41 +0200 (CEST)
Message-ID: <4AD30DFD.8080800@crans.ens-cachan.fr>
Date: Mon, 12 Oct 2009 13:07:41 +0200
From: DUBOST Brice <dubost@crans.ens-cachan.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: S2API and DVB-T tuning
Content-Type: multipart/mixed;
 boundary="------------040801050702000704040005"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040801050702000704040005
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hello,

I have some problems with DVB-T tuning under s2-api/DVB API 5

To run these tests I use scan-s2-7effc68db255

My machine runs the following kernel (uname -a)
Linux fixe_barcelone 2.6.31-13-generic #42-Ubuntu SMP Thu Oct 8 20:03:54
UTC 2009 x86_64 GNU/Linux

And I own 3 DVB-T devices :
1:
01:00.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Technotrend Systemtechnik GmbH Device 1012
	Flags: bus master, medium devsel, latency 64, IRQ 21
	Memory at fa6ffc00 (32-bit, non-prefetchable) [size=512]
	Kernel driver in use: budget_ci dvb
	Kernel modules: budget-ci
2:
Bus 001 Device 010: ID 2040:7070 Hauppauge

3:
Bus 001 Device 011: ID 07ca:a815 AVerMedia Technologies, Inc.

All three devices tune well and work flawlessly with scan (dvb api v3)
But when I use scan-s2, only the AVerMedia is able to lock

I use the dvb-t/es-Collserola as an initial tuning file.

I thought the S2API shouldn't change the tuning behavior.

I tried to search the Mailing list archives via google I unfortunately
found nothing. I'm sorry if this subject was discussed before.

What can I do to investigate more on this issue ?

PS : I join the debug output for the sucessful and unsucessful tuning

Thanks

-- 
Brice

A: Yes.
>Q: Are you sure?
>>A: Because it reverses the logical flow of conversation.
>>>Q: Why is top posting annoying in email?

--------------040801050702000704040005
Content-Type: text/plain;
 name="scan_dvbapi3.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scan_dvbapi3.txt"

Oct 12 13:02:28 fixe_barcelone kernel: [228614.407730] DiB7000P: setting output mode for demod ffff880139055000 to 0
Oct 12 13:02:28 fixe_barcelone kernel: [228614.416623] DiB0070: Tuning for Band: 2 (514000 kHz)
Oct 12 13:02:28 fixe_barcelone kernel: [228614.448106] DiB0070: HFDIV code: 5
Oct 12 13:02:28 fixe_barcelone kernel: [228614.448112] DiB0070: VCO = 1
Oct 12 13:02:28 fixe_barcelone kernel: [228614.448115] DiB0070: VCOF in kHz: 6168000 ((6*514000) << 1))
Oct 12 13:02:28 fixe_barcelone kernel: [228614.448120] DiB0070: REFDIV: 1, FREF: 12000
Oct 12 13:02:28 fixe_barcelone kernel: [228614.448124] DiB0070: FBDIV: 85, Rest: 43520
Oct 12 13:02:28 fixe_barcelone kernel: [228614.448127] DiB0070: Num: -22016, Den: 255, SD: 1
Oct 12 13:02:28 fixe_barcelone kernel: [228614.513606] DiB0070: CAPTRIM=64; ADC = 905 (ADC) & 1590mV
Oct 12 13:02:28 fixe_barcelone kernel: [228614.513613] DiB0070: CAPTRIM=64 is closer to target (505/3000)
Oct 12 13:02:28 fixe_barcelone kernel: [228614.534355] DiB0070: CAPTRIM=32; ADC = 35 (ADC) & 61mV
Oct 12 13:02:28 fixe_barcelone kernel: [228614.534362] DiB0070: CAPTRIM=32 is closer to target (365/505)
Oct 12 13:02:28 fixe_barcelone kernel: [228614.554356] DiB0070: CAPTRIM=48; ADC = 34 (ADC) & 59mV
Oct 12 13:02:28 fixe_barcelone kernel: [228614.574981] DiB0070: CAPTRIM=56; ADC = 141 (ADC) & 247mV
Oct 12 13:02:28 fixe_barcelone kernel: [228614.574988] DiB0070: CAPTRIM=56 is closer to target (259/365)
Oct 12 13:02:28 fixe_barcelone kernel: [228614.594356] DiB0070: CAPTRIM=60; ADC = 285 (ADC) & 500mV
Oct 12 13:02:28 fixe_barcelone kernel: [228614.594363] DiB0070: CAPTRIM=60 is closer to target (115/259)
Oct 12 13:02:28 fixe_barcelone kernel: [228614.614357] DiB0070: CAPTRIM=62; ADC = 420 (ADC) & 738mV
Oct 12 13:02:28 fixe_barcelone kernel: [228614.614364] DiB0070: CAPTRIM=62 is closer to target (20/115)
Oct 12 13:02:28 fixe_barcelone kernel: [228614.634484] DiB0070: CAPTRIM=61; ADC = 343 (ADC) & 602mV
Oct 12 13:02:29 fixe_barcelone kernel: [228614.759111] DiB7000P: SPLIT ffff880139055000: 176
Oct 12 13:02:29 fixe_barcelone kernel: [228614.790742] DiB7000P: using default timf
Oct 12 13:02:29 fixe_barcelone kernel: [228615.090748] DiB7000P: updated timf_frequency: 20452445 (default: 20452225)
Oct 12 13:02:29 fixe_barcelone kernel: [228615.090756] DiB7000P: relative position of the Spur: 2000k (RF: 514000k, XTAL: 12000k)
Oct 12 13:02:29 fixe_barcelone kernel: [228615.091871] DiB7000P: PALF COEF: 0 re: 25 im: 124
Oct 12 13:02:29 fixe_barcelone kernel: [228615.095246] DiB7000P: PALF COEF: 1 re: -103 im: 43
Oct 12 13:02:29 fixe_barcelone kernel: [228615.098618] DiB7000P: PALF COEF: 2 re: -52 im: -79
Oct 12 13:02:29 fixe_barcelone kernel: [228615.101995] DiB7000P: PALF COEF: 3 re: 54 im: -53
Oct 12 13:02:29 fixe_barcelone kernel: [228615.105368] DiB7000P: PALF COEF: 4 re: 45 im: 30
Oct 12 13:02:29 fixe_barcelone kernel: [228615.108745] DiB7000P: PALF COEF: 5 re: -11 im: 28
Oct 12 13:02:29 fixe_barcelone kernel: [228615.112995] DiB7000P: PALF COEF: 6 re: -5 im: 0
Oct 12 13:02:29 fixe_barcelone kernel: [228615.116373] DiB7000P: PALF COEF: 7 re: 0 im: 19
Oct 12 13:02:29 fixe_barcelone kernel: [228615.120871] DiB7000P: using updated timf
Oct 12 13:02:29 fixe_barcelone kernel: [228615.124493] DiB7000P: setting output mode for demod ffff880139055000 to 5
Oct 12 13:02:29 fixe_barcelone kernel: [228615.129290] function : dvb_dmxdev_filter_set
Oct 12 13:02:29 fixe_barcelone kernel: [228615.129514] function : dvb_dmxdev_filter_set


--------------040801050702000704040005
Content-Type: text/plain;
 name="scan_dvbapi5.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scan_dvbapi5.txt"

Oct 12 13:01:55 fixe_barcelone kernel: [228581.408427] DiB7000P: setting output mode for demod ffff880139055000 to 0
Oct 12 13:01:55 fixe_barcelone kernel: [228581.420136] DiB0070: Tuning for Band: 2 (514000 kHz)
Oct 12 13:01:55 fixe_barcelone kernel: [228581.452538] DiB0070: HFDIV code: 5
Oct 12 13:01:55 fixe_barcelone kernel: [228581.452544] DiB0070: VCO = 1
Oct 12 13:01:55 fixe_barcelone kernel: [228581.452547] DiB0070: VCOF in kHz: 6168000 ((6*514000) << 1))
Oct 12 13:01:55 fixe_barcelone kernel: [228581.452552] DiB0070: REFDIV: 1, FREF: 12000
Oct 12 13:01:55 fixe_barcelone kernel: [228581.452595] DiB0070: FBDIV: 85, Rest: 43520
Oct 12 13:01:55 fixe_barcelone kernel: [228581.452598] DiB0070: Num: -22016, Den: 255, SD: 1
Oct 12 13:01:55 fixe_barcelone kernel: [228581.513539] DiB0070: CAPTRIM=64; ADC = 876 (ADC) & 1539mV
Oct 12 13:01:55 fixe_barcelone kernel: [228581.513547] DiB0070: CAPTRIM=64 is closer to target (476/3000)
Oct 12 13:01:55 fixe_barcelone kernel: [228581.533539] DiB0070: CAPTRIM=32; ADC = 34 (ADC) & 59mV
Oct 12 13:01:55 fixe_barcelone kernel: [228581.533545] DiB0070: CAPTRIM=32 is closer to target (366/476)
Oct 12 13:01:55 fixe_barcelone kernel: [228581.553667] DiB0070: CAPTRIM=48; ADC = 34 (ADC) & 59mV
Oct 12 13:01:55 fixe_barcelone kernel: [228581.573540] DiB0070: CAPTRIM=56; ADC = 139 (ADC) & 244mV
Oct 12 13:01:55 fixe_barcelone kernel: [228581.573547] DiB0070: CAPTRIM=56 is closer to target (261/366)
Oct 12 13:01:55 fixe_barcelone kernel: [228581.593541] DiB0070: CAPTRIM=60; ADC = 282 (ADC) & 495mV
Oct 12 13:01:55 fixe_barcelone kernel: [228581.593548] DiB0070: CAPTRIM=60 is closer to target (118/261)
Oct 12 13:01:55 fixe_barcelone kernel: [228581.613543] DiB0070: CAPTRIM=62; ADC = 413 (ADC) & 725mV
Oct 12 13:01:55 fixe_barcelone kernel: [228581.613550] DiB0070: CAPTRIM=62 is closer to target (13/118)
Oct 12 13:01:55 fixe_barcelone kernel: [228581.633542] DiB0070: CAPTRIM=61; ADC = 338 (ADC) & 594mV
Oct 12 13:01:56 fixe_barcelone kernel: [228581.688424] DiB7000P: WBD: ref: 1058, sel: 1, active: 1, alpha: 1
Oct 12 13:01:56 fixe_barcelone kernel: [228581.778420] DiB7000P: SPLIT ffff880139055000: 166
Oct 12 13:01:56 fixe_barcelone kernel: [228581.810017] DiB7000P: using default timf
Oct 12 13:01:56 fixe_barcelone kernel: [228582.130784] DiB7000P: relative position of the Spur: 2000k (RF: 514000k, XTAL: 12000k)
Oct 12 13:01:56 fixe_barcelone kernel: [228582.138635] DiB7000P: PALF COEF: 0 re: 25 im: 124
Oct 12 13:01:56 fixe_barcelone kernel: [228582.160035] DiB7000P: PALF COEF: 1 re: -103 im: 43
Oct 12 13:01:56 fixe_barcelone kernel: [228582.163459] DiB7000P: PALF COEF: 2 re: -52 im: -79
Oct 12 13:01:56 fixe_barcelone kernel: [228582.172306] DiB7000P: PALF COEF: 3 re: 54 im: -53
Oct 12 13:01:56 fixe_barcelone kernel: [228582.175733] DiB7000P: PALF COEF: 4 re: 45 im: 30
Oct 12 13:01:56 fixe_barcelone kernel: [228582.191187] DiB7000P: PALF COEF: 5 re: -11 im: 28
Oct 12 13:01:56 fixe_barcelone kernel: [228582.194625] DiB7000P: PALF COEF: 6 re: -5 im: 0
Oct 12 13:01:56 fixe_barcelone kernel: [228582.220038] DiB7000P: PALF COEF: 7 re: 0 im: 19
Oct 12 13:01:56 fixe_barcelone kernel: [228582.229129] DiB7000P: using default timf
Oct 12 13:01:56 fixe_barcelone kernel: [228582.232943] DiB7000P: setting output mode for demod ffff880139055000 to 5
Oct 12 13:01:57 fixe_barcelone kernel: [228583.232833] DiB7000P: setting output mode for demod ffff880139055000 to 0


--------------040801050702000704040005--
