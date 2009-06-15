Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:39353 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZFOW1c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 18:27:32 -0400
Received: from IO.local (4-167.105-92.cust.bluewin.ch [92.105.167.4])
	(authenticated bits=0)
	by smtp1.infomaniak.ch (8.14.2/8.14.2) with ESMTP id n5FMRWZw022110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 16 Jun 2009 00:27:32 +0200
Message-ID: <4A36CAD3.4030806@deckpoint.ch>
Date: Tue, 16 Jun 2009 00:27:31 +0200
From: Thomas Kernen <tkernen@deckpoint.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: TT-S1500 budget-ci registeration
References: <4A36B2F1.5060006@deckpoint.ch>
In-Reply-To: <4A36B2F1.5060006@deckpoint.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thomas Kernen wrote:
> 
> Hello to all,
> 
> I'm currently testing a TT-S1500 budget card with the TT budget CI 
> adapter with vl4 tree and kernel 2.6.28.
> 
> When I modprobe budget_ci, the CI adapter seems to be detected but not 
> registered in /dev/dvb/adapter3/ca0 as I would have expected it to be.
> 
> Instead I see the following output:
> 
> [  148.664846] input: Budget-CI dvb ir receiver saa7146 (0) as 
> /devices/pci0000:00/0000:00:1e.0/0000:11:09.0/input/input5
> 
> Any suggestions/ideas what the cause may be and how I can attempt to 
> solve this?
> 
> Thanks
> Thomas
> -- 

And I realised I cut and pasted the wrong line: I was expecting to see 
"budget_ci: CI interface initialised" after the other line but nothing 
of the like did appear. Nor any line indicating an error.

As one can see from the lspci the drivers claim to be in use:

11:09.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Technotrend Systemtechnik GmbH Device 1017
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 123 (3750ns min, 9500ns max)
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at d0220000 (32-bit, non-prefetchable) [size=512]
	Kernel driver in use: budget_ci dvb
	Kernel modules: budget-ci

Am I missing a point here? I can't find anything that addresses this in 
the LinuxTV wiki or in the archives of the mailing list.

Thanks
Thomas
