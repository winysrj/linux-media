Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns1.in-cube.fr ([81.91.64.63])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <simon.g.morin@gmail.com>) id 1L5IQX-0005LL-7b
	for linux-dvb@linuxtv.org; Wed, 26 Nov 2008 12:19:26 +0100
Received: from yoda.localnet
	(LAubervilliers-151-11-33-138.w193-251.abo.wanadoo.fr
	[193.251.65.138])
	by ns1.in-cube.fr (Postfix) with ESMTP id DFF214E02E2
	for <linux-dvb@linuxtv.org>; Wed, 26 Nov 2008 12:44:38 +0100 (CET)
From: Simon MORIN <simon.g.morin@gmail.com>
To: linux-dvb@linuxtv.org
Date: Wed, 26 Nov 2008 12:18:48 +0100
MIME-Version: 1.0
Message-Id: <200811261218.49367.simon.g.morin@gmail.com>
Subject: [linux-dvb] WinTV HVR 1700 cannot scan (DVB-T)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0303302191=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0303302191==
Content-Type: multipart/alternative;
  boundary="Boundary-00=_ZCTLJoDdTCTRS9W"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-00=_ZCTLJoDdTCTRS9W
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Hello everyone !

I have a problem  with a WinTV HVR 1700
I installed the latest available driver via mercurial and the firmware (dvb-fe-
tda10048-1.0.fw).

The card seems to be well detected by its module (cx23885) as you can see in 
the dmesg output.
I saw there [1] that some others firmware were used (v4l-cx23885-avcore-01.fw 
and v4l-cx23885-enc.fw). I installed them, but I don't see when they are 
loaded.

I am sure of the frequencies I used because I have successfully tested on the 
same antenna, with the same frequencies with a WinTV Nova-T.

I do not see where the problem can come from.

[1] http://marc.info/?l=linux-dvb&m=120951119026705&w=2

Thank you very much for any help.

Simon MORIN

------

dmesg output :

Linux video capture interface: v2.00                                                                                                                         
cx23885 driver version 0.0.1 loaded                                                                                                                          
ACPI: PCI Interrupt 0000:0e:00.0[A] -> GSI 17 (level, low) -> IRQ 17                                                                                         
cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe bridge type 885                                                                                 
cx23885[0]/0: cx23885_init_tsport(portno=2)                                                                                                                  
CORE cx23885[0]: subsystem: 0070:8101, board: Hauppauge WinTV-HVR1700 
[card=8,autodetected]                                                                  
cx23885[0]/0: cx23885_pci_quirks()                                                                                                                           
cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x0 tuner_addr = 0x0                                                                                          
cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0 radio_addr = 0x0                                                                                          
cx23885[0]/0: cx23885_reset()                                                                                                                                
cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [VID A]                                                                                       
cx23885[0]/0: cx23885_sram_channel_setup() 0x000104c0 <- 0x00000040                                                                                          
cx23885[0]/0: cx23885_sram_channel_setup() 0x000104d0 <- 0x00000b80                                                                                          
cx23885[0]/0: cx23885_sram_channel_setup() 0x000104e0 <- 0x000016c0                                                                                          
cx23885[0]/0: [bridge 885] sram setup VID A: bpl=2880 lines=3                                                                                                
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch2]                                                                                             
cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS1 B]                                                                                       
cx23885[0]/0: cx23885_sram_channel_setup() 0x00010580 <- 0x00005000                                                                                          
cx23885[0]/0: cx23885_sram_channel_setup() 0x00010590 <- 0x000052f0                                                                                          
cx23885[0]/0: cx23885_sram_channel_setup() 0x000105a0 <- 0x000055e0                                                                                          
cx23885[0]/0: cx23885_sram_channel_setup() 0x000105b0 <- 0x000058d0
cx23885[0]/0: cx23885_sram_channel_setup() 0x000105c0 <- 0x00005bc0
cx23885[0]/0: [bridge 885] sram setup TS1 B: bpl=752 lines=5
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch4]
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch5]
cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS2 C]
cx23885[0]/0: cx23885_sram_channel_setup() 0x000105e0 <- 0x00006000
cx23885[0]/0: cx23885_sram_channel_setup() 0x000105f0 <- 0x000062f0
cx23885[0]/0: cx23885_sram_channel_setup() 0x00010600 <- 0x000065e0
cx23885[0]/0: cx23885_sram_channel_setup() 0x00010610 <- 0x000068d0
cx23885[0]/0: cx23885_sram_channel_setup() 0x00010620 <- 0x00006bc0
cx23885[0]/0: [bridge 885] sram setup TS2 C: bpl=752 lines=5
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch7]
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch8]
cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch9]
cx23885[0]: i2c scan: found device @ 0x10  [tda10048]
cx23885[0]: i2c scan: found device @ 0xa0  [eeprom]
cx23885[0]: i2c scan: found device @ 0x84  [tda8295]
cx25840' 2-0044: cx25  0-21 found @ 0x88 (cx23885[0])
cx23885[0]: i2c scan: found device @ 0x66  [???]
cx23885[0]: i2c scan: found device @ 0x88  [cx25837]
cx23885[0]: i2c scan: found device @ 0x98  [???]
tveeprom 0-0050: Hauppauge model 81519, rev B2E9, serial# 3473167
tveeprom 0-0050: MAC address is 00-0D-FE-34-FF-0F
tveeprom 0-0050: tuner model is Philips 18271_8295 (idx 149, type 54)
tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB 
Digital (eeprom 0xf4)
tveeprom 0-0050: audio processor is CX23885 (idx 39)
tveeprom 0-0050: decoder processor is CX23885 (idx 33)
tveeprom 0-0050: has no radio
cx23885[0]: hauppauge eeprom: model=81519
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
tda829x 1-0042: type set to tda8295
tda18271 1-0060: creating new instance
TDA18271HD/C1 detected @ 1-0060
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:0e:00.0, rev: 2, irq: 17, latency: 0, mmio: 
0xfde00000
PCI: Setting latency timer of device 0000:0e:00.0 to 64
tda10048_firmware_upload: waiting for firmware upload (dvb-fe-
tda10048-1.0.fw)...
firmware: requesting dvb-fe-tda10048-1.0.fw
tda10048_firmware_upload: firmware read 24878 bytes.
tda10048_firmware_upload: firmware uploading
tda10048_firmware_upload: firmware uploaded
-----

