Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from xsmtp0.ethz.ch ([82.130.70.14])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cluck@student.ethz.ch>) id 1K7YDu-0005rQ-1P
	for linux-dvb@linuxtv.org; Sat, 14 Jun 2008 18:03:36 +0200
Message-ID: <4853EBC4.8030205@ethz.ch>
Date: Sat, 14 Jun 2008 18:03:16 +0200
From: Claudio Luck <cluck@ethz.ch>
MIME-Version: 1.0
To: Alireza Torabi <alireza.torabi@gmail.com>
References: <cffd8c580806131621p6c8e783al4c96b00763721acf@mail.gmail.com>
In-Reply-To: <cffd8c580806131621p6c8e783al4c96b00763721acf@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Scanning with DVB-S2 card (VP-1041) and
	Mantis	drivers...
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

Alireza Torabi wrote:
> I've been reading all these messages about the scan and patches
> required to make it work with STB0899 frontends.

But you are still using an unpatched version of scan.

Seems to be a good and recent start:
"[linux-dvb] scan does not work on latest multiproto drivers"
http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025222.html


> Could anyone help please:
> 
> scan)
> [alireza@linux ~]$ scan Astra-28.2E
> scanning Astra-28.2E
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 12441000 V 27500000 2
>>>> tune to: 12441:v:0:27500
> DVB-S IF freq is 1841000
> __tune_to_transponder:1516: ERROR: FE_READ_STATUS failed: 22 Invalid argument
>>>> tune to: 12441:v:0:27500
> DVB-S IF freq is 1841000
> __tune_to_transponder:1516: ERROR: FE_READ_STATUS failed: 22 Invalid argument
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.
> 
> kernel message)
> Jun 14 04:16:59 linux kernel: stb0899_search: Unsupported delivery system

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
