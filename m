Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:42386 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZFPHek (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 03:34:40 -0400
Received: from IO.local (4-167.105-92.cust.bluewin.ch [92.105.167.4])
	(authenticated bits=0)
	by smtp1.infomaniak.ch (8.14.2/8.14.2) with ESMTP id n5G7Ybxa027909
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 16 Jun 2009 09:34:41 +0200
Message-ID: <4A374B0D.4030303@deckpoint.ch>
Date: Tue, 16 Jun 2009 09:34:37 +0200
From: Thomas Kernen <tkernen@deckpoint.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [SOLVED] Re: TT-S1500 budget-ci registeration
References: <4A36B2F1.5060006@deckpoint.ch> <4A36CAD3.4030806@deckpoint.ch>
In-Reply-To: <4A36CAD3.4030806@deckpoint.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thomas Kernen wrote:
> Thomas Kernen wrote:
>>
>> Hello to all,
>>
>> I'm currently testing a TT-S1500 budget card with the TT budget CI 
>> adapter with vl4 tree and kernel 2.6.28.
>>
>> When I modprobe budget_ci, the CI adapter seems to be detected but not 
>> registered in /dev/dvb/adapter3/ca0 as I would have expected it to be.
>>
>> Instead I see the following output:
>>
>> [  148.664846] input: Budget-CI dvb ir receiver saa7146 (0) as 
>> /devices/pci0000:00/0000:00:1e.0/0000:11:09.0/input/input5
>>
>> Any suggestions/ideas what the cause may be and how I can attempt to 
>> solve this?
>>
>> Thanks
>> Thomas
>> -- 
> 
> And I realised I cut and pasted the wrong line: I was expecting to see 
> "budget_ci: CI interface initialised" after the other line but nothing 
> of the like did appear. Nor any line indicating an error.
> 
> As one can see from the lspci the drivers claim to be in use:
> 
> 11:09.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>     Subsystem: Technotrend Systemtechnik GmbH Device 1017
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
> Stepping- SERR- FastB2B- DisINTx-
>     Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>     Latency: 123 (3750ns min, 9500ns max)
>     Interrupt: pin A routed to IRQ 23
>     Region 0: Memory at d0220000 (32-bit, non-prefetchable) [size=512]
>     Kernel driver in use: budget_ci dvb
>     Kernel modules: budget-ci
> 
> Am I missing a point here? I can't find anything that addresses this in 
> the LinuxTV wiki or in the archives of the mailing list.
> 

It would appear that I enjoy speaking to myself on this mailer ;-)

Anyway, good news is that the issue had to do with a defective cable 
that was bridging the Budget CI and the TT S-1500. It is now functional 
and descrambles the Viaccess streams I needed to test against.

Later today I will update the wiki pages with the details of my setup:

[    8.850659] saa7146: register extension 'budget_ci dvb'.
[    8.850678] budget_ci dvb 0000:11:08.0: PCI INT A -> GSI 22 (level, 
low) -> IRQ 22
[    8.850695] saa7146: found saa7146 @ mem ffffc20001198000 (revision 
1, irq 22) (0x13c2,0x1017).
[    8.850698] saa7146 (0): dma buffer size 192512
[    8.850700] DVB: registering new adapter (TT-Budget/S-1500 PCI)
[    8.910869] adapter has MAC addr = 00:d0:5c:64:c2:55
[    8.911046] input: Budget-CI dvb ir receiver saa7146 (0) as 
/devices/pci0000:00/0000:00:1e.0/0000:11:08.0/input/input4
[    8.972616] budget_ci: CI interface initialised
[    9.335816] LNBx2x attached on addr=8DVB: registering adapter 0 
frontend 0 (ST STV0299 DVB-S)...
[    9.340535] dvb_ca adapter 0: DVB CAM detected and initialised 
successfully

CAM Application type: 01
CAM Application manufacturer: 02ca
CAM Manufacturer code: 3000
CAM Menu string: PowerCam_HD V2.0.4


Hopefully this might be useful to others too.

Thomas
