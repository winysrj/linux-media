Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas.schorpp@googlemail.com>) id 1LIbq7-00010D-JD
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 05:40:53 +0100
Received: by bwz11 with SMTP id 11so13449055bwz.17
	for <linux-dvb@linuxtv.org>; Thu, 01 Jan 2009 20:40:18 -0800 (PST)
Message-ID: <495D9AAE.3060501@gmail.com>
Date: Fri, 02 Jan 2009 05:40:14 +0100
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <495D862C.3020805@gmail.com> <495D8909.4030601@gmail.com>
In-Reply-To: <495D8909.4030601@gmail.com>
From: thomas schorpp <thomas.schorpp@googlemail.com>
Subject: Re: [linux-dvb] [BUG]2.6.28 breaks dvb-usb devices FE i2c
Reply-To: thomas.schorpp@gmail.com
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

thomas schorpp schrieb:
> thomas schorpp schrieb:
>> hi,
>>
>> usb 2-2: Product: TvTUNER
>> usb 2-2: Manufacturer: SKGZ
>> ID 04ca:f001 Lite-On Technology Corp.
>>
>> FE has been (mostly, until the 3rd try) detected until 2.6.27.10:
>> Dec 31 12:01:33 tom1 kernel: MT2060: successfully identified (IF1 = 1241)
>>
>> but no more with 2.6.28.
>>
> 
>>
>> this should be the breaking changeset included in 2.6.28 stable kernel 
>> release, others are too old:
>>
> 
>> http://linuxtv.org/hg/v4l-dvb/rev/5bfadacec8a2 Signed-off-by: Mauro 
>> Carvalho Chehab <mchehab@redhat.com>
> 
> no, takeback, too trivial 
> http://linuxtv.org/hg/v4l-dvb/diff/5bfadacec8a2/linux/drivers/media/dvb/frontends/dibx000_common.c 
> 
> 
> 2.6.28 i2c broken or this driver needs updating for 2.6.28.
> 

rebuild kernel with dvb-usb + i2c core debug, detects FE after reboot:

check for cold 10b8 bc6
check for warm 10b8 bc7
check for cold 5d8 8109
check for warm 5d8 810a
check for cold 4ca f000
check for warm 4ca f001
check for cold eb1a e360
dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in warm state.
power control: 1
>>> 07 00 01 
i2c-adapter i2c-3: adapter [LITE-ON USB2.0 DVB-T Tuner] registered
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
all in all I will use 28672 bytes for streaming
allocating buffer 0
buffer 0: ffff88003ccec000 (dma: 1020182528)
allocating buffer 1
buffer 1: ffff88003ccf5000 (dma: 1020219392)
allocating buffer 2
buffer 2: ffff88003cd08000 (dma: 1020297216)
allocating buffer 3
buffer 3: ffff88003ccef000 (dma: 1020194816)
allocating buffer 4
buffer 4: ffff88003ccfb000 (dma: 1020243968)
allocating buffer 5
buffer 5: ffff88003ccf6000 (dma: 1020223488)
allocating buffer 6
buffer 6: ffff88003ccf7000 (dma: 1020227584)
allocation successful
DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)
i2c-adapter i2c-3: master_xfer[0] W, addr=0x0c, len=2
i2c-adapter i2c-3: master_xfer[1] R, addr=0x0c, len=2
>>> 02 19 84 01 00 02 
<<< 01 b3 
i2c-adapter i2c-3: master_xfer[0] W, addr=0x0c, len=2
i2c-adapter i2c-3: master_xfer[1] R, addr=0x0c, len=2
>>> 02 19 84 02 00 02 
<<< 30 02 
DiB3000MC/P:-I-  found DiB3000MC/P: 3002

