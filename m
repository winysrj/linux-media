Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alireza.torabi@gmail.com>) id 1K7IaQ-0005wY-VT
	for linux-dvb@linuxtv.org; Sat, 14 Jun 2008 01:21:42 +0200
Received: by wf-out-1314.google.com with SMTP id 27so4365673wfd.17
	for <linux-dvb@linuxtv.org>; Fri, 13 Jun 2008 16:21:19 -0700 (PDT)
Message-ID: <cffd8c580806131621p6c8e783al4c96b00763721acf@mail.gmail.com>
Date: Sat, 14 Jun 2008 00:21:19 +0100
From: "Alireza Torabi" <alireza.torabi@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Scanning with DVB-S2 card (VP-1041) and Mantis
	drivers...
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

I've been reading all these messages about the scan and patches
required to make it work with STB0899 frontends.
Could anyone help please:

scan)
[alireza@linux ~]$ scan Astra-28.2E
scanning Astra-28.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12441000 V 27500000 2
>>> tune to: 12441:v:0:27500
DVB-S IF freq is 1841000
__tune_to_transponder:1516: ERROR: FE_READ_STATUS failed: 22 Invalid argument
>>> tune to: 12441:v:0:27500
DVB-S IF freq is 1841000
__tune_to_transponder:1516: ERROR: FE_READ_STATUS failed: 22 Invalid argument
ERROR: initial tuning failed
dumping lists (0 services)
Done.

kernel message)
Jun 14 04:16:59 linux kernel: stb0899_search: Unsupported delivery system

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
