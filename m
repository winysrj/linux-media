Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.235])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sergeniki@googlemail.com>) id 1K4Mfn-0001jK-5f
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 23:07:07 +0200
Received: by wx-out-0506.google.com with SMTP id h27so529747wxd.17
	for <linux-dvb@linuxtv.org>; Thu, 05 Jun 2008 14:06:57 -0700 (PDT)
Message-ID: <9e5406cc0806051406p78cfa341p2897e30b965d6bd8@mail.gmail.com>
Date: Thu, 5 Jun 2008 22:06:57 +0100
From: "Serge Nikitin" <sergeniki@googlemail.com>
To: "Antti Palosaari" <crope@iki.fi>
In-Reply-To: <48480E9D.9000004@iki.fi>
MIME-Version: 1.0
References: <9e5406cc0806050626r5588f1d3k36896b75c05070b0@mail.gmail.com>
	<48480E9D.9000004@iki.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] PEAK DVB-T Digital Dual Tuner PCI - anyone got this
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0037375212=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0037375212==
Content-Type: multipart/alternative;
	boundary="----=_Part_4253_13754132.1212700017052"

------=_Part_4253_13754132.1212700017052
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Jun 5, 2008 at 5:04 PM, Antti Palosaari <crope@iki.fi> wrote:

>
> Could you give all debug / message logs printed in startup? It should print
> eeprom content and some more information as well.
>

Antti,
I already compare both "dmesg" outputs and can't see much difference, but I
hope that those logs will make more sense for you (fyi - there is second DVB
card on the same box - Hauppauge NOVA DVB-S, some messaging may interfere):
############## OK ####################
########## Cold restart - both tuners added, did not check how does it
work...
(from dmesg):
af9015_usb_probe: interface:0
af9015_read_config: TS mode:1
af9015_read_config: [0] xtal:2 set adc_clock:28000
af9015_read_config: [0] IF1:36125
af9015_read_config: [0] MT2060 IF1:0
af9015_read_config: [0] tuner id:156
af9015_read_config: [1] xtal:2 set adc_clock:28000
af9015_read_config: [1] IF1:36125
af9015_read_config: [1] MT2060 IF1:0
af9015_read_config: [1] tuner id:156
af9015_identify_state: reply:01
dvb-usb: found a 'KWorld  PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner' in
cold state, will try to load a firmware
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
af9015_download_firmware:
usb 2-1: USB disconnect, address 2
af9015_usb_device_exit:
dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
usb 2-1: new high speed USB device using ehci_hcd and address 3
usb 2-1: configuration #1 chosen from 1 choice
af9015_usb_probe: interface:0
af9015_read_config: TS mode:1
af9015_read_config: [0] xtal:2 set adc_clock:28000
af9015_read_config: [0] IF1:36125
af9015_read_config: [0] MT2060 IF1:0
af9015_read_config: [0] tuner id:156
af9015_read_config: [1] xtal:2 set adc_clock:28000
af9015_read_config: [1] IF1:36125
af9015_read_config: [1] MT2060 IF1:0
af9015_read_config: [1] tuner id:156
af9015_identify_state: reply:02
dvb-usb: found a 'KWorld  PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner' in
warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (KWorld  PC160 (PEAK 221544AGPK) DVB-T PCI dual
tuner)
af9015_af9013_frontend_attach: init I2C
af9015_i2c_init:
af9015_eeprom_dump:
00: 2b 85 9b 0b 00 00 00 00 80 1b 60 c1 00 02 01 02
10: 03 80 00 fa fa 10 40 ef 04 30 31 30 31 30 37 32
20: 34 30 37 30 30 30 30 31 ff ff ff ff ff ff ff ff
30: 00 01 3a 01 00 08 02 00 1d 8d 00 00 9c ff ff ff
40: ff ff ff ff ff 08 02 00 1d 8d 00 00 9c ff ff ff
50: ff ff ff ff ff 26 00 00 04 03 09 04 10 03 41 00
60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00
70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00
80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
i2c_core: exports duplicate symbol i2c_smbus_write_i2c_block_data (owned by
kernel)
af9013: firmware version:4.95.0
DVB: registering frontend 1 (Afatech AF9013 DVB-T)...
af9015_tuner_attach:
i2c_core: exports duplicate symbol i2c_smbus_write_i2c_block_data (owned by
kernel)
tda18271 3-00c0: creating new instance
TDA18271HD/C1 detected @ 3-00c0
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (KWorld  PC160 (PEAK 221544AGPK) DVB-T PCI dual
tuner)
af9015_copy_firmware:
af9015_copy_firmware: firmware copy done
af9015_copy_firmware: firmware boot cmd status:0
af9015_copy_firmware: firmware status cmd status:0 fw status:0c
af9013: firmware version:4.95.0
DVB: registering frontend 2 (Afatech AF9013 DVB-T)...
af9015_tuner_attach:
tda18271 4-00c0: creating new instance
TDA18271HD/C1 detected @ 4-00c0
input: IR-receiver inside an USB DVB receiver as /class/input/input1
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: KWorld  PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner successfully
initialized and connected.
af9015_init:
af9015_init_endpoint: USB speed:3
af9015_download_ir_table:
usbcore: registered new interface driver dvb_usb_af9015

