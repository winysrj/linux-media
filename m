Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <martin.rudge@googlemail.com>) id 1KuoAb-00088a-VK
	for linux-dvb@linuxtv.org; Tue, 28 Oct 2008 13:59:38 +0100
Received: by yx-out-2324.google.com with SMTP id 8so611964yxg.41
	for <linux-dvb@linuxtv.org>; Tue, 28 Oct 2008 05:59:33 -0700 (PDT)
Message-ID: <966d86d70810280559w644c5849i8fd9035e0283821c@mail.gmail.com>
Date: Tue, 28 Oct 2008 12:59:33 +0000
From: "Martin Rudge" <martin.rudge@googlemail.com>
To: linuxdvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: [linux-dvb] Audio processor not found using WINTV-Nova-HD-S2 Card
	(HVR4000Lite)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0630595981=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0630595981==
Content-Type: multipart/alternative;
	boundary="----=_Part_54915_26169499.1225198773122"

------=_Part_54915_26169499.1225198773122
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I was working my way through building/testing the driver for my card (per
the wiki) last night.
Scanned ok, szap ok (able to apparently zap and lock both SD and HD
channels).

However, I had noticed that I am apparently missing an audio device
according to the dmesg log.
I am also seeing a number of cx8802_start_dma failures being logged during
use.

Is anyone else experiencing this with the subject card?  If so I may have a
configuration problem that I need to investigate further.

I notice that the mpeg video was created as /dev/video0 and not associated
with the adapter under /dev/dvb/adapter0 as I had expected.  Is this working
as designed?

dmesg output:
[   11.957865] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   11.957865] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[   11.957866] ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [APC2] -> GSI 17
(level, low) -> IRQ 17
[   11.957866] cx88[0]: subsystem: 0070:6906, board: Hauppauge
WinTV-HVR4000(Lite) DVB-S/S2 [card=69,autodetected], frontend(s): 1
[   11.957866] cx88[0]: TV tuner type -1, Radio tuner type -1
[   11.973865] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   12.018573] cx2388x alsa driver version 0.0.6 loaded
[   12.179623] tveeprom 0-0050: Hauppauge model 69100, rev B2C3, serial#
2898725
[   12.179623] tveeprom 0-0050: MAC address is 00-0D-FE-2C-3B-25
[   12.179623] tveeprom 0-0050: tuner model is Conexant CX24118A (idx 123,
type 4)
[   12.179623] tveeprom 0-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
*
[   12.179623] tveeprom 0-0050: audio processor is None (idx 0)*

[   12.179623] tveeprom 0-0050: decoder processor is CX882 (idx 25)
[   12.179623] tveeprom 0-0050: has no radio, has IR receiver, has no IR
transmitter
[   12.179623] cx88[0]: hauppauge eeprom: model=69100
[   12.179623] input: cx88 IR (Hauppauge WinTV-HVR400 as /class/input/input4
[   12.212342] cx88[0]/0: found at 0000:01:06.0, rev: 5, irq: 17, latency:
32, mmio: 0xe3000000
[   12.212382] cx88[0]/0: registered device video0 [v4l2]
[   12.212399] cx88[0]/0: registered device vbi0
[   12.212811] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 23
[   12.212813] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [AAZA] -> GSI 23
(level, low) -> IRQ 23
[   12.212825] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   12.215620] cx88[0]/2: cx2388x 8802 Driver Manager
[   12.215630] ACPI: PCI Interrupt 0000:01:06.2[A] -> Link [APC2] -> GSI 17
(level, low) -> IRQ 17
[   12.215637] cx88[0]/2: found at 0000:01:06.2, rev: 5, irq: 17, latency:
32, mmio: 0xe5000000
[   12.215640] cx8802_probe() allocating 1 frontend(s)
[   12.236915] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   12.236915] cx88/2: registering cx8802 driver, type: dvb access: shared
[   12.236915] cx88[0]/2: subsystem: 0070:6906, board: Hauppauge
WinTV-HVR4000(Lite) DVB-S/S2 [card=69]
[   12.236915] cx88[0]/2: cx2388x based DVB/ATSC card
[   12.249829] hda_codec: Unknown model for ALC662, trying auto-probe from
BIOS...
[   12.281623] ACPI: PCI Interrupt 0000:01:06.1[A] -> Link [APC2] -> GSI 17
(level, low) -> IRQ 17
[   12.281641] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[   12.551931] DVB: registering new adapter (cx88[0])
[   12.551934] DVB: registering adapter 0 frontend 0 (Conexant
CX24116/CX24118)...
... SNIP ...
[  655.269584] cx24116_firmware_ondemand: Waiting for firmware upload
(dvb-fe-cx24116.fw)...
[  655.269589] firmware: requesting dvb-fe-cx24116.fw
[  655.373586] cx24116_firmware_ondemand: Waiting for firmware upload(2)...
[  660.357302] cx24116_load_firmware: FW version 1.22.82.0
[  660.357302] cx24116_firmware_ondemand: Firmware upload complete
*
[ 4620.026254] cx8802_start_dma() Failed. Unsupported value in .mpeg
(0x00000001)
[ 4620.532266] cx8802_start_dma() Failed. Unsupported value in .mpeg
(0x00000001)

