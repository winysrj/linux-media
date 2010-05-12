Return-path: <linux-media-owner@vger.kernel.org>
Received: from web27804.mail.ukl.yahoo.com ([217.146.182.9]:29760 "HELO
	web27804.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754675Ab0ELVOu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 17:14:50 -0400
Message-ID: <703190.46824.qm@web27804.mail.ukl.yahoo.com>
Date: Wed, 12 May 2010 21:14:48 +0000 (GMT)
From: marc balta <marc_balta@yahoo.de>
Subject: Stuck Digittrade DVB-T stick (dvb_usb_af9015)
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

i have problems with my Digittrade (www.digittrade.de) dvb-t stick. I'm 
trying at first to sum up my researches and observings (since im 
researching now two weeks for this problem) and will then enumerate my 
system parameter. This problem is very annoying so I hope you can help 
me. Perhaps there is workaround for instance reseting the stick  somehow 
(see *Observings and Researches).*


*Observings and Researches:*

* im using a mythtv box that runs 24 hours a day. The box uses EItScan 
to retrieve the EPG data.
* every now and then there is a file recorded that is empty. It seems 
that dvb-t stick doesnt tune correctly. There
is however no error reported by mythtv. I have then found on some forums 
that the problem might be triggered by  channels that cannot be received 
very well being scanned by the mythtv EITScanner. It is assumed that the 
driver or firmware stucks then somehow.
* when this happens (stuck device) only a reboot or unplugging the stick 
helps. Reloading all dvb modules helps nothing. So the problem might be 
the firmware?
* sometimes the device gets itself out of this state
* some days ago this happened again. The usb stick came in this state. 
No Live Tv was possible and no recordings could be made. I decided to 
wait and see what happens. Two days later the device was still stuck in 
this state and I observed that this had an impact on the entire system: 
The responsivness was very bad. I pressed a button on the USB keyboard 
and the reaction appeard one or two  seconds later on the screen. I 
tried this also via a ssh connection. It was the same. Then I examined 
the logs. I think that the first show that couldnt be recorded was on 
11th May. Thats the day the "I2C read failed reg" log messages started.

################## /var/log/kern.log: ################################

May  9 15:38:36 debian kernel: usb 8-2: new high speed USB device using 
ehci_hcd and address 9
May  9 15:38:36 debian kernel: af9015_usb_probe: interface:0
May  9 15:38:36 debian kernel: af9015_read_config: IR mode:1
May  9 15:38:36 debian kernel: af9015_read_config: TS mode:0
May  9 15:38:36 debian kernel: af9015_read_config: [0] xtal:2 set 
adc_clock:28000
May  9 15:38:36 debian kernel: af9015_read_config: [0] IF1:36125
May  9 15:38:36 debian kernel: af9015_read_config: [0] MT2060 IF1:1220
May  9 15:38:36 debian kernel: af9015_read_config: [0] tuner id:130
May  9 15:38:36 debian kernel: af9015_identify_state: reply:01
May  9 15:38:36 debian kernel: dvb-usb: found a 'Afatech AF9015 DVB-T 
USB2.0 stick' in cold state, will try to
load a firmware
May  9 15:38:36 debian kernel: usb 8-2: firmware: requesting 
dvb-usb-af9015.fw
May  9 15:38:36 debian kernel: dvb-usb: downloading firmware from file 
'dvb-usb-af9015.fw'
May  9 15:38:36 debian kernel: af9015_download_firmware:
May  9 15:38:36 debian kernel: dvb-usb: found a 'Afatech AF9015 DVB-T 
USB2.0 stick' in warm state.
May  9 15:38:36 debian kernel: dvb-usb: will pass the complete MPEG2 
transport stream to the software demuxer.
May  9 15:38:36 debian kernel: DVB: registering new adapter (Afatech 
AF9015 DVB-T USB2.0 stick)
May  9 15:38:36 debian kernel: af9015_af9013_frontend_attach: init I2C
May  9 15:38:36 debian kernel: af9015_i2c_init:
May  9 15:38:36 debian kernel: 00: 2c 21 97 0b 00 00 00 00 a4 15 16 90 
00 02 01 02
May  9 15:38:36 debian kernel: 10: 00 80 00 fa fa 10 40 ef 01 30 31 30 
31 30 35 30
May  9 15:38:36 debian kernel: 20: 36 30 39 30 30 30 30 31 ff ff ff ff 
ff ff ff ff
May  9 15:38:36 debian kernel: 30: 00 00 3a 01 00 08 02 00 1d 8d c4 04 
82 ff ff ff
May  9 15:38:36 debian kernel: 40: ff ff ff ff ff 08 02 00 1d 8d c4 04 
82 ff ff ff
May  9 15:38:36 debian kernel: 50: ff ff ff ff ff 24 00 00 04 03 09 04 
10 03 41 00
May  9 15:38:37 debian kernel: 60: 66 00 61 00 74 00 65 00 63 00 68 00 
0c 03 44 00
May  9 15:38:37 debian kernel: 70: 56 00 42 00 2d 00 54 00 20 03 30 00 
31 00 30 00
May  9 15:38:37 debian kernel: 80: 31 00 30 00 31 00 30 00 31 00 30 00 
36 00 30 00
May  9 15:38:37 debian kernel: 90: 30 00 30 00 30 00 31 00 00 ff ff ff 
ff ff ff ff
May  9 15:38:37 debian kernel: a0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
May  9 15:38:37 debian kernel: b0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
May  9 15:38:37 debian kernel: c0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
May  9 15:38:37 debian kernel: d0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
May  9 15:38:37 debian kernel: e0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
May  9 15:38:37 debian kernel: f0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
May  9 15:38:37 debian kernel: af9013: firmware version:4.95.0
May  9 15:38:37 debian kernel: DVB: registering adapter 0 frontend 0 
(Afatech AF9013 DVB-T)...
May  9 15:38:37 debian kernel: af9015_tuner_attach:
May  9 15:38:37 debian kernel: MT2060: successfully identified (IF1 = 1220)
May  9 15:38:37 debian kernel: input: IR-receiver inside an USB DVB 
receiver as /class/input/input62
May  9 15:38:37 debian kernel: dvb-usb: schedule remote query interval 
to 150 msecs.
May  9 15:38:37 debian kernel: dvb-usb: Afatech AF9015 DVB-T USB2.0 
stick successfully initialized and connected.
May  9 15:38:37 debian kernel: af9015_init:
May  9 15:38:37 debian kernel: af9015_init_endpoint: USB speed:3
May  9 15:38:37 debian kernel: af9015_download_ir_table:
May  9 15:38:44 debian kernel: af9015_pid_filter_ctrl: onoff:0
May  9 15:38:45 debian last message repeated 2 times
May  9 16:01:59 debian kernel: af9015_pid_filter_ctrl: onoff:0
May  9 16:17:11 debian kernel: af9015_pid_filter_ctrl: onoff:0
[...]
May 11 08:11:12 debian kernel: af9015: bulk message failed:-110 (8/0)
May 11 08:11:12 debian kernel: af9013: I2C read failed reg:d330
May 11 08:11:14 debian kernel: af9015: bulk message failed:-110 (8/0)
May 11 08:11:14 debian kernel: dvb-usb: error while querying for an 
remote control event.
May 11 08:11:16 debian kernel: af9015: bulk message failed:-110 (8/0)
May 11 08:11:16 debian kernel: af9013: I2C read failed reg:d330
May 11 08:11:18 debian kernel: af9015: bulk message failed:-110 (9/0)
May 11 08:11:18 debian kernel: af9013: I2C write failed reg:ae00 len:1
May 11 08:11:20 debian kernel: af9015: bulk message failed:-110 (8/0)
May 11 08:11:20 debian kernel: dvb-usb: error while querying for an 
remote control event.
May 11 08:11:22 debian kernel: af9015: bulk message failed:-110 (8/0)
May 11 08:11:22 debian kernel: af9013: I2C read failed reg:9bee
May 11 08:11:24 debian kernel: af9015: bulk message failed:-110 (8/0)
May 11 08:11:24 debian kernel: dvb-usb: error while querying for an 
remote control event.
May 11 08:11:26 debian kernel: af9015: bulk message failed:-110 (8/0)
May 11 08:11:26 debian kernel: af9013: I2C read failed reg:d330
May 11 08:11:28 debian kernel: af9015: bulk message failed:-110 (8/0)
May 11 08:11:28 debian kernel: dvb-usb: error while querying for an 
remote control event.
May 11 08:11:30 debian kernel: af9015: bulk message failed:-110 (8/0)
May 11 08:11:30 debian kernel: af9013: I2C read failed reg:9bee
May 11 08:11:32 debian kernel: af9015: bulk message failed:-110 (8/0)
May 11 08:11:32 debian kernel: dvb-usb: error while querying for an 
remote control event.
[...]
May 12 20:30:06 debian kernel: af9015: bulk message failed:-22 (8/-1)
May 12 20:30:06 debian kernel: af9013: I2C read failed reg:9bee
May 12 20:30:07 debian kernel: af9015: bulk message failed:-22 (8/-1)
May 12 20:30:07 debian kernel: af9013: I2C read failed reg:9bee
May 12 20:30:08 debian kernel: af9015: bulk message failed:-22 (8/-1)
May 12 20:30:08 debian kernel: af9013: I2C read failed reg:9bee
May 12 20:30:09 debian kernel: af9015: bulk message failed:-22 (8/-1)
May 12 20:30:09 debian kernel: af9013: I2C read failed reg:9bee
####################################################################
*
System Parameter:

*System: Debian Lenny
Kernel: Linux debian 2.6.33.2 #1 SMP Thu Apr 15 07:40:04 CEST 2010 
x86_64 GNU/Linux
Driver: dvb_usb_af9015 (Using the original dvb drivers and subsystem of 
Linux debian 2.6.33.2)
Firmware: firmware version:4.95.0
Mythtv Version: 0.22
######################## lsusb: ##################################
Bus 008 Device 004: ID 15a4:9016 
Device Descriptor:
 bLength                18
 bDescriptorType         1
 bcdUSB               2.00
 bDeviceClass            0 (Defined at Interface level)
 bDeviceSubClass         0
 bDeviceProtocol         0
 bMaxPacketSize0        64
 idVendor           0x15a4
 idProduct          0x9016
 bcdDevice            2.00
 iManufacturer           1 Afatech
 iProduct                2 DVB-T
 iSerial                 0
 bNumConfigurations      1
 Configuration Descriptor:
   bLength                 9
   bDescriptorType         2
   wTotalLength           71
   bNumInterfaces          2
   bConfigurationValue     1
   iConfiguration          0
   bmAttributes         0x80
     (Bus Powered)
   MaxPower              500mA
   Interface Descriptor:
     bLength                 9
     bDescriptorType         4
     bInterfaceNumber        0
     bAlternateSetting       0
     bNumEndpoints           4
     bInterfaceClass       255 Vendor Specific Class
     bInterfaceSubClass      0
     bInterfaceProtocol      0
     iInterface              0
     Endpoint Descriptor:
       bLength                 7
       bDescriptorType         5
       bEndpointAddress     0x81  EP 1 IN
       bmAttributes            2
         Transfer Type            Bulk
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0200  1x 512 bytes
       bInterval               0
     Endpoint Descriptor:
       bLength                 7
       bDescriptorType         5
       bEndpointAddress     0x02  EP 2 OUT
       bmAttributes            2
         Transfer Type            Bulk
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0200  1x 512 bytes
       bInterval               0
     Endpoint Descriptor:
       bLength                 7
       bDescriptorType         5
       bEndpointAddress     0x84  EP 4 IN
       bmAttributes            2
         Transfer Type            Bulk
         Synch Type               None
         Usage Type               Data
       wMaxPacketSize     0x0200  1x 512 bytes
       bInterval               0
     Endpoint Descriptor:
[...]
Device Qualifier (for other device speed):
 bLength                10
 bDescriptorType         6
 bcdUSB               2.00
 bDeviceClass            0 (Defined at Interface level)
 bDeviceSubClass         0
 bDeviceProtocol         0
 bMaxPacketSize0        64
 bNumConfigurations      1
Device Status:     0x0000
 (Bus Powered)

####################################################################


Greetings,

Marc




