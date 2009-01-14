Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2e.orange.fr ([80.12.242.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <catimimi@libertysurf.fr>) id 1LN22c-0007vE-Um
	for linux-dvb@linuxtv.org; Wed, 14 Jan 2009 10:28:03 +0100
Message-ID: <496DB023.3090402@libertysurf.fr>
Date: Wed, 14 Jan 2009 10:28:03 +0100
From: Catimimi <catimimi@libertysurf.fr>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org, Linux-media <linux-media@vger.kernel.org>
References: <496CB23D.6000606@libertysurf.fr> <496D7204.6030501@rogers.com>
In-Reply-To: <496D7204.6030501@rogers.com>
Subject: Re: [linux-dvb] Pinnacle dual Hybrid pro PCI-express - linuxTV!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0526583308=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0526583308==
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content=3D"text/html;charset=3DISO-8859-15"
 http-equiv=3D"Content-Type">
</head>
<body bgcolor=3D"#ffffff" text=3D"#000000">
CityK a =E9crit=A0:
<blockquote cite=3D"mid:496D7204.6030501@rogers.com" type=3D"cite">
  <blockquote type=3D"cite">
    <pre wrap=3D"">in order to send you the result of :

lspci -vvxxx

for the Pinnacle PCTV Dual Hybrid Pro PCI Express (3010i)

______________________

04:00.0 Multimedia controller: Philips Semiconductors Device 7162
        Subsystem: Pinnacle Systems Inc. Device 0100
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast &gt;TAbor=
t-
&lt;TAbort- &lt;MAbort- &gt;SERR- &lt;PERR- INTx-
        Latency: 0, Cache Line Size: 16 bytes
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at dde00000 (64-bit, non-prefetchable) [size=3D1=
M]
        Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+
Queue=3D0/5 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [50] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
&lt;256ns, L1 &lt;1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
TransPend-
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 &lt;4us, L1 &lt;64us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain-
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk-
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [74] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] Vendor Specific Information &lt;?&gt;
00: 31 11 62 71 07 00 10 00 00 00 80 04 04 00 00 00
10: 04 00 e0 dd 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 bd 11 00 01
30: 00 00 00 00 40 00 00 00 00 00 00 00 05 01 00 00
40: 05 50 8a 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 10 74 01 00 80 00 28 00 10 00 0a 00 11 6c 03 01
60: 08 00 11 00 00 0a 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 01 80 02 3e 00 00 00 00 00 00 00 00
80: 09 00 50 00 03 0c 00 00 02 02 00 00 00 00 00 00
90: 00 04 00 00 00 00 00 08 00 00 10 00 00 00 00 00
a0: 01 00 00 04 03 18 00 00 00 00 01 04 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 20 01 2a 00 00
c0: 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

I hope it'll help.
    </pre>
  </blockquote>
  <pre wrap=3D""><!---->
Could you put it in the wiki if its not already contained there.  Thanks.
  </pre>
</blockquote>
It was done yesterday.<br>
<blockquote cite=3D"mid:496D7204.6030501@rogers.com" type=3D"cite">
  <pre wrap=3D"">
  </pre>
  <blockquote type=3D"cite">
    <pre wrap=3D"">I tried the driver found here : <a class=3D"moz-txt-li=
nk-freetext" href=3D"http://jusst.de/hg/saa716x">http://jusst.de/hg/saa71=
6x</a>
It compiles and install, but if I try : modprobe saa716x_hybrid.ko
I get a fatal error : module not found.

I can't find any message in dmesg.
    </pre>
  </blockquote>
  <pre wrap=3D""><!---->
try without the ".ko", i.e. instead, use:

modprobe saa716x_hybrid
  </pre>
</blockquote>
OK, shame on me, it works but nothing happens.<br>
Michel.<br>
<br>
</body>
</html>



--===============0526583308==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0526583308==--