########## NOT OK ########
#### "shutdown -r" ( same for "shutdown -h" without real power off/on )
af9015_usb_probe: interface:0
af9015_read_config: TS mode:1
af9015_read_config: [0] xtal:2 set adc_clock:28000
af9015_read_config: [0] IF1:36125
af9015_read_config: [0] MT2060 IF1:0
af9015_read_config: [0] tuner id:156
af9015_read_config: [1] xtal:2 set adc_clock:28000
af9015_read_config: [1] IF1:36125
af9015_read_config: [1] MT2060 IF1:0
af9015_read_config: [1] tuner id:156
af9015_identify_state: reply:02
dvb-usb: found a 'KWorld  PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner' in
warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (KWorld  PC160 (PEAK 221544AGPK) DVB-T PCI dual
tuner)
af9015_af9013_frontend_attach: init I2C
af9015_i2c_init:
af9015_eeprom_dump:
00: 2b 85 9b 0b 00 00 00 00 80 1b 60 c1 00 02 01 02
DVB: registering frontend 0 (ST STV0299 DVB-S)...
10: 03 80 00 fa fa 10 40 ef 04 30 31 30 31 30 37 32
20: 34 30 37 30 30 30 30 31 ff ff ff ff ff ff ff ff
30: 00 01 3a 01 00 08 02 00 1d 8d 00 00 9c ff ff ff
40: ff ff ff ff ff 08 02 00 1d 8d 00 00 9c ff ff ff
50: ff ff ff ff ff 26 00 00 04 03 09 04 10 03 41 00
60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00
70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00
80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
i2c_core: exports duplicate symbol i2c_smbus_write_i2c_block_data (owned by
kernel)
af9013: firmware version:4.95.0
DVB: registering frontend 1 (Afatech AF9013 DVB-T)...
af9015_tuner_attach:
i2c_core: exports duplicate symbol i2c_smbus_write_i2c_block_data (owned by
kernel)
tda18271 3-00c0: creating new instance
TDA18271HD/C1 detected @ 3-00c0
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (KWorld  PC160 (PEAK 221544AGPK) DVB-T PCI dual
tuner)
af9015_copy_firmware:
af9015_copy_firmware: firmware copy done
af9015_copy_firmware: firmware boot cmd status:0
af9015_copy_firmware: firmware status cmd status:0 fw status:0c
af9013: firmware version:4.95.0
DVB: registering frontend 2 (Afatech AF9013 DVB-T)...
af9015_tuner_attach:
tda18271 4-00c0: creating new instance
af9015: af9015_rw_udev: command failed: 2
tda18271_read_regs: ERROR: i2c_transfer returned: -1
Unknown device detected @ 4-00c0, device not supported.
tda18271 4-00c0: destroying instance
input: IR-receiver inside an USB DVB receiver as /class/input/input1
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: KWorld  PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner successfully
initialized and connected.
af9015_init:
af9015_init_endpoint: USB speed:3
af9015_download_ir_table:
usbcore: registered new interface driver dvb_usb_af9015
####################################################

Thank you.
Serge.

