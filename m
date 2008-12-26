Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp19.orange.fr ([80.12.242.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kafifi@orange.fr>) id 1LGB4k-0002km-2c
	for linux-dvb@linuxtv.org; Fri, 26 Dec 2008 12:41:56 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf1921.orange.fr (SMTP Server) with ESMTP id 378B61C00099
	for <linux-dvb@linuxtv.org>; Fri, 26 Dec 2008 12:41:20 +0100 (CET)
Received: from pcserver (ASte-Genev-Bois-151-1-79-83.w81-48.abo.wanadoo.fr
	[81.48.108.83])
	by mwinf1921.orange.fr (SMTP Server) with ESMTP id EFE221C00094
	for <linux-dvb@linuxtv.org>; Fri, 26 Dec 2008 12:41:19 +0100 (CET)
Received: from pcserver ([192.168.200.1]) by pcserver (602LAN SUITE 2004) id
	389cea9f for linux-dvb@linuxtv.org; Fri, 26 Dec 2008 12:40:52 +0100
From: "kafifi" <kafifi@orange.fr>
To: <linux-dvb@linuxtv.org>
Date: Fri, 26 Dec 2008 12:40:52 +0100
MIME-Version: 1.0
Message-Id: <20081226114119.EFE221C00094@mwinf1921.orange.fr>
Subject: [linux-dvb] "scan" doesn't tune on all dvb-t  multiplex
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

I've some problem with "scan" utilities, which doesn't find all TNT channels
from Eiffel Tower - Paris.
The multiplex R5 and L8 are missing. My installation is correct, because
when I've tried with a standard 
demudulator, all multiplex and channels were found.

I am using :
- Hauppauge Nova T-500 (under Ubuntu 8.10).
- scan version from
http://linuxtv.org/hg/dvb-apps/file/a3e6e8487082/util/scan/dvb-t/


I don't know if all the "tuning failed" messages are due to a bad
"sources.conf", or something else.
Could you please help me to find what's wrong ?

Thanks a lot.

________________________________________________________________
sources.conf 
	# Paris - France - various DVB-T transmitters
	# contributed by Alexis de Lattre <alexis@via.ecp.fr>
	# Paris - Tour Eiffel      : 21 24 27 29 32 35
	# T freq bw fec_hi fec_lo mod transmission-mode guard-interval
hierarchy
	T 474166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	T 498166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	T 522166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	T 538166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	T 562166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	T 586166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
	T 714166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
	T 738166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	T 754166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	T 762166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	T 786166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	T 810166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

________________________________________________________________
Log
	root@pcsat:/usr/local/src# scan -a 2 -o vdr -p fr-Paris >
channels.conf
	scanning fr-Paris
	using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
	initial transponder 474166000 0 2 9 3 1 0 0
	initial transponder 498166000 0 2 9 3 1 0 0
	initial transponder 522166000 0 2 9 3 1 0 0
	initial transponder 538166000 0 2 9 3 1 0 0
	initial transponder 562166000 0 2 9 3 1 0 0
	initial transponder 586166000 0 3 9 3 1 2 0
	initial transponder 714166000 0 3 9 3 1 2 0
	initial transponder 738166000 0 2 9 3 1 0 0
	initial transponder 754166000 0 2 9 3 1 0 0
	initial transponder 762166000 0 2 9 3 1 0 0
	initial transponder 786166000 0 2 9 3 1 0 0
	initial transponder 810166000 0 2 9 3 1 0 0
	>>> tune to: 474166:I999B8C23D999M64T8G32Y0:T:27500:
	0x0000 0x0201: pmt_pid 0x0500 NTN -- Direct 8 (running)
	0x0000 0x0203: pmt_pid 0x0502 NTN -- BFM TV (running)
	0x0000 0x0204: pmt_pid 0x0503 NTN -- i>TELE (running)
	0x0000 0x0205: pmt_pid 0x0504 NTN -- Virgin 17 (running)
	0x0000 0x0206: pmt_pid 0x0505 NTN -- Gulli (running)
	0x0000 0x0207: pmt_pid 0x0506 NTN -- France 4 (running)
	Network Name 'F'
	>>> tune to: 498166:I999B8C23D999M64T8G32Y0:T:27500:
	Network Name 'F'
	0x0000 0x0406: pmt_pid 0x0000 MULTI4 -- temp (running, scrambled)
	0x0000 0x0407: pmt_pid 0x02c6 Multi 4 -- ARTE HD (running)
	0x0000 0x0404: pmt_pid 0x019a MULTI4 -- PARIS PREMIERE (running)
	0x0000 0x0401: pmt_pid 0x006e MULTI4 -- M6 (running)
	0x0000 0x0402: pmt_pid 0x00d2 MULTI4 -- W9 (running)
	0x0000 0x0403: pmt_pid 0x0136 MULTI4 -- NT1 (running)
	>>> tune to: 522166:I999B8C23D999M64T8G32Y0:T:27500:
	0x0000 0x0301: pmt_pid 0x0000 CNH -- CANAL+ (running)
	0x0000 0x0302: pmt_pid 0x0000 CNH -- CANAL+ CINEMA
(running,scrambled)
	0x0000 0x0303: pmt_pid 0x0000 CNH -- CANAL+ SPORT (running)
	0x0000 0x0304: pmt_pid 0x0000 CNH -- PLANETE (running, scrambled)
	0x0000 0x0305: pmt_pid 0x0000 CNH -- CANAL J (running, scrambled)
	0x0000 0x0306: pmt_pid 0x0000 CNH -- TPS STAR (running)
	0x0000 0x03f0: pmt_pid 0x0000 CNH -- (null) (running)
	0x0000 0x03f1: pmt_pid 0x0000 CNH -- (null) (running)
	Network Name 'F'
	>>> tune to: 538166:I999B8C23D999M64T8G32Y0:T:27500:
	WARNING: >>> tuning failed!!!
	>>> tune to: 538166:I999B8C23D999M64T8G32Y0:T:27500: (tuning failed)
	WARNING: >>> tuning failed!!!
	>>> tune to: 562166:I999B8C23D999M64T8G32Y0:T:27500:
	0x0000 0x0601: pmt_pid 0x0064 SMR6 -- TF1 (running)
	0x0000 0x0602: pmt_pid 0x00c8 SMR6 -- NRJ12 (running)
	0x0000 0x0604: pmt_pid 0x0190 SMR6 -- Eurosport  (running,scrambled)
	0x0000 0x0603: pmt_pid 0x012c SMR6 -- LCI (running, scrambled)
	0x0000 0x0606: pmt_pid 0x0258 SMR6 -- TMC (running)
	0x0000 0x0605: pmt_pid 0x01f4 SMR6 -- TF6 (running, scrambled)
	Network Name 'F'
	>>> tune to: 586166:I999B8C34D999M64T8G8Y0:T:27500:
	0x0000 0x0111: pmt_pid 0x00d2 GR1 -- France 3 (running)
	0x0000 0x0101: pmt_pid 0x006e GR1 -- France 2 (running)
	0x0000 0x0104: pmt_pid 0x0136 GR1 -- France 5 (running)
	0x0000 0x0106: pmt_pid 0x0262 GR1 -- LCP (running)
	0x0000 0x0105: pmt_pid 0x01fe GR1 -- ARTE (running)
	0x0000 0x0176: pmt_pid 0x02c6 GR1 -- France   (running)
	Network Name 'F'
	>>> tune to: 714166:I999B8C34D999M64T8G8Y0:T:27500:
	WARNING: filter timeout pid 0x0011
	WARNING: filter timeout pid 0x0000
	WARNING: filter timeout pid 0x0010
	>>> tune to: 738166:I999B8C23D999M64T8G32Y0:T:27500:
	WARNING: filter timeout pid 0x0011
	WARNING: filter timeout pid 0x0000
	WARNING: filter timeout pid 0x0010
	>>> tune to: 754166:I999B8C23D999M64T8G32Y0:T:27500:
	WARNING: filter timeout pid 0x0011
	WARNING: filter timeout pid 0x0000
	WARNING: filter timeout pid 0x0010
	>>> tune to: 762166:I999B8C23D999M64T8G32Y0:T:27500:
	WARNING: filter timeout pid 0x0011
	WARNING: filter timeout pid 0x0000
	WARNING: filter timeout pid 0x0010
	>>> tune to: 786166:I999B8C23D999M64T8G32Y0:T:27500:
	WARNING: filter timeout pid 0x0011
	WARNING: filter timeout pid 0x0000
	WARNING: filter timeout pid 0x0010
	>>> tune to: 810166:I999B8C23D999M64T8G32Y0:T:27500:
	WARNING: filter timeout pid 0x0011
	WARNING: filter timeout pid 0x0000
	WARNING: filter timeout pid 0x0010
	>>> tune to: 4294967:I999B8C999D12M64T8G32Y0:T:27500:
	__tune_to_transponder:1508: ERROR: Setting frontend parameters
failed: 22 Invalid argument
	>>> tune to: 4294967:I999B8C999D12M64T8G32Y0:T:27500:
	__tune_to_transponder:1508: ERROR: Setting frontend parameters
failed: 22 Invalid argument
	dumping lists (35 services)
	Done.
________________________________________________________________   



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
