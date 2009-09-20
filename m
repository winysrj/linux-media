Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:46087 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbZITIYc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2009 04:24:32 -0400
Message-ID: <4AB5E6AC.1090505@cogweb.net>
Date: Sun, 20 Sep 2009 01:24:12 -0700
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: linux-media@vger.kernel.org
Subject: Re: Audio drop on saa7134
References: <4AAEFEC9.3080405@cogweb.net>	 <20090915000841.56c24dd6@pedra.chehab.org>  <4AAF11EC.3040800@cogweb.net>	 <1252988501.3250.62.camel@pc07.localdom.local>	 <4AAF232F.9060204@cogweb.net> <1252993000.3250.97.camel@pc07.localdom.local> <4AAF2F1B.2050206@cogweb.net>
In-Reply-To: <4AAF2F1B.2050206@cogweb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann --

I ran in debug mode; results below -- and let me correct a mistake: 
these are 7134 cards, not 7135. I tried some low-profile 7135 cards, but 
got a far higher rate of audio drops and stopped using them.

David Liontooth wrote:
> hermann pitton wrote:
>> Am Montag, den 14.09.2009, 22:16 -0700 schrieb David Liontooth:
>>  
>>> hermann pitton wrote:
>>>    
>>>> Am Montag, den 14.09.2009, 21:02 -0700 schrieb David Liontooth:
>>>>        
>>>>> <snip>
>>>>> We've been using saa7135 cards for several years with relatively 
>>>>> few incidents, but they occasionally drop audio.
>>>>> I've been unable to find any pattern in the audio drops, so I 
>>>>> haven't reported it -- I have no way to reproduce the error, but 
>>>>> it happens regularly, affecting between 3 and 5% of recordings. 
>>>>> Audio will sometimes drop in the middle of a recording and then 
>>>>> resume, or else work fine on the next recording.
>>>>>             
>>>> Hi Dave,
>>>>
>>>> hmm, losing audio on three to five percent of the recordings is a lot!
>>>>
>>>> When we started to talk to each other, we had only saa7134 PAL/SECAM
>>>> devices over here.
>>>>
>>>> That has changed a lot, but still no System-M here.
>>>>
>>>> The kernel thread detecting audio on saa7133/35/31e behaves different
>>>> from the one on saa7134.
>>>>
>>>> But if you let it run with audio_debug=1, you should have something in
>>>> the logs when losing the audio. The kernel audio detection thread must
>>>> have been started without success or id find the right thing again. I
>>>> would assume caused by a weaker signal in between.
>>>>
>>>> Do you know about the insmod option audio_ddep?
>>>>
>>>> It is pretty hidden and I almost must look it up myself in the code.
>>>>
>>>> Cheers,
>>>> Hermann
>>>>
>>>>         
>>> OK, I'll try running with audio_debug=1. Could you clarify what you 
>>> mean by "The kernel audio detection thread must have been started 
>>> without success or id find the right thing again"? An audio drop can 
>>> be initiated at any point in the recording. A weak signal is a good 
>>> guess, but I've never noticed a correlation with video quality.
>>>     
>>
>> You said audio sometimes recovers, than the kernel thread did detect it
>> again, else failed on the pilots.
>>
>>  
>>> I didn't know about audio_ddep -- what does it do? I'm not seeing it 
>>> in modinfo.
>>>     
>>
>> Oh, are you sure?
>>
>>   
> My mistake -- I'm running 2.6.19 and it's there.
>>> It would be fantastic to get this problem solved -- we've had to 
>>> record everything in parallel to avoid loss, and still very 
>>> occasionally lose sound.
>>>     
>>
>> It could also be something else, but that is the point to start.
>>
>> It stops the kernel audio detection thread and tells him to believe that
>> only the norm given by insmod should be assumed.
>>
>> It is some hex in saa7134-audio, don't know it off hand for NTSC.
>>
>> Wait, i'll look it up. 0x40.
>>   
> Thank you! I'll try turning off the audio detection thread first, and 
> then run debug.
>
> options saa7134 card=95,95,95,95 tuner=39,39,39,39 
> audio_ddep=0x40,0x40,0x40,0x40 # audio_debug=9,9,9,9
>
> It's a production system so I may need to wait until the weekend.
>
> Cheers,
> Dave

