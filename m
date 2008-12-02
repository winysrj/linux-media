Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-3.orange.nl ([193.252.22.243])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michel@verbraak.org>) id 1L7OWe-00004u-6x
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 07:14:25 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf6209.online.nl (SMTP Server) with ESMTP id 5F4AB1C00082
	for <linux-dvb@linuxtv.org>; Tue,  2 Dec 2008 07:13:50 +0100 (CET)
Received: from asterisk.verbraak.thuis (s55939d86.adsl.wanadoo.nl
	[85.147.157.134])
	by mwinf6209.online.nl (SMTP Server) with ESMTP id 335871C00081
	for <linux-dvb@linuxtv.org>; Tue,  2 Dec 2008 07:13:46 +0100 (CET)
Message-ID: <4934D218.4090202@verbraak.org>
Date: Tue, 02 Dec 2008 07:13:44 +0100
From: Michel Verbraak <michel@verbraak.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <49346726.7010303@insite.cz>
In-Reply-To: <49346726.7010303@insite.cz>
Subject: Re: [linux-dvb] Technisat HD2 cannot szap/scan
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

Pavel Hofman schreef:
> Hello,
>
>
> I have studied many pages, tried to make the card work. I can tune and 
> view programs in windows.
>
> My setup:
>
> Ubuntu 8.04, P4 32bit, Technisat HD2 connected to dual LNB, A heading to 
> Astra 19.2E, B heading to Astra 23.5E
>
> uname -a:
> Linux htpc 2.6.24-19-generic #1 SMP
>
>
> lspci -v:
> 05:01.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI 
> Bridge Controller [Ver 1.0] (rev 01)
>          Subsystem: Unknown device 1ae4:0003
>          Flags: bus master, medium devsel, latency 32, IRQ 22
>          Memory at 92000000 (32-bit, prefetchable) [size=4K]
>
>
> I fetched latest mantis from  http://jusst.de/hg/mantis, changed
> #define TECHNISAT_SKYSTAR_HD2  0x0003
>
>
>   
<snip>
> I fetched latest dvb-apps from  http://linuxtv.org/hg/dvb-apps, compiled.
>
>   
<snip>
> Please what are the next steps I should perform to make the card work? 
> Such as the success report 
> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29608.html
>
>
> I can post verbose=5 messages for stb0899/stb6100 if needed. Thank you 
> very much for your help and suggestions.
>
> Regards,
>
> Pavel.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   

Pavel,

Try http://mercurial.intuxication.org/hg/s2-liplianin . This one works 
for me on Fedora 9 with the latest scan tool (scan-s2) from 
http://mercurial.intuxication.org/hg/scan-s2 and tune tool (szap-s2) 
from http://mercurial.intuxication.org/hg/szap-s2.

If you unpack the driver and the tools unpack them into the same 
directory and make a symbolic link named "s2" pointing to the 
s2-liplianing-* directory. Do this before compiling of the tools.

Regards,

Michel.




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
