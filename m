Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f20.google.com ([209.85.217.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <orbus42@gmail.com>) id 1KTQdD-0003db-Ol
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 02:24:01 +0200
Received: by gxk13 with SMTP id 13so2365328gxk.17
	for <linux-dvb@linuxtv.org>; Wed, 13 Aug 2008 17:23:24 -0700 (PDT)
Message-ID: <8fcafd2c0808131723l21031daej9e9ae3eeabfa57f7@mail.gmail.com>
Date: Wed, 13 Aug 2008 19:23:24 -0500
From: "James Lucas" <orbus42@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Digital tuning failing on Pinnacle 800i with dmesg
	output
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1570025029=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1570025029==
Content-Type: multipart/alternative;
	boundary="----=_Part_95985_12219181.1218673404590"

------=_Part_95985_12219181.1218673404590
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

 Hello - first time poster here.  I'm running Ubuntu Hardy, stock kernel
2.6.24-19-generic.  Compiled the v4l tree from repository and installed the
modules.  Also grabbed firmware found on the dvb-wiki page  Analog tuning
works.  Trying to run dvbscan or scan results in either no channels found or
a hang on the attempt to tune the first channel.

Output of dmesg contains errors like this:

[  576.298553] i2c-adapter i2c-2: sendbytes: error - bailout.
[  577.098249] xc5000: I2C write failed (len=4)
[  577.098259] xc5000: Unable to initialise tuner
[  583.499754] s5h1409_writereg: writereg error (reg == 0xf3, val == 0x0000,
ret == -121)
[  589.897260] s5h1409_writereg: writereg error (reg == 0xf5, val == 0x0000,
ret == -121)
[  596.294758] s5h1409_writereg: writereg error (reg == 0xf5, val == 0x0001,
ret == -121)
[  602.692260] s5h1409_writereg: writereg error (reg == 0xf4, val == 0x0001,
ret == -121)
[  609.089760] s5h1409_writereg: writereg error (reg == 0x85, val == 0x0110,
ret == -121)
[  615.487264] s5h1409_writereg: writereg error (reg == 0xf5, val == 0x0000,
ret == -121)
[  621.884765] s5h1409_writereg: writereg error (reg == 0xf5, val == 0x0001,
ret == -121)
[  628.386227] s5h1409_writereg: writereg error (reg == 0xf3, val == 0x0001,
ret == -121)



Here's the relevant lspci -vvnn output for the card:

00:0f.0 Multimedia video controller [0400]: Conexant CX23880/1/2/3 PCI Video
and Audio Decoder [14f1:8800] (rev 05)
       Subsystem: Pinnacle Systems Inc. Unknown device [11bd:0051]
       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
       Latency: 64 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
       Interrupt: pin A routed to IRQ 5
       Region 0: Memory at ca000000 (32-bit, non-prefetchable) [size=16M]
       Capabilities: [44] Vital Product Data
       Capabilities: [4c] Power Management version 2
               Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0f.1 Multimedia controller [0480]: Conexant CX23880/1/2/3 PCI Video and
Audio Decoder [Audio Port] [14f1:8801] (rev 05)
       Subsystem: Pinnacle Systems Inc. Unknown device [11bd:0051]
       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
       Latency: 64 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
       Interrupt: pin A routed to IRQ 5
       Region 0: Memory at cb000000 (32-bit, non-prefetchable) [size=16M]
       Capabilities: [4c] Power Management version 2
               Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0f.2 Multimedia controller [0480]: Conexant CX23880/1/2/3 PCI Video and
Audio Decoder [MPEG Port] [14f1:8802] (rev 05)
       Subsystem: Pinnacle Systems Inc. Unknown device [11bd:0051]
       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
       Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
       Latency: 64 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
       Interrupt: pin A routed to IRQ 5
       Region 0: Memory at cc000000 (32-bit, non-prefetchable) [size=16M]
       Capabilities: [4c] Power Management version 2
               Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
               Status: D0 PME-Enable- DSel=0 DScale=0 PME-


I've got Time Warner cable, so I'm trying to pick up the QAM stations.  So
far no luck.  If anyone can shed any light, it would be most appreciated.
Thanks in advance!

James

------=_Part_95985_12219181.1218673404590
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">
<div class="moz-text-flowed" style="font-family: -moz-fixed; font-size: 13px;" lang="x-western">Hello - first time poster here.&nbsp; I&#39;m running Ubuntu Hardy, stock kernel 
2.6.24-19-generic.&nbsp; Compiled the v4l tree from repository and installed 
the modules.&nbsp; Also grabbed firmware found on the dvb-wiki page&nbsp; Analog 
tuning works.&nbsp; Trying to run dvbscan or scan results in either no 
channels found or a hang on the attempt to tune the first channel.
<br>
<br>Output of dmesg contains errors like this:
<br>
<br>[&nbsp; 576.298553] i2c-adapter i2c-2: sendbytes: error - bailout.
<br>[&nbsp; 577.098249] xc5000: I2C write failed (len=4)
<br>[&nbsp; 577.098259] xc5000: Unable to initialise tuner
<br>[&nbsp; 583.499754] s5h1409_writereg: writereg error (reg == 0xf3, val == 
0x0000, ret == -121)
<br>[&nbsp; 589.897260] s5h1409_writereg: writereg error (reg == 0xf5, val == 
0x0000, ret == -121)
<br>[&nbsp; 596.294758] s5h1409_writereg: writereg error (reg == 0xf5, val == 
0x0001, ret == -121)
<br>[&nbsp; 602.692260] s5h1409_writereg: writereg error (reg == 0xf4, val == 
0x0001, ret == -121)
<br>[&nbsp; 609.089760] s5h1409_writereg: writereg error (reg == 0x85, val == 
0x0110, ret == -121)
<br>[&nbsp; 615.487264] s5h1409_writereg: writereg error (reg == 0xf5, val == 
0x0000, ret == -121)
<br>[&nbsp; 621.884765] s5h1409_writereg: writereg error (reg == 0xf5, val == 
0x0001, ret == -121)
<br>[&nbsp; 628.386227] s5h1409_writereg: writereg error (reg == 0xf3, val == 
0x0001, ret == -121)
<br>
<br>
<br>
<br>Here&#39;s the relevant lspci -vvnn output for the card:
<br>
<br>00:0f.0 Multimedia video controller [0400]: Conexant CX23880/1/2/3 PCI 
Video and Audio Decoder [14f1:8800] (rev 05)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Subsystem: Pinnacle Systems Inc. Unknown device [11bd:0051]
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium &gt;TAbort- 
&lt;TAbort- &lt;MAbort- &gt;SERR- &lt;PERR-
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Latency: 64 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Interrupt: pin A routed to IRQ 5
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Region 0: Memory at ca000000 (32-bit, non-prefetchable) [size=16M]
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Capabilities: [44] Vital Product Data
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Capabilities: [4c] Power Management version 2
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Status: D0 PME-Enable- DSel=0 DScale=0 PME-
<br>
<br>00:0f.1 Multimedia controller [0480]: Conexant CX23880/1/2/3 PCI Video 
and Audio Decoder [Audio Port] [14f1:8801] (rev 05)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Subsystem: Pinnacle Systems Inc. Unknown device [11bd:0051]
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium &gt;TAbort- 
&lt;TAbort- &lt;MAbort- &gt;SERR- &lt;PERR-
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Latency: 64 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Interrupt: pin A routed to IRQ 5
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Region 0: Memory at cb000000 (32-bit, non-prefetchable) [size=16M]
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Capabilities: [4c] Power Management version 2
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Status: D0 PME-Enable- DSel=0 DScale=0 PME-
<br>
<br>00:0f.2 Multimedia controller [0480]: Conexant CX23880/1/2/3 PCI Video 
and Audio Decoder [MPEG Port] [14f1:8802] (rev 05)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Subsystem: Pinnacle Systems Inc. Unknown device [11bd:0051]
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium &gt;TAbort- 
&lt;TAbort- &lt;MAbort- &gt;SERR- &lt;PERR-
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Latency: 64 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Interrupt: pin A routed to IRQ 5
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Region 0: Memory at cc000000 (32-bit, non-prefetchable) [size=16M]
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Capabilities: [4c] Power Management version 2
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Status: D0 PME-Enable- DSel=0 DScale=0 PME-
<br>
<br>
<br>I&#39;ve got Time Warner cable, so I&#39;m trying to pick up the QAM stations.&nbsp; 
So far no luck.&nbsp; If anyone can shed any light, it would be most 
appreciated.&nbsp; Thanks in advance!
<br>
<br>James<br></div></div>

------=_Part_95985_12219181.1218673404590--


--===============1570025029==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1570025029==--