I added the audio_ddep value and it appears to have no effect; audio 
drops continued at the previous rate on two machines.

I removed the audio_ddep parameter and added audio_debug=9:

saa7133[4]: found at 0000:02:03.0, rev: 16, irq: 16, latency: 64, mmio: 
0xff2ff800
saa7133[4]: subsystem: 5169:0138, board: LifeView FlyVIDEO3000 
[card=2,insmod option]
saa7133[4]: board init: gpio is 39900
saa7133[4]: there are different flyvideo cards with different tuners
saa7133[4]: out there, you might have to use the tuner=<nr> insmod
saa7133[4]: option to override the default value.
tuner 4-0061: chip found @ 0xc2 (saa7133[4])
tuner 4-0061: type set to 39 (LG NTSC (newer TAPC series))
tuner 4-0061: type set to 39 (LG NTSC (newer TAPC series))
tuner 4-0063: chip found @ 0xc6 (saa7133[4])
saa7133[4]: i2c eeprom 00: 69 51 38 01 ff 28 ff ff ff ff ff ff ff ff ff ff
saa7133[4]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[4]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[4]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[4]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[4]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[4]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[4]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[4]/audio: dsp write reg 0x464 = 0x000000
saa7133[4]/audio: dsp write reg 0x46c = 0xbbbbbb
saa7133[4]/audio: dsp write reg 0x464 = 0x000000
saa7133[4]/audio: dsp write reg 0x46c = 0xbbbbbb
saa7133[4]/audio: dsp write reg 0x474 = 0x000000
saa7133[4]/audio: dsp write reg 0x450 = 0x000000
saa7133[4]/audio: tvaudio thread scan start [1]
saa7133[4]/audio: scanning: B/G D/K I
saa7133[4]/audio: dsp write reg 0x454 = 0x000000
saa7133[4]/audio: dsp write reg 0x454 = 0x0000ac
saa7133[4]/audio: dsp write reg 0x464 = 0x000000
saa7133[4]/audio: dsp write reg 0x470 = 0x101010
saa7133[4]: registered device video2 [v4l2]
saa7133[4]: registered device vbi2
saa7133[4]: registered device radio2
saa7133[4]/audio: dsp write reg 0x464 = 0x000000
saa7133[4]/audio: dsp write reg 0x46c = 0xbbbbbb
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xff6b3800 irq 27 registered as card 1
saa7133[1]/alsa: saa7133[1] at 0xff6b3000 irq 28 registered as card 3
saa7133[2]/alsa: saa7133[2] at 0xff6b2800 irq 29 registered as card 5
saa7133[3]/alsa: saa7133[3] at 0xff6b2000 irq 30 registered as card 4
saa7133[4]/alsa: saa7133[4] at 0xff2ff800 irq 16 registered as card 2
saa7133[0]/audio: dsp write reg 0x46c = 0xbbbb10
saa7133[0]/audio: dsp write reg 0x464 = 0x000003
saa7133[0]/audio: tvaudio thread status: 0x100000 [no standard detected]
saa7133[0]/audio: detailed status: ############# init done
saa7133[1]/audio: tvaudio thread status: 0x100000 [no standard detected]
saa7133[1]/audio: detailed status: ############# init done
saa7133[2]/audio: tvaudio thread status: 0x100000 [no standard detected]
saa7133[2]/audio: detailed status: ############# init done
saa7133[3]/audio: tvaudio thread status: 0x100001 [B/G (in progress)]
saa7133[3]/audio: detailed status: ############# init done
saa7133[4]/audio: tvaudio thread status: 0x100000 [no standard detected]
saa7133[4]/audio: detailed status: ############# init done

When audio is detected correctly, I get this sort of thing:

Sep 18 07:00:01 prato /USR/SBIN/CRON[13590]: (tna) CMD (channel 7, 
60min, "Good Morning America", 2)
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: tvaudio thread scan 
start [32]
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: scanning: M
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x454 = 
0x000000
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x454 = 
0x0000c0
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x470 = 
0x101010
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: tvaudio thread scan 
start [33]
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: scanning: M
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x454 = 
0x000000
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x454 = 
0x0000c0
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x470 = 
0x101010
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbb10
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbb10
Sep 18 07:00:04 prato kernel: saa7133[4]/audio: tvaudio thread status: 
0x100003 [M (in progress)]
Sep 18 07:00:04 prato kernel: saa7133[4]/audio: detailed status: 
############# init done
Sep 18 07:59:57 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 07:59:57 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 18 07:59:57 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 07:59:57 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 
0xbbbbbb

The pattern is a four-second initialization and a split-second 
termination as the recording ends.

When audio is dropped, I get this:

Sep 18 08:00:01 prato /USR/SBIN/CRON[21608]: (tna) CMD (channel 7, 
60min, "Good Morning America", 3)
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: tvaudio thread scan 
start [29]
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: scanning: M
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x454 = 
0x000000
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x454 = 
0x0000c0
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x470 = 
0x101010
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: tvaudio thread scan 
start [30]
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: scanning: M
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x454 = 
0x000000
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x454 = 
0x0000c0
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x470 = 
0x101010
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x46c = 
0xbbbb10
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 08:00:01 prato kernel: saa7133[1]/audio: dsp write reg 0x46c = 
0xbbbb10
Sep 18 08:00:04 prato kernel: saa7133[1]/audio: tvaudio thread status: 
0x100003 [M (in progress)]
Sep 18 08:00:04 prato kernel: saa7133[1]/audio: detailed status: 
############# init done
Sep 18 08:27:36 prato -- MARK --
Sep 18 08:53:59 prato kernel: saa7133[1]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 08:53:59 prato kernel: saa7133[1]/audio: dsp write reg 0x46c = 
0xbbbb10
Sep 18 08:53:59 prato kernel: saa7133[1]/audio: tvaudio thread scan 
start [31]
Sep 18 08:53:59 prato kernel: saa7133[1]/audio: scanning: M
Sep 18 08:53:59 prato kernel: saa7133[1]/audio: dsp write reg 0x454 = 
0x000000
Sep 18 08:53:59 prato kernel: saa7133[1]/audio: dsp write reg 0x454 = 
0x0000c0
Sep 18 08:53:59 prato kernel: saa7133[1]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 08:53:59 prato kernel: saa7133[1]/audio: dsp write reg 0x470 = 
0x101010
Sep 18 08:54:02 prato kernel: saa7133[1]/audio: tvaudio thread status: 
0x100003 [M (in progress)]
Sep 18 08:54:02 prato kernel: saa7133[1]/audio: detailed status: 
############# init done
Sep 18 08:59:57 prato kernel: saa7133[1]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 08:59:57 prato kernel: saa7133[1]/audio: dsp write reg 0x46c = 
0xbbbbbb
Sep 18 08:59:57 prato kernel: saa7133[1]/audio: dsp write reg 0x464 = 
0x000000
Sep 18 08:59:57 prato kernel: saa7133[1]/audio: dsp write reg 0x46c = 
0xbbbbbb

The actual audio drop starts at 08:27:46 --

soundcheck 2009-09-18_0800_KABC_Good_Morning_America.mp3

Searching for dropped audio on Saturday September 19, 2009 at 11:36:42 
PM -- this can take several minutes

        2009-09-18_0800_KABC_Good_Morning_America.mp3

                Found dropped audio in this interval:

                00:27:46 - 00:53:59 (1573 seconds)

Unfortunately, there's no trace of the drop in the logs -- it shows only 
that the scanning restarts at 08:53:59, at which point sound recording 
resumes.

Is there anything I can do to make the problem show up when it happens?

I should also mention that I record the same program from the same RF 
feed on two different computers, and the other recording was fine. It's 
extremely unusual for both recordings to have dropped audio at the same 
time -- if that happens, it's just a signal issue and I deal with it 
accordingly.

I have no comparison data from other OSes and don't know if this is a 
Linux driver or a hardware issue.

Cheers,
Dave