------=_Part_4253_13754132.1212700017052
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div class="gmail_quote">On Thu, Jun 5, 2008 at 5:04 PM, Antti Palosaari &lt;<a href="mailto:crope@iki.fi">crope@iki.fi</a>&gt; wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
Could you give all debug / message logs printed in startup? It should print eeprom content and some more information as well.<br>
</blockquote></div><br>Antti,<br>I already compare both &quot;dmesg&quot; outputs and can&#39;t see much difference, but I hope that those logs will make more sense for you (fyi - there is second DVB card on the same box - Hauppauge NOVA DVB-S, some messaging may interfere):<br>
############## OK ####################<br>########## Cold restart - both tuners added, did not check how does it work...<br>(from dmesg):<br>af9015_usb_probe: interface:0<br>af9015_read_config: TS mode:1<br>af9015_read_config: [0] xtal:2 set adc_clock:28000<br>
af9015_read_config: [0] IF1:36125<br>af9015_read_config: [0] MT2060 IF1:0<br>af9015_read_config: [0] tuner id:156<br>af9015_read_config: [1] xtal:2 set adc_clock:28000<br>af9015_read_config: [1] IF1:36125<br>af9015_read_config: [1] MT2060 IF1:0<br>
af9015_read_config: [1] tuner id:156<br>af9015_identify_state: reply:01<br>dvb-usb: found a &#39;KWorld&nbsp; PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner&#39; in cold state, will try to load a firmware<br>dvb-usb: downloading firmware from file &#39;dvb-usb-af9015.fw&#39;<br>
af9015_download_firmware:<br>usb 2-1: USB disconnect, address 2<br>af9015_usb_device_exit:<br>dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.<br>usb 2-1: new high speed USB device using ehci_hcd and address 3<br>
usb 2-1: configuration #1 chosen from 1 choice<br>af9015_usb_probe: interface:0<br>af9015_read_config: TS mode:1<br>af9015_read_config: [0] xtal:2 set adc_clock:28000<br>af9015_read_config: [0] IF1:36125<br>af9015_read_config: [0] MT2060 IF1:0<br>
af9015_read_config: [0] tuner id:156<br>af9015_read_config: [1] xtal:2 set adc_clock:28000<br>af9015_read_config: [1] IF1:36125<br>af9015_read_config: [1] MT2060 IF1:0<br>af9015_read_config: [1] tuner id:156<br>af9015_identify_state: reply:02<br>
dvb-usb: found a &#39;KWorld&nbsp; PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner&#39; in warm state.<br>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>DVB: registering new adapter (KWorld&nbsp; PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)<br>
af9015_af9013_frontend_attach: init I2C<br>af9015_i2c_init:<br>af9015_eeprom_dump:<br>00: 2b 85 9b 0b 00 00 00 00 80 1b 60 c1 00 02 01 02<br>10: 03 80 00 fa fa 10 40 ef 04 30 31 30 31 30 37 32<br>20: 34 30 37 30 30 30 30 31 ff ff ff ff ff ff ff ff<br>
30: 00 01 3a 01 00 08 02 00 1d 8d 00 00 9c ff ff ff<br>40: ff ff ff ff ff 08 02 00 1d 8d 00 00 9c ff ff ff<br>50: ff ff ff ff ff 26 00 00 04 03 09 04 10 03 41 00<br>60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00<br>70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00<br>
80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00<br>90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff<br>a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>i2c_core: exports duplicate symbol i2c_smbus_write_i2c_block_data (owned by kernel)<br>
af9013: firmware version:4.95.0<br>DVB: registering frontend 1 (Afatech AF9013 DVB-T)...<br>af9015_tuner_attach:<br>i2c_core: exports duplicate symbol i2c_smbus_write_i2c_block_data (owned by kernel)<br>tda18271 3-00c0: creating new instance<br>
TDA18271HD/C1 detected @ 3-00c0<br>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>DVB: registering new adapter (KWorld&nbsp; PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)<br>af9015_copy_firmware:<br>
af9015_copy_firmware: firmware copy done<br>af9015_copy_firmware: firmware boot cmd status:0<br>af9015_copy_firmware: firmware status cmd status:0 fw status:0c<br>af9013: firmware version:4.95.0<br>DVB: registering frontend 2 (Afatech AF9013 DVB-T)...<br>
af9015_tuner_attach:<br>tda18271 4-00c0: creating new instance<br>TDA18271HD/C1 detected @ 4-00c0<br>input: IR-receiver inside an USB DVB receiver as /class/input/input1<br>dvb-usb: schedule remote query interval to 150 msecs.<br>
dvb-usb: KWorld&nbsp; PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner successfully initialized and connected.<br>af9015_init:<br>af9015_init_endpoint: USB speed:3<br>af9015_download_ir_table:<br>usbcore: registered new interface driver dvb_usb_af9015<br>
<br>########## NOT OK ########<br>#### &quot;shutdown -r&quot; ( same for &quot;shutdown -h&quot; without real power off/on )<br>af9015_usb_probe: interface:0<br>af9015_read_config: TS mode:1<br>af9015_read_config: [0] xtal:2 set adc_clock:28000<br>
af9015_read_config: [0] IF1:36125<br>af9015_read_config: [0] MT2060 IF1:0<br>af9015_read_config: [0] tuner id:156<br>af9015_read_config: [1] xtal:2 set adc_clock:28000<br>af9015_read_config: [1] IF1:36125<br>af9015_read_config: [1] MT2060 IF1:0<br>
af9015_read_config: [1] tuner id:156<br>af9015_identify_state: reply:02<br>dvb-usb: found a &#39;KWorld&nbsp; PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner&#39; in warm state.<br>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>
DVB: registering new adapter (KWorld&nbsp; PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)<br>af9015_af9013_frontend_attach: init I2C<br>af9015_i2c_init:<br>af9015_eeprom_dump:<br>00: 2b 85 9b 0b 00 00 00 00 80 1b 60 c1 00 02 01 02<br>
DVB: registering frontend 0 (ST STV0299 DVB-S)...<br>10: 03 80 00 fa fa 10 40 ef 04 30 31 30 31 30 37 32<br>20: 34 30 37 30 30 30 30 31 ff ff ff ff ff ff ff ff<br>30: 00 01 3a 01 00 08 02 00 1d 8d 00 00 9c ff ff ff<br>40: ff ff ff ff ff 08 02 00 1d 8d 00 00 9c ff ff ff<br>
50: ff ff ff ff ff 26 00 00 04 03 09 04 10 03 41 00<br>60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00<br>70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00<br>80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00<br>90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff<br>
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff<br>i2c_core: exports duplicate symbol i2c_smbus_write_i2c_block_data (owned by kernel)<br>af9013: firmware version:4.95.0<br>DVB: registering frontend 1 (Afatech AF9013 DVB-T)...<br>
af9015_tuner_attach:<br>i2c_core: exports duplicate symbol i2c_smbus_write_i2c_block_data (owned by kernel)<br>tda18271 3-00c0: creating new instance<br>TDA18271HD/C1 detected @ 3-00c0<br>dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>
DVB: registering new adapter (KWorld&nbsp; PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner)<br>af9015_copy_firmware:<br>af9015_copy_firmware: firmware copy done<br>af9015_copy_firmware: firmware boot cmd status:0<br>af9015_copy_firmware: firmware status cmd status:0 fw status:0c<br>
af9013: firmware version:4.95.0<br>DVB: registering frontend 2 (Afatech AF9013 DVB-T)...<br>af9015_tuner_attach:<br>tda18271 4-00c0: creating new instance<br>af9015: af9015_rw_udev: command failed: 2<br>tda18271_read_regs: ERROR: i2c_transfer returned: -1<br>
Unknown device detected @ 4-00c0, device not supported.<br>tda18271 4-00c0: destroying instance<br>input: IR-receiver inside an USB DVB receiver as /class/input/input1<br>dvb-usb: schedule remote query interval to 150 msecs.<br>
dvb-usb: KWorld&nbsp; PC160 (PEAK 221544AGPK) DVB-T PCI dual tuner successfully initialized and connected.<br>af9015_init:<br>af9015_init_endpoint: USB speed:3<br>af9015_download_ir_table:<br>usbcore: registered new interface driver dvb_usb_af9015<br>
####################################################<br><br>Thank you.<br>Serge.<br>

------=_Part_4253_13754132.1212700017052--


--===============0037375212==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0037375212==--
