Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web36104.mail.mud.yahoo.com ([66.163.179.218])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <knueffle@yahoo.com>) id 1KU8fC-0004qK-9j
	for linux-dvb@linuxtv.org; Sat, 16 Aug 2008 01:25:00 +0200
Date: Fri, 15 Aug 2008 16:24:22 -0700 (PDT)
From: Jody Gugelhupf <knueffle@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <920268.8615.qm@web36104.mail.mud.yahoo.com>
Subject: [linux-dvb] problem with dvb-ttpci-01.fw-2622 and
	technotrend/hauppauge nexus-s 2.3
Reply-To: knueffle@yahoo.com
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

Hi people, 
I wrote a script to grab some xml data, in order to do, xine switches channels every 50 seconds for about 150 times. At some point the card stops working and I get error like this:
[672227.942674] dvb-ttpci: StopHWFilter error  cmd 0b08 0001 0001  ret ffffff92  resp 0000 0000  pid 0
[672228.944141] dvb-ttpci: __av7110_send_fw_cmd(): timeout waiting for COMMAND idle
[672228.944150] dvb-ttpci: av7110_send_fw_cmd(): av7110_send_fw_cmd error -110
[672228.944154] dvb-ttpci: av7110_fw_cmd error -110
when i remove and readd the module it works fine again. Anyone has an idea why this happens and what I can do? Below is some information about my system, thx in advance :)

ubuntu hardy
uname -r
2.6.24-19-generic

latest firmware dvb-ttpci-01.fw-2622

Technotrend Premium S-2300 "modded" identical to Hauppauge Nexus-S 2.3, but additional Features
Technotrend Premium 3.5" CI (Common Interface)

lsmod | egrep dvb
dvb_ttpci             104008  1 
dvb_core               81404  2 dvb_ttpci,stv0299
saa7146_vv             50304  1 dvb_ttpci
saa7146                20360  2 dvb_ttpci,saa7146_vv
ttpci_eeprom            3456  1 dvb_ttpci
i2c_core               24832  4 dvb_ttpci,lnbp21,stv0299,ttpci_eeprom

ls /dev/dvb/adapter0/
audio0     ca0        demux0     dvr0       frontend0  net0       osd0       video0 

lspci -v
01:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: Technotrend Systemtechnik GmbH Unknown device 000e
        Flags: bus master, medium devsel, latency 64, IRQ 20
        Memory at febffc00 (32-bit, non-prefetchable) [size=512]

lspci -nn
01:04.0 PCI bridge [0604]: Hint Corp HB6 Universal PCI-PCI bridge (non-transparent mode) [3388:0021] (rev 11)
01:06.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 [1131:7146] (rev 01) 


dmesg boot info:
[   25.427881] saa7146: register extension 'dvb'.
[   25.428202] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 19
[   25.428208] ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [LNKB] -> GSI 19 (level, low) -> IRQ 20
[   25.428230] saa7146: found saa7146 @ mem f8a56c00 (revision 1, irq 20) (0x13c2,0x000e).
[   25.510688] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23

[   25.782505] DVB: registering new adapter (Technotrend/Hauppauge WinTV Nexus-S rev2.3)
[   25.818655] adapter has MAC addr = 00:d0:5c:09:59:65
[   26.026874] dvb-ttpci: gpioirq unknown type=0 len=0
[   26.040478] dvb-ttpci: info @ card 0: firm f0240009, rtsl b0250018, vid 71010068, app 8000261c
[   26.040482] dvb-ttpci: firmware @ card 0 supports CI link layer interface
[   26.088477] dvb-ttpci: Crystal audio DAC @ card 0 detected
[   26.089308] saa7146_vv: saa7146 (0): registered device video0 [v4l2]
[   26.089334] saa7146_vv: saa7146 (0): registered device vbi0 [v4l2]
[   26.371054] DVB: registering frontend 0 (ST STV0299 DVB-S)...
[   26.371194] input: DVB on-card IR receiver as /devices/pci0000:00/0000:00:0a.0/0000:01:06.0/input/input6
[   26.403884] dvb-ttpci: found av7110-0.

