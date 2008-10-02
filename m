Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f20.google.com ([209.85.217.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <yellowplantain@gmail.com>) id 1KlPP0-00053z-Ny
	for linux-dvb@linuxtv.org; Thu, 02 Oct 2008 16:43:40 +0200
Received: by gxk13 with SMTP id 13so1542266gxk.17
	for <linux-dvb@linuxtv.org>; Thu, 02 Oct 2008 07:43:04 -0700 (PDT)
Message-ID: <48E4DDEF.5060606@gmail.com>
Date: Fri, 03 Oct 2008 00:12:55 +0930
From: Plantain <yellowplantain@gmail.com>
MIME-Version: 1.0
To: "Mitchell, J.G." <jgm11@leicester.ac.uk>
References: <48E35E38.9040909@gmail.com>
	<48E394D0.5010808@linuxtv.org>		<48E3A687.9000703@gmail.com>
	<48E3BBD4.8090304@linuxtv.org>	<1222900908.2706.18.camel@pc10.localdom.local>,
	<48E4A4A4.8030003@gmail.com>
	<8477EDDA0355EC429DA077A1FB414E2E1C5FF01D26@EXC-MBX1.cfs.le.ac.uk>
In-Reply-To: <8477EDDA0355EC429DA077A1FB414E2E1C5FF01D26@EXC-MBX1.cfs.le.ac.uk>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Support for Leadtek DTV1000S ?
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

Mitchell, J.G. wrote:
> Hello,
>
> I also have this card and I would like to get it working under Linux. I'm currently undergoing a bit of a hectic freshers week and have not been able to look into how I would go about doing this, but it seems as though you have done a fair bit of ground work. I'm also currently learning C amongst some other things and hope to be diving into it headfirst asap! If there is anything else that needs to be tested or executed then I also run 32bit XP along with 64bit Archlinux, so i have both those operating systems at my disposal.
>
> Jack
> ________________________________________
> From: linux-dvb-bounces@linuxtv.org [linux-dvb-bounces@linuxtv.org] On Behalf Of Plantain [yellowplantain@gmail.com]
> Sent: 02 October 2008 11:38
> To: hermann pitton
> Cc: linux-dvb@linuxtv.org
> Subject: Re: [linux-dvb] Support for Leadtek DTV1000S ?
>
> hermann pitton wrote:
>   
>> Hi,
>>
>> Am Mittwoch, den 01.10.2008, 14:05 -0400 schrieb Steven Toth:
>>
>>     
>>> Plantain wrote:
>>>
>>>       
>>>> Steven Toth wrote:
>>>>
>>>>         
>>>>> Plantain wrote:
>>>>>
>>>>>           
>>>>>> Hey,
>>>>>>
>>>>>> I've luckily come across a Leadtek DTV1000S that I'd like to get working
>>>>>> under Linux!
>>>>>>
>>>>>> From reading the Leadtek specifications
>>>>>> (http://leadtek.com/eng/tv_tuner/specification.asp?pronameid=382&lineid=6&act=2),
>>>>>>
>>>>>> I now understand it has contained within it the following chips;
>>>>>> NXP 18271
>>>>>> TDA10048
>>>>>>
>>>>>>             
>>>>> Firmware:
>>>>>
>>>>> http://steventoth.net/linux/hvr1700/
>>>>>
>>>>> Good luck!
>>>>>
>>>>> Regards,
>>>>>
>>>>> - Steve
>>>>>
>>>>>           
>>>> Hey,
>>>>
>>>>         
>>> Either you or I dropped the mailinglist is CC'd. I've added it back.
>>> Please ensure the mailinglist is CC'd at all times.
>>>
>>>
>>>       
>>>> So it doesn't matter at all that they are for different cards even
>>>> though the chipsets are the same?
>>>>
>>>>         
>>> Correct.
>>>
>>>
>>>       
>>>> Even with the firmware, it seems that the tuner is not detected/loaded.
>>>> I've pasted my current modprobe/dmesg below.
>>>>
>>>>         
>>> If it's not found during an i2c scan then it's probably held in reset by
>>> a GPIO. YOu'd need to figure out which GPIO needs to be raised. I don't
>>> know the 7130 framework very well by I suspect running regspy.exe (from
>>> the dscaler project) on a windows system will probably show you the gpio
>>> configuration that windows uses when the TV playback software is running.
>>>
>>>       
>> for all what I can see we have no analog demodulator on that card like
>> tda8290/95 or a 8290 integrated within a saa7131e chip.
>> All other saa713x chips don't have an internal analog demod with an i2c
>> bridge to control the tuner.
>>
>> That simply means there is no analog tuner and  the correct tuner type
>> for analog is tuner=4 TUNER_ABSENT. We can only configure the card for
>> auto detection as a saa7130 device, enable Composite and S-Video support
>> and maybe the remote if the IR controller is supported.
>>
>> Rest must be found and done within saa7134-dvb.c like pointed.
>> Tuner is at 0x60/0xc0 and tda10048 at 0x08 (0x10 >> 1).
>>
>>
>>     
>>>> plantain@plantain-king ~ $ sudo modprobe saa7134 card=104 tuner=54
>>>> plantain@plantain-king ~ $ dmesg
>>>> ...
>>>> saa7130/34: v4l2 driver version 0.2.14 loaded
>>>> saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 19, latency: 32, mmio:
>>>> 0xfc005000
>>>> saa7130[0]: subsystem: 107d:6655, board: Hauppauge WinTV-HVR1110
>>>> DVB-T/Hybrid [card=104,insmod option]
>>>> saa7130[0]: board init: gpio is 222104
>>>> Chip ID is not zero. It is not a TEA5767
>>>> tuner' 2-0060: chip found @ 0xc0 (saa7130[0])
>>>> saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
>>>> saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
>>>> saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08 ff 00 8a ff ff ff ff
>>>> saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff 04 ff ff ff ff ff ff
>>>> saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>>> tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt or not a
>>>> Hauppauge eeprom.
>>>> saa7130[0]: warning: unknown hauppauge model #0
>>>> saa7130[0]: hauppauge eeprom: model=0
>>>> tuner' 2-0060: Tuner has no way to set tv freq
>>>> tuner' 2-0060: Tuner has no way to set tv freq
>>>> saa7130[0]: registered device video0 [v4l2]
>>>> saa7130[0]: registered device vbi0
>>>> saa7130[0]: registered device radio0
>>>> tda10046: chip is not answering. Giving up.
>>>> tuner' 2-0060: Tuner has no way to set tv freq
>>>> plantain@plantain-king ~ $
>>>>
>>>>
>>>> I believe I am right with the tuner=54 modprobe option for the NXP 18271?
>>>> I've no idea what to actually set card= to, I just guessed HVR1110 since
>>>> it was similar to the firmware from which I've now taken from. If anyone
>>>> can point me towards a better card= setting, that'd be great!
>>>>
>>>>         
>>> I don't normally force load drivers with card=X. I typically just start
>>> patching the [7130] tree with the correct PCI'd, attach structs etc.
>>> It's easier that guessing - which leads to bad assumptions and mistakes.
>>>
>>> You can use the other trees [ cx23885, cx88 ] for reference code to show
>>> how to attach tuners and demods.
>>>
>>> - Steve
>>>
>>>
>>>       
>> Cheers,
>> Hermann
>>
>>
>>     
> Hey,
>
> I'm not actually able to code in C, but I've spent the last 24 hours
> puddling around trying to get somewhere. I believe I've added everything
> that is needed for the card to be detected, but it's not detecting it,
> even if I specify it with card=152 (the ID I've added). I have got the
> code to compile at least, which I'm pretty proud of :)
>
> I managed to get regspy to work (needed to revert 64bit vista to 32bit
> XP), but the viewing software that came with the card just crashes on
> 32bit XP. I've built a small wiki page (with highres images) detailing
> my progress, but I've really just hit a brick wall. Wikipage at
> http://www.linuxtv.org/wiki/index.php/WinFast_DTV_1000_S
>
> Short of learning C (which I am very slowly doing), I don't see anyway
> forwards under my direction, so I've attached my efforts in the hope
> someone else can take this forwards. From my limited understanding I've
> provided all the necessary information for someone to finish it, and if
> not I'll happily dig up anything else needed. I'm not familiar with any
> version control system/patching, so I've just hg diff > file.diff, I
> hope this is adequate.
>
> I'm on #linuxtv @ freenode IRC for a significant portion of the day if
> anyone has pointers for me/wants to ask questions about the card.
>
> Cheers,
>
> ~Matthew~ (plantain on IRC)
>   
Hey,

I'll go out on an uneducated limb and say another set of results from
regspy would be useful, as I couldn't actually get mine to work properly.
RegSpy:
http://sourceforge.net/project/showfiles.php?group_id=7420&package_id=69037
Wiki page: http://www.linuxtv.org/wiki/index.php/WinFast_DTV_1000_S

Cheers,

~Matthew~ (plantain on IRC)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
