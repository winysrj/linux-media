Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.integra.fr ([217.115.161.167]:35804 "EHLO mta2.integra.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbZBKQrv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2009 11:47:51 -0500
Received: from zcs.integra.fr (unknown [194.145.56.139])
	by mta2.integra.fr (Postfix) with ESMTP id CD226244271
	for <linux-media@vger.kernel.org>; Wed, 11 Feb 2009 17:47:40 +0100 (CET)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zcs.integra.fr (Postfix) with ESMTP id 6D3D0678433
	for <linux-media@vger.kernel.org>; Wed, 11 Feb 2009 17:47:44 +0100 (CET)
Received: from zcs.integra.fr ([127.0.0.1])
	by localhost (zcs.integra.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HS2Eu-poO6Xn for <linux-media@vger.kernel.org>;
	Wed, 11 Feb 2009 17:47:40 +0100 (CET)
Received: from [192.168.0.204] (actimag014716-2.clients.easynet.fr [212.11.28.50])
	by zcs.integra.fr (Postfix) with ESMTP id DA78C678428
	for <linux-media@vger.kernel.org>; Wed, 11 Feb 2009 17:47:39 +0100 (CET)
Message-ID: <4993012E.5060407@gmail.com>
Date: Wed, 11 Feb 2009 17:47:42 +0100
From: Pierre Gronlier <ticapix@gmail.com>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: tt3200 and lnb switch
References: <gmev1k$r9b$1@ger.gmane.org>
In-Reply-To: <gmev1k$r9b$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pierre Gronlier wrote:
> Hello,
> 
> I'm using the v4l-dvb driver from this http://linuxtv.org/hg/v4l-dvb
> mercurial repository for my two cards, a Hauppauge hvr4000 and
> TechnoTrend 3200
> 
> I have one dish with two lnb heads.
> 
> I can, with the hvr4000, scan, lock and stream transponders of both
> astra19.2e and hotbird13.0e
> 
> I can, with the tt3200, scan, lock and stream descrambled transponders
> of astra19.2e (using a powercam 2.0.3)
> 
> I can, with the tt3200, scan transponders of hotbird13.0e
> 
> I can't, with the tt3200, lock transponders of hotbird13.0e
> 

maybe it's comming from the lnb2p1 driver.

The TechniSat SkyStar HD and  Azurewave AD SP400 CI (VP-1041) have the
same driver.

Does someone with a TechniSat SkyStar HD or Azurewave AD SP400 CI
(VP-1041) and a dual lnb head manage to lock on the second head ?


-- 
pierre


> As a test, I'm running this few commands:
> 
> $> cat hotbird # my transpondeur list
> S 12597000 V 27500000 3/4
> 
> $> scan -vvv -a 0 -s 1 hotbird # scanning the transponder
> scanning hotbird
> 
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> 
> initial transponder 12597000 V 27500000 3
> 
>>>> tune to: 12597:v:1:27500
> 
> DiSEqC: switch pos 1, 13V, hiband (index 6)
> 
> DiSEqC: e0 10 38 f5 00 00
> 
> DVB-S IF freq is 1997000
> 
>>>> tuning status == 0x1e
> 
> parse_section:1172: pid 0x10 tid 0x40 table_id_ext 0x013e, 0/0 (version
> 2)
> NIT (actual TS)
> 
> Network Name 'Globecast'
> 
> parse_nit:869: transport_stream_id 0x24b8
> 
> parse_satellite_delivery_system_descriptor:444: 0x13e/0x24b8
> 12596:v:1:27500
> is_same_transponder:211: f1 = 12597000 is same TP as f2 = 12596560
> 
> parse_section:1172: pid 0x00 tid 0x00 table_id_ext 0x24b8, 0/0 (version
> 8)
> PAT
> 
> parse_section:1172: pid 0x41e tid 0x02 table_id_ext 0x2026, 0/0 (version
> 1)
> PMT 0x041e for service 0x2026
> 
>   AUDIO     : PID 0x0854
> 
> parse_pmt:833: 0x24b8 0x2026: (null) -- (null), pmt_pid 0x041e, vpid
> 0x0000, apid 0x0854 ()
> parse_section:1172: pid 0x419 tid 0x02 table_id_ext 0x2021, 0/0 (version
> 1)
> PMT 0x0419 for service 0x2021
> 
>   AUDIO     : PID 0x084a
> 
> parse_pmt:833: 0x24b8 0x2021: (null) -- (null), pmt_pid 0x0419, vpid
> 0x0000, apid 0x084a ()
> parse_section:1172: pid 0x416 tid 0x02 table_id_ext 0x201e, 0/0 (version
> 1)
> PMT 0x0416 for service 0x201e
> 
>   AUDIO     : PID 0x0843
> 
> parse_pmt:833: 0x24b8 0x201e: (null) -- (null), pmt_pid 0x0416, vpid
> 0x0000, apid 0x0843 ()
> parse_section:1172: pid 0x413 tid 0x02 table_id_ext 0x201b, 0/0 (version
> 3)
> PMT 0x0413 for service 0x201b
> 
>   AUDIO     : PID 0x087d
> 
> parse_pmt:833: 0x24b8 0x201b: (null) -- (null), pmt_pid 0x0413, vpid
> 0x0000, apid 0x087d ()
> parse_section:1172: pid 0x412 tid 0x02 table_id_ext 0x201a, 0/0 (version
> 1)
> PMT 0x0412 for service 0x201a
> 
>   AUDIO     : PID 0x083b
> 
> parse_pmt:833: 0x24b8 0x201a: (null) -- (null), pmt_pid 0x0412, vpid
> 0x0000, apid 0x083b ()
> parse_section:1172: pid 0x411 tid 0x02 table_id_ext 0x2019, 0/0 (version
> 1)
> PMT 0x0411 for service 0x2019
> 
>   AUDIO     : PID 0x0839
> 
> parse_pmt:833: 0x24b8 0x2019: (null) -- (null), pmt_pid 0x0411, vpid
> 0x0000, apid 0x0839 ()
> parse_section:1172: pid 0x410 tid 0x02 table_id_ext 0x2018, 0/0 (version
> 1)
> PMT 0x0410 for service 0x2018
> 
>   AUDIO     : PID 0x0837
> 
> parse_pmt:833: 0x24b8 0x2018: (null) -- (null), pmt_pid 0x0410, vpid
> 0x0000, apid 0x0837 ()
> parse_section:1172: pid 0x40f tid 0x02 table_id_ext 0x2017, 0/0 (version
> 1)
> PMT 0x040f for service 0x2017
> 
>   AUDIO     : PID 0x0835
> 
> parse_pmt:833: 0x24b8 0x2017: (null) -- (null), pmt_pid 0x040f, vpid
> 0x0000, apid 0x0835 ()
> parse_section:1172: pid 0x407 tid 0x02 table_id_ext 0x2010, 0/0 (version
> 1)
> PMT 0x0407 for service 0x2010
> 
>   AUDIO     : PID 0x006c
> 
>   VIDEO     : PID 0x00a7
> 
> parse_pmt:833: 0x24b8 0x2010: (null) -- (null), pmt_pid 0x0407, vpid
> 0x00a7, apid 0x006c ()
> parse_section:1172: pid 0x20 tid 0x02 table_id_ext 0x200d, 0/0 (version
> 1)
> PMT 0x0020 for service 0x200d
> 
>   AUDIO     : PID 0x005d
> 
> parse_pmt:833: 0x24b8 0x200d: (null) -- (null), pmt_pid 0x0020, vpid
> 0x0000, apid 0x005d ()
> parse_section:1172: pid 0x403 tid 0x02 table_id_ext 0x200c, 0/0 (version
> 4)
> PMT 0x0403 for service 0x200c
> 
>   TELETEXT  : PID 0x0029
> 
>   AUDIO     : PID 0x005c
> 
>   VIDEO     : PID 0x00a3
> 
> parse_pmt:833: 0x24b8 0x200c: (null) -- (null), pmt_pid 0x0403, vpid
> 0x00a3, apid 0x005c ()
> parse_section:1172: pid 0x402 tid 0x02 table_id_ext 0x200b, 0/0 (version
> 1)
> PMT 0x0402 for service 0x200b
> 
> parse_pmt:833: 0x24b8 0x200b: (null) -- (null), pmt_pid 0x0402, vpid
> 0x0000, apid 0x0000 ()
> parse_section:1172: pid 0x401 tid 0x02 table_id_ext 0x200a, 0/0 (version
> 1)
> PMT 0x0401 for service 0x200a
> 
>   AUDIO     : PID 0x0054
> 
>   VIDEO     : PID 0x00a1
> 
> parse_pmt:833: 0x24b8 0x200a: (null) -- (null), pmt_pid 0x0401, vpid
> 0x00a1, apid 0x0054 ()
> parse_section:1172: pid 0x400 tid 0x02 table_id_ext 0x2009, 0/0 (version
> 1)
> PMT 0x0400 for service 0x2009
> 
>   VIDEO     : PID 0x0050
> 
>   AUDIO     : PID 0x0051
> 
> parse_pmt:833: 0x24b8 0x2009: (null) -- (null), pmt_pid 0x0400, vpid
> 0x0050, apid 0x0051 ()
> parse_section:1172: pid 0xbe5 tid 0x02 table_id_ext 0x2035, 0/0 (version
> 1)
> PMT 0x0be5 for service 0x2035
> 
>   AUDIO     : PID 0x07fd
> 
> parse_pmt:833: 0x24b8 0x2035: (null) -- (null), pmt_pid 0x0be5, vpid
> 0x0000, apid 0x07fd ()
> parse_section:1172: pid 0xbe3 tid 0x02 table_id_ext 0x2033, 0/0 (version
> 1)
> PMT 0x0be3 for service 0x2033
> 
>   AUDIO     : PID 0x07fb
> 
> parse_pmt:833: 0x24b8 0x2033: (null) -- (null), pmt_pid 0x0be3, vpid
> 0x0000, apid 0x07fb ()
> parse_section:1172: pid 0xbe0 tid 0x02 table_id_ext 0x2030, 0/0 (version
> 1)
> PMT 0x0be0 for service 0x2030
> 
>   AUDIO     : PID 0x07f7
> 
> parse_pmt:833: 0x24b8 0x2030: (null) -- (null), pmt_pid 0x0be0, vpid
> 0x0000, apid 0x07f7 ()
> parse_section:1172: pid 0xbdf tid 0x02 table_id_ext 0x202f, 0/0 (version
> 7)
> PMT 0x0bdf for service 0x202f
> 
>   AUDIO     : PID 0x07f5
> 
> parse_pmt:833: 0x24b8 0x202f: (null) -- (null), pmt_pid 0x0bdf, vpid
> 0x0000, apid 0x07f5 ()
> parse_section:1172: pid 0xbde tid 0x02 table_id_ext 0x202e, 0/0 (version
> 1)
> PMT 0x0bde for service 0x202e
> 
>   AUDIO     : PID 0x07f3
> 
> parse_pmt:833: 0x24b8 0x202e: (null) -- (null), pmt_pid 0x0bde, vpid
> 0x0000, apid 0x07f3 ()
> parse_section:1172: pid 0xbdc tid 0x02 table_id_ext 0x202c, 0/0 (version
> 1)
> PMT 0x0bdc for service 0x202c
> 
>   AUDIO     : PID 0x07ef
> 
> parse_pmt:833: 0x24b8 0x202c: (null) -- (null), pmt_pid 0x0bdc, vpid
> 0x0000, apid 0x07ef ()
> parse_section:1172: pid 0xbd9 tid 0x02 table_id_ext 0x2029, 0/0 (version
> 1)
> PMT 0x0bd9 for service 0x2029
> 
>   AUDIO     : PID 0x07e9
> 
> parse_pmt:833: 0x24b8 0x2029: (null) -- (null), pmt_pid 0x0bd9, vpid
> 0x0000, apid 0x07e9 ()
> parse_section:1172: pid 0xbd7 tid 0x02 table_id_ext 0x2027, 0/0 (version
> 1)
> PMT 0x0bd7 for service 0x2027
> 
>   AUDIO     : PID 0x07e5
> 
> parse_pmt:833: 0x24b8 0x2027: (null) -- (null), pmt_pid 0x0bd7, vpid
> 0x0000, apid 0x07e5 ()
> parse_section:1172: pid 0x41d tid 0x02 table_id_ext 0x2025, 0/0 (version
> 3)
> PMT 0x041d for service 0x2025
> 
>   AUDIO     : PID 0x0852
> 
> parse_pmt:833: 0x24b8 0x2025: (null) -- (null), pmt_pid 0x041d, vpid
> 0x0000, apid 0x0852 ()
> parse_section:1172: pid 0x41c tid 0x02 table_id_ext 0x2024, 0/0 (version
> 1)
> PMT 0x041c for service 0x2024
> 
>   AUDIO     : PID 0x0850
> 
> parse_pmt:833: 0x24b8 0x2024: (null) -- (null), pmt_pid 0x041c, vpid
> 0x0000, apid 0x0850 ()
> parse_section:1172: pid 0x41b tid 0x02 table_id_ext 0x2023, 0/0 (version
> 1)
> PMT 0x041b for service 0x2023
> 
>   AUDIO     : PID 0x084e
> 
> parse_pmt:833: 0x24b8 0x2023: (null) -- (null), pmt_pid 0x041b, vpid
> 0x0000, apid 0x084e ()
> parse_section:1172: pid 0x41a tid 0x02 table_id_ext 0x2022, 0/0 (version
> 1)
> PMT 0x041a for service 0x2022
> 
>   AUDIO     : PID 0x084c
> 
> parse_pmt:833: 0x24b8 0x2022: (null) -- (null), pmt_pid 0x041a, vpid
> 0x0000, apid 0x084c ()
> parse_section:1172: pid 0x418 tid 0x02 table_id_ext 0x2020, 0/0 (version
> 1)
> PMT 0x0418 for service 0x2020
> 
>   AUDIO     : PID 0x0848
> 
> parse_pmt:833: 0x24b8 0x2020: (null) -- (null), pmt_pid 0x0418, vpid
> 0x0000, apid 0x0848 ()
> parse_section:1172: pid 0x417 tid 0x02 table_id_ext 0x201f, 0/0 (version
> 1)
> PMT 0x0417 for service 0x201f
> 
>   AUDIO     : PID 0x0846
> 
> parse_pmt:833: 0x24b8 0x201f: (null) -- (null), pmt_pid 0x0417, vpid
> 0x0000, apid 0x0846 ()
> parse_section:1172: pid 0x415 tid 0x02 table_id_ext 0x201d, 0/0 (version
> 1)
> PMT 0x0415 for service 0x201d
> 
>   AUDIO     : PID 0x0841
> 
> parse_pmt:833: 0x24b8 0x201d: (null) -- (null), pmt_pid 0x0415, vpid
> 0x0000, apid 0x0841 ()
> parse_section:1172: pid 0x414 tid 0x02 table_id_ext 0x201c, 0/0 (version
> 1)
> PMT 0x0414 for service 0x201c
> 
>   AUDIO     : PID 0x083f
> 
> parse_pmt:833: 0x24b8 0x201c: (null) -- (null), pmt_pid 0x0414, vpid
> 0x0000, apid 0x083f ()
> parse_section:1172: pid 0x40a tid 0x02 table_id_ext 0x2013, 0/0 (version
> 1)
> PMT 0x040a for service 0x2013
> 
>   TELETEXT  : PID 0x0300
> 
>   VIDEO     : PID 0x08ad
> 
>   AUDIO     : PID 0x08b7
> 
> parse_iso639_language_descriptor:312:     LANG=fra 1
> 
>   AUDIO     : PID 0x08b8
> 
> parse_iso639_language_descriptor:312:     LANG=eng 1
> 
>   AUDIO     : PID 0x08b9
> 
> parse_iso639_language_descriptor:312:     LANG=deu 1
> 
>   AUDIO     : PID 0x08ba
> 
> parse_iso639_language_descriptor:312:     LANG=ita 1
> 
>   AUDIO     : PID 0x08bb
> 
> parse_iso639_language_descriptor:312:     LANG=spa 1
> 
>   AUDIO     : PID 0x08bc
> 
> parse_iso639_language_descriptor:312:     LANG=por 1
> 
>   AUDIO     : PID 0x08bd
> 
> parse_iso639_language_descriptor:312:     LANG=rus 1
> 
>   AUDIO     : PID 0x08be
> 
> parse_iso639_language_descriptor:312:     LANG=ara 1
> 
>   AUDIO     : PID 0x08bf
> 
> parse_pmt:833: 0x24b8 0x2013: (null) -- (null), pmt_pid 0x040a, vpid
> 0x08ad, apid 0x08b7 (fra), 0x08b8 (eng), 0x08b9 (deu), 0x08ba (ita),
> 0x08bb (spa), 0x08bc (por), 0x08bd (rus), 0x08be (ara), 0x08bf ()
> 
> parse_section:1172: pid 0x408 tid 0x02 table_id_ext 0x2011, 0/0 (version
> 27)
> PMT 0x0408 for service 0x2011
> 
>   AUDIO     : PID 0x0070
> 
>   AUDIO     : PID 0x0071
> 
>   OTHER     : PID 0x0072 TYPE 0xc1
> 
>   OTHER     : PID 0x0073 TYPE 0xc0
> 
>   VIDEO     : PID 0x00a8
> 
> parse_pmt:833: 0x24b8 0x2011: (null) -- (null), pmt_pid 0x0408, vpid
> 0x00a8, apid 0x0070 (), 0x0071 ()
> parse_section:1172: pid 0x11 tid 0x42 table_id_ext 0x24b8, 0/1 (version
> 22)
> SDT (actual TS)
> 
> 0x24b8 0x2009: pmt_pid 0x0400 Globecast -- Planeta Sport (running)
> 
> 0x24b8 0x200a: pmt_pid 0x0401 Globecast -- ARM_1 (running)
> 
> 0x24b8 0x200b: pmt_pid 0x0402 Globecast -- BET (running)
> 
> 0x24b8 0x200c: pmt_pid 0x0403 Globecast UK -- BBC World News (running)
> 
> 0x24b8 0x200d: pmt_pid 0x0020 Harmonic -- RD1_Radio_ARMENIA (running)
> 
> 0x24b8 0x2010: pmt_pid 0x0407 Globecast -- 1TVRUS Europe (running)
> 
> 0x24b8 0x2011: pmt_pid 0x0408 Globecast -- CNNi (running, scrambled)
> 
> 0x24b8 0x2013: pmt_pid 0x040a Globecast -- Euronews (running)
> 
> 0x24b8 0x2015: pmt_pid 0x040d Globecast -- JSTV1 (running)
> 
> 0x24b8 0x2016: pmt_pid 0x040e Globecast -- JSTV2 (running)
> 
> 0x24b8 0x2017: pmt_pid 0x040f Globecast -- WRN Russkij (running)
> 
> 0x24b8 0x2018: pmt_pid 0x0410 Globecast -- WRN English (running)
> 
> 0x24b8 0x2019: pmt_pid 0x0411 Globecast -- WRN Deutsch (running)
> 
> 0x24b8 0x201a: pmt_pid 0x0412 Globecast -- WRN Francais (running)
> 
> 0x24b8 0x201b: pmt_pid 0x0413 Globecast -- GBTS2 (running)
> 
> 0x24b8 0x201c: pmt_pid 0x0414 Globecast -- RCI 3 (running)
> 
> 0x24b8 0x201d: pmt_pid 0x0415 Globecast -- Family Europe (running)
> 
> 0x24b8 0x201e: pmt_pid 0x0416 Globecast -- RCI 2 (running)
> 
> 0x24b8 0x201f: pmt_pid 0x0417 Globecast -- RCI 1 (running)
> 
> 0x24b8 0x2020: pmt_pid 0x0418 Globecast -- RTE (running)
> 
> 0x24b8 0x2021: pmt_pid 0x0419 Globecast -- IBC TAMIL RADIO (running)
> 
> 0x24b8 0x2022: pmt_pid 0x041a Globecast -- Sedayelran (running)
> 
> 0x24b8 0x2023: pmt_pid 0x041b Globecast -- PRA Radio (running)
> 
> 0x24b8 0x2024: pmt_pid 0x041c Globecast -- The Voice (running)
> 
> 0x24b8 0x2025: pmt_pid 0x041d Globecast -- GBTS1 (running)
> 
> 0x24b8 0x2026: pmt_pid 0x041e Globecast -- WRN Special (running)
> 
> 0x24b8 0x2027: pmt_pid 0x0bd7 Globecast -- Radio New Hope (running)
> 
> 0x24b8 0x2028: pmt_pid 0x0bd8 Globecast -- PEC 3 RRI 3 (running)
> 
> 0x24b8 0x2029: pmt_pid 0x0bd9 Globecast -- Family Int 1 (running)
> 
> 0x24b8 0x202a: pmt_pid 0x0bda Globecast -- Family Int 2 (running)
> 
> 0x24b8 0x202c: pmt_pid 0x0bdc Globecast -- AWR Radio 128Kbit (running)
> 
> 0x24b8 0x202d: pmt_pid 0x0bdd Globecast -- YLESAT 1 (running)
> 
> 0x24b8 0x202e: pmt_pid 0x0bde Globecast -- YLESAT 2 (running)
> 
> 0x24b8 0x202f: pmt_pid 0x0bdf Globecast -- GBTS3 (running)
> 
> 0x24b8 0x2030: pmt_pid 0x0be0 Globecast -- WRN Sawt Al Alam (running)
> 
> parse_section:1172: pid 0x11 tid 0x42 table_id_ext 0x24b8, 1/1 (version
> 22)
> SDT (actual TS)
> 
> 0x24b8 0x2031: pmt_pid 0x0be1 Globecast -- WRN Events (running)
> 
> 0x24b8 0x2032: pmt_pid 0x0be2 Globecast -- GBTS4 (running)
> 
> 0x24b8 0x2033: pmt_pid 0x0be3 Globecast -- GBTS5 (running)
> 
> 0x24b8 0x2034: pmt_pid 0x0be4 Globecast -- GBTS6 (running)
> 
> 0x24b8 0x2035: pmt_pid 0x0be5 Globecast -- GBTS7 (running)
> 
> 0x24b8 0x2064: pmt_pid 0x0405 Globecast -- Quadriga (running)
> 
> parse_section:1172: pid 0x40d tid 0x02 table_id_ext 0x2015, 0/0 (version
> 27)
> PMT 0x040d for service 0x2015
> 
>   VIDEO     : PID 0x07d0
> 
>   AUDIO     : PID 0x07d1
> 
> parse_iso639_language_descriptor:312:     LANG=jpn 1
> 
>   AUDIO     : PID 0x07d2
> 
> parse_iso639_language_descriptor:312:     LANG=eng 1
> 
>   AUDIO     : PID 0x07d3
> 
> parse_iso639_language_descriptor:312:     LANG=nat 1
> 
>   AUDIO     : PID 0x07d4
> 
> parse_iso639_language_descriptor:312:     LANG=dut 1
> 
> parse_pmt:833: 0x24b8 0x2015: Globecast -- JSTV1, pmt_pid 0x040d, vpid
> 0x07d0, apid 0x07d1 (jpn), 0x07d2 (eng), 0x07d3 (nat), 0x07d4 (dut)
> 
> 
> parse_section:1172: pid 0xbe2 tid 0x02 table_id_ext 0x2032, 0/0 (version
> 1)
> PMT 0x0be2 for service 0x2032
> 
>   AUDIO     : PID 0x07fa
> 
> parse_pmt:833: 0x24b8 0x2032: Globecast -- GBTS4, pmt_pid 0x0be2, vpid
> 0x0000, apid 0x07fa ()
> parse_section:1172: pid 0xbdd tid 0x02 table_id_ext 0x202d, 0/0 (version
> 1)
> PMT 0x0bdd for service 0x202d
> 
>   AUDIO     : PID 0x07f1
> 
> parse_pmt:833: 0x24b8 0x202d: Globecast -- YLESAT 1, pmt_pid 0x0bdd,
> vpid 0x0000, apid 0x07f1 ()
> parse_section:1172: pid 0x405 tid 0x02 table_id_ext 0x2064, 0/0 (version
> 5)
> PMT 0x0405 for service 0x2064
> 
>   OTHER     : PID 0x138a TYPE 0x0d
> 
> parse_pmt:833: 0x24b8 0x2064: Globecast -- Quadriga, pmt_pid 0x0405,
> vpid 0x0000, apid 0x0000 ()
> parse_section:1172: pid 0xbe4 tid 0x02 table_id_ext 0x2034, 0/0 (version
> 1)
> PMT 0x0be4 for service 0x2034
> 
>   AUDIO     : PID 0x07fc
> 
> parse_pmt:833: 0x24b8 0x2034: Globecast -- GBTS6, pmt_pid 0x0be4, vpid
> 0x0000, apid 0x07fc ()
> parse_section:1172: pid 0xbe1 tid 0x02 table_id_ext 0x2031, 0/0 (version
> 3)
> PMT 0x0be1 for service 0x2031
> 
>   AUDIO     : PID 0x07f9
> 
> parse_pmt:833: 0x24b8 0x2031: Globecast -- WRN Events, pmt_pid 0x0be1,
> vpid 0x0000, apid 0x07f9 ()
> parse_section:1172: pid 0xbda tid 0x02 table_id_ext 0x202a, 0/0 (version
> 1)
> PMT 0x0bda for service 0x202a
> 
>   AUDIO     : PID 0x07eb
> 
> parse_pmt:833: 0x24b8 0x202a: Globecast -- Family Int 2, pmt_pid 0x0bda,
> vpid 0x0000, apid 0x07eb ()
> parse_section:1172: pid 0xbd8 tid 0x02 table_id_ext 0x2028, 0/0 (version
> 1)
> PMT 0x0bd8 for service 0x2028
> 
>   AUDIO     : PID 0x07e7
> 
>   OTHER     : PID 0x07e8 TYPE 0xf1
> 
> parse_pmt:833: 0x24b8 0x2028: Globecast -- PEC 3 RRI 3, pmt_pid 0x0bd8,
> vpid 0x0000, apid 0x07e7 ()
> parse_section:1172: pid 0x40e tid 0x02 table_id_ext 0x2016, 0/0 (version
> 11)
> PMT 0x040e for service 0x2016
> 
>   VIDEO     : PID 0x07db
> 
>   AUDIO     : PID 0x07dc
> 
> parse_iso639_language_descriptor:312:     LANG=jpn 1
> 
>   AUDIO     : PID 0x07dd
> 
> parse_iso639_language_descriptor:312:     LANG=eng 1
> 
> parse_pmt:833: 0x24b8 0x2016: Globecast -- JSTV2, pmt_pid 0x040e, vpid
> 0x07db, apid 0x07dc (jpn), 0x07dd (eng)
> dumping lists (41 services)
> 
> Planeta Sport:12596:v:1:27500:80:81:8201
> 
> ARM_1:12596:v:1:27500:161:84:8202
> 
> BET:12596:v:1:27500:0:0:8203
> 
> BBC World News:12596:v:1:27500:163:92:8204
> 
> RD1_Radio_ARMENIA:12596:v:1:27500:0:93:8205
> 
> 1TVRUS Europe:12596:v:1:27500:167:108:8208
> 
> CNNi:12596:v:1:27500:168:112:8209
> 
> Euronews:12596:v:1:27500:2221:2231:8211
> JSTV1:12596:v:1:27500:2000:2001:8213
> JSTV2:12596:v:1:27500:2011:2012:8214
> WRN Russkij:12596:v:1:27500:0:2101:8215
> WRN English:12596:v:1:27500:0:2103:8216
> WRN Deutsch:12596:v:1:27500:0:2105:8217
> WRN Francais:12596:v:1:27500:0:2107:8218
> GBTS2:12596:v:1:27500:0:2173:8219
> RCI 3:12596:v:1:27500:0:2111:8220
> Family Europe:12596:v:1:27500:0:2113:8221
> RCI 2:12596:v:1:27500:0:2115:8222
> RCI 1:12596:v:1:27500:0:2118:8223
> RTE:12596:v:1:27500:0:2120:8224
> IBC TAMIL RADIO:12596:v:1:27500:0:2122:8225
> Sedayelran:12596:v:1:27500:0:2124:8226
> PRA Radio:12596:v:1:27500:0:2126:8227
> The Voice:12596:v:1:27500:0:2128:8228
> GBTS1:12596:v:1:27500:0:2130:8229
> WRN Special:12596:v:1:27500:0:2132:8230
> Radio New Hope:12596:v:1:27500:0:2021:8231
> PEC 3 RRI 3:12596:v:1:27500:0:2023:8232
> Family Int 1:12596:v:1:27500:0:2025:8233
> Family Int 2:12596:v:1:27500:0:2027:8234
> AWR Radio 128Kbit:12596:v:1:27500:0:2031:8236
> YLESAT 1:12596:v:1:27500:0:2033:8237
> YLESAT 2:12596:v:1:27500:0:2035:8238
> GBTS3:12596:v:1:27500:0:2037:8239
> WRN Sawt Al Alam:12596:v:1:27500:0:2039:8240
> WRN Events:12596:v:1:27500:0:2041:8241
> GBTS4:12596:v:1:27500:0:2042:8242
> GBTS5:12596:v:1:27500:0:2043:8243
> GBTS6:12596:v:1:27500:0:2044:8244
> GBTS7:12596:v:1:27500:0:2045:8245
> Quadriga:12596:v:1:27500:0:0:8292
> Done.
> 
> $> # scan went fine and I'm only interested in Euronews which is a FTA
> channel
> $> echo "Euronews:12596:v:1:27500:2221:2231:8211" > channel.conf
> 
> $> sudo rmmod budget_ci && sleep 1 && sudo modprobe budget_ci # I must
> do this otherwise the tt3200 card is not reponding to ioctl calls
> 
> $> # trying to lock the channel
> $> szap -a 0 -c channel.conf -r -n 1
> reading channels from file 'channel.conf'
> zapping to 1 'Euronews':
> sat_no: 1
> sat 1, frequency = 12596 MHz V, symbolrate 27500000, vpid = 0x08ad, apid
> = 0x08b7 sid = 0x2013
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 00 | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> ...
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> 
> $> # same thing with scan-s2
> $> szap-s2 -a 0 -c channel.conf -r -n 1
> reading channels from file 'channel.conf'
> zapping to 1 'Euronews':
> delivery DVB-S, modulation QPSK
> sat 1, frequency 12596 MHz V, symbolrate 27500000, coderate auto,
> rolloff 0.35
> vpid 0x08ad, apid 0x08b7, sid 0x2013
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> DiSEqC: e0 10 38 f5 00 00
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> ...
> status 00 | signal fffe | snr fffe | ber 00000000 | unc fffffffe |
> $>
> 
> I can't lock channel on the second lnb head with my tt3200
> 
> And with the hvr4000 (which is pluged in the same box as the tt3200), I
> can lock and stream this same EuroNews channel.
> 
> Can someone advise me on what I can do to resolve this issue ?
> 
> Thanks
> 

