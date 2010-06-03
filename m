Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34435 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab0FCRPP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jun 2010 13:15:15 -0400
Received: by fxm8 with SMTP id 8so270734fxm.19
        for <linux-media@vger.kernel.org>; Thu, 03 Jun 2010 10:15:13 -0700 (PDT)
Content-Type: multipart/mixed; boundary=----------gsGSDaGZk5DFQthzlbK855
To: semiRocket <semirocket@gmail.com>,
	"Davor Emard" <davoremard@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
References: <AANLkTikbpZ0LM5rK70abVuJS27j0lT7iZs12DrSKB9wI@mail.gmail.com>
 <op.vcfoxwnq3xmt7q@crni> <20100509173243.GA8227@z60m> <op.vcga9rw2ndeod6@crni>
 <20100509231535.GA6334@z60m> <op.vcsntos43xmt7q@crni> <op.vc551isrndeod6@crni>
 <20100530234817.GA17135@emard.lan> <20100531075214.GA17456@lipa.lan>
 <op.vdn7g9nj3xmt7q@crni> <20100602182757.GA22171@emard.lan>
Date: Thu, 03 Jun 2010 19:15:05 +0200
MIME-Version: 1.0
From: semiRocket <semirocket@gmail.com>
Message-ID: <op.vdqh7fnc3xmt7q@crni>
In-Reply-To: <20100602182757.GA22171@emard.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------------gsGSDaGZk5DFQthzlbK855
Content-Type: text/plain; charset=iso-8859-2; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Wed, 02 Jun 2010 20:27:59 +0200, Davor Emard <davoremard@gmail.com>  
wrote:

> HI!
>
> Have you tested my lastest GPIO suggestion, or come up
> with your own initialization? Does it allow
> to load firmware without windows booting?
>

No luck with this...

Remainder: It can't load firmware doing cold boot. If I restart from  
windows firmware loads, and can start tvtime a few times and watch analog  
tv.

I've uninstalled the driver and compro software from windows in order to  
track thing more carefully.

My card cold boot gpstatus value is 0080bf00. When windows driver loads,  
it sets it to 0080ff00. And sets the GPMODE to 82c000 among the other  
values. When compro remote tray utility loads sets mask to 84ff00 (94ff00)  
and value begins to constantly change.

So, I tried with something like:
	case SAA7134_BOARD_VIDEOMATE_T750:
		dev->has_remote = SAA7134_REMOTE_GPIO;
		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x0082c000, 0x0082c000);
		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0000f000, 0x0000f000);
		break;

And I get this line in dmesg after loading the driver for the second time:
saa7133[0]: board init: gpio is 94ff00

That doesn't help with firmware load. But it seems to help get to work  
analog stable, e.g when  windows prepare device I can restart tvtime as  
many times as I want without analog stop working.


Audio clock changes (xx187de7) when switching from inputs. It uses  
03187de7 for analog and DVB, and 43187de7 for S Video and Composite. Maybe  
this enables audio line in connector.


I tried to log GPMODE additional activity before it stabilizes at 0082c000  
by enabling/disabling windows driver and attached it to this mail.

