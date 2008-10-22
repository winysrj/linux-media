Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 217-112-173-73.cust.avonet.cz ([217.112.173.73]
	helo=podzimek.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <andrej@podzimek.org>) id 1KsShI-000388-OV
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 03:39:43 +0200
Message-ID: <48FE8438.7080804@podzimek.org>
Date: Wed, 22 Oct 2008 03:39:04 +0200
From: Andrej Podzimek <andrej@podzimek.org>
MIME-Version: 1.0
To: Darron Broad <darron@kewl.org>
References: <48FE2872.3070105@podzimek.org> <48FE3553.5080009@iki.fi>
	<48FE6351.2000805@podzimek.org> <10307.1224636523@kewl.org>
In-Reply-To: <10307.1224636523@kewl.org>
Cc: Antti Palosaari <crope@iki.fi>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] MSI DigiVox mini II V3.0 stopped working
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

>> One more little note about the firmware:
>>
>> 	[andrej@xandrej firmware]$ sha1sum dvb-usb-af9015.fw
>> 	6a0edcc65f490d69534d4f071915fc73f5461560  dvb-usb-af9015.fw
>>
>> That file can be found here: http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw
>>
>> Is it the right one? Shell I try something else?
> 
> Lo
> 
> try this patch (WARNING, although I have one of these devices
> and this looked to fix it, I have no idea what this actually means).

Many thanks for the patch! Now I know my device hasn't died.

Obviously, mentioning the member no_reconnect in the initializers of (the array of) struct dvb_usb_device_properties solved the problem. The device reset that normally occurs after firmware loading simply did not come when no_reconnect was left out from the initializers.

A piece of poetry:

	Oct 22 03:24:48 xandrej usb 4-2: new high speed USB device using ehci_hcd and address 12
	Oct 22 03:24:48 xandrej usb 4-2: configuration #1 chosen from 1 choice
	Oct 22 03:24:48 xandrej Afatech DVB-T 2: Fixing fullspeed to highspeed interval: 16 -> 8
	Oct 22 03:24:48 xandrej input: Afatech DVB-T 2 as /class/input/input17
	Oct 22 03:24:48 xandrej input: USB HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:1d.7-2
	Oct 22 03:24:49 xandrej af9015_usb_probe: interface:0
	Oct 22 03:24:49 xandrej af9015_read_config: IR mode:1
	Oct 22 03:24:49 xandrej af9015_read_config: TS mode:0
	Oct 22 03:24:49 xandrej af9015_read_config: [0] xtal:2 set adc_clock:28000
	Oct 22 03:24:49 xandrej af9015_read_config: [0] IF1:43000
	Oct 22 03:24:49 xandrej af9015_read_config: [0] MT2060 IF1:0
	Oct 22 03:24:49 xandrej af9015_read_config: [0] tuner id:156
	Oct 22 03:24:49 xandrej af9015_identify_state: reply:01
	Oct 22 03:24:49 xandrej dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state, will try to load a firmware
	Oct 22 03:24:49 xandrej firmware: requesting dvb-usb-af9015.fw
	Oct 22 03:24:49 xandrej dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
	Oct 22 03:24:49 xandrej af9015_download_firmware:
	Oct 22 03:24:49 xandrej dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
	Oct 22 03:24:49 xandrej dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
	Oct 22 03:24:49 xandrej DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
	Oct 22 03:24:49 xandrej af9015_af9013_frontend_attach: init I2C
	Oct 22 03:24:49 xandrej af9015_i2c_init:
	Oct 22 03:24:49 xandrej 00: 2b d3 9b 0b 00 00 00 00 a4 15 16 90 00 02 01 02
	Oct 22 03:24:49 xandrej 10: 03 80 00 fa fa 10 40 ef 01 30 31 30 31 31 30 31
	Oct 22 03:24:49 xandrej 20: 36 30 37 30 30 30 30 31 ff ff ff ff ff ff ff ff
	Oct 22 03:24:49 xandrej 30: 00 00 3a 01 00 08 02 00 f8 a7 00 00 9c ff ff ff
	Oct 22 03:24:49 xandrej 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
	Oct 22 03:24:49 xandrej 50: ff ff ff ff 10 26 00 00 04 03 09 04 10 03 41 00
	Oct 22 03:24:49 xandrej 60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00
	Oct 22 03:24:49 xandrej 70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00
	Oct 22 03:24:49 xandrej 80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
	Oct 22 03:24:49 xandrej 90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
	Oct 22 03:24:49 xandrej a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
	Oct 22 03:24:49 xandrej b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
	Oct 22 03:24:49 xandrej c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
	Oct 22 03:24:49 xandrej d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
	Oct 22 03:24:49 xandrej e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
	Oct 22 03:24:49 xandrej f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
	Oct 22 03:24:49 xandrej af9013: firmware version:4.95.0
	Oct 22 03:24:49 xandrej DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
	Oct 22 03:24:49 xandrej af9015_tuner_attach:
	Oct 22 03:24:49 xandrej tda18271 1-00c0: creating new instance
	Oct 22 03:24:49 xandrej TDA18271HD/C1 detected @ 1-00c0
	Oct 22 03:24:49 xandrej dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully initialized and connected.
	Oct 22 03:24:49 xandrej af9015_init:
	Oct 22 03:24:49 xandrej af9015_init_endpoint: USB speed:3
	Oct 22 03:24:49 xandrej af9015_download_ir_table:
	Oct 22 03:24:49 xandrej usbcore: registered new interface driver dvb_usb_af9015

It seems to be perfectly OK right now. Both video and sound work as usual in Kaffeine.

Andrej


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