*I2C adapter driver [DiBX000 tuner I2C bus] forgot to specify physical device*
i2c-adapter i2c-4: adapter [DiBX000 tuner I2C bus] registered
i2c-adapter i2c-3: master_xfer[0] W, addr=0x0c, len=4
>>> 03 18 03 01 00 80 
i2c-adapter i2c-3: master_xfer[0] W, addr=0x0c, len=4
>>> 03 18 04 0d 31 30 
DVB: registering adapter 2 frontend 0 (DiBcom 3000MC/P)...
>>> 02 a1 7e 00 01 
<<< 00 
>>> 02 a1 7f 00 01 
<<< 15 
i2c-adapter i2c-2: master_xfer[0] W, addr=0x10, len=2
i2c-adapter i2c-2: master_xfer[0] W, addr=0x40, len=2
i2c-adapter i2c-4: master_xfer[0] W, addr=0x60, len=1
i2c-adapter i2c-4: master_xfer[1] R, addr=0x60, len=1
i2c-adapter i2c-3: master_xfer[0] W, addr=0x0c, len=4
i2c-adapter i2c-3: master_xfer[1] W, addr=0x60, len=1
i2c-adapter i2c-3: master_xfer[2] R, addr=0x60, len=1
i2c-adapter i2c-3: master_xfer[3] W, addr=0x0c, len=4
>>> 03 18 03 01 60 00 
>>> 02 c1 00 00 01 
<<< 63 
>>> 03 18 03 01 00 80 
MT2060: successfully identified (IF1 = 1241)

but fails verify:

Jan  2 05:09:39 tom1 kernel: dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully deinitialized and disconnected.
Jan  2 05:09:58 tom1 kernel: check for cold 10b8 bc6
Jan  2 05:09:58 tom1 kernel: check for warm 10b8 bc7
Jan  2 05:09:58 tom1 kernel: check for cold 5d8 8109
Jan  2 05:09:58 tom1 kernel: check for warm 5d8 810a
Jan  2 05:09:58 tom1 kernel: check for cold 4ca f000
Jan  2 05:09:58 tom1 kernel: check for warm 4ca f001
Jan  2 05:09:58 tom1 kernel: check for cold eb1a e360
Jan  2 05:09:58 tom1 kernel: dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in warm state.
Jan  2 05:09:58 tom1 kernel: power control: 1
Jan  2 05:09:58 tom1 kernel: >>> 07 00 01 
Jan  2 05:09:58 tom1 kernel: dvb-usb: bulk message failed: -22 (3/180432)
Jan  2 05:09:58 tom1 kernel: i2c-adapter i2c-0: adapter [LITE-ON USB2.0 DVB-T Tuner] registered
Jan  2 05:09:58 tom1 kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Jan  2 05:09:58 tom1 kernel: all in all I will use 28672 bytes for streaming
Jan  2 05:09:58 tom1 kernel: allocating buffer 0
...
Jan  2 05:09:58 tom1 kernel: allocation successful
Jan  2 05:09:58 tom1 kernel: DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)
Jan  2 05:09:58 tom1 kernel: i2c-adapter i2c-0: master_xfer[0] W, addr=0x0c, len=2
Jan  2 05:09:58 tom1 kernel: i2c-adapter i2c-0: master_xfer[1] R, addr=0x0c, len=2
Jan  2 05:09:58 tom1 kernel: >>> 02 19 84 01 00 02 
Jan  2 05:09:58 tom1 kernel: dvb-usb: bulk message failed: -22 (6/-30720)
Jan  2 05:09:58 tom1 kernel: DiB3000MC/P:i2c read error on 1025
Jan  2 05:09:58 tom1 kernel: 
Jan  2 05:09:58 tom1 kernel: DiB3000MC/P:-E-  DiB3000MC/P: wrong Vendor ID (read=0x290c)
Jan  2 05:09:58 tom1 kernel: 
Jan  2 05:09:58 tom1 kernel: i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=2
Jan  2 05:09:58 tom1 kernel: i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=2
Jan  2 05:09:58 tom1 kernel: >>> 02 11 84 01 00 02 
Jan  2 05:09:58 tom1 kernel: dvb-usb: bulk message failed: -22 (6/-30720)
Jan  2 05:09:58 tom1 kernel: DiB3000MC/P:i2c read error on 1025
Jan  2 05:09:58 tom1 kernel: 
Jan  2 05:09:58 tom1 kernel: DiB3000MC/P:-E-  DiB3000MC/P: wrong Vendor ID (read=0xc024)
Jan  2 05:09:58 tom1 kernel: 
Jan  2 05:09:58 tom1 kernel: dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'
Jan  2 05:09:58 tom1 kernel: power control: 0
Jan  2 05:09:58 tom1 kernel: dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully initialized and connected.
Jan  2 05:09:58 tom1 kernel: usbcore: registered new interface driver dvb_usb_dibusb_mc

trying cold state:

