Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mikerussellnz@gmail.com>) id 1JfAro-0007GT-LW
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 10:27:22 +0100
Received: by py-out-1112.google.com with SMTP id a29so200577pyi.0
	for <linux-dvb@linuxtv.org>; Fri, 28 Mar 2008 02:26:54 -0700 (PDT)
Message-ID: <c112e7e90803280226h49820354r6520ca723e3a3584@mail.gmail.com>
Date: Fri, 28 Mar 2008 22:26:53 +1300
From: "Mike Russell" <mikerussellnz@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] HVR-3000 - cx22702 DVB-T Problem cx22702_readreg: /
	cx22702_writereg:
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0057595266=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0057595266==
Content-Type: multipart/alternative;
	boundary="----=_Part_13803_5249230.1206696414170"

------=_Part_13803_5249230.1206696414170
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

I am currently having problems getting this card working under 2.6.24 for
DVB-T.  The driver appears to load ok, but produces errors in dmesg when
attempting to scan for channels.

Below are the log sections from the driver loading and also the errors that
are generated when trying to scan for channels.

Any help on this would be greatly appreciated.  I am happy to provide any
info that would help.

Thanks


cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
ACPI: PCI Interrupt 0000:05:08.0[A] -> Link [APC3] -> GSI 18 (level, low) ->
IRQ 18
cx88[0]: subsystem: 0070:1402, board: Hauppauge WinTV-HVR3000 TriMode
Analog/DVB-S/DVB-T [card=53,autodetected]
cx88[0]: TV tuner type 63, Radio tuner type -1
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
tveeprom 2-0050: Hauppauge model 14109, rev B3D3, serial# 2687674
tveeprom 2-0050: MAC address is 00-0D-FE-29-02-BA
tveeprom 2-0050: tuner model is Philips FMD1216MEX (idx 133, type 63)
tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K)
ATSC/DVB Digital (eeprom 0xf4)
tveeprom 2-0050: audio processor is CX882 (idx 33)
tveeprom 2-0050: decoder processor is CX882 (idx 25)
tveeprom 2-0050: has radio, has IR receiver, has no IR transmitter
cx88[0]: hauppauge eeprom: model=14109
input: cx88 IR (Hauppauge WinTV-HVR300 as /class/input/input6
cx88[0]/0: found at 0000:05:08.0, rev: 5, irq: 18, latency: 32, mmio:
0xd0000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cannot find the slot for index 1 (range 0-1), error: -16
cx88_audio: probe of 0000:05:08.1 failed with error -12
cx88[0]/2: cx2388x 8802 Driver Manager
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:1402, board: Hauppauge WinTV-HVR3000 TriMode
Analog/DVB-S/DVB-T [card=53]
cx88[0]/2: cx2388x based DVB/ATSC card
tuner-simple 2-0061: creating new instance
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (cx88[0])
DVB: registering frontend 0 (Conexant CX22702 DVB-T)...
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x00, ret == -121)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x01, ret == -121)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x00, ret == -121)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x01, ret == -121)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x00, ret == -121)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x01, ret == -121)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x00, ret == -121)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x01, ret == -121)


and scanning produces the following in dmesg:

