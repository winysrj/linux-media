Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62211 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab0AVJgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 04:36:16 -0500
Received: by ewy19 with SMTP id 19so1133999ewy.1
        for <linux-media@vger.kernel.org>; Fri, 22 Jan 2010 01:36:12 -0800 (PST)
Message-ID: <4B597186.6000702@gmail.com>
Date: Fri, 22 Jan 2010 10:36:06 +0100
From: "tomlohave@gmail.com" <tomlohave@gmail.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: linux-media@vger.kernel.org, jpnews13@free.fr
Subject: Re: [PATCH] [RFC] support for fly dvb duo on medion laptop
References: <4B53FCF2.7000303@gmail.com> <1264119876.31090.14.camel@pc07.localdom.local>
In-Reply-To: <1264119876.31090.14.camel@pc07.localdom.local>
Content-Type: multipart/mixed;
 boundary="------------090301050308040200040802"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090301050308040200040802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

hermann pitton a écrit :

hi hermann

thanks for your reply :)
> Hi.
>
> Am Montag, den 18.01.2010, 07:17 +0100 schrieb tomlohave@gmail.com:
>   
>> Hi list,
>>
>> this patch add support for lifeview fly dvb duo (hybrid card) on medion 
>> laptop
>>
>> what works : dvb and analogic tv
>> not tested :  svideo, composite, radio (i am not the owner of this card)
>>
>> this card uses gpio 22 for the mode switch between analogic and dvb
>>
>> gpio settings  should change when  svideo , composite an radio will be 
>> tested
>>
>>
>> Cheers,
>> Thomas
>>
>> Signed-off-by : Thomas Genty <tomlohave@gmail.com>
>>     
>
> Thomas,
>
> if at all, the special on that card should be, and why it did take so
> long, that this so called "Duo" has only a single hybrid tuner against
> all other "DUOs" previously with dual tuners IMHO.
>   
jp, can you tell us how is called this card under windows ? is it  
really named duo or not ?
> For what, within the current functions now, you need 
> .i2c_gate      = 0x4b ?
>   
copy paste too fast when searching for good settings
Will test without this.
> Please provide output with i2c_debug=1, already previously asked for,
> to get a better idea about this hardware.
>   
attached. But this output is _before_ the use of gpio 22 for the mode switch
(many errors on log ..). i haven't got  a more recent one.

Jp, can you send us a more recent dmesg output with the latest 
modifications, please ?

and regspy log attached too with this tests : (in french)

state 0 démarrage de regspy
state 1 demarrage de powercinema(logiciel qui fait fonctionner ma carte avec l'initial source(DVB-T) 
state 2 selection de la source Analogique
state 3 selection de la source Numerique(DVB)
state 4 selection de la source Analogique (2ème essai)
state 5 selection de la source Numerique (2ème essai)
state 6 log après fermeture de powercinema


> Cheers,
> Hermann
>   
Cheers,
Thomas


--------------090301050308040200040802
Content-Type: text/plain;
 name="SAA7133_0.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="SAA7133_0.txt"

SAA7133 Card [0]:

Vendor ID:           0x1131
Device ID:           0x7133
Subsystem ID:        0x03075168


8 states dumped

----------------------------------------------------------------------------------

SAA7133 Card - State 0:
SAA7134_GPIO_GPMODE:             08400000   (00001000 01000000 00000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           00410000   (00000000 01000001 00000000 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         81         (10000001)                                            
SAA7133_ANALOG_IO_SELECT:        0a         (00001010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03200000   (00000011 00100000 00000000 00000000)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        10         (00010000)                                            
SAA7134_TS_PARALLEL:             64         (01100100)                                            
SAA7134_TS_PARALLEL_SERIAL:      b9         (10111001)                                            
SAA7134_TS_SERIAL0:              40         (01000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 35         (00110101)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 0 -> State 1:

0 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 1:
SAA7134_GPIO_GPMODE:             08400000   (00001000 01000000 00000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           00410000 * (00000000 01000001 00000000 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         81         (10000001)                                            
SAA7133_ANALOG_IO_SELECT:        0a         (00001010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03200000   (00000011 00100000 00000000 00000000)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        10         (00010000)                                            
SAA7134_TS_PARALLEL:             64         (01100100)                                            
SAA7134_TS_PARALLEL_SERIAL:      b9         (10111001)                                            
SAA7134_TS_SERIAL0:              40         (01000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 35         (00110101)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 1 -> State 2:
SAA7134_GPIO_GPSTATUS:           00410000 -> 00010000  (-------- -1------ -------- --------)  

1 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 2:
SAA7134_GPIO_GPMODE:             08400000   (00001000 01000000 00000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           00010000 * (00000000 00000001 00000000 00000000)  (was: 00410000)
SAA7134_ANALOG_IN_CTRL1:         81         (10000001)                                            
SAA7133_ANALOG_IO_SELECT:        0a         (00001010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03200000   (00000011 00100000 00000000 00000000)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        10         (00010000)                                            
SAA7134_TS_PARALLEL:             64 *       (01100100)                                            
SAA7134_TS_PARALLEL_SERIAL:      b9         (10111001)                                            
SAA7134_TS_SERIAL0:              40         (01000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 35         (00110101)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 2 -> State 3:
SAA7134_GPIO_GPSTATUS:           00010000 -> 00410000  (-------- -0------ -------- --------)  (same as 0, 1)
SAA7134_TS_PARALLEL:             64       -> e4        (0-------)                             

2 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 3:
SAA7134_GPIO_GPMODE:             08400000   (00001000 01000000 00000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           00410000 * (00000000 01000001 00000000 00000000)  (was: 00010000)
SAA7134_ANALOG_IN_CTRL1:         81         (10000001)                                            
SAA7133_ANALOG_IO_SELECT:        0a         (00001010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03200000   (00000011 00100000 00000000 00000000)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        10         (00010000)                                            
SAA7134_TS_PARALLEL:             e4 *       (11100100)                             (was: 64)      
SAA7134_TS_PARALLEL_SERIAL:      b9         (10111001)                                            
SAA7134_TS_SERIAL0:              40         (01000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 35         (00110101)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 3 -> State 4:
SAA7134_GPIO_GPSTATUS:           00410000 -> 00010000  (-------- -1------ -------- --------)  (same as 2)
SAA7134_TS_PARALLEL:             e4       -> 64        (1-------)                             (same as 0, 1, 2)

2 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 4:
SAA7134_GPIO_GPMODE:             08400000   (00001000 01000000 00000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           00010000 * (00000000 00000001 00000000 00000000)  (was: 00410000)
SAA7134_ANALOG_IN_CTRL1:         81         (10000001)                                            
SAA7133_ANALOG_IO_SELECT:        0a         (00001010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03200000   (00000011 00100000 00000000 00000000)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        10         (00010000)                                            
SAA7134_TS_PARALLEL:             64 *       (01100100)                             (was: e4)      
SAA7134_TS_PARALLEL_SERIAL:      b9         (10111001)                                            
SAA7134_TS_SERIAL0:              40         (01000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 35         (00110101)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 4 -> State 5:
SAA7134_GPIO_GPSTATUS:           00010000 -> 00410000  (-------- -0------ -------- --------)  (same as 0, 1, 3)
SAA7134_TS_PARALLEL:             64       -> e4        (0-------)                             (same as 3)

2 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 5:
SAA7134_GPIO_GPMODE:             08400000   (00001000 01000000 00000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           00410000   (00000000 01000001 00000000 00000000)  (was: 00010000)
SAA7134_ANALOG_IN_CTRL1:         81         (10000001)                                            
SAA7133_ANALOG_IO_SELECT:        0a         (00001010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03200000   (00000011 00100000 00000000 00000000)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        10         (00010000)                                            
SAA7134_TS_PARALLEL:             e4 *       (11100100)                             (was: 64)      
SAA7134_TS_PARALLEL_SERIAL:      b9         (10111001)                                            
SAA7134_TS_SERIAL0:              40         (01000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 35         (00110101)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 5 -> State 6:
SAA7134_TS_PARALLEL:             e4       -> 64        (1-------)                             (same as 0, 1, 2, 4)

1 changes


----------------------------------------------------------------------------------

SAA7133 Card - State 6:
SAA7134_GPIO_GPMODE:             08400000   (00001000 01000000 00000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           00410000   (00000000 01000001 00000000 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         81         (10000001)                                            
SAA7133_ANALOG_IO_SELECT:        0a         (00001010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03200000   (00000011 00100000 00000000 00000000)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        10         (00010000)                                            
SAA7134_TS_PARALLEL:             64         (01100100)                             (was: e4)      
SAA7134_TS_PARALLEL_SERIAL:      b9         (10111001)                                            
SAA7134_TS_SERIAL0:              40         (01000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 35         (00110101)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            


Changes: State 6 -> Register Dump:

0 changes


=================================================================================

SAA7133 Card - Register Dump:
SAA7134_GPIO_GPMODE:             08400000   (00001000 01000000 00000000 00000000)                 
SAA7134_GPIO_GPSTATUS:           00410000   (00000000 01000001 00000000 00000000)                 
SAA7134_ANALOG_IN_CTRL1:         81         (10000001)                                            
SAA7133_ANALOG_IO_SELECT:        0a         (00001010)                                            
SAA7133_AUDIO_CLOCK_NOMINAL:     03200000   (00000011 00100000 00000000 00000000)                 
SAA7133_PLL_CONTROL:             03         (00000011)                                            
SAA7133_AUDIO_CLOCKS_PER_FIELD:  0001e000   (00000000 00000001 11100000 00000000)                 
SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000 00000000)                 
SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)                                            
SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_FORMAT:       00         (00000000)                                            
SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)                                            
SAA7134_I2S_AUDIO_OUTPUT:        10         (00010000)                                            
SAA7134_TS_PARALLEL:             64         (01100100)                                            
SAA7134_TS_PARALLEL_SERIAL:      b9         (10111001)                                            
SAA7134_TS_SERIAL0:              40         (01000000)                                            
SAA7134_TS_SERIAL1:              00         (00000000)                                            
SAA7134_TS_DMA0:                 35         (00110101)                                            
SAA7134_TS_DMA1:                 01         (00000001)                                            
SAA7134_TS_DMA2:                 00         (00000000)                                            
SAA7134_SPECIAL_MODE:            01         (00000001)                                            

end of dump

--------------090301050308040200040802
Content-Type: text/x-log;
 name="output.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="output.log"

[    0.004244] Checking 'hlt' instruction... OK.
[    0.020697] SMP alternatives: switching to UP code
[    0.132014] ACPI: Core revision 20080926
[    0.136271] ACPI: Checking initramfs for custom DSDT
[    0.480471] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.520880] CPU0: Intel(R) Pentium(R) M processor 1.73GHz stepping 08
[    0.524002] Brought up 1 CPUs
[    0.524002] Total of 1 processors activated (3457.68 BogoMIPS).
[    0.524002] CPU0 attaching NULL sched-domain.
[    0.524002] net_namespace: 776 bytes
[    0.524002] Booting paravirtualized kernel on bare hardware
[    0.524002] Time: 12:58:33  Date: 12/24/09
[    0.524002] regulator: core version 0.5
[    0.524002] NET: Registered protocol family 16
[    0.524002] EISA bus registered
[    0.524002] ACPI: bus type pci registered
[    0.524002] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0=
 - 255
[    0.524002] PCI: MCFG area at e0000000 reserved in E820
[    0.524002] PCI: Using MMCONFIG for extended config space
[    0.524002] PCI: Using configuration type 1 for base access
[    0.524002] ACPI: EC: Look up EC in DSDT
[    0.525501] ACPI: Interpreter enabled
[    0.525506] ACPI: (supports S0 S3 S4 S5)
[    0.525525] ACPI: Using IOAPIC for interrupt routing
[    0.525889] ACPI: EC: non-query interrupt received, switching to inter=
rupt mode
[    0.530892] ACPI: EC: GPE =3D 0x17, I/O: command/status =3D 0x66, data=
 =3D 0x62
[    0.530895] ACPI: EC: driver started in interrupt mode
[    0.531040] ACPI: No dock devices found.
[    0.531051] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.531137] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.531141] pci 0000:00:01.0: PME# disabled
[    0.531197] pci 0000:00:1b.0: reg 10 64bit mmio: [0x80000000-0x80003ff=
f]
[    0.531223] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.531227] pci 0000:00:1b.0: PME# disabled
[    0.531269] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.531272] pci 0000:00:1c.0: PME# disabled
[    0.531317] pci 0000:00:1d.0: reg 20 io port: [0x1800-0x181f]
[    0.531360] pci 0000:00:1d.1: reg 20 io port: [0x1820-0x183f]
[    0.531403] pci 0000:00:1d.2: reg 20 io port: [0x1840-0x185f]
[    0.531451] pci 0000:00:1d.7: reg 10 32bit mmio: [0x80004000-0x800043f=
f]
[    0.531486] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.531491] pci 0000:00:1d.7: PME# disabled
[    0.531588] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.531594] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 =
ACPI/GPIO/TCO
[    0.531599] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 =
GPIO
[    0.531624] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.531629] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.531635] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.531641] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.531647] pci 0000:00:1f.2: reg 20 io port: [0x1870-0x187f]
[    0.531662] pci 0000:00:1f.2: PME# supported from D3hot
[    0.531666] pci 0000:00:1f.2: PME# disabled
[    0.531708] pci 0000:00:1f.3: reg 20 io port: [0x18a0-0x18bf]
[    0.531768] pci 0000:01:00.0: reg 10 32bit mmio: [0xa0000000-0xa0fffff=
f]
[    0.531781] pci 0000:01:00.0: reg 14 64bit mmio: [0xc0000000-0xcffffff=
f]
[    0.531794] pci 0000:01:00.0: reg 1c 64bit mmio: [0x90000000-0x90fffff=
f]
[    0.531807] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.531859] pci 0000:00:01.0: bridge 32bit mmio: [0x90000000-0xaffffff=
f]
[    0.531862] pci 0000:00:01.0: bridge 32bit mmio pref: [0xc0000000-0xcf=
ffffff]
[    0.531920] pci 0000:02:00.0: reg 10 64bit mmio: [0xb0000000-0xb0003ff=
f]
[    0.531929] pci 0000:02:00.0: reg 18 io port: [0x2000-0x20ff]
[    0.531964] pci 0000:02:00.0: supports D1 D2
[    0.531967] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.531972] pci 0000:02:00.0: PME# disabled
[    0.532014] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.532019] pci 0000:00:1c.0: bridge 32bit mmio: [0xb0000000-0xb3fffff=
f]
[    0.532025] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xd0000000-0xd3=
ffffff]
[    0.532063] pci 0000:06:02.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.532073] pci 0000:06:02.0: supports D1 D2
[    0.532075] pci 0000:06:02.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.532080] pci 0000:06:02.0: PME# disabled
[    0.532114] pci 0000:06:02.2: reg 10 32bit mmio: [0xb4006000-0xb40067f=
f]
[    0.532122] pci 0000:06:02.2: reg 14 32bit mmio: [0xb4000000-0xb4003ff=
f]
[    0.532157] pci 0000:06:02.2: supports D1 D2
[    0.532159] pci 0000:06:02.2: PME# supported from D0 D1 D2 D3hot
[    0.532164] pci 0000:06:02.2: PME# disabled
[    0.532196] pci 0000:06:02.3: reg 10 32bit mmio: [0xb4004000-0xb4005ff=
f]
[    0.532233] pci 0000:06:02.3: supports D1 D2
[    0.532235] pci 0000:06:02.3: PME# supported from D0 D1 D2 D3hot
[    0.532240] pci 0000:06:02.3: PME# disabled
[    0.532272] pci 0000:06:02.4: reg 10 32bit mmio: [0xb4007000-0xb40070f=
f]
[    0.532279] pci 0000:06:02.4: reg 14 32bit mmio: [0xb4006c00-0xb4006cf=
f]
[    0.532287] pci 0000:06:02.4: reg 18 32bit mmio: [0xb4006800-0xb40068f=
f]
[    0.532315] pci 0000:06:02.4: supports D1 D2
[    0.532317] pci 0000:06:02.4: PME# supported from D0 D1 D2 D3hot
[    0.532322] pci 0000:06:02.4: PME# disabled
[    0.532357] pci 0000:06:03.0: reg 10 32bit mmio: [0xb4007800-0xb4007ff=
f]
[    0.532394] pci 0000:06:03.0: supports D1 D2
[    0.532432] pci 0000:06:08.0: reg 10 32bit mmio: [0xb4008000-0xb4008ff=
f]
[    0.532470] pci 0000:06:08.0: PME# supported from D0 D3hot D3cold
[    0.532475] pci 0000:06:08.0: PME# disabled
[    0.532508] pci 0000:00:1e.0: transparent bridge
[    0.532513] pci 0000:00:1e.0: bridge 32bit mmio: [0xb4000000-0xb40ffff=
f]
[    0.532546] bus 00 -> node 0
[    0.532553] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.532945] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.533100] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.533267] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.538192] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 5 6 7 10) *4
[    0.538308] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14=
 15) *10
[    0.538425] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *7 10 12 1=
4 15)
[    0.538540] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14=
 15) *10
[    0.538656] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14=
 15) *0, disabled.
[    0.538772] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 1=
4 15)
[    0.538887] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14=
 15) *0, disabled.
[    0.539003] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 1=
4 15)
[    0.539315] ACPI: WMI: Mapper loaded
[    0.539481] SCSI subsystem initialized
[    0.539519] libata version 3.00 loaded.
[    0.539563] usbcore: registered new interface driver usbfs
[    0.539580] usbcore: registered new interface driver hub
[    0.539606] usbcore: registered new device driver usb
[    0.539719] PCI: Using ACPI for IRQ routing
[    0.539819] Bluetooth: Core ver 2.13
[    0.539819] NET: Registered protocol family 31
[    0.539819] Bluetooth: HCI device and connection manager initialized
[    0.539819] Bluetooth: HCI socket layer initialized
[    0.539819] NET: Registered protocol family 8
[    0.539819] NET: Registered protocol family 20
[    0.539819] NetLabel: Initializing
[    0.539819] NetLabel:  domain hash size =3D 128
[    0.539819] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.539819] NetLabel:  unlabeled traffic allowed by default
[    0.540053] hpet clockevent registered
[    0.540056] HPET: 3 timers in total, 0 timers will be used for per-cpu=
 timer
[    0.540061] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.540066] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.544063] AppArmor: AppArmor Filesystem Enabled
[    0.544069] pnp: PnP ACPI init
[    0.544069] ACPI: bus type pnp registered
[    0.547127] pnp: PnP ACPI: found 11 devices
[    0.547129] ACPI: ACPI bus type pnp unregistered
[    0.547133] PnPBIOS: Disabled by ACPI PNP
[    0.547142] system 00:01: iomem range 0xe0000000-0xefffffff has been r=
eserved
[    0.547146] system 00:01: iomem range 0xf0000000-0xf0003fff has been r=
eserved
[    0.547153] system 00:01: iomem range 0xf0004000-0xf0004fff has been r=
eserved
[    0.547156] system 00:01: iomem range 0xf0005000-0xf0005fff has been r=
eserved
[    0.547159] system 00:01: iomem range 0xf0008000-0xf000bfff has been r=
eserved
[    0.547162] system 00:01: iomem range 0xfed20000-0xfed8ffff has been r=
eserved
[    0.547169] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.547172] system 00:05: ioport range 0x1000-0x107f has been reserved=

[    0.547175] system 00:05: ioport range 0x1180-0x11bf has been reserved=

[    0.547178] system 00:05: ioport range 0x1640-0x164f has been reserved=

[    0.582175] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.582178] pci 0000:00:01.0:   IO window: disabled
[    0.582182] pci 0000:00:01.0:   MEM window: 0x90000000-0xafffffff
[    0.582186] pci 0000:00:01.0:   PREFETCH window: 0x000000c0000000-0x00=
0000cfffffff
[    0.582191] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.582194] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.582199] pci 0000:00:1c.0:   MEM window: 0xb0000000-0xb3ffffff
[    0.582204] pci 0000:00:1c.0:   PREFETCH window: 0x000000d0000000-0x00=
0000d3ffffff
[    0.582215] pci 0000:06:02.0: CardBus bridge, secondary bus 0000:07
[    0.582217] pci 0000:06:02.0:   IO window: 0x003000-0x0030ff
[    0.582222] pci 0000:06:02.0:   IO window: 0x003400-0x0034ff
[    0.582227] pci 0000:06:02.0:   PREFETCH window: 0x50000000-0x53ffffff=

[    0.582232] pci 0000:06:02.0:   MEM window: 0x54000000-0x57ffffff
[    0.582236] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
[    0.582239] pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
[    0.582244] pci 0000:00:1e.0:   MEM window: 0xb4000000-0xb40fffff
[    0.582249] pci 0000:00:1e.0:   PREFETCH window: 0x00000050000000-0x00=
000053ffffff
[    0.582262] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
[    0.582266] pci 0000:00:01.0: setting latency timer to 64
[    0.582273] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ =
17
[    0.582278] pci 0000:00:1c.0: setting latency timer to 64
[    0.582284] pci 0000:00:1e.0: setting latency timer to 64
[    0.582291] pci 0000:06:02.0: enabling device (0000 -> 0003)
[    0.582295] pci 0000:06:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
[    0.582301] pci 0000:06:02.0: setting latency timer to 64
[    0.582306] bus: 00 index 0 io port: [0x00-0xffff]
[    0.582308] bus: 00 index 1 mmio: [0x000000-0xffffffff]
[    0.582310] bus: 01 index 0 mmio: [0x0-0x0]
[    0.582313] bus: 01 index 1 mmio: [0x90000000-0xafffffff]
[    0.582315] bus: 01 index 2 mmio: [0xc0000000-0xcfffffff]
[    0.582318] bus: 01 index 3 mmio: [0x0-0x0]
[    0.582320] bus: 02 index 0 io port: [0x2000-0x2fff]
[    0.582322] bus: 02 index 1 mmio: [0xb0000000-0xb3ffffff]
[    0.582325] bus: 02 index 2 mmio: [0xd0000000-0xd3ffffff]
[    0.582327] bus: 02 index 3 mmio: [0x0-0x0]
[    0.582329] bus: 06 index 0 io port: [0x3000-0x3fff]
[    0.582332] bus: 06 index 1 mmio: [0xb4000000-0xb40fffff]
[    0.582334] bus: 06 index 2 mmio: [0x50000000-0x53ffffff]
[    0.582337] bus: 06 index 3 io port: [0x00-0xffff]
[    0.582339] bus: 06 index 4 mmio: [0x000000-0xffffffff]
[    0.582341] bus: 07 index 0 io port: [0x3000-0x30ff]
[    0.582344] bus: 07 index 1 io port: [0x3400-0x34ff]
[    0.582346] bus: 07 index 2 mmio: [0x50000000-0x53ffffff]
[    0.582349] bus: 07 index 3 mmio: [0x54000000-0x57ffffff]
[    0.582357] NET: Registered protocol family 2
[    0.582469] IP route cache hash table entries: 32768 (order: 5, 131072=
 bytes)
[    0.582721] TCP established hash table entries: 131072 (order: 8, 1048=
576 bytes)
[    0.583389] TCP bind hash table entries: 65536 (order: 7, 524288 bytes=
)
[    0.583802] TCP: Hash tables configured (established 131072 bind 65536=
)
[    0.583805] TCP reno registered
[    0.583949] NET: Registered protocol family 1
[    0.584109] checking if image is initramfs... it is
[    1.044090] Switched to high resolution mode on CPU 0
[    1.282481] Freeing initrd memory: 7381k freed
[    1.282533] Simple Boot Flag at 0x36 set to 0x1
[    1.282569] cpufreq: No nForce2 chipset.
[    1.282751] audit: initializing netlink socket (disabled)
[    1.282774] type=3D2000 audit(1261659513.280:1): initialized
[    1.291169] highmem bounce pool size: 64 pages
[    1.291176] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.292570] VFS: Disk quotas dquot_6.5.1
[    1.292629] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=

[    1.293277] fuse init (API version 7.10)
[    1.293369] msgmni has been set to 1724
[    1.293547] alg: No test for stdrng (krng)
[    1.293560] io scheduler noop registered
[    1.293562] io scheduler anticipatory registered
[    1.293564] io scheduler deadline registered
[    1.293579] io scheduler cfq registered (default)
[    1.293683] pci 0000:01:00.0: Boot video device
[    1.297059] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    1.297091] pcieport-driver 0000:00:01.0: found MSI capability
[    1.297112] pcieport-driver 0000:00:01.0: irq 2303 for MSI/MSI-X
[    1.297121] pci_express 0000:00:01.0:pcie00: allocate port service
[    1.297137] pci_express 0000:00:01.0:pcie03: allocate port service
[    1.297182] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.297212] pcieport-driver 0000:00:1c.0: found MSI capability
[    1.297233] pcieport-driver 0000:00:1c.0: irq 2302 for MSI/MSI-X
[    1.297244] pci_express 0000:00:1c.0:pcie00: allocate port service
[    1.297257] pci_express 0000:00:1c.0:pcie02: allocate port service
[    1.297270] pci_express 0000:00:1c.0:pcie03: allocate port service
[    1.297336] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.297433] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    1.297892] ACPI: AC Adapter [AC] (on-line)
[    1.317759] ACPI: Battery Slot [BAT0] (battery present)
[    1.317836] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:=
00/input/input0
[    1.317839] ACPI: Power Button (FF) [PWRF]
[    1.317885] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0=
D:00/input/input1
[    1.318573] ACPI: Lid Switch [LID0]
[    1.318624] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00=
/PNP0C0C:00/input/input2
[    1.318631] ACPI: Power Button (CM) [PWRB]
[    1.319047] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.319077] processor ACPI_CPU:00: registered as cooling_device0
[    1.319081] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.321360] isapnp: Scanning for PnP cards...
[    1.675011] isapnp: No Plug & Play device found
[    1.676153] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.676277] serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
[    1.677314] brd: module loaded
[    1.677619] loop: module loaded
[    1.677693] Fixed MDIO Bus: probed
[    1.677700] PPP generic driver version 2.4.2
[    1.677761] input: Macintosh mouse button emulation as /devices/virtua=
l/input/input3
[    1.677793] Driver 'sd' needs updating - please use bus_type methods
[    1.677803] Driver 'sr' needs updating - please use bus_type methods
[    1.677843] ahci 0000:00:1f.2: version 3.0
[    1.677859] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ=
 19
[    1.677869] ahci 0000:00:1f.2: PCI INT B disabled
[    1.677874] ahci: probe of 0000:00:1f.2 failed with error -22
[    1.677915] ata_piix 0000:00:1f.2: version 2.12
[    1.677920] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) ->=
 IRQ 19
[    1.677924] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    1.677961] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.678048] scsi0 : ata_piix
[    1.678214] scsi1 : ata_piix
[    1.679374] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1870 i=
rq 14
[    1.679378] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1878 i=
rq 15
[    1.840302] ata1.00: ATA-7: SAMSUNG MP0804H, UE100-14, max UDMA/100
[    1.840305] ata1.00: 156368016 sectors, multi 16: LBA48=20
[    1.840320] ata1.00: applying bridge limits
[    1.848318] ata1.00: configured for UDMA/100
[    2.012471] ata2.00: ATAPI: MATSHITADVD-RAM UJ-840S, 1.00, max UDMA/33=

