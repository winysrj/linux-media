Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o08MvFnH030478
	for <video4linux-list@redhat.com>; Fri, 8 Jan 2010 17:57:16 -0500
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.7])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o08MuwcC010365
	for <video4linux-list@redhat.com>; Fri, 8 Jan 2010 17:56:59 -0500
Message-ID: <4B47B836.3000108@wp.pl>
Date: Fri, 08 Jan 2010 23:56:54 +0100
From: dz-tor <dz-tor@wp.pl>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
Subject: Re: Leadtek Winfast TV2100
References: <4B40B9CC.1040108@wp.pl>
	<1262979242.3246.10.camel@pc07.localdom.local>
In-Reply-To: <1262979242.3246.10.camel@pc07.localdom.local>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

My friend helped me a little and we managed card to work, i.e. TV (only 
mono, I suppose that stereo is not available for this card), s-video, 
composite and radio works fine.

We've tried setting audio_clock to both values (32.11 MHz -> 
.audio_clock=0x187de7 and 24.576MHz -> .audio_clock=0x200000) and both 
works - for me it seems, that for 32.11 MHz sound is better (i.e. louder).

Now I have only one problem with ir. We succeeded to enable it, but 
reading from it is bit weird - sometimes when I press the key, no event 
is generated, sometimes 2 (key pressed/released) and sometimes more. 
Have any clue what can cause that?

