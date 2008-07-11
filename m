Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <postfix@au-79.de>) id 1KHKNI-00058Z-1x
	for linux-dvb@linuxtv.org; Fri, 11 Jul 2008 17:17:33 +0200
Received: from agathe (dslb-084-057-037-243.pools.arcor-ip.net [84.57.37.243])
	by post.webmailer.de (klopstock mo27) (RZmta 16.47)
	with ESMTP id k023f5k6BF9v3x for <linux-dvb@linuxtv.org>;
	Fri, 11 Jul 2008 17:17:28 +0200 (MEST)
	(envelope-from: <postfix@au-79.de>)
Received: from localhost (agathe [127.0.0.1])
	by agathe (Postfix) with ESMTP id D25891BBB8
	for <linux-dvb@linuxtv.org>; Fri, 11 Jul 2008 17:17:27 +0200 (CEST)
Received: from agathe ([127.0.0.1])
	by localhost (agathe.au-79.intra [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cwn4U8TCWQSX for <linux-dvb@linuxtv.org>;
	Fri, 11 Jul 2008 17:17:27 +0200 (CEST)
Received: from [192.168.23.45] (unknown [192.168.23.45])
	by agathe (Postfix) with ESMTP id 766481BB76
	for <linux-dvb@linuxtv.org>; Fri, 11 Jul 2008 17:17:27 +0200 (CEST)
Message-ID: <4877798E.2030409@au-79.de>
Date: Fri, 11 Jul 2008 17:17:34 +0200
From: postfix@au-79.de
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4841663B.5080105@au-79.de>
In-Reply-To: <4841663B.5080105@au-79.de>
Subject: Re: [linux-dvb] Problems with WinTV Nova T by Hauppauge USB-stick
 (id:	2040:7070)
Reply-To: postfix@au-79.de
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

Hi,

a short summary after a few weeks testing:

The internal EEprom seems to be broken. I returend the stick to the shop 
and got my money back.


Best regards

Robert

postfix@au-79.de schrieb:
> Hi,
> 
> a view days ago I bought a dvb-USB stick from Hauppauge (WinTV Nova T). 
> I want to use this stick with linux, but I sill have some trubble.
> After a google-search it is clear, that the correct driver is dib0700, 
> and the firmware to use is  dvb-usb-dib0700-1.10.fw (md5: 
> 5878ebfcba2d8deb90b9120eb89b02da)
> Kernel is 2.6.25
> 
> lsusb:
> 2040:7070 Hauppauge
> 
> If I want to tune to a channel (e.g. with kaffine) the dmesg-log is 
> overcrowed with "DiB0070 I2C write failed" and there is no sucessfull 
> tuning. The output of kaffeine while searching a channel is:
> 
> Using DVB device 0:0 "DiBcom 7000PC"
> tuning DVB-T to 402000000 Hz
> inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
> . LOCKED.
> Transponders: 1/63
> 
> Invalid section length or timeout: pid=17
> 
> Frontend closed
> Using DVB device 0:0 "DiBcom 7000PC"
> tuning DVB-T to 410000000 Hz
> inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
> . LOCKED.
> Transponders: 2/63
> 
> Invalid section length or timeout: pid=17
> .... <and so on>
> 
> The output of dmesg while attaching the stick and searching with 
> kaffeine and debug enabled is:
> 
> usb 1-6: new high speed USB device using ehci_hcd and address 6
> usb 1-6: configuration #1 chosen from 1 choice
> dvb-usb: found a 'Hauppauge Nova-T Stick' in cold state, will try to 
> load a firmware
> dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
> dib0700: firmware started successfully.
> dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
> i2c-adapter i2c-0: SMBus Quick command not supported, can't probe for chips
> dvb-usb: will pass the complete MPEG2 transport stream to the software 
> demuxer.
> DVB: registering new adapter (Hauppauge Nova-T Stick)
> i2c-adapter i2c-1: SMBus Quick command not supported, can't probe for chips
> DVB: registering frontend 0 (DiBcom 7000PC)...
> DiB0070: Revision: 3
> DiB0070 I2C write failed
> DiB0070 I2C write failed
> DiB0070 I2C write failed
> DiB0070: CTRL_LO5: 0x16a4
> DiB0070 I2C write failed
> DiB0070 I2C write failed
> DiB0070 I2C write failed
> DiB0070 I2C write failed
> DiB0070 I2C read failed
> DiB0070 I2C write failed
> DiB0070: WBDStart = 0 (Vargen) - FF = 0
> DiB0070: successfully identified
> input: IR-receiver inside an USB DVB receiver as /class/input/input11
> dvb-usb: schedule remote query interval to 150 msecs.
> dvb-usb: Hauppauge Nova-T Stick successfully initialized and connected.
> usb 1-6: New USB device found, idVendor=2040, idProduct=7070
> usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-6: Product: Nova-T Stick
> usb 1-6: Manufacturer: Hauppauge
> usb 1-6: SerialNumber: 4030980792
> DiB0070: Tuning for Band: 2 (402000 kHz)
> DiB0070 I2C write failed
> DiB0070 I2C read failed
> DiB0070 I2C write failed
> DiB0070: HFDIV code: 5
> DiB0070: VCO = 1
> DiB0070: VCOF in kHz: 4824000 ((6*402000) << 1))
> DiB0070: REFDIV: 1, FREF: 12000
> DiB0070: FBDIV: 67, Rest: 0
> DiB0070: Num: 0, Den: 1, SD: 0
> DiB0070 I2C write failed
> DiB0070 I2C write failed
> DiB0070 I2C write failed
> DiB0070 I2C write failed
> DiB0070 I2C write failed
> DiB0070 I2C write failed
> DiB0070 I2C write failed
> DiB0070 I2C write failed
> DiB0070 I2C read failed
> DiB0070: CAPTRIM=64; ADC = 0 (ADC) & 0mV
> DiB0070: CAPTRIM=64 is closer to target (400/3000)
> DiB0070 I2C write failed
> DiB0070 I2C read failed
> DiB0070: CAPTRIM=96; ADC = 0 (ADC) & 0mV
> <and so on...>
> 
> Here some more information about the stick:
> 
> lsusb -vvvv:
> 
> Bus 001 Device 006: ID 2040:7070 Hauppauge
> Device Descriptor:
>    bLength                18
>    bDescriptorType         1
>    bcdUSB               2.00
>    bDeviceClass            0 (Defined at Interface level)
>    bDeviceSubClass         0
>    bDeviceProtocol         0
>    bMaxPacketSize0        64
>    idVendor           0x2040 Hauppauge
>    idProduct          0x7070
>    bcdDevice            1.00
>    iManufacturer           1
>    iProduct                2
>    iSerial                 3
>    bNumConfigurations      1
>    Configuration Descriptor:
>      bLength                 9
>      bDescriptorType         2
>      wTotalLength           46
>      bNumInterfaces          1
>      bConfigurationValue     1
>      iConfiguration          0
>      bmAttributes         0xa0
>        (Bus Powered)
>        Remote Wakeup
>      MaxPower              500mA
>      Interface Descriptor:
>        bLength                 9
>        bDescriptorType         4
>        bInterfaceNumber        0
>        bAlternateSetting       0
>        bNumEndpoints           4
>        bInterfaceClass       255 Vendor Specific Class
>        bInterfaceSubClass      0
>        bInterfaceProtocol      0
>        iInterface              0
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x01  EP 1 OUT
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               1
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x81  EP 1 IN
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               1
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x82  EP 2 IN
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               1
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x83  EP 3 IN
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               1
> can't get device qualifier: Operation not permitted
> can't get debug descriptor: Operation not permitted
> cannot read device status, Operation not permitted (1)
> 
> 
> Thanks for your assistance. If you need any further informations or 
> tests, please let me know.
> 
> Best regards
> 
> Robert
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