[    2.028449] ata2.00: configured for UDMA/33
[    2.028918] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG MP0804H  =
UE10 PQ: 0 ANSI: 5
[    2.029014] sd 0:0:0:0: [sda] 156368016 512-byte hardware sectors: (80=
=2E0 GB/74.5 GiB)
[    2.029032] sd 0:0:0:0: [sda] Write Protect is off
[    2.029034] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.029061] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    2.029118] sd 0:0:0:0: [sda] 156368016 512-byte hardware sectors: (80=
=2E0 GB/74.5 GiB)
[    2.029133] sd 0:0:0:0: [sda] Write Protect is off
[    2.029136] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.029161] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    2.029165]  sda: sda1 sda2 < sda5 sda6 >
[    2.074029] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.074072] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.075956] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-840S  =
1.00 PQ: 0 ANSI: 5
[    2.080367] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form=
2 cdda tray
[    2.080370] Uniform CD-ROM driver Revision: 3.20
[    2.080462] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.080499] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.081146] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    2.081165] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[    2.081187] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.081191] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.081246] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bu=
s number 1
[    2.085149] ehci_hcd 0000:00:1d.7: debug port 1
[    2.085155] ehci_hcd 0000:00:1d.7: cache line size of 32 is not suppor=
ted
[    2.085169] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x80004000
[    2.100008] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.100084] usb usb1: configuration #1 chosen from 1 choice
[    2.100115] hub 1-0:1.0: USB hub found
[    2.100124] hub 1-0:1.0: 6 ports detected
[    2.100226] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.100242] uhci_hcd: USB Universal Host Controller Interface driver
[    2.100263] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) ->=
 IRQ 23
[    2.100269] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.100272] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.100315] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bu=
s number 2
[    2.100337] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001800
[    2.100412] usb usb2: configuration #1 chosen from 1 choice
[    2.100436] hub 2-0:1.0: USB hub found
[    2.100444] hub 2-0:1.0: 2 ports detected
[    2.100524] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) ->=
 IRQ 19
[    2.100530] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.100533] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.100572] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bu=
s number 3
[    2.100599] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001820
[    2.100669] usb usb3: configuration #1 chosen from 1 choice
[    2.100697] hub 3-0:1.0: USB hub found
[    2.100704] hub 3-0:1.0: 2 ports detected
[    2.100781] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) ->=
 IRQ 18
[    2.100786] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.100789] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.100837] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bu=
s number 4
[    2.100864] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
[    2.100940] usb usb4: configuration #1 chosen from 1 choice
[    2.100965] hub 4-0:1.0: USB hub found
[    2.100971] hub 4-0:1.0: 2 ports detected
[    2.101111] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0=
x64 irq 1,12
[    2.103814] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.103819] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.103920] mice: PS/2 mouse device common for all mice
[    2.104080] rtc_cmos 00:06: RTC can wake from S4
[    2.104113] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    2.104137] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet i=
rqs
[    2.104200] device-mapper: uevent: version 1.0.3
[    2.104299] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialise=
d: dm-devel@redhat.com
[    2.104350] device-mapper: multipath: version 1.0.5 loaded
[    2.104353] device-mapper: multipath round-robin: version 1.0.0 loaded=

[    2.104426] EISA: Probing bus 0 at eisa.0
[    2.104432] Cannot allocate resource for EISA slot 1
[    2.104435] Cannot allocate resource for EISA slot 2
[    2.104437] Cannot allocate resource for EISA slot 3
[    2.104453] EISA: Detected 0 cards.
[    2.104520] cpuidle: using governor ladder
[    2.104583] cpuidle: using governor menu
[    2.105082] TCP cubic registered
[    2.105187] NET: Registered protocol family 10
[    2.105604] lo: Disabled Privacy Extensions
[    2.105918] NET: Registered protocol family 17
[    2.105934] Bluetooth: L2CAP ver 2.11
[    2.105936] Bluetooth: L2CAP socket layer initialized
[    2.105939] Bluetooth: SCO (Voice Link) ver 0.6
[    2.105941] Bluetooth: SCO socket layer initialized
[    2.105963] Bluetooth: RFCOMM socket layer initialized
[    2.105969] Bluetooth: RFCOMM TTY layer initialized
[    2.105971] Bluetooth: RFCOMM ver 1.10
[    2.106233] Using IPI No-Shortcut mode
[    2.106300] registered taskstats version 1
[    2.106416]   Magic number: 5:555:987
[    2.106483] rtc_cmos 00:06: setting system clock to 2009-12-24 12:58:3=
5 UTC (1261659515)
[    2.106486] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.106488] EDD information not available.
[    2.106770] Freeing unused kernel memory: 532k freed
[    2.106901] Write protecting the kernel text: 4120k
[    2.106942] Write protecting the kernel read-only data: 1524k
[    2.146276] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input4
[    2.596021] usb 2-1: new low speed USB device using uhci_hcd and addre=
ss 2
[    2.773511] usb 2-1: configuration #1 chosen from 1 choice
[    2.790424] sky2 driver version 1.22
[    2.790474] sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ=
 16
[    2.790485] sky2 0000:02:00.0: setting latency timer to 64
[    2.790543] sky2 0000:02:00.0: Yukon-2 FE chip revision 1
[    2.854227] sky2 0000:02:00.0: Marvell Yukon 88E8036 Fast Ethernet Con=
troller
[    2.854230]  Part Number: Yukon 88E8036
[    2.854232]  Engineering Level: Rev. 1.1
[    2.854234]  Manufacturer: Marvell
[    2.854289] sky2 0000:02:00.0: irq 2301 for MSI/MSI-X
[    2.858613] sky2 eth0: addr 00:03:25:24:43:e4
[    2.890536] ohci1394 0000:06:02.2: PCI INT A -> GSI 16 (level, low) ->=
 IRQ 16
[    2.940299] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[16]  MMIO=3D=
[b4006000-b40067ff]  Max Packet=3D[2048]  IR/IT contexts=3D[4/8]
[    3.276197] usbcore: registered new interface driver hiddev
[    3.276282] usbcore: registered new interface driver usbhid
[    3.276285] usbhid: v2.6:USB HID core driver
[    3.324889] Marking TSC unstable due to TSC halts in idle
[    3.335952] input: Logitech USB Receiver as /devices/pci0000:00/0000:0=
0:1d.0/usb2/2-1/2-1:1.0/input/input5
[    3.337698] logitech 0003:046D:C50C.0001: input,hidraw0: USB HID v1.10=
 Keyboard [Logitech USB Receiver] on usb-0000:00:1d.0-1/input0
[    3.374263] logitech 0003:046D:C50C.0002: fixing up Logitech keyboard =
report descriptor
[    3.375699] input: Logitech USB Receiver as /devices/pci0000:00/0000:0=
0:1d.0/usb2/2-1/2-1:1.1/input/input6
[    3.392518] logitech 0003:046D:C50C.0002: input,hiddev96,hidraw1: USB =
HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1/input1
[    3.591749] PM: Starting manual resume from disk
[    3.591753] PM: Resume from partition 8:5
[    3.591755] PM: Checking hibernation image.
[    3.591955] PM: Resume from disk failed.
[    3.610215] EXT4-fs: barriers enabled
[    3.628378] kjournald2 starting.  Commit interval 5 seconds
[    3.628387] EXT4-fs: delayed allocation enabled
[    3.628389] EXT4-fs: file extents enabled
[    3.629692] EXT4-fs: mballoc enabled
[    3.629696] EXT4-fs: mounted filesystem with ordered data mode.
[    4.272137] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000325214001=
03ec]
[    9.866715] udev: starting version 141
[   10.432117] Linux agpgart interface v0.103
[   11.041615] intel_rng: FWH not detected
[   11.114401] parport_pc 00:08: reported by Plug and Play ACPI
[   11.114426] parport0: PC-style at 0x378, irq 5 [PCSPP,TRISTATE,EPP]
[   11.252522] Linux video capture interface: v2.00
[   11.289569] ieee80211_crypt: registered algorithm 'NULL'
[   11.294195] ieee80211: 802.11 data/management/control stack, git-1.1.1=
3
[   11.294198] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jket=
reno@linux.intel.com>
[   11.321601] input: PC Speaker as /devices/platform/pcspkr/input/input7=

[   11.364649] sdhci: Secure Digital Host Controller Interface driver
[   11.364652] sdhci: Copyright(c) Pierre Ossman
[   11.374807] sdhci-pci 0000:06:02.4: SDHCI controller found [104c:8034]=
 (rev 0)
[   11.374824] sdhci-pci 0000:06:02.4: PCI INT A -> GSI 16 (level, low) -=
> IRQ 16
[   11.374949] mmc0: SDHCI controller on PCI [0000:06:02.4] using PIO
[   11.375011] mmc1: SDHCI controller on PCI [0000:06:02.4] using PIO
[   11.375069] mmc2: SDHCI controller on PCI [0000:06:02.4] using PIO
[   11.448322] yenta_cardbus 0000:06:02.0: CardBus bridge found [161f:203=
d]
[   11.448339] yenta_cardbus 0000:06:02.0: Enabling burst memory read tra=
nsactions
[   11.448344] yenta_cardbus 0000:06:02.0: Using CSCINT to route CSC inte=
rrupts to PCI
[   11.448347] yenta_cardbus 0000:06:02.0: Routing CardBus interrupts to =
PCI
[   11.448352] yenta_cardbus 0000:06:02.0: TI: mfunc 0x00a01002, devctl 0=
x64
[   11.461935] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08=
:00/device:01/device:02/input/input8
[   11.467829] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: =
no)
[   11.468152] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08=
:00/device:06/input/input9
[   11.471396] ppdev: user-space parallel port driver
[   11.476944] ACPI: Video Device [VGA1] (multi-head: yes  rom: no  post:=
 no)
[   11.681083] yenta_cardbus 0000:06:02.0: ISA IRQ mask 0x0cd8, PCI irq 1=
6
[   11.681089] yenta_cardbus 0000:06:02.0: Socket status: 30000006
[   11.681094] pci_bus 0000:06: Raising subordinate bus# of parent bus (#=
06) from #06 to #0a
[   11.681105] yenta_cardbus 0000:06:02.0: pcmcia: parent PCI bridge I/O =
window: 0x3000 - 0x3fff
[   11.681109] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3000-0x3=
fff: clean.
[   11.681338] yenta_cardbus 0000:06:02.0: pcmcia: parent PCI bridge Memo=
ry window: 0xb4000000 - 0xb40fffff
[   11.681341] yenta_cardbus 0000:06:02.0: pcmcia: parent PCI bridge Memo=
ry window: 0x50000000 - 0x53ffffff
[   11.777694] nvidia: module license 'NVIDIA' taints kernel.
[   12.038699] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[   12.038710] nvidia 0000:01:00.0: setting latency timer to 64
[   12.039573] NVRM: loading NVIDIA UNIX x86 Kernel Module  180.44  Mon M=
ar 23 14:59:10 PST 2009
[   12.048708] tifm_7xx1 0000:06:02.3: PCI INT A -> GSI 16 (level, low) -=
> IRQ 16
[   12.103646] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1=
=2E2.2kmprq
[   12.103650] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   12.104122] ipw2200 0000:06:08.0: PCI INT A -> GSI 21 (level, low) -> =
IRQ 21
[   12.106192] ipw2200: Detected Intel PRO/Wireless 2200BG Network Connec=
tion
[   12.106243] ipw2200 0000:06:08.0: firmware: requesting ipw2200-bss.fw
[   12.168357] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.190198] synaptics was reset on resume, see synaptics_resume_reset =
if you have trouble on resume
[   12.313050] iTCO_vendor_support: vendor-support=3D0
[   12.315080] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   12.315266] iTCO_wdt: Found a ICH6-M TCO device (Version=3D2, TCOBASE=3D=
0x1060)
[   12.315353] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[   12.329643] ipw2200: Detected geography ZZM (11 802.11bg channels, 0 8=
02.11a channels)
[   12.457132] saa7130/34: v4l2 driver version 0.2.15 loaded
[   12.457288] saa7134 0000:06:03.0: PCI INT A -> GSI 19 (level, low) -> =
IRQ 19
[   12.457295] saa7133[0]: found at 0000:06:03.0, rev: 208, irq: 19, late=
ncy: 181, mmio: 0xb4007800
[   12.457303] saa7133[0]: subsystem: 5168:0307, board: LifeView FlyDVB-T=
 DUO Medion [card=3D176,autodetected]
[   12.457370] saa7133[0]: board init: gpio is 10000
[   12.457379] saa7133[0]: gpio: mode=3D0x0000000 in=3D0x0010000 out=3D0x=
0000000 [pre-init]
[   12.538821] nf_conntrack version 0.5.0 (16360 buckets, 65440 max)
[   12.540154] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. =
Please use
[   12.540157] nf_conntrack.acct=3D1 kernel paramater, acct=3D1 nf_conntr=
ack module option or
[   12.540160] sysctl net.netfilter.nf_conntrack_acct=3D1 to enable it.
[   12.560083] saa7133[0]: i2c xfer: < a0 00 >
[   12.570770] saa7133[0]: i2c xfer: < a1 =3D68 =3D51 =3D07 =3D03 =3D54 =3D=
20 =3D1c =3D00 =3D43 =3D43 =3Da9 =3D1c =3D55 =3Dd2 =3Db2 =3D92 =3D00 =3D0=
0 =3D62 =3D08 =3Dff =3D20 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff=
 =3Dff =3Dff =3D01 =3D40 =3D01 =3D03 =3D03 =3D01 =3D01 =3D03 =3D08 =3Dff =
=3D01 =3De7 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D=
ff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D24 =3D0=
0 =3Dc2 =3D96 =3D10 =3D05 =3D01 =3D01 =3D16 =3D22 =3D15 =3Dff =3Dff =3Dff=
 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =
=3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D=
ff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Df=
f =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff=
 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =
=3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D=
ff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Df=
f =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff=
 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =
=3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D=
ff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Df=
f =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff=
 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =
