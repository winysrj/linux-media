Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.vodamail.co.za ([196.11.146.226]:34980 "EHLO
	vodamail.co.za" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753683Ab0AIWFa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jan 2010 17:05:30 -0500
Subject: Re: Fwd: Compro S300 - ZL10313
From: JD Louw <jd.louw@mweb.co.za>
To: Theunis Potgieter <theunis.potgieter@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <23582ca1001061217v6a67d6a3k8ac61fee5bd861da@mail.gmail.com>
References: <23582ca0912291306v11d0631fia6ad442918961b48@mail.gmail.com>
	 <23582ca0912291307l53ff8d74j928f9e22ce09311@mail.gmail.com>
	 <23582ca0912291323s1be512ebnd60bf2ea1988799@mail.gmail.com>
	 <1262297232.1913.31.camel@Core2Duo>
	 <23582ca1001012339h6efa3b88k5eea2799b5b739dc@mail.gmail.com>
	 <1262428404.1944.22.camel@Core2Duo>
	 <23582ca1001061217v6a67d6a3k8ac61fee5bd861da@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-CC2XLAm3qlVBF7kPFjPE"
Date: Sun, 10 Jan 2010 00:05:14 +0200
Message-ID: <1263074714.2432.19.camel@Core2Duo>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-CC2XLAm3qlVBF7kPFjPE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2010-01-06 at 22:17 +0200, Theunis Potgieter wrote:
> 2010/1/2 JD Louw <jd.louw@mweb.co.za>:
> > On Sat, 2010-01-02 at 09:39 +0200, Theunis Potgieter wrote:
> >> 2010/1/1 JD Louw <jd.louw@mweb.co.za>:
> >> > On Tue, 2009-12-29 at 23:23 +0200, Theunis Potgieter wrote:
> >> >> Hi mailing list,
> >> >>
> >> >> I have a problem with my Compro S300 pci card under Linux 2.6.32.
> >> >>
> >> >> I cannot tune with this card and STR/SNRA is very bad compared to my
> >> >> Technisat SkyStar 2 pci card, connected to the same dish.
> >> >>
> >> >> I have this card and are willing to run tests, tested drivers etc to
> >> >> make this work.
> >> >>
> >> >> I currently load the module saa7134 with options: card=169
> >> >>
> >> >> I enabled some debug parameters on the saa7134, not sure what else I
> >> >> should enable. Please find my dmesg log attached.
> >> >>
> >> >> lsmod shows :
> >> >>
> >> >> # lsmod
> >> >> Module                  Size  Used by
> >> >> zl10039                 6268  2
> >> >> mt312                  12048  2
> >> >> saa7134_dvb            41549  11
> >> >> saa7134               195664  1 saa7134_dvb
> >> >> nfsd                  416819  11
> >> >> videobuf_dvb            8187  1 saa7134_dvb
> >> >> dvb_core              148140  1 videobuf_dvb
> >> >> ir_common              40625  1 saa7134
> >> >> v4l2_common            21544  1 saa7134
> >> >> videodev               58341  2 saa7134,v4l2_common
> >> >> v4l1_compat            24473  1 videodev
> >> >> videobuf_dma_sg        17830  2 saa7134_dvb,saa7134
> >> >> videobuf_core          26534  3 saa7134,videobuf_dvb,videobuf_dma_sg
> >> >> tveeprom               12550  1 saa7134
> >> >> thermal                20547  0
> >> >> processor              54638  1
> >> >>
> >> >> # uname -a
> >> >> Linux vbox 2.6.32-gentoo #4 Sat Dec 19 00:54:19 SAST 2009 i686 Pentium
> >> >> III (Coppermine) GenuineIntel GNU/Linux
> >> >>
> >> >> Thanks,
> >> >> Theunis
> >> >
> >> > Hi,
> >> >
> >> > It's probably the GPIO settings that are wrong for your SAA7133 based
> >> > card revision. See http://osdir.com/ml/linux-media/2009-06/msg01256.html
> >> > for an explanation. For quick confirmation check if you have 12V - 20V
> >> > DC going to your LNB. The relevant lines of code is in
> >> > ~/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c:
> >> >
> >> > case SAA7134_BOARD_VIDEOMATE_S350:
> >> > dev->has_remote = SAA7134_REMOTE_GPIO;
> >> > saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
> >> > saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
> >> > break;
> >> >
> >> Hi thanks for the hint. I changed it to the following:
> >>
> >>  case SAA7134_BOARD_VIDEOMATE_S350:
> >>  dev->has_remote = SAA7134_REMOTE_GPIO;
> >>  saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x0000c000, 0x0000c000);
> >>  saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0000c000, 0x0000c000);
> >>  break;
> >>
> >> I now get the same SNR as on my skystar2 card, signal is still
> >> indicating 17% where as the skystar2 would show 68%. At least I'm
> >> getting a LOCK on channels :)
> >>
> >> Thanks!
> >>
> >> >
> >> > Looking at your log, at least the demodulator and tuner is responding
> >> > correctly. You can see this by looking at the i2c traffic addressed to
> >> > 0x1c (demodulator) and 0xc0 (tuner). Attached is a dmesg trace from my
> >> > working SAA7130 based card.
> >> >
> >> > Regards
> >> > JD
> >> >
> >
> > Hi,
> >
> > Just to clarify, can you now watch channels?
> >
> > At the moment the signal strength measurement is a bit whacked, so don't
> > worry too much about it. I also get the 75%/17% figures you mentioned
> > when tuning to strong signals. The figure is simply reported wrongly:
> > even weaker signals should tune fine. If you want you can have a look in
> > ~/v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c at
> > mt312_read_signal_strength().
> >
> > Also, if you have a multimeter handy, can you confirm that the
> > 0x0000c000 GPIO fix enables LNB voltage? I'd like to issue a patch for
> > this. I've already tested this on my older card with no ill effect.
> 
> This is what happened when I started vdr.
> 
> Vertical gave a Volt reading between 13.9 and 14.1, Horizontal Gave
> 19.4 ~ 19.5. When I stopped vdr, the Voltage went back to 14V. I
> thought that it would read 0V. What is suppose to happen?
> 
> Theunis
> 
> >
> > Regards
> > JD
> >
> >
> >
> >

