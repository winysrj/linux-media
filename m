Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail05.syd.optusnet.com.au ([211.29.132.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pjama@optusnet.com.au>) id 1JszCO-0006a0-J3
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 13:49:46 +0200
Received: from zerver.home.pjama.net
	(c122-104-130-106.kelvn2.qld.optusnet.com.au [122.104.130.106])
	by mail05.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m45BnVkf002954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Mon, 5 May 2008 21:49:31 +1000
Received: from [192.168.200.201] (emma.home.pjama.net [192.168.200.201])
	by zerver.home.pjama.net (8.13.8+Sun/8.13.8) with ESMTP id
	m45BmcNx006900
	for <linux-dvb@linuxtv.org>; Mon, 5 May 2008 21:48:38 +1000 (EST)
Message-ID: <481EF416.4010609@optusnet.com.au>
Date: Mon, 05 May 2008 21:48:38 +1000
From: pjama <pjama@optusnet.com.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <481E7399.1040909@optusnet.com.au> <481E91D8.7010404@wentink.de>
	<481EBF63.2050601@optusnet.com.au> <481ECDFE.40203@iki.fi>
	<481EE22C.6090102@optusnet.com.au> <481EE6E2.6090301@iki.fi>
In-Reply-To: <481EE6E2.6090301@iki.fi>
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

Hi Antti,

Antti Palosaari wrote:
> pjama wrote:
>> Do you mean in /lib/firmware/kernel.... ? Do you have a copy of the 
>> latest firmware. I think my source may be suspect.
> 
> /lib/firmware/
> /lib/firmware/kernel<version>/
> 
> I think both are OK, but other is loaded bigger priority by kernel. I 
> think directory with kernel version has looked first. You have 4.73.0 in 
> other directory and other has 4.95.0 ?
> 
> Different firmware files can be found from:
> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/ 
> 

OK I have no firmware in /lib/firmware, it is all in the kernel directory. I have copied the file from the above URL which is the one I've been using and I still get "af9013: firmware version:4.73.0" in dmesg. Full 9015 relevant dmesg below.

I'm not sure it's a problem at this point as I've at least got TV but you may be interested from a developer point of view as there are a few errors in the dmesg.

On a related note: What are the chances of getting the remote that came with the usb stick working? It's this one:
http://www.digitalnow.com.au/images/ProRemote.jpg

Thanks for all your efforts

Peter


dmesg output

[   46.545481] af9015_usb_probe: interface:0
[   46.546807] af9015_identify_state: reply:02
[   46.546812] dvb-usb: found a 'DigitalNow TinyTwin DVB-T Receiver' in warm state.
[   46.546915] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[   46.548122] DVB: registering new adapter (DigitalNow TinyTwin DVB-T Receiver)
[   46.548513] af9015_eeprom_dump:
[   46.578726] 00: 2a 88 9b 0b 00 00 00 00 d3 13 26 32 00 02 01 02
[   46.610703] 10: 03 80 00 fa fa 10 40 ef 01 30 31 30 31 30 39 31
[   46.642684] 20: 34 30 36 30 30 30 30 31 ff ff ff ff ff ff ff ff
[   46.674656] 30: 00 01 3a 01 00 08 02 00 da 11 00 00 1e ff ff ff
[   46.707638] 40: ff ff ff ff ff 08 02 00 da 11 00 00 1e ff ff ff
[   46.739615] 50: ff ff ff ff ff 24 00 00 04 03 09 04 10 03 41 00
[   46.771592] 60: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00
[   46.803567] 70: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00
[   46.835551] 80: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00
[   46.867527] 90: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff
[   46.899496] a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   46.931475] b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   46.963448] c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   46.995434] d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   47.027404] e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   47.059380] f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   47.061375] af9015_read_config: TS mode:1
[   47.063379] af9015_read_config: xtal:2 set adc_clock:28000
[   47.067374] af9015_read_config: IF1:4570
[   47.071367] af9015_read_config: MT2060 IF1:0
[   47.073385] af9015_read_config: tuner id1:30
[   47.075368] af9015_read_config: spectral inversion:0
[   47.146320] af9013: firmware version:4.73.0
[   47.166303] DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
[   47.166359] af9015_tuner_attach:
[   47.215903] mxl500x_attach: Attaching ...
[   47.215909] mxl500x_attach: MXL500x tuner succesfully attached
[   47.215914] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[   47.216645] DVB: registering new adapter (DigitalNow TinyTwin DVB-T Receiver)
[   47.217008] af9015_copy_firmware:
[   47.378141] af9015: af9015_rw_udev: command failed: 1
[   47.378149] af9015: af9015_copy_firmware: firmware copy cmd failed, err:-1
[   47.378153] af9015_copy_firmware: firmware copy done
[   47.482081] af9015: af9015_rw_udev: command failed: 1
[   47.482089] af9015_copy_firmware: firmware boot cmd status:-1
[   47.585989] af9015: af9015_rw_udev: command failed: 2
[   47.585998] af9015_copy_firmware: firmware status cmd status:-1 fw status:ff
[   47.587994] af9015: af9015_rw_udev: command failed: 1
[   47.588002] af9015_copy_firmware: firmware boot cmd status:-1
[   47.689916] af9015: af9015_rw_udev: command failed: 2
[   47.689924] af9015_copy_firmware: firmware status cmd status:-1 fw status:ff
[   47.691910] af9015: af9015_rw_udev: command failed: 1
[   47.691916] af9015_copy_firmware: firmware boot cmd status:-1
[   47.793831] af9015: af9015_rw_udev: command failed: 2
[   47.793840] af9015_copy_firmware: firmware status cmd status:-1 fw status:ff
[   47.795830] af9015: af9015_rw_udev: command failed: 1
[   47.795835] af9015_copy_firmware: firmware boot cmd status:-1
[   47.897756] af9015: af9015_rw_udev: command failed: 2
[   47.897764] af9015_copy_firmware: firmware status cmd status:-1 fw status:ff
[   47.899756] af9015: af9015_rw_udev: command failed: 1
[   47.899761] af9015_copy_firmware: firmware boot cmd status:-1
[   48.001677] af9015: af9015_rw_udev: command failed: 2
[   48.001685] af9015_copy_firmware: firmware status cmd status:-1 fw status:ff
[   48.003672] af9015: af9015_rw_udev: command failed: 1
[   48.003676] af9015_copy_firmware: firmware boot cmd status:-1
[   48.105610] af9015: af9015_rw_udev: command failed: 2
[   48.105618] af9015_copy_firmware: firmware status cmd status:-1 fw status:ff
[   48.107595] af9015: af9015_rw_udev: command failed: 1
[   48.107599] af9015_copy_firmware: firmware boot cmd status:-1
[   48.209522] af9015: af9015_rw_udev: command failed: 2
[   48.209529] af9015_copy_firmware: firmware status cmd status:-1 fw status:ff
[   48.211518] af9015: af9015_rw_udev: command failed: 1
[   48.211522] af9015_copy_firmware: firmware boot cmd status:-1
[   48.313445] af9015: af9015_rw_udev: command failed: 2
[   48.313452] af9015_copy_firmware: firmware status cmd status:-1 fw status:ff
[   48.315441] af9015: af9015_rw_udev: command failed: 1
[   48.315444] af9015_copy_firmware: firmware boot cmd status:-1
[   48.417366] af9015: af9015_rw_udev: command failed: 2
[   48.417371] af9015_copy_firmware: firmware status cmd status:-1 fw status:ff
[   48.419367] af9015: af9015_rw_udev: command failed: 1
[   48.419371] af9015_copy_firmware: firmware boot cmd status:-1
[   48.521288] af9015: af9015_rw_udev: command failed: 2
[   48.521293] af9015_copy_firmware: firmware status cmd status:-1 fw status:ff
[   48.521298] af9015: af9015_copy_firmware: firmware did not run
[   48.521302] af9015: af9015_af9013_frontend_attach: firmware copy to 2nd frontend failed, will disable it
[   48.521309] dvb-usb: no frontend was attached by 'DigitalNow TinyTwin DVB-T Receiver'
[   48.521315] dvb-usb: DigitalNow TinyTwin DVB-T Receiver successfully initialized and connected.
[   48.521320] af9015_init:
[   48.521322] af9015_init_endpoint: USB speed:3
[   48.565257] af9015_download_ir_table:
[   48.817098] usbcore: registered new interface driver dvb_usb_af9015

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
