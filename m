Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.csc.fi ([193.166.3.105])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Christopher.Ariyo@csc.fi>) id 1LMHi7-000392-Sm
	for linux-dvb@linuxtv.org; Mon, 12 Jan 2009 08:59:49 +0100
Received: from kusti.csc.fi (kusti.csc.fi [193.166.0.100])
	by smtp1.csc.fi (MAILSERVER) with ESMTP id n0C7wrmX004618
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=OK)
	for <linux-dvb@linuxtv.org>; Mon, 12 Jan 2009 09:59:35 +0200
Message-ID: <496AF83C.2080303@csc.fi>
Date: Mon, 12 Jan 2009 09:58:52 +0200
From: Chris Ariyo <Chris.Ariyo@csc.fi>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
References: <1a297b360901091300w6078f926p5efaadeb912e8c03@mail.gmail.com>
In-Reply-To: <1a297b360901091300w6078f926p5efaadeb912e8c03@mail.gmail.com>
Cc: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Mantis users
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

Hi,

Manu Abraham wrote:
> Hi,
> 
> Can you all please provide me the following information for the Mantis / Hopper bridge
> based cards that you have in the following manner ?
> 
> 1) Card Name (As advertised on the cardboard box):
> 


TerraTec Cinergy S2 PCI HD with CI module

> 2) lspci -vvn:
> 

04:06.0 0480: 1822:4e35 (rev 01)
	Subsystem: 153b:1179
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort+ <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at fdbff000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: Mantis
	Kernel modules: mantis

> 3) Chips on the card if you know them (only the basic chip description is required,
> not the complete batch no. etc)
> 

Don't have it


regards,
Chris

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