Hi,

The newer revision cards should be able to shut down LNB power when the
card is closed. This is what the Windows driver does; not yet
implemented in Linux.

I'd like to document the different variants of this card on the wiki.
Can you send me the output of lspci -vvnn for your variant? If you have
Windows, can you also send me some RegSpy states similar to the ones I'm
attaching to this mail?

Regards
JD


--=-CC2XLAm3qlVBF7kPFjPE
Content-Disposition: attachment; filename="SAA7130_1_3_7_8b.txt"
Content-Type: text/plain; name="SAA7130_1_3_7_8b.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

SAA7130 Card [0]:

Vendor ID:           0x1131
Device ID:           0x7130
Subsystem ID:        0xc900185b


7 states dumped

Clean PC boot - no tuning yet
----------------------------------------------------------------------------------

SAA7130 Card - State 0:
SAA7134_GPIO_GPMODE:             0080c000   (00000000 10000000 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0084bf00 * (00000000 10000100 10111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7134_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        00         (00000000)                                            
SAA7134_TS_PARALLEL:             04 *       (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00 *       (00000000)                                            
SAA7134_TS_SERIAL0:              00 *       (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00 *       (00000000)                                            
SAA7134_TS_DMA1:                 00 *       (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 0 -> State 1:
SAA7134_GPIO_GPSTATUS:           0084bf00 -> 0084ff00  (-------- -------- -0------ --------)  
SAA7134_TS_PARALLEL:             04       -> e4        (000-----)                             
SAA7134_TS_PARALLEL_SERIAL:      00       -> bb        (0-000-00)                             
SAA7134_TS_SERIAL0:              00       -> 40        (-0------)                             
SAA7134_TS_DMA0:                 00       -> 37        (--00-000)                             
SAA7134_TS_DMA1:                 00       -> 01        (-------0)                             

6 changes

Input set to DVB
----------------------------------------------------------------------------------

SAA7130 Card - State 1:
SAA7134_GPIO_GPMODE:             0080c000   (00000000 10000000 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0084ff00   (00000000 10000100 11111111 00000000)  (was: 0084bf00)
SAA7134_ANALOG_IN_CTRL1:         88 *       (10001000)                                            
SAA7134_ANALOG_IO_SELECT:        02 *       (00000010)                                            
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00 *       (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        00 *       (00000000)                                            
SAA7134_TS_PARALLEL:             e4 *       (11100100)                             (was: 04)      
SAA7134_TS_PARALLEL_SERIAL:      bb *       (10111011)                             (was: 00)      
SAA7134_TS_SERIAL0:              40 *       (01000000)                             (was: 00)      
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 37         (00110111)                             (was: 00)      
SAA7134_TS_DMA1:                 01         (00000001)                             (was: 00)      
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 1 -> State 2:
SAA7134_ANALOG_IN_CTRL1:         88       -> 81        (----1--0)                             
SAA7134_ANALOG_IO_SELECT:        02       -> 00        (------1-)                             
SAA7134_I2S_OUTPUT_FORMAT:       00       -> 01        (-------0)                             
SAA7134_I2S_AUDIO_OUTPUT:        00       -> 01        (-------0)                             
SAA7134_TS_PARALLEL:             e4       -> 04        (111-----)                             (same as 0)
SAA7134_TS_PARALLEL_SERIAL:      bb       -> 00        (1-111-11)                             (same as 0)
SAA7134_TS_SERIAL0:              40       -> 00        (-1------)                             (same as 0)

7 changes

Input set to Composite
----------------------------------------------------------------------------------

SAA7130 Card - State 2:
SAA7134_GPIO_GPMODE:             0080c000   (00000000 10000000 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0084ff00   (00000000 10000100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         81 *       (10000001)                             (was: 88)      
SAA7134_ANALOG_IO_SELECT:        00         (00000000)                             (was: 02)      
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       01         (00000001)                             (was: 00)      
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        01         (00000001)                             (was: 00)      
SAA7134_TS_PARALLEL:             04         (00000100)                             (was: e4)      
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                             (was: bb)      
SAA7134_TS_SERIAL0:              00         (00000000)                             (was: 40)      
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 37         (00110111)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 2 -> State 3:
SAA7134_ANALOG_IN_CTRL1:         81       -> 88        (----0--1)                             (same as 0, 1)

1 changes

Input set to S-Video
----------------------------------------------------------------------------------

SAA7130 Card - State 3:
SAA7134_GPIO_GPMODE:             0080c000   (00000000 10000000 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0084ff00   (00000000 10000100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                             (was: 81)      
SAA7134_ANALOG_IO_SELECT:        00 *       (00000000)                                            
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       01         (00000001)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        01 *       (00000001)                                            
SAA7134_TS_PARALLEL:             04 *       (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00 *       (00000000)                                            
SAA7134_TS_SERIAL0:              00 *       (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 37         (00110111)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 3 -> State 4:
SAA7134_ANALOG_IO_SELECT:        00       -> 02        (------0-)                             (same as 0, 1)
SAA7134_I2S_AUDIO_OUTPUT:        01       -> 00        (-------1)                             (same as 0, 1)
SAA7134_TS_PARALLEL:             04       -> e4        (000-----)                             (same as 1)
SAA7134_TS_PARALLEL_SERIAL:      00       -> bb        (0-000-00)                             (same as 1)
SAA7134_TS_SERIAL0:              00       -> 40        (-0------)                             (same as 1)

5 changes

Back to DVB
----------------------------------------------------------------------------------

SAA7130 Card - State 4:
SAA7134_GPIO_GPMODE:             0080c000   (00000000 10000000 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0084ff00 * (00000000 10000100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7134_ANALOG_IO_SELECT:        02         (00000010)                             (was: 00)      
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       01         (00000001)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        00         (00000000)                             (was: 01)      
SAA7134_TS_PARALLEL:             e4 *       (11100100)                             (was: 04)      
SAA7134_TS_PARALLEL_SERIAL:      bb *       (10111011)                             (was: 00)      
SAA7134_TS_SERIAL0:              40 *       (01000000)                             (was: 00)      
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 37         (00110111)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 4 -> State 5:
SAA7134_GPIO_GPSTATUS:           0084ff00 -> 0084bf00  (-------- -------- -1------ --------)  (same as 0)
SAA7134_TS_PARALLEL:             e4       -> 04        (111-----)                             (same as 0, 2, 3)
SAA7134_TS_PARALLEL_SERIAL:      bb       -> 00        (1-111-11)                             (same as 0, 2, 3)
SAA7134_TS_SERIAL0:              40       -> 00        (-1------)                             (same as 0, 2, 3)

4 changes

Close viewing app
----------------------------------------------------------------------------------

SAA7130 Card - State 5:
SAA7134_GPIO_GPMODE:             0080c000   (00000000 10000000 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0084bf00   (00000000 10000100 10111111 00000000)  (was: 0084ff00)
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7134_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       01         (00000001)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        00         (00000000)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                             (was: e4)      
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                             (was: bb)      
SAA7134_TS_SERIAL0:              00         (00000000)                             (was: 40)      
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 37         (00110111)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 5 -> Register Dump:

0 changes

Extra state saved by RegSpy
=================================================================================

SAA7130 Card - Register Dump:
SAA7134_GPIO_GPMODE:             0080c000   (00000000 10000000 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0084bf00   (00000000 10000100 10111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7134_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       01         (00000001)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        00         (00000000)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 37         (00110111)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            

end of dump

--=-CC2XLAm3qlVBF7kPFjPE--

