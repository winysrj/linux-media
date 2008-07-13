Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wp025.webpack.hosteurope.de ([80.237.132.32])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <julian@summer06.de>) id 1KI20l-0001xZ-Qa
	for linux-dvb@linuxtv.org; Sun, 13 Jul 2008 15:53:14 +0200
Message-ID: <487A0899.4020900@summer06.de>
Date: Sun, 13 Jul 2008 15:52:25 +0200
From: Julian Picht <julian@summer06.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <486C9A32.3010904@summer06.de>
In-Reply-To: <486C9A32.3010904@summer06.de>
Subject: Re: [linux-dvb] Terratec Cinergy S PCI
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

Hi List,

anyone with any information on how to start?
Any docs to look into?
Any Wiki Page?
Anyone responsible for, or with some knowledge about, the cx88 driver?

Regards,
J.Picht

Julian Picht schrieb:
> Hi List.
>
> I recently bought a Terratec Cinergy S PCI which uses a Conexant CX2388x 
> chip as it's PCI Interface and a Fujitsu MB86A16 as it's frontend.
>
> I modified the cx88 files to recognize this card. Now I need a some 
> pointers how to attach the MB86A16 frontend (which is included in mantis 
> source, i think) to the cx88 and how to obtain the right i2c adresses etc.
>
> Is there any documentation on how to do that?
> I would be very happy to contribute to the great work you do and already 
> did.
>
> --------------------------------------
> # lspci -vvnn
> 04:01.0 Multimedia video controller [0400]: Conexant CX23880/1/2/3 PCI 
> Video and Audio Decoder [14f1:8800] (rev 05)
>    Subsystem: TERRATEC Electronic GmbH Device [153b:117a]
>    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
> Stepping- SERR- FastB2B- DisINTx-
>    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
>    Interrupt: pin A routed to IRQ 22
>    Region 0: Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
>    Capabilities: <access denied>
>    Kernel driver in use: cx8800
>    Kernel modules: cx8800
>
> 04:01.2 Multimedia controller [0480]: Conexant CX23880/1/2/3 PCI Video 
> and Audio Decoder [MPEG Port] [14f1:8802] (rev 05)
>    Subsystem: TERRATEC Electronic GmbH Device [153b:117a]
>    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
> Stepping- SERR- FastB2B- DisINTx-
>    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
>    Interrupt: pin A routed to IRQ 5
>    Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=16M]
>    Capabilities: <access denied>
>    Kernel modules: cx8802
>
> 04:01.4 Multimedia controller [0480]: Conexant CX23880/1/2/3 PCI Video 
> and Audio Decoder [IR Port] [14f1:8804] (rev 05)
>    Subsystem: TERRATEC Electronic GmbH Device [153b:117a]
>    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
> Stepping- SERR- FastB2B- DisINTx-
>    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>    Latency: 32 (1500ns min, 63750ns max), Cache Line Size: 32 bytes
>    Interrupt: pin A routed to IRQ 5
>    Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
>    Capabilities: <access denied>
>
> --------------------------------------
> # i2cdetect -l
> i2c-0    smbus         SMBus I801 adapter at 0400          SMBus adapter
> i2c-1    i2c           cx88[0]                             I2C adapter
> # i2cdetect 1
> WARNING! This program can confuse your I2C bus, cause data loss and worse!
> I will probe file /dev/i2c-1.
> I will probe address range 0x03-0x77.
> Continue? [Y/n]
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          -- -- -- -- -- 08 -- -- -- -- -- -- --
> 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 50: UU -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
> 70: -- -- -- -- -- -- -- --
> --------------------------------------
>
> Thanks in advance! Any help appreciated!
>
> Julian Picht
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