=3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D=
ff =3Dff =3Dff =3Dff =3Dff =3Dff >
[   12.623109] saa7133[0]: i2c eeprom 00: 68 51 07 03 54 20 1c 00 43 43 a=
9 1c 55 d2 b2 92
[   12.623120] saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff f=
f ff ff ff ff ff
[   12.623129] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 0=
1 e7 ff ff ff ff
[   12.623139] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623149] saa7133[0]: i2c eeprom 40: ff 24 00 c2 96 10 05 01 01 16 2=
2 15 ff ff ff ff
[   12.623158] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623168] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623177] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623187] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623196] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623206] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623216] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623225] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623235] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623244] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623254] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623265] saa7133[0]: i2c xfer: < 01 ERROR: NO_DEVICE
[   12.623442] saa7133[0]: i2c xfer: < 03 ERROR: NO_DEVICE
[   12.623618] saa7133[0]: i2c xfer: < 05 ERROR: NO_DEVICE
[   12.623794] saa7133[0]: i2c xfer: < 07 ERROR: NO_DEVICE
[   12.623970] saa7133[0]: i2c xfer: < 09 ERROR: NO_DEVICE
[   12.624156] saa7133[0]: i2c xfer: < 0b ERROR: NO_DEVICE
[   12.624336] saa7133[0]: i2c xfer: < 0d ERROR: NO_DEVICE
[   12.624512] saa7133[0]: i2c xfer: < 0f ERROR: NO_DEVICE
[   12.624688] saa7133[0]: i2c xfer: < 11 >
[   12.640223] saa7133[0]: i2c scan: found device @ 0x10  [???]
[   12.640227] saa7133[0]: i2c xfer: < 13 ERROR: NO_DEVICE
[   12.640404] saa7133[0]: i2c xfer: < 15 ERROR: NO_DEVICE
[   12.640580] saa7133[0]: i2c xfer: < 17 ERROR: NO_DEVICE
[   12.640756] saa7133[0]: i2c xfer: < 19 ERROR: NO_DEVICE
[   12.640932] saa7133[0]: i2c xfer: < 1b ERROR: NO_DEVICE
[   12.641107] saa7133[0]: i2c xfer: < 1d ERROR: NO_DEVICE
[   12.641283] saa7133[0]: i2c xfer: < 1f ERROR: NO_DEVICE
[   12.641459] saa7133[0]: i2c xfer: < 21 ERROR: NO_DEVICE
[   12.641635] saa7133[0]: i2c xfer: < 23 ERROR: NO_DEVICE
[   12.641810] saa7133[0]: i2c xfer: < 25 ERROR: NO_DEVICE
[   12.641986] saa7133[0]: i2c xfer: < 27 ERROR: NO_DEVICE
[   12.642162] saa7133[0]: i2c xfer: < 29 ERROR: NO_DEVICE
[   12.642337] saa7133[0]: i2c xfer: < 2b ERROR: NO_DEVICE
[   12.642513] saa7133[0]: i2c xfer: < 2d ERROR: NO_DEVICE
[   12.642689] saa7133[0]: i2c xfer: < 2f ERROR: NO_DEVICE
[   12.642864] saa7133[0]: i2c xfer: < 31 ERROR: NO_DEVICE
[   12.643040] saa7133[0]: i2c xfer: < 33 ERROR: NO_DEVICE
[   12.643216] saa7133[0]: i2c xfer: < 35 ERROR: NO_DEVICE
[   12.643392] saa7133[0]: i2c xfer: < 37 ERROR: NO_DEVICE
[   12.643567] saa7133[0]: i2c xfer: < 39 ERROR: NO_DEVICE
[   12.643743] saa7133[0]: i2c xfer: < 3b ERROR: NO_DEVICE
[   12.643919] saa7133[0]: i2c xfer: < 3d ERROR: NO_DEVICE
[   12.644097] saa7133[0]: i2c xfer: < 3f ERROR: NO_DEVICE
[   12.644273] saa7133[0]: i2c xfer: < 41 ERROR: NO_DEVICE
[   12.644449] saa7133[0]: i2c xfer: < 43 ERROR: NO_DEVICE
[   12.644624] saa7133[0]: i2c xfer: < 45 ERROR: NO_DEVICE
[   12.644800] saa7133[0]: i2c xfer: < 47 ERROR: NO_DEVICE
[   12.644976] saa7133[0]: i2c xfer: < 49 ERROR: NO_DEVICE
[   12.645151] saa7133[0]: i2c xfer: < 4b ERROR: NO_DEVICE
[   12.645327] saa7133[0]: i2c xfer: < 4d ERROR: NO_DEVICE
[   12.645503] saa7133[0]: i2c xfer: < 4f ERROR: NO_DEVICE
[   12.645679] saa7133[0]: i2c xfer: < 51 ERROR: NO_DEVICE
[   12.645854] saa7133[0]: i2c xfer: < 53 ERROR: NO_DEVICE
[   12.646030] saa7133[0]: i2c xfer: < 55 ERROR: NO_DEVICE
[   12.646206] saa7133[0]: i2c xfer: < 57 ERROR: NO_DEVICE
[   12.646382] saa7133[0]: i2c xfer: < 59 ERROR: NO_DEVICE
[   12.646557] saa7133[0]: i2c xfer: < 5b ERROR: NO_DEVICE
[   12.646733] saa7133[0]: i2c xfer: < 5d ERROR: NO_DEVICE
[   12.646909] saa7133[0]: i2c xfer: < 5f ERROR: NO_DEVICE
[   12.647084] saa7133[0]: i2c xfer: < 61 ERROR: NO_DEVICE
[   12.647260] saa7133[0]: i2c xfer: < 63 ERROR: NO_DEVICE
[   12.647436] saa7133[0]: i2c xfer: < 65 ERROR: NO_DEVICE
[   12.647612] saa7133[0]: i2c xfer: < 67 ERROR: NO_DEVICE
[   12.647827] saa7133[0]: i2c xfer: < 69 ERROR: NO_DEVICE
[   12.648017] saa7133[0]: i2c xfer: < 6b ERROR: NO_DEVICE
[   12.648193] saa7133[0]: i2c xfer: < 6d ERROR: NO_DEVICE
[   12.648368] saa7133[0]: i2c xfer: < 6f ERROR: NO_DEVICE
[   12.648544] saa7133[0]: i2c xfer: < 71 ERROR: NO_DEVICE
[   12.648720] saa7133[0]: i2c xfer: < 73 ERROR: NO_DEVICE
[   12.648896] saa7133[0]: i2c xfer: < 75 ERROR: NO_DEVICE
[   12.649071] saa7133[0]: i2c xfer: < 77 ERROR: NO_DEVICE
[   12.649247] saa7133[0]: i2c xfer: < 79 ERROR: NO_DEVICE
[   12.649423] saa7133[0]: i2c xfer: < 7b ERROR: NO_DEVICE
[   12.649599] saa7133[0]: i2c xfer: < 7d ERROR: NO_DEVICE
[   12.649774] saa7133[0]: i2c xfer: < 7f ERROR: NO_DEVICE
[   12.649950] saa7133[0]: i2c xfer: < 81 ERROR: NO_DEVICE
[   12.650126] saa7133[0]: i2c xfer: < 83 ERROR: NO_DEVICE
[   12.650301] saa7133[0]: i2c xfer: < 85 ERROR: NO_DEVICE
[   12.650477] saa7133[0]: i2c xfer: < 87 ERROR: NO_DEVICE
[   12.650653] saa7133[0]: i2c xfer: < 89 ERROR: NO_DEVICE
[   12.650829] saa7133[0]: i2c xfer: < 8b ERROR: NO_DEVICE
[   12.651004] saa7133[0]: i2c xfer: < 8d ERROR: NO_DEVICE
[   12.651180] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
[   12.651356] saa7133[0]: i2c xfer: < 91 ERROR: NO_DEVICE
[   12.651532] saa7133[0]: i2c xfer: < 93 ERROR: NO_DEVICE
[   12.651707] saa7133[0]: i2c xfer: < 95 ERROR: NO_DEVICE
[   12.651883] saa7133[0]: i2c xfer: < 97 >
[   12.664525] saa7133[0]: i2c scan: found device @ 0x96  [???]
[   12.664530] saa7133[0]: i2c xfer: < 99 ERROR: NO_DEVICE
[   12.664707] saa7133[0]: i2c xfer: < 9b ERROR: NO_DEVICE
[   12.664883] saa7133[0]: i2c xfer: < 9d ERROR: NO_DEVICE
[   12.665059] saa7133[0]: i2c xfer: < 9f ERROR: NO_DEVICE
[   12.665234] saa7133[0]: i2c xfer: < a1 >
[   12.672025] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
[   12.672029] saa7133[0]: i2c xfer: < a3 ERROR: NO_DEVICE
[   12.672206] saa7133[0]: i2c xfer: < a5 ERROR: NO_DEVICE
[   12.672382] saa7133[0]: i2c xfer: < a7 ERROR: NO_DEVICE
[   12.672558] saa7133[0]: i2c xfer: < a9 ERROR: NO_DEVICE
[   12.672734] saa7133[0]: i2c xfer: < ab ERROR: NO_DEVICE
[   12.672910] saa7133[0]: i2c xfer: < ad ERROR: NO_DEVICE
[   12.673085] saa7133[0]: i2c xfer: < af ERROR: NO_DEVICE
[   12.673261] saa7133[0]: i2c xfer: < b1 ERROR: NO_DEVICE
[   12.673437] saa7133[0]: i2c xfer: < b3 ERROR: NO_DEVICE
[   12.673612] saa7133[0]: i2c xfer: < b5 ERROR: NO_DEVICE
[   12.673788] saa7133[0]: i2c xfer: < b7 ERROR: NO_DEVICE
[   12.673964] saa7133[0]: i2c xfer: < b9 ERROR: NO_DEVICE
[   12.674140] saa7133[0]: i2c xfer: < bb ERROR: NO_DEVICE
[   12.674315] saa7133[0]: i2c xfer: < bd ERROR: NO_DEVICE
[   12.674491] saa7133[0]: i2c xfer: < bf ERROR: NO_DEVICE
[   12.674667] saa7133[0]: i2c xfer: < c1 ERROR: NO_DEVICE
[   12.674843] saa7133[0]: i2c xfer: < c3 ERROR: NO_DEVICE
[   12.675018] saa7133[0]: i2c xfer: < c5 ERROR: NO_DEVICE
[   12.675194] saa7133[0]: i2c xfer: < c7 ERROR: NO_DEVICE
[   12.675370] saa7133[0]: i2c xfer: < c9 ERROR: NO_DEVICE
[   12.675546] saa7133[0]: i2c xfer: < cb ERROR: NO_DEVICE
[   12.675721] saa7133[0]: i2c xfer: < cd ERROR: NO_DEVICE
[   12.675897] saa7133[0]: i2c xfer: < cf ERROR: NO_DEVICE
[   12.676080] saa7133[0]: i2c xfer: < d1 ERROR: NO_DEVICE
[   12.676256] saa7133[0]: i2c xfer: < d3 ERROR: NO_DEVICE
[   12.676432] saa7133[0]: i2c xfer: < d5 ERROR: NO_DEVICE
[   12.676607] saa7133[0]: i2c xfer: < d7 ERROR: NO_DEVICE
[   12.676783] saa7133[0]: i2c xfer: < d9 ERROR: NO_DEVICE
[   12.676959] saa7133[0]: i2c xfer: < db ERROR: NO_DEVICE
[   12.677135] saa7133[0]: i2c xfer: < dd ERROR: NO_DEVICE
[   12.677310] saa7133[0]: i2c xfer: < df ERROR: NO_DEVICE
[   12.677486] saa7133[0]: i2c xfer: < e1 ERROR: NO_DEVICE
[   12.677662] saa7133[0]: i2c xfer: < e3 ERROR: NO_DEVICE
[   12.677838] saa7133[0]: i2c xfer: < e5 ERROR: NO_DEVICE
[   12.678013] saa7133[0]: i2c xfer: < e7 ERROR: NO_DEVICE
[   12.678189] saa7133[0]: i2c xfer: < e9 ERROR: NO_DEVICE
[   12.678553] saa7133[0]: i2c xfer: < eb ERROR: NO_DEVICE
[   12.678729] saa7133[0]: i2c xfer: < ed ERROR: NO_DEVICE
[   12.678905] saa7133[0]: i2c xfer: < ef ERROR: NO_DEVICE
[   12.679081] saa7133[0]: i2c xfer: < f1 ERROR: NO_DEVICE
[   12.679257] saa7133[0]: i2c xfer: < f3 ERROR: NO_DEVICE
[   12.679433] saa7133[0]: i2c xfer: < f5 ERROR: NO_DEVICE
[   12.679608] saa7133[0]: i2c xfer: < f7 ERROR: NO_DEVICE
[   12.679784] saa7133[0]: i2c xfer: < f9 ERROR: NO_DEVICE
[   12.679960] saa7133[0]: i2c xfer: < fb ERROR: NO_DEVICE
[   12.680160] saa7133[0]: i2c xfer: < fd ERROR: NO_DEVICE
[   12.680336] saa7133[0]: i2c xfer: < ff ERROR: NO_DEVICE
[   12.680512] saa7133[0]: i2c xfer: < 10 3c 33 60 >
[   12.711733] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -=
> IRQ 16
[   12.711833] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.749104] saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
[   12.749283] saa7133[0]: i2c xfer: < 86 ERROR: NO_DEVICE
[   12.749460] saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
[   12.749635] saa7133[0]: i2c xfer: < 96 >
[   12.787682] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3a=
f: clean.
[   12.788847] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4f=
f: excluding 0x4d0-0x4d7
[   12.789361] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8f=
f: clean.
[   12.789778] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf=
7: clean.
[   12.790338] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaf=
f: clean.
[   12.843493] saa7133[0]: i2c xfer: < 96 00 >
[   12.848019] saa7133[0]: i2c xfer: < 97 =3D01 =3D01 =3D00 =3D11 =3D01 =3D=
04 =3D01 =3D85 >
[   12.856019] saa7133[0]: i2c xfer: < 96 1f >
[   12.864039] saa7133[0]: i2c xfer: < 97 =3D89 >
[   12.872132] tuner 0-004b: chip found @ 0x96 (saa7133[0])
[   12.872241] saa7133[0]: i2c xfer: < 96 1f >
[   12.880019] saa7133[0]: i2c xfer: < 97 =3D89 >
[   12.888016] saa7133[0]: i2c xfer: < 96 2f >
[   12.896018] saa7133[0]: i2c xfer: < 97 =3D00 >
[   12.904018] saa7133[0]: i2c xfer: < 96 21 c0 >
[   12.936018] saa7133[0]: i2c xfer: < c1 ERROR: NO_DEVICE
[   12.936195] saa7133[0]: i2c xfer: < c3 =3D02 >
[   12.944018] saa7133[0]: i2c xfer: < c5 ERROR: NO_DEVICE
[   12.944194] saa7133[0]: i2c xfer: < c7 ERROR: NO_DEVICE
[   12.944370] saa7133[0]: i2c xfer: < 96 21 00 >
[   12.952018] tda829x 0-004b: setting tuner address to 61
[   12.952021] saa7133[0]: i2c xfer: < 96 21 c0 >
[   12.984018] saa7133[0]: i2c xfer: < c3 =3D02 >
[   13.000699] saa7133[0]: i2c xfer: < c3 =3D02 >
[   13.008017] saa7133[0]: i2c xfer: < c2 30 d0 >
[   13.016016] saa7133[0]: i2c xfer: < 96 21 00 >
[   13.024018] tda829x 0-004b: type set to tda8290+75
[   13.024021] saa7133[0]: i2c xfer: < 96 21 c0 >
[   13.056015] saa7133[0]: i2c xfer: < c2 00 00 00 40 dc 04 af 3f 2a 04 f=
f 00 00 40 >
[   13.064015] saa7133[0]: i2c xfer: < 96 21 00 >
[   13.072015] saa7133[0]: i2c xfer: < 96 20 0b >
[   13.080015] saa7133[0]: i2c xfer: < 96 30 6f >
[   13.088018] saa7133[0]: i2c xfer: < 96 01 00 >
[   13.096015] saa7133[0]: i2c xfer: < 96 02 00 >
[   13.104015] saa7133[0]: i2c xfer: < 96 00 00 >
[   13.120015] saa7133[0]: i2c xfer: < 96 01 90 >
[   13.128016] saa7133[0]: i2c xfer: < 96 28 14 >
[   13.136015] saa7133[0]: i2c xfer: < 96 0f 88 >
[   13.144015] saa7133[0]: i2c xfer: < 96 05 04 >
[   13.152015] saa7133[0]: i2c xfer: < 96 0d 47 >
[   13.160015] saa7133[0]: i2c xfer: < 96 21 c0 >
[   13.179110] Synaptics Touchpad, model: 1, fw: 5.9, id: 0x6eb1, caps: 0=
xa04711/0x40a
[   13.192015] saa7133[0]: i2c xfer: < c2 00 32 f8 40 52 5b 9f 8f >
[   13.200015] saa7133[0]: i2c xfer: < c2 80 00 >
[   13.208016] saa7133[0]: i2c xfer: < c2 60 bf >
[   13.216015] saa7133[0]: i2c xfer: < c2 30 d2 ><6>input: SynPS/2 Synapt=
ics TouchPad as /devices/platform/i8042/serio1/input/input10
[   13.224019]=20
[   13.232022] saa7133[0]: i2c xfer: < c2 30 56 >
[   13.248016] saa7133[0]: i2c xfer: < c2 30 52 >
[   13.812019] saa7133[0]: i2c xfer: < c2 30 50 >
[   13.820015] saa7133[0]: i2c xfer: < c2 60 3f >
[   13.828018] saa7133[0]: i2c xfer: < c2 80 08 >
[   13.836018] saa7133[0]: i2c xfer: < 96 1b >
[   13.844017] saa7133[0]: i2c xfer: < 97 =3D4d >
[   13.956018] saa7133[0]: i2c xfer: < 96 1b >
[   13.964017] saa7133[0]: i2c xfer: < 97 =3D45 >
[   14.076018] saa7133[0]: i2c xfer: < 96 1b >
[   14.084017] saa7133[0]: i2c xfer: < 97 =3D3c >
[   14.196019] saa7133[0]: i2c xfer: < 96 28 64 >
[   14.308018] saa7133[0]: i2c xfer: < 96 1d >
[   14.316017] saa7133[0]: i2c xfer: < 97 =3Dff >
[   14.324017] saa7133[0]: i2c xfer: < 96 1b >
[   14.332019] saa7133[0]: i2c xfer: < 97 =3D30 >
[   14.340018] saa7133[0]: i2c xfer: < c2 80 0c >
[   14.452019] saa7133[0]: i2c xfer: < 96 1d >
[   14.460018] saa7133[0]: i2c xfer: < 97 =3Dcf >
[   14.468015] saa7133[0]: i2c xfer: < 96 1b >
[   14.476018] saa7133[0]: i2c xfer: < 97 =3D2f >
[   14.484017] saa7133[0]: i2c xfer: < 96 05 01 >
[   14.492019] saa7133[0]: i2c xfer: < 96 0d 27 >
[   14.604017] saa7133[0]: i2c xfer: < 96 21 00 >
[   14.612019] saa7133[0]: i2c xfer: < 96 0f 81 >
[   14.620023] saa7133[0]: i2c xfer: < 96 01 10 >
[   14.628018] saa7133[0]: i2c xfer: < 96 02 00 >
[   14.636018] saa7133[0]: i2c xfer: < 96 00 00 >
[   14.652018] saa7133[0]: i2c xfer: < 96 01 82 >
[   14.660018] saa7133[0]: i2c xfer: < 96 28 14 >
[   14.668015] saa7133[0]: i2c xfer: < 96 0f 88 >
[   14.676018] saa7133[0]: i2c xfer: < 96 05 04 >
[   14.684017] saa7133[0]: i2c xfer: < 96 0d 47 >
[   14.692019] saa7133[0]: i2c xfer: < 96 21 c0 >
[   14.724017] saa7133[0]: i2c xfer: < c2 00 32 d8 40 52 5b 9f 8f >
[   14.732019] saa7133[0]: i2c xfer: < c2 80 00 >
[   14.740018] saa7133[0]: i2c xfer: < c2 60 bf >
[   14.748018] saa7133[0]: i2c xfer: < c2 30 d2 >
[   14.764016] saa7133[0]: i2c xfer: < c2 30 56 >
[   14.780017] saa7133[0]: i2c xfer: < c2 30 52 >
[   15.344019] saa7133[0]: i2c xfer: < c2 30 50 >
[   15.352025] saa7133[0]: i2c xfer: < c2 60 3f >
[   15.360018] saa7133[0]: i2c xfer: < c2 80 08 >
[   15.368016] saa7133[0]: i2c xfer: < 96 1b >
[   15.376018] saa7133[0]: i2c xfer: < 97 =3D4d >
[   15.488016] saa7133[0]: i2c xfer: < 96 1b >
[   15.496018] saa7133[0]: i2c xfer: < 97 =3D45 >
[   15.608016] saa7133[0]: i2c xfer: < 96 1b >
[   15.616017] saa7133[0]: i2c xfer: < 97 =3D3d >
[   15.728016] saa7133[0]: i2c xfer: < 96 28 64 >
[   15.840018] saa7133[0]: i2c xfer: < 96 1d >
[   15.848016] saa7133[0]: i2c xfer: < 97 =3Dff >
[   15.856018] saa7133[0]: i2c xfer: < 96 1b >
[   15.864018] saa7133[0]: i2c xfer: < 97 =3D37 >
[   15.872015] saa7133[0]: i2c xfer: < c2 80 0c >
[   15.984018] saa7133[0]: i2c xfer: < 96 1d >
[   15.992018] saa7133[0]: i2c xfer: < 97 =3Dcf >
[   16.000018] saa7133[0]: i2c xfer: < 96 1b >
[   16.008016] saa7133[0]: i2c xfer: < 97 =3D0d >
[   16.016017] saa7133[0]: i2c xfer: < 96 05 01 >
[   16.024024] saa7133[0]: i2c xfer: < 96 0d 27 >
[   16.136019] saa7133[0]: i2c xfer: < 96 21 00 >
[   16.144018] saa7133[0]: i2c xfer: < 96 0f 81 >
[   16.152024] saa7133[0]: i2c xfer: < 96 01 02 >
[   16.160018] saa7133[0]: i2c xfer: < 96 02 00 >
[   16.168016] saa7133[0]: i2c xfer: < 96 00 00 >
[   16.184017] saa7133[0]: i2c xfer: < 96 01 82 >
[   16.192018] saa7133[0]: i2c xfer: < 96 28 14 >
[   16.200018] saa7133[0]: i2c xfer: < 96 0f 88 >
[   16.208016] saa7133[0]: i2c xfer: < 96 05 04 >
[   16.216017] saa7133[0]: i2c xfer: < 96 0d 47 >
[   16.224018] saa7133[0]: i2c xfer: < 96 21 c0 >
[   16.256019] saa7133[0]: i2c xfer: < c2 00 32 d8 40 52 5b 9f 8f >
[   16.264018] saa7133[0]: i2c xfer: < c2 80 00 >
[   16.272021] saa7133[0]: i2c xfer: < c2 60 bf >
[   16.280018] saa7133[0]: i2c xfer: < c2 30 d2 >
[   16.296018] saa7133[0]: i2c xfer: < c2 30 56 >
[   16.312017] saa7133[0]: i2c xfer: < c2 30 52 >
[   16.876018] saa7133[0]: i2c xfer: < c2 30 50 >
[   16.884017] saa7133[0]: i2c xfer: < c2 60 3f >
[   16.892019] saa7133[0]: i2c xfer: < c2 80 08 >
[   16.900018] saa7133[0]: i2c xfer: < 96 1b >
[   16.908018] saa7133[0]: i2c xfer: < 97 =3D4d >
[   17.020016] saa7133[0]: i2c xfer: < 96 1b >
[   17.028018] saa7133[0]: i2c xfer: < 97 =3D45 >
[   17.140019] saa7133[0]: i2c xfer: < 96 1b >
[   17.148018] saa7133[0]: i2c xfer: < 97 =3D3c >
[   17.260019] saa7133[0]: i2c xfer: < 96 28 64 >
[   17.372015] saa7133[0]: i2c xfer: < 96 1d >
[   17.380018] saa7133[0]: i2c xfer: < 97 =3Dff >
[   17.388018] saa7133[0]: i2c xfer: < 96 1b >
[   17.396018] saa7133[0]: i2c xfer: < 97 =3D40 >
[   17.404017] saa7133[0]: i2c xfer: < c2 80 0c >
[   17.516017] saa7133[0]: i2c xfer: < 96 1d >
[   17.524015] saa7133[0]: i2c xfer: < 97 =3Dcf >
[   17.532019] saa7133[0]: i2c xfer: < 96 1b >
[   17.540022] saa7133[0]: i2c xfer: < 97 =3D48 >
[   17.548018] saa7133[0]: i2c xfer: < 96 05 01 >
[   17.556018] saa7133[0]: i2c xfer: < 96 0d 27 >
[   17.668018] saa7133[0]: i2c xfer: < 96 21 00 >
[   17.676018] saa7133[0]: i2c xfer: < 96 0f 81 >
[   17.684079] saa7133[0]: gpio: mode=3D0x0200000 in=3D0x0010000 out=3D0x=
0200000 [Television]
[   17.684160] saa7133[0]: gpio: mode=3D0x0200000 in=3D0x0010000 out=3D0x=
0200000 [Television]
[   17.684325] saa7133[0]: gpio: mode=3D0x0200000 in=3D0x0010000 out=3D0x=
0200000 [Television]
[   17.684330] saa7133[0]: i2c xfer: < 96 21 c0 >
[   17.716018] saa7133[0]: i2c xfer: < c2 30 d0 >
[   17.724016] saa7133[0]: i2c xfer: < 96 21 00 >
[   17.732019] saa7133[0]: i2c xfer: < 96 02 20 >
[   17.740018] saa7133[0]: i2c xfer: < 96 00 02 >
[   17.748166] saa7133[0]: registered device video0 [v4l2]
[   17.748267] saa7133[0]: registered device vbi0
[   17.748370] saa7133[0]: registered device radio0
[   18.211285] saa7134 ALSA driver for DMA sound loaded
[   18.211320] saa7133[0]/alsa: saa7133[0] at 0xb4007800 irq 19 registere=
d as card -2
[   18.266038] dvb_init() allocating 1 frontend
[   18.308611] saa7133[0]: i2c xfer: < 10 00 [fe quirk] < 11 =3D46 >
[   18.316126] DVB: registering new adapter (saa7133[0])
[   18.316130] DVB: registering adapter 0 frontend 0 (Philips TDA10046H D=
VB-T)...
[   18.316441] saa7133[0]: i2c xfer: < 10 07 80 >
[   18.324562] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[   18.332307] saa7133[0]: i2c xfer: < 10 3b fe >
[   18.340036] saa7133[0]: i2c xfer: < 10 3c 33 >
[   18.348154] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D60 >
[   18.357443] saa7133[0]: i2c xfer: < 10 3d 62 >
[   18.380028] saa7133[0]: i2c xfer: < 10 2d f0 >
[   18.388018] tda1004x: setting up plls for 48MHz sampling clock
[   18.388021] saa7133[0]: i2c xfer: < 10 2f 03 >
[   18.396021] saa7133[0]: i2c xfer: < 10 30 03 >
[   18.404018] saa7133[0]: i2c xfer: < 10 3e 72 ><6>lp0: using parport0 (=
interrupt-driven).
[   18.412022]=20
[   18.412028] saa7133[0]: i2c xfer: < 10 4d 0c >
[   18.420019] saa7133[0]: i2c xfer: < 10 4e 00 >
[   18.428020] saa7133[0]: i2c xfer: < 10 31 54 >
[   18.436017] saa7133[0]: i2c xfer: < 10 32 03 >
[   18.444465] saa7133[0]: i2c xfer: < 10 33 0c >
[   18.452066] saa7133[0]: i2c xfer: < 10 34 30 >
[   18.460989] saa7133[0]: i2c xfer: < 10 35 c3 >
[   18.468948] saa7133[0]: i2c xfer: < 10 4d 0d >
[   18.476029] saa7133[0]: i2c xfer: < 10 4e 55 >
[   18.512217] Adding 979924k swap on /dev/sda5.  Priority:-1 extents:1 a=
cross:979924k
[   18.608023] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3D34 >
[   18.616032] saa7133[0]: i2c xfer: < 10 37 34 >
[   18.624369] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.640018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.656013] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.672008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.688019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.704018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.720017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.736018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.752026] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.768016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.784017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.800017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.816018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.832017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.848015] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.864017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.880017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.896017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.912017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.928015] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.944017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.960017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.976017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.992017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.008015] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.024017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.040145] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 ><6>EX=
T4 FS on sda1, internal journal on sda1:8
[   19.048020]=20
[   19.056019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.072016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.088886] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.104304] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.120609] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.136020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.152327] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.168021] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.184021] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.200016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.216018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.233266] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.248410] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.264017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.280018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.296072] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.312051] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.328018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.344017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.360017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.376018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.392020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.408025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.424017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.440020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.456018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.472018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.488015] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.504018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.520017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.536020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.552016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.568009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.584020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.600009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.616018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.632018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.648016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.664009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.680128] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.696020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.712020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.732007] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.748014] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.764023] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.784007] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.800020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.816018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.832019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.848010] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.864044] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.880009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.896009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.912010] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.928011] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.944008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.960011] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.976008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.992019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.008008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.024023] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.040020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.056018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.072019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.088016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.104009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.120010] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.136017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.152019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.168008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.184018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.200007] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.216010] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.232020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.248008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.264019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.280009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.296018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.312009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.328016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[   20.336010] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[   20.344017] saa7133[0]: i2c xfer: < 10 07 80 >
[   20.352019] saa7133[0]: i2c xfer: < 10 11 67 >
[   20.360017] saa7133[0]: i2c xfer: < 10 13 [fe quirk] < 11 =3D67 >
[   20.368016] saa7133[0]: i2c xfer: < 10 14 [fe quirk] < 11 =3D23 >
[   20.376010] tda1004x: found firmware revision 23 -- ok
[   20.376013] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[   20.384007] saa7133[0]: i2c xfer: < 10 07 80 >
[   20.392020] saa7133[0]: i2c xfer: < 10 01 87 >
[   20.400010] saa7133[0]: i2c xfer: < 10 16 88 >
[   20.408017] saa7133[0]: i2c xfer: < 10 43 02 >
[   20.416020] saa7133[0]: i2c xfer: < 10 44 70 >
[   20.424010] saa7133[0]: i2c xfer: < 10 45 08 >
[   20.432007] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D62 >
[   20.440020] saa7133[0]: i2c xfer: < 10 3d 62 >
[   20.448010] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[   20.456017] saa7133[0]: i2c xfer: < 10 3b 7f >
[   20.464018] saa7133[0]: i2c xfer: < 10 3a [fe quirk] < 11 =3D00 >
[   20.472010] saa7133[0]: i2c xfer: < 10 3a 00 >
[   20.480007] saa7133[0]: i2c xfer: < 10 37 38 >
[   20.488022] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3D7f >
[   20.496018] saa7133[0]: i2c xfer: < 10 3b 79 >
[   20.504010] saa7133[0]: i2c xfer: < 10 47 00 >
[   20.512007] saa7133[0]: i2c xfer: < 10 48 ff >
[   20.520020] saa7133[0]: i2c xfer: < 10 49 00 >
[   20.528016] saa7133[0]: i2c xfer: < 10 4a ff >
[   20.536010] saa7133[0]: i2c xfer: < 10 46 12 >
[   20.544008] saa7133[0]: i2c xfer: < 10 4f 1a >
[   20.558115] saa7133[0]: i2c xfer: < 10 1e 07 >
[   20.567686] saa7133[0]: i2c xfer: < 10 1f c0 >
[   20.576020] saa7133[0]: i2c xfer: < 10 3b ff >
[   20.584017] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D62 >
[   20.592019] saa7133[0]: i2c xfer: < 10 3d 68 >
[   20.600018] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3D38 >
[   20.613902] saa7133[0]: i2c xfer: < 10 37 f8 >
[   20.620020] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[   20.628018] saa7133[0]: i2c xfer: < 10 07 81 >
[   20.636011] saa7133[0]: i2c xfer: < 96 21 c0 >
[   20.668016] saa7133[0]: i2c xfer: < c3 =3D02 >
[   20.676010] saa7133[0]: i2c xfer: < 96 21 80 >
[   20.708018] saa7133[0]: i2c xfer: < 96 21 c0 >
[   20.740018] saa7133[0]: i2c xfer: < c2 30 d0 >
[   20.748011] saa7133[0]: i2c xfer: < 96 21 80 >
[   26.348364] EXT4-fs: barriers enabled
[   26.367127] kjournald2 starting.  Commit interval 5 seconds
[   26.368150] EXT4 FS on sda6, internal journal on sda6:8
[   26.368153] EXT4-fs: delayed allocation enabled
[   26.368155] EXT4-fs: file extents enabled
[   26.368974] EXT4-fs: mballoc enabled
[   26.368978] EXT4-fs: mounted filesystem with ordered data mode.
[   26.622366] type=3D1505 audit(1261659540.013:2): operation=3D"profile_=
load" name=3D"/usr/share/gdm/guest-session/Xsession" name2=3D"default" pi=
d=3D2227
[   26.677838] type=3D1505 audit(1261659540.069:3): operation=3D"profile_=
load" name=3D"/sbin/dhclient-script" name2=3D"default" pid=3D2231
[   26.677956] type=3D1505 audit(1261659540.069:4): operation=3D"profile_=
load" name=3D"/sbin/dhclient3" name2=3D"default" pid=3D2231
[   26.678006] type=3D1505 audit(1261659540.069:5): operation=3D"profile_=
load" name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" name2=3D"def=
ault" pid=3D2231
[   26.678052] type=3D1505 audit(1261659540.069:6): operation=3D"profile_=
load" name=3D"/usr/lib/connman/scripts/dhclient-script" name2=3D"default"=
 pid=3D2231