*Environment:
  Debian Lenny (Linux 2.6.26-1-amd64 #1 SMP)
  GCC: gcc (Debian 4.3.2-1) 4.3.2
  Driver level: changeset: 9471:8486cbf6af4e, tag: tip
  Firmware file/level dvb-fe-cx24116-1.22.82.0.fw

Cheers
Martin ...

------=_Part_54915_26169499.1225198773122
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br><br>I was working my way through building/testing the driver for my card (per the wiki) last night.<br>Scanned ok, szap ok (able to apparently zap and lock both SD and HD channels).<br><br>However, I had noticed that I am apparently missing an audio device according to the dmesg log. <br>
I am also seeing a number of cx8802_start_dma failures being logged during use.<br><br>Is anyone else experiencing this with the subject card?&nbsp; If so I may have a configuration problem that I need to investigate further.<br>
<br>
I notice that the mpeg video was created as /dev/video0 and not associated with the adapter under /dev/dvb/adapter0 as I had expected.&nbsp; Is this working as designed?<br>
<br>dmesg output:<br>[&nbsp;&nbsp; 11.957865] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded<br>[&nbsp;&nbsp; 11.957865] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17<br>[&nbsp;&nbsp; 11.957866] ACPI: PCI Interrupt 0000:01:06.0[A] -&gt; Link [APC2] -&gt; GSI 17 (level, low) -&gt; IRQ 17<br>
[&nbsp;&nbsp; 11.957866] cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69,autodetected], frontend(s): 1<br>[&nbsp;&nbsp; 11.957866] cx88[0]: TV tuner type -1, Radio tuner type -1<br>[&nbsp;&nbsp; 11.973865] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded<br>
[&nbsp;&nbsp; 12.018573] cx2388x alsa driver version 0.0.6 loaded<br>[&nbsp;&nbsp; 12.179623] tveeprom 0-0050: Hauppauge model 69100, rev B2C3, serial# 2898725<br>[&nbsp;&nbsp; 12.179623] tveeprom 0-0050: MAC address is 00-0D-FE-2C-3B-25<br>[&nbsp;&nbsp; 12.179623] tveeprom 0-0050: tuner model is Conexant CX24118A (idx 123, type 4)<br>
[&nbsp;&nbsp; 12.179623] tveeprom 0-0050: TV standards ATSC/DVB Digital (eeprom 0x80)<br><b><br>[&nbsp;&nbsp; 12.179623] tveeprom 0-0050: audio processor is None (idx 0)</b><br><br>[&nbsp;&nbsp; 12.179623] tveeprom 0-0050: decoder processor is CX882 (idx 25)<br>
[&nbsp;&nbsp; 12.179623] tveeprom 0-0050: has no radio, has IR receiver, has no IR transmitter<br>[&nbsp;&nbsp; 12.179623] cx88[0]: hauppauge eeprom: model=69100<br>[&nbsp;&nbsp; 12.179623] input: cx88 IR (Hauppauge WinTV-HVR400 as /class/input/input4<br>
[&nbsp;&nbsp; 12.212342] cx88[0]/0: found at 0000:01:06.0, rev: 5, irq: 17, latency: 32, mmio: 0xe3000000<br>[&nbsp;&nbsp; 12.212382] cx88[0]/0: registered device video0 [v4l2]<br>[&nbsp;&nbsp; 12.212399] cx88[0]/0: registered device vbi0<br>[&nbsp;&nbsp; 12.212811] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 23<br>
[&nbsp;&nbsp; 12.212813] ACPI: PCI Interrupt 0000:00:09.0[A] -&gt; Link [AAZA] -&gt; GSI 23 (level, low) -&gt; IRQ 23<br>[&nbsp;&nbsp; 12.212825] PCI: Setting latency timer of device 0000:00:09.0 to 64<br>[&nbsp;&nbsp; 12.215620] cx88[0]/2: cx2388x 8802 Driver Manager<br>
[&nbsp;&nbsp; 12.215630] ACPI: PCI Interrupt 0000:01:06.2[A] -&gt; Link [APC2] -&gt; GSI 17 (level, low) -&gt; IRQ 17<br>[&nbsp;&nbsp; 12.215637] cx88[0]/2: found at 0000:01:06.2, rev: 5, irq: 17, latency: 32, mmio: 0xe5000000<br>[&nbsp;&nbsp; 12.215640] cx8802_probe() allocating 1 frontend(s)<br>
[&nbsp;&nbsp; 12.236915] cx88/2: cx2388x dvb driver version 0.0.6 loaded<br>[&nbsp;&nbsp; 12.236915] cx88/2: registering cx8802 driver, type: dvb access: shared<br>[&nbsp;&nbsp; 12.236915] cx88[0]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 [card=69]<br>
[&nbsp;&nbsp; 12.236915] cx88[0]/2: cx2388x based DVB/ATSC card<br>[&nbsp;&nbsp; 12.249829] hda_codec: Unknown model for ALC662, trying auto-probe from BIOS...<br>[&nbsp;&nbsp; 12.281623] ACPI: PCI Interrupt 0000:01:06.1[A] -&gt; Link [APC2] -&gt; GSI 17 (level, low) -&gt; IRQ 17<br>
[&nbsp;&nbsp; 12.281641] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards<br>[&nbsp;&nbsp; 12.551931] DVB: registering new adapter (cx88[0])<br>[&nbsp;&nbsp; 12.551934] DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX24118)...<br> ... SNIP ...<br>
[&nbsp; 655.269584] cx24116_firmware_ondemand: Waiting for firmware upload (dvb-fe-cx24116.fw)...<br>[&nbsp; 655.269589] firmware: requesting dvb-fe-cx24116.fw<br>[&nbsp; 655.373586] cx24116_firmware_ondemand: Waiting for firmware upload(2)...<br>
[&nbsp; 660.357302] cx24116_load_firmware: FW version <a href="http://1.22.82.0">1.22.82.0</a><br>[&nbsp; 660.357302] cx24116_firmware_ondemand: Firmware upload complete<br><b><br>[ 4620.026254] cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)<br>
[ 4620.532266] cx8802_start_dma() Failed. Unsupported value in .mpeg (0x00000001)<br><br></b>Environment: <br>

&nbsp; Debian Lenny (Linux 2.6.26-1-amd64 #1 SMP) <br>
&nbsp; GCC: gcc (Debian 4.3.2-1) 4.3.2<br>
&nbsp; Driver level: changeset: 9471:8486cbf6af4e, tag: tip<br>
&nbsp; Firmware file/level dvb-fe-cx24116-1.22.82.0.fw<br>

<br>Cheers<br>Martin ...<br>

------=_Part_54915_26169499.1225198773122--


--===============0630595981==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0630595981==--