Jan  2 05:26:13 tom1 kernel: usb 2-2: new high speed USB device using ehci_hcd and address 5
Jan  2 05:26:13 tom1 kernel: usb 2-2: configuration #1 chosen from 1 choice
Jan  2 05:26:13 tom1 kernel: usb 2-2: New USB device found, idVendor=04ca, idProduct=f000
Jan  2 05:26:13 tom1 kernel: usb 2-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Jan  2 05:26:13 tom1 kernel: check for cold 10b8 bc6
Jan  2 05:26:13 tom1 kernel: check for warm 10b8 bc7
Jan  2 05:26:13 tom1 kernel: check for cold 5d8 8109
Jan  2 05:26:13 tom1 kernel: check for warm 5d8 810a
Jan  2 05:26:13 tom1 kernel: check for cold 4ca f000
Jan  2 05:26:13 tom1 kernel: dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in cold state, will try to load a firmware
Jan  2 05:26:13 tom1 kernel: usb 2-2: firmware: requesting dvb-usb-dibusb-6.0.0.8.fw
Jan  2 05:26:13 tom1 kernel: dvb-usb: downloading firmware from file 'dvb-usb-dibusb-6.0.0.8.fw'
Jan  2 05:26:13 tom1 kernel: writing to address 0x1525 (buffer: 0x0a 9f)
...
Jan  2 05:26:13 tom1 kernel: writing to address 0x0c55 (buffer: 0x01 9e)
Jan  2 05:26:13 tom1 kernel: usbcore: registered new interface driver dvb_usb_dibusb_mc
Jan  2 05:26:13 tom1 kernel: usb 2-2: USB disconnect, address 5
Jan  2 05:26:13 tom1 kernel: dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
Jan  2 05:26:15 tom1 kernel: usb 2-2: new high speed USB device using ehci_hcd and address 6
Jan  2 05:26:15 tom1 kernel: usb 2-2: configuration #1 chosen from 1 choice
Jan  2 05:26:15 tom1 kernel: check for cold 10b8 bc6
Jan  2 05:26:15 tom1 kernel: check for warm 10b8 bc7
Jan  2 05:26:15 tom1 kernel: check for cold 5d8 8109
Jan  2 05:26:15 tom1 kernel: check for warm 5d8 810a
Jan  2 05:26:15 tom1 kernel: check for cold 4ca f000
Jan  2 05:26:15 tom1 kernel: check for warm 4ca f001
Jan  2 05:26:15 tom1 kernel: check for cold eb1a e360
Jan  2 05:26:15 tom1 kernel: dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in warm state.
Jan  2 05:26:15 tom1 kernel: power control: 1
Jan  2 05:26:15 tom1 kernel: >>> 07 00 01 
Jan  2 05:26:15 tom1 kernel: i2c-adapter i2c-0: adapter [LITE-ON USB2.0 DVB-T Tuner] registered
Jan  2 05:26:15 tom1 kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Jan  2 05:26:15 tom1 kernel: all in all I will use 28672 bytes for streaming
Jan  2 05:26:15 tom1 kernel: allocating buffer 0
...
Jan  2 05:26:15 tom1 kernel: allocation successful
Jan  2 05:26:15 tom1 kernel: DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)
Jan  2 05:26:15 tom1 kernel: i2c-adapter i2c-0: master_xfer[0] W, addr=0x0c, len=2
Jan  2 05:26:15 tom1 kernel: i2c-adapter i2c-0: master_xfer[1] R, addr=0x0c, len=2
Jan  2 05:26:15 tom1 kernel: >>> 02 19 84 01 00 02 
Jan  2 05:26:15 tom1 kernel: <<< 5a 00 
Jan  2 05:26:15 tom1 kernel: DiB3000MC/P:-E-  DiB3000MC/P: wrong Vendor ID (read=0x5a00)
Jan  2 05:26:15 tom1 kernel: 
Jan  2 05:26:15 tom1 kernel: i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=2
Jan  2 05:26:15 tom1 kernel: i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=2
Jan  2 05:26:15 tom1 kernel: >>> 02 11 84 01 00 02 
Jan  2 05:26:15 tom1 kernel: <<< 5a 00 
Jan  2 05:26:15 tom1 kernel: DiB3000MC/P:-E-  DiB3000MC/P: wrong Vendor ID (read=0x5a00)
Jan  2 05:26:15 tom1 kernel: 
Jan  2 05:26:15 tom1 kernel: dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'
Jan  2 05:26:15 tom1 kernel: power control: 0
Jan  2 05:26:15 tom1 kernel: dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully initialized and connected.
Jan  2 05:26:15 tom1 kernel: usb 2-2: New USB device found, idVendor=04ca, idProduct=f001
Jan  2 05:26:15 tom1 kernel: usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Jan  2 05:26:15 tom1 kernel: usb 2-2: Product: TvTUNER
Jan  2 05:26:15 tom1 kernel: usb 2-2: Manufacturer: SKGZ

