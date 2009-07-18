Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48274 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148AbZGRKj7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2009 06:39:59 -0400
Received: by fxm18 with SMTP id 18so1159906fxm.37
        for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 03:39:57 -0700 (PDT)
Date: Sat, 18 Jul 2009 12:40:07 +0200
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Report: Compro Videomate Vista T750F
From: "=?windows-1250?B?U2FtdWVsIFJha2l0bmnoYW4=?=" <semirocket@gmail.com>
Content-Type: multipart/mixed; boundary=----------kFnDTGmERxdeuTIhhwXRFn
MIME-Version: 1.0
References: <op.uwycxowt80yj81@localhost>
 <1247434386.5152.28.camel@pc07.localdom.local> <op.uw4gkkks80yj81@localhost>
 <1247878736.4268.52.camel@pc07.localdom.local>
Message-ID: <op.uw9ek3vot7szun@crni.lan>
In-Reply-To: <1247878736.4268.52.camel@pc07.localdom.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

------------kFnDTGmERxdeuTIhhwXRFn
Content-Type: text/plain; format=flowed; delsp=yes; charset=windows-1250
Content-Transfer-Encoding: 7bit

Hi,

On Sat, 18 Jul 2009 02:58:56 +0200, hermann pitton  
<hermann-pitton@arcor.de> wrote:

