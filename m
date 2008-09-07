Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 203.161.84.42.static.amnet.net.au ([203.161.84.42]
	helo=goeng.com.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tom@goeng.com.au>) id 1Kc8jR-0003y8-Fp
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 03:06:27 +0200
From: "Thomas Goerke" <tom@goeng.com.au>
To: stev391@email.com, "'jackden'" <jackden@gmail.com>
References: <20080907002919.38684104F0@ws1-3.us4.outblaze.com>
In-Reply-To: <20080907002919.38684104F0@ws1-3.us4.outblaze.com>
Date: Sun, 7 Sep 2008 09:06:54 +0800
Message-ID: <000001c91086$0b6b1900$22414b00$@com.au>
MIME-Version: 1.0
Content-Language: en-au
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
	TV/FM capture card
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

 
> Tom & Jackden,
> 
> to use the i2c_scan:
> sudo rmmod cx23885
> sudo modprobe cx24885 i2c_scan=1
> 
> dmesg
> 
> Now in dmesg you should see something like:
--snip--
> 
> This will have the cards initialisation before and after it, I just
> need the i2c scan results.
> 
> Then to get the results from the eeprom scan:
> sudo modprobe i2c-dev
> sudo i2cdetect -l
> (take note which i2c device matches the one above with the eeprom, this
> example assumes 0)
> sudo i2cdump 0 0x50
> (Note the i2c address has to be divided by 2 from what the scan above
> states, so 0xa0 -> 0x50)
> 
> Then you should get an output in the terminal, copy this and send it to
> me (and the list).
> 
> Regards,
> 
> Stephen.
> 
Stephen,

See below for results of testing.  

Commands:
sudo rmmod cx23885
sudo modprobe cx24885 i2c_scan=1

dmesg:

[160134.208379] ACPI: PCI interrupt for device 0000:04:00.0 disabled
[160134.208542] xc2028 1-0061: xc2028_dvb_release called
[160134.208545] xc2028 1-0061: free_firmware called
[160134.208564] xc2028 1-0061: destroying instance
[160169.249974] cx23885 driver version 0.0.1 loaded
[160169.250021] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low)
-> IRQ 16
[160169.250026] cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe
bridge type 885
[160169.250028] cx23885[0]/0: cx23885_init_tsport(portno=2)
[160169.250037] CORE cx23885[0]: subsystem: 185b:e800, board: Compro
VideoMate E650 [card=13,autodetected]
[160169.250040] cx23885[0]/0: cx23885_pci_quirks()
[160169.250043] cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x0
tuner_addr = 0x0
[160169.250045] cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0
radio_addr = 0x0
[160169.250047] cx23885[0]/0: cx23885_reset()
[160169.349190] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [VID A]
[160169.349202] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch2]
[160169.349204] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [TS1 B]
[160169.349217] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch4]
[160169.349219] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch5]
[160169.349222] cx23885[0]/0: cx23885_sram_channel_setup() Configuring
channel [TS2 C]
[160169.349235] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch7]
[160169.349237] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch8]
[160169.349239] cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel
[ch9]
[160169.389065] cx23885[0]: i2c bus 0 registered
[160169.391249] cx23885[0]: i2c scan: found device @ 0x1e  [???]
[160169.400115] cx23885[0]: i2c scan: found device @ 0xa0  [eeprom]
[160169.403390] cx23885[0]: i2c scan: found device @ 0xd0  [???]
[160169.406677] cx23885[0]: i2c bus 1 registered
[160169.420042] cx23885[0]: i2c scan: found device @ 0xc2
[tuner/mt2131/tda8275/xc5000/xc3028]
[160169.424399] cx25840' 2-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[160169.424729] cx23885[0]: i2c bus 2 registered
[160169.426637] cx23885[0]: i2c scan: found device @ 0x66  [???]
[160169.427262] cx23885[0]: i2c scan: found device @ 0x88  [cx25837]
[160169.427557] cx23885[0]: i2c scan: found device @ 0x98  [???]
[160169.466057] cx23885[0]: cx23885 based dvb card
[160169.466581] xc2028: Xcv2028/3028 init called!
[160169.466583] xc2028 1-0061: creating new instance
[160169.466585] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[160169.466587] xc2028 1-0061: xc2028_set_config called
[160169.466589] DVB: registering new adapter (cx23885[0])
[160169.466591] DVB: registering frontend 1 (Zarlink ZL10353 DVB-T)...
[160169.466748] cx23885_dev_checkrevision() Hardware revision = 0xb0
[160169.466754] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xfe800000
[160169.466761] PCI: Setting latency timer of device 0000:04:00.0 to 64

tom@quark:~$ sudo modprobe i2c-dev
tom@quark:~$ sudo i2cdetect -l
i2c-3   i2c             Hauppauge Nova-T 500 Dual DVB-T         I2C adapter
i2c-4   i2c             DiBX000 tuner I2C bus                   I2C adapter
i2c-5   i2c             DiBX000 tuner I2C bus                   I2C adapter
i2c-6   i2c             NVIDIA i2c adapter                      I2C adapter
i2c-7   i2c             NVIDIA i2c adapter                      I2C adapter
i2c-8   i2c             NVIDIA i2c adapter                      I2C adapter
i2c-0   i2c             cx23885[0]                              I2C adapter
i2c-1   i2c             cx23885[0]                              I2C adapter
i2c-2   i2c             cx23885[0]                              I2C adapter

tom@quark:~$ sudo i2cdump 0 0x50
No size specified (using byte-data access)
WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-0, address 0x50, mode byte
Continue? [Y/n] Y
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f    0123456789abcdef
00: 2c 00 05 00 5b 18 00 e8 ff ff ff ff ff ff ff ff    ,.?.[?.?........
10: 18 03 05 00 0d c0 09 03 08 00 18 83 00 00 03 28    ???.?????.??..?(
20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
40: ff 1a 03 c2 86 1e ff ff ff ff ff ff c6 ff ff ff    .?????......?...
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff    ................

Tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
