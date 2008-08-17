Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1KUqSL-0005dT-EP
	for linux-dvb@linuxtv.org; Mon, 18 Aug 2008 00:10:39 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sun, 17 Aug 2008 23:55:14 +0200
References: <920268.8615.qm@web36104.mail.mud.yahoo.com>
In-Reply-To: <920268.8615.qm@web36104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808172355.14680@orion.escape-edv.de>
Subject: Re: [linux-dvb] problem with dvb-ttpci-01.fw-2622 and
	technotrend/hauppauge nexus-s 2.3
Reply-To: linux-dvb@linuxtv.org
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

Jody Gugelhupf wrote:
> Hi people, 
> I wrote a script to grab some xml data, in order to do, xine switches channels every 50 seconds for about 150 times. At some point the card stops working and I get error like this:
> [672227.942674] dvb-ttpci: StopHWFilter error  cmd 0b08 0001 0001  ret ffffff92  resp 0000 0000  pid 0
> [672228.944141] dvb-ttpci: __av7110_send_fw_cmd(): timeout waiting for COMMAND idle
> [672228.944150] dvb-ttpci: av7110_send_fw_cmd(): av7110_send_fw_cmd error -110
> [672228.944154] dvb-ttpci: av7110_fw_cmd error -110
> when i remove and readd the module it works fine again. Anyone has an idea why this happens and what I can do? Below is some information about my system, thx in advance :)
> 
> ubuntu hardy
> uname -r
> 2.6.24-19-generic
> 
> latest firmware dvb-ttpci-01.fw-2622

No, see below.

> Technotrend Premium S-2300 "modded" identical to Hauppauge Nexus-S 2.3, but additional Features
> Technotrend Premium 3.5" CI (Common Interface)
> 
> lsmod | egrep dvb
> dvb_ttpci             104008  1 
> dvb_core               81404  2 dvb_ttpci,stv0299
> saa7146_vv             50304  1 dvb_ttpci
> saa7146                20360  2 dvb_ttpci,saa7146_vv
> ttpci_eeprom            3456  1 dvb_ttpci
> i2c_core               24832  4 dvb_ttpci,lnbp21,stv0299,ttpci_eeprom
> 
> ls /dev/dvb/adapter0/
> audio0     ca0        demux0     dvr0       frontend0  net0       osd0       video0 
> 
> lspci -v
> 01:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: Technotrend Systemtechnik GmbH Unknown device 000e
>         Flags: bus master, medium devsel, latency 64, IRQ 20
>         Memory at febffc00 (32-bit, non-prefetchable) [size=512]
> 
> lspci -nn
> 01:04.0 PCI bridge [0604]: Hint Corp HB6 Universal PCI-PCI bridge (non-transparent mode) [3388:0021] (rev 11)
> 01:06.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 [1131:7146] (rev 01) 
> 
> 
> dmesg boot info:
> [   25.427881] saa7146: register extension 'dvb'.
> [   25.428202] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 19
> [   25.428208] ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [LNKB] -> GSI 19 (level, low) -> IRQ 20
> [   25.428230] saa7146: found saa7146 @ mem f8a56c00 (revision 1, irq 20) (0x13c2,0x000e).
> [   25.510688] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23
> 
> [   25.782505] DVB: registering new adapter (Technotrend/Hauppauge WinTV Nexus-S rev2.3)
> [   25.818655] adapter has MAC addr = 00:d0:5c:09:59:65
> [   26.026874] dvb-ttpci: gpioirq unknown type=0 len=0
> [   26.040478] dvb-ttpci: info @ card 0: firm f0240009, rtsl b0250018, vid 71010068, app 8000261c

You are using the fw 261c.

> ...
> [640529.411541] dvb-ttpci: __av7110_send_fw_cmd(): timeout waiting for COMMAND idle
> [640529.411551] dvb-ttpci: av7110_send_fw_cmd(): av7110_send_fw_cmd error -110
> [640529.411554] dvb-ttpci: av7110_fw_cmd error -110
> [640742.112314] dvb-ttpci: __av7110_send_fw_cmd(): timeout waiting for COMMAND idle
> [640742.112324] dvb-ttpci: av7110_send_fw_cmd(): av7110_send_fw_cmd error -110
> [640742.112327] dvb-ttpci: av7110_fw_cmd error -110

This is an ARM crash.

> [657733.380748] console-kit-dae[10180]: segfault at 00000000 eip b7e72677 esp bf8ceb44 error 4

???

> [662729.894931] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
> [663112.576098] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
> [663367.977312] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
> [663739.169201] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
> [664251.914035] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
> [664451.448936] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
> [664581.441263] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
> [664788.406786] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
> [665572.507224] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
> [665857.162666] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
> [666271.421151] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
> [667786.852007] DVB: frontend 0 frequency 4285217296 out of range (950000..2150000)

What are you doing here?

First of all you should try a recent firmware.
Please update the firmware to 2622 or to the lastest one
http://www.suse.de/~werner/test_av-f12623.tar.bz2

If this doesn not help, the ARM crash might be caused by a bad signal.
Currently there is no fix for this problem. Sorry.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