>> (full log: http://pastebin.com/f5f8e6184)
>
> Hi Samuel,
>
> the above link still gives error not found.
>

Strange, because to me works just fine. I'm going to add it directly as an  
email attachement this time.

> For an external audio mux it is always a single gpio pin for that.
>
> It is some same pin in the same state for composite and s-video,
> but different for TV mode.
>
> The above seems not to show such a pattern.
>
> Also you missed to print GPIO_GPMODE, which is the gpio mask.
> In that, pins actively used for switching are high, but m$ drivers do
> often also have for that specific card unrelated pins high.
>
> Gpio 8 to 15 are the remote gpios and gpio18 should be the key
> press/release.
>
> The rest above seems not to be consistent for what we are searching for.
>
> If you get some time again, do a cold boot and dump the gpio mode and
> state before any application did use the card.
>
> Then dump analog TV, composite and s-video and anything else you can
> test. The GPMODE and the GPSTATUS on top of any mode used is what is
> really interesting.
>

As I mentioned before GPSTATUS keeps changing all the time (And I mean  
frequent, measurable in miliseconds), and it seems that it hasn't any  
connection between other values.

> It also prints the state of all gpios for each mode in binary, so if you
> manually mark the states you used, one can just copy and paste line by
> line and see the changing pins.
>
> As said, it should be a pin in the mask/GPMODE being the same for
> composite and s-video, but different for analog TV. Maybe better use the
> Compro software to get the logs.
>

The mask/GPMODE doesn't change at all.

I have used Compro software this time.

> Cheers,
> Hermann
>
>


Regards

------------kFnDTGmERxdeuTIhhwXRFn
Content-Disposition: attachment; filename=SAA7133_0_cold-boot.txt
Content-Type: text/plain; name=SAA7133_0_cold-boot.txt
Content-Transfer-Encoding: 7bit

SAA7133 Card [0]:

Vendor ID:           0x1131
Device ID:           0x7133
Subsystem ID:        0xc900185b


11 states dumped

----------------------------------------------------------------------------------

SAA7133 Card - State 0:
SAA7134_GPIO_GPMODE:             8082c000   (10000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0284ff00 * (00000010 10000100 11111111 00000000)                 
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


Changes: State 0 -> State 1: *****(Cold boot, nothing runs GPSTATUS keeps changing)
SAA7134_GPIO_GPSTATUS:           0284ff00 -> 0694ff00  (-----0-- ---0---- -------- --------)  

1 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 1:
SAA7134_GPIO_GPMODE:             8082c000   (10000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0694ff00 * (00000110 10010100 11111111 00000000)  (was: 0284ff00)
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


Changes: State 1 -> State 2: *****(Nothing runs)
SAA7134_GPIO_GPSTATUS:           0694ff00 -> 0294ff00  (-----1-- -------- -------- --------)  

1 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 2:
SAA7134_GPIO_GPMODE:             8082c000   (10000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0294ff00 * (00000010 10010100 11111111 00000000)  (was: 0694ff00)
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


Changes: State 2 -> State 3: *****(Nothing runs)
SAA7134_GPIO_GPSTATUS:           0294ff00 -> 0084ff00  (------1- ---1---- -------- --------)  

1 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 3:
SAA7134_GPIO_GPMODE:             8082c000   (10000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0084ff00 * (00000000 10000100 11111111 00000000)  (was: 0294ff00)
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


Changes: State 3 -> State 4: *****(Nothing runs)
SAA7134_GPIO_GPSTATUS:           0084ff00 -> 0494ff00  (-----0-- ---0---- -------- --------)  

1 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 4:
SAA7134_GPIO_GPMODE:             8082c000   (10000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0494ff00 * (00000100 10010100 11111111 00000000)  (was: 0084ff00)
SAA7134_ANALOG_IN_CTRL1:         88 *       (10001000)                                            
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


Changes: State 4 -> State 5: *****(Turning on win software shows analog tv)
SAA7134_GPIO_GPSTATUS:           0494ff00 -> 0884ff00  (----01-- ---1---- -------- --------)  
SAA7134_ANALOG_IN_CTRL1:         88       -> 83        (----1-00)                             

2 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 5:
SAA7134_GPIO_GPMODE:             8082c000   (10000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0884ff00 * (00001000 10000100 11111111 00000000)  (was: 0494ff00)
SAA7134_ANALOG_IN_CTRL1:         83 *       (10000011)                             (was: 88)      
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7 * (00000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             03 *       (00000011)                                            
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


Changes: State 5 -> State 6: *****(Switch to Composite)
SAA7134_GPIO_GPSTATUS:           0884ff00 -> 0494ff00  (----10-- ---0---- -------- --------)  (same as 4)
SAA7134_ANALOG_IN_CTRL1:         83       -> 81        (------1-)                             
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7 -> 43187de7  (-0------ -------- -------- --------)  
SAA7133_PLL_CONTROL:             03       -> 43        (-0------)                             

4 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 6:
SAA7134_GPIO_GPMODE:             8082c000   (10000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0494ff00 * (00000100 10010100 11111111 00000000)  (was: 0884ff00)
SAA7134_ANALOG_IN_CTRL1:         81 *       (10000001)                             (was: 83)      
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     43187de7   (01000011 00011000 01111101 11100111)  (was: 03187de7)
SAA7133_PLL_CONTROL:             43         (01000011)                             (was: 03)      
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


Changes: State 6 -> State 7: *****(Switch to S-Video)
SAA7134_GPIO_GPSTATUS:           0494ff00 -> 0084ff00  (-----1-- ---1---- -------- --------)  (same as 3)
SAA7134_ANALOG_IN_CTRL1:         81       -> 88        (----0--1)                             (same as 0, 1, 2, 3, 4)

2 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 7:
SAA7134_GPIO_GPMODE:             8082c000   (10000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0084ff00 * (00000000 10000100 11111111 00000000)  (was: 0494ff00)
SAA7134_ANALOG_IN_CTRL1:         88         (10001000)                             (was: 81)      
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     43187de7   (01000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             43         (01000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             04 *       (00000100)                                            
SAA7134_TS_PARALLEL_SERIAL:      00 *       (00000000)                                            
SAA7134_TS_SERIAL0:              00 *       (00000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 00 *       (00000000)                                            
SAA7134_TS_DMA1:                 00 *       (00000000)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 7 -> State 8: *****(Switch to DVB-T, I can't see DVB-T yet, so it's showing a black screen)
SAA7134_GPIO_GPSTATUS:           0084ff00 -> 0694ff00  (-----00- ---0---- -------- --------)  (same as 1)
SAA7134_TS_PARALLEL:             04       -> e4        (000-----)                             
SAA7134_TS_PARALLEL_SERIAL:      00       -> b9        (0-000--0)                             
SAA7134_TS_SERIAL0:              00       -> 40        (-0------)                             
SAA7134_TS_DMA0:                 00       -> 35        (--00-0-0)                             
SAA7134_TS_DMA1:                 00       -> 01        (-------0)                             

6 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 8:
SAA7134_GPIO_GPMODE:             8082c000   (10000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0694ff00 * (00000110 10010100 11111111 00000000)  (was: 0084ff00)
SAA7134_ANALOG_IN_CTRL1:         88 *       (10001000)                                            
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     43187de7 * (01000011 00011000 01111101 11100111)                 
SAA7133_PLL_CONTROL:             43 *       (01000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             e4 *       (11100100)                             (was: 04)      
SAA7134_TS_PARALLEL_SERIAL:      b9         (10111001)                             (was: 00)      
SAA7134_TS_SERIAL0:              40         (01000000)                             (was: 00)      
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 35         (00110101)                             (was: 00)      
SAA7134_TS_DMA1:                 01         (00000001)                             (was: 00)      
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 8 -> State 9: *****(Switch back to analog)
SAA7134_GPIO_GPSTATUS:           0694ff00 -> 0c84ff00  (----0-1- ---1---- -------- --------)  
SAA7134_ANALOG_IN_CTRL1:         88       -> 83        (----1-00)                             (same as 5)
SAA7133_AUDIO_CLOCK_NOMINAL:     43187de7 -> 03187de7  (-1------ -------- -------- --------)  (same as 0, 1, 2, 3, 4, 5)
SAA7133_PLL_CONTROL:             43       -> 03        (-1------)                             (same as 0, 1, 2, 3, 4, 5)
SAA7134_TS_PARALLEL:             e4       -> 64        (1-------)                             

5 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 9:
SAA7134_GPIO_GPMODE:             8082c000   (10000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0c84ff00 * (00001100 10000100 11111111 00000000)  (was: 0694ff00)
SAA7134_ANALOG_IN_CTRL1:         83         (10000011)                             (was: 88)      
SAA7133_ANALOG_IO_SELECT:        02         (00000010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03187de7   (00000011 00011000 01111101 11100111)  (was: 43187de7)
SAA7133_PLL_CONTROL:             03         (00000011)                             (was: 43)      
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        11         (00010001)                                            
SAA7134_TS_PARALLEL:             64         (01100100)                             (was: e4)      
SAA7134_TS_PARALLEL_SERIAL:      b9         (10111001)                                            
SAA7134_TS_SERIAL0:              40         (01000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 35         (00110101)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 9 -> Register Dump:
SAA7134_GPIO_GPSTATUS:           0c84ff00 -> 0e94ff00  (------0- ---0---- -------- --------)  

1 changes


=================================================================================

SAA7133 Card - Register Dump:
SAA7134_GPIO_GPMODE:             8082c000   (10000000 10000010 11000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           0e94ff00   (00001110 10010100 11111111 00000000)  (was: 0c84ff00)
SAA7134_ANALOG_IN_CTRL1:         83         (10000011)                                            
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
SAA7134_TS_PARALLEL:             64         (01100100)                                            
SAA7134_TS_PARALLEL_SERIAL:      b9         (10111001)                                            
SAA7134_TS_SERIAL0:              40         (01000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 35         (00110101)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            

end of dump

------------kFnDTGmERxdeuTIhhwXRFn--

