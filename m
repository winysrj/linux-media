Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6U63YY9025738
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 02:03:34 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.168])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6U63FFb008286
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 02:03:15 -0400
Received: by wf-out-1314.google.com with SMTP id 25so228471wfc.6
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 23:03:14 -0700 (PDT)
Message-ID: <4890041D.5050303@gmail.com>
Date: Tue, 29 Jul 2008 22:03:09 -0800
From: D <therealisttruest@gmail.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <486FF148.2060506@gmail.com>	
	<1215298086.3237.19.camel@pc10.localdom.local>
	<48700079.6000209@gmail.com>	 <48701944.2040200@gmail.com>
	<1215343839.2852.14.camel@pc10.localdom.local>	
	<48716CED.6010608@gmail.com>
	<1215459667.3762.35.camel@pc10.localdom.local>
	<4884232E.8040803@gmail.com>
In-Reply-To: <4884232E.8040803@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Help with Chinese card
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

D wrote:
> hermann pitton wrote:
>> Am Sonntag, den 06.07.2008, 17:10 -0800 schrieb D:
>>   
>>>> "garbled video" can mean lots of different things.
>>>> Black and white only would be simplest, since indicating some wrong
>>>> vmux.
>>>>
>>>>   
>>>>       
>>> When I added card 145, I did have one of the 8 cameras that are set up
>>> showing grainy, black and white video with a very bad jitter to
>>> it(this was using ntsc, not pal). This was with vmux=2 I believe. I
>>> tried 0,1, and 3 as well just to see if it was a bit off, but only
>>> ended up with black output. The other videos were black as well, even
>>> though there should have been video in at least one or two others.
>>>     
>>>>>> [44494.080206] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
>>>>>> Capture
>>>>>> [44494.080210] saa7130[0]: subsystem: 1131:0000, board: 
>>>>>> UNKNOWN/GENERIC [card=0,autodetected]
>>>>>> [44494.080220] saa7130[0]: board init: gpio is c013ef0
>>>>>>       
>>>>>>           
>>>> ^^^^^^^^^^^^^^^
>>>>
>>>> In such a case, this is the only indication if it might have been seen
>>>> already previously. 
>>>>
>>>> If this is after a boot prior to mess around with other card entries or
>>>> trying something yourself on gpios, it looks like this device was not
>>>> seen yet then.
>>>>
>>>>   
>>>>       
>>>>>> [44494.807913] saa7134:   card=145 -> AOPVision AOP-8008A 16CH/240fps 
>>>>>> Capture
>>>>>> [44494.807917] saa7130[7]: subsystem: 1131:0000, board: 
>>>>>> UNKNOWN/GENERIC [card=0,autodetected]
>>>>>> [44494.807930] saa7130[7]: board init: gpio is 10000
>>>>>>       
>>>>>>           
>>>> ^^^^^^^^^^              ^^^^^^^^^^^^^
>>>> Seems to be still unique here.
>>>>   
>>>>       
>>> As far as autodetection goes, when I originally started working on
>>> this, it was card number 0, by default. What I did above to get it
>>> back to that point was modprobe saa7134, without the 'card=' argument,
>>> so that tells me it doesn't autodetect it correctly or recognize it.
>>> As I said before card number 145 is my own, but it's not correct
>>> either. Do you have any tips on what I can do next. I know this card
>>> is not yet supported as is, but would like to get it working and
>>> perhaps get support added to it for other users in the future.  My
>>> idea was to change the gpio values, but it sounds like that could be a
>>> problem unless I can find what the correct values are. Any ideas? I'm
>>> willing to do what I can, but I need some guidance on this one.
>>>
>>>     
>>
>> A valid input for composite video is also vmux = 4 and is used by
>> several manufactures. Higher vmux inputs are for s-video.
>> For composite over s-video vmux = 0 is usually used.
>>
>> If you thing gpios are in use for some switching, regspy.exe might be
>> your friend (DScaler - deinterlace.sf.net) to investigate the other
>> driver and software.
>>
>> Still don't know which device it exactly is, but they seem to use a PLX
>> PCI bridge. Identifying that device and getting the datasheet might give
>> you some further hints too.
>> http://www.plxtech.com
>>
>> Good Luck,
>> Hermann
>>
>>
>>
>>
>>   
> It's been awhile and I've tried the different vmux settings with no 
> luck. I did manage to get a card here locally and now I have one 
> sitting in my machine as well. Before putting it in the Linux box, I 
> put it in Windows and used RegSpy and got seven dumps, one for each 
> recognized card( even though there is one card, it recognizes seven). 
> I tried doing .gpio = ...... but not much success. Hopefully, by 
> posting these dumps this will provide more info and hopefully more 
> help. I also can't find much info on what the pci bridge is(or at 
> least I think that's what I was trying to find). So I'll post the 
> numbers I got off the card and hopefully they'll be familiar or at 
> least easily identifiable by someone else.  Firstly, the model number 
> on the card is LE-8008A, part number looks like 8008A0803008479. There 
> are 8 chips with heat sinks(8 'cards') with 2 vga outs and 1 svideo 
> out. The pci chip has a logo that as best as I can describe is the 
> letter P with a lightning bolt through it. It does not look like the 
> other PLX logos on the site you gave me nor like the ones on the site 
> with the many, many other cards that include pics. The numbers on it 
> are P17C, then below that 8150BMAE, then below that B0750BT. I've 
> found nothing like that anywhere I've looked yet. Also, to answer a 
> previous inquiry, I don't believe that there is a tuner on this thing 
> as it is a card that is included in a security camera setup. Finally, 
> probably the most important part is the RegSpy dumps. They are like 
> this-----
>
> Card 0
> SAA7130 Card [0]:
>
> Vendor ID:           0x1131
> Device ID:           0x7130
> Subsystem ID:        0x00001131
>
>
> 3 states dumped
>
> ----------------------------------------------------------------------------------
>
> SAA7130 Card - State 0:
> SAA7134_GPIO_GPMODE:             00000000 * (00000000 00000000 
> 00000000 00000000)                
> SAA7134_GPIO_GPSTATUS:           0c013ef0 * (00001100 00000001 
> 00111110 11110000)                
> SAA7134_ANALOG_IN_CTRL1:         00 *       
> (00000000)                                           
> SAA7134_ANALOG_IO_SELECT:        00         
> (00000000)                                           
> SAA7134_VIDEO_PORT_CTRL0:        0000b000   (00000000 00000000 
> 10110000 00000000)                
> SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 
> 00000000 00000000)                
> SAA7134_VIDEO_PORT_CTRL8:        00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_SELECT:       00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_FORMAT:       00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_LEVEL:        00         
> (00000000)                                           
> SAA7134_I2S_AUDIO_OUTPUT:        00         
> (00000000)                                           
> SAA7134_TS_PARALLEL:             6c         
> (01101100)                                           
> SAA7134_TS_PARALLEL_SERIAL:      bb         
> (10111011)                                           
> SAA7134_TS_SERIAL0:              50         
> (01010000)                                           
> SAA7134_TS_SERIAL1:              01         
> (00000001)                                           
> SAA7134_TS_DMA0:                 37         
> (00110111)                                           
> SAA7134_TS_DMA1:                 01         
> (00000001)                                           
> SAA7134_TS_DMA2:                 00         
> (00000000)                                           
> SAA7134_SPECIAL_MODE:            00         
> (00000000)                                           
>
>
> Changes: State 0 -> State 1:
> SAA7134_GPIO_GPMODE:             00000000 -> 0c0e3c00  (----00-- 
> ----000- --0000-- --------) 
> SAA7134_GPIO_GPSTATUS:           0c013ef0 -> 040dfef0  (----1--- 
> ----00-- 00------ --------) 
> SAA7134_ANALOG_IN_CTRL1:         00       -> c2        
> (00----0-)                            
>
> 3 changes
>
>
> ----------------------------------------------------------------------------------
>
> SAA7130 Card - State 1:
> SAA7134_GPIO_GPMODE:             0c0e3c00   (00001100 00001110 
> 00111100 00000000)  (was: 00000000)
> SAA7134_GPIO_GPSTATUS:           040dfef0   (00000100 00001101 
> 11111110 11110000)  (was: 0c013ef0)
> SAA7134_ANALOG_IN_CTRL1:         c2         
> (11000010)                             (was: 00)     
> SAA7134_ANALOG_IO_SELECT:        00         
> (00000000)                                           
> SAA7134_VIDEO_PORT_CTRL0:        0000b000   (00000000 00000000 
> 10110000 00000000)                
> SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 
> 00000000 00000000)                
> SAA7134_VIDEO_PORT_CTRL8:        00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_SELECT:       00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_FORMAT:       00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_LEVEL:        00         
> (00000000)                                           
> SAA7134_I2S_AUDIO_OUTPUT:        00         
> (00000000)                                           
> SAA7134_TS_PARALLEL:             6c         
> (01101100)                                           
> SAA7134_TS_PARALLEL_SERIAL:      bb         
> (10111011)                                           
> SAA7134_TS_SERIAL0:              50         
> (01010000)                                           
> SAA7134_TS_SERIAL1:              01         
> (00000001)                                           
> SAA7134_TS_DMA0:                 37         
> (00110111)                                           
> SAA7134_TS_DMA1:                 01         
> (00000001)                                           
> SAA7134_TS_DMA2:                 00         
> (00000000)                                           
> SAA7134_SPECIAL_MODE:            00         
> (00000000)                                           
>
>
> Changes: State 1 -> Register Dump:
>
> 0 changes
>
>
> =================================================================================
>
> SAA7130 Card - Register Dump:
> SAA7134_GPIO_GPMODE:             0c0e3c00   (00001100 00001110 
> 00111100 00000000)                
> SAA7134_GPIO_GPSTATUS:           040dfef0   (00000100 00001101 
> 11111110 11110000)                
> SAA7134_ANALOG_IN_CTRL1:         c2         
> (11000010)                                           
> SAA7134_ANALOG_IO_SELECT:        00         
> (00000000)                                           
> SAA7134_VIDEO_PORT_CTRL0:        0000b000   (00000000 00000000 
> 10110000 00000000)                
> SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 
> 00000000 00000000)                
> SAA7134_VIDEO_PORT_CTRL8:        00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_SELECT:       00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_FORMAT:       00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_LEVEL:        00         
> (00000000)                                           
> SAA7134_I2S_AUDIO_OUTPUT:        00         
> (00000000)                                           
> SAA7134_TS_PARALLEL:             6c         
> (01101100)                                           
> SAA7134_TS_PARALLEL_SERIAL:      bb         
> (10111011)                                           
> SAA7134_TS_SERIAL0:              50         
> (01010000)                                           
> SAA7134_TS_SERIAL1:              01         
> (00000001)                                           
> SAA7134_TS_DMA0:                 37         
> (00110111)                                           
> SAA7134_TS_DMA1:                 01         
> (00000001)                                           
> SAA7134_TS_DMA2:                 00         
> (00000000)                                           
> SAA7134_SPECIAL_MODE:            00         
> (00000000)                                           
>
> end of dump
>
> Cards 1,2,4,5,6, and 7 (3 is different for some odd reason)
> SAA7130 Card [2]:
>
> Vendor ID:           0x1131
> Device ID:           0x7130
> Subsystem ID:        0x00001131
>
> =================================================================================
>
> SAA7130 Card - Register Dump:
> SAA7134_GPIO_GPMODE:             000e3c00   (00000000 00001110 
> 00111100 00000000)                
> SAA7134_GPIO_GPSTATUS:           000d0000   (00000000 00001101 
> 00000000 00000000)                
> SAA7134_ANALOG_IN_CTRL1:         c2         
> (11000010)                                           
> SAA7134_ANALOG_IO_SELECT:        00         
> (00000000)                                           
> SAA7134_VIDEO_PORT_CTRL0:        0000b000   (00000000 00000000 
> 10110000 00000000)                
> SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 
> 00000000 00000000)                
> SAA7134_VIDEO_PORT_CTRL8:        00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_SELECT:       00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_FORMAT:       00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_LEVEL:        00         
> (00000000)                                           
> SAA7134_I2S_AUDIO_OUTPUT:        00         
> (00000000)                                           
> SAA7134_TS_PARALLEL:             6c         
> (01101100)                                           
> SAA7134_TS_PARALLEL_SERIAL:      bb         
> (10111011)                                           
> SAA7134_TS_SERIAL0:              50         
> (01010000)                                           
> SAA7134_TS_SERIAL1:              01         
> (00000001)                                           
> SAA7134_TS_DMA0:                 37         
> (00110111)                                           
> SAA7134_TS_DMA1:                 01         
> (00000001)                                           
> SAA7134_TS_DMA2:                 00         
> (00000000)                                           
> SAA7134_SPECIAL_MODE:            00         
> (00000000)                                           
>
> end of dump
>
> Card 3
> SAA7130 Card [3]:
>
> Vendor ID:           0x1131
> Device ID:           0x7130
> Subsystem ID:        0x00001131
>
> =================================================================================
>
> SAA7130 Card - Register Dump:
> SAA7134_GPIO_GPMODE:             000effff   (00000000 00001110 
> 11111111 11111111)                
> SAA7134_GPIO_GPSTATUS:           000d1000   (00000000 00001101 
> 00010000 00000000)                
> SAA7134_ANALOG_IN_CTRL1:         c2         
> (11000010)                                           
> SAA7134_ANALOG_IO_SELECT:        00         
> (00000000)                                           
> SAA7134_VIDEO_PORT_CTRL0:        0000b000   (00000000 00000000 
> 10110000 00000000)                
> SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 
> 00000000 00000000)                
> SAA7134_VIDEO_PORT_CTRL8:        00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_SELECT:       00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_FORMAT:       00         
> (00000000)                                           
> SAA7134_I2S_OUTPUT_LEVEL:        00         
> (00000000)                                           
> SAA7134_I2S_AUDIO_OUTPUT:        00         
> (00000000)                                           
> SAA7134_TS_PARALLEL:             6c         
> (01101100)                                           
> SAA7134_TS_PARALLEL_SERIAL:      bb         
> (10111011)                                           
> SAA7134_TS_SERIAL0:              50         
> (01010000)                                           
> SAA7134_TS_SERIAL1:              01         
> (00000001)                                           
> SAA7134_TS_DMA0:                 37         
> (00110111)                                           
> SAA7134_TS_DMA1:                 01         
> (00000001)                                           
> SAA7134_TS_DMA2:                 00         
> (00000000)                                           
> SAA7134_SPECIAL_MODE:            00         
> (00000000)                                           
>
> end of dump
>
>
> Hope this helps more as I'm still a bit lost at this point.
>
> Thanks much
Anything from anyone? Please? It's still not working.

Thanks again
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
