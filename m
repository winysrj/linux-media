Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout4.freenet.de ([195.4.92.94])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ruediger.dohmhardt@freenet.de>) id 1LVtir-00053h-RT
	for linux-dvb@linuxtv.org; Sat, 07 Feb 2009 21:24:18 +0100
Message-ID: <498DEDA9.7010905@freenet.de>
Date: Sat, 07 Feb 2009 21:23:05 +0100
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <4984E294.6020401@gmail.com> <498B7945.4060200@gmail.com>
In-Reply-To: <498B7945.4060200@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis Update was Re: Twinhan DTV Ter-CI (3030
 Mantis) ???
Reply-To: linux-media@vger.kernel.org
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

Manu Abraham schrieb:
> Have added initial support for this card, as well as a large
> overhaul of the driver for a couple of performance impacts.
>
> Please do test with the latest updates from http://jusst.de/hg/mantis.
>   
Hi Manu
the versions from January and February 2009 compile fine on the
SUSE-11.1 kernel 2.6.27.7-9-default x86_64.
The modules for my Twinhan AD-CP300 (2033) load fine, too.

However, the devices below /dev/dvb are NOT created, and hence vdr-1.7
does not work.
The card works with the s2-liplianin driver.

I assume it is interrupt related as listed in the lines from
/var/log/messages


Feb  7 21:03:38 mt40 su: (to root) rudi on /dev/pts/1
Feb  7 21:03:48 mt40 kernel: vendor=1002 device=4371
Feb  7 21:03:48 mt40 kernel: Mantis 0000:02:01.0: PCI INT A -> GSI 21
(level, low) -> IRQ 21
Feb  7 21:03:48 mt40 kernel: DVB: registering new adapter (Mantis DVB
adapter)
Feb  7 21:03:48 mt40 kernel: vendor=1002 device=4371
Feb  7 21:03:48 mt40 kernel: Mantis 0000:02:01.0: PCI INT A disabled
Feb  7 21:03:48 mt40 kernel: Mantis: probe of 0000:02:01.0 failed with
error -1
Feb  7 21:05:03 mt40 vdr: [4320] cTimeMs: using monotonic clock
(resolution is 1 ns)
Feb  7 21:05:03 mt40 vdr: [4320] VDR version 1.7.0 started
Feb  7 21:05:03 mt40 vdr: [4320] codeset is 'UTF-8' - known
Feb  7 21:05:03 mt40 vdr: [4320] ERROR: ./locale: Datei oder Verzeichnis
nicht gefunden
Feb  7 21:05:03 mt40 vdr: [4320] no locale for language code 'deu,ger'
Feb  7 21:05:03 mt40 vdr: [4320] no locale for language code 'slv,slo'
Feb  7 21:05:03 mt40 vdr: [4320] no locale for language code 'ita'
Feb  7 21:05:05 mt40 vdr: [4320] no DVB device found

I wonder whether I can check something more to get your driver back to work

Ciao Ruediger

>   


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
