Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5.freeserve.com ([193.252.22.128]:16687 "EHLO
	smtp5.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0FCXgD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jun 2010 19:36:03 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf3417.me.freeserve.com (SMTP Server) with ESMTP id B4E6F1C02B8C
	for <linux-media@vger.kernel.org>; Fri,  4 Jun 2010 01:35:56 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf3417.me.freeserve.com (SMTP Server) with ESMTP id 9F6611C02B92
	for <linux-media@vger.kernel.org>; Fri,  4 Jun 2010 01:35:56 +0200 (CEST)
Received: from wwinf3713 (wwinf3713 [10.232.27.57])
	by mwinf3417.me.freeserve.com (SMTP Server) with ESMTP id 705371C02B8C
	for <linux-media@vger.kernel.org>; Fri,  4 Jun 2010 01:35:56 +0200 (CEST)
From: john ryan <member@royschdun.freeserve.co.uk>
Reply-To: john ryan <member@royschdun.freeserve.co.uk>
To: linux-media@vger.kernel.org
Message-ID: <30472449.234361275608156425.JavaMail.www@wwinf3713>
Subject: FW: DVB-T af9015 "K world" device problem, only gets channels from
 one multiplex
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Fri,  4 Jun 2010 01:35:56 +0200 (CEST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




========================================
Message Received: Jun 02 2010, 11:01 AM
From: "john ryan" 
To: linux-media@vger.kernel.org
Cc: 
Subject: DVB-T af9015 ("K world) device problem, only gets channels from one multiplex

Hi,
I'm running:
System uname: Linux-2.6.32-gentoo-r7-x86_64-Quad-Core_AMD_Opteron-tm-_Processor_1352-with-gentoo-1.12.13 

I have a "K World" DVB-T USB device.

When I run W-scan, all frequencies are scanned, but it only picks up individual stations on one multiplex. At the end of the scan it tries to tune in the other multiplexes but cannot.

I am reasonably sure the problem is not with W-scan, but I am unsure what has gone wrong or what I can change to fix it - I am a Linux n00bie !

This is a dump of W-scan log

w_scan version 20100529 (compiled for DVB API 5.0)
GB atsc1 dvb2 frontend2
using settings for UNITED KINGDOM
DVB aerial
DVB-T GB
frontend_type DVB-T, channellist 6
output format vdr-1.6
Info: using DVB adapter auto detection.
/dev/dvb/adapter0/frontend0 -> DVB-T "Afatech AF9013 DVB-T": good :-)
Using DVB-T frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_ 
Using DVB API 3.2
frontend Afatech AF9013 DVB-T supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
FEC_AUTO


-----------------snip---------------------------


base_offset=-1, channel=133, step=8000000
channellist=6, base_offset=-1, channel=133, step=8000000
tune to: QAM_16 f = 578166 kHz I999B8C34D0T2G32Y0 
(time: 06:37) set_frontend: using DVB API 3.2
>>> tuning status == 0x03
>>> tuning status == 0x1f
PAT
===================== parse_pat ========================================
len = 94
0x00: 00 00 E0 10 64 40 E3 E9 64 80 E3 EA 64 C0 E3 EB : d@ d d 
0x10: 65 40 E3 ED 6B 00 E3 F7 6B 40 E3 F8 6B 80 E3 F9 : e@ k k@ k 
0x20: 6B C0 E3 FA 6C 00 E4 08 6C 40 E4 09 6C 80 E4 0A : k l l@ l 
0x30: 6C C0 E4 0B 6D 00 E4 0C 6D 80 E4 0D 69 80 E4 07 : l m m i 
0x40: 68 40 E4 05 68 00 E4 04 67 C0 E4 03 66 C0 E3 FF : h@ h g f 
0x50: 66 80 E3 FE 66 40 E3 FD 67 00 E4 00 6A 00 : f f@ g j 
========================================================================
PMT 0x03f8 for service 0x6b40
===================== parse_pmt ========================================
len = 47
0x00: FF FF F0 00 0B E8 9E F0 28 52 01 65 66 0D 01 06 : (R ef 
0x10: 01 01 00 07 01 05 01 01 6F FF FF 13 05 00 00 00 : o 
0x20: 01 00 14 0D 00 65 00 00 08 FF FF FF FF FF FF : e 
========================================================================
DSM-CC U-N Messages : PID 0x089e
PMT 0x0403 for service 0x67c0
===================== parse_pmt ========================================
len = 61
0x00: E6 A5 F0 00 04 E6 A5 F0 09 52 01 01 0A 04 65 6E : R en
0x10: 67 00 0B E6 A6 F0 28 52 01 65 66 0D 01 06 01 01 : g (R ef 
0x20: 00 07 01 05 01 01 6F FF FF 13 05 00 00 00 01 00 : o 
0x30: 14 0D 00 65 00 00 08 FF FF FF FF FF FF : e 
========================================================================
AUDIO : PID 0x06a5
DSM-CC U-N Messages : PID 0x06a6
PMT 0x03e9 for service 0x6440
===================== parse_pmt ========================================
len = 65
0x00: E0 65 F0 00 02 E0 65 F0 03 52 01 01 04 E0 66 F0 : e e R f 
0x10: 09 52 01 02 0A 04 65 6E 67 00 0B E0 69 F0 12 52 : R eng i R
0x20: 01 6E 13 05 00 00 00 01 00 66 06 01 06 01 01 00 : n f 
0x30: 00 06 E0 67 F0 0D 52 01 03 59 08 65 6E 67 10 00 : g R Y eng 
0x40: 02 : 
========================================================================
VIDEO : PID 0x0065
AUDIO : PID 0x0066
DSM-CC U-N Messages : PID 0x0069
SUBTITLING: PID 0x0067
PMT 0x0400 for service 0x6700
===================== parse_pmt ========================================
len = 61
0x00: E5 79 F0 00 04 E5 79 F0 09 52 01 01 0A 04 65 6E : y y R en
0x10: 67 00 0B E5 7A F0 28 52 01 65 66 0D 01 06 01 01 : g z (R ef 
0x20: 00 07 01 05 01 01 6F FF FF 13 05 00 00 00 01 00 : o 
0x30: 14 0D 00 65 00 00 08 FF FF FF FF FF FF : e 
========================================================================
AUDIO : PID 0x0579
DSM-CC U-N Messages : PID 0x057a
PMT 0x040a for service 0x6c80
===================== parse_pmt ========================================
len = 47
0x00: FF FF F0 00 0B E9 16 F0 28 52 01 65 66 0D 01 06 : (R ef 
0x10: 01 01 00 07 01 05 01 01 6F FF FF 13 05 00 00 00 : o 
0x20: 01 00 14 0D 00 65 00 00 08 FF FF FF FF FF FF : e 
========================================================================
DSM-CC U-N Messages : PID 0x0916
PMT 0x03fd for service 0x6640
===================== parse_pmt ========================================
len = 61
0x00: E4 4D F0 00 04 E4 4D F0 09 52 01 01 0A 04 65 6E : M M R en
0x10: 67 00 0B E4 4E F0 28 52 01 65 66 0D 01 06 01 01 : g N (R ef 
0x20: 00 07 01 05 01 01 6F FF FF 13 05 00 00 00 01 00 : o 
0x30: 14 0D 00 65 00 00 08 FF FF FF FF FF FF : e 
========================================================================
AUDIO : PID 0x044d
DSM-CC U-N Messages : PID 0x044e
PMT 0x03ea for service 0x6480
===================== parse_pmt ========================================
len = 42
0x00: E0 C9 F0 00 02 E0 C9 F0 03 52 01 01 04 E0 CA F0 : R 
0x10: 09 52 01 02 0A 04 65 6E 67 00 06 E0 CB F0 0D 52 : R eng R
0x20: 01 03 59 08 65 6E 67 10 00 02 : Y eng 
========================================================================
VIDEO : PID 0x00c9
AUDIO : PID 0x00ca
SUBTITLING: PID 0x00cb
PMT 0x03fa for service 0x6bc0
===================== parse_pmt ========================================
len = 47
0x00: FF FF F0 00 0B E8 44 F0 28 52 01 65 66 0D 01 06 : D (R ef 
0x10: 01 01 00 07 01 05 01 01 6F FF FF 13 05 00 00 00 : o 
0x20: 01 00 14 0D 00 65 00 00 08 FF FF FF FF FF FF : e 
========================================================================
DSM-CC U-N Messages : PID 0x0844
PMT 0x0405 for service 0x6840
===================== parse_pmt ========================================
len = 61
0x00: E7 6D F0 00 04 E7 6D F0 09 52 01 01 0A 04 65 6E : m m R en
0x10: 67 00 0B E7 6E F0 28 52 01 65 66 0D 01 06 01 01 : g n (R ef 
0x20: 00 07 01 05 01 01 6F FF FF 13 05 00 00 00 01 00 : o 
0x30: 14 0D 00 65 00 00 08 FF FF FF FF FF FF : e 
========================================================================
AUDIO : PID 0x076d
DSM-CC U-N Messages : PID 0x076e
PMT 0x03f7 for service 0x6b00
===================== parse_pmt ========================================
len = 56
0x00: E8 35 F0 00 02 E8 35 F0 03 52 01 01 04 E8 36 F0 : 5 5 R 6 
0x10: 09 52 01 02 0A 04 65 6E 67 00 06 E8 37 F0 0D 52 : R eng 7 R
0x20: 01 03 59 08 65 6E 67 10 00 02 00 02 04 E8 38 F0 : Y eng 8 
0x30: 09 52 01 04 0A 04 65 6E : R en
========================================================================
VIDEO : PID 0x0835
AUDIO : PID 0x0836
SUBTITLING: PID 0x0837
AUDIO : PID 0x0838
PMT 0x03eb for service 0x64c0
===================== parse_pmt ========================================
len = 56
0x00: E1 2D F0 00 02 E1 2D F0 03 52 01 01 04 E1 2E F0 : - - R . 
0x10: 09 52 01 02 0A 04 65 6E 67 00 04 E1 30 F0 09 52 : R eng 0 R
0x20: 01 04 0A 04 65 6E 67 03 06 E1 2F F0 0D 52 01 03 : eng / R 
0x30: 59 08 65 6E 67 10 00 02 : Y eng 
========================================================================
VIDEO : PID 0x012d
AUDIO : PID 0x012e
AUDIO : PID 0x0130
SUBTITLING: PID 0x012f
PMT 0x03ff for service 0x66c0
===================== parse_pmt ========================================
len = 61
0x00: E5 15 F0 00 04 E5 15 F0 09 52 01 01 0A 04 65 6E : R en
0x10: 67 00 0B E5 16 F0 28 52 01 65 66 0D 01 06 01 01 : g (R ef 
0x20: 00 07 01 05 01 01 6F FF FF 13 05 00 00 00 01 00 : o 
0x30: 14 0D 00 65 00 00 08 FF FF FF FF FF FF : e 
========================================================================
AUDIO : PID 0x0515
DSM-CC U-N Messages : PID 0x0516
PMT 0x0407 for service 0x6980
===================== parse_pmt ========================================
len = 74
0x00: FF FF F0 00 0B EF AA F0 12 52 01 65 66 06 01 06 : R ef 
0x10: 01 01 00 00 13 05 00 00 00 01 00 0B EF AB F0 0A : 
0x20: 52 01 66 13 05 00 00 00 02 00 0B EF AC F0 0E 52 : R f R
0x30: 01 78 66 02 01 11 13 05 00 00 00 13 00 0B EF AD : xf 
0x40: F0 0A 52 01 27 13 05 00 00 00 : R ' 
========================================================================
DSM-CC U-N Messages : PID 0x0faa
DSM-CC U-N Messages : PID 0x0fab
DSM-CC U-N Messages : PID 0x0fac
DSM-CC U-N Messages : PID 0x0fad
PMT 0x0409 for service 0x6c40
===================== parse_pmt ========================================
len = 47
0x00: FF FF F0 00 0B E9 0C F0 28 52 01 65 66 0D 01 06 : (R ef 
0x10: 01 01 00 07 01 05 01 01 6F FF FF 13 05 00 00 00 : o 
0x20: 01 00 14 0D 00 65 00 00 08 FF FF FF FF FF FF : e 
========================================================================
DSM-CC U-N Messages : PID 0x090c
PMT 0x03f9 for service 0x6b80
===================== parse_pmt ========================================
len = 47
0x00: FF FF F0 00 0B E2 04 F0 28 52 01 65 66 0D 01 06 : (R ef 
0x10: 01 01 00 07 01 05 01 01 6F FF FF 13 05 00 00 00 : o 
0x20: 01 00 14 0D 00 65 00 00 08 FF FF FF FF FF FF : e 
========================================================================
DSM-CC U-N Messages : PID 0x0204
PMT 0x03ed for service 0x6540
===================== parse_pmt ========================================
len = 24
0x00: E1 F5 F0 00 02 E1 F5 F0 03 52 01 01 04 E1 F6 F0 : R 
0x10: 09 52 01 02 0A 04 65 6E : R en
========================================================================
VIDEO : PID 0x01f5
AUDIO : PID 0x01f6
PMT 0x0404 for service 0x6800
===================== parse_pmt ========================================
len = 61
0x00: E7 09 F0 00 04 E7 09 F0 09 52 01 01 0A 04 65 6E : R en
0x10: 67 00 0B E7 0A F0 28 52 01 65 66 0D 01 06 01 01 : g (R ef 
0x20: 00 07 01 05 01 01 6F FF FF 13 05 00 00 00 01 00 : o 
0x30: 14 0D 00 65 00 00 08 FF FF FF FF FF FF : e 
========================================================================
AUDIO : PID 0x0709
DSM-CC U-N Messages : PID 0x070a
PMT 0x040d for service 0x6d80
===================== parse_pmt ========================================
len = 56
0x00: E2 59 F0 00 02 E2 59 F0 03 52 01 01 04 E2 5A F0 : Y Y R Z 
0x10: 09 52 01 02 0A 04 65 6E 67 00 04 E2 5C F0 09 52 : R eng \ R
0x20: 01 03 0A 04 65 6E 67 03 06 E2 5B F0 0D 52 01 07 : eng [ R 
0x30: 59 08 65 6E 67 10 00 02 : Y eng 
========================================================================
VIDEO : PID 0x0259
AUDIO : PID 0x025a
AUDIO : PID 0x025c
SUBTITLING: PID 0x025b
PMT 0x040b for service 0x6cc0
===================== parse_pmt ========================================
len = 47
0x00: FF FF F0 00 0B E9 20 F0 28 52 01 65 66 0D 01 06 : (R ef 
0x10: 01 01 00 07 01 05 01 01 6F FF FF 13 05 00 00 00 : o 
0x20: 01 00 14 0D 00 65 00 00 08 FF FF FF FF FF FF : e 
========================================================================
DSM-CC U-N Messages : PID 0x0920
PMT 0x03fe for service 0x6680
===================== parse_pmt ========================================
len = 61
0x00: E4 B1 F0 00 04 E4 B1 F0 09 52 01 01 0A 04 65 6E : R en
0x10: 67 00 0B E4 B2 F0 28 52 01 65 66 0D 01 06 01 01 : g (R ef 
0x20: 00 07 01 05 01 01 6F FF FF 13 05 00 00 00 01 00 : o 
0x30: 14 0D 00 65 00 00 08 FF FF FF FF FF FF : e 
========================================================================
AUDIO : PID 0x04b1
DSM-CC U-N Messages : PID 0x04b2
PMT 0x0408 for service 0x6c00
===================== parse_pmt ========================================
len = 47
0x00: FF FF F0 00 0B E9 02 F0 28 52 01 65 66 0D 01 06 : (R ef 
0x10: 01 01 00 07 01 05 01 01 6F FF FF 13 05 00 00 00 : o 
0x20: 01 00 14 0D 00 65 00 00 08 FF FF FF FF FF FF : e 
========================================================================
DSM-CC U-N Messages : PID 0x0902
PMT 0x03f0 for service 0x6a00
===================== parse_pmt ========================================
len = 56
0x00: E2 BD F0 00 02 E2 BD F0 03 52 01 01 04 E2 BE F0 : R 
0x10: 09 52 01 02 0A 04 65 6E 67 00 04 E2 C0 F0 09 52 : R eng R
0x20: 01 04 0A 04 65 6E 67 03 06 E2 BF F0 0D 52 01 03 : eng R 
0x30: 59 08 65 6E 67 10 00 02 : Y eng 
========================================================================
VIDEO : PID 0x02bd
AUDIO : PID 0x02be
AUDIO : PID 0x02c0
SUBTITLING: PID 0x02bf
PMT 0x040c for service 0x6d00
===================== parse_pmt ========================================
len = 50
0x00: E9 25 F0 00 02 E9 25 F0 03 52 01 0B 04 E9 26 F0 : % % R & 
0x10: 0C 52 01 0C 0A 04 65 6E 67 00 03 01 67 0B E9 29 : R eng g )
0x20: F0 12 52 01 07 13 05 00 00 00 02 00 66 06 01 06 : R f 
0x30: 01 01 : 
========================================================================
VIDEO : PID 0x0925
AUDIO : PID 0x0926
DSM-CC U-N Messages : PID 0x0929
SDT (actual TS)
===================== parse_sdt ========================================
len = 670
0x00: 23 3A FF 64 40 FF 80 13 48 09 01 00 06 34 4D 75 : #: d@ H 4Mu
0x10: 73 69 63 73 06 62 64 73 2E 74 76 64 80 FF 80 1B : sics bds.tvd 
0x20: 48 11 01 0A 4D 54 56 20 45 75 72 6F 70 65 04 56 : H MTV Europe V
0x30: 49 56 41 73 06 62 64 73 2E 74 76 64 C0 FF 80 1A : IVAs bds.tvd 
0x40: 48 10 01 04 55 4B 54 56 09 59 65 73 74 65 72 64 : H UKTV Yesterd
0x50: 61 79 73 06 62 64 73 2E 74 76 65 40 FF 80 18 48 : ays bds.tve@ H
0x60: 0E 01 00 0B 49 64 65 61 6C 20 57 6F 72 6C 64 73 : Ideal Worlds
0x70: 06 62 64 73 2E 74 76 66 40 FF 80 11 48 07 02 00 : bds.tvf@ H 
0x80: 04 4B 69 73 73 73 06 62 64 73 2E 74 76 66 C0 FF : Kisss bds.tvf 
0x90: 80 15 48 0B 02 00 08 4B 65 72 72 61 6E 67 21 73 : H Kerrang!s
0xA0: 06 62 64 73 2E 74 76 67 00 FF 80 1C 48 12 02 03 : bds.tvg H 
0xB0: 47 4D 47 0C 53 4D 4F 4F 54 48 20 52 41 44 49 4F : GMG SMOOTH RADIO
0xC0: 73 06 62 64 73 2E 74 76 67 C0 FF 80 1B 48 11 02 : s bds.tvg H 
0xD0: 00 0E 54 68 65 20 48 69 74 73 20 52 61 64 69 6F : The Hits Radio
0xE0: 73 06 62 64 73 2E 74 76 68 00 FF 80 12 48 08 02 : s bds.tvh H 
0xF0: 00 05 4D 61 67 69 63 73 06 62 64 73 2E 74 76 68 : Magics bds.tvh
0x100: 40 FF 80 0E 48 04 02 00 01 51 73 06 62 64 73 2E : @ H Qs bds.
0x110: 74 76 69 80 FC 30 1A 48 18 0C 07 34 54 56 20 4C : tvi 0 H 4TV L
0x120: 74 64 0E 34 54 56 69 6E 74 65 72 61 63 74 69 76 : td 4TVinteractiv
0x130: 65 6A 00 FF 80 28 48 14 01 0C 43 68 61 6E 6E 65 : ej (H Channe
0x140: 6C 20 34 20 54 56 05 46 69 6C 6D 34 73 10 77 77 : l 4 TV Film4s ww
0x150: 77 2E 63 68 61 6E 6E 65 6C 34 2E 63 6F 6D 66 80 : w.channel4.comf 
0x160: FF 80 11 48 07 02 00 04 68 65 61 74 73 06 62 64 : H heats bd
0x170: 73 2E 74 76 6B 00 FF 80 1B 48 11 01 04 55 4B 54 : s.tvk H UKT
0x180: 56 0A 44 61 76 65 20 6A 61 20 76 75 73 06 62 64 : V Dave ja vus bd
0x190: 73 2E 74 76 6B 40 FF 80 1F 48 1D 01 0E 49 6E 66 : s.tvk@ H Inf
0x1A0: 6F 72 6D 61 74 69 6F 6E 20 54 56 0C 52 75 73 73 : ormation TV Russ
0x1B0: 69 61 20 54 6F 64 61 79 6B 80 FF 80 0E 48 0C 01 : ia Todayk H 
0x1C0: 00 09 73 6D 69 6C 65 20 54 56 32 6C 80 FF 80 2C : smile TV2l ,
0x1D0: 48 2A 01 19 49 64 65 61 6C 20 53 68 6F 70 70 69 : H* Ideal Shoppi
0x1E0: 6E 67 20 44 69 72 65 63 74 20 50 6C 63 0E 43 72 : ng Direct Plc Cr
0x1F0: 65 61 74 65 20 26 20 43 72 61 66 74 6C 00 FF 80 : eate & Craftl 
0x200: 0D 48 0B 01 00 08 42 69 67 20 44 65 61 6C 6D 00 : H Big Dealm 
0x210: FF 80 1C 48 1A 01 0C 47 61 6D 65 20 4E 65 74 77 : H Game Netw
0x220: 6F 72 6B 0B 42 61 62 65 73 74 61 74 69 6F 6E 6C : ork Babestationl
0x230: 40 FF 80 0C 48 0A 01 00 07 54 56 20 4E 65 77 73 : @ H TV News
0x240: 6D 80 FF 80 19 48 0A 01 03 49 54 56 04 49 54 56 : m H ITV ITV
0x250: 34 73 0B 77 77 77 2E 69 74 76 2E 63 6F 6D 6C C0 : 4s www.itv.coml 
0x260: FF 80 18 48 16 01 09 4E 45 54 50 4C 41 59 54 56 : H NETPLAYTV
0x270: 0A 52 6F 63 6B 73 20 26 20 43 6F 6B C0 FF 80 20 : Rocks & Cok 
0x280: 48 1E 01 0F 47 61 6D 65 20 4E 65 74 77 6F 72 6B : H Game Network
0x290: 20 42 56 0C 42 61 62 65 73 74 61 74 69 6F : BV Babestatio
========================================================================
===================== parse_service_descriptor =========================
len = 9
0x00: 01 00 06 34 4D 75 73 69 63 : 4Music
========================================================================
service = 4Music ((null))
===================== parse_service_descriptor =========================
len = 17
0x00: 01 0A 4D 54 56 20 45 75 72 6F 70 65 04 56 49 56 : MTV Europe VIV
0x10: 41 : A
========================================================================
service = VIVA (MTV Europe)
===================== parse_service_descriptor =========================
len = 16
0x00: 01 04 55 4B 54 56 09 59 65 73 74 65 72 64 61 79 : UKTV Yesterday
========================================================================
service = Yesterday (UKTV)
===================== parse_service_descriptor =========================
len = 14
0x00: 01 00 0B 49 64 65 61 6C 20 57 6F 72 6C 64 : Ideal World
========================================================================
service = Ideal World ((null))
===================== parse_service_descriptor =========================
len = 7
0x00: 02 00 04 4B 69 73 73 : Kiss
========================================================================
service = Kiss ((null))
===================== parse_service_descriptor =========================
len = 11
0x00: 02 00 08 4B 65 72 72 61 6E 67 21 : Kerrang!
========================================================================
service = Kerrang! ((null))
===================== parse_service_descriptor =========================
len = 18
0x00: 02 03 47 4D 47 0C 53 4D 4F 4F 54 48 20 52 41 44 : GMG SMOOTH RAD
0x10: 49 4F : IO
========================================================================
service = SMOOTH RADIO (GMG)
===================== parse_service_descriptor =========================
len = 17
0x00: 02 00 0E 54 68 65 20 48 69 74 73 20 52 61 64 69 : The Hits Radi
0x10: 6F : o
========================================================================
service = The Hits Radio ((null))
===================== parse_service_descriptor =========================
len = 8
0x00: 02 00 05 4D 61 67 69 63 : Magic
========================================================================
service = Magic ((null))
===================== parse_service_descriptor =========================
len = 4
0x00: 02 00 01 51 : Q
========================================================================
service = Q ((null))
===================== parse_service_descriptor =========================
len = 24
0x00: 0C 07 34 54 56 20 4C 74 64 0E 34 54 56 69 6E 74 : 4TV Ltd 4TVint
0x10: 65 72 61 63 74 69 76 65 : eractive
========================================================================
service = 4TVinteractive (4TV Ltd)
===================== parse_service_descriptor =========================
len = 20
0x00: 01 0C 43 68 61 6E 6E 65 6C 20 34 20 54 56 05 46 : Channel 4 TV F
0x10: 69 6C 6D 34 : ilm4
========================================================================
service = Film4 (Channel 4 TV)
===================== parse_service_descriptor =========================
len = 7
0x00: 02 00 04 68 65 61 74 : heat
========================================================================
service = heat ((null))
===================== parse_service_descriptor =========================
len = 17
0x00: 01 04 55 4B 54 56 0A 44 61 76 65 20 6A 61 20 76 : UKTV Dave ja v
0x10: 75 : u
========================================================================
service = Dave ja vu (UKTV)
===================== parse_service_descriptor =========================
len = 29
0x00: 01 0E 49 6E 66 6F 72 6D 61 74 69 6F 6E 20 54 56 : Information TV
0x10: 0C 52 75 73 73 69 61 20 54 6F 64 61 79 : Russia Today
========================================================================
service = Russia Today (Information TV)
===================== parse_service_descriptor =========================
len = 12
0x00: 01 00 09 73 6D 69 6C 65 20 54 56 32 : smile TV2
========================================================================
service = smile TV2 ((null))
===================== parse_service_descriptor =========================
len = 42
0x00: 01 19 49 64 65 61 6C 20 53 68 6F 70 70 69 6E 67 : Ideal Shopping
0x10: 20 44 69 72 65 63 74 20 50 6C 63 0E 43 72 65 61 : Direct Plc Crea
0x20: 74 65 20 26 20 43 72 61 66 74 : te & Craft
========================================================================
service = Create & Craft (Ideal Shopping Direct Plc)
===================== parse_service_descriptor =========================
len = 11
0x00: 01 00 08 42 69 67 20 44 65 61 6C : Big Deal
========================================================================
service = Big Deal ((null))
===================== parse_service_descriptor =========================
len = 26
0x00: 01 0C 47 61 6D 65 20 4E 65 74 77 6F 72 6B 0B 42 : Game Network B
0x10: 61 62 65 73 74 61 74 69 6F 6E : abestation
========================================================================
service = Babestation (Game Network)
===================== parse_service_descriptor =========================
len = 10
0x00: 01 00 07 54 56 20 4E 65 77 73 : TV News
========================================================================
service = TV News ((null))
===================== parse_service_descriptor =========================
len = 10
0x00: 01 03 49 54 56 04 49 54 56 34 : ITV ITV4
========================================================================
service = ITV4 (ITV)
===================== parse_service_descriptor =========================
len = 22
0x00: 01 09 4E 45 54 50 4C 41 59 54 56 0A 52 6F 63 6B : NETPLAYTV Rock
0x10: 73 20 26 20 43 6F : s & Co
========================================================================
service = Rocks & Co (NETPLAYTV)
===================== parse_service_descriptor =========================
len = 30
0x00: 01 0F 47 61 6D 65 20 4E 65 74 77 6F 72 6B 20 42 : Game Network B
0x10: 56 0C 42 61 62 65 73 74 61 74 69 6F 6E 32 : V Babestation2
========================================================================
service = Babestation2 (Game Network BV)
NIT (actual TS)
===================== parse_nit ========================================
len = 210
0x00: F0 00 F0 D0 60 01 23 3A F0 CA 41 45 64 40 01 64 : ` #: AEd@ d
0x10: 80 01 64 C0 01 65 40 01 66 40 02 66 C0 02 67 00 : d e@ f@ f g 
0x20: 02 67 C0 02 68 00 02 68 40 02 69 80 0C 6A 00 01 : g h h@ i j 
0x30: 66 80 02 6B 00 01 6B 40 01 6B 80 01 6C 80 01 6C : f k k@ k l l
0x40: 00 01 6D 00 01 6C 40 01 6D 80 01 6C C0 01 6B C0 : m l@ m l k 
0x50: 01 5A 0B 03 72 36 5B 1F 42 41 FF FF FF FF 62 09 : Z r6[ BA b 
0x60: FF 03 66 01 5B 04 D4 37 5B 7F 05 09 47 42 52 F8 : f [ 7[ GBR 
0x70: 5F 04 00 00 23 3A 83 5C 6A 00 FC 0F 67 C0 FE C7 : _ #: \j g 
0x80: 6B C0 FC 63 68 00 FE CB 66 40 FE C9 6B 00 FC 19 : k ch f@ k 
0x90: 6C 40 FC 59 6B 40 FC 55 64 80 FC 15 65 40 FC 16 : l@ Yk@ Ud e@ 
0xA0: 67 00 FE CE 6B 80 FC 5E 66 80 FE CA 64 40 FC 12 : g k ^f d@ 
0xB0: 66 C0 FE D2 6C 00 FC 20 6D 00 FC 60 6C C0 FC 28 : f l m `l (
0xC0: 6D 80 FC 18 6C 80 FC 24 69 80 FD 2C 64 C0 FC 0C : m l $i ,d 
0xD0: 68 40 : h@
========================================================================
===================== parse_terrestrial_delivery_system_descriptor =====
len = 11
0x00: 03 72 36 5B 1F 42 41 FF FF FF FF : r6[ BA 
========================================================================
===================== parse_frequency_list_descriptor ==================
len = 9
0x00: FF 03 66 01 5B 04 D4 37 5B : f [ 7[
========================================================================
NIT (actual TS)
===================== parse_nit ========================================
len = 995
0x00: F1 05 40 11 4E 6F 72 74 68 65 72 6E 20 49 72 65 : @ Northern Ire
0x10: 6C 61 6E 64 2E 7F 19 0A 47 42 52 65 6E 67 50 4E : land. GBRengPN
0x20: 6F 72 74 68 65 72 6E 20 49 72 65 6C 61 6E 64 04 : orthern Ireland 
0x30: 7F 06 09 47 42 52 F9 04 4A 0C 40 00 23 3A 4C 00 : GBR J @ #:L 
0x40: 09 04 00 01 5A 00 4A 0C 10 3D 23 3A 11 7D 09 04 : Z J =#: } 
0x50: 00 01 5A 00 7F 14 07 30 01 10 01 01 DB E5 00 00 : Z 0 
0x60: 00 11 59 59 10 01 40 00 23 3A 7F 9B 08 01 65 6E : YY @ #: en
0x70: 67 4E 65 74 77 6F 72 6B 20 63 68 61 6E 67 65 20 : gNetwork change 
0x80: 6E 6F 74 69 66 69 63 61 74 69 6F 6E 3B 20 65 6E : notification; en
0x90: 68 61 6E 63 65 64 20 6E 65 74 77 6F 72 6B 20 63 : hanced network c
0xA0: 6F 6E 66 69 67 75 72 61 74 69 6F 6E 3B 20 56 65 : onfiguration; Ve
0xB0: 72 73 69 6F 6E 20 32 2E 30 20 20 20 20 20 20 4E : rsion 2.0 N
0xC0: 65 74 77 6F 72 6B 20 63 68 61 6E 67 65 20 6E 6F : etwork change no
0xD0: 74 69 66 69 63 61 74 69 6F 6E 3B 20 65 6E 68 61 : tification; enha
0xE0: 6E 63 65 64 20 6E 65 74 77 6F 72 6B 20 63 6F 6E : nced network con
0xF0: 66 69 67 75 72 61 74 69 6F 6E 3B 20 56 65 72 73 : figuration; Vers
0x100: 69 6F 6E 20 32 2E 30 F2 DC 10 3D 23 3A F0 5A 41 : ion 2.0 =#: ZA
0x110: 18 10 7D 01 10 BD 01 11 3D 01 11 7D 01 12 3D 01 : } = } = 
0x120: 18 BD 02 18 FD 02 10 FD 01 5A 0B 03 34 EC 40 1F : Z 4 @ 
0x130: 42 41 FF FF FF FF 62 09 FF 03 41 62 5B 05 04 CA : BA b Ab[ 
0x140: 40 5F 04 00 00 23 3A 83 20 10 7D FC 01 10 FD FC : @_ #: } 
0x150: 07 18 BD FE CF 11 7D FC 69 10 BD FC 02 12 3D FC : } i = 
0x160: 46 11 3D FC 50 18 FD FE D0 20 14 23 3A F0 7D 41 : F = P #: }A
0x170: 27 20 54 01 20 C0 01 21 00 01 21 75 0C 21 B6 0C : ' T ! !u ! 
0x180: 20 FA 01 22 42 02 20 85 01 21 04 01 21 80 0C 21 : "B ! ! !
0x190: 81 0C 20 E9 01 21 34 01 5A 0B 03 65 7F 25 1F 81 : !4 Z e % 
0x1A0: 01 FF FF FF FF 62 09 FF 03 72 36 5B 04 96 AC 25 : b r6[ %
0x1B0: 5F 04 00 00 23 3A 83 34 20 54 FC 03 20 E9 FC 1B : _ #: 4 T 
0x1C0: 21 81 FC 6B 21 04 FC 0D 21 34 FC 05 20 85 FC 06 : ! k! !4 
0x1D0: 21 B6 FC 66 22 42 FE D6 20 FA FC 0E 21 80 FC 6A : ! f"B ! j
0x1E0: 20 C0 FC 04 21 75 FC 64 21 00 FC 1C 30 04 23 3A : !u d! 0 #:
0x1F0: F0 CA 41 45 33 40 01 39 00 02 39 C0 0C 3A 80 01 : AE3@ 9 9 : 
0x200: 3B 80 01 3C C0 01 3D C0 01 37 C0 01 3F 60 01 3F : ; < = 7 ?` ?
0x210: 80 01 3F A0 01 32 C0 01 32 80 01 3E E0 01 3E A0 : ? 2 2 > > 
0x220: 01 39 E0 0C 38 A2 01 38 20 01 37 E0 01 3A 20 0C : 9 8 8 7 : 
0x230: 3E B0 01 3B A0 01 3D 20 01 5A 0B 02 EB 6D 25 1F : > ; = Z m% 
0x240: 81 01 FF FF FF FF 62 09 FF 02 EB EF 5B 04 59 E4 : b [ Y 
0x250: 40 7F 05 09 47 42 52 F8 5F 04 00 00 23 3A 83 5C : @ GBR _ #: \
0x260: 32 C0 FC 1F 37 C0 FC 17 3F 60 FD 33 38 20 FC 61 : 2 7 ?` 38 a
0x270: 3C C0 FC 11 3A 20 FC 6D 3B 80 FC 5D 39 C0 FC 65 : < : m; ]9 e
0x280: 3F A0 FD 35 38 A2 FC 26 32 80 FC 1E 3A 80 FC 1A : ? 58 &2 : 
0x290: 3E B0 FC 0A 3B A0 FC 62 3E E0 FC 22 33 40 FC 10 : > ; b> "3@ 
0x2A0: 39 00 FE C8 39 E0 FC 68 3E A0 FC 48 3D C0 FC 58 : 9 9 h> H= X
0x2B0: 37 E0 FC 14 3D 20 FC 54 3F 80 FD 34 40 00 23 3A : 7 = T? 4@ #:
0x2C0: F0 99 41 33 41 C0 01 42 40 01 42 80 01 46 80 02 : A3A B@ B F 
0x2D0: 46 C0 02 47 40 02 47 80 02 4C 00 01 4C 80 01 4E : F G@ G L L N
0x2E0: 00 01 47 00 02 46 40 02 46 00 02 49 00 02 48 C0 : G F@ F I H 
0x2F0: 02 48 80 02 48 40 02 5A 0B 03 10 0C 25 1F 42 41 : H H@ Z % BA
0x300: FF FF FF FF 62 09 FF 03 10 8E 5B 04 8A 77 25 5F : b [ w%_
0x310: 04 00 00 23 3A 83 44 48 C0 FE BF 4C 80 FD 2F 4E : #: DH L /N
0x320: 00 FC 57 42 40 FC 47 46 80 FE C3 42 80 FC 51 46 : WB@ GF B QF
0x330: 00 FE C1 41 C0 FC 09 4C 00 FD 2D 47 00 FE BD 47 : A L -G G
0x340: 40 FE C5 47 80 FE C6 48 80 FE BE 46 40 FE C2 49 : @ G H F@ I
0x350: 00 FE C0 46 C0 FE C4 48 40 FE BC 50 01 23 3A F0 : F H@ P #: 
0x360: 84 41 27 57 40 01 56 80 01 58 40 02 5C 80 0C 57 : A'W@ V X@ \ W
0x370: 00 01 59 C0 02 5A 40 02 56 40 01 56 C0 01 5C C0 : Y Z@ V@ V \ 
0x380: 0C 57 C0 01 57 80 01 5D 40 01 5A 0B 04 1C DB 40 : W W ]@ Z @
0x390: 1F 42 41 FF FF FF FF 62 09 FF 03 35 2D 5B 04 AF : BA b 5-[ 
0x3A0: 98 5B 7F 05 09 47 42 52 F8 5F 04 00 00 23 3A 83 : [ GBR _ #: 
0x3B0: 34 57 80 FC 5F 5A 40 FE D7 56 80 FC 53 57 00 FC : 4W _Z@ V SW 
0x3C0: 13 58 40 FE D3 56 C0 FC 0B 57 40 FC 1D 57 C0 FC : X@ V W@ W 
0x3D0: 25 59 C0 FE D5 5D 40 FC 5A 56 40 FC 52 5C C0 FD : %Y ]@ ZV@ R\ 
0x3E0: 32 5C 80 : 2\ 
========================================================================
===================== parse_terrestrial_delivery_system_descriptor =====
len = 11
0x00: 03 34 EC 40 1F 42 41 FF FF FF FF : 4 @ BA 
========================================================================
===================== parse_frequency_list_descriptor ==================
len = 9
0x00: FF 03 41 62 5B 05 04 CA 40 : Ab[ @
========================================================================
===================== parse_terrestrial_delivery_system_descriptor =====
len = 11
0x00: 03 65 7F 25 1F 81 01 FF FF FF FF : e % 
========================================================================
===================== parse_frequency_list_descriptor ==================
len = 9
0x00: FF 03 72 36 5B 04 96 AC 25 : r6[ %
========================================================================
===================== parse_terrestrial_delivery_system_descriptor =====
len = 11
0x00: 02 EB 6D 25 1F 81 01 FF FF FF FF : m% 
========================================================================
===================== parse_frequency_list_descriptor ==================
len = 9
0x00: FF 02 EB EF 5B 04 59 E4 40 : [ Y @
========================================================================
===================== parse_terrestrial_delivery_system_descriptor =====
len = 11
0x00: 03 10 0C 25 1F 42 41 FF FF FF FF : % BA 
========================================================================
===================== parse_frequency_list_descriptor ==================
len = 9
0x00: FF 03 10 8E 5B 04 8A 77 25 : [ w%
========================================================================
===================== parse_terrestrial_delivery_system_descriptor =====
len = 11
0x00: 04 1C DB 40 1F 42 41 FF FF FF FF : @ BA 
========================================================================
===================== parse_frequency_list_descriptor ==================
len = 9
0x00: FF 03 35 2D 5B 04 AF 98 5B : 5-[ [
========================================================================
Info: NIT(other) filter timeout
tune to: QAM_16 f = 538000 kHz I999B8C34D0T2G32Y0 
(time: 06:51) set_frontend: using DVB API 3.2
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
----------no signal----------
tune to: QAM_16 f = 538000 kHz I999B8C34D0T2G32Y0 (no signal)
(time: 06:52) set_frontend: using DVB API 3.2
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
----------no signal----------
tune to: QAM_64 f = 569833 kHz I999B8C23D0T2G32Y0 
(time: 06:53) set_frontend: using DVB API 3.2
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
----------no signal----------
tune to: QAM_64 f = 569833 kHz I999B8C23D0T2G32Y0 (no signal)
(time: 06:54) set_frontend: using DVB API 3.2
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
----------no signal----------
tune to: QAM_64 f = 489833 kHz I999B8C23D0T2G32Y0 
(time: 06:55) set_frontend: using DVB API 3.2
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
----------no signal----------
tune to: QAM_64 f = 489833 kHz I999B8C23D0T2G32Y0 (no signal)
(time: 06:56) set_frontend: using DVB API 3.2
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
----------no signal----------
tune to: QAM_16 f = 513833 kHz I999B8C34D0T2G32Y0 
(time: 06:57) set_frontend: using DVB API 3.2
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
----------no signal----------
tune to: QAM_16 f = 513833 kHz I999B8C34D0T2G32Y0 (no signal)
(time: 06:58) set_frontend: using DVB API 3.2
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
----------no signal----------
tune to: QAM_16 f = 690000 kHz I999B8C34D0T2G32Y0 
(time: 06:59) set_frontend: using DVB API 3.2
>>> tuning status == 0x03
>>> tuning status == 0x07
>>> tuning status == 0x07
>>> tuning status == 0x03
>>> tuning status == 0x03
----------no signal----------
tune to: QAM_16 f = 690000 kHz I999B8C34D0T2G32Y0 (no signal)
(time: 07:00) set_frontend: using DVB API 3.2
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
>>> tuning status == 0x03
----------no signal----------
dumping lists (23 services)
Done.
4Music;(null):578166:I999B8C34D0M16T2G32Y0:T:27500:101:102=eng:0:0:25664:9018:24577:0
VIVA;MTV Europe:578166:I999B8C34D0M16T2G32Y0:T:27500:201:202=eng:0:0:25728:9018:24577:0
Yesterday;UKTV:578166:I999B8C34D0M16T2G32Y0:T:27500:301:302=eng,304=eng:0:0:25792:9018:24577:0
Ideal World;(null):578166:I999B8C34D0M16T2G32Y0:T:27500:501:502=eng:0:0:25920:9018:24577:0
Dave ja vu;UKTV:578166:I999B8C34D0M16T2G32Y0:T:27500:2101:2102=eng,2104=eng:0:0:27392:9018:24577:0
Babestation;Game Network:578166:I999B8C34D0M16T2G32Y0:T:27500:2341:2342=eng:0:0:27904:9018:24577:0
ITV4;ITV:578166:I999B8C34D0M16T2G32Y0:T:27500:601:602=eng,604=eng:0:0:28032:9018:24577:0
Q;(null):578166:I999B8C34D0M16T2G32Y0:T:27500:0:1901=eng:0:0:26688:9018:24577:0
Magic;(null):578166:I999B8C34D0M16T2G32Y0:T:27500:0:1801=eng:0:0:26624:9018:24577:0
The Hits Radio;(null):578166:I999B8C34D0M16T2G32Y0:T:27500:0:1701=eng:0:0:26560:9018:24577:0
Kerrang!;(null):578166:I999B8C34D0M16T2G32Y0:T:27500:0:1301=eng:0:0:26304:9018:24577:0
heat;(null):578166:I999B8C34D0M16T2G32Y0:T:27500:0:1201=eng:0:0:26240:9018:24577:0
Kiss;(null):578166:I999B8C34D0M16T2G32Y0:T:27500:0:1101=eng:0:0:26176:9018:24577:0
SMOOTH RADIO;GMG:578166:I999B8C34D0M16T2G32Y0:T:27500:0:1401=eng:0:0:26368:9018:24577:0
Film4;Channel 4 TV:578166:I999B8C34D0M16T2G32Y0:T:27500:701:702=eng,704=eng:0:0:27136:9018:24577:0