[   26.841578] type=3D1505 audit(1261659540.233:7): operation=3D"profile_=
load" name=3D"/usr/lib/cups/backend/cups-pdf" name2=3D"default" pid=3D223=
6
[   26.841832] type=3D1505 audit(1261659540.233:8): operation=3D"profile_=
load" name=3D"/usr/sbin/cupsd" name2=3D"default" pid=3D2236
[   26.873211] type=3D1505 audit(1261659540.265:9): operation=3D"profile_=
load" name=3D"/usr/sbin/tcpdump" name2=3D"default" pid=3D2240
[   29.582065] saa7133[0]: gpio: mode=3D0x0200000 in=3D0x0010000 out=3D0x=
0000000 [Radio]
[   29.582073] saa7133[0]: i2c xfer: < 96 01 02 >
[   29.590598] saa7133[0]: i2c xfer: < 96 02 00 >
[   29.597223] saa7133[0]: i2c xfer: < 96 00 00 >
[   29.604025] saa7133[0]: i2c xfer: < 96 01 01 >
[   29.612023] saa7133[0]: i2c xfer: < 96 02 00 >
[   29.620023] saa7133[0]: i2c xfer: < 96 00 00 >
[   29.628159] saa7133[0]: i2c xfer: < 96 01 02 >
[   29.636274] saa7133[0]: i2c xfer: < 96 02 00 >
[   29.645446] saa7133[0]: i2c xfer: < 96 00 00 >
[   29.652917] saa7133[0]: i2c xfer: < 96 01 81 >
[   29.660422] saa7133[0]: i2c xfer: < 96 03 48 >
[   29.668130] saa7133[0]: i2c xfer: < 96 04 04 >
[   29.676423] saa7133[0]: i2c xfer: < 96 05 04 >
[   29.684435] saa7133[0]: i2c xfer: < 96 06 10 >
[   29.692030] saa7133[0]: i2c xfer: < 96 07 00 >
[   29.700018] saa7133[0]: i2c xfer: < 96 08 00 >
[   29.708018] saa7133[0]: i2c xfer: < 96 09 80 >
[   29.716018] saa7133[0]: i2c xfer: < 96 0a da >
[   29.724018] saa7133[0]: i2c xfer: < 96 0b 4b >
[   29.732018] saa7133[0]: i2c xfer: < 96 0c 68 >
[   29.740018] saa7133[0]: i2c xfer: < 96 0d 00 >
[   29.748018] saa7133[0]: i2c xfer: < 96 14 00 >
[   29.756019] saa7133[0]: i2c xfer: < 96 13 01 >
[   29.766993] saa7133[0]: i2c xfer: < 96 21 c0 >
[   29.772900] saa7133[0]: i2c xfer: < 96 01 82 >
[   29.780028] saa7133[0]: i2c xfer: < 96 28 14 >
[   29.788020] saa7133[0]: i2c xfer: < 96 0f 88 >
[   29.796024] saa7133[0]: i2c xfer: < 96 05 04 >
[   29.804018] saa7133[0]: i2c xfer: < 96 0d 47 >
[   29.812018] saa7133[0]: i2c xfer: < 96 21 c0 >
[   29.820019] saa7133[0]: i2c xfer: < 96 01 82 >
[   29.828018] saa7133[0]: i2c xfer: < 96 28 14 >
[   29.836018] saa7133[0]: i2c xfer: < 96 0f 88 >
[   29.844018] saa7133[0]: i2c xfer: < 96 05 04 >
[   29.852018] saa7133[0]: i2c xfer: < 96 0d 47 >
[   29.860018] saa7133[0]: i2c xfer: < 96 21 c0 >
[   29.868019] saa7133[0]: i2c xfer: < c2 00 2e 80 40 52 d0 9f 8f >
[   29.876018] saa7133[0]: i2c xfer: < c2 80 00 >
[   29.884018] saa7133[0]: i2c xfer: < c2 60 bf >
[   29.892018] saa7133[0]: i2c xfer: < c2 30 d2 >
[   29.900019] saa7133[0]: i2c xfer: < c2 00 32 d8 40 52 5b 9f 8f >
[   29.908019] saa7133[0]: i2c xfer: < c2 80 00 >
[   29.916018] saa7133[0]: i2c xfer: < c2 60 bf >
[   29.924018] saa7133[0]: i2c xfer: < c2 30 d2 >
[   29.932019] saa7133[0]: i2c xfer: < c2 00 32 d8 40 52 5b 9f 8f >
[   29.940018] saa7133[0]: i2c xfer: < c2 80 00 >
[   29.948018] saa7133[0]: i2c xfer: < c2 60 bf >
[   29.956018] saa7133[0]: i2c xfer: < c2 30 d2 >
[   29.964019] saa7133[0]: i2c xfer: < c2 30 56 >
[   29.972019] saa7133[0]: i2c xfer: < c2 30 56 >
[   29.980020] saa7133[0]: i2c xfer: < c2 30 56 >
[   29.988020] saa7133[0]: i2c xfer: < c2 30 52 >
[   29.996019] saa7133[0]: i2c xfer: < c2 30 52 >
[   30.004030] saa7133[0]: i2c xfer: < c2 30 52 >
[   30.552018] saa7133[0]: i2c xfer: < c2 30 50 >
[   30.560016] saa7133[0]: i2c xfer: < c2 60 3f >
[   30.568018] saa7133[0]: i2c xfer: < c2 80 08 >
[   30.576018] saa7133[0]: i2c xfer: < 96 1b >
[   30.584018] saa7133[0]: i2c xfer: < 97 =3D4b >
[   30.592019] saa7133[0]: i2c xfer: < c2 30 50 >
[   30.600018] saa7133[0]: i2c xfer: < c2 60 3f >
[   30.608017] saa7133[0]: i2c xfer: < c2 80 08 >
[   30.616018] saa7133[0]: i2c xfer: < 96 1b >
[   30.624018] saa7133[0]: i2c xfer: < 97 =3D48 >
[   30.632019] saa7133[0]: i2c xfer: < c2 30 50 >
[   30.640017] saa7133[0]: i2c xfer: < c2 60 3f >
[   30.648017] saa7133[0]: i2c xfer: < c2 80 08 >
[   30.656023] saa7133[0]: i2c xfer: < 96 1b >
[   30.664017] saa7133[0]: i2c xfer: < 97 =3D46 >
[   30.696019] saa7133[0]: i2c xfer: < 96 1b >
[   30.704016] saa7133[0]: i2c xfer: < 97 =3D43 >
[   30.736019] saa7133[0]: i2c xfer: < 96 1b >
[   30.744016] saa7133[0]: i2c xfer: < 97 =3D40 >
[   30.776019] saa7133[0]: i2c xfer: < 96 1b >
[   30.784016] saa7133[0]: i2c xfer: < 97 =3D3c >
[   30.816020] saa7133[0]: i2c xfer: < 96 1b >
[   30.824015] saa7133[0]: i2c xfer: < 97 =3D3b >
[   30.856019] saa7133[0]: i2c xfer: < 96 1b >
[   30.864015] saa7133[0]: i2c xfer: < 97 =3D39 >
[   30.896019] saa7133[0]: i2c xfer: < 96 1b >
[   30.904021] saa7133[0]: i2c xfer: < 97 =3D36 >
[   30.936019] saa7133[0]: i2c xfer: < 96 21 00 >
[   30.944015] saa7133[0]: i2c xfer: < 96 0f 81 >
[   30.952676] saa7133[0]: i2c xfer: < 96 21 c0 >
[   30.976019] saa7133[0]: i2c xfer: < 96 28 64 >
[   30.984019] saa7133[0]: i2c xfer: < c2 30 d0 >
[   30.992017] saa7133[0]: i2c xfer: < 96 21 00 >
[   31.000017] saa7133[0]: i2c xfer: < 96 02 20 >
[   31.008016] saa7133[0]: i2c xfer: < 96 00 02 >
[   31.016239] saa7133[0]: i2c xfer: < 96 28 64 >
[   31.088018] saa7133[0]: i2c xfer: < 96 1d >
[   31.096016] saa7133[0]: i2c xfer: < 97 =3D80 >
[   31.104017] saa7133[0]: i2c xfer: < 96 1b >
[   31.112017] saa7133[0]: i2c xfer: < 97 =3D36 >
[   31.120017] saa7133[0]: i2c xfer: < c2 ERROR: NO_DEVICE
[   31.128053] saa7133[0]: i2c xfer: < 96 1d >
[   31.136016] saa7133[0]: i2c xfer: < 97 =3D80 >
[   31.144017] saa7133[0]: i2c xfer: < 96 1b >
[   31.152025] saa7133[0]: i2c xfer: < 97 =3D36 >
[   31.160017] saa7133[0]: i2c xfer: < c2 ERROR: NO_DEVICE
[   31.224056] saa7133[0]: i2c xfer: < 96 1d >
[   31.232016] saa7133[0]: i2c xfer: < 97 =3D80 >
[   31.240017] saa7133[0]: i2c xfer: < 96 1b >
[   31.248016] saa7133[0]: i2c xfer: < 97 =3D36 >
[   31.256017] saa7133[0]: i2c xfer: < 96 05 01 >
[   31.264020] saa7133[0]: i2c xfer: < 96 0d 27 >
[   31.272019] saa7133[0]: i2c xfer: < 96 1d >
[   31.280017] saa7133[0]: i2c xfer: < 97 =3D80 >
[   31.288017] saa7133[0]: i2c xfer: < 96 1b >
[   31.296017] saa7133[0]: i2c xfer: < 97 =3D36 >
[   31.304017] saa7133[0]: i2c xfer: < 96 05 01 >
[   31.312017] saa7133[0]: i2c xfer: < 96 0d 27 >
[   31.376019] saa7133[0]: i2c xfer: < 96 21 00 >
[   31.384016] saa7133[0]: i2c xfer: < 96 0f 81 >
[   31.392080] saa7133[0]: gpio: mode=3D0x0200000 in=3D0x0010000 out=3D0x=
0200000 [Television]
[   31.424023] saa7133[0]: i2c xfer: < 96 21 00 >
[   31.432016] saa7133[0]: i2c xfer: < 96 0f 81 >
[   31.440080] saa7133[0]: gpio: mode=3D0x0200000 in=3D0x0010000 out=3D0x=
0200000 [Television]
[   31.567778] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   31.567782] Bluetooth: BNEP filters: protocol multicast
[   31.619949] Bridge firewalling registered
[   37.326626] sky2 eth0: enabling interface
[   37.326871] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   42.008901] saa7133[0]: gpio: mode=3D0x0200000 in=3D0x0010000 out=3D0x=
0200000 [Television]
[   47.013844] saa7133[0]: gpio: mode=3D0x0200000 in=3D0x0010000 out=3D0x=
0200000 [Television]
[   47.404020] eth1: no IPv6 routers present
[   57.701130] CPU0 attaching NULL sched-domain.
[   57.701204] CPU0 attaching NULL sched-domain.
[   63.334658] ieee80211_crypt: registered algorithm 'CCMP'
[   63.477600] padlock: VIA PadLock not detected.
[   98.040025] Clocksource tsc unstable (delta =3D -120385657 ns)
[  274.337866] saa7133[0]: i2c xfer: < 10 07 80 >
[  274.344024] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  274.352030] saa7133[0]: i2c xfer: < 10 3b fe >
[  274.360026] saa7133[0]: i2c xfer: < 10 3c 33 >
[  274.368026] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D68 >
[  274.376026] saa7133[0]: i2c xfer: < 10 3d 62 >
[  274.400027] saa7133[0]: i2c xfer: < 10 2d f0 >
[  274.408025] tda1004x: setting up plls for 48MHz sampling clock
[  274.408032] saa7133[0]: i2c xfer: < 10 2f 03 >
[  274.416036] saa7133[0]: i2c xfer: < 10 30 03 >
[  274.424026] saa7133[0]: i2c xfer: < 10 3e 72 >
[  274.432026] saa7133[0]: i2c xfer: < 10 4d 0c >
[  274.440038] saa7133[0]: i2c xfer: < 10 4e 00 >
[  274.448027] saa7133[0]: i2c xfer: < 10 31 54 >
[  274.456026] saa7133[0]: i2c xfer: < 10 32 03 >
[  274.464027] saa7133[0]: i2c xfer: < 10 33 0c >
[  274.472030] saa7133[0]: i2c xfer: < 10 34 30 >
[  274.480026] saa7133[0]: i2c xfer: < 10 35 c3 >
[  274.488026] saa7133[0]: i2c xfer: < 10 4d 0d >
[  274.496037] saa7133[0]: i2c xfer: < 10 4e 55 >
[  274.628029] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3Df8 >
[  274.636023] saa7133[0]: i2c xfer: < 10 37 38 >
[  274.644027] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.660025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.676025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.692025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.708027] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.724025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.740029] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.756024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.772024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.788024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.804024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.820024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.836025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.852025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.868024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.884027] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.900024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.916028] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.932035] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.948024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.964025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.980024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.996024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.012026] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.028024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.044024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.060028] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.076025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.092030] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.108025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.124025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.140024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.156024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.172024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.188034] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.204026] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.220024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.236029] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.252024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.268398] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.284025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.300029] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.316026] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.332024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.348024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.364025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.392037] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.408032] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.424035] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.440025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.456054] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.472017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.488014] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.504014] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.520015] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.536044] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.552308] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.568025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.584025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.600024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.616036] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.632025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.648029] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.664025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.680034] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.696035] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.712025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.728024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.744026] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.760025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.776034] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.792027] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.808024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.824028] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.840025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.856032] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.872024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.888025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.904025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.920025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.936035] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.952024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.968028] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.984024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.000028] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.016035] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.032025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.048024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.064025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.080024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.096035] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.112025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.128024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.144028] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.160025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.176247] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.192027] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.208025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.224024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.240025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.256036] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.272026] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.288025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.304024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  276.312022] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  276.320031] saa7133[0]: i2c xfer: < 10 07 80 >
[  276.328026] saa7133[0]: i2c xfer: < 10 11 67 >
[  276.336035] saa7133[0]: i2c xfer: < 10 13 [fe quirk] < 11 =3D67 >
[  276.344026] saa7133[0]: i2c xfer: < 10 14 [fe quirk] < 11 =3D23 >
[  276.352644] tda1004x: found firmware revision 23 -- ok
[  276.352652] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  276.360028] saa7133[0]: i2c xfer: < 10 07 80 >
[  276.368025] saa7133[0]: i2c xfer: < 10 01 87 >
[  276.376026] saa7133[0]: i2c xfer: < 10 16 88 >
[  276.384026] saa7133[0]: i2c xfer: < 10 43 02 >
[  276.392026] saa7133[0]: i2c xfer: < 10 44 70 >
[  276.400026] saa7133[0]: i2c xfer: < 10 45 08 >
[  276.408243] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D62 >
[  276.416035] saa7133[0]: i2c xfer: < 10 3d 62 >
[  276.424035] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  276.432026] saa7133[0]: i2c xfer: < 10 3b 7f >
[  276.441294] saa7133[0]: i2c xfer: < 10 3a [fe quirk] < 11 =3D00 >
[  276.448028] saa7133[0]: i2c xfer: < 10 3a 00 >
[  276.456026] saa7133[0]: i2c xfer: < 10 37 38 >
[  276.464026] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3D7f >
[  276.472026] saa7133[0]: i2c xfer: < 10 3b 79 >
[  276.480026] saa7133[0]: i2c xfer: < 10 47 00 >
[  276.488026] saa7133[0]: i2c xfer: < 10 48 ff >
[  276.496036] saa7133[0]: i2c xfer: < 10 49 00 >
[  276.504027] saa7133[0]: i2c xfer: < 10 4a ff >
[  276.512026] saa7133[0]: i2c xfer: < 10 46 12 >
[  276.520026] saa7133[0]: i2c xfer: < 10 4f 1a >
[  276.528030] saa7133[0]: i2c xfer: < 10 1e 07 >
[  276.536028] saa7133[0]: i2c xfer: < 10 1f c0 >
[  276.544027] saa7133[0]: i2c xfer: < 96 21 c0 >
[  276.576037] saa7133[0]: i2c xfer: < 96 21 80 >
[  279.608146] saa7133[0]: i2c xfer: < 96 21 c0 >
[  279.640493] saa7133[0]: i2c xfer: < 96 21 c0 >
[  279.672017] saa7133[0]: i2c xfer: < c2 30 d0 >
[  279.680025] saa7133[0]: i2c xfer: < 96 21 80 >
[  279.726526] saa7133[0]: i2c xfer: < 96 21 80 >
[  279.756016] saa7133[0]: i2c xfer: < 10 3b ff >
[  279.764014] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D62 >
[  279.772012] saa7133[0]: i2c xfer: < 10 3d 68 >
[  279.780030] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3D38 >
[  279.788026] saa7133[0]: i2c xfer: < 10 37 f8 >
[  279.796026] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  279.804025] saa7133[0]: i2c xfer: < 10 07 81 >
[  280.911636] saa7133[0]: i2c xfer: < 10 07 80 >
[  280.920028] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  280.928027] saa7133[0]: i2c xfer: < 10 3b fe >
[  280.936026] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  280.936175] saa7133[0]: i2c xfer: < 10 3d ERROR: BUS_ERR
[  280.952062] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  280.952173] tda1004x: setting up plls for 48MHz sampling clock
[  280.952215] saa7133[0]: i2c xfer: < 10 2f ERROR: BUS_ERR
[  280.952549] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  280.952730] saa7133[0]: i2c xfer: < 10 3e ERROR: BUS_ERR
[  280.953013] saa7133[0]: i2c xfer: < 10 ERROR: ARB_LOST
[  280.953292] saa7133[0]: i2c xfer: < 10 4e 00 >
[  280.960030] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  280.960212] saa7133[0]: i2c xfer: < 10 4d 0d ERROR: ARB_LOST
[  280.960665] saa7133[0]: i2c xfer: < 10 ERROR: ARB_LOST
[  281.084068] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3Df8 >
[  281.092023] saa7133[0]: i2c xfer: < 10 37 38 >
[  281.100027] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  281.108026] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  281.116026] saa7133[0]: i2c xfer: < 10 07 80 >
[  281.124026] saa7133[0]: i2c xfer: < 10 11 67 >
[  281.132058] saa7133[0]: i2c xfer: < 10 13 [fe quirk] < 11 =3D67 >
[  281.140026] saa7133[0]: i2c xfer: < 10 14 [fe quirk] < 11 =3D23 >
[  281.148026] tda1004x: found firmware revision 23 -- ok
[  281.148033] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  281.156027] saa7133[0]: i2c xfer: < 10 07 80 >
[  281.165023] saa7133[0]: i2c xfer: < 10 01 87 >
[  281.172027] saa7133[0]: i2c xfer: < 10 16 88 >
[  281.180027] saa7133[0]: i2c xfer: < 10 43 02 >
[  281.188033] saa7133[0]: i2c xfer: < 10 44 70 >
[  281.196027] saa7133[0]: i2c xfer: < 10 45 08 >
[  281.204026] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D68 >
[  281.212026] saa7133[0]: i2c xfer: < 10 3d 68 >
[  281.220023] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  281.228026] saa7133[0]: i2c xfer: < 10 3b 7f >
[  281.236026] saa7133[0]: i2c xfer: < 10 3a [fe quirk] < 11 =3D00 >
[  281.244026] saa7133[0]: i2c xfer: < 10 3a 00 >
[  281.253207] saa7133[0]: i2c xfer: < 10 37 38 >
[  281.260027] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3D7f >
[  281.268025] saa7133[0]: i2c xfer: < 10 3b 79 >
[  281.276026] saa7133[0]: i2c xfer: < 10 47 00 >
[  281.284027] saa7133[0]: i2c xfer: < 10 48 ff >
[  281.292029] saa7133[0]: i2c xfer: < 10 49 00 >
[  281.300027] saa7133[0]: i2c xfer: < 10 4a ff >
[  281.308027] saa7133[0]: i2c xfer: < 10 46 12 >
[  281.316028] saa7133[0]: i2c xfer: < 10 4f 1a >
[  281.324026] saa7133[0]: i2c xfer: < 10 1e 07 >
[  281.332027] saa7133[0]: i2c xfer: < 10 1f c0 >
[  281.340034] saa7133[0]: i2c xfer: < 96 21 c0 >
[  281.372028] saa7133[0]: i2c xfer: < 96 21 80 >
[  281.404551] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D87 >
[  281.412024] saa7133[0]: i2c xfer: < 10 01 97 >
[  281.420027] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D00 >
[  281.428043] saa7133[0]: i2c xfer: < 10 02 00 >
[  281.436028] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  281.444026] saa7133[0]: i2c xfer: < 10 03 00 >
[  281.452026] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D02 >
[  281.460025] saa7133[0]: i2c xfer: < 10 43 02 >
[  281.468028] saa7133[0]: i2c xfer: < 96 21 c0 >
[  281.500027] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  281.508027] saa7133[0]: i2c xfer: < 96 21 80 >
[  282.044044] saa7133[0]: i2c xfer: < 96 21 c0 >
[  282.076027] saa7133[0]: i2c xfer: < c2 30 50 >
[  282.084023] saa7133[0]: i2c xfer: < 96 21 80 >
[  282.116029] saa7133[0]: i2c xfer: < 96 21 80 >
[  282.148031] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D97 >
[  282.156024] saa7133[0]: i2c xfer: < 10 01 97 >
[  282.164029] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D00 >
[  282.172026] saa7133[0]: i2c xfer: < 10 02 00 >
[  282.180026] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D00 >
[  282.188030] saa7133[0]: i2c xfer: < 10 02 00 >
[  282.196030] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  282.208167] saa7133[0]: i2c xfer: < 10 03 00 >
[  282.216027] saa7133[0]: i2c xfer: < 10 31 54 >
[  282.224033] saa7133[0]: i2c xfer: < 10 32 03 >
[  282.232029] saa7133[0]: i2c xfer: < 10 33 0c >
[  282.240026] saa7133[0]: i2c xfer: < 10 34 30 >
[  282.248026] saa7133[0]: i2c xfer: < 10 35 c3 >
[  282.256038] saa7133[0]: i2c xfer: < 10 4d 0d >
[  282.264026] saa7133[0]: i2c xfer: < 10 4e 55 >
[  282.272026] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3D88 >
[  282.280026] saa7133[0]: i2c xfer: < 10 16 a8 >
[  282.288027] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D97 >
[  282.296026] saa7133[0]: i2c xfer: < 10 01 95 >
[  282.304025] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D00 >
[  282.312026] saa7133[0]: i2c xfer: < 10 02 00 >
[  282.320030] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D95 >
[  282.328026] saa7133[0]: i2c xfer: < 10 01 91 >
[  282.336037] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D00 >
[  282.344026] saa7133[0]: i2c xfer: < 10 02 10 >
[  282.352026] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  282.360026] saa7133[0]: i2c xfer: < 10 01 d1 >
[  282.376035] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D02 >
[  282.384023] saa7133[0]: i2c xfer: < 10 43 03 >
[  282.408038] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  282.416027] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  282.424027] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  282.432027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  282.540122] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  282.548025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  282.556029] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  282.564026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  282.672255] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  282.680027] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  282.688028] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  282.696027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  282.804387] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  282.812025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  282.820030] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  282.828027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  282.936408] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  282.944026] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  282.952027] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  282.960026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  283.068386] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  283.076025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  283.084032] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  283.092028] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  283.200126] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  283.208035] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  283.216031] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  283.224026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  283.232045] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  283.240026] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  283.248026] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  283.256026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  283.264043] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  283.272026] saa7133[0]: i2c xfer: < 10 01 91 >
[  283.280026] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  283.288032] saa7133[0]: i2c xfer: < 10 02 10 >
[  283.296044] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  283.304027] saa7133[0]: i2c xfer: < 10 03 00 >
[  283.312026] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  283.320027] saa7133[0]: i2c xfer: < 10 43 03 >
[  283.328028] saa7133[0]: i2c xfer: < 96 21 c0 >
[  283.360026] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  283.368036] saa7133[0]: i2c xfer: < 96 21 80 >
[  283.904026] saa7133[0]: i2c xfer: < 96 21 c0 >
[  283.936108] saa7133[0]: i2c xfer: < c2 30 50 >
[  283.944027] saa7133[0]: i2c xfer: < 96 21 80 >
[  283.976024] saa7133[0]: i2c xfer: < 96 21 80 >
[  284.008029] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  284.016036] saa7133[0]: i2c xfer: < 10 01 91 >
[  284.024027] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  284.032019] saa7133[0]: i2c xfer: < 10 02 10 >
[  284.040026] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  284.048026] saa7133[0]: i2c xfer: < 10 02 10 >
[  284.056026] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  284.064026] saa7133[0]: i2c xfer: < 10 03 00 >
[  284.072026] saa7133[0]: i2c xfer: < 10 31 54 >
[  284.080026] saa7133[0]: i2c xfer: < 10 32 03 >
[  284.088027] saa7133[0]: i2c xfer: < 10 33 0c >
[  284.096041] saa7133[0]: i2c xfer: < 10 34 30 >
[  284.104027] saa7133[0]: i2c xfer: < 10 35 c3 >
[  284.112036] saa7133[0]: i2c xfer: < 10 4d 0d >
[  284.120026] saa7133[0]: i2c xfer: < 10 4e 55 >
[  284.128026] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3Da8 >
[  284.136026] saa7133[0]: i2c xfer: < 10 16 88 >
[  284.144026] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  284.152026] saa7133[0]: i2c xfer: < 10 01 91 >
[  284.160026] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  284.168026] saa7133[0]: i2c xfer: < 10 02 10 >
[  284.176036] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  284.184030] saa7133[0]: i2c xfer: < 10 01 91 >
[  284.192029] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  284.200027] saa7133[0]: i2c xfer: < 10 02 10 >
[  284.208027] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  284.216026] saa7133[0]: i2c xfer: < 10 01 d1 >
[  284.232025] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  284.240025] saa7133[0]: i2c xfer: < 10 43 03 >
[  284.264052] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  284.272031] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  284.280027] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  284.288027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  284.396127] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  284.404025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  284.412027] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  284.420026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  284.528131] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  284.537357] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  284.544028] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  284.552026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  284.660133] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  284.668026] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  284.676029] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  284.684026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  284.792417] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  284.800025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  284.808033] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  284.816031] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  284.924404] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  284.932025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  284.940028] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  284.948026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  285.056406] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  285.064027] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  285.072034] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  285.080027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  285.088046] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  285.096026] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  285.104035] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  285.112037] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  285.120027] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  285.128026] saa7133[0]: i2c xfer: < 10 01 91 >
[  285.136038] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  285.144030] saa7133[0]: i2c xfer: < 10 02 10 >
[  285.152027] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  285.160032] saa7133[0]: i2c xfer: < 10 03 00 >
[  285.168026] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  285.176026] saa7133[0]: i2c xfer: < 10 43 03 >
[  285.184291] saa7133[0]: i2c xfer: < 96 21 c0 >
[  285.216039] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  285.224046] saa7133[0]: i2c xfer: < 96 21 80 >
[  285.760029] saa7133[0]: i2c xfer: < 96 21 c0 >
[  285.792036] saa7133[0]: i2c xfer: < c2 30 50 >
[  285.800023] saa7133[0]: i2c xfer: < 96 21 80 >
[  285.832021] saa7133[0]: i2c xfer: < 96 21 80 >
[  285.864037] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  285.872025] saa7133[0]: i2c xfer: < 10 01 91 >
[  285.880026] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  285.888026] saa7133[0]: i2c xfer: < 10 02 10 >
[  285.896026] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  285.904026] saa7133[0]: i2c xfer: < 10 02 10 >
[  285.912026] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  285.920026] saa7133[0]: i2c xfer: < 10 03 00 >
[  285.928026] saa7133[0]: i2c xfer: < 10 31 54 >
[  285.936035] saa7133[0]: i2c xfer: < 10 32 03 >
[  285.944025] saa7133[0]: i2c xfer: < 10 33 0c >
[  285.952029] saa7133[0]: i2c xfer: < 10 34 30 >
[  285.960028] saa7133[0]: i2c xfer: < 10 35 c3 >
[  285.968026] saa7133[0]: i2c xfer: < 10 4d 0d >
[  285.976034] saa7133[0]: i2c xfer: < 10 4e 55 >
[  285.984026] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3D88 >
[  285.992026] saa7133[0]: i2c xfer: < 10 16 88 >
[  286.000026] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  286.008026] saa7133[0]: i2c xfer: < 10 01 91 >
[  286.016036] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  286.024025] saa7133[0]: i2c xfer: < 10 02 10 >
[  286.032026] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  286.040029] saa7133[0]: i2c xfer: < 10 01 91 >
[  286.048028] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  286.056026] saa7133[0]: i2c xfer: < 10 02 10 >
[  286.064026] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  286.072026] saa7133[0]: i2c xfer: < 10 01 d1 >
[  286.088024] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  286.096040] saa7133[0]: i2c xfer: < 10 43 03 >
[  286.120035] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  286.128030] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  286.136029] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  286.144026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  286.920045] saa7133[0]: i2c xfer: < 96 21 c0 >
[  286.952026] saa7133[0]: i2c xfer: < 96 21 c0 >
[  286.984040] saa7133[0]: i2c xfer: < c2 30 d0 >
[  286.992023] saa7133[0]: i2c xfer: < 96 21 80 >
[  287.024034] saa7133[0]: i2c xfer: < 96 21 80 >
[  287.056037] saa7133[0]: i2c xfer: < 10 3b ff >
[  287.064023] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D68 >
[  287.072027] saa7133[0]: i2c xfer: < 10 3d 68 >
[  287.080026] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3D38 >
[  287.088035] saa7133[0]: i2c xfer: < 10 37 f8 >
[  287.096030] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  287.104030] saa7133[0]: i2c xfer: < 10 07 81 >
[  358.200290] saa7133[0]: i2c xfer: < 10 07 80 >
[  358.208031] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  358.216031] saa7133[0]: i2c xfer: < 10 3b fe >
[  358.224027] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  358.224209] saa7133[0]: i2c xfer: < 10 3d ERROR: BUS_ERR
[  358.240080] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  358.240192] tda1004x: setting up plls for 48MHz sampling clock
[  358.240235] saa7133[0]: i2c xfer: < 10 2f ERROR: BUS_ERR
[  358.240518] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  358.240665] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  358.240845] saa7133[0]: i2c xfer: < 10 4d ERROR: BUS_ERR
[  358.241128] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  358.241276] saa7133[0]: i2c xfer: < 10 31 54 >
[  358.248028] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  358.248209] saa7133[0]: i2c xfer: < 10 4d 0d ERROR: BUS_ERR
[  358.248628] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  358.372081] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3Df8 >
[  358.380024] saa7133[0]: i2c xfer: < 10 37 38 >
[  358.388509] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  358.396027] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  358.404027] saa7133[0]: i2c xfer: < 10 07 80 >
[  358.412027] saa7133[0]: i2c xfer: < 10 11 67 >
[  358.420026] saa7133[0]: i2c xfer: < 10 13 [fe quirk] < 11 =3D67 >
[  358.428027] saa7133[0]: i2c xfer: < 10 14 [fe quirk] < 11 =3D23 >
[  358.436026] tda1004x: found firmware revision 23 -- ok
[  358.436033] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  358.444028] saa7133[0]: i2c xfer: < 10 07 80 >
[  358.452027] saa7133[0]: i2c xfer: < 10 01 87 >
[  358.460026] saa7133[0]: i2c xfer: < 10 16 88 >
[  358.468026] saa7133[0]: i2c xfer: < 10 43 02 >
[  358.476889] saa7133[0]: i2c xfer: < 10 44 70 >
[  358.484027] saa7133[0]: i2c xfer: < 10 45 08 >
[  358.492026] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D68 >
[  358.500028] saa7133[0]: i2c xfer: < 10 3d 68 >
[  358.508028] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  358.516026] saa7133[0]: i2c xfer: < 10 3b 7f >
[  358.524027] saa7133[0]: i2c xfer: < 10 3a [fe quirk] < 11 =3D00 >
[  358.532027] saa7133[0]: i2c xfer: < 10 3a 00 >
[  358.540026] saa7133[0]: i2c xfer: < 10 37 38 >
[  358.548026] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3D7f >
[  358.556026] saa7133[0]: i2c xfer: < 10 3b 79 >
[  358.565912] saa7133[0]: i2c xfer: < 10 47 00 >
[  358.572028] saa7133[0]: i2c xfer: < 10 48 ff >
[  358.580403] saa7133[0]: i2c xfer: < 10 49 00 >
[  358.588027] saa7133[0]: i2c xfer: < 10 4a ff >
[  358.596032] saa7133[0]: i2c xfer: < 10 46 12 >
[  358.604029] saa7133[0]: i2c xfer: < 10 4f 1a >
[  358.612028] saa7133[0]: i2c xfer: < 10 1e 07 >
[  358.620027] saa7133[0]: i2c xfer: < 10 1f c0 >
[  358.628027] saa7133[0]: i2c xfer: < 96 21 c0 >
[  358.660035] saa7133[0]: i2c xfer: < 96 21 80 >
[  358.692414] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D87 >
[  358.700024] saa7133[0]: i2c xfer: < 10 01 97 >
[  358.708027] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  358.716026] saa7133[0]: i2c xfer: < 10 02 10 >
[  358.724112] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  358.732026] saa7133[0]: i2c xfer: < 10 03 00 >
[  358.740026] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D02 >
[  358.748033] saa7133[0]: i2c xfer: < 10 43 02 >
[  358.756027] saa7133[0]: i2c xfer: < 96 21 c0 >
[  358.788023] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  358.796027] saa7133[0]: i2c xfer: < 96 21 80 >
[  359.332032] saa7133[0]: i2c xfer: < 96 21 c0 >
[  359.364613] saa7133[0]: i2c xfer: < c2 30 50 >
[  359.372029] saa7133[0]: i2c xfer: < 96 21 80 >
[  359.404027] saa7133[0]: i2c xfer: < 96 21 80 >
[  359.436023] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D97 >
[  359.444026] saa7133[0]: i2c xfer: < 10 01 97 >
[  359.452030] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  359.466367] saa7133[0]: i2c xfer: < 10 02 10 >
[  359.472027] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  359.480032] saa7133[0]: i2c xfer: < 10 02 10 >
[  359.488030] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  359.496027] saa7133[0]: i2c xfer: < 10 03 00 >
[  359.504029] saa7133[0]: i2c xfer: < 10 31 54 >
[  359.512027] saa7133[0]: i2c xfer: < 10 32 03 >
[  359.520049] saa7133[0]: i2c xfer: < 10 33 0c >
[  359.528029] saa7133[0]: i2c xfer: < 10 34 30 >
[  359.536027] saa7133[0]: i2c xfer: < 10 35 c3 >
[  359.544034] saa7133[0]: i2c xfer: < 10 4d 0d >
[  359.552032] saa7133[0]: i2c xfer: < 10 4e 55 >
[  359.560029] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3D88 >
[  359.568028] saa7133[0]: i2c xfer: < 10 16 88 >
[  359.576030] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D97 >
[  359.584028] saa7133[0]: i2c xfer: < 10 01 95 >
[  359.592282] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  359.600041] saa7133[0]: i2c xfer: < 10 02 10 >
[  359.608504] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D95 >
[  359.616262] saa7133[0]: i2c xfer: < 10 01 91 >
[  359.624192] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  359.632028] saa7133[0]: i2c xfer: < 10 02 10 >
[  359.640031] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  359.648029] saa7133[0]: i2c xfer: < 10 01 d1 >
[  359.664029] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D02 >
[  359.672029] saa7133[0]: i2c xfer: < 10 43 03 >
[  359.700463] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  359.708031] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  359.716031] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  359.724432] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  359.832139] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  359.840035] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  359.848031] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  359.856026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  359.964145] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  359.972026] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  359.980028] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  359.988980] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  360.096145] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  360.104867] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  360.112095] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  360.120027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  360.228141] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  360.236081] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  360.244168] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  360.252027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  360.360145] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  360.368032] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  360.376032] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  360.384026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  360.492135] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  360.500031] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  360.508030] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  360.516027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  360.524046] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  360.532027] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  360.540027] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  360.548032] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  360.556031] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  360.564027] saa7133[0]: i2c xfer: < 10 01 91 >
[  360.572028] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  360.580027] saa7133[0]: i2c xfer: < 10 02 10 >
[  360.588027] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  360.596028] saa7133[0]: i2c xfer: < 10 03 00 >
[  360.604027] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  360.612029] saa7133[0]: i2c xfer: < 10 43 03 >
[  360.620030] saa7133[0]: i2c xfer: < 96 21 c0 >
[  360.652044] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  360.660028] saa7133[0]: i2c xfer: < 96 21 80 >
[  361.196023] saa7133[0]: i2c xfer: < 96 21 c0 >
[  361.228024] saa7133[0]: i2c xfer: < c2 30 50 >
[  361.236743] saa7133[0]: i2c xfer: < 96 21 80 >
[  361.268031] saa7133[0]: i2c xfer: < 96 21 80 >
[  361.300029] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  361.308028] saa7133[0]: i2c xfer: < 10 01 91 >
[  361.316027] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  361.324027] saa7133[0]: i2c xfer: < 10 02 10 >
[  361.332029] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  361.340028] saa7133[0]: i2c xfer: < 10 02 10 >
[  361.348033] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  361.356941] saa7133[0]: i2c xfer: < 10 03 00 >
[  361.364036] saa7133[0]: i2c xfer: < 10 31 54 >
[  361.372034] saa7133[0]: i2c xfer: < 10 32 03 >
[  361.380056] saa7133[0]: i2c xfer: < 10 33 0c >
[  361.388029] saa7133[0]: i2c xfer: < 10 34 30 >
[  361.396027] saa7133[0]: i2c xfer: < 10 35 c3 >
[  361.404030] saa7133[0]: i2c xfer: < 10 4d 0d >
[  361.412029] saa7133[0]: i2c xfer: < 10 4e 55 >
[  361.420028] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3D88 >
[  361.428026] saa7133[0]: i2c xfer: < 10 16 a8 >
[  361.438072] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  361.444029] saa7133[0]: i2c xfer: < 10 01 91 >
[  361.452028] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  361.460031] saa7133[0]: i2c xfer: < 10 02 10 >
[  361.468028] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  361.476029] saa7133[0]: i2c xfer: < 10 01 91 >
[  361.484028] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  361.492027] saa7133[0]: i2c xfer: < 10 02 10 >
[  361.500028] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  361.508028] saa7133[0]: i2c xfer: < 10 01 d1 >
[  361.524030] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  361.532028] saa7133[0]: i2c xfer: < 10 43 03 >
[  361.556037] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  361.564024] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  361.572027] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  361.580026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  361.688148] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  361.696096] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  361.704081] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  361.712126] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  361.820141] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  361.828027] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  361.836031] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  361.844028] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  361.952215] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  361.960025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  361.968036] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  361.976092] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  362.084137] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  362.092028] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  362.100029] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  362.108028] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  362.216134] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  362.224026] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  362.232033] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  362.240031] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  362.348146] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  362.356023] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  362.364026] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  362.372023] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  362.380045] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  362.388022] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  362.396021] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  362.404020] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  362.412015] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  362.420013] saa7133[0]: i2c xfer: < 10 01 91 >
[  362.428011] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  362.436013] saa7133[0]: i2c xfer: < 10 02 10 >
[  362.444013] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  362.452014] saa7133[0]: i2c xfer: < 10 03 00 >
[  362.460015] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  362.469388] saa7133[0]: i2c xfer: < 10 43 03 >
[  362.476014] saa7133[0]: i2c xfer: < 96 21 c0 >
[  362.508014] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  362.516013] saa7133[0]: i2c xfer: < 96 21 80 >
[  363.052017] saa7133[0]: i2c xfer: < 96 21 c0 >
[  363.084013] saa7133[0]: i2c xfer: < c2 30 50 >
[  363.092014] saa7133[0]: i2c xfer: < 96 21 80 >
[  363.124073] saa7133[0]: i2c xfer: < 96 21 80 >
[  363.156014] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  363.164012] saa7133[0]: i2c xfer: < 10 01 91 >
[  363.172013] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  363.180016] saa7133[0]: i2c xfer: < 10 02 10 >
[  363.188024] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  363.196017] saa7133[0]: i2c xfer: < 10 02 10 >
[  363.204016] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  363.212016] saa7133[0]: i2c xfer: < 10 03 00 >
[  363.220019] saa7133[0]: i2c xfer: < 10 31 54 >
[  363.228016] saa7133[0]: i2c xfer: < 10 32 03 >
[  363.236016] saa7133[0]: i2c xfer: < 10 33 0c >
[  363.244017] saa7133[0]: i2c xfer: < 10 34 30 >
[  363.252016] saa7133[0]: i2c xfer: < 10 35 c3 >
[  363.260016] saa7133[0]: i2c xfer: < 10 4d 0d >
[  363.268017] saa7133[0]: i2c xfer: < 10 4e 55 >
[  363.276020] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3Da8 >
[  363.284028] saa7133[0]: i2c xfer: < 10 16 a8 >
[  363.292028] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  363.300026] saa7133[0]: i2c xfer: < 10 01 91 >
[  363.308028] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  363.316027] saa7133[0]: i2c xfer: < 10 02 10 >
[  363.324027] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  363.332026] saa7133[0]: i2c xfer: < 10 01 91 >
[  363.340027] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  363.348026] saa7133[0]: i2c xfer: < 10 02 10 >
[  363.356026] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  363.364161] saa7133[0]: i2c xfer: < 10 01 d1 >
[  363.380025] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  363.388027] saa7133[0]: i2c xfer: < 10 43 03 >
[  363.412039] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  363.420025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  363.428029] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  363.436027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  364.212035] saa7133[0]: i2c xfer: < 96 21 c0 >
[  364.244040] saa7133[0]: i2c xfer: < 96 21 c0 >
[  364.276028] saa7133[0]: i2c xfer: < c2 30 d0 >
[  364.284028] saa7133[0]: i2c xfer: < 96 21 80 >
[  364.316033] saa7133[0]: i2c xfer: < 96 21 80 >
[  364.348039] saa7133[0]: i2c xfer: < 10 3b ff >
[  364.356023] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D68 >
[  364.365204] saa7133[0]: i2c xfer: < 10 3d 68 >
[  364.372026] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3D38 >
[  364.380028] saa7133[0]: i2c xfer: < 10 37 f8 >
[  364.388024] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  364.396036] saa7133[0]: i2c xfer: < 10 07 81 >
[  416.283495] saa7133[0]: i2c xfer: < 10 07 80 >
[  416.288029] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  416.296047] saa7133[0]: i2c xfer: < 10 3b fe >
[  416.304029] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  416.304211] saa7133[0]: i2c xfer: < 10 3d ERROR: BUS_ERR
[  416.320079] saa7133[0]: i2c xfer: < 10 2d ERROR: BUS_ERR
[  416.320395] tda1004x: setting up plls for 48MHz sampling clock
[  416.320437] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  416.320552] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  416.320699] saa7133[0]: i2c xfer: < 10 ERROR: ARB_LOST
[  416.320912] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  416.321026] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  416.321207] saa7133[0]: i2c xfer: < 10 31 54 >
[  416.329151] saa7133[0]: i2c xfer: < 10 ERROR: ARB_LOST
[  416.329335] saa7133[0]: i2c xfer: < 10 4d 0d ERROR: BUS_ERR
[  416.329721] saa7133[0]: i2c xfer: < 10 4e ERROR: BUS_ERR
[  416.452074] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3Df8 >
[  416.460031] saa7133[0]: i2c xfer: < 10 37 38 >
[  416.468043] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  416.476031] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  416.484030] saa7133[0]: i2c xfer: < 10 07 80 >
[  416.492036] saa7133[0]: i2c xfer: < 10 11 67 >
[  416.500029] saa7133[0]: i2c xfer: < 10 13 [fe quirk] < 11 =3D67 >
[  416.508029] saa7133[0]: i2c xfer: < 10 14 [fe quirk] < 11 =3D23 >
[  416.516034] tda1004x: found firmware revision 23 -- ok
[  416.516044] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  416.524038] saa7133[0]: i2c xfer: < 10 07 80 >
[  416.532030] saa7133[0]: i2c xfer: < 10 01 87 >
[  416.540032] saa7133[0]: i2c xfer: < 10 16 88 >
[  416.548029] saa7133[0]: i2c xfer: < 10 43 02 >
[  416.556031] saa7133[0]: i2c xfer: < 10 44 70 >
[  416.564035] saa7133[0]: i2c xfer: < 10 45 08 >
[  416.572029] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D68 >
[  416.580030] saa7133[0]: i2c xfer: < 10 3d 68 >
[  416.588033] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  416.596031] saa7133[0]: i2c xfer: < 10 3b 7f >
[  416.604030] saa7133[0]: i2c xfer: < 10 3a [fe quirk] < 11 =3D00 >
[  416.612035] saa7133[0]: i2c xfer: < 10 3a 00 >
[  416.620028] saa7133[0]: i2c xfer: < 10 37 38 >
[  416.628032] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3D7f >
[  416.636033] saa7133[0]: i2c xfer: < 10 3b 79 >
[  416.645775] saa7133[0]: i2c xfer: < 10 47 00 >
[  416.652029] saa7133[0]: i2c xfer: < 10 48 ff >
[  416.662070] saa7133[0]: i2c xfer: < 10 49 00 >
[  416.668034] saa7133[0]: i2c xfer: < 10 4a ff >
[  416.676037] saa7133[0]: i2c xfer: < 10 46 12 >
[  416.684035] saa7133[0]: i2c xfer: < 10 4f 1a >
[  416.692029] saa7133[0]: i2c xfer: < 10 1e 07 >
[  416.700032] saa7133[0]: i2c xfer: < 10 1f c0 >
[  416.708030] saa7133[0]: i2c xfer: < 96 21 c0 >
[  416.740037] saa7133[0]: i2c xfer: < 96 21 80 >
[  416.773376] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D87 >
[  416.780030] saa7133[0]: i2c xfer: < 10 01 97 >
[  416.788030] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  416.796031] saa7133[0]: i2c xfer: < 10 02 10 >
[  416.804040] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  416.812030] saa7133[0]: i2c xfer: < 10 03 00 >
[  416.821717] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D02 >
[  416.828032] saa7133[0]: i2c xfer: < 10 43 02 >
[  416.836029] saa7133[0]: i2c xfer: < 96 21 c0 >
[  416.868029] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  416.876032] saa7133[0]: i2c xfer: < 96 21 80 >
[  417.412034] saa7133[0]: i2c xfer: < 96 21 c0 >
[  417.444034] saa7133[0]: i2c xfer: < c2 30 50 >
[  417.452024] saa7133[0]: i2c xfer: < 96 21 80 >
[  417.484032] saa7133[0]: i2c xfer: < 96 21 80 >
[  417.516035] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D97 >
[  417.524625] saa7133[0]: i2c xfer: < 10 01 97 >
[  417.532037] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  417.540028] saa7133[0]: i2c xfer: < 10 02 10 >
[  417.548029] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  417.556031] saa7133[0]: i2c xfer: < 10 02 10 >
[  417.564027] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  417.572030] saa7133[0]: i2c xfer: < 10 03 00 >
[  417.580028] saa7133[0]: i2c xfer: < 10 31 54 >
[  417.588028] saa7133[0]: i2c xfer: < 10 32 03 >
[  417.596029] saa7133[0]: i2c xfer: < 10 33 0c >
[  417.604028] saa7133[0]: i2c xfer: < 10 34 30 >
[  417.612128] saa7133[0]: i2c xfer: < 10 35 c3 >
[  417.620034] saa7133[0]: i2c xfer: < 10 4d 0d >
[  417.628028] saa7133[0]: i2c xfer: < 10 4e 55 >
[  417.636028] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3D88 >
[  417.644028] saa7133[0]: i2c xfer: < 10 16 a8 >
[  417.652031] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D97 >
[  417.660029] saa7133[0]: i2c xfer: < 10 01 95 >
[  417.668030] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  417.676030] saa7133[0]: i2c xfer: < 10 02 10 >
[  417.684029] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D95 >
[  417.692028] saa7133[0]: i2c xfer: < 10 01 91 >
[  417.700029] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  417.708033] saa7133[0]: i2c xfer: < 10 02 10 >
[  417.716031] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  417.724027] saa7133[0]: i2c xfer: < 10 01 d1 >
[  417.740028] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D02 >
[  417.748028] saa7133[0]: i2c xfer: < 10 43 03 >
[  417.772044] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  417.780032] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  417.788029] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  417.796039] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  417.904139] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  417.912026] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  417.920039] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  417.928028] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  418.036136] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  418.044037] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  418.052029] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  418.060038] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  418.168156] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  418.176032] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  418.184033] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  418.192034] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  418.300321] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  418.308037] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  418.318807] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  418.324399] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  418.432163] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  418.440036] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  418.448037] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  418.456042] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  418.564199] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  418.572030] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  418.580026] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  418.588034] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  418.596398] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  418.604179] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  418.612428] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  418.620288] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  418.628237] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  418.636170] saa7133[0]: i2c xfer: < 10 01 91 >
[  418.644256] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  418.652395] saa7133[0]: i2c xfer: < 10 02 10 >
[  418.660120] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  418.668035] saa7133[0]: i2c xfer: < 10 03 00 >
[  418.676899] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  418.684247] saa7133[0]: i2c xfer: < 10 43 03 >
[  418.692280] saa7133[0]: i2c xfer: < 96 21 c0 >
[  418.724201] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  418.732178] saa7133[0]: i2c xfer: < 96 21 80 >
[  419.268031] saa7133[0]: i2c xfer: < 96 21 c0 >
[  419.300032] saa7133[0]: i2c xfer: < c2 30 50 >
[  419.308026] saa7133[0]: i2c xfer: < 96 21 80 >
[  419.340041] saa7133[0]: i2c xfer: < 96 21 80 >
[  419.372031] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  419.392031] saa7133[0]: i2c xfer: < 10 01 91 >
[  419.400022] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  419.408027] saa7133[0]: i2c xfer: < 10 02 10 >
[  419.416022] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  419.424022] saa7133[0]: i2c xfer: < 10 02 10 >
[  419.432023] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  419.440034] saa7133[0]: i2c xfer: < 10 03 00 >
[  419.448024] saa7133[0]: i2c xfer: < 10 31 54 >
[  419.456021] saa7133[0]: i2c xfer: < 10 32 03 >
[  419.464021] saa7133[0]: i2c xfer: < 10 33 0c >
[  419.472027] saa7133[0]: i2c xfer: < 10 34 30 >
[  419.480024] saa7133[0]: i2c xfer: < 10 35 c3 >
[  419.488036] saa7133[0]: i2c xfer: < 10 4d 0d >
[  419.496022] saa7133[0]: i2c xfer: < 10 4e 55 >
[  419.504024] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3Da8 >
[  419.512021] saa7133[0]: i2c xfer: < 10 16 88 >
[  419.520025] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  419.528016] saa7133[0]: i2c xfer: < 10 01 91 >
[  419.536022] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  419.544020] saa7133[0]: i2c xfer: < 10 02 10 >
[  419.552014] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  419.560015] saa7133[0]: i2c xfer: < 10 01 91 >
[  419.568015] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  419.576086] saa7133[0]: i2c xfer: < 10 02 10 >
[  419.584015] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  419.592205] saa7133[0]: i2c xfer: < 10 01 d1 >
[  419.608383] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  419.616014] saa7133[0]: i2c xfer: < 10 43 03 >
[  419.640033] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  419.649355] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  419.656095] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  419.665096] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  419.772115] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  419.780016] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  419.795245] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  419.804023] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  419.912120] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  419.920020] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  419.928017] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  419.936996] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  420.044116] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  420.052022] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  420.060022] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  420.068014] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  420.177154] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  420.184020] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  420.192024] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  420.200022] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  420.308117] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  420.316021] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  420.324023] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  420.332024] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  420.440027] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  420.448018] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  420.456016] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  420.464016] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  420.472018] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  420.480020] saa7133[0]: i2c xfer: < 10 01 91 >
[  420.488016] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  420.496021] saa7133[0]: i2c xfer: < 10 02 10 >
[  420.504020] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  420.512023] saa7133[0]: i2c xfer: < 10 03 00 >
[  420.520021] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  420.528029] saa7133[0]: i2c xfer: < 10 43 03 >
[  420.536032] saa7133[0]: i2c xfer: < 96 21 c0 >
[  420.568051] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  420.576026] saa7133[0]: i2c xfer: < 96 21 80 >
[  421.112611] saa7133[0]: i2c xfer: < 96 21 c0 >
[  421.144031] saa7133[0]: i2c xfer: < c2 30 50 >
[  421.152035] saa7133[0]: i2c xfer: < 96 21 80 >
[  421.184036] saa7133[0]: i2c xfer: < 96 21 80 >
[  421.216038] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  421.224024] saa7133[0]: i2c xfer: < 10 01 91 >
[  421.232031] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  421.240030] saa7133[0]: i2c xfer: < 10 02 10 >
[  421.248028] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  421.256029] saa7133[0]: i2c xfer: < 10 02 10 >
[  421.264030] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  421.272043] saa7133[0]: i2c xfer: < 10 03 00 >
[  421.280043] saa7133[0]: i2c xfer: < 10 31 54 >
[  421.289329] saa7133[0]: i2c xfer: < 10 32 03 >
[  421.296035] saa7133[0]: i2c xfer: < 10 33 0c >
[  421.304043] saa7133[0]: i2c xfer: < 10 34 30 >
[  421.312029] saa7133[0]: i2c xfer: < 10 35 c3 >
[  421.320028] saa7133[0]: i2c xfer: < 10 4d 0d >
[  421.328037] saa7133[0]: i2c xfer: < 10 4e 55 >
[  421.336036] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3D88 >
[  421.344029] saa7133[0]: i2c xfer: < 10 16 88 >
[  421.352030] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  421.360040] saa7133[0]: i2c xfer: < 10 01 91 >
[  421.368039] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  421.377415] saa7133[0]: i2c xfer: < 10 02 10 >
[  421.384037] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  421.392027] saa7133[0]: i2c xfer: < 10 01 91 >
[  421.400035] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  421.408038] saa7133[0]: i2c xfer: < 10 02 10 >
[  421.416032] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  421.424037] saa7133[0]: i2c xfer: < 10 01 d1 >
[  421.440031] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  421.448035] saa7133[0]: i2c xfer: < 10 43 03 >
[  421.472043] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  421.480037] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  421.488376] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  421.496719] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  421.604146] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  421.612028] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  421.620039] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  421.628032] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  422.272024] saa7133[0]: i2c xfer: < 96 21 c0 >
[  422.304025] saa7133[0]: i2c xfer: < 96 21 c0 >
[  422.336023] saa7133[0]: i2c xfer: < c2 30 d0 >
[  422.350781] saa7133[0]: i2c xfer: < 96 21 80 >
[  422.380032] saa7133[0]: i2c xfer: < 96 21 80 >
[  422.420025] saa7133[0]: i2c xfer: < 10 3b ff >
[  422.428029] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D68 >
[  422.436027] saa7133[0]: i2c xfer: < 10 3d 68 >
[  422.444020] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3D38 >
[  422.452031] saa7133[0]: i2c xfer: < 10 37 f8 >
[  422.460031] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  422.468021] saa7133[0]: i2c xfer: < 10 07 81 >

