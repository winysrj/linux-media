Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rudy@grumpydevil.homelinux.org>) id 1LLcc9-0006nR-9w
	for linux-dvb@linuxtv.org; Sat, 10 Jan 2009 13:06:56 +0100
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
To: Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <1a297b360901091300w6078f926p5efaadeb912e8c03@mail.gmail.com>
References: <1a297b360901091300w6078f926p5efaadeb912e8c03@mail.gmail.com>
Date: Sat, 10 Jan 2009 13:06:37 +0100
Message-Id: <1231589197.23623.618.camel@poledra.romunt.nl>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis users
Reply-To: Rudy@grumpydevil.homelinux.org
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

Op zaterdag 10-01-2009 om 01:00 uur [tijdzone +0400], schreef Manu
Abraham:
> Hi,
> 
> Can you all please provide me the following information for the
> Mantis / Hopper bridge 
> based cards that you have in the following manner ?
> 
> 1) Card Name (As advertised on the cardboard box):

I've lost the cardboard box long ago

on the PCB is says VP-20330 Ver:1.4. This is a DVB-C card
Label on the tuner tin has Twinhan

> 
> 2) lspci -vvn:

05:09.0 0480: 1822:4e35 (rev 01)
        Subsystem: 1822:0008
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at f8fff000 (32-bit, prefetchable) [size=4K]

> 
> 3) Chips on the card if you know them (only the basic chip description
> is required, 
> not the complete batch no. etc)
> 

Mantis K61468. 1A-1

> 
> Regards,
> Manu
> 
Cheers,

Rudy
> 


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