cx22702_writereg: writereg error (reg == 0x00, val == 0x02, ret == -121)
cx22702_writereg: writereg error (reg == 0x00, val == 0x00, ret == -121)
cx22702_writereg: writereg error (reg == 0x0b, val == 0x06, ret == -121)
cx22702_writereg: writereg error (reg == 0x09, val == 0x01, ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x41, ret == -121)
cx22702_writereg: writereg error (reg == 0x16, val == 0x32, ret == -121)
cx22702_writereg: writereg error (reg == 0x20, val == 0x0a, ret == -121)
cx22702_writereg: writereg error (reg == 0x21, val == 0x17, ret == -121)
cx22702_writereg: writereg error (reg == 0x24, val == 0x3e, ret == -121)
cx22702_writereg: writereg error (reg == 0x26, val == 0xff, ret == -121)
cx22702_writereg: writereg error (reg == 0x27, val == 0x10, ret == -121)
cx22702_writereg: writereg error (reg == 0x28, val == 0x00, ret == -121)
cx22702_writereg: writereg error (reg == 0x29, val == 0x00, ret == -121)
cx22702_writereg: writereg error (reg == 0x2a, val == 0x10, ret == -121)
cx22702_writereg: writereg error (reg == 0x2b, val == 0x00, ret == -121)
cx22702_writereg: writereg error (reg == 0x2c, val == 0x10, ret == -121)
cx22702_writereg: writereg error (reg == 0x2d, val == 0x00, ret == -121)
cx22702_writereg: writereg error (reg == 0x48, val == 0xd4, ret == -121)
cx22702_writereg: writereg error (reg == 0x49, val == 0x56, ret == -121)
cx22702_writereg: writereg error (reg == 0x6b, val == 0x1e, ret == -121)
cx22702_writereg: writereg error (reg == 0xc8, val == 0x02, ret == -121)
cx22702_writereg: writereg error (reg == 0xf9, val == 0x00, ret == -121)
cx22702_writereg: writereg error (reg == 0xfa, val == 0x00, ret == -121)
cx22702_writereg: writereg error (reg == 0xfb, val == 0x00, ret == -121)
cx22702_writereg: writereg error (reg == 0xfc, val == 0x00, ret == -121)
cx22702_writereg: writereg error (reg == 0xfd, val == 0x00, ret == -121)
cx22702_writereg: writereg error (reg == 0xf8, val == 0x02, ret == -121)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x01, ret == -121)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x00, ret == -121)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x01, ret == -121)
cx22702_readreg: readreg error (ret == -121)
cx22702_writereg: writereg error (reg == 0x0d, val == 0x00, ret == -121)
cx22702_readreg: readreg error (ret == -121)