trying warm state:

Jan  2 05:31:29 tom1 kernel: DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)
Jan  2 05:31:29 tom1 kernel: i2c-adapter i2c-0: master_xfer[0] W, addr=0x0c, len=2
Jan  2 05:31:29 tom1 kernel: i2c-adapter i2c-0: master_xfer[1] R, addr=0x0c, len=2
Jan  2 05:31:29 tom1 kernel: >>> 02 19 84 01 00 02 
Jan  2 05:31:29 tom1 kernel: dvb-usb: bulk message failed: -22 (6/-30720)
Jan  2 05:31:29 tom1 kernel: DiB3000MC/P:i2c read error on 1025
Jan  2 05:31:29 tom1 kernel: 
Jan  2 05:31:29 tom1 kernel: DiB3000MC/P:-E-  DiB3000MC/P: wrong Vendor ID (read=0xc014)
Jan  2 05:31:29 tom1 kernel: 
Jan  2 05:31:29 tom1 kernel: i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=2
Jan  2 05:31:29 tom1 kernel: i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=2
Jan  2 05:31:29 tom1 kernel: >>> 02 11 84 01 00 02 
Jan  2 05:31:29 tom1 kernel: dvb-usb: bulk message failed: -22 (6/-30720)
Jan  2 05:31:29 tom1 kernel: DiB3000MC/P:i2c read error on 1025
Jan  2 05:31:29 tom1 kernel: 
Jan  2 05:31:29 tom1 kernel: DiB3000MC/P:-E-  DiB3000MC/P: wrong Vendor ID (read=0xc014)
Jan  2 05:31:29 tom1 kernel: 
Jan  2 05:31:29 tom1 kernel: dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'
Jan  2 05:31:29 tom1 kernel: power control: 0
Jan  2 05:31:29 tom1 kernel: dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully initialized and connected.
Jan  2 05:31:29 tom1 kernel: usbcore: registered new interface driver dvb_usb_dibusb_mc

3rd:

Jan  2 05:32:56 tom1 kernel: DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)
Jan  2 05:32:56 tom1 kernel: i2c-adapter i2c-0: master_xfer[0] W, addr=0x0c, len=2
Jan  2 05:32:56 tom1 kernel: i2c-adapter i2c-0: master_xfer[1] R, addr=0x0c, len=2
Jan  2 05:32:56 tom1 kernel: >>> 02 19 84 01 00 02 
Jan  2 05:32:56 tom1 kernel: dvb-usb: bulk message failed: -22 (6/-30720)
Jan  2 05:32:56 tom1 kernel: DiB3000MC/P:i2c read error on 1025
Jan  2 05:32:56 tom1 kernel: 
Jan  2 05:32:56 tom1 kernel: DiB3000MC/P:-E-  DiB3000MC/P: wrong Vendor ID (read=0xc054)
Jan  2 05:32:56 tom1 kernel: 
Jan  2 05:32:56 tom1 kernel: i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=2
Jan  2 05:32:56 tom1 kernel: i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=2
Jan  2 05:32:56 tom1 kernel: >>> 02 11 84 01 00 02 
Jan  2 05:32:56 tom1 kernel: dvb-usb: bulk message failed: -22 (6/-30720)
Jan  2 05:32:56 tom1 kernel: DiB3000MC/P:i2c read error on 1025
Jan  2 05:32:56 tom1 kernel: 
Jan  2 05:32:56 tom1 kernel: DiB3000MC/P:-E-  DiB3000MC/P: wrong Vendor ID (read=0xc054)
Jan  2 05:32:56 tom1 kernel: 
Jan  2 05:32:56 tom1 kernel: dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'
Jan  2 05:32:56 tom1 kernel: power control: 0
Jan  2 05:32:56 tom1 kernel: dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully initialized and connected.
Jan  2 05:32:56 tom1 kernel: usbcore: registered new interface driver dvb_usb_dibusb_mc


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
