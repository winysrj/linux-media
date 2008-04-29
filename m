Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <4817ACDA.1010105@web.de>
Date: Wed, 30 Apr 2008 01:18:50 +0200
From: Torben Viets <viets@web.de>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <4815B2A9.4060209@web.de>
	<4815F0AF.4010709@linuxtv.org>	<4815FA2B.5030502@web.de>
	<4815FF67.6050004@linuxtv.org>	<4816050D.2040408@web.de>
	<48161163.9000602@linuxtv.org>	<4816186B.3030703@web.de>
	<48161B2D.6090602@linuxtv.org>	<48176236.1020306@web.de>
	<481763AA.4030702@linuxtv.org>	<481767E4.8030608@web.de>
	<48176969.6070306@linuxtv.org> <4817935E.8090801@web.de>
In-Reply-To: <4817935E.8090801@web.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1700 Support
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

Torben Viets wrote:
> Steven Toth wrote:
>   
>> Torben Viets wrote:
>>     
>>> Steven Toth wrote:
>>>       
>>>> Torben Viets wrote:
>>>>         
>>>>> Hello,
>>>>>
>>>>> I've got it: http://pastebin.com/f50f33096
>>>>>
>>>>> the trick was to compile the kernel (now linux-2.6.25-git13) with:
>>>>>
>>>>> CONFIG_I2C_DEBUG_CORE=y
>>>>> CONFIG_I2C_DEBUG_ALGO=y
>>>>> CONFIG_I2C_DEBUG_BUS=y
>>>>> CONFIG_I2C_DEBUG_CHIP=y
>>>>>
>>>>> I hope you've got an idea, i updated my bios (afters this my RAM 
>>>>> doesn't work anymore), installed a new Ubuntu Linux hardy (8.04)...
>>>>>
>>>>> One last question when will the firmware be loaded and why there is 
>>>>> no hotplug tool in ubuntu, or is it in the kernel?
>>>>>
>>>>> greetings
>>>>> Torben
>>>>>
>>>>>
>>>>> Steven Toth wrote:
>>>>>           
>>>>>> Torben Viets wrote:
>>>>>>             
>>>>>>> Steven Toth wrote:
>>>>>>>               
>>>>>>>> Torben Viets wrote:
>>>>>>>>                 
>>>>>>>>> Steven Toth wrote:
>>>>>>>>>                   
>>>>>>>>>> Torben Viets wrote:
>>>>>>>>>>                     
>>>>>>>>>>> Hello,
>>>>>>>>>>>
>>>>>>>>>>> thanks for the quick reply.
>>>>>>>>>>>
>>>>>>>>>>> Steven Toth wrote:
>>>>>>>>>>>                       
>>>>>>>>>>>> Torben Viets wrote:
>>>>>>>>>>>>                         
>>>>>>>>>>>>> Hello,
>>>>>>>>>>>>>
>>>>>>>>>>>>> I have a Hauppauge HVR-1700 PCI Express, I have read all 
>>>>>>>>>>>>> posts about
>>>>>>>>>>>>> this card here, but I didn't get it working, how does it work?
>>>>>>>>>>>>>                           
>>>>>>>>>>>> It's working fine for me on a stock 7.10 ubuntu install.
>>>>>>>>>>>>
>>>>>>>>>>>>                         
>>>>>>>>>>>>> Kernel: linux-2.6.25-git10
>>>>>>>>>>>>>
>>>>>>>>>>>>> Firmware-Files:
>>>>>>>>>>>>> ls -al /lib/firmware/2.6.25-git10/
>>>>>>>>>>>>> total 416
>>>>>>>>>>>>> drwxr-xr-x 2 root root     91 Apr 27 16:27 .
>>>>>>>>>>>>> drwxr-xr-x 3 root root     25 Apr 27 16:26 ..
>>>>>>>>>>>>> -rw-r--r-- 1 root root  24878 Apr 27 16:27 
>>>>>>>>>>>>> dvb-fe-tda10048-1.0.fw
>>>>>>>>>>>>> -r--r--r-- 1 root root  16382 Apr 27 16:27 
>>>>>>>>>>>>> v4l-cx23885-avcore-01.fw
>>>>>>>>>>>>> -r--r--r-- 1 root root 376836 Apr 27 16:26 v4l-cx23885-enc.fw
>>>>>>>>>>>>>
>>>>>>>>>>>>> The modules I use are from the actual v4l-dvb hg, if I type 
>>>>>>>>>>>>> make load,
>>>>>>>>>>>>> the only thing I get is a /dev/video0, but I have no 
>>>>>>>>>>>>> picture with xawtv...
>>>>>>>>>>>>>                           
>>>>>>>>>>>> /dev/video doesn't work, it's not supported.
>>>>>>>>>>>>
>>>>>>>>>>>>                         
>>>>>>>>>>> Are there any plans to support it?
>>>>>>>>>>>                       
>>>>>>>>>> No immediate plans.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>                     
>>>>>>>>>>>> You should aim to use the dvb-apps tools (tzap, scan) and 
>>>>>>>>>>>> mplayer as example tools, or MythTV as an app.
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>                         
>>>>>>>>>>>>> The DVB doesn't work at all, I have no /dev/dvb*, here is 
>>>>>>>>>>>>> my dmesg:
>>>>>>>>>>>>>
>>>>>>>>>>>>> cx23885 driver version 0.0.1 loaded
>>>>>>>>>>>>> ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 24 (level, low) 
>>>>>>>>>>>>> -> IRQ 24
>>>>>>>>>>>>> CORE cx23885[0]: subsystem: 0070:8101, board: Hauppauge 
>>>>>>>>>>>>> WinTV-HVR1700
>>>>>>>>>>>>> [card=8,autodetected]
>>>>>>>>>>>>> cx23885[0]: i2c bus 0 registered
>>>>>>>>>>>>> cx23885[0]: i2c bus 1 registered
>>>>>>>>>>>>> cx23885[0]: i2c bus 2 registered
>>>>>>>>>>>>> tveeprom 0-0050: Huh, no eeprom present (err=-5)?
>>>>>>>>>>>>> tveeprom 0-0050: Encountered bad packet header [00].
>>>>>>>>>>>>> Corrupt or not a Hauppauge
>>>>>>>>>>>>> eeprom.
>>>>>>>>>>>>> cx23885[0]: warning: unknown hauppauge model #0
>>>>>>>>>>>>> cx23885[0]: hauppauge eeprom: model=0
>>>>>>>>>>>>> cx23885[0]: cx23885 based dvb card
>>>>>>>>>>>>> tda10048_readreg: readreg error (ret == -5)
>>>>>>>>>>>>> cx23885[0]: frontend initialization failed
>>>>>>>>>>>>> cx23885_dvb_register() dvb_register failed err = -1
>>>>>>>>>>>>> cx23885_dev_setup() Failed to register dvb on VID_C
>>>>>>>>>>>>> cx23885_dev_checkrevision() New hardware revision found 0x0
>>>>>>>>>>>>> cx23885_dev_checkrevision() Hardware revision unknown 0x0
>>>>>>>>>>>>> cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 24, 
>>>>>>>>>>>>> latency: 0, mmio:
>>>>>>>>>>>>> 0xfe800000
>>>>>>>>>>>>>                           
>>>>>>>>>>>> This looks bad, it looks like i2c is broken badly, so that 
>>>>>>>>>>>> the eeprom isn't detected and the demodulator isn't found 
>>>>>>>>>>>> during attach. This is the reason why your missing 
>>>>>>>>>>>> /dev/dvb/adapterX/
>>>>>>>>>>>>
>>>>>>>>>>>> No idea why. Try loading the cx23885 with debug=5 and report 
>>>>>>>>>>>> any log messages here - on this mailing list.
>>>>>>>>>>>>                         
>>>>>>>>>>> here ist the debug=5 output
>>>>>>>>>>>
>>>>>>>>>>> cx23885[0]/0: cx23885_dev_setup() Memory configured for PCIe 
>>>>>>>>>>> bridge type 885
>>>>>>>>>>> cx23885[0]/0: cx23885_init_tsport(portno=2)
>>>>>>>>>>> CORE cx23885[0]: subsystem: 0070:8101, board: Hauppauge 
>>>>>>>>>>> WinTV-HVR1700 [card=8,autodetected]
>>>>>>>>>>> cx23885[0]/0: cx23885_pci_quirks()
>>>>>>>>>>> cx23885[0]/0: cx23885_dev_setup() tuner_type = 0x0 tuner_addr 
>>>>>>>>>>> = 0x0
>>>>>>>>>>> cx23885[0]/0: cx23885_dev_setup() radio_type = 0x0 radio_addr 
>>>>>>>>>>> = 0x0
>>>>>>>>>>> cx23885[0]/0: cx23885_reset()
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() Configuring 
>>>>>>>>>>> channel [VID A]
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() 0x000107b0 <- 
>>>>>>>>>>> 0x00000040
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() 0x000107c0 <- 
>>>>>>>>>>> 0x00000b80
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() 0x000107d0 <- 
>>>>>>>>>>> 0x000016c0
>>>>>>>>>>> cx23885[0]/0: [bridge 885] sram setup VID A: bpl=2880 lines=3
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch2]
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() Configuring 
>>>>>>>>>>> channel [TS1 B]
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() 0x00010400 <- 
>>>>>>>>>>> 0x00005000
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() 0x00010410 <- 
>>>>>>>>>>> 0x000052f0
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() 0x00010420 <- 
>>>>>>>>>>> 0x000055e0
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() 0x00010430 <- 
>>>>>>>>>>> 0x000058d0
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() 0x00010440 <- 
>>>>>>>>>>> 0x00005bc0
>>>>>>>>>>> cx23885[0]/0: [bridge 885] sram setup TS1 B: bpl=752 lines=5
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch4]
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch5]
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() Configuring 
>>>>>>>>>>> channel [TS2 C]
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() 0x000108d0 <- 
>>>>>>>>>>> 0x00006000
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() 0x000108e0 <- 
>>>>>>>>>>> 0x000062f0
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() 0x000108f0 <- 
>>>>>>>>>>> 0x000065e0
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() 0x00010900 <- 
>>>>>>>>>>> 0x000068d0
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() 0x00010910 <- 
>>>>>>>>>>> 0x00006bc0
>>>>>>>>>>> cx23885[0]/0: [bridge 885] sram setup TS2 C: bpl=752 lines=5
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch7]
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch8]
>>>>>>>>>>> cx23885[0]/0: cx23885_sram_channel_setup() Erasing channel [ch9]
>>>>>>>>>>> cx23885[0]: i2c bus 0 registered
>>>>>>>>>>> cx23885[0]: i2c bus 1 registered
>>>>>>>>>>> cx23885[0]: i2c bus 2 registered
>>>>>>>>>>>                       
>>>>>>>>>> Everything looks fine up to this point, then i2c looks bad.
>>>>>>>>>>
>>>>>>>>>> Can you try again with modprobe cx23885 i2c_scan=1 and post 
>>>>>>>>>> the output again? (Output will be large - feel free to use 
>>>>>>>>>> pastebin.com and post the URL here).
>>>>>>>>>>                     
>>>>>>>>> hmm, output doesn't change with it. here is a lsmod plus a 
>>>>>>>>> complete dmesg, is some module missing?
>>>>>>>>>
>>>>>>>>> http://pastebin.com/f4f9b58ed
>>>>>>>>>
>>>>>>>>>                   
>>>>>>>> The module option isn't active.
>>>>>>>>
>>>>>>>> Unload the cx23885 module (and any dependencies) then try 
>>>>>>>> modprobe i2c_scan=1
>>>>>>>>
>>>>>>>> When the module option is set correctly, you'll see a lot of 
>>>>>>>> extra debug messages.
>>>>>>>>
>>>>>>>> - Steve
>>>>>>>>
>>>>>>>>
>>>>>>>>                 
>>>>>>> hmm, I've unload all modules that sounds interesting, but there 
>>>>>>> is no more output: http://pastebin.com/f157a3978
>>>>>>>               
>>>>>> Hmm. No idea. i2c_scan is working for me and various other people. 
>>>>>> Something is wrong with your environment and I don't know what.
>>>>>>
>>>>>> The only time I've seen i2c_scan output not work, is when i2c_scan 
>>>>>> is not passed as a module parameter.
>>>>>>
>>>>>> Unload all modules, then use lsmod to ensure cx23885.ko is not 
>>>>>> loaded.
>>>>>> Then, modprobe cx23885 debug=5 i2c_scan=1
>>>>>>
>>>>>> If that doesn't show i2c device scanning traffic then I'm stumped.
>>>>>>
>>>>>> - Steve
>>>>>>
>>>>>>             
>>>> Thanks for the feedback. This is odd, it looks like either I2C isn;t 
>>>> working at all, or it's working partially for device 0x44. I think 
>>>> I'm tempted to believe it's not working at all.
>>>>
>>>> The firmware gets loaded by the cx25840 module (if required), the 
>>>> module is requested on the fly. But, that doesn't explain the 
>>>> missing eeprom errors.
>>>>
>>>> Does this board work under windows?
>>>>
>>>> - Steve
>>>>
>>>>         
>>> hmm, never tested under windows, i' windows free ;) but i will 
>>> install Windows now and will try wether it works....
>>>       
>> Try a -stable linux kernel first, linux-2.6.25-git10 might be broken.
>>
>> - Steve
>>
>>
>>     
> too late, i've installed Windows, and the card works, not as much as i 
> expected, but i guess this is because i haven't the experience with 
> windows. Additionally i've written down the wintv output about the card, 
> don't know wether this interest.
>
> http://pastebin.com/f7aefdd0d
>
>  tried the ubuntu kernel linux-2.6.24-16-rt, this doesn't detect, and it 
> doens't work with the v4l hg, now i'm building a 2.6.25 and if this 
> doesn't detect the card, i will try it with the v4l hg
>
> greetings
> Torben
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   
Hey, I've update, now the dvb works with 2.6.25 ant the v4l-dvb hg, I 
was sure that I already tried this combinations...

Now, only the analog input have to work (this was the main reason I 
bought this card), is it really so hard, because I
 saw that the HVR-1600 and the HVR-1800 is supported.

greetings and many thanks
Torben

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
