Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n73a.bullet.mail.sp1.yahoo.com ([98.136.45.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <killero_24@yahoo.com>) id 1Knd14-0002Kq-Qg
	for linux-dvb@linuxtv.org; Wed, 08 Oct 2008 19:40:09 +0200
Date: Wed, 8 Oct 2008 10:39:29 -0700 (PDT)
From: Killero SS <killero_24@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <370912.91542.qm@web45403.mail.sp1.yahoo.com>
Subject: [linux-dvb] ATI HDTV 600 PCIe
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


I just can't get this card to work on ubuntu 8.04

lspci output: device is just not recognized:

03:00.0 Multimedia controller: ATI Technologies Inc Unknown device ac02
    Subsystem: ATI Technologies Inc Unknown device b300
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 10
    Region 0: Memory at e0200000 (32-bit, non-prefetchable) [size=1M]
    Region 2: Memory at e0000000 (32-bit, prefetchable) [size=128K]
    Capabilities: [50] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Express Legacy Endpoint IRQ 0
        Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
        Device: Latency L0s <4us, L1 unlimited
        Device: AtnBtn- AtnInd- PwrInd-
        Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
        Device: RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
        Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
        Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
        Link: Latency L0s <64ns, L1 <1us
        Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
        Link: Speed 2.5Gb/s, Width x1

dmesg:

[ 4343.374866] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[ 4343.374873] cx88/2: registering cx8802 driver, type: dvb access: shared

modprobe:

FATAL: Error inserting cx88_dvb (/lib/modules/2.6.24-21-generic/kernel/drivers/media/video/cx88/cx88-dvb.ko): No such device

tried with card=33 but get
[  657.482627] cx88_dvb: Unknown parameter `card'

also tried to modify cx88-cards.c:
added:

                .subvendor = 0xac02,
                .subdevice = 0xb300,
                .card      = CX88_BOARD_ATI_HDTVWONDER,
        },{
after the ati card line


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
