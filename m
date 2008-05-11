Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail16.syd.optusnet.com.au ([211.29.132.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pjama@optusnet.com.au>) id 1Jv5bh-0006Un-Mq
	for linux-dvb@linuxtv.org; Sun, 11 May 2008 09:04:31 +0200
Received: from zerver.home.pjama.net
	(c122-104-130-106.kelvn2.qld.optusnet.com.au [122.104.130.106])
	by mail16.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m4B74GBa027405
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Sun, 11 May 2008 17:04:17 +1000
Received: from [192.168.200.201] (emma.home.pjama.net [192.168.200.201])
	by zerver.home.pjama.net (8.13.8+Sun/8.13.8) with ESMTP id
	m4B73e2O013489
	for <linux-dvb@linuxtv.org>; Sun, 11 May 2008 17:03:41 +1000 (EST)
Message-ID: <48269A4C.8080608@optusnet.com.au>
Date: Sun, 11 May 2008 17:03:40 +1000
From: pjama <pjama@optusnet.com.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <481E7399.1040909@optusnet.com.au> <481E91D8.7010404@wentink.de>
	<481EBF63.2050601@optusnet.com.au> <481ECDFE.40203@iki.fi>
	<481EE22C.6090102@optusnet.com.au> <481EE6E2.6090301@iki.fi>
	<481EF416.4010609@optusnet.com.au> <481F2C5F.1040504@iki.fi>
In-Reply-To: <481F2C5F.1040504@iki.fi>
Subject: Re: [linux-dvb] probs with af901x on mythbuntu
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



Antti Palosaari wrote:
<snip>
>>
>> OK I have no firmware in /lib/firmware, it is all in the kernel 
>> directory. I have copied the file from the above URL which is the one 
>> I've been using and I still get "af9013: firmware version:4.73.0" in 
>> dmesg. Full 9015 relevant dmesg below.
> 
> Is that possible that you are looking firmware file from wrong 
> directory? I mean that you have for example /lib/firmware/kernel-2.6.1/ 
> and /lib/firmware/kernel-2.6.2/ other having 4.73 and the other 4.95? 
> Remove all af9015 firmwares from kernel-x.x.x directories and leave 
> 4.95.0 to /lib/firmware/. Then take unplug stick and boot machine and 
> plug stick again.
> 
> I see from dmesg log that firmware copy to 2nd frontend fails. This is 
> due to fact that currently driver has hard coded checksum for 4.95.0.

I double checked the firmware and there was only one copy in /lib/firmware/kernel-blah
It matched the 4.95.0 version. I did as mentioned earlier to boot without USB card plugged in, then plugged in device. It now looks better:

[   55.650921] usb 2-2: new high speed USB device using ehci_hcd and address 4
[   55.703555] usb 2-2: configuration #1 chosen from 1 choice
[   55.706215] af9015_usb_probe: interface:0
[   55.706814] af9015_identify_state: reply:01
[   55.706816] dvb-usb: found a 'DigitalNow TinyTwin DVB-T Receiver' in cold state, will try to load a firmware
[   55.719697] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[   55.719700] af9015_download_firmware:
[   55.752878] af9015_usb_probe: interface:1
[   55.752920] usb 2-2: USB disconnect, address 4
[   55.755152] dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
[   55.755185] dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
[   55.846024] usb 2-2: new high speed USB device using ehci_hcd and address 5
[   55.898765] usb 2-2: configuration #1 chosen from 1 choice
[   55.899005] af9015_usb_probe: interface:0
[   55.902273] af9015_identify_state: reply:02
[   55.902276] dvb-usb: found a 'DigitalNow TinyTwin DVB-T Receiver' in warm state.
[   55.902566] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[   55.903174] DVB: registering new adapter (DigitalNow TinyTwin DVB-T Receiver)
[   55.903288] af9015_eeprom_dump:
[   55.915696] 00: 2a 88 9b 0b 00 00 00 00 d3 13 26 32 00 02 01 02
[   55.932201] 10: 03 80 00 fa fa 10 40 ef 01 30 31 30 31 30 39 31
[   55.949854] 20: 34 30 36 30 30 30 30 31 ff ff ff ff ff ff ff ff
[   55.963675] 30: 00 01 3a 01 00 08 02 00 da 11 00 00 1e ff ff ff
[   55.978323] 40: ff ff ff ff ff 08 02 00 da 11 00 00 1e ff ff ff
[   55.997833] 50: ff ff ff ff ff 24 00 00 04 03 09 04 10 03 41 00
[   56.014259] 60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00
[   56.034290] 70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00
[   56.050029] 80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
[   56.071905] 90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
[   56.084186] a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   56.096469] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   56.108748] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   56.121032] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   56.133313] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   56.148280] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   56.149075] af9015_read_config: TS mode:1
[   56.149816] af9015_read_config: xtal:2 set adc_clock:28000
[   56.151353] af9015_read_config: IF1:4570
[   56.152885] af9015_read_config: MT2060 IF1:0
[   56.153653] af9015_read_config: tuner id1:30
[   56.154420] af9015_read_config: spectral inversion:0
[   56.208057] af9013: firmware version:4.95.0
[   56.219005] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
[   56.219030] af9015_tuner_attach:
[   56.282874] mxl500x_attach: Attaching ...
[   56.282877] mxl500x_attach: MXL500x tuner succesfully attached
[   56.282879] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[   56.283100] DVB: registering new adapter (DigitalNow TinyTwin DVB-T Receiver)
[   56.283216] af9015_copy_firmware:
[   56.476723] af9015_copy_firmware: firmware copy done
[   56.517404] af9015_copy_firmware: firmware boot cmd status:0
[   56.557320] af9015_copy_firmware: firmware status cmd status:0 fw status:0c
[   56.559620] af9013: firmware version:4.95.0
[   56.567300] DVB: registering frontend 1 (Afatech AF9013 DVB-T)...
[   56.567322] af9015_tuner_attach:
[   56.567352] mxl500x_attach: Attaching ...
[   56.567353] mxl500x_attach: MXL500x tuner succesfully attached
[   56.567356] dvb-usb: DigitalNow TinyTwin DVB-T Receiver successfully initialized and connected.
[   56.567358] af9015_init:
[   56.567359] af9015_init_endpoint: USB speed:3
[   56.591860] af9015_download_ir_table:
[   56.690500] input: Afatech DVB-T 2 as /devices/pci0000:00/0000:00:02.1/usb2/2-2/2-2:1.1/input/input6
[   56.702667] input,hidraw2: USB HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:02.1-2
[   59.987029] eth0: no IPv6 routers present

> 
>> I'm not sure it's a problem at this point as I've at least got TV but 
>> you may be interested from a developer point of view as there are a 
>> few errors in the dmesg.
>>
>> On a related note: What are the chances of getting the remote that 
>> came with the usb stick working? It's this one:
>> http://www.digitalnow.com.au/images/ProRemote.jpg
> 
> It should be polled. There is code for than in the driver already, but 
> it is disabled currently.

Cool. So I guess it has at least been looked at then.

Cheers
Peter

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