[   12.560083] saa7133[0]: i2c xfer: < a0 00 >
[   12.570770] saa7133[0]: i2c xfer: < a1 =3D68 =3D51 =3D07 =3D03 =3D54 =3D=
20 =3D1c =3D00 =3D43 =3D43 =3Da9 =3D1c =3D55 =3Dd2 =3Db2 =3D92 =3D00 =3D0=
0 =3D62 =3D08 =3Dff =3D20 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff=
 =3Dff =3Dff =3D01 =3D40 =3D01 =3D03 =3D03 =3D01 =3D01 =3D03 =3D08 =3Dff =
=3D01 =3De7 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D=
ff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D24 =3D0=
0 =3Dc2 =3D96 =3D10 =3D05 =3D01 =3D01 =3D16 =3D22 =3D15 =3Dff =3Dff =3Dff=
 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =
=3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D=
ff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Df=
f =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff=
 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =
=3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D=
ff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Df=
f =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff=
 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =
=3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D=
ff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Df=
f =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff=
 =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =
=3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3Dff =3D=
ff =3Dff =3Dff =3Dff =3Dff =3Dff >
[   12.623109] saa7133[0]: i2c eeprom 00: 68 51 07 03 54 20 1c 00 43 43 a=
9 1c 55 d2 b2 92
[   12.623120] saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff f=
f ff ff ff ff ff
[   12.623129] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 0=
1 e7 ff ff ff ff
[   12.623139] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623149] saa7133[0]: i2c eeprom 40: ff 24 00 c2 96 10 05 01 01 16 2=
2 15 ff ff ff ff
[   12.623158] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623168] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623177] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623187] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623196] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623206] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623216] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623225] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623235] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623244] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623254] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff f=
f ff ff ff ff ff
[   12.623265] saa7133[0]: i2c xfer: < 01 ERROR: NO_DEVICE
[   12.623442] saa7133[0]: i2c xfer: < 03 ERROR: NO_DEVICE
[   12.623618] saa7133[0]: i2c xfer: < 05 ERROR: NO_DEVICE
[   12.623794] saa7133[0]: i2c xfer: < 07 ERROR: NO_DEVICE
[   12.623970] saa7133[0]: i2c xfer: < 09 ERROR: NO_DEVICE
[   12.624156] saa7133[0]: i2c xfer: < 0b ERROR: NO_DEVICE
[   12.624336] saa7133[0]: i2c xfer: < 0d ERROR: NO_DEVICE
[   12.624512] saa7133[0]: i2c xfer: < 0f ERROR: NO_DEVICE
[   12.624688] saa7133[0]: i2c xfer: < 11 >
[   12.640223] saa7133[0]: i2c scan: found device @ 0x10  [???]
[   12.640227] saa7133[0]: i2c xfer: < 13 ERROR: NO_DEVICE
[   12.640404] saa7133[0]: i2c xfer: < 15 ERROR: NO_DEVICE
[   12.640580] saa7133[0]: i2c xfer: < 17 ERROR: NO_DEVICE
[   12.640756] saa7133[0]: i2c xfer: < 19 ERROR: NO_DEVICE
[   12.640932] saa7133[0]: i2c xfer: < 1b ERROR: NO_DEVICE
[   12.641107] saa7133[0]: i2c xfer: < 1d ERROR: NO_DEVICE
[   12.641283] saa7133[0]: i2c xfer: < 1f ERROR: NO_DEVICE
[   12.641459] saa7133[0]: i2c xfer: < 21 ERROR: NO_DEVICE
[   12.641635] saa7133[0]: i2c xfer: < 23 ERROR: NO_DEVICE
[   12.641810] saa7133[0]: i2c xfer: < 25 ERROR: NO_DEVICE
[   12.641986] saa7133[0]: i2c xfer: < 27 ERROR: NO_DEVICE
[   12.642162] saa7133[0]: i2c xfer: < 29 ERROR: NO_DEVICE
[   12.642337] saa7133[0]: i2c xfer: < 2b ERROR: NO_DEVICE
[   12.642513] saa7133[0]: i2c xfer: < 2d ERROR: NO_DEVICE
[   12.642689] saa7133[0]: i2c xfer: < 2f ERROR: NO_DEVICE
[   12.642864] saa7133[0]: i2c xfer: < 31 ERROR: NO_DEVICE
[   12.643040] saa7133[0]: i2c xfer: < 33 ERROR: NO_DEVICE
[   12.643216] saa7133[0]: i2c xfer: < 35 ERROR: NO_DEVICE
[   12.643392] saa7133[0]: i2c xfer: < 37 ERROR: NO_DEVICE
[   12.643567] saa7133[0]: i2c xfer: < 39 ERROR: NO_DEVICE
[   12.643743] saa7133[0]: i2c xfer: < 3b ERROR: NO_DEVICE
[   12.643919] saa7133[0]: i2c xfer: < 3d ERROR: NO_DEVICE
[   12.644097] saa7133[0]: i2c xfer: < 3f ERROR: NO_DEVICE
[   12.644273] saa7133[0]: i2c xfer: < 41 ERROR: NO_DEVICE
[   12.644449] saa7133[0]: i2c xfer: < 43 ERROR: NO_DEVICE
[   12.644624] saa7133[0]: i2c xfer: < 45 ERROR: NO_DEVICE
[   12.644800] saa7133[0]: i2c xfer: < 47 ERROR: NO_DEVICE
[   12.644976] saa7133[0]: i2c xfer: < 49 ERROR: NO_DEVICE
[   12.645151] saa7133[0]: i2c xfer: < 4b ERROR: NO_DEVICE
[   12.645327] saa7133[0]: i2c xfer: < 4d ERROR: NO_DEVICE
[   12.645503] saa7133[0]: i2c xfer: < 4f ERROR: NO_DEVICE
[   12.645679] saa7133[0]: i2c xfer: < 51 ERROR: NO_DEVICE
[   12.645854] saa7133[0]: i2c xfer: < 53 ERROR: NO_DEVICE
[   12.646030] saa7133[0]: i2c xfer: < 55 ERROR: NO_DEVICE
[   12.646206] saa7133[0]: i2c xfer: < 57 ERROR: NO_DEVICE
[   12.646382] saa7133[0]: i2c xfer: < 59 ERROR: NO_DEVICE
[   12.646557] saa7133[0]: i2c xfer: < 5b ERROR: NO_DEVICE
[   12.646733] saa7133[0]: i2c xfer: < 5d ERROR: NO_DEVICE
[   12.646909] saa7133[0]: i2c xfer: < 5f ERROR: NO_DEVICE
[   12.647084] saa7133[0]: i2c xfer: < 61 ERROR: NO_DEVICE
[   12.647260] saa7133[0]: i2c xfer: < 63 ERROR: NO_DEVICE
[   12.647436] saa7133[0]: i2c xfer: < 65 ERROR: NO_DEVICE
[   12.647612] saa7133[0]: i2c xfer: < 67 ERROR: NO_DEVICE
[   12.647827] saa7133[0]: i2c xfer: < 69 ERROR: NO_DEVICE
[   12.648017] saa7133[0]: i2c xfer: < 6b ERROR: NO_DEVICE
[   12.648193] saa7133[0]: i2c xfer: < 6d ERROR: NO_DEVICE
[   12.648368] saa7133[0]: i2c xfer: < 6f ERROR: NO_DEVICE
[   12.648544] saa7133[0]: i2c xfer: < 71 ERROR: NO_DEVICE
[   12.648720] saa7133[0]: i2c xfer: < 73 ERROR: NO_DEVICE
[   12.648896] saa7133[0]: i2c xfer: < 75 ERROR: NO_DEVICE
[   12.649071] saa7133[0]: i2c xfer: < 77 ERROR: NO_DEVICE
[   12.649247] saa7133[0]: i2c xfer: < 79 ERROR: NO_DEVICE
[   12.649423] saa7133[0]: i2c xfer: < 7b ERROR: NO_DEVICE
[   12.649599] saa7133[0]: i2c xfer: < 7d ERROR: NO_DEVICE
[   12.649774] saa7133[0]: i2c xfer: < 7f ERROR: NO_DEVICE
[   12.649950] saa7133[0]: i2c xfer: < 81 ERROR: NO_DEVICE
[   12.650126] saa7133[0]: i2c xfer: < 83 ERROR: NO_DEVICE
[   12.650301] saa7133[0]: i2c xfer: < 85 ERROR: NO_DEVICE
[   12.650477] saa7133[0]: i2c xfer: < 87 ERROR: NO_DEVICE
[   12.650653] saa7133[0]: i2c xfer: < 89 ERROR: NO_DEVICE
[   12.650829] saa7133[0]: i2c xfer: < 8b ERROR: NO_DEVICE
[   12.651004] saa7133[0]: i2c xfer: < 8d ERROR: NO_DEVICE
[   12.651180] saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
[   12.651356] saa7133[0]: i2c xfer: < 91 ERROR: NO_DEVICE
[   12.651532] saa7133[0]: i2c xfer: < 93 ERROR: NO_DEVICE
[   12.651707] saa7133[0]: i2c xfer: < 95 ERROR: NO_DEVICE
[   12.651883] saa7133[0]: i2c xfer: < 97 >
[   12.664525] saa7133[0]: i2c scan: found device @ 0x96  [???]
[   12.664530] saa7133[0]: i2c xfer: < 99 ERROR: NO_DEVICE
[   12.664707] saa7133[0]: i2c xfer: < 9b ERROR: NO_DEVICE
[   12.664883] saa7133[0]: i2c xfer: < 9d ERROR: NO_DEVICE
[   12.665059] saa7133[0]: i2c xfer: < 9f ERROR: NO_DEVICE
[   12.665234] saa7133[0]: i2c xfer: < a1 >
[   12.672025] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
[   12.672029] saa7133[0]: i2c xfer: < a3 ERROR: NO_DEVICE
[   12.672206] saa7133[0]: i2c xfer: < a5 ERROR: NO_DEVICE
[   12.672382] saa7133[0]: i2c xfer: < a7 ERROR: NO_DEVICE
[   12.672558] saa7133[0]: i2c xfer: < a9 ERROR: NO_DEVICE
[   12.672734] saa7133[0]: i2c xfer: < ab ERROR: NO_DEVICE
[   12.672910] saa7133[0]: i2c xfer: < ad ERROR: NO_DEVICE
[   12.673085] saa7133[0]: i2c xfer: < af ERROR: NO_DEVICE
[   12.673261] saa7133[0]: i2c xfer: < b1 ERROR: NO_DEVICE
[   12.673437] saa7133[0]: i2c xfer: < b3 ERROR: NO_DEVICE
[   12.673612] saa7133[0]: i2c xfer: < b5 ERROR: NO_DEVICE
[   12.673788] saa7133[0]: i2c xfer: < b7 ERROR: NO_DEVICE
[   12.673964] saa7133[0]: i2c xfer: < b9 ERROR: NO_DEVICE
[   12.674140] saa7133[0]: i2c xfer: < bb ERROR: NO_DEVICE
[   12.674315] saa7133[0]: i2c xfer: < bd ERROR: NO_DEVICE
[   12.674491] saa7133[0]: i2c xfer: < bf ERROR: NO_DEVICE
[   12.674667] saa7133[0]: i2c xfer: < c1 ERROR: NO_DEVICE
[   12.674843] saa7133[0]: i2c xfer: < c3 ERROR: NO_DEVICE
[   12.675018] saa7133[0]: i2c xfer: < c5 ERROR: NO_DEVICE
[   12.675194] saa7133[0]: i2c xfer: < c7 ERROR: NO_DEVICE
[   12.675370] saa7133[0]: i2c xfer: < c9 ERROR: NO_DEVICE
[   12.675546] saa7133[0]: i2c xfer: < cb ERROR: NO_DEVICE
[   12.675721] saa7133[0]: i2c xfer: < cd ERROR: NO_DEVICE
[   12.675897] saa7133[0]: i2c xfer: < cf ERROR: NO_DEVICE
[   12.676080] saa7133[0]: i2c xfer: < d1 ERROR: NO_DEVICE
[   12.676256] saa7133[0]: i2c xfer: < d3 ERROR: NO_DEVICE
[   12.676432] saa7133[0]: i2c xfer: < d5 ERROR: NO_DEVICE
[   12.676607] saa7133[0]: i2c xfer: < d7 ERROR: NO_DEVICE
[   12.676783] saa7133[0]: i2c xfer: < d9 ERROR: NO_DEVICE
[   12.676959] saa7133[0]: i2c xfer: < db ERROR: NO_DEVICE
[   12.677135] saa7133[0]: i2c xfer: < dd ERROR: NO_DEVICE
[   12.677310] saa7133[0]: i2c xfer: < df ERROR: NO_DEVICE
[   12.677486] saa7133[0]: i2c xfer: < e1 ERROR: NO_DEVICE
[   12.677662] saa7133[0]: i2c xfer: < e3 ERROR: NO_DEVICE
[   12.677838] saa7133[0]: i2c xfer: < e5 ERROR: NO_DEVICE
[   12.678013] saa7133[0]: i2c xfer: < e7 ERROR: NO_DEVICE
[   12.678189] saa7133[0]: i2c xfer: < e9 ERROR: NO_DEVICE
[   12.678553] saa7133[0]: i2c xfer: < eb ERROR: NO_DEVICE
[   12.678729] saa7133[0]: i2c xfer: < ed ERROR: NO_DEVICE
[   12.678905] saa7133[0]: i2c xfer: < ef ERROR: NO_DEVICE
[   12.679081] saa7133[0]: i2c xfer: < f1 ERROR: NO_DEVICE
[   12.679257] saa7133[0]: i2c xfer: < f3 ERROR: NO_DEVICE
[   12.679433] saa7133[0]: i2c xfer: < f5 ERROR: NO_DEVICE
[   12.679608] saa7133[0]: i2c xfer: < f7 ERROR: NO_DEVICE
[   12.679784] saa7133[0]: i2c xfer: < f9 ERROR: NO_DEVICE
[   12.679960] saa7133[0]: i2c xfer: < fb ERROR: NO_DEVICE
[   12.680160] saa7133[0]: i2c xfer: < fd ERROR: NO_DEVICE
[   12.680336] saa7133[0]: i2c xfer: < ff ERROR: NO_DEVICE
[   12.680512] saa7133[0]: i2c xfer: < 10 3c 33 60 >
[   12.749104] saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
[   12.749283] saa7133[0]: i2c xfer: < 86 ERROR: NO_DEVICE
[   12.749460] saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
[   12.749635] saa7133[0]: i2c xfer: < 96 >
[   12.843493] saa7133[0]: i2c xfer: < 96 00 >
[   12.848019] saa7133[0]: i2c xfer: < 97 =3D01 =3D01 =3D00 =3D11 =3D01 =3D=
04 =3D01 =3D85 >
[   12.856019] saa7133[0]: i2c xfer: < 96 1f >
[   12.864039] saa7133[0]: i2c xfer: < 97 =3D89 >
[   12.872241] saa7133[0]: i2c xfer: < 96 1f >
[   12.880019] saa7133[0]: i2c xfer: < 97 =3D89 >
[   12.888016] saa7133[0]: i2c xfer: < 96 2f >
[   12.896018] saa7133[0]: i2c xfer: < 97 =3D00 >
[   12.904018] saa7133[0]: i2c xfer: < 96 21 c0 >
[   12.936018] saa7133[0]: i2c xfer: < c1 ERROR: NO_DEVICE
[   12.936195] saa7133[0]: i2c xfer: < c3 =3D02 >
[   12.944018] saa7133[0]: i2c xfer: < c5 ERROR: NO_DEVICE
[   12.944194] saa7133[0]: i2c xfer: < c7 ERROR: NO_DEVICE
[   12.944370] saa7133[0]: i2c xfer: < 96 21 00 >
[   12.952021] saa7133[0]: i2c xfer: < 96 21 c0 >
[   12.984018] saa7133[0]: i2c xfer: < c3 =3D02 >
[   13.000699] saa7133[0]: i2c xfer: < c3 =3D02 >
[   13.008017] saa7133[0]: i2c xfer: < c2 30 d0 >
[   13.016016] saa7133[0]: i2c xfer: < 96 21 00 >
[   13.024021] saa7133[0]: i2c xfer: < 96 21 c0 >
[   13.056015] saa7133[0]: i2c xfer: < c2 00 00 00 40 dc 04 af 3f 2a 04 f=
f 00 00 40 >
[   13.064015] saa7133[0]: i2c xfer: < 96 21 00 >
[   13.072015] saa7133[0]: i2c xfer: < 96 20 0b >
[   13.080015] saa7133[0]: i2c xfer: < 96 30 6f >
[   13.088018] saa7133[0]: i2c xfer: < 96 01 00 >
[   13.096015] saa7133[0]: i2c xfer: < 96 02 00 >
[   13.104015] saa7133[0]: i2c xfer: < 96 00 00 >
[   13.120015] saa7133[0]: i2c xfer: < 96 01 90 >
[   13.128016] saa7133[0]: i2c xfer: < 96 28 14 >
[   13.136015] saa7133[0]: i2c xfer: < 96 0f 88 >
[   13.144015] saa7133[0]: i2c xfer: < 96 05 04 >
[   13.152015] saa7133[0]: i2c xfer: < 96 0d 47 >
[   13.160015] saa7133[0]: i2c xfer: < 96 21 c0 >
[   13.192015] saa7133[0]: i2c xfer: < c2 00 32 f8 40 52 5b 9f 8f >
[   13.200015] saa7133[0]: i2c xfer: < c2 80 00 >
[   13.208016] saa7133[0]: i2c xfer: < c2 60 bf >
[   13.216015] saa7133[0]: i2c xfer: < c2 30 d2 ><6>input: SynPS/2 Synapt=
ics TouchPad as /devices/platform/i8042/serio1/input/input10
[   13.232022] saa7133[0]: i2c xfer: < c2 30 56 >
[   13.248016] saa7133[0]: i2c xfer: < c2 30 52 >
[   13.812019] saa7133[0]: i2c xfer: < c2 30 50 >
[   13.820015] saa7133[0]: i2c xfer: < c2 60 3f >
[   13.828018] saa7133[0]: i2c xfer: < c2 80 08 >
[   13.836018] saa7133[0]: i2c xfer: < 96 1b >
[   13.844017] saa7133[0]: i2c xfer: < 97 =3D4d >
[   13.956018] saa7133[0]: i2c xfer: < 96 1b >
[   13.964017] saa7133[0]: i2c xfer: < 97 =3D45 >
[   14.076018] saa7133[0]: i2c xfer: < 96 1b >
[   14.084017] saa7133[0]: i2c xfer: < 97 =3D3c >
[   14.196019] saa7133[0]: i2c xfer: < 96 28 64 >
[   14.308018] saa7133[0]: i2c xfer: < 96 1d >
[   14.316017] saa7133[0]: i2c xfer: < 97 =3Dff >
[   14.324017] saa7133[0]: i2c xfer: < 96 1b >
[   14.332019] saa7133[0]: i2c xfer: < 97 =3D30 >
[   14.340018] saa7133[0]: i2c xfer: < c2 80 0c >
[   14.452019] saa7133[0]: i2c xfer: < 96 1d >
[   14.460018] saa7133[0]: i2c xfer: < 97 =3Dcf >
[   14.468015] saa7133[0]: i2c xfer: < 96 1b >
[   14.476018] saa7133[0]: i2c xfer: < 97 =3D2f >
[   14.484017] saa7133[0]: i2c xfer: < 96 05 01 >
[   14.492019] saa7133[0]: i2c xfer: < 96 0d 27 >
[   14.604017] saa7133[0]: i2c xfer: < 96 21 00 >
[   14.612019] saa7133[0]: i2c xfer: < 96 0f 81 >
[   14.620023] saa7133[0]: i2c xfer: < 96 01 10 >
[   14.628018] saa7133[0]: i2c xfer: < 96 02 00 >
[   14.636018] saa7133[0]: i2c xfer: < 96 00 00 >
[   14.652018] saa7133[0]: i2c xfer: < 96 01 82 >
[   14.660018] saa7133[0]: i2c xfer: < 96 28 14 >
[   14.668015] saa7133[0]: i2c xfer: < 96 0f 88 >
[   14.676018] saa7133[0]: i2c xfer: < 96 05 04 >
[   14.684017] saa7133[0]: i2c xfer: < 96 0d 47 >
[   14.692019] saa7133[0]: i2c xfer: < 96 21 c0 >
[   14.724017] saa7133[0]: i2c xfer: < c2 00 32 d8 40 52 5b 9f 8f >
[   14.732019] saa7133[0]: i2c xfer: < c2 80 00 >
[   14.740018] saa7133[0]: i2c xfer: < c2 60 bf >
[   14.748018] saa7133[0]: i2c xfer: < c2 30 d2 >
[   14.764016] saa7133[0]: i2c xfer: < c2 30 56 >
[   14.780017] saa7133[0]: i2c xfer: < c2 30 52 >
[   15.344019] saa7133[0]: i2c xfer: < c2 30 50 >
[   15.352025] saa7133[0]: i2c xfer: < c2 60 3f >
[   15.360018] saa7133[0]: i2c xfer: < c2 80 08 >
[   15.368016] saa7133[0]: i2c xfer: < 96 1b >
[   15.376018] saa7133[0]: i2c xfer: < 97 =3D4d >
[   15.488016] saa7133[0]: i2c xfer: < 96 1b >
[   15.496018] saa7133[0]: i2c xfer: < 97 =3D45 >
[   15.608016] saa7133[0]: i2c xfer: < 96 1b >
[   15.616017] saa7133[0]: i2c xfer: < 97 =3D3d >
[   15.728016] saa7133[0]: i2c xfer: < 96 28 64 >
[   15.840018] saa7133[0]: i2c xfer: < 96 1d >
[   15.848016] saa7133[0]: i2c xfer: < 97 =3Dff >
[   15.856018] saa7133[0]: i2c xfer: < 96 1b >
[   15.864018] saa7133[0]: i2c xfer: < 97 =3D37 >
[   15.872015] saa7133[0]: i2c xfer: < c2 80 0c >
[   15.984018] saa7133[0]: i2c xfer: < 96 1d >
[   15.992018] saa7133[0]: i2c xfer: < 97 =3Dcf >
[   16.000018] saa7133[0]: i2c xfer: < 96 1b >
[   16.008016] saa7133[0]: i2c xfer: < 97 =3D0d >
[   16.016017] saa7133[0]: i2c xfer: < 96 05 01 >
[   16.024024] saa7133[0]: i2c xfer: < 96 0d 27 >
[   16.136019] saa7133[0]: i2c xfer: < 96 21 00 >
[   16.144018] saa7133[0]: i2c xfer: < 96 0f 81 >
[   16.152024] saa7133[0]: i2c xfer: < 96 01 02 >
[   16.160018] saa7133[0]: i2c xfer: < 96 02 00 >
[   16.168016] saa7133[0]: i2c xfer: < 96 00 00 >
[   16.184017] saa7133[0]: i2c xfer: < 96 01 82 >
[   16.192018] saa7133[0]: i2c xfer: < 96 28 14 >
[   16.200018] saa7133[0]: i2c xfer: < 96 0f 88 >
[   16.208016] saa7133[0]: i2c xfer: < 96 05 04 >
[   16.216017] saa7133[0]: i2c xfer: < 96 0d 47 >
[   16.224018] saa7133[0]: i2c xfer: < 96 21 c0 >
[   16.256019] saa7133[0]: i2c xfer: < c2 00 32 d8 40 52 5b 9f 8f >
[   16.264018] saa7133[0]: i2c xfer: < c2 80 00 >
[   16.272021] saa7133[0]: i2c xfer: < c2 60 bf >
[   16.280018] saa7133[0]: i2c xfer: < c2 30 d2 >
[   16.296018] saa7133[0]: i2c xfer: < c2 30 56 >
[   16.312017] saa7133[0]: i2c xfer: < c2 30 52 >
[   16.876018] saa7133[0]: i2c xfer: < c2 30 50 >
[   16.884017] saa7133[0]: i2c xfer: < c2 60 3f >
[   16.892019] saa7133[0]: i2c xfer: < c2 80 08 >
[   16.900018] saa7133[0]: i2c xfer: < 96 1b >
[   16.908018] saa7133[0]: i2c xfer: < 97 =3D4d >
[   17.020016] saa7133[0]: i2c xfer: < 96 1b >
[   17.028018] saa7133[0]: i2c xfer: < 97 =3D45 >
[   17.140019] saa7133[0]: i2c xfer: < 96 1b >
[   17.148018] saa7133[0]: i2c xfer: < 97 =3D3c >
[   17.260019] saa7133[0]: i2c xfer: < 96 28 64 >
[   17.372015] saa7133[0]: i2c xfer: < 96 1d >
[   17.380018] saa7133[0]: i2c xfer: < 97 =3Dff >
[   17.388018] saa7133[0]: i2c xfer: < 96 1b >
[   17.396018] saa7133[0]: i2c xfer: < 97 =3D40 >
[   17.404017] saa7133[0]: i2c xfer: < c2 80 0c >
[   17.516017] saa7133[0]: i2c xfer: < 96 1d >
[   17.524015] saa7133[0]: i2c xfer: < 97 =3Dcf >
[   17.532019] saa7133[0]: i2c xfer: < 96 1b >
[   17.540022] saa7133[0]: i2c xfer: < 97 =3D48 >
[   17.548018] saa7133[0]: i2c xfer: < 96 05 01 >
[   17.556018] saa7133[0]: i2c xfer: < 96 0d 27 >
[   17.668018] saa7133[0]: i2c xfer: < 96 21 00 >
[   17.676018] saa7133[0]: i2c xfer: < 96 0f 81 >
[   17.684330] saa7133[0]: i2c xfer: < 96 21 c0 >
[   17.716018] saa7133[0]: i2c xfer: < c2 30 d0 >
[   17.724016] saa7133[0]: i2c xfer: < 96 21 00 >
[   17.732019] saa7133[0]: i2c xfer: < 96 02 20 >
[   17.740018] saa7133[0]: i2c xfer: < 96 00 02 >
[   18.308611] saa7133[0]: i2c xfer: < 10 00 [fe quirk] < 11 =3D46 >
[   18.316441] saa7133[0]: i2c xfer: < 10 07 80 >
[   18.324562] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[   18.332307] saa7133[0]: i2c xfer: < 10 3b fe >
[   18.340036] saa7133[0]: i2c xfer: < 10 3c 33 >
[   18.348154] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D60 >
[   18.357443] saa7133[0]: i2c xfer: < 10 3d 62 >
[   18.380028] saa7133[0]: i2c xfer: < 10 2d f0 >
[   18.388021] saa7133[0]: i2c xfer: < 10 2f 03 >
[   18.396021] saa7133[0]: i2c xfer: < 10 30 03 >
[   18.404018] saa7133[0]: i2c xfer: < 10 3e 72 ><6>lp0: using parport0 (=
interrupt-driven).
[   18.412028] saa7133[0]: i2c xfer: < 10 4d 0c >
[   18.420019] saa7133[0]: i2c xfer: < 10 4e 00 >
[   18.428020] saa7133[0]: i2c xfer: < 10 31 54 >
[   18.436017] saa7133[0]: i2c xfer: < 10 32 03 >
[   18.444465] saa7133[0]: i2c xfer: < 10 33 0c >
[   18.452066] saa7133[0]: i2c xfer: < 10 34 30 >
[   18.460989] saa7133[0]: i2c xfer: < 10 35 c3 >
[   18.468948] saa7133[0]: i2c xfer: < 10 4d 0d >
[   18.476029] saa7133[0]: i2c xfer: < 10 4e 55 >
[   18.608023] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3D34 >
[   18.616032] saa7133[0]: i2c xfer: < 10 37 34 >
[   18.624369] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.640018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.656013] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.672008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.688019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.704018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.720017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.736018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.752026] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.768016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.784017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.800017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.816018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.832017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.848015] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.864017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.880017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.896017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.912017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.928015] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.944017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.960017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.976017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   18.992017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.008015] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.024017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.040145] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 ><6>EX=
T4 FS on sda1, internal journal on sda1:8
[   19.056019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.072016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.088886] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.104304] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.120609] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.136020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.152327] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.168021] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.184021] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.200016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.216018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.233266] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.248410] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.264017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.280018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.296072] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.312051] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.328018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.344017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.360017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.376018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.392020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.408025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.424017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.440020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.456018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.472018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.488015] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.504018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.520017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.536020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.552016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.568009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.584020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.600009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.616018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.632018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.648016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.664009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.680128] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.696020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.712020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.732007] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.748014] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.764023] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.784007] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.800020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.816018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.832019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.848010] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.864044] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.880009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.896009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.912010] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.928011] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.944008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.960011] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.976008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   19.992019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.008008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.024023] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.040020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.056018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.072019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.088016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.104009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.120010] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.136017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.152019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.168008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.184018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.200007] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.216010] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.232020] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.248008] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.264019] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.280009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.296018] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.312009] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[   20.328016] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[   20.336010] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[   20.344017] saa7133[0]: i2c xfer: < 10 07 80 >
[   20.352019] saa7133[0]: i2c xfer: < 10 11 67 >
[   20.360017] saa7133[0]: i2c xfer: < 10 13 [fe quirk] < 11 =3D67 >
[   20.368016] saa7133[0]: i2c xfer: < 10 14 [fe quirk] < 11 =3D23 >
[   20.376013] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[   20.384007] saa7133[0]: i2c xfer: < 10 07 80 >
[   20.392020] saa7133[0]: i2c xfer: < 10 01 87 >
[   20.400010] saa7133[0]: i2c xfer: < 10 16 88 >
[   20.408017] saa7133[0]: i2c xfer: < 10 43 02 >
[   20.416020] saa7133[0]: i2c xfer: < 10 44 70 >
[   20.424010] saa7133[0]: i2c xfer: < 10 45 08 >
[   20.432007] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D62 >
[   20.440020] saa7133[0]: i2c xfer: < 10 3d 62 >
[   20.448010] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[   20.456017] saa7133[0]: i2c xfer: < 10 3b 7f >
[   20.464018] saa7133[0]: i2c xfer: < 10 3a [fe quirk] < 11 =3D00 >
[   20.472010] saa7133[0]: i2c xfer: < 10 3a 00 >
[   20.480007] saa7133[0]: i2c xfer: < 10 37 38 >
[   20.488022] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3D7f >
[   20.496018] saa7133[0]: i2c xfer: < 10 3b 79 >
[   20.504010] saa7133[0]: i2c xfer: < 10 47 00 >
[   20.512007] saa7133[0]: i2c xfer: < 10 48 ff >
[   20.520020] saa7133[0]: i2c xfer: < 10 49 00 >
[   20.528016] saa7133[0]: i2c xfer: < 10 4a ff >
[   20.536010] saa7133[0]: i2c xfer: < 10 46 12 >
[   20.544008] saa7133[0]: i2c xfer: < 10 4f 1a >
[   20.558115] saa7133[0]: i2c xfer: < 10 1e 07 >
[   20.567686] saa7133[0]: i2c xfer: < 10 1f c0 >
[   20.576020] saa7133[0]: i2c xfer: < 10 3b ff >
[   20.584017] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D62 >
[   20.592019] saa7133[0]: i2c xfer: < 10 3d 68 >
[   20.600018] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3D38 >
[   20.613902] saa7133[0]: i2c xfer: < 10 37 f8 >
[   20.620020] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[   20.628018] saa7133[0]: i2c xfer: < 10 07 81 >
[   20.636011] saa7133[0]: i2c xfer: < 96 21 c0 >
[   20.668016] saa7133[0]: i2c xfer: < c3 =3D02 >
[   20.676010] saa7133[0]: i2c xfer: < 96 21 80 >
[   20.708018] saa7133[0]: i2c xfer: < 96 21 c0 >
[   20.740018] saa7133[0]: i2c xfer: < c2 30 d0 >
[   20.748011] saa7133[0]: i2c xfer: < 96 21 80 >
[   29.582073] saa7133[0]: i2c xfer: < 96 01 02 >
[   29.590598] saa7133[0]: i2c xfer: < 96 02 00 >
[   29.597223] saa7133[0]: i2c xfer: < 96 00 00 >
[   29.604025] saa7133[0]: i2c xfer: < 96 01 01 >
[   29.612023] saa7133[0]: i2c xfer: < 96 02 00 >
[   29.620023] saa7133[0]: i2c xfer: < 96 00 00 >
[   29.628159] saa7133[0]: i2c xfer: < 96 01 02 >
[   29.636274] saa7133[0]: i2c xfer: < 96 02 00 >
[   29.645446] saa7133[0]: i2c xfer: < 96 00 00 >
[   29.652917] saa7133[0]: i2c xfer: < 96 01 81 >
[   29.660422] saa7133[0]: i2c xfer: < 96 03 48 >
[   29.668130] saa7133[0]: i2c xfer: < 96 04 04 >
[   29.676423] saa7133[0]: i2c xfer: < 96 05 04 >
[   29.684435] saa7133[0]: i2c xfer: < 96 06 10 >
[   29.692030] saa7133[0]: i2c xfer: < 96 07 00 >
[   29.700018] saa7133[0]: i2c xfer: < 96 08 00 >
[   29.708018] saa7133[0]: i2c xfer: < 96 09 80 >
[   29.716018] saa7133[0]: i2c xfer: < 96 0a da >
[   29.724018] saa7133[0]: i2c xfer: < 96 0b 4b >
[   29.732018] saa7133[0]: i2c xfer: < 96 0c 68 >
[   29.740018] saa7133[0]: i2c xfer: < 96 0d 00 >
[   29.748018] saa7133[0]: i2c xfer: < 96 14 00 >
[   29.756019] saa7133[0]: i2c xfer: < 96 13 01 >
[   29.766993] saa7133[0]: i2c xfer: < 96 21 c0 >
[   29.772900] saa7133[0]: i2c xfer: < 96 01 82 >
[   29.780028] saa7133[0]: i2c xfer: < 96 28 14 >
[   29.788020] saa7133[0]: i2c xfer: < 96 0f 88 >
[   29.796024] saa7133[0]: i2c xfer: < 96 05 04 >
[   29.804018] saa7133[0]: i2c xfer: < 96 0d 47 >
[   29.812018] saa7133[0]: i2c xfer: < 96 21 c0 >
[   29.820019] saa7133[0]: i2c xfer: < 96 01 82 >
[   29.828018] saa7133[0]: i2c xfer: < 96 28 14 >
[   29.836018] saa7133[0]: i2c xfer: < 96 0f 88 >
[   29.844018] saa7133[0]: i2c xfer: < 96 05 04 >
[   29.852018] saa7133[0]: i2c xfer: < 96 0d 47 >
[   29.860018] saa7133[0]: i2c xfer: < 96 21 c0 >
[   29.868019] saa7133[0]: i2c xfer: < c2 00 2e 80 40 52 d0 9f 8f >
[   29.876018] saa7133[0]: i2c xfer: < c2 80 00 >
[   29.884018] saa7133[0]: i2c xfer: < c2 60 bf >
[   29.892018] saa7133[0]: i2c xfer: < c2 30 d2 >
[   29.900019] saa7133[0]: i2c xfer: < c2 00 32 d8 40 52 5b 9f 8f >
[   29.908019] saa7133[0]: i2c xfer: < c2 80 00 >
[   29.916018] saa7133[0]: i2c xfer: < c2 60 bf >
[   29.924018] saa7133[0]: i2c xfer: < c2 30 d2 >
[   29.932019] saa7133[0]: i2c xfer: < c2 00 32 d8 40 52 5b 9f 8f >
[   29.940018] saa7133[0]: i2c xfer: < c2 80 00 >
[   29.948018] saa7133[0]: i2c xfer: < c2 60 bf >
[   29.956018] saa7133[0]: i2c xfer: < c2 30 d2 >
[   29.964019] saa7133[0]: i2c xfer: < c2 30 56 >
[   29.972019] saa7133[0]: i2c xfer: < c2 30 56 >
[   29.980020] saa7133[0]: i2c xfer: < c2 30 56 >
[   29.988020] saa7133[0]: i2c xfer: < c2 30 52 >
[   29.996019] saa7133[0]: i2c xfer: < c2 30 52 >
[   30.004030] saa7133[0]: i2c xfer: < c2 30 52 >
[   30.552018] saa7133[0]: i2c xfer: < c2 30 50 >
[   30.560016] saa7133[0]: i2c xfer: < c2 60 3f >
[   30.568018] saa7133[0]: i2c xfer: < c2 80 08 >
[   30.576018] saa7133[0]: i2c xfer: < 96 1b >
[   30.584018] saa7133[0]: i2c xfer: < 97 =3D4b >
[   30.592019] saa7133[0]: i2c xfer: < c2 30 50 >
[   30.600018] saa7133[0]: i2c xfer: < c2 60 3f >
[   30.608017] saa7133[0]: i2c xfer: < c2 80 08 >
[   30.616018] saa7133[0]: i2c xfer: < 96 1b >
[   30.624018] saa7133[0]: i2c xfer: < 97 =3D48 >
[   30.632019] saa7133[0]: i2c xfer: < c2 30 50 >
[   30.640017] saa7133[0]: i2c xfer: < c2 60 3f >
[   30.648017] saa7133[0]: i2c xfer: < c2 80 08 >
[   30.656023] saa7133[0]: i2c xfer: < 96 1b >
[   30.664017] saa7133[0]: i2c xfer: < 97 =3D46 >
[   30.696019] saa7133[0]: i2c xfer: < 96 1b >
[   30.704016] saa7133[0]: i2c xfer: < 97 =3D43 >
[   30.736019] saa7133[0]: i2c xfer: < 96 1b >
[   30.744016] saa7133[0]: i2c xfer: < 97 =3D40 >
[   30.776019] saa7133[0]: i2c xfer: < 96 1b >
[   30.784016] saa7133[0]: i2c xfer: < 97 =3D3c >
[   30.816020] saa7133[0]: i2c xfer: < 96 1b >
[   30.824015] saa7133[0]: i2c xfer: < 97 =3D3b >
[   30.856019] saa7133[0]: i2c xfer: < 96 1b >
[   30.864015] saa7133[0]: i2c xfer: < 97 =3D39 >
[   30.896019] saa7133[0]: i2c xfer: < 96 1b >
[   30.904021] saa7133[0]: i2c xfer: < 97 =3D36 >
[   30.936019] saa7133[0]: i2c xfer: < 96 21 00 >
[   30.944015] saa7133[0]: i2c xfer: < 96 0f 81 >
[   30.952676] saa7133[0]: i2c xfer: < 96 21 c0 >
[   30.976019] saa7133[0]: i2c xfer: < 96 28 64 >
[   30.984019] saa7133[0]: i2c xfer: < c2 30 d0 >
[   30.992017] saa7133[0]: i2c xfer: < 96 21 00 >
[   31.000017] saa7133[0]: i2c xfer: < 96 02 20 >
[   31.008016] saa7133[0]: i2c xfer: < 96 00 02 >
[   31.016239] saa7133[0]: i2c xfer: < 96 28 64 >
[   31.088018] saa7133[0]: i2c xfer: < 96 1d >
[   31.096016] saa7133[0]: i2c xfer: < 97 =3D80 >
[   31.104017] saa7133[0]: i2c xfer: < 96 1b >
[   31.112017] saa7133[0]: i2c xfer: < 97 =3D36 >
[   31.120017] saa7133[0]: i2c xfer: < c2 ERROR: NO_DEVICE
[   31.128053] saa7133[0]: i2c xfer: < 96 1d >
[   31.136016] saa7133[0]: i2c xfer: < 97 =3D80 >
[   31.144017] saa7133[0]: i2c xfer: < 96 1b >
[   31.152025] saa7133[0]: i2c xfer: < 97 =3D36 >
[   31.160017] saa7133[0]: i2c xfer: < c2 ERROR: NO_DEVICE
[   31.224056] saa7133[0]: i2c xfer: < 96 1d >
[   31.232016] saa7133[0]: i2c xfer: < 97 =3D80 >
[   31.240017] saa7133[0]: i2c xfer: < 96 1b >
[   31.248016] saa7133[0]: i2c xfer: < 97 =3D36 >
[   31.256017] saa7133[0]: i2c xfer: < 96 05 01 >
[   31.264020] saa7133[0]: i2c xfer: < 96 0d 27 >
[   31.272019] saa7133[0]: i2c xfer: < 96 1d >
[   31.280017] saa7133[0]: i2c xfer: < 97 =3D80 >
[   31.288017] saa7133[0]: i2c xfer: < 96 1b >
[   31.296017] saa7133[0]: i2c xfer: < 97 =3D36 >
[   31.304017] saa7133[0]: i2c xfer: < 96 05 01 >
[   31.312017] saa7133[0]: i2c xfer: < 96 0d 27 >
[   31.376019] saa7133[0]: i2c xfer: < 96 21 00 >
[   31.384016] saa7133[0]: i2c xfer: < 96 0f 81 >
[   31.424023] saa7133[0]: i2c xfer: < 96 21 00 >
[   31.432016] saa7133[0]: i2c xfer: < 96 0f 81 >
[  274.337866] saa7133[0]: i2c xfer: < 10 07 80 >
[  274.344024] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  274.352030] saa7133[0]: i2c xfer: < 10 3b fe >
[  274.360026] saa7133[0]: i2c xfer: < 10 3c 33 >
[  274.368026] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D68 >
[  274.376026] saa7133[0]: i2c xfer: < 10 3d 62 >
[  274.400027] saa7133[0]: i2c xfer: < 10 2d f0 >
[  274.408032] saa7133[0]: i2c xfer: < 10 2f 03 >
[  274.416036] saa7133[0]: i2c xfer: < 10 30 03 >
[  274.424026] saa7133[0]: i2c xfer: < 10 3e 72 >
[  274.432026] saa7133[0]: i2c xfer: < 10 4d 0c >
[  274.440038] saa7133[0]: i2c xfer: < 10 4e 00 >
[  274.448027] saa7133[0]: i2c xfer: < 10 31 54 >
[  274.456026] saa7133[0]: i2c xfer: < 10 32 03 >
[  274.464027] saa7133[0]: i2c xfer: < 10 33 0c >
[  274.472030] saa7133[0]: i2c xfer: < 10 34 30 >
[  274.480026] saa7133[0]: i2c xfer: < 10 35 c3 >
[  274.488026] saa7133[0]: i2c xfer: < 10 4d 0d >
[  274.496037] saa7133[0]: i2c xfer: < 10 4e 55 >
[  274.628029] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3Df8 >
[  274.636023] saa7133[0]: i2c xfer: < 10 37 38 >
[  274.644027] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.660025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.676025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.692025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.708027] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.724025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.740029] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.756024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.772024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.788024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.804024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.820024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.836025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.852025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.868024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.884027] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.900024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.916028] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.932035] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.948024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.964025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.980024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  274.996024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.012026] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.028024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.044024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.060028] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.076025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.092030] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.108025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.124025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.140024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.156024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.172024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.188034] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.204026] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.220024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.236029] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.252024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.268398] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.284025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.300029] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.316026] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.332024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.348024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.364025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.392037] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.408032] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.424035] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.440025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.456054] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.472017] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.488014] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.504014] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.520015] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.536044] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.552308] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.568025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.584025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.600024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.616036] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.632025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.648029] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.664025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.680034] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.696035] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.712025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.728024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.744026] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.760025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.776034] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.792027] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.808024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.824028] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.840025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.856032] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.872024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.888025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.904025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.920025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.936035] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.952024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.968028] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  275.984024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.000028] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.016035] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.032025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.048024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.064025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.080024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.096035] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.112025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.128024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.144028] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.160025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.176247] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.192027] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.208025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.224024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.240025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.256036] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.272026] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.288025] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3D80 >
[  276.304024] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  276.312022] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  276.320031] saa7133[0]: i2c xfer: < 10 07 80 >
[  276.328026] saa7133[0]: i2c xfer: < 10 11 67 >
[  276.336035] saa7133[0]: i2c xfer: < 10 13 [fe quirk] < 11 =3D67 >
[  276.344026] saa7133[0]: i2c xfer: < 10 14 [fe quirk] < 11 =3D23 >
[  276.352652] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  276.360028] saa7133[0]: i2c xfer: < 10 07 80 >
[  276.368025] saa7133[0]: i2c xfer: < 10 01 87 >
[  276.376026] saa7133[0]: i2c xfer: < 10 16 88 >
[  276.384026] saa7133[0]: i2c xfer: < 10 43 02 >
[  276.392026] saa7133[0]: i2c xfer: < 10 44 70 >
[  276.400026] saa7133[0]: i2c xfer: < 10 45 08 >
[  276.408243] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D62 >
[  276.416035] saa7133[0]: i2c xfer: < 10 3d 62 >
[  276.424035] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  276.432026] saa7133[0]: i2c xfer: < 10 3b 7f >
[  276.441294] saa7133[0]: i2c xfer: < 10 3a [fe quirk] < 11 =3D00 >
[  276.448028] saa7133[0]: i2c xfer: < 10 3a 00 >
[  276.456026] saa7133[0]: i2c xfer: < 10 37 38 >
[  276.464026] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3D7f >
[  276.472026] saa7133[0]: i2c xfer: < 10 3b 79 >
[  276.480026] saa7133[0]: i2c xfer: < 10 47 00 >
[  276.488026] saa7133[0]: i2c xfer: < 10 48 ff >
[  276.496036] saa7133[0]: i2c xfer: < 10 49 00 >
[  276.504027] saa7133[0]: i2c xfer: < 10 4a ff >
[  276.512026] saa7133[0]: i2c xfer: < 10 46 12 >
[  276.520026] saa7133[0]: i2c xfer: < 10 4f 1a >
[  276.528030] saa7133[0]: i2c xfer: < 10 1e 07 >
[  276.536028] saa7133[0]: i2c xfer: < 10 1f c0 >
[  276.544027] saa7133[0]: i2c xfer: < 96 21 c0 >
[  276.576037] saa7133[0]: i2c xfer: < 96 21 80 >
[  279.608146] saa7133[0]: i2c xfer: < 96 21 c0 >
[  279.640493] saa7133[0]: i2c xfer: < 96 21 c0 >
[  279.672017] saa7133[0]: i2c xfer: < c2 30 d0 >
[  279.680025] saa7133[0]: i2c xfer: < 96 21 80 >
[  279.726526] saa7133[0]: i2c xfer: < 96 21 80 >
[  279.756016] saa7133[0]: i2c xfer: < 10 3b ff >
[  279.764014] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D62 >
[  279.772012] saa7133[0]: i2c xfer: < 10 3d 68 >
[  279.780030] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3D38 >
[  279.788026] saa7133[0]: i2c xfer: < 10 37 f8 >
[  279.796026] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  279.804025] saa7133[0]: i2c xfer: < 10 07 81 >
[  280.911636] saa7133[0]: i2c xfer: < 10 07 80 >
[  280.920028] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  280.928027] saa7133[0]: i2c xfer: < 10 3b fe >
[  280.936026] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  280.936175] saa7133[0]: i2c xfer: < 10 3d ERROR: BUS_ERR
[  280.952062] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  280.952215] saa7133[0]: i2c xfer: < 10 2f ERROR: BUS_ERR
[  280.952549] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  280.952730] saa7133[0]: i2c xfer: < 10 3e ERROR: BUS_ERR
[  280.953013] saa7133[0]: i2c xfer: < 10 ERROR: ARB_LOST
[  280.953292] saa7133[0]: i2c xfer: < 10 4e 00 >
[  280.960030] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  280.960212] saa7133[0]: i2c xfer: < 10 4d 0d ERROR: ARB_LOST
[  280.960665] saa7133[0]: i2c xfer: < 10 ERROR: ARB_LOST
[  281.084068] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3Df8 >
[  281.092023] saa7133[0]: i2c xfer: < 10 37 38 >
[  281.100027] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  281.108026] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  281.116026] saa7133[0]: i2c xfer: < 10 07 80 >
[  281.124026] saa7133[0]: i2c xfer: < 10 11 67 >
[  281.132058] saa7133[0]: i2c xfer: < 10 13 [fe quirk] < 11 =3D67 >
[  281.140026] saa7133[0]: i2c xfer: < 10 14 [fe quirk] < 11 =3D23 >
[  281.148033] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  281.156027] saa7133[0]: i2c xfer: < 10 07 80 >
[  281.165023] saa7133[0]: i2c xfer: < 10 01 87 >
[  281.172027] saa7133[0]: i2c xfer: < 10 16 88 >
[  281.180027] saa7133[0]: i2c xfer: < 10 43 02 >
[  281.188033] saa7133[0]: i2c xfer: < 10 44 70 >
[  281.196027] saa7133[0]: i2c xfer: < 10 45 08 >
[  281.204026] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D68 >
[  281.212026] saa7133[0]: i2c xfer: < 10 3d 68 >
[  281.220023] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  281.228026] saa7133[0]: i2c xfer: < 10 3b 7f >
[  281.236026] saa7133[0]: i2c xfer: < 10 3a [fe quirk] < 11 =3D00 >
[  281.244026] saa7133[0]: i2c xfer: < 10 3a 00 >
[  281.253207] saa7133[0]: i2c xfer: < 10 37 38 >
[  281.260027] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3D7f >
[  281.268025] saa7133[0]: i2c xfer: < 10 3b 79 >
[  281.276026] saa7133[0]: i2c xfer: < 10 47 00 >
[  281.284027] saa7133[0]: i2c xfer: < 10 48 ff >
[  281.292029] saa7133[0]: i2c xfer: < 10 49 00 >
[  281.300027] saa7133[0]: i2c xfer: < 10 4a ff >
[  281.308027] saa7133[0]: i2c xfer: < 10 46 12 >
[  281.316028] saa7133[0]: i2c xfer: < 10 4f 1a >
[  281.324026] saa7133[0]: i2c xfer: < 10 1e 07 >
[  281.332027] saa7133[0]: i2c xfer: < 10 1f c0 >
[  281.340034] saa7133[0]: i2c xfer: < 96 21 c0 >
[  281.372028] saa7133[0]: i2c xfer: < 96 21 80 >
[  281.404551] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D87 >
[  281.412024] saa7133[0]: i2c xfer: < 10 01 97 >
[  281.420027] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D00 >
[  281.428043] saa7133[0]: i2c xfer: < 10 02 00 >
[  281.436028] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  281.444026] saa7133[0]: i2c xfer: < 10 03 00 >
[  281.452026] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D02 >
[  281.460025] saa7133[0]: i2c xfer: < 10 43 02 >
[  281.468028] saa7133[0]: i2c xfer: < 96 21 c0 >
[  281.500027] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  281.508027] saa7133[0]: i2c xfer: < 96 21 80 >
[  282.044044] saa7133[0]: i2c xfer: < 96 21 c0 >
[  282.076027] saa7133[0]: i2c xfer: < c2 30 50 >
[  282.084023] saa7133[0]: i2c xfer: < 96 21 80 >
[  282.116029] saa7133[0]: i2c xfer: < 96 21 80 >
[  282.148031] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D97 >
[  282.156024] saa7133[0]: i2c xfer: < 10 01 97 >
[  282.164029] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D00 >
[  282.172026] saa7133[0]: i2c xfer: < 10 02 00 >
[  282.180026] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D00 >
[  282.188030] saa7133[0]: i2c xfer: < 10 02 00 >
[  282.196030] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  282.208167] saa7133[0]: i2c xfer: < 10 03 00 >
[  282.216027] saa7133[0]: i2c xfer: < 10 31 54 >
[  282.224033] saa7133[0]: i2c xfer: < 10 32 03 >
[  282.232029] saa7133[0]: i2c xfer: < 10 33 0c >
[  282.240026] saa7133[0]: i2c xfer: < 10 34 30 >
[  282.248026] saa7133[0]: i2c xfer: < 10 35 c3 >
[  282.256038] saa7133[0]: i2c xfer: < 10 4d 0d >
[  282.264026] saa7133[0]: i2c xfer: < 10 4e 55 >
[  282.272026] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3D88 >
[  282.280026] saa7133[0]: i2c xfer: < 10 16 a8 >
[  282.288027] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D97 >
[  282.296026] saa7133[0]: i2c xfer: < 10 01 95 >
[  282.304025] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D00 >
[  282.312026] saa7133[0]: i2c xfer: < 10 02 00 >
[  282.320030] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D95 >
[  282.328026] saa7133[0]: i2c xfer: < 10 01 91 >
[  282.336037] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D00 >
[  282.344026] saa7133[0]: i2c xfer: < 10 02 10 >
[  282.352026] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  282.360026] saa7133[0]: i2c xfer: < 10 01 d1 >
[  282.376035] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D02 >
[  282.384023] saa7133[0]: i2c xfer: < 10 43 03 >
[  282.408038] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  282.416027] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  282.424027] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  282.432027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  282.540122] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  282.548025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  282.556029] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  282.564026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  282.672255] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  282.680027] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  282.688028] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  282.696027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  282.804387] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  282.812025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  282.820030] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  282.828027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  282.936408] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  282.944026] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  282.952027] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  282.960026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  283.068386] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  283.076025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  283.084032] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  283.092028] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  283.200126] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  283.208035] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  283.216031] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  283.224026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  283.232045] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  283.240026] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  283.248026] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  283.256026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  283.264043] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  283.272026] saa7133[0]: i2c xfer: < 10 01 91 >
[  283.280026] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  283.288032] saa7133[0]: i2c xfer: < 10 02 10 >
[  283.296044] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  283.304027] saa7133[0]: i2c xfer: < 10 03 00 >
[  283.312026] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  283.320027] saa7133[0]: i2c xfer: < 10 43 03 >
[  283.328028] saa7133[0]: i2c xfer: < 96 21 c0 >
[  283.360026] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  283.368036] saa7133[0]: i2c xfer: < 96 21 80 >
[  283.904026] saa7133[0]: i2c xfer: < 96 21 c0 >
[  283.936108] saa7133[0]: i2c xfer: < c2 30 50 >
[  283.944027] saa7133[0]: i2c xfer: < 96 21 80 >
[  283.976024] saa7133[0]: i2c xfer: < 96 21 80 >
[  284.008029] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  284.016036] saa7133[0]: i2c xfer: < 10 01 91 >
[  284.024027] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  284.032019] saa7133[0]: i2c xfer: < 10 02 10 >
[  284.040026] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  284.048026] saa7133[0]: i2c xfer: < 10 02 10 >
[  284.056026] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  284.064026] saa7133[0]: i2c xfer: < 10 03 00 >
[  284.072026] saa7133[0]: i2c xfer: < 10 31 54 >
[  284.080026] saa7133[0]: i2c xfer: < 10 32 03 >
[  284.088027] saa7133[0]: i2c xfer: < 10 33 0c >
[  284.096041] saa7133[0]: i2c xfer: < 10 34 30 >
[  284.104027] saa7133[0]: i2c xfer: < 10 35 c3 >
[  284.112036] saa7133[0]: i2c xfer: < 10 4d 0d >
[  284.120026] saa7133[0]: i2c xfer: < 10 4e 55 >
[  284.128026] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3Da8 >
[  284.136026] saa7133[0]: i2c xfer: < 10 16 88 >
[  284.144026] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  284.152026] saa7133[0]: i2c xfer: < 10 01 91 >
[  284.160026] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  284.168026] saa7133[0]: i2c xfer: < 10 02 10 >
[  284.176036] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  284.184030] saa7133[0]: i2c xfer: < 10 01 91 >
[  284.192029] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  284.200027] saa7133[0]: i2c xfer: < 10 02 10 >
[  284.208027] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  284.216026] saa7133[0]: i2c xfer: < 10 01 d1 >
[  284.232025] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  284.240025] saa7133[0]: i2c xfer: < 10 43 03 >
[  284.264052] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  284.272031] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  284.280027] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  284.288027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  284.396127] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  284.404025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  284.412027] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  284.420026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  284.528131] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  284.537357] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  284.544028] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  284.552026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  284.660133] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  284.668026] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  284.676029] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  284.684026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  284.792417] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  284.800025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  284.808033] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  284.816031] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  284.924404] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  284.932025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  284.940028] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  284.948026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  285.056406] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  285.064027] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  285.072034] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  285.080027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  285.088046] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  285.096026] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  285.104035] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  285.112037] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  285.120027] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  285.128026] saa7133[0]: i2c xfer: < 10 01 91 >
[  285.136038] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  285.144030] saa7133[0]: i2c xfer: < 10 02 10 >
[  285.152027] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  285.160032] saa7133[0]: i2c xfer: < 10 03 00 >
[  285.168026] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  285.176026] saa7133[0]: i2c xfer: < 10 43 03 >
[  285.184291] saa7133[0]: i2c xfer: < 96 21 c0 >
[  285.216039] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  285.224046] saa7133[0]: i2c xfer: < 96 21 80 >
[  285.760029] saa7133[0]: i2c xfer: < 96 21 c0 >
[  285.792036] saa7133[0]: i2c xfer: < c2 30 50 >
[  285.800023] saa7133[0]: i2c xfer: < 96 21 80 >
[  285.832021] saa7133[0]: i2c xfer: < 96 21 80 >
[  285.864037] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  285.872025] saa7133[0]: i2c xfer: < 10 01 91 >
[  285.880026] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  285.888026] saa7133[0]: i2c xfer: < 10 02 10 >
[  285.896026] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  285.904026] saa7133[0]: i2c xfer: < 10 02 10 >
[  285.912026] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  285.920026] saa7133[0]: i2c xfer: < 10 03 00 >
[  285.928026] saa7133[0]: i2c xfer: < 10 31 54 >
[  285.936035] saa7133[0]: i2c xfer: < 10 32 03 >
[  285.944025] saa7133[0]: i2c xfer: < 10 33 0c >
[  285.952029] saa7133[0]: i2c xfer: < 10 34 30 >
[  285.960028] saa7133[0]: i2c xfer: < 10 35 c3 >
[  285.968026] saa7133[0]: i2c xfer: < 10 4d 0d >
[  285.976034] saa7133[0]: i2c xfer: < 10 4e 55 >
[  285.984026] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3D88 >
[  285.992026] saa7133[0]: i2c xfer: < 10 16 88 >
[  286.000026] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  286.008026] saa7133[0]: i2c xfer: < 10 01 91 >
[  286.016036] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  286.024025] saa7133[0]: i2c xfer: < 10 02 10 >
[  286.032026] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  286.040029] saa7133[0]: i2c xfer: < 10 01 91 >
[  286.048028] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  286.056026] saa7133[0]: i2c xfer: < 10 02 10 >
[  286.064026] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  286.072026] saa7133[0]: i2c xfer: < 10 01 d1 >
[  286.088024] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  286.096040] saa7133[0]: i2c xfer: < 10 43 03 >
[  286.120035] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  286.128030] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  286.136029] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  286.144026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  286.920045] saa7133[0]: i2c xfer: < 96 21 c0 >
[  286.952026] saa7133[0]: i2c xfer: < 96 21 c0 >
[  286.984040] saa7133[0]: i2c xfer: < c2 30 d0 >
[  286.992023] saa7133[0]: i2c xfer: < 96 21 80 >
[  287.024034] saa7133[0]: i2c xfer: < 96 21 80 >
[  287.056037] saa7133[0]: i2c xfer: < 10 3b ff >
[  287.064023] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D68 >
[  287.072027] saa7133[0]: i2c xfer: < 10 3d 68 >
[  287.080026] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3D38 >
[  287.088035] saa7133[0]: i2c xfer: < 10 37 f8 >
[  287.096030] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  287.104030] saa7133[0]: i2c xfer: < 10 07 81 >
[  358.200290] saa7133[0]: i2c xfer: < 10 07 80 >
[  358.208031] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  358.216031] saa7133[0]: i2c xfer: < 10 3b fe >
[  358.224027] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  358.224209] saa7133[0]: i2c xfer: < 10 3d ERROR: BUS_ERR
[  358.240080] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  358.240235] saa7133[0]: i2c xfer: < 10 2f ERROR: BUS_ERR
[  358.240518] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  358.240665] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  358.240845] saa7133[0]: i2c xfer: < 10 4d ERROR: BUS_ERR
[  358.241128] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  358.241276] saa7133[0]: i2c xfer: < 10 31 54 >
[  358.248028] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  358.248209] saa7133[0]: i2c xfer: < 10 4d 0d ERROR: BUS_ERR
[  358.248628] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  358.372081] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3Df8 >
[  358.380024] saa7133[0]: i2c xfer: < 10 37 38 >
[  358.388509] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  358.396027] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  358.404027] saa7133[0]: i2c xfer: < 10 07 80 >
[  358.412027] saa7133[0]: i2c xfer: < 10 11 67 >
[  358.420026] saa7133[0]: i2c xfer: < 10 13 [fe quirk] < 11 =3D67 >
[  358.428027] saa7133[0]: i2c xfer: < 10 14 [fe quirk] < 11 =3D23 >
[  358.436033] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  358.444028] saa7133[0]: i2c xfer: < 10 07 80 >
[  358.452027] saa7133[0]: i2c xfer: < 10 01 87 >
[  358.460026] saa7133[0]: i2c xfer: < 10 16 88 >
[  358.468026] saa7133[0]: i2c xfer: < 10 43 02 >
[  358.476889] saa7133[0]: i2c xfer: < 10 44 70 >
[  358.484027] saa7133[0]: i2c xfer: < 10 45 08 >
[  358.492026] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D68 >
[  358.500028] saa7133[0]: i2c xfer: < 10 3d 68 >
[  358.508028] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  358.516026] saa7133[0]: i2c xfer: < 10 3b 7f >
[  358.524027] saa7133[0]: i2c xfer: < 10 3a [fe quirk] < 11 =3D00 >
[  358.532027] saa7133[0]: i2c xfer: < 10 3a 00 >
[  358.540026] saa7133[0]: i2c xfer: < 10 37 38 >
[  358.548026] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3D7f >
[  358.556026] saa7133[0]: i2c xfer: < 10 3b 79 >
[  358.565912] saa7133[0]: i2c xfer: < 10 47 00 >
[  358.572028] saa7133[0]: i2c xfer: < 10 48 ff >
[  358.580403] saa7133[0]: i2c xfer: < 10 49 00 >
[  358.588027] saa7133[0]: i2c xfer: < 10 4a ff >
[  358.596032] saa7133[0]: i2c xfer: < 10 46 12 >
[  358.604029] saa7133[0]: i2c xfer: < 10 4f 1a >
[  358.612028] saa7133[0]: i2c xfer: < 10 1e 07 >
[  358.620027] saa7133[0]: i2c xfer: < 10 1f c0 >
[  358.628027] saa7133[0]: i2c xfer: < 96 21 c0 >
[  358.660035] saa7133[0]: i2c xfer: < 96 21 80 >
[  358.692414] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D87 >
[  358.700024] saa7133[0]: i2c xfer: < 10 01 97 >
[  358.708027] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  358.716026] saa7133[0]: i2c xfer: < 10 02 10 >
[  358.724112] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  358.732026] saa7133[0]: i2c xfer: < 10 03 00 >
[  358.740026] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D02 >
[  358.748033] saa7133[0]: i2c xfer: < 10 43 02 >
[  358.756027] saa7133[0]: i2c xfer: < 96 21 c0 >
[  358.788023] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  358.796027] saa7133[0]: i2c xfer: < 96 21 80 >
[  359.332032] saa7133[0]: i2c xfer: < 96 21 c0 >
[  359.364613] saa7133[0]: i2c xfer: < c2 30 50 >
[  359.372029] saa7133[0]: i2c xfer: < 96 21 80 >
[  359.404027] saa7133[0]: i2c xfer: < 96 21 80 >
[  359.436023] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D97 >
[  359.444026] saa7133[0]: i2c xfer: < 10 01 97 >
[  359.452030] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  359.466367] saa7133[0]: i2c xfer: < 10 02 10 >
[  359.472027] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  359.480032] saa7133[0]: i2c xfer: < 10 02 10 >
[  359.488030] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  359.496027] saa7133[0]: i2c xfer: < 10 03 00 >
[  359.504029] saa7133[0]: i2c xfer: < 10 31 54 >
[  359.512027] saa7133[0]: i2c xfer: < 10 32 03 >
[  359.520049] saa7133[0]: i2c xfer: < 10 33 0c >
[  359.528029] saa7133[0]: i2c xfer: < 10 34 30 >
[  359.536027] saa7133[0]: i2c xfer: < 10 35 c3 >
[  359.544034] saa7133[0]: i2c xfer: < 10 4d 0d >
[  359.552032] saa7133[0]: i2c xfer: < 10 4e 55 >
[  359.560029] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3D88 >
[  359.568028] saa7133[0]: i2c xfer: < 10 16 88 >
[  359.576030] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D97 >
[  359.584028] saa7133[0]: i2c xfer: < 10 01 95 >
[  359.592282] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  359.600041] saa7133[0]: i2c xfer: < 10 02 10 >
[  359.608504] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D95 >
[  359.616262] saa7133[0]: i2c xfer: < 10 01 91 >
[  359.624192] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  359.632028] saa7133[0]: i2c xfer: < 10 02 10 >
[  359.640031] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  359.648029] saa7133[0]: i2c xfer: < 10 01 d1 >
[  359.664029] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D02 >
[  359.672029] saa7133[0]: i2c xfer: < 10 43 03 >
[  359.700463] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  359.708031] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  359.716031] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  359.724432] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  359.832139] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  359.840035] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  359.848031] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  359.856026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  359.964145] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  359.972026] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  359.980028] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  359.988980] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  360.096145] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  360.104867] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  360.112095] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  360.120027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  360.228141] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  360.236081] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  360.244168] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  360.252027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  360.360145] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  360.368032] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  360.376032] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  360.384026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  360.492135] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  360.500031] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  360.508030] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  360.516027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  360.524046] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  360.532027] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  360.540027] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  360.548032] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  360.556031] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  360.564027] saa7133[0]: i2c xfer: < 10 01 91 >
[  360.572028] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  360.580027] saa7133[0]: i2c xfer: < 10 02 10 >
[  360.588027] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  360.596028] saa7133[0]: i2c xfer: < 10 03 00 >
[  360.604027] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  360.612029] saa7133[0]: i2c xfer: < 10 43 03 >
[  360.620030] saa7133[0]: i2c xfer: < 96 21 c0 >
[  360.652044] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  360.660028] saa7133[0]: i2c xfer: < 96 21 80 >
[  361.196023] saa7133[0]: i2c xfer: < 96 21 c0 >
[  361.228024] saa7133[0]: i2c xfer: < c2 30 50 >
[  361.236743] saa7133[0]: i2c xfer: < 96 21 80 >
[  361.268031] saa7133[0]: i2c xfer: < 96 21 80 >
[  361.300029] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  361.308028] saa7133[0]: i2c xfer: < 10 01 91 >
[  361.316027] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  361.324027] saa7133[0]: i2c xfer: < 10 02 10 >
[  361.332029] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  361.340028] saa7133[0]: i2c xfer: < 10 02 10 >
[  361.348033] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  361.356941] saa7133[0]: i2c xfer: < 10 03 00 >
[  361.364036] saa7133[0]: i2c xfer: < 10 31 54 >
[  361.372034] saa7133[0]: i2c xfer: < 10 32 03 >
[  361.380056] saa7133[0]: i2c xfer: < 10 33 0c >
[  361.388029] saa7133[0]: i2c xfer: < 10 34 30 >
[  361.396027] saa7133[0]: i2c xfer: < 10 35 c3 >
[  361.404030] saa7133[0]: i2c xfer: < 10 4d 0d >
[  361.412029] saa7133[0]: i2c xfer: < 10 4e 55 >
[  361.420028] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3D88 >
[  361.428026] saa7133[0]: i2c xfer: < 10 16 a8 >
[  361.438072] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  361.444029] saa7133[0]: i2c xfer: < 10 01 91 >
[  361.452028] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  361.460031] saa7133[0]: i2c xfer: < 10 02 10 >
[  361.468028] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  361.476029] saa7133[0]: i2c xfer: < 10 01 91 >
[  361.484028] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  361.492027] saa7133[0]: i2c xfer: < 10 02 10 >
[  361.500028] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  361.508028] saa7133[0]: i2c xfer: < 10 01 d1 >
[  361.524030] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  361.532028] saa7133[0]: i2c xfer: < 10 43 03 >
[  361.556037] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  361.564024] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  361.572027] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  361.580026] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  361.688148] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  361.696096] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  361.704081] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  361.712126] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  361.820141] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  361.828027] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  361.836031] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  361.844028] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  361.952215] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  361.960025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  361.968036] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  361.976092] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  362.084137] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  362.092028] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  362.100029] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  362.108028] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  362.216134] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  362.224026] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  362.232033] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  362.240031] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  362.348146] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  362.356023] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  362.364026] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  362.372023] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  362.380045] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  362.388022] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  362.396021] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  362.404020] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  362.412015] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  362.420013] saa7133[0]: i2c xfer: < 10 01 91 >
[  362.428011] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  362.436013] saa7133[0]: i2c xfer: < 10 02 10 >
[  362.444013] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  362.452014] saa7133[0]: i2c xfer: < 10 03 00 >
[  362.460015] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  362.469388] saa7133[0]: i2c xfer: < 10 43 03 >
[  362.476014] saa7133[0]: i2c xfer: < 96 21 c0 >
[  362.508014] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  362.516013] saa7133[0]: i2c xfer: < 96 21 80 >
[  363.052017] saa7133[0]: i2c xfer: < 96 21 c0 >
[  363.084013] saa7133[0]: i2c xfer: < c2 30 50 >
[  363.092014] saa7133[0]: i2c xfer: < 96 21 80 >
[  363.124073] saa7133[0]: i2c xfer: < 96 21 80 >
[  363.156014] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  363.164012] saa7133[0]: i2c xfer: < 10 01 91 >
[  363.172013] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  363.180016] saa7133[0]: i2c xfer: < 10 02 10 >
[  363.188024] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  363.196017] saa7133[0]: i2c xfer: < 10 02 10 >
[  363.204016] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  363.212016] saa7133[0]: i2c xfer: < 10 03 00 >
[  363.220019] saa7133[0]: i2c xfer: < 10 31 54 >
[  363.228016] saa7133[0]: i2c xfer: < 10 32 03 >
[  363.236016] saa7133[0]: i2c xfer: < 10 33 0c >
[  363.244017] saa7133[0]: i2c xfer: < 10 34 30 >
[  363.252016] saa7133[0]: i2c xfer: < 10 35 c3 >
[  363.260016] saa7133[0]: i2c xfer: < 10 4d 0d >
[  363.268017] saa7133[0]: i2c xfer: < 10 4e 55 >
[  363.276020] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3Da8 >
[  363.284028] saa7133[0]: i2c xfer: < 10 16 a8 >
[  363.292028] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  363.300026] saa7133[0]: i2c xfer: < 10 01 91 >
[  363.308028] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  363.316027] saa7133[0]: i2c xfer: < 10 02 10 >
[  363.324027] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  363.332026] saa7133[0]: i2c xfer: < 10 01 91 >
[  363.340027] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  363.348026] saa7133[0]: i2c xfer: < 10 02 10 >
[  363.356026] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  363.364161] saa7133[0]: i2c xfer: < 10 01 d1 >
[  363.380025] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  363.388027] saa7133[0]: i2c xfer: < 10 43 03 >
[  363.412039] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  363.420025] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  363.428029] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  363.436027] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  364.212035] saa7133[0]: i2c xfer: < 96 21 c0 >
[  364.244040] saa7133[0]: i2c xfer: < 96 21 c0 >
[  364.276028] saa7133[0]: i2c xfer: < c2 30 d0 >
[  364.284028] saa7133[0]: i2c xfer: < 96 21 80 >
[  364.316033] saa7133[0]: i2c xfer: < 96 21 80 >
[  364.348039] saa7133[0]: i2c xfer: < 10 3b ff >
[  364.356023] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D68 >
[  364.365204] saa7133[0]: i2c xfer: < 10 3d 68 >
[  364.372026] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3D38 >
[  364.380028] saa7133[0]: i2c xfer: < 10 37 f8 >
[  364.388024] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  364.396036] saa7133[0]: i2c xfer: < 10 07 81 >
[  416.283495] saa7133[0]: i2c xfer: < 10 07 80 >
[  416.288029] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  416.296047] saa7133[0]: i2c xfer: < 10 3b fe >
[  416.304029] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  416.304211] saa7133[0]: i2c xfer: < 10 3d ERROR: BUS_ERR
[  416.320079] saa7133[0]: i2c xfer: < 10 2d ERROR: BUS_ERR
[  416.320437] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  416.320552] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  416.320699] saa7133[0]: i2c xfer: < 10 ERROR: ARB_LOST
[  416.320912] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  416.321026] saa7133[0]: i2c xfer: < 10 ERROR: BUS_ERR
[  416.321207] saa7133[0]: i2c xfer: < 10 31 54 >
[  416.329151] saa7133[0]: i2c xfer: < 10 ERROR: ARB_LOST
[  416.329335] saa7133[0]: i2c xfer: < 10 4d 0d ERROR: BUS_ERR
[  416.329721] saa7133[0]: i2c xfer: < 10 4e ERROR: BUS_ERR
[  416.452074] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3Df8 >
[  416.460031] saa7133[0]: i2c xfer: < 10 37 38 >
[  416.468043] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  416.476031] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  416.484030] saa7133[0]: i2c xfer: < 10 07 80 >
[  416.492036] saa7133[0]: i2c xfer: < 10 11 67 >
[  416.500029] saa7133[0]: i2c xfer: < 10 13 [fe quirk] < 11 =3D67 >
[  416.508029] saa7133[0]: i2c xfer: < 10 14 [fe quirk] < 11 =3D23 >
[  416.516044] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  416.524038] saa7133[0]: i2c xfer: < 10 07 80 >
[  416.532030] saa7133[0]: i2c xfer: < 10 01 87 >
[  416.540032] saa7133[0]: i2c xfer: < 10 16 88 >
[  416.548029] saa7133[0]: i2c xfer: < 10 43 02 >
[  416.556031] saa7133[0]: i2c xfer: < 10 44 70 >
[  416.564035] saa7133[0]: i2c xfer: < 10 45 08 >
[  416.572029] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D68 >
[  416.580030] saa7133[0]: i2c xfer: < 10 3d 68 >
[  416.588033] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3Dff >
[  416.596031] saa7133[0]: i2c xfer: < 10 3b 7f >
[  416.604030] saa7133[0]: i2c xfer: < 10 3a [fe quirk] < 11 =3D00 >
[  416.612035] saa7133[0]: i2c xfer: < 10 3a 00 >
[  416.620028] saa7133[0]: i2c xfer: < 10 37 38 >
[  416.628032] saa7133[0]: i2c xfer: < 10 3b [fe quirk] < 11 =3D7f >
[  416.636033] saa7133[0]: i2c xfer: < 10 3b 79 >
[  416.645775] saa7133[0]: i2c xfer: < 10 47 00 >
[  416.652029] saa7133[0]: i2c xfer: < 10 48 ff >
[  416.662070] saa7133[0]: i2c xfer: < 10 49 00 >
[  416.668034] saa7133[0]: i2c xfer: < 10 4a ff >
[  416.676037] saa7133[0]: i2c xfer: < 10 46 12 >
[  416.684035] saa7133[0]: i2c xfer: < 10 4f 1a >
[  416.692029] saa7133[0]: i2c xfer: < 10 1e 07 >
[  416.700032] saa7133[0]: i2c xfer: < 10 1f c0 >
[  416.708030] saa7133[0]: i2c xfer: < 96 21 c0 >
[  416.740037] saa7133[0]: i2c xfer: < 96 21 80 >
[  416.773376] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D87 >
[  416.780030] saa7133[0]: i2c xfer: < 10 01 97 >
[  416.788030] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  416.796031] saa7133[0]: i2c xfer: < 10 02 10 >
[  416.804040] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  416.812030] saa7133[0]: i2c xfer: < 10 03 00 >
[  416.821717] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D02 >
[  416.828032] saa7133[0]: i2c xfer: < 10 43 02 >
[  416.836029] saa7133[0]: i2c xfer: < 96 21 c0 >
[  416.868029] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  416.876032] saa7133[0]: i2c xfer: < 96 21 80 >
[  417.412034] saa7133[0]: i2c xfer: < 96 21 c0 >
[  417.444034] saa7133[0]: i2c xfer: < c2 30 50 >
[  417.452024] saa7133[0]: i2c xfer: < 96 21 80 >
[  417.484032] saa7133[0]: i2c xfer: < 96 21 80 >
[  417.516035] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D97 >
[  417.524625] saa7133[0]: i2c xfer: < 10 01 97 >
[  417.532037] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  417.540028] saa7133[0]: i2c xfer: < 10 02 10 >
[  417.548029] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  417.556031] saa7133[0]: i2c xfer: < 10 02 10 >
[  417.564027] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  417.572030] saa7133[0]: i2c xfer: < 10 03 00 >
[  417.580028] saa7133[0]: i2c xfer: < 10 31 54 >
[  417.588028] saa7133[0]: i2c xfer: < 10 32 03 >
[  417.596029] saa7133[0]: i2c xfer: < 10 33 0c >
[  417.604028] saa7133[0]: i2c xfer: < 10 34 30 >
[  417.612128] saa7133[0]: i2c xfer: < 10 35 c3 >
[  417.620034] saa7133[0]: i2c xfer: < 10 4d 0d >
[  417.628028] saa7133[0]: i2c xfer: < 10 4e 55 >
[  417.636028] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3D88 >
[  417.644028] saa7133[0]: i2c xfer: < 10 16 a8 >
[  417.652031] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D97 >
[  417.660029] saa7133[0]: i2c xfer: < 10 01 95 >
[  417.668030] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  417.676030] saa7133[0]: i2c xfer: < 10 02 10 >
[  417.684029] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D95 >
[  417.692028] saa7133[0]: i2c xfer: < 10 01 91 >
[  417.700029] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  417.708033] saa7133[0]: i2c xfer: < 10 02 10 >
[  417.716031] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  417.724027] saa7133[0]: i2c xfer: < 10 01 d1 >
[  417.740028] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D02 >
[  417.748028] saa7133[0]: i2c xfer: < 10 43 03 >
[  417.772044] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  417.780032] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  417.788029] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  417.796039] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  417.904139] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  417.912026] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  417.920039] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  417.928028] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  418.036136] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  418.044037] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  418.052029] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  418.060038] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  418.168156] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  418.176032] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  418.184033] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  418.192034] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  418.300321] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  418.308037] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  418.318807] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  418.324399] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  418.432163] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  418.440036] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  418.448037] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  418.456042] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  418.564199] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  418.572030] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  418.580026] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  418.588034] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  418.596398] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  418.604179] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  418.612428] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  418.620288] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  418.628237] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  418.636170] saa7133[0]: i2c xfer: < 10 01 91 >
[  418.644256] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  418.652395] saa7133[0]: i2c xfer: < 10 02 10 >
[  418.660120] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  418.668035] saa7133[0]: i2c xfer: < 10 03 00 >
[  418.676899] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  418.684247] saa7133[0]: i2c xfer: < 10 43 03 >
[  418.692280] saa7133[0]: i2c xfer: < 96 21 c0 >
[  418.724201] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  418.732178] saa7133[0]: i2c xfer: < 96 21 80 >
[  419.268031] saa7133[0]: i2c xfer: < 96 21 c0 >
[  419.300032] saa7133[0]: i2c xfer: < c2 30 50 >
[  419.308026] saa7133[0]: i2c xfer: < 96 21 80 >
[  419.340041] saa7133[0]: i2c xfer: < 96 21 80 >
[  419.372031] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  419.392031] saa7133[0]: i2c xfer: < 10 01 91 >
[  419.400022] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  419.408027] saa7133[0]: i2c xfer: < 10 02 10 >
[  419.416022] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  419.424022] saa7133[0]: i2c xfer: < 10 02 10 >
[  419.432023] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  419.440034] saa7133[0]: i2c xfer: < 10 03 00 >
[  419.448024] saa7133[0]: i2c xfer: < 10 31 54 >
[  419.456021] saa7133[0]: i2c xfer: < 10 32 03 >
[  419.464021] saa7133[0]: i2c xfer: < 10 33 0c >
[  419.472027] saa7133[0]: i2c xfer: < 10 34 30 >
[  419.480024] saa7133[0]: i2c xfer: < 10 35 c3 >
[  419.488036] saa7133[0]: i2c xfer: < 10 4d 0d >
[  419.496022] saa7133[0]: i2c xfer: < 10 4e 55 >
[  419.504024] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3Da8 >
[  419.512021] saa7133[0]: i2c xfer: < 10 16 88 >
[  419.520025] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  419.528016] saa7133[0]: i2c xfer: < 10 01 91 >
[  419.536022] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  419.544020] saa7133[0]: i2c xfer: < 10 02 10 >
[  419.552014] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  419.560015] saa7133[0]: i2c xfer: < 10 01 91 >
[  419.568015] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  419.576086] saa7133[0]: i2c xfer: < 10 02 10 >
[  419.584015] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  419.592205] saa7133[0]: i2c xfer: < 10 01 d1 >
[  419.608383] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  419.616014] saa7133[0]: i2c xfer: < 10 43 03 >
[  419.640033] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  419.649355] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  419.656095] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  419.665096] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  419.772115] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  419.780016] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  419.795245] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  419.804023] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  419.912120] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  419.920020] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  419.928017] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  419.936996] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  420.044116] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  420.052022] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  420.060022] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  420.068014] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  420.177154] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  420.184020] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  420.192024] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  420.200022] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  420.308117] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  420.316021] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  420.324023] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  420.332024] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  420.440027] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  420.448018] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  420.456016] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  420.464016] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  420.472018] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  420.480020] saa7133[0]: i2c xfer: < 10 01 91 >
[  420.488016] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  420.496021] saa7133[0]: i2c xfer: < 10 02 10 >
[  420.504020] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  420.512023] saa7133[0]: i2c xfer: < 10 03 00 >
[  420.520021] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  420.528029] saa7133[0]: i2c xfer: < 10 43 03 >
[  420.536032] saa7133[0]: i2c xfer: < 96 21 c0 >
[  420.568051] saa7133[0]: i2c xfer: < c2 00 5f f4 00 52 3b 9f bf 2a 05 f=
f 00 00 40 >
[  420.576026] saa7133[0]: i2c xfer: < 96 21 80 >
[  421.112611] saa7133[0]: i2c xfer: < 96 21 c0 >
[  421.144031] saa7133[0]: i2c xfer: < c2 30 50 >
[  421.152035] saa7133[0]: i2c xfer: < 96 21 80 >
[  421.184036] saa7133[0]: i2c xfer: < 96 21 80 >
[  421.216038] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  421.224024] saa7133[0]: i2c xfer: < 10 01 91 >
[  421.232031] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  421.240030] saa7133[0]: i2c xfer: < 10 02 10 >
[  421.248028] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  421.256029] saa7133[0]: i2c xfer: < 10 02 10 >
[  421.264030] saa7133[0]: i2c xfer: < 10 03 [fe quirk] < 11 =3D00 >
[  421.272043] saa7133[0]: i2c xfer: < 10 03 00 >
[  421.280043] saa7133[0]: i2c xfer: < 10 31 54 >
[  421.289329] saa7133[0]: i2c xfer: < 10 32 03 >
[  421.296035] saa7133[0]: i2c xfer: < 10 33 0c >
[  421.304043] saa7133[0]: i2c xfer: < 10 34 30 >
[  421.312029] saa7133[0]: i2c xfer: < 10 35 c3 >
[  421.320028] saa7133[0]: i2c xfer: < 10 4d 0d >
[  421.328037] saa7133[0]: i2c xfer: < 10 4e 55 >
[  421.336036] saa7133[0]: i2c xfer: < 10 16 [fe quirk] < 11 =3D88 >
[  421.344029] saa7133[0]: i2c xfer: < 10 16 88 >
[  421.352030] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  421.360040] saa7133[0]: i2c xfer: < 10 01 91 >
[  421.368039] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  421.377415] saa7133[0]: i2c xfer: < 10 02 10 >
[  421.384037] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  421.392027] saa7133[0]: i2c xfer: < 10 01 91 >
[  421.400035] saa7133[0]: i2c xfer: < 10 02 [fe quirk] < 11 =3D10 >
[  421.408038] saa7133[0]: i2c xfer: < 10 02 10 >
[  421.416032] saa7133[0]: i2c xfer: < 10 01 [fe quirk] < 11 =3D91 >
[  421.424037] saa7133[0]: i2c xfer: < 10 01 d1 >
[  421.440031] saa7133[0]: i2c xfer: < 10 43 [fe quirk] < 11 =3D03 >
[  421.448035] saa7133[0]: i2c xfer: < 10 43 03 >
[  421.472043] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  421.480037] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  421.488376] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  421.496719] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  421.604146] saa7133[0]: i2c xfer: < 10 06 [fe quirk] < 11 =3Db0 >
[  421.612028] saa7133[0]: i2c xfer: < 10 22 [fe quirk] < 11 =3Dff >
[  421.620039] saa7133[0]: i2c xfer: < 10 21 [fe quirk] < 11 =3Dff >
[  421.628032] saa7133[0]: i2c xfer: < 10 20 [fe quirk] < 11 =3Dff >
[  422.272024] saa7133[0]: i2c xfer: < 96 21 c0 >
[  422.304025] saa7133[0]: i2c xfer: < 96 21 c0 >
[  422.336023] saa7133[0]: i2c xfer: < c2 30 d0 >
[  422.350781] saa7133[0]: i2c xfer: < 96 21 80 >
[  422.380032] saa7133[0]: i2c xfer: < 96 21 80 >
[  422.420025] saa7133[0]: i2c xfer: < 10 3b ff >
[  422.428029] saa7133[0]: i2c xfer: < 10 3d [fe quirk] < 11 =3D68 >
[  422.436027] saa7133[0]: i2c xfer: < 10 3d 68 >
[  422.444020] saa7133[0]: i2c xfer: < 10 37 [fe quirk] < 11 =3D38 >
[  422.452031] saa7133[0]: i2c xfer: < 10 37 f8 >
[  422.460031] saa7133[0]: i2c xfer: < 10 07 [fe quirk] < 11 =3D80 >
[  422.468021] saa7133[0]: i2c xfer: < 10 07 81 >


--------------090301050308040200040802--