Modules loaded :

#$ modprobe  -v cx23885                                                                                                                                           
insmod /lib/modules/2.6.26-bpo.1-686-
bigmem/kernel/drivers/media/video/tveeprom.ko                                                                                          
insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/video/btcx-
risc.ko                                                                                         
insmod /lib/modules/2.6.26-bpo.1-686-
bigmem/kernel/drivers/media/video/videobuf-core.ko                                                                                     
insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/dvb/dvb-
core/dvb-core.ko                                                                                   
insmod /lib/modules/2.6.26-bpo.1-686-
bigmem/kernel/drivers/media/video/videobuf-dvb.ko                                                                                      
insmod /lib/modules/2.6.26-bpo.1-686-
bigmem/kernel/drivers/media/video/videobuf-dma-sg.ko                                                                                   
insmod /lib/modules/2.6.26-bpo.1-686-
bigmem/kernel/drivers/media/video/cx2341x.ko                                                                                           
insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/video/v4l2-
compat-ioctl32.ko                                                                               
insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/video/v4l1-
compat.ko                                                                                       
insmod /lib/modules/2.6.26-bpo.1-686-
bigmem/kernel/drivers/media/video/videodev.ko                                                                                          
insmod /lib/modules/2.6.26-bpo.1-686-
bigmem/kernel/drivers/media/video/cx23885/cx23885.ko debug=5 i2c_scan=1