Output from dmesg when module is loaded:
[32627.844221] saa7130/34: v4l2 driver version 0.2.15 loaded
[32627.844294] saa7130[0]: found at 0000:01:09.0, rev: 1, irq: 17, 
latency: 32, mmio: 0xe7001000
[32627.844303] saa7130[0]: subsystem: 107d:6f3a, board: Proteus Pro 
[philips reference design] [card=1,insmod option]
[32627.844340] saa7130[0]: board init: gpio is 60a08
[32627.844351] saa7130[0]: gpio: mode=0x0000000 in=0x0060a0c 
out=0x0000000 [pre-init]
[32627.844901] input: saa7134 IR (Proteus Pro [philip as 
/devices/pci0000:00/0000:00:08.0/0000:01:09.0/input/input15
[32627.845064] IRQ 17/saa7130[0]: IRQF_DISABLED is not guaranteed on 
shared IRQs
[32628.028017] saa7130[0]: i2c eeprom 00: 7d 10 3a 6f 54 20 1c 00 43 43 
a9 1c 55 d2 b2 92
[32628.028029] saa7130[0]: i2c eeprom 10: 0c ff 82 0e ff 20 ff ff ff ff 
ff ff ff ff ff ff
[32628.028038] saa7130[0]: i2c eeprom 20: 01 40 02 03 03 02 01 03 08 ff 
00 8c ff ff ff ff
[32628.028047] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[32628.028056] saa7130[0]: i2c eeprom 40: 50 89 00 c2 00 00 02 30 02 ff 
ff ff ff ff ff ff
[32628.028064] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[32628.028073] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[32628.028082] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[32628.028091] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[32628.028099] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[32628.028108] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[32628.028117] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[32628.028126] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[32628.028134] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[32628.028143] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[32628.028152] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[32628.028163] i2c i2c-2: Invalid 7-bit address 0x7a
[32628.036120] tuner 2-0061: chip found @ 0xc2 (saa7130[0])
[32628.044037] tuner-simple 2-0061: creating new instance
[32628.044044] tuner-simple 2-0061: type set to 69 (Tena TNF 5335 and 
similar models)
[32628.052058] saa7130[0]: gpio: mode=0x000000d in=0x0060a00 
out=0x0000008 [mute]
[32628.052178] saa7130[0]: registered device video1 [v4l2]
[32628.052205] saa7130[0]: registered device vbi0
[32628.052232] saa7130[0]: registered device radio0


For testing we've used existing card (card=1 - Proteus Pro) with tuner 
69. When everything will be working ok, my friend will try to add new 
card definition and generate the patch. Below you can find actual code 
modified by us:

saa7134-cards.c
struct saa7134_board saa7134_boards[] = {
...
     [SAA7134_BOARD_PROTEUS_PRO] = {
         /* /me */
         .name        = "Proteus Pro [philips reference design]",
         .audio_clock    = 0x00187de7,
         .tuner_type    = TUNER_TNF_5335MF,
         .radio_type     = UNSET,
         .tuner_addr    = ADDR_UNSET,
         .radio_addr    = ADDR_UNSET,

         .gpiomask    = 0x0d,
         .inputs         = {{
             .name = name_comp1,
             .vmux = 3,
             .amux = LINE2,
             .gpio = 0x08,
         },{
             .name = name_tv,
             .vmux = 1,
             .amux = LINE1,
             .tv   = 1,
         },{
             .name = name_tv_mono,
             .vmux = 1,
             .amux = LINE1,
             .tv   = 1,
         },{
             .name = name_svideo,
             .vmux = 8,
             .amux = LINE2,
             .gpio = 0x08,
         }},
         .radio = {
             .name = name_radio,
             .amux = LINE1,
             .gpio = 0x04,
         },
         .mute = {
             .name = name_mute,
             .amux = TV,
             .gpio = 0x08,
         },
     },

int saa7134_board_init1(struct saa7134_dev *dev)
{
...
     case SAA7134_BOARD_PROTEUS_PRO:
         dev->has_remote = SAA7134_REMOTE_GPIO;
         break;


saa7134-input.c
int saa7134_input_init1(struct saa7134_dev *dev)
{
     case SAA7134_BOARD_PROTEUS_PRO:
         ir_codes     = &ir_codes_avermedia_table;
         mask_keycode = 0x000000;
         polling      = 50; // ms

Regards,
Darek

On 08.01.2010 20:34, hermann pitton wrote:
> Hi,
>
> Am Sonntag, den 03.01.2010, 16:37 +0100 schrieb dz-tor:
>    
>> Hi,
>>
>> I want to ask whether you are working on this 'issue'. I'm interested in
>> the subject, as I'm owner of this card and cannot get this stuff to work
>> - I've picture, no sound. Earlier you have written, that you can provide
>> patches for testing. If offer is still actual, I can test them.
>> Currently I'm using kernel 2.6.31, but if it's a problem I can switch to
>> 2.6.32.
>>
>> As I wrote earlier I have the same card - Winfast TV2100 with FM, tv
>> norm used in my country is PAL (I'm from Poland).
>>
>> Regards,
>> Darek
>>      
> please have a look at the xtal/oscillator close to the saa713x chip.
>
> It can have two different values. See README.saa7134 in Documentation.
>
> I'll provide a patch with best guessing based on the regspy.exe results
> then, assuming all is connected to LINE2 and routed through the external
> mux chip as a start. If that fails, we try with LINE1 next.
>
> Cheers,
> Hermann
>
>
>    
>>>        
>>>> Hey guys,
>>>>
>>>> Let me start by thanking you both for all your help. Unfortunately,
>>>> there isn't much I can do with the data you provided - it's way too
>>>> technical for me. I'd be happy to do any tests and apply any patches,
>>>> but I would need some instructions - but only if you have time; I
>>>> really don't want to burden you with this.
>>>>
>>>> Thanks again,
>>>>
>>>> Pavle.
>>>>
>>>>
>>>>
>>>> ________________________________
>>>> From: hermann pitton<hermann-pitton@arcor.de>
>>>> To: Terry Wu<terrywu2009@gmail.com>
>>>> Cc: pavle.predic@yahoo.co.uk; video4linux-list@redhat.com
>>>> Sent: Sat, 28 November, 2009 4:09:28
>>>> Subject: Re: Re: Leadtek Winfast TV2100
>>>>
>>>> Hi Terry Wu,
>>>>
>>>> Am Donnerstag, den 26.11.2009, 10:33 +0800 schrieb Terry Wu:
>>>>          
>>>>>   Hi,
>>>>>
>>>>>   Here are the subsystem IDs for different TV2100 models:
>>>>>       Subsystem ID:0x6f30107d, TVF8533-BDF (PAL BG/DK)
>>>>>       Subsystem ID:0x6f32107d, TVF5533-MF (NTSC)
>>>>>       Subsystem ID:0x6f3a107d, TVF88T5-B/DFF (PAL BG/DK, FM)
>>>>>
>>>>>   Terry
>>>>>            
>>>> better is to become active on it.
>>>>
>>>> we can most likely help about how to match such tuners fine,
>>>> if any doubts left, but the best is to send just patches with having
>>>> such hardware to test on.
>>>>
>>>> Compared to the early tda9887 stuff on LeadTek devices, LeadTek was
>>>> pioneering and we have that in mind, it should be fairly easy for those.
>>>>
>>>> Let's know the other way round too, where you have still concerns doing
>>>> so.
>>>>
>>>> Cheers,
>>>> Hermann
>>>>
>>>>          
>>>>>   2009/11/23 hermann pitton<hermann-pitton@arcor.de>:
>>>>>            
>>>>>>   Hi, thanks again!
>>>>>>
>>>>>>   Am Montag, den 23.11.2009, 09:42 +0800 schrieb Terry Wu:
>>>>>>              
>>>>>>>   Hi,
>>>>>>>
>>>>>>>       Please refer to the attached JPEG file for the GPIO
>>>>>>>                
>>>> settings of
>>>>          
>>>>>>>   TV2100 with FM (PCB:B).
>>>>>>>
>>>>>>>       Let me know if you need the information of TV2100 without FM
>>>>>>>   (PCB:A, TVF8533-BDF).
>>>>>>>
>>>>>>>   Terry Wu
>>>>>>>                
>>>>>>   On a first look, if we start to count gpios from zero, we tell
>>>>>>              
>>>> the same.
>>>>          
>>>>>>   The TVF8533_BDF I would have to look up. It is four to five
>>>>>>              
>>>> years back.
>>>>          
>>>>>>   If it uses that minor number TI chip without radio support, we
>>>>>>              
>>>> treat it
>>>>          
>>>>>>   as tuner=69 too currently.
>>>>>>
>>>>>>   For all such older can tuners, widely different about the globe,
>>>>>>              
>>>> counts,
>>>>          
>>>>>>   that we don't have any way to detect them. So first working,
>>>>>>              
>>>> either NTSC
>>>>          
>>>>>>   or PAL, sits in the pool position and others have to think twice.
>>>>>>
>>>>>>   OEMs do code tuners into eeprom content, some do not at all,
>>>>>>              
>>>> such doing
>>>>          
>>>>>>   it are in competition and don't follow the rules of the main chip
>>>>>>   manufacturer, Philips/NXP in that case, and go their own ways.
>>>>>>
>>>>>>   So tuner tables are unstable across manufacturers.
>>>>>>
>>>>>>   We often can't help that much in such cases, but implementing
>>>>>>              
>>>> their own
>>>>          
>>>>>>   tuner eeprom detection into the linux drivers is of course still
>>>>>>   welcome. Hauppauge does it very successfully since years.
>>>>>>
>>>>>>   We can't do much about it, if OEMs don't follow Philips or whom
>>>>>>              
>>>> ever on
>>>>          
>>>>>>   such.
>>>>>>
>>>>>>   Thanks,
>>>>>>   Hermann
>>>>>>
>>>>>>
>>>>>>              
>>>>>>>   2009/11/23 Terry Wu<terrywu2009@gmail.com>:
>>>>>>>                
>>>>>>>>   Hi,
>>>>>>>>
>>>>>>>>      The TVF88T5-BDFF data sheet is attached.
>>>>>>>>
>>>>>>>>   Terry Wu
>>>>>>>>
>>>>>>>>   11/17/2003  06:39 PM            72,010 TVF5531-MF.pdf
>>>>>>>>   03/12/2008  11:37 AM           555,285 TVF5533-MF-.pdf
>>>>>>>>   02/24/2004  02:19 PM           120,727 TVF5533-MF.pdf
>>>>>>>>   12/30/2003  06:59 PM            91,577 TVF5831-MFF.pdf
>>>>>>>>   09/26/2005  10:20 AM           156,853 TVF78P3-MFF.pdf
>>>>>>>>   11/17/2003  06:39 PM            67,947 TVF8531-BDF.pdf
>>>>>>>>   11/17/2003  06:39 PM            67,715 TVF8531-DIF.pdf
>>>>>>>>   03/12/2008  11:37 AM           509,340 TVF8533-BDF.pdf
>>>>>>>>   03/12/2008  11:37 AM           507,295 TVF8533-DIF.pdf
>>>>>>>>   12/30/2003  06:59 PM            87,921 TVF8831-BDFF.pdf
>>>>>>>>   12/30/2003  06:59 PM            87,624 TVF8831-DIFF.pdf
>>>>>>>>   09/26/2005  10:20 AM           176,525 TVF88P3-CFF.pdf
>>>>>>>>   03/24/2006  10:48 AM           460,941 TVF88T5-BDFF.pdf
>>>>>>>>   02/24/2004  02:19 PM           132,304 TVF9533-BDF.pdf
>>>>>>>>   02/24/2004  02:19 PM           120,940 TVF9533-DIF.pdf
>>>>>>>>   03/12/2008  11:37 AM           458,967 TVF99T5-BDFF.pdf
>>>>>>>>
>>>>>>>>                  
>>>>>>
>>>>>>
>>>>>>              
>>>>
>>>>          
>
>
>    

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
