Return-path: <linux-media-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:59097 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbZC2TEk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 15:04:40 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from localhost.localdomain ([70.81.178.230])
 by VL-MO-MR005.ip.videotron.ca
 (Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007; 32bit))
 with ESMTP id <0KHA006JY7M0PNT0@VL-MO-MR005.ip.videotron.ca> for
 linux-media@vger.kernel.org; Sun, 29 Mar 2009 15:03:37 -0400 (EDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by localhost.localdomain (8.14.2/8.14.2) with ESMTP id n2TJ4ZKc031170	for
 <linux-media@vger.kernel.org>; Sun, 29 Mar 2009 15:04:35 -0400
Message-id: <49CFC642.3030408@videotron.ca>
Date: Sun, 29 Mar 2009 15:04:34 -0400
From: Michel Dansereau <Michel.Dansereau@videotron.ca>
To: linux-media@vger.kernel.org
Subject: Wintv-1250 - EEPROM decoding - V4L DVB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
    I was trying to get the WINTV  HVR1250 analog interface to work.
    So far I kludged the cx23885-cards.c file to enable the decoding of 
the eeprom.
    The required offset in the eeprom is 0xC0

cx23885 driver version 0.0.1 loaded
cx23885 0000:05:00.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low) -> 
IRQ 16
cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe bridge type 885
cx23885[0]/0: cx23885_init_tsport(portno=2)
CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250 
[card=3,autodetected]
cx23885[0]/0: cx23885_pci_quirks()
cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x0 tuner_addr = 0x0
cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0 radio_addr = 0x0
cx23885[0]/0: cx23885_reset()
cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [VID A]
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch2]
cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS1 B]
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch4]
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch5]
cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS2 C]
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch7]
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch8]
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch9]
tuner' 3-0043: chip found @ 0x86 (cx23885[0])
tda9887 3-0043: creating new instance
tda9887 3-0043: tda988[5/6/7] found
tuner' 3-0043: type set to tda9887
tuner' 3-0043: tv freq set to 0.00
tuner' 3-0043: TV freq (0.00) out of range (44-958)
tuner' 3-0043: cx23885[0] tuner' I2C addr 0x86 with type 74 used for 0x0e
cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
tveeprom 2-0050: full 256-byte eeprom dump:
tveeprom 2-0050: 00: 20 00 13 00 00 00 00 00 2c 00 05 00 70 00 11 79
tveeprom 2-0050: 10: 50 03 05 00 04 80 00 08 0c 03 05 80 0e 01 00 00
tveeprom 2-0050: 20: 78 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 2-0050: 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 2-0050: 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 2-0050: 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 2-0050: 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 2-0050: 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 2-0050: 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 2-0050: 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 2-0050: a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 2-0050: b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tveeprom 2-0050: c0: 84 09 00 04 20 77 00 40 13 73 4a f0 73 05 27 00
tveeprom 2-0050: d0: 84 08 00 06 99 34 01 00 19 29 95 72 07 70 73 09
tveeprom 2-0050: e0: 21 7f 73 0a 88 8b 72 0b 2f 72 0f 01 72 10 01 72
tveeprom 2-0050: f0: 11 ff 79 c1 00 00 00 00 00 00 00 00 00 00 00 00
tveeprom 2-0050: Tag [04] + 8 bytes: 20 77 00 40 13 73 4a f0
tveeprom 2-0050: Tag [05] + 2 bytes: 27 00
tveeprom 2-0050: Tag [06] + 7 bytes: 99 34 01 00 19 29 95
tveeprom 2-0050: Tag [07] + 1 bytes: 70
tveeprom 2-0050: Tag [09] + 2 bytes: 21 7f
tveeprom 2-0050: Tag [0a] + 2 bytes: 88 8b
tveeprom 2-0050: Tag [0b] + 1 bytes: 2f
tveeprom 2-0050: Tag [0f] + 1 bytes: 01
tveeprom 2-0050: Tag [10] + 1 bytes: 01
tveeprom 2-0050: Not sure what to do with tag [10]
tveeprom 2-0050: Tag [11] + 1 bytes: ff
tveeprom 2-0050: Not sure what to do with tag [11]
tveeprom 2-0050: Hauppauge model 79001, rev E2D9, serial# 4879123
tveeprom 2-0050: MAC address is 00-0D-FE-4A-73-13
tveeprom 2-0050: tuner model is Microtune MT2131 (idx 139, type 4)
tveeprom 2-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
tveeprom 2-0050: audio processor is CX23885 (idx 39)
tveeprom 2-0050: decoder processor is CX23885 (idx 33)
tveeprom 2-0050: has no radio, has IR receiver, has no IR transmitter
cx23885[0]: hauppauge eeprom: model=79001
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
mt2131: mt2131_attach()
MT2131: successfully identified at address 0x61
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx23885_dev_checkrevision() Hardware revision = 0xc0
cx23885[0]/0: found at 0000:05:00.0, rev: 3, irq: 16, latency: 0, mmio: 
0xfdc00000
cx23885 0000:05:00.0: setting latency timer to 64
IRQ 16/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs
tuner 5-0061: Cmd VIDIOC_G_TUNER accepted for analog TV
tuner 5-0061: Cmd VIDIOC_G_TUNER accepted for analog TV
tuner 5-0061: Cmd VIDIOC_G_TUNER accepted for analog TV


    I did not get very for after that.

    FYI the firmware suggested by development site sees wrong ... The 
encoder firmware especially. I think that the following profile is 
required by the code.
    The code requiresfirmware with these sizes (these are from the 
hauppage distro.

-r--r--r-- 1 root root 376836 2009-03-29 13:03 
/lib/firmware/v4l-cx23885-enc.fw
-r--r--r-- 1 root root  16382 2009-03-29 13:04 
/lib/firmware/v4l-cx23885-avcore-01.fw



void cx23885_card_setup(struct cx23885_dev *dev)
{
        struct cx23885_tsport *ts1 = &dev->ts1;
        struct cx23885_tsport *ts2 = &dev->ts2;

        static u8 eeprom[256];

        if (dev->i2c_bus[0].i2c_rc == 0) {
                dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
                tveeprom_read(&dev->i2c_bus[0].i2c_client,
                              eeprom, sizeof(eeprom));
        }

        switch (dev->board) {
/* removed        case CX23885_BOARD_HAUPPAUGE_HVR1250: */
        case CX23885_BOARD_HAUPPAUGE_HVR1500:
        case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
        case CX23885_BOARD_HAUPPAUGE_HVR1400:
                if (dev->i2c_bus[0].i2c_rc == 0)
                        hauppauge_eeprom(dev, eeprom+0x80);
                break;
        case CX23885_BOARD_HAUPPAUGE_HVR1250: /*added*/
        case CX23885_BOARD_HAUPPAUGE_HVR1800:
        case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
        case CX23885_BOARD_HAUPPAUGE_HVR1200:
        case CX23885_BOARD_HAUPPAUGE_HVR1700:
                if (dev->i2c_bus[0].i2c_rc == 0)
                        hauppauge_eeprom(dev, eeprom+0xc0);
                break;
        }


I hope this helps.

Michel