here follows windows driver initialization from cold boot (without  
software installed) I know it shows GPMODE 0002c000 but later (a second  
after loading) it stabilizes at 0082c000 (didn't cach it here.):

SAA7133 Card [0]:

Vendor ID:           0x1131
Device ID:           0x7133
Subsystem ID:        0xc900185b


3 states dumped

----------------------------------------------------------------------------------

SAA7133 Card - State 0:
SAA7134_GPIO_GPMODE:             00000000 * (00000000 00000000 00000000  
00000000)
SAA7134_GPIO_GPSTATUS:           0080bf00 * (00000000 10000000 10111111  
00000000)
SAA7134_ANALOG_IN_CTRL1:         00 *       (00000000)
SAA7133_ANALOG_IO_SELECT:        00 *       (00000000)
SAA7133_AUDIO_CLOCK_NOMINAL:     00187de7 * (00000000 00011000 01111101  
11100111)
SAA7133_PLL_CONTROL:             00 *       (00000000)
SAA7133_AUDIO_CLOCKS_PER_FIELD:  00000000 * (00000000 00000000 00000000  
00000000)
SAA7134_VIDEO_PORT_CTRL0:        0000b000 * (00000000 00000000 10110000  
00000000)
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000  
00000000)
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)
SAA7134_I2S_AUDIO_OUTPUT:        10 *       (00010000)
SAA7134_TS_PARALLEL:             6c *       (01101100)
SAA7134_TS_PARALLEL_SERIAL:      b9 *       (10111001)
SAA7134_TS_SERIAL0:              50 *       (01010000)
SAA7134_TS_SERIAL1:              01 *       (00000001)
SAA7134_TS_DMA0:                 35 *       (00110101)
SAA7134_TS_DMA1:                 01 *       (00000001)
SAA7134_TS_DMA2:                 00         (00000000)
SAA7134_SPECIAL_MODE:            00 *       (00000000)


Changes: State 0 -> State 1:
SAA7134_GPIO_GPMODE:             00000000 -> 0002c000  (-------- ------0-  
00------ --------)
SAA7134_GPIO_GPSTATUS:           0080bf00 -> 0080ff00  (-------- --------  
-0------ --------)
SAA7134_ANALOG_IN_CTRL1:         00       -> 88        (0---0---)
SAA7133_ANALOG_IO_SELECT:        00       -> 02        (------0-)
SAA7133_AUDIO_CLOCK_NOMINAL:     00187de7 -> 03187de7  (------00 --------  
-------- --------)
SAA7133_PLL_CONTROL:             00       -> 03        (------00)
SAA7133_AUDIO_CLOCKS_PER_FIELD:  00000000 -> 0001e000  (-------- -------0  
000----- --------)
SAA7134_VIDEO_PORT_CTRL0:        0000b000 -> 00000000  (-------- --------  
1-11---- --------)
SAA7134_I2S_AUDIO_OUTPUT:        10       -> 11        (-------0)
SAA7134_TS_PARALLEL:             6c       -> 04        (-11-1---)
SAA7134_TS_PARALLEL_SERIAL:      b9       -> 00        (1-111--1)
SAA7134_TS_SERIAL0:              50       -> 00        (-1-1----)
SAA7134_TS_SERIAL1:              01       -> 00        (-------1)
SAA7134_TS_DMA0:                 35       -> 00        (--11-1-1)
SAA7134_TS_DMA1:                 01       -> 00        (-------1)
SAA7134_SPECIAL_MODE:            00       -> 01        (-------0)

16 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 1:
SAA7134_GPIO_GPMODE:             0002c000 * (00000000 00000010 11000000  
00000000)  (was: 00000000)
SAA7134_GPIO_GPSTATUS:           0080ff00   (00000000 10000000 11111111  
00000000)  (was: 0080bf00)
SAA7134_ANALOG_IN_CTRL1:         88          
(10001000)                             (was: 00)
SAA7133_ANALOG_IO_SELECT:        02          
(00000010)                             (was: 00)
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101  
11100111)  (was: 00187de7)
SAA7133_PLL_CONTROL:             03          
(00000011)                             (was: 00)
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000  
00000000)  (was: 00000000)
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000  
00000000)  (was: 0000b000)
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000  
00000000)
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)
SAA7134_I2S_AUDIO_OUTPUT:        11          
(00010001)                             (was: 10)
SAA7134_TS_PARALLEL:             04          
(00000100)                             (was: 6c)
SAA7134_TS_PARALLEL_SERIAL:      00          
(00000000)                             (was: b9)
SAA7134_TS_SERIAL0:              00          
(00000000)                             (was: 50)
SAA7134_TS_SERIAL1:              00          
(00000000)                             (was: 01)
SAA7134_TS_DMA0:                 00          
(00000000)                             (was: 35)
SAA7134_TS_DMA1:                 00          
(00000000)                             (was: 01)
SAA7134_TS_DMA2:                 00         (00000000)
SAA7134_SPECIAL_MODE:            01          
(00000001)                             (was: 00)