[640529.411541] dvb-ttpci: __av7110_send_fw_cmd(): timeout waiting for COMMAND idle
[640529.411551] dvb-ttpci: av7110_send_fw_cmd(): av7110_send_fw_cmd error -110
[640529.411554] dvb-ttpci: av7110_fw_cmd error -110
[640742.112314] dvb-ttpci: __av7110_send_fw_cmd(): timeout waiting for COMMAND idle
[640742.112324] dvb-ttpci: av7110_send_fw_cmd(): av7110_send_fw_cmd error -110
[640742.112327] dvb-ttpci: av7110_fw_cmd error -110
[641562.379076] saa7146: unregister extension 'dvb'.
[641562.423894] ACPI: PCI interrupt for device 0000:01:06.0 disabled
[641581.018825] saa7146: register extension 'dvb'.
[641581.018884] ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [LNKB] -> GSI 19 (level, low) -> IRQ 20
[641581.018911] saa7146: found saa7146 @ mem f8a56c00 (revision 1, irq 20) (0x13c2,0x000e).
[641581.026868] DVB: registering new adapter (Technotrend/Hauppauge WinTV Nexus-S rev2.3)
[641581.028020] adapter has MAC addr = 00:d0:5c:09:59:65
[641581.235601] dvb-ttpci: gpioirq unknown type=0 len=0
[641581.253212] dvb-ttpci: info @ card 0: firm f0240009, rtsl b0250018, vid 71010068, app 8000261c
[641581.253217] dvb-ttpci: firmware @ card 0 supports CI link layer interface
[641581.301578] dvb-ttpci: Crystal audio DAC @ card 0 detected
[641581.306080] saa7146_vv: saa7146 (0): registered device video0 [v4l2]
[641581.306110] saa7146_vv: saa7146 (0): registered device vbi0 [v4l2]
[641581.509076] DVB: registering frontend 0 (ST STV0299 DVB-S)...
[641581.509230] input: DVB on-card IR receiver as /devices/pci0000:00/0000:00:0a.0/0000:01:06.0/input/input7
[641581.552726] dvb-ttpci: found av7110-0.
[657733.380748] console-kit-dae[10180]: segfault at 00000000 eip b7e72677 esp bf8ceb44 error 4
[662729.894931] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
[663112.576098] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
[663367.977312] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
[663739.169201] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
[664251.914035] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
[664451.448936] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
[664581.441263] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
[664788.406786] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
[665572.507224] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
[665857.162666] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
[666271.421151] DVB: frontend 0 frequency 4285221296 out of range (950000..2150000)
[667786.852007] DVB: frontend 0 frequency 4285217296 out of range (950000..2150000)
[672227.942662] av7110_fw_request: timeout waiting for COMMAND to complete
[672227.942674] dvb-ttpci: StopHWFilter error  cmd 0b08 0001 0001  ret ffffff92  resp 0000 0000  pid 0
[672228.944141] dvb-ttpci: __av7110_send_fw_cmd(): timeout waiting for COMMAND idle
[672228.944150] dvb-ttpci: av7110_send_fw_cmd(): av7110_send_fw_cmd error -110
[672228.944154] dvb-ttpci: av7110_fw_cmd error -110
[672229.950612] dvb-ttpci: __av7110_send_fw_cmd(): timeout waiting for COMMAND idle
[672229.950621] dvb-ttpci: av7110_fw_request error -110
[672229.950627] dvb-ttpci: StopHWFilter error  cmd 0b08 0001 0000  ret ffffff92  resp 0000 0000  pid 32
[672230.957087] dvb-ttpci: __av7110_send_fw_cmd(): timeout waiting for COMMAND idle
[672230.957097] dvb-ttpci: av7110_fw_request error -110
[672230.957103] dvb-ttpci: StopHWFilter error  cmd 0b08 0001 0002  ret ffffff92  resp 0000 0000  pid 18
[672231.963553] dvb-ttpci: __av7110_send_fw_cmd(): timeout waiting for COMMAND idle
[672231.963562] dvb-ttpci: av7110_send_fw_cmd(): av7110_send_fw_cmd error -110
[672231.963566] dvb-ttpci: av7110_fw_cmd error -110
[672232.970024] dvb-ttpci: __av7110_send_fw_cmd(): timeout waiting for COMMAND idle
[672232.970032] dvb-ttpci: av7110_send_fw_cmd(): av7110_send_fw_cmd error -110
[672232.970036] dvb-ttpci: av7110_fw_cmd error -110
[672233.977506] dvb-ttpci: __av7110_send_fw_cmd(): timeout waiting for COMMAND idle
[672233.977516] dvb-ttpci: av7110_send_fw_cmd(): av7110_send_fw_cmd error -110
[672233.977519] dvb-ttpci: av7110_fw_cmd error -110
[672233.978034] dvb-ttpci: ARM crashed @ card 0
[672234.188604] dvb-ttpci: gpioirq unknown type=0 len=0
[672234.245233] dvb-ttpci: Crystal audio DAC @ card 0 detected
[707835.552702] console-kit-dae[22786]: segfault at 00000000 eip b7e96677 esp bff2a994 error 4
[717539.491486] saa7146: unregister extension 'dvb'.
[717539.529651] ACPI: PCI interrupt for device 0000:01:06.0 disabled
[717548.941832] saa7146: register extension 'dvb'.
[717548.941885] ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [LNKB] -> GSI 19 (level, low) -> IRQ 20
[717548.941907] saa7146: found saa7146 @ mem f8a56c00 (revision 1, irq 20) (0x13c2,0x000e).
[717548.946517] DVB: registering new adapter (Technotrend/Hauppauge WinTV Nexus-S rev2.3)
[717548.947470] adapter has MAC addr = 00:d0:5c:09:59:65
[717549.153883] dvb-ttpci: gpioirq unknown type=0 len=0
[717549.170493] dvb-ttpci: info @ card 0: firm f0240009, rtsl b0250018, vid 71010068, app 8000261c
[717549.170498] dvb-ttpci: firmware @ card 0 supports CI link layer interface
[717549.219823] dvb-ttpci: Crystal audio DAC @ card 0 detected
[717549.221041] saa7146_vv: saa7146 (0): registered device video0 [v4l2]
[717549.221070] saa7146_vv: saa7146 (0): registered device vbi0 [v4l2]
[717549.426352] DVB: registering frontend 0 (ST STV0299 DVB-S)...
[717549.426504] input: DVB on-card IR receiver as /devices/pci0000:00/0000:00:0a.0/0000:01:06.0/input/input8
[717549.469987] dvb-ttpci: found av7110-0.
[721035.618698] console-kit-dae[628]: segfault at 00000000 eip b7ec8677 esp bf9863f4 error 4
[738673.540966] lirc_dev: IR Remote Control driver registered, at major 61 
[745805.785523] console-kit-dae[2664]: segfault at 00000000 eip b7e68677 esp bfa3e4b4 error 4
[817817.076801] dvb-ttpci: StartHWFilter error  buf 0b07 0010 001c b96a  ret 0  handle ffff
[817847.578450] dvb-ttpci: StartHWFilter error  buf 0b07 0010 0037 b96a  ret 0  handle ffff
[817878.072111] dvb-ttpci: StartHWFilter error  buf 0b07 0010 0052 b96a  ret 0  handle ffff
[817878.763059] dvb-ttpci: StartHWFilter error  buf 0b07 0010 006d b96a  ret 0  handle ffff
[817879.454009] dvb-ttpci: StartHWFilter error  buf 0b07 0010 0088 b96a  ret 0  handle ffff
[817880.144960] dvb-ttpci: StartHWFilter error  buf 0b07 0010 00a3 b96a  ret 0  handle ffff
[817880.836903] dvb-ttpci: StartHWFilter error  buf 0b07 0010 00be b96a  ret 0  handle ffff
[817881.527854] dvb-ttpci: StartHWFilter error  buf 0b07 0010 00d9 b96a  ret 0  handle ffff
[817882.218812] dvb-ttpci: StartHWFilter error  buf 0b07 0010 00f4 b96a  ret 0  handle ffff
[817882.909753] dvb-ttpci: StartHWFilter error  buf 0b07 0010 010f b96a  ret 0  handle ffff
[817883.600704] dvb-ttpci: StartHWFilter error  buf 0b07 0010 012a b96a  ret 0  handle ffff

jody :)


      __________________________________________________________________
Instant Messaging, free SMS, sharing photos and more... Try the new Yahoo! Canada Messenger at http://ca.beta.messenger.yahoo.com/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
