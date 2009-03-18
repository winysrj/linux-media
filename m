Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.nav6.org ([219.93.2.80]:48017 "EHLO nav6.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbZCRH7t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 03:59:49 -0400
Message-ID: <49C0A9E8.1080403@nav6.org>
Date: Wed, 18 Mar 2009 16:59:36 +0900
From: Ang Way Chuang <wcang@nav6.org>
MIME-Version: 1.0
To: Grant Gardner <grant@lastweekend.com.au>
CC: linux-media@vger.kernel.org
Subject: Re: No subsystem id (and therefore no cx88_dvb loaded) after reboot
References: <e0f27036e7a5af1cc8e8a725b522593b@localhost> <49C03FAE.9060009@nav6.org>
In-Reply-To: <49C03FAE.9060009@nav6.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ang Way Chuang wrote:
> I experience similar problem with HVR4000 Lite cards that we have in the 
> lab. The card can't tune after cold boot, but a reboot will fix the 
> problem. I will check whether it has the similar invalid subsystem id 
> problem.

Unfortunately, I can't reproduce the cold boot tuning problem now. We'll 
send syslog information if our partner universities report the similar 
issue. Sorry.

> 
> Grant Gardner wrote:
>>
>>
>> I'm looking for some pointers on debugging a problem with my DVICO
>> FusionHDTV Hybrid DVB-T card.
>>
>> The device was working perfectly prior to a reconfiguration of my 
>> machine,
>> kernel upgrade etc...
>>
>> Now, on a cold start everything seems to start smoothly but I can't tune
>> channels.
>>
>> Then, after a reboot the device is not detected due to "invalid subsystem
>> id". As below lspci reports no subsystem information at all.
>> Comparing the lspci output seems to be around the "Region 0: Memory at
>> ee000000 v de000000", but I'm not
>> sure what this means, and whether fixing the reboot problem will fix the
>> channel tuning problem.
>>
>> Running mythbuntu 8.10
>> 2.6.27-11-generic #1 SMP Thu Jan 29 19:28:32 UTC 2009 x86_64 GNU/Linux
>>
>> lspci -vvnn after cold start
>>
>> 00:0a.0 Multimedia video controller [0400]: Conexant Systems, Inc.
>> CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)
>>     Subsystem: DViCO Corporation Device [18ac:db40]
>>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>     Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
>>     Interrupt: pin A routed to IRQ 18
>>     Region 0: Memory at de000000 (32-bit, non-prefetchable) [size=16M]
>>     Capabilities: [44] Vital Product Data <?>
>>     Capabilities: [4c] Power Management version 2
>>         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>     Kernel driver in use: cx8800
>>     Kernel modules: cx8800
>>
>> 00:0a.1 Multimedia controller [0480]: Conexant Systems, Inc. 
>> CX23880/1/2/3
>> PCI Video and Audio Decoder [Audio Port] [14f1:8811] (rev 05)
>>     Subsystem: DViCO Corporation Device [18ac:db40]
>>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>     Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
>>     Interrupt: pin A routed to IRQ 11
>>     Region 0: Memory at df000000 (32-bit, non-prefetchable) [size=16M]
>>     Capabilities: [4c] Power Management version 2
>>         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>     Kernel modules: cx88-alsa
>>
>> 00:0a.2 Multimedia controller [0480]: Conexant Systems, Inc. 
>> CX23880/1/2/3
>> PCI Video and Audio Decoder [MPEG Port] [14f1:8802] (rev 05)
>>     Subsystem: DViCO Corporation Device [18ac:db40]
>>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
>> <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>     Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
>>     Interrupt: pin A routed to IRQ 18
>>     Region 0: Memory at e0000000 (32-bit, non-prefetchable) [size=16M]
>>     Capabilities: [4c] Power Management version 2
>>         Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
currently, though we're working on a commercial implementation of the
RTP profile.

If you're interested in the GPL'ed UDP profile code, we can email it to
you in a week or two (we'll eventually make it available on our website
as well, but currently it needs to be cleaned up a bit).

T.C.
>>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>     Kernel driver in use: cx88-mpeg driver manager
>>     Kernel modules: cx8802
>>
>>
>> lspci -vvnn after warm reboot
>>
>> 00:0a.0 Multimedia video controller [0400]: Conexant Systems, Inc.
>> CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)
>>       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>       Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
>>       Interrupt: pin A routed to IRQ 18
>>       Region 0: Memory at ee000000 (32-bit, non-prefetchable) [size=16M]
>>       Capabilities: [44] Vital Product Data <?>
>>       Capabilities: [4c] Power Management version 2
>>               Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>               Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>       Kernel driver in use: cx8800
>>       Kernel modules: cx8800
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