Changes: State 1 -> Register Dump:
SAA7134_GPIO_GPMODE:             0002c000 -> 0082c000  (-------- 0-------  
-------- --------)

1 changes


=================================================================================

SAA7133 Card - Register Dump:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000  
00000000)  (was: 0002c000)
SAA7134_GPIO_GPSTATUS:           0080ff00   (00000000 10000000 11111111  
00000000)
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)
SAA7133_ANALOG_IO_SELECT:        02         (00000010)
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101  
11100111)
SAA7133_PLL_CONTROL:             03         (00000011)
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000  
00000000)
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000  
00000000)
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000  
00000000)
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)
SAA7134_TS_PARALLEL:             04         (00000100)
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)
SAA7134_TS_SERIAL0:              00         (00000000)
SAA7134_TS_SERIAL1:              00         (00000000)
SAA7134_TS_DMA0:                 00         (00000000)
SAA7134_TS_DMA1:                 00         (00000000)
SAA7134_TS_DMA2:                 00         (00000000)
SAA7134_SPECIAL_MODE:            01         (00000001)

end of dump
------------gsGSDaGZk5DFQthzlbK855
Content-Disposition: attachment; filename=SAA7133_0.txt
Content-Type: text/plain; name=SAA7133_0.txt
Content-Transfer-Encoding: 7bit

SAA7133 Card [0]:

Vendor ID:           0x1131
Device ID:           0x7133
Subsystem ID:        0xc900185b


11 states dumped

----------------------------------------------------------------------------------