--Boundary-00=_ZCTLJoDdTCTRS9W
Content-Type: text/html;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html><head><meta name="qrichtext" content="1" /><style type="text/css">
p, li { white-space: pre-wrap; }
</style></head><body style=" font-family:'DejaVu Sans'; font-size:10pt; font-weight:400; font-style:normal;">
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Hello everyone !</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">I have a problem  with a WinTV HVR 1700</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">I installed the latest available driver via mercurial and the firmware (dvb-fe-tda10048-1.0.fw).</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">The card seems to be well detected by its module (cx23885) as you can see in the dmesg output.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">I saw there [1] that some others firmware were used (v4l-cx23885-avcore-01.fw and v4l-cx23885-enc.fw). I installed them, but I don't see when they are loaded.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">I am sure of the frequencies I used because I have successfully tested on the same antenna, with the same frequencies with a WinTV Nova-T.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">I do not see where the problem can come from.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">[1] http://marc.info/?l=linux-dvb&amp;m=120951119026705&amp;w=2</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Thank you very much for any help.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Simon MORIN</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">------</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">dmesg output :</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Linux video capture interface: v2.00                                                                                                                         </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885 driver version 0.0.1 loaded                                                                                                                          </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">ACPI: PCI Interrupt 0000:0e:00.0[A] -&gt; GSI 17 (level, low) -&gt; IRQ 17                                                                                         </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe bridge type 885                                                                                 </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_init_tsport(portno=2)                                                                                                                  </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">CORE cx23885[0]: subsystem: 0070:8101, board: Hauppauge WinTV-HVR1700 [card=8,autodetected]                                                                  </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_pci_quirks()                                                                                                                           </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x0 tuner_addr = 0x0                                                                                          </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0 radio_addr = 0x0                                                                                          </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_reset()                                                                                                                                </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [VID A]                                                                                       </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() 0x000104c0 &lt;- 0x00000040                                                                                          </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() 0x000104d0 &lt;- 0x00000b80                                                                                          </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() 0x000104e0 &lt;- 0x000016c0                                                                                          </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: [bridge 885] sram setup VID A: bpl=2880 lines=3                                                                                                </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch2]                                                                                             </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS1 B]                                                                                       </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() 0x00010580 &lt;- 0x00005000                                                                                          </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() 0x00010590 &lt;- 0x000052f0                                                                                          </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() 0x000105a0 &lt;- 0x000055e0                                                                                          </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() 0x000105b0 &lt;- 0x000058d0</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() 0x000105c0 &lt;- 0x00005bc0</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: [bridge 885] sram setup TS1 B: bpl=752 lines=5</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch4]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch5]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() Configuring channel [TS2 C]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() 0x000105e0 &lt;- 0x00006000</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() 0x000105f0 &lt;- 0x000062f0</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() 0x00010600 &lt;- 0x000065e0</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() 0x00010610 &lt;- 0x000068d0</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() 0x00010620 &lt;- 0x00006bc0</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: [bridge 885] sram setup TS2 C: bpl=752 lines=5</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch7]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch8]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch9]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]: i2c scan: found device @ 0x10  [tda10048]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]: i2c scan: found device @ 0xa0  [eeprom]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]: i2c scan: found device @ 0x84  [tda8295]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx25840' 2-0044: cx25  0-21 found @ 0x88 (cx23885[0])</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]: i2c scan: found device @ 0x66  [???]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]: i2c scan: found device @ 0x88  [cx25837]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]: i2c scan: found device @ 0x98  [???]</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">tveeprom 0-0050: Hauppauge model 81519, rev B2E9, serial# 3473167</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">tveeprom 0-0050: MAC address is 00-0D-FE-34-FF-0F</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">tveeprom 0-0050: tuner model is Philips 18271_8295 (idx 149, type 54)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">tveeprom 0-0050: audio processor is CX23885 (idx 39)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">tveeprom 0-0050: decoder processor is CX23885 (idx 33)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">tveeprom 0-0050: has no radio</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]: hauppauge eeprom: model=81519</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885_dvb_register() allocating 1 frontend(s)</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]: cx23885 based dvb card</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">tda829x 1-0042: type set to tda8295</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">tda18271 1-0060: creating new instance</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">TDA18271HD/C1 detected @ 1-0060</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">DVB: registering new adapter (cx23885[0])</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885_dev_checkrevision() Hardware revision = 0xb0</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">cx23885[0]/0: found at 0000:0e:00.0, rev: 2, irq: 17, latency: 0, mmio: 0xfde00000</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">PCI: Setting latency timer of device 0000:0e:00.0 to 64</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">tda10048_firmware_upload: waiting for firmware upload (dvb-fe-tda10048-1.0.fw)...</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">firmware: requesting dvb-fe-tda10048-1.0.fw</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">tda10048_firmware_upload: firmware read 24878 bytes.</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">tda10048_firmware_upload: firmware uploading</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">tda10048_firmware_upload: firmware uploaded</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">-----</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Modules loaded :</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;"></p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">#$ modprobe  -v cx23885                                                                                                                                           </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/video/tveeprom.ko                                                                                          </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/video/btcx-risc.ko                                                                                         </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/video/videobuf-core.ko                                                                                     </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/dvb/dvb-core/dvb-core.ko                                                                                   </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/video/videobuf-dvb.ko                                                                                      </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/video/videobuf-dma-sg.ko                                                                                   </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/video/cx2341x.ko                                                                                           </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/video/v4l2-compat-ioctl32.ko                                                                               </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/video/v4l1-compat.ko                                                                                       </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/video/videodev.ko                                                                                          </p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">insmod /lib/modules/2.6.26-bpo.1-686-bigmem/kernel/drivers/media/video/cx23885/cx23885.ko debug=5 i2c_scan=1</p></body></html>
--Boundary-00=_ZCTLJoDdTCTRS9W--


--===============0303302191==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0303302191==--