------=_Part_13803_5249230.1206696414170
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi<br><br>I am currently having problems getting this card working under 2.6.24 for DVB-T.&nbsp; The driver appears to load ok, but produces errors in dmesg when attempting to scan for channels. <br><br>Below are the log sections from the driver loading and also the errors that are generated when trying to scan for channels.<br>
<br>Any help on this would be greatly appreciated.&nbsp; I am happy to provide any info that would help.<br><br>Thanks<br><br><br>cx88/0: cx2388x v4l2 driver version 0.0.6 loaded<br>ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18<br>
ACPI: PCI Interrupt 0000:05:08.0[A] -&gt; Link [APC3] -&gt; GSI 18 (level, low) -&gt; IRQ 18<br>cx88[0]: subsystem: 0070:1402, board: Hauppauge WinTV-HVR3000 TriMode Analog/DVB-S/DVB-T [card=53,autodetected]<br>cx88[0]: TV tuner type 63, Radio tuner type -1<br>
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded<br>tveeprom 2-0050: Hauppauge model 14109, rev B3D3, serial# 2687674<br>tveeprom 2-0050: MAC address is 00-0D-FE-29-02-BA<br>tveeprom 2-0050: tuner model is Philips FMD1216MEX (idx 133, type 63)<br>
tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L&#39;) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)<br>tveeprom 2-0050: audio processor is CX882 (idx 33)<br>tveeprom 2-0050: decoder processor is CX882 (idx 25)<br>tveeprom 2-0050: has radio, has IR receiver, has no IR transmitter<br>
cx88[0]: hauppauge eeprom: model=14109<br>input: cx88 IR (Hauppauge WinTV-HVR300 as /class/input/input6<br>cx88[0]/0: found at 0000:05:08.0, rev: 5, irq: 18, latency: 32, mmio: 0xd0000000<br>cx88[0]/0: registered device video0 [v4l2]<br>
cx88[0]/0: registered device vbi0<br>cx88[0]/0: registered device radio0<br>cannot find the slot for index 1 (range 0-1), error: -16<br>cx88_audio: probe of 0000:05:08.1 failed with error -12<br>cx88[0]/2: cx2388x 8802 Driver Manager<br>
cx88/2: cx2388x dvb driver version 0.0.6 loaded<br>cx88/2: registering cx8802 driver, type: dvb access: shared<br>cx88[0]/2: subsystem: 0070:1402, board: Hauppauge WinTV-HVR3000 TriMode Analog/DVB-S/DVB-T [card=53]<br>cx88[0]/2: cx2388x based DVB/ATSC card<br>
tuner-simple 2-0061: creating new instance<br>tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)<br>DVB: registering new adapter (cx88[0])<br>DVB: registering frontend 0 (Conexant CX22702 DVB-T)...<br>
cx22702_readreg: readreg error (ret == -121)<br>cx22702_writereg: writereg error (reg == 0x0d, val == 0x00, ret == -121)<br>cx22702_readreg: readreg error (ret == -121)<br>cx22702_writereg: writereg error (reg == 0x0d, val == 0x01, ret == -121)<br>
cx22702_readreg: readreg error (ret == -121)<br>cx22702_writereg: writereg error (reg == 0x0d, val == 0x00, ret == -121)<br>cx22702_readreg: readreg error (ret == -121)<br>cx22702_writereg: writereg error (reg == 0x0d, val == 0x01, ret == -121)<br>
cx22702_readreg: readreg error (ret == -121)<br>cx22702_writereg: writereg error (reg == 0x0d, val == 0x00, ret == -121)<br>cx22702_readreg: readreg error (ret == -121)<br>cx22702_writereg: writereg error (reg == 0x0d, val == 0x01, ret == -121)<br>
cx22702_readreg: readreg error (ret == -121)<br>cx22702_writereg: writereg error (reg == 0x0d, val == 0x00, ret == -121)<br>cx22702_readreg: readreg error (ret == -121)<br>cx22702_writereg: writereg error (reg == 0x0d, val == 0x01, ret == -121)<br>
<br><br>and scanning produces the following in dmesg:<br><br>cx22702_writereg: writereg error (reg == 0x00, val == 0x02, ret == -121)<br>cx22702_writereg: writereg error (reg == 0x00, val == 0x00, ret == -121)<br>cx22702_writereg: writereg error (reg == 0x0b, val == 0x06, ret == -121)<br>
cx22702_writereg: writereg error (reg == 0x09, val == 0x01, ret == -121)<br>cx22702_writereg: writereg error (reg == 0x0d, val == 0x41, ret == -121)<br>cx22702_writereg: writereg error (reg == 0x16, val == 0x32, ret == -121)<br>
cx22702_writereg: writereg error (reg == 0x20, val == 0x0a, ret == -121)<br>cx22702_writereg: writereg error (reg == 0x21, val == 0x17, ret == -121)<br>cx22702_writereg: writereg error (reg == 0x24, val == 0x3e, ret == -121)<br>
cx22702_writereg: writereg error (reg == 0x26, val == 0xff, ret == -121)<br>cx22702_writereg: writereg error (reg == 0x27, val == 0x10, ret == -121)<br>cx22702_writereg: writereg error (reg == 0x28, val == 0x00, ret == -121)<br>
cx22702_writereg: writereg error (reg == 0x29, val == 0x00, ret == -121)<br>cx22702_writereg: writereg error (reg == 0x2a, val == 0x10, ret == -121)<br>cx22702_writereg: writereg error (reg == 0x2b, val == 0x00, ret == -121)<br>
cx22702_writereg: writereg error (reg == 0x2c, val == 0x10, ret == -121)<br>cx22702_writereg: writereg error (reg == 0x2d, val == 0x00, ret == -121)<br>cx22702_writereg: writereg error (reg == 0x48, val == 0xd4, ret == -121)<br>
cx22702_writereg: writereg error (reg == 0x49, val == 0x56, ret == -121)<br>cx22702_writereg: writereg error (reg == 0x6b, val == 0x1e, ret == -121)<br>cx22702_writereg: writereg error (reg == 0xc8, val == 0x02, ret == -121)<br>
cx22702_writereg: writereg error (reg == 0xf9, val == 0x00, ret == -121)<br>cx22702_writereg: writereg error (reg == 0xfa, val == 0x00, ret == -121)<br>cx22702_writereg: writereg error (reg == 0xfb, val == 0x00, ret == -121)<br>
cx22702_writereg: writereg error (reg == 0xfc, val == 0x00, ret == -121)<br>cx22702_writereg: writereg error (reg == 0xfd, val == 0x00, ret == -121)<br>cx22702_writereg: writereg error (reg == 0xf8, val == 0x02, ret == -121)<br>
cx22702_readreg: readreg error (ret == -121)<br>cx22702_writereg: writereg error (reg == 0x0d, val == 0x01, ret == -121)<br>cx22702_readreg: readreg error (ret == -121)<br>cx22702_writereg: writereg error (reg == 0x0d, val == 0x00, ret == -121)<br>
cx22702_readreg: readreg error (ret == -121)<br>cx22702_writereg: writereg error (reg == 0x0d, val == 0x01, ret == -121)<br>cx22702_readreg: readreg error (ret == -121)<br>cx22702_writereg: writereg error (reg == 0x0d, val == 0x00, ret == -121)<br>
cx22702_readreg: readreg error (ret == -121)<br><br>

------=_Part_13803_5249230.1206696414170--


--===============0057595266==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0057595266==--