SAA7133 Card - State 0:
SAA7134_GPIO_GPMODE:             00028000   (00000000 00000010 10000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094bf00 * (00000000 10010100 10111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         80         (10000000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 0 -> State 1:
SAA7134_GPIO_GPSTATUS:           0094bf00 -> 00943f00  (-------- -------- 1------- --------)  

1 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 1:
SAA7134_GPIO_GPMODE:             00028000   (00000000 00000010 10000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           00943f00   (00000000 10010100 00111111 00000000)  (was: 0094bf00)
SAA7134_ANALOG_IN_CTRL1:         80         (10000000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 1 -> State 2:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 2:
SAA7134_GPIO_GPMODE:             00028000 * (00000000 00000010 10000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           00943f00 * (00000000 10010100 00111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         80 *       (10000000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 2 -> State 3:
SAA7134_GPIO_GPMODE:             00028000 -> 0002c000  (-------- -------- -0------ --------)  
SAA7134_GPIO_GPSTATUS:           00943f00 -> 0094ff00  (-------- -------- 00------ --------)  
SAA7134_ANALOG_IN_CTRL1:         80       -> 88        (----0---)                             

3 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 3:
SAA7134_GPIO_GPMODE:             0002c000   (00000000 00000010 11000000 00000000)  (was: 00028000)
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)  (was: 00943f00)
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                             (was: 80)      
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 3 -> State 4:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 4:
SAA7134_GPIO_GPMODE:             0002c000   (00000000 00000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 4 -> State 5:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 5:
SAA7134_GPIO_GPMODE:             0002c000   (00000000 00000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 5 -> State 6:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 6:
SAA7134_GPIO_GPMODE:             0002c000   (00000000 00000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 6 -> State 7:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 7:
SAA7134_GPIO_GPMODE:             0002c000 * (00000000 00000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 7 -> State 8:
SAA7134_GPIO_GPMODE:             0002c000 -> 0082c000  (-------- 0------- -------- --------)  

1 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 8:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)  (was: 0002c000)
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 8 -> State 9:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 9:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 9 -> Register Dump:

0 changes


=================================================================================

SAA7133 Card - Register Dump:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            

end of dump

------------gsGSDaGZk5DFQthzlbK855
Content-Disposition: attachment; filename=SAA7133_0_01.txt
Content-Type: text/plain; name=SAA7133_0_01.txt
Content-Transfer-Encoding: 7bit

SAA7133 Card [0]:

Vendor ID:           0x1131
Device ID:           0x7133
Subsystem ID:        0xc900185b


6 states dumped

----------------------------------------------------------------------------------

SAA7133 Card - State 0:
SAA7134_GPIO_GPMODE:             00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0080bf00   (00000000 10000000 10111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         00         (00000000)                                            
SAA7133_ANALOG_IO_SELECT:        00         (00000000)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     00187de7   (00000000 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             00         (00000000)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        0000b000   (00000000 00000000 10110000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        10         (00010000)                                            
SAA7134_TS_PARALLEL:             6c         (01101100)                                            
SAA7134_TS_PARALLEL_SERIAL:      b9         (10111001)                                            
SAA7134_TS_SERIAL0:              50         (01010000)                                            
SAA7134_TS_SERIAL1:              01         (00000001)                                            
SAA7134_TS_DMA0:                 35         (00110101)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            00         (00000000)                                            


Changes: State 0 -> State 1:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 1:
SAA7134_GPIO_GPMODE:             00000000 * (00000000 00000000 00000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0080bf00 * (00000000 10000000 10111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         00 *       (00000000)                                            
SAA7133_ANALOG_IO_SELECT:        00 *       (00000000)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     00187de7 * (00000000 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             00 *       (00000000)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  00000000 * (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        0000b000 * (00000000 00000000 10110000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        10 *       (00010000)                                            
SAA7134_TS_PARALLEL:             6c *       (01101100)                                            
SAA7134_TS_PARALLEL_SERIAL:      b9 *       (10111001)                                            
SAA7134_TS_SERIAL0:              50 *       (01010000)                                            
SAA7134_TS_SERIAL1:              01 *       (00000001)                                            
SAA7134_TS_DMA0:                 35 *       (00110101)                                            
SAA7134_TS_DMA1:                 01 *       (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            00 *       (00000000)                                            


Changes: State 1 -> State 2:
SAA7134_GPIO_GPMODE:             00000000 -> 0002c000  (-------- ------0- 00------ --------)  
SAA7134_GPIO_GPSTATUS:           0080bf00 -> 0080ff00  (-------- -------- -0------ --------)  
SAA7134_ANALOG_IN_CTRL1:         00       -> 88        (0---0---)                             
SAA7133_ANALOG_IO_SELECT:        00       -> 02        (------0-)                             
SAA7133_AUDIO_CLOCK_NOMINAL:     00187de7 -> 03187de7  (------00 -------- -------- --------)  
SAA7133_PLL_CONTROL:             00       -> 03        (------00)                             
SAA7133_AUDIO_CLOCKS_PER_FIELD:  00000000 -> 0001e000  (-------- -------0 000----- --------)  
SAA7134_VIDEO_PORT_CTRL0:        0000b000 -> 00000000  (-------- -------- 1-11---- --------)  
SAA7134_I2S_AUDIO_OUTPUT:        10       -> 11        (-------0)                             
SAA7134_TS_PARALLEL:             6c       -> 04        (-11-1---)                             
SAA7134_TS_PARALLEL_SERIAL:      b9       -> 00        (1-111--1)                             
SAA7134_TS_SERIAL0:              50       -> 00        (-1-1----)                             
SAA7134_TS_SERIAL1:              01       -> 00        (-------1)                             
SAA7134_TS_DMA0:                 35       -> 00        (--11-1-1)                             
SAA7134_TS_DMA1:                 01       -> 00        (-------1)                             
SAA7134_SPECIAL_MODE:            00       -> 01        (-------0)                             

16 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 2:
SAA7134_GPIO_GPMODE:             0002c000 * (00000000 00000010 11000000 00000000)  (was: 00000000)
SAA7134_GPIO_GPSTATUS:           0080ff00   (00000000 10000000 11111111 00000000)  (was: 0080bf00)
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                             (was: 00)      
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                             (was: 00)      
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)  (was: 00187de7)
SAA7133_PLL_CONTROL:             03         (00000011)                             (was: 00)      
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)  (was: 00000000)
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)  (was: 0000b000)
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                             (was: 10)      
SAA7134_TS_PARALLEL:             04         (00000100)                             (was: 6c)      
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                             (was: b9)      
SAA7134_TS_SERIAL0:              00         (00000000)                             (was: 50)      
SAA7134_TS_SERIAL1:              00         (00000000)                             (was: 01)      
SAA7134_TS_DMA0:                 00         (00000000)                             (was: 35)      
SAA7134_TS_DMA1:                 00         (00000000)                             (was: 01)      
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                             (was: 00)      


Changes: State 2 -> State 3:
SAA7134_GPIO_GPMODE:             0002c000 -> 0082c000  (-------- 0------- -------- --------)  

1 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 3:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)  (was: 0002c000)
SAA7134_GPIO_GPSTATUS:           0080ff00   (00000000 10000000 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 3 -> State 4:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 4:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0080ff00   (00000000 10000000 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 4 -> Register Dump:

0 changes


=================================================================================

SAA7133 Card - Register Dump:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0080ff00   (00000000 10000000 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            

end of dump

------------gsGSDaGZk5DFQthzlbK855
Content-Disposition: attachment; filename=SAA7133_0_02.txt
Content-Type: text/plain; name=SAA7133_0_02.txt
Content-Transfer-Encoding: 7bit

SAA7133 Card [0]:

Vendor ID:           0x1131
Device ID:           0x7133
Subsystem ID:        0xc900185b

=================================================================================

SAA7133 Card - Register Dump:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            

end of dump

------------gsGSDaGZk5DFQthzlbK855
Content-Disposition: attachment; filename=SAA7133_0_03.txt
Content-Type: text/plain; name=SAA7133_0_03.txt
Content-Transfer-Encoding: 7bit

SAA7133 Card [0]:

Vendor ID:           0x1131
Device ID:           0x7133
Subsystem ID:        0xc900185b


10 states dumped

----------------------------------------------------------------------------------

SAA7133 Card - State 0:
SAA7134_GPIO_GPMODE:             00028000   (00000000 00000010 10000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094bf00 * (00000000 10010100 10111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         80         (10000000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 0 -> State 1:
SAA7134_GPIO_GPSTATUS:           0094bf00 -> 00943f00  (-------- -------- 1------- --------)  

1 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 1:
SAA7134_GPIO_GPMODE:             00028000   (00000000 00000010 10000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           00943f00   (00000000 10010100 00111111 00000000)  (was: 0094bf00)
SAA7134_ANALOG_IN_CTRL1:         80         (10000000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 1 -> State 2:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 2:
SAA7134_GPIO_GPMODE:             00028000 * (00000000 00000010 10000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           00943f00 * (00000000 10010100 00111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         80 *       (10000000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 2 -> State 3:
SAA7134_GPIO_GPMODE:             00028000 -> 0002c000  (-------- -------- -0------ --------)  
SAA7134_GPIO_GPSTATUS:           00943f00 -> 0094ff00  (-------- -------- 00------ --------)  
SAA7134_ANALOG_IN_CTRL1:         80       -> 88        (----0---)                             

3 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 3:
SAA7134_GPIO_GPMODE:             0002c000 * (00000000 00000010 11000000 00000000)  (was: 00028000)
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)  (was: 00943f00)
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                             (was: 80)      
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 3 -> State 4:
SAA7134_GPIO_GPMODE:             0002c000 -> 0082c000  (-------- 0------- -------- --------)  

1 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 4:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)  (was: 0002c000)
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 4 -> State 5:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 5:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 5 -> State 6:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 6:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 6 -> State 7:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 7:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 7 -> State 8:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 8:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 8 -> Register Dump:

0 changes


=================================================================================

SAA7133 Card - Register Dump:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            

end of dump

------------gsGSDaGZk5DFQthzlbK855
Content-Disposition: attachment; filename=SAA7133_0_04.txt
Content-Type: text/plain; name=SAA7133_0_04.txt
Content-Transfer-Encoding: 7bit

SAA7133 Card [0]:

Vendor ID:           0x1131
Device ID:           0x7133
Subsystem ID:        0xc900185b


8 states dumped

----------------------------------------------------------------------------------

SAA7133 Card - State 0:
SAA7134_GPIO_GPMODE:             ffffffff * (11111111 11111111 11111111 11111111)                 
SAA7134_GPIO_GPSTATUS:           ffffffff * (11111111 11111111 11111111 11111111)                 
SAA7134_ANALOG_IN_CTRL1:         ff *       (11111111)                                            
SAA7133_ANALOG_IO_SELECT:        ff *       (11111111)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     ffffffff * (11111111 11111111 11111111 11111111)                 
SAA7133_PLL_CONTROL:             ff *       (11111111)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  ffffffff * (11111111 11111111 11111111 11111111)                 
SAA7134_VIDEO_PORT_CTRL0:        ffffffff * (11111111 11111111 11111111 11111111)                 
SAA7134_VIDEO_PORT_CTRL4:        ffffffff * (11111111 11111111 11111111 11111111)                 
SAA7134_VIDEO_PORT_CTRL8:        ff *       (11111111)                                            
SAA7134_I2S_OUTPUT_SELECT:       ff *       (11111111)                                            
SAA7134_I2S_OUTPUT_FORMAT:       ff *       (11111111)                                            
SAA7134_I2S_OUTPUT_LEVEL:        ff *       (11111111)                                            
SAA7134_I2S_AUDIO_OUTPUT:        ff *       (11111111)                                            
SAA7134_TS_PARALLEL:             ff *       (11111111)                                            
SAA7134_TS_PARALLEL_SERIAL:      ff *       (11111111)                                            
SAA7134_TS_SERIAL0:              ff *       (11111111)                                            
SAA7134_TS_SERIAL1:              ff *       (11111111)                                            
SAA7134_TS_DMA0:                 ff *       (11111111)                                            
SAA7134_TS_DMA1:                 ff *       (11111111)                                            
SAA7134_TS_DMA2:                 ff *       (11111111)                                            
SAA7134_SPECIAL_MODE:            ff *       (11111111)                                            


Changes: State 0 -> State 1:
SAA7134_GPIO_GPMODE:             ffffffff -> 00028000  (11111111 111111-1 -1111111 11111111)  
SAA7134_GPIO_GPSTATUS:           ffffffff -> 0094bf00  (11111111 -11-1-11 -1------ 11111111)  
SAA7134_ANALOG_IN_CTRL1:         ff       -> 80        (-1111111)                             
SAA7133_ANALOG_IO_SELECT:        ff       -> 02        (111111-1)                             
SAA7133_AUDIO_CLOCK_NOMINAL:     ffffffff -> 03187de7  (111111-- 111--111 1-----1- ---11---)  
SAA7133_PLL_CONTROL:             ff       -> 03        (111111--)                             
SAA7133_AUDIO_CLOCKS_PER_FIELD:  ffffffff -> 0001e000  (11111111 1111111- ---11111 11111111)  
SAA7134_VIDEO_PORT_CTRL0:        ffffffff -> 00000000  (11111111 11111111 11111111 11111111)  
SAA7134_VIDEO_PORT_CTRL4:        ffffffff -> 00000000  (11111111 11111111 11111111 11111111)  
SAA7134_VIDEO_PORT_CTRL8:        ff       -> 00        (11111111)                             
SAA7134_I2S_OUTPUT_SELECT:       ff       -> 00        (11111111)                             
SAA7134_I2S_OUTPUT_FORMAT:       ff       -> 00        (11111111)                             
SAA7134_I2S_OUTPUT_LEVEL:        ff       -> 00        (11111111)                             
SAA7134_I2S_AUDIO_OUTPUT:        ff       -> 11        (111-111-)                             
SAA7134_TS_PARALLEL:             ff       -> 04        (11111-11)                             
SAA7134_TS_PARALLEL_SERIAL:      ff       -> 00        (11111111)                             
SAA7134_TS_SERIAL0:              ff       -> 00        (11111111)                             
SAA7134_TS_SERIAL1:              ff       -> 00        (11111111)                             
SAA7134_TS_DMA0:                 ff       -> 00        (11111111)                             
SAA7134_TS_DMA1:                 ff       -> 00        (11111111)                             
SAA7134_TS_DMA2:                 ff       -> 00        (11111111)                             
SAA7134_SPECIAL_MODE:            ff       -> 01        (1111111-)                             

22 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 1:
SAA7134_GPIO_GPMODE:             00028000   (00000000 00000010 10000000 00000000)  (was: ffffffff)
SAA7134_GPIO_GPSTATUS:           0094bf00 * (00000000 10010100 10111111 00000000)  (was: ffffffff)
SAA7134_ANALOG_IN_CTRL1:         80         (10000000)                             (was: ff)      
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                             (was: ff)      
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)  (was: ffffffff)
SAA7133_PLL_CONTROL:             03         (00000011)                             (was: ff)      
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)  (was: ffffffff)
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)  (was: ffffffff)
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)  (was: ffffffff)
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                             (was: ff)      
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                             (was: ff)      
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                             (was: ff)      
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                             (was: ff)      
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                             (was: ff)      
SAA7134_TS_PARALLEL:             04         (00000100)                             (was: ff)      
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                             (was: ff)      
SAA7134_TS_SERIAL0:              00         (00000000)                             (was: ff)      
SAA7134_TS_SERIAL1:              00         (00000000)                             (was: ff)      
SAA7134_TS_DMA0:                 00         (00000000)                             (was: ff)      
SAA7134_TS_DMA1:                 00         (00000000)                             (was: ff)      
SAA7134_TS_DMA2:                 00         (00000000)                             (was: ff)      
SAA7134_SPECIAL_MODE:            01         (00000001)                             (was: ff)      


Changes: State 1 -> State 2:
SAA7134_GPIO_GPSTATUS:           0094bf00 -> 00943f00  (-------- -------- 1------- --------)  

1 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 2:
SAA7134_GPIO_GPMODE:             00028000   (00000000 00000010 10000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           00943f00   (00000000 10010100 00111111 00000000)  (was: 0094bf00)
SAA7134_ANALOG_IN_CTRL1:         80         (10000000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 2 -> State 3:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 3:
SAA7134_GPIO_GPMODE:             00028000 * (00000000 00000010 10000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           00943f00 * (00000000 10010100 00111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         80 *       (10000000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 3 -> State 4:
SAA7134_GPIO_GPMODE:             00028000 -> 0002c000  (-------- -------- -0------ --------)  
SAA7134_GPIO_GPSTATUS:           00943f00 -> 0094ff00  (-------- -------- 00------ --------)  
SAA7134_ANALOG_IN_CTRL1:         80       -> 88        (----0---)                             

3 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 4:
SAA7134_GPIO_GPMODE:             0002c000   (00000000 00000010 11000000 00000000)  (was: 00028000)
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)  (was: 00943f00)
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                             (was: 80)      
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 4 -> State 5:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 5:
SAA7134_GPIO_GPMODE:             0002c000 * (00000000 00000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 5 -> State 6:
SAA7134_GPIO_GPMODE:             0002c000 -> 0082c000  (-------- 0------- -------- --------)  

1 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 6:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)  (was: 0002c000)
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 6 -> Register Dump:

0 changes


=================================================================================

SAA7133 Card - Register Dump:
SAA7134_GPIO_GPMODE:             0082c000   (00000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0094ff00   (00000000 10010100 11111111 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04         (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)                                            
SAA7134_TS_SERIAL0:              00         (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00         (00000000)                                            
SAA7134_TS_DMA1:                 00         (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            

end of dump

------------gsGSDaGZk5DFQthzlbK855--

