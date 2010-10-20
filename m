Return-path: <mchehab@pedra>
Received: from blu0-omc2-s35.blu0.hotmail.com ([65.55.111.110]:38302 "EHLO
	blu0-omc2-s35.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753354Ab0JTQZY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 12:25:24 -0400
Message-ID: <BLU0-SMTP3076739B1A745CCB3563D3A75C0@phx.gbl>
Date: Wed, 20 Oct 2010 11:19:12 -0500
From: Daniel Lee Kim <danlkim@hotmail.com>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: cx23885 module
References: <BLU0-SMTP179D180C75C88F1B693AA73A75A0@phx.gbl> <4CBE0D47.7080201@kernellabs.com>
In-Reply-To: <4CBE0D47.7080201@kernellabs.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thank you, Steve, for introducing me to the mailing list and showing me 
the protocol.  I have taken a look at your questions and comments.  My 
responses are interspersed in the email below

On 10/19/2010 04:27 PM, Steven Toth wrote:
> Hi Dan,
>
> Thanks for writing.
>
> I can't do one-on-one end user support without copying in the Linux 
> Media mailing list. I'm taking the liberty of doing so. Please 
> reply-all when discussing this issue - so everyone can benefit.
>
> [Dan is having issues being up an AverMedia board with a LG demod and 
> a MT2131 tuner via the cx23885 driver]
>
>> However, I am having some trouble getting the tuner to be recognized. 
>> I was
>
> It's the GPIO probably holding the tuner in reset, I suspect your gpio 
> configuration is wrong. That's my first guess. What makes you think 
> the gpio settings in your patch are correct?

how do I find out the GPIO?  I was unable to find it in the 
ngene-cards.c file.  I have the AVer88xHD.inf file with me and it says 
the following:

----from AVer88xHD.inf----
;Enable TS capture and BDA filter registration
HKR,"DriverData","Enable_BDA",0x00010001, 0x01, 0x00, 0x00, 0x00
HKR,"DriverData","BDA_Demod_Tuner_type",0x00010001, 0x65, 0x00, 0x00, 0x00
HKR,"DriverData","DemodI2CAddress",0x00010001, 0xb2, 0x00, 0x00, 0x00
HKR,"DriverData","DigitalDemodI2CBus",0x00010001, 0x1, 0x00, 0x00, 0x00

; these registry keys for TS filter
; DebugTS entry forces creation of TS capture filter without a demod
;HKR,"DriverData","DebugTS",0x00010001, 0x01,0x00,0x00,0x00
; Next line enables the software TS packetizer
;HKR,"DriverData","dwIsTSStream",0x00010001,0x01,0x00,0x00,0x00

;IR Support
HKR,"DriverData","EnableIR",0x00010001, 0x00, 0x00, 0x00, 0x00
;NEC standard
HKR,"DriverData","IRStandard",0x00010001, 0x01, 0x00, 0x00, 0x00

; GPIO Pin values
; IMPORTANT !!! if any GPIO is not used - just delete the corresponding 
entry !!!
;HKR,"DriverData","comp_select_gpio_bit", 0x00010001, 0x00, 0x00, 0x00, 
0x00

; Back Panel = 0x00, Front Panel = 0x01
;HKR,"DriverData","comp_select_panel", 0x00010001, 0x00, 0x00, 0x00, 0x00

;Demod Comm mode : 0x00 = Serial, 0x01 = Parallel
HKR,"DriverData","DemodTransferMode",0x00010001, 0x00, 0x00, 0x00, 0x00

;BoardType M791ENC = 113
HKR,"DriverData","BoardType",0x00010001, 0x71, 0x00, 0x00, 0x00
HKR,"DriverData","ComboBoard",0x00010001, 0x01, 0x00, 0x00, 0x00

; XCeive 3028 = 100
HKR,"DriverData","TunerType",              0x00010001, 0x64, 0x00, 0x00, 
0x00
HKR,"DriverData","TunerI2CAddress",        0x00010001, 0xC2, 0x00, 0x00, 
0x00
HKR,"DriverData","TunerI2CBus",            0x00010001, 0x02, 0x00, 0x00, 
0x00
HKR,"DriverData","tuner_reset_gpio_bit",   0x00010001, 0x02, 0x00, 0x00, 
0x00
;HKR,"DriverData","tuner_sif_fm_gpio_bit",  0x00010001, 0x01, 0x00, 
0x00, 0x00

; MT2131            = 102
HKR,"DriverData","DigitalTunerType",       0x00010001, 0x66, 0x00, 0x00, 
0x00
HKR,"DriverData","DigitalTunerI2CAddress", 0x00010001, 0xC0, 0x00, 0x00, 
0x00
HKR,"DriverData","DigitalTunerI2CBus",     0x00010001, 0x01, 0x00, 0x00, 
0x00
HKR,"DriverData","demod_reset_gpio_bit",   0x00010001, 0x14, 0x00, 0x00, 
0x00
---end AVer88xHD.inf----

I'm not sure how to get the gpio from this?  Am I supposed to use 
0x00010001?
>
>> hoping that you might be willing to look over the code a bit to see 
>> what I am
>> missing. I have altered the following 3 files: cx23885.h, 
>> cx23885-cards.c, and
>> cx23885-dvb.c. I am attaching the 3 files in this email. I have been 
>> trying to
>> do 3 things. First, to have the module auto-detect my card which was 
>> successful.
>> Second, I wanted to attach the LGDT330X as my frontend which was 
>> successful.
>> Third, I wanted to attach the MT2131 tuner. This third step is where 
>> I am having
>> my troubles. I feel so close but I am not there yet. I know that you 
>> wrote the
>> code a while back but if you would be willing to help me, I'd really 
>> appreciate
>> it. Some folks have gotten the ngene module to work with the M780 
>> board which
>
> Yeah, I worked on the ngene with Devin as part of our KernelLabs.com 
> projects, we brought up the digital side of the card as a pre-test 
> while investigating ngene analog support.
>
> If the 2131 isn't attaching then it's because you think it's on a 
> different I2C bus, or the LG demod has it's I2C gate closed (unlikely) 
> or the tuner is not responding because it's being held in reset.
>
> Do you see the tuner if you perform and I2C scan (modprobe i2c_scan=1)?
>
When I run this, I can the following message:
FATAL: Module i2c_scan=1 not found.

However, running dmesg, I get the following:
[ 3072.274680] cx23885 driver version 0.0.2 loaded
[ 3072.274752] cx23885 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> 
IRQ 19
[ 3072.274970] CORE cx23885[0]: subsystem: 1461:d439, board: AVermedia 
M791 [card=29,autodetected]
[ 3072.605134] cx23885_dvb_register() allocating 1 frontend(s)
[ 3072.605189] cx23885[0]: cx23885 based dvb card
[ 3072.621974] MT2131: successfully identified at address 0x60
[ 3072.621981] DVB: registering new adapter (cx23885[0])
[ 3072.621986] DVB: registering adapter 0 frontend 0 (LG Electronics 
LGDT3303 VSB/QAM Frontend)...
[ 3072.622519] cx23885_dev_checkrevision() Hardware revision = 0xb1
[ 3072.622529] cx23885[0]/0: found at 0000:04:00.0, rev: 15, irq: 19, 
latency: 0, mmio: 0xea000000
[ 3072.622540] cx23885 0000:04:00.0: setting latency timer to 64
[ 3072.622546] IRQ 19/cx23885[0]: IRQF_DISABLED is not guaranteed on 
shared IRQs

so it does look like it has identified MT2131 as the tuner but is unable 
to work it.

Any further help would be greatly appreciated.

-Dan

