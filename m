Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1Jl5h9-00072e-T0
	for linux-dvb@linuxtv.org; Sun, 13 Apr 2008 19:08:55 +0200
Message-ID: <48023E17.1070103@iinet.net.au>
Date: Mon, 14 Apr 2008 01:08:39 +0800
From: timf <timf@iinet.net.au>
MIME-Version: 1.0
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
References: <47FE3ECC.8020209@iinet.net.au>	<47FE8FD1.3050004@t-online.de>	<1207870241.17744.8.camel@pc08.localdom.local>	<47FFA5C5.7000704@iinet.net.au>	<47FFE2CC.3090405@t-online.de>	<4801A18D.3090401@iinet.net.au>
	<4801BD4D.7090708@iinet.net.au> <48022CB7.1040006@iinet.net.au>
In-Reply-To: <48022CB7.1040006@iinet.net.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Kworld DVB-T 210 - dvb tuning problem
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

timf wrote:
> timf wrote:
>   
>> timf wrote:
>>   
>>     
>>> Hartmut Hackmann wrote:
>>>   
>>>     
>>>       
>>>> Hi, Tim
>>>>
>>>> timf schrieb:
>>>>     
>>>>       
>>>>         
>>>>> hermann pitton wrote:
>>>>>       
>>>>>         
>>>>>           
>>>>>> Am Freitag, den 11.04.2008, 00:08 +0200 schrieb Hartmut Hackmann:
>>>>>>  
>>>>>>         
>>>>>>           
>>>>>>             
>>>>>>> HI, Tim
>>>>>>>
>>>>>>> timf schrieb:
>>>>>>>   
>>>>>>>           
>>>>>>>             
>>>>>>>               
>>>>>>>> Hi Hartmut,
>>>>>>>> OK, found some more spare time, but very, very frustrated!
>>>>>>>>
>>>>>>>> 1) Tried ubuntu 7.04, 7.10, 8.04
>>>>>>>>     Tried with just modules that exist in kernel (no v4l-dvb)
>>>>>>>>    Tried v4l-dvb from June 2007 and tried current v4l-dvb
>>>>>>>>    Tried with/without Hartmut patch - changeset 7376    49ba58715fe0
>>>>>>>>    Tried with .gpio_config   = TDA10046_GP11_I, or .gpio_config   
>>>>>>>> = TDA10046_GP01_I,
>>>>>>>>    Tried using configs in saa7134-dvb.c matching tiger, tiger_s, 
>>>>>>>> pinnacle 310i, twinhan 3056
>>>>>>>>
>>>>>>>>     # Australia / Perth (Roleystone transmitter)
>>>>>>>>     # T freq bw fec_hi fec_lo mod transmission-mode guard-interval 
>>>>>>>> hierarchy
>>>>>>>>     # SBS
>>>>>>>>     T 704500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
>>>>>>>>     # ABC
>>>>>>>>     T 725500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>>>>>>>     # Seven
>>>>>>>>     T 746500000 7MHz 2/3 NONE QAM64 8k 1/16 NONE
>>>>>>>>     # Nine
>>>>>>>>     T 767500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>>>>>>>     # Ten
>>>>>>>>     T 788500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>>>>>>>
>>>>>>>> 2) I have these saa7134 cards:
>>>>>>>>     - pinnacle 310i
>>>>>>>>     - kworld 210
>>>>>>>>
>>>>>>>>     This cx88 card:
>>>>>>>>     - dvico DVB-T Pro hybrid (analog tv not work)
>>>>>>>>
>>>>>>>> -   problem only occurs with kworld 210 in linux (works fine in 
>>>>>>>> WinXP)
>>>>>>>>
>>>>>>>> 3) In WinXP, all channels, both analog tv and dvb-t found
>>>>>>>>
>>>>>>>> 4) In linux, if start dvb-t first, never scans SBS - dmesg1
>>>>>>>>
>>>>>>>> 5) In linux, if start analog tv first, stop, then start dvb-t, 
>>>>>>>> scan finds SBS - dmesg2
>>>>>>>>
>>>>>>>>       
>>>>>>>>             
>>>>>>>>               
>>>>>>>>                 
>>>>>>> a) The pinnacle 310i finds everything?
>>>>>>>     It has the same chipset, but an almost perfectly handled tuner 
>>>>>>> chip...
>>>>>>>     This means that your initial config file is ok...
>>>>>>> b) Does this mean that in case 4, all other channels are found?
>>>>>>> c) Case 5: This finds everything?
>>>>>>> d) What happens if you use the scan data of the pinnacle card?
>>>>>>>     Does it tune SBS? Does it just take more time to stabilize?
>>>>>>>     This can be understood.
>>>>>>> e) Just to be sure: did you clarify the open point with 
>>>>>>> .antenna_switch
>>>>>>>     (i think so)
>>>>>>> f) the kernel logs are as expected.
>>>>>>> <snip>
>>>>>>>
>>>>>>>
>>>>>>>   
>>>>>>>           
>>>>>>>             
>>>>>>>               
>>>>>>>> 6) Herman mentioned something called a "mode-switch" in the 
>>>>>>>> archives, but not any description.
>>>>>>>>       
>>>>>>>>             
>>>>>>>>               
>>>>>>>>                 
>>>>>>> I guess he meant the switching between analog, radio and dvb-t. 
>>>>>>> This is the
>>>>>>> GPIO handling and card depending.
>>>>>>>     
>>>>>>>           
>>>>>>>             
>>>>>>>               
>>>>>> Tim must have it from when I mentioned the special case of card=87 and
>>>>>> 94.
>>>>>>
>>>>>>  
>>>>>>         
>>>>>>           
>>>>>>             
>>>>>>>> I tried to find some data sheets for tda8275 tda8290 but only 
>>>>>>>> found the publicity pdf file from Phillips,
>>>>>>>> so at least I can see they go together, so I presume this 
>>>>>>>> "mode-switch" is coded into those modules.
>>>>>>>> But those modules work for all other cards, so now I'm lost again.
>>>>>>>>
>>>>>>>> What else should I try?
>>>>>>>>
>>>>>>>>       
>>>>>>>>             
>>>>>>>>               
>>>>>>>>                 
>>>>>>> If my assumptions above are wrong, there is one other chance:
>>>>>>> Recently i saw another card that does the (unusual) mode switching
>>>>>>> like card 87. So to be sure, you might try to force this card type (be
>>>>>>> aware of the antenna inputs, if in doubt, try both.
>>>>>>>
>>>>>>> Best regards
>>>>>>>    Hartmut
>>>>>>>
>>>>>>>     
>>>>>>>           
>>>>>>>             
>>>>>>>               
>>>>>> For the Medion8800 Quad and CTX948 also showing this issue, needs to
>>>>>> tune analog first to have good recepton on DVB-T, they are a little
>>>>>> weaker on analog than other cards, but after that on DVB-T, they are as
>>>>>> good than known good others.
>>>>>>
>>>>>> Cheers,
>>>>>> Hermann
>>>>>>
>>>>>>
>>>>>>   
>>>>>>         
>>>>>>           
>>>>>>             
>>>>> Hi Hartmut and Hermann,
>>>>>
>>>>> a) The pinnacle 310i finds everything?
>>>>>    It has the same chipset, but an almost perfectly handled tuner 
>>>>> chip...
>>>>>    This means that your initial config file is ok...
>>>>>
>>>>> Answer - Yes, the non-working remote (and constant unknown key 
>>>>> messages) is all that is
>>>>> wrong with the pinnacle 310i.
>>>>> I tested it for your new tda8290 tda8275 patches - didn't I send you 
>>>>> the results?
>>>>> It works fine!
>>>>>
>>>>> b) Does this mean that in case 4, all other channels are found?
>>>>>
>>>>> Answer - In linux, if start dvb-t first, never scans SBS
>>>>>     - yes all other channels are viewable/scannable.
>>>>>
>>>>> c) Case 5: This finds everything?
>>>>>
>>>>> Answer - In linux, if start analog tv first, stop, then start dvb-t, 
>>>>> scan finds SBS
>>>>>     - yes all channels are viewable/scannable.
>>>>>
>>>>> d) What happens if you use the scan data of the pinnacle card?
>>>>>    Does it tune SBS? Does it just take more time to stabilize?
>>>>>    This can be understood.
>>>>>
>>>>> Answer - the same answer applies as for b) and c)
>>>>>
>>>>> e) Just to be sure: did you clarify the open point with .antenna_switch
>>>>>    (i think so)
>>>>>
>>>>> Answer - yes that was me being over-enthusiastic - made no difference
>>>>> as you pointed out.
>>>>>
>>>>>
>>>>> OK, this modification has achieved, I think success. I can now 
>>>>> view/scan all channels
>>>>> in analog tv or dvb-t in either order.
>>>>> That is, I now don't have to start analog tv first, before dvb-t will 
>>>>> start.
>>>>>
>>>>> In saa7134- cards.c - no change.
>>>>>
>>>>> In saa7134-dvb.c:
>>>>>
>>>>> Remove this:
>>>>> ------------------------------------
>>>>> static struct tda1004x_config kworld_dvb_t_210_config = {
>>>>>    .demod_address = 0x08,
>>>>>    .invert        = 1,
>>>>>    .invert_oclk   = 0,
>>>>>    .xtal_freq     = TDA10046_XTAL_16M,
>>>>>    .agc_config    = TDA10046_AGC_TDA827X,
>>>>>    .gpio_config   = TDA10046_GP11_I,
>>>>>    .if_freq       = TDA10046_FREQ_045,
>>>>>    .i2c_gate      = 0x4b,
>>>>>    .tuner_address = 0x61,
>>>>>    .antenna_switch= 1,
>>>>>    .request_firmware = philips_tda1004x_request_firmware
>>>>> };
>>>>> ------------------------------
>>>>>
>>>>> Add this:
>>>>>
>>>>> ------------------------------
>>>>> static int kw210_tuner_init(struct dvb_frontend *fe)
>>>>> {
>>>>>    struct saa7134_dev *dev = fe->dvb->priv;
>>>>>    philips_tda827x_tuner_init(fe);
>>>>>    /* route TDA8275a AGC input to the channel decoder */
>>>>>    saa7134_set_gpio(dev, 22, 1);
>>>>>    return 0;
>>>>> }
>>>>>
>>>>> static int kw210_tuner_sleep(struct dvb_frontend *fe)
>>>>> {
>>>>>    struct saa7134_dev *dev = fe->dvb->priv;
>>>>>    /* route TDA8275a AGC input to the analog IF chip*/
>>>>>    saa7134_set_gpio(dev, 22, 0);
>>>>>    philips_tda827x_tuner_sleep(fe);
>>>>>    return 0;
>>>>> }
>>>>>
>>>>> static struct tda827x_config kw210_cfg = {
>>>>>    .tuner_callback = saa7134_tuner_callback,
>>>>>    .init = kw210_tuner_init,
>>>>>    .sleep = kw210_tuner_sleep,
>>>>>    .config = 0
>>>>> };
>>>>>
>>>>> static struct tda1004x_config kworld_dvb_t_210_config = {
>>>>>    .demod_address = 0x08,
>>>>>    .invert        = 1,
>>>>>    .invert_oclk   = 0,
>>>>>    .xtal_freq     = TDA10046_XTAL_16M,
>>>>>    .agc_config    = TDA10046_AGC_TDA827X,
>>>>>    .gpio_config   = TDA10046_GP11_I,
>>>>>    .if_freq       = TDA10046_FREQ_045,
>>>>>    .tuner_address = 0x61,
>>>>>    .request_firmware = philips_tda1004x_request_firmware
>>>>> };
>>>>> ----------------------------
>>>>>
>>>>> Change this:
>>>>>
>>>>>    case SAA7134_BOARD_KWORLD_DVBT_210:
>>>>>        dev->dvb.frontend = dvb_attach(tda10046_attach, 
>>>>> &kworld_dvb_t_210_config, &dev->i2c_adap);
>>>>>        if (dev->dvb.frontend) {
>>>>>            if (dvb_attach(tda827x_attach,dev->dvb.frontend,
>>>>>                   kworld_dvb_t_210_config.tuner_address, &dev->i2c_adap,
>>>>>                                &kw210_cfg) == NULL) {
>>>>>                wprintk("no tda827x tuner found at addr: %02x\n",
>>>>>                    kworld_dvb_t_210_config.tuner_address);
>>>>>            }
>>>>>        }
>>>>>        break;
>>>>> ---------------------------------------------
>>>>>
>>>>> However, I need you to explain something for me.
>>>>>
>>>>> There is no difference if I use this:
>>>>>
>>>>>    saa7134_set_gpio(dev, 22, 1);
>>>>>
>>>>> or this:
>>>>>
>>>>>    saa7134_set_gpio(dev, 21, 1);
>>>>>
>>>>> I await your guidance, meanwhile I shall apply my
>>>>> modification to enable the remote and ensure it
>>>>> doesn't have any effect.
>>>>>
>>>>> Many thanks to you both,
>>>>>
>>>>> Regards,
>>>>> Tim
>>>>>
>>>>>       
>>>>>         
>>>>>           
>>>> Again progress, excellent!
>>>> I think we will need one further interation. If i go through your
>>>> changes and comments, i come to the opinion that we will get the same
>>>> with less changes. But if i understand this right, its astonishing 
>>>> that your
>>>> card worked a bit. But let me go through your last patch again tomorrow -
>>>> i am too tired now.
>>>>
>>>> Best regards
>>>>   Hartmut
>>>>
>>>>     
>>>>       
>>>>         
>>> Hi Hartmut,
>>>
>>> I was wrong:
>>>
>>> ->There is no difference if I use this:
>>>
>>> ->   saa7134_set_gpio(dev, 22, 1);
>>>
>>> ->or this:
>>>
>>> ->   saa7134_set_gpio(dev, 21, 1);
>>>
>>> This is wrong.
>>> It only works at all when it is this:   saa7134_set_gpio(dev, 22, 1);
>>>
>>> With this:   saa7134_set_gpio(dev, 21, 1); it does not scan anything at all.
>>>
>>> I proved this out by modifying the source, rebuild v4l-dvb,
>>> and then instead of rebooting, I power-cycled each time.
>>>
>>>
>>> There are 2 problems here:
>>> 1) With no modification, I must switch to analog tv before I can switch 
>>> to dvb-t.
>>>     If I am using Kaffeine, and then wish to use Me-tv, I must view 
>>> analog tv
>>>     in between.
>>>
>>> 2) With no modification, dvb-t will not scan SBS unless analog tv viewed 
>>> first.
>>>
>>>
>>> With this modification, both problems vanish.
>>>
>>> I have not yet tested radio.
>>>
>>> Regards,
>>> Tim
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>
>>>   
>>>     
>>>       
>> Hi Hartmut,
>>
>> OK, tried to test radio with gradio, can't get any frequency to lock.
>>
>> Now, switching to radio then causes analog tv to have a very weak signal 
>> - only 1 channel will scan with very noisy picture.
>>
>> Then need to power-cycle to revert to good system.
>>
>>  From syslog:
>> Apr 13 14:15:47 ubuntu kernel: [ 3863.073092] tda829x 0-004b: tda8290 
>> not locked, no signal?
>> Apr 13 14:15:47 ubuntu kernel: [ 3863.193072] tda829x 0-004b: tda8290 
>> not locked, no signal?
>> Apr 13 14:15:47 ubuntu kernel: [ 3863.297056] tda829x 0-004b: adjust 
>> gain, step 1. Agc: 0, ADC stat: 0, lock: 0
>> Apr 13 14:15:47 ubuntu kernel: [ 3863.441033] tda829x 0-004b: adjust 
>> gain, step 2. Agc: 204, lock: 0
>> Apr 13 14:15:47 ubuntu kernel: [ 3863.585010] tda829x 0-004b: adjust 
>> gain, step 3. Agc: 123
>> Apr 13 14:15:47 ubuntu kernel: [ 3863.721163] tuner' 0-004b: Cmd 
>> VIDIOC_G_TUNER accepted for radio
>> Apr 13 14:15:48 ubuntu kernel: [ 3863.737067] tuner' 0-004b: Cmd 
>> VIDIOC_G_TUNER accepted for radio
>> Apr 13 14:15:48 ubuntu kernel: [ 3863.752986] tuner' 0-004b: Cmd 
>> VIDIOC_S_TUNER accepted for radio
>> Apr 13 14:15:48 ubuntu kernel: [ 3863.752990] tda829x 0-004b: setting 
>> tda829x to system B
>> Apr 13 14:15:48 ubuntu kernel: [ 3863.856965] tda827x: setting tda827x 
>> to system B
>> Apr 13 14:15:48 ubuntu kernel: [ 3863.912956] tda827x: AGC2 gain is: 10
>> Apr 13 14:15:48 ubuntu kernel: [ 3864.240905] tda829x 0-004b: tda8290 
>> not locked, no signal?
>> Apr 13 14:15:48 ubuntu kernel: [ 3864.360885] tda829x 0-004b: tda8290 
>> not locked, no signal?
>> Apr 13 14:15:48 ubuntu kernel: [ 3864.480865] tda829x 0-004b: tda8290 
>> not locked, no signal?
>> Apr 13 14:15:48 ubuntu kernel: [ 3864.584849] tda829x 0-004b: adjust 
>> gain, step 1. Agc: 0, ADC stat: 0, lock: 0
>> Apr 13 14:15:48 ubuntu kernel: [ 3864.728828] tda829x 0-004b: adjust 
>> gain, step 2. Agc: 209, lock: 0
>> Apr 13 14:15:49 ubuntu kernel: [ 3864.872802] tda829x 0-004b: adjust 
>> gain, step 3. Agc: 129
>> Apr 13 14:17:08 ubuntu kernel: [ 3944.108802] tuner' 0-004b: Cmd 
>> VIDIOC_G_TUNER accepted for radio
>> Apr 13 14:17:08 ubuntu kernel: [ 3944.132069] tuner' 0-004b: Cmd 
>> VIDIOC_G_TUNER accepted for radio
>>
>> -> I know the local FM station is 107.3MHz and can tune it in with WinXP
>>
>> Apr 13 14:17:08 ubuntu kernel: [ 3944.148049] tuner' 0-004b: radio freq 
>> set to 107.30
>> Apr 13 14:17:08 ubuntu kernel: [ 3944.148054] tda829x 0-004b: setting 
>> tda829x to system B
>> Apr 13 14:17:08 ubuntu kernel: [ 3944.256024] tda827x: setting tda827x 
>> to system B
>> Apr 13 14:17:08 ubuntu kernel: [ 3944.324013] tda827x: AGC2 gain is: 10
>> Apr 13 14:17:08 ubuntu kernel: [ 3944.651961] tda829x 0-004b: tda8290 
>> not locked, no signal?
>> Apr 13 14:17:09 ubuntu kernel: [ 3944.771941] tda829x 0-004b: tda8290 
>> not locked, no signal?
>> Apr 13 14:17:09 ubuntu kernel: [ 3944.891922] tda829x 0-004b: tda8290 
>> not locked, no signal?
>> Apr 13 14:17:09 ubuntu kernel: [ 3944.995906] tda829x 0-004b: adjust 
>> gain, step 1. Agc: 0, ADC stat: 0, lock: 0
>> Apr 13 14:17:09 ubuntu kernel: [ 3945.143884] tda829x 0-004b: adjust 
>> gain, step 2. Agc: 229, lock: 0
>> Apr 13 14:17:09 ubuntu kernel: [ 3945.291857] tda829x 0-004b: adjust 
>> gain, step 3. Agc: 149
>> Apr 13 14:17:09 ubuntu kernel: [ 3945.432058] tuner' 0-004b: Cmd 
>> VIDIOC_G_TUNER accepted for radio
>> Apr 13 14:17:09 ubuntu kernel: [ 3945.451896] tuner' 0-004b: Cmd 
>> VIDIOC_G_TUNER accepted for radio
>> Apr 13 14:17:09 ubuntu kernel: [ 3945.467841] tuner' 0-004b: Cmd 
>> VIDIOC_S_TUNER accepted for radio
>> Apr 13 14:17:09 ubuntu kernel: [ 3945.467845] tda829x 0-004b: setting 
>> tda829x to system B
>> Apr 13 14:17:09 ubuntu kernel: [ 3945.575812] tda827x: setting tda827x 
>> to system B
>> Apr 13 14:17:09 ubuntu kernel: [ 3945.643801] tda827x: AGC2 gain is: 10
>> Apr 13 14:17:10 ubuntu kernel: [ 3945.971749] tda829x 0-004b: tda8290 
>> not locked, no signal?
>> Apr 13 14:17:10 ubuntu kernel: [ 3946.091729] tda829x 0-004b: tda8290 
>> not locked, no signal?
>> Apr 13 14:17:10 ubuntu kernel: [ 3946.211710] tda829x 0-004b: tda8290 
>> not locked, no signal?
>> Apr 13 14:17:10 ubuntu kernel: [ 3946.315694] tda829x 0-004b: adjust 
>> gain, step 1. Agc: 0, ADC stat: 0, lock: 0
>> Apr 13 14:17:10 ubuntu kernel: [ 3946.463670] tda829x 0-004b: adjust 
>> gain, step 2. Agc: 231, lock: 0
>> Apr 13 14:17:10 ubuntu kernel: [ 3946.611645] tda829x 0-004b: adjust 
>> gain, step 3. Agc: 150
>> Apr 13 14:17:20 ubuntu kernel: [ 3956.031282] tuner' 0-004b: Cmd 
>> VIDIOC_G_TUNER accepted for radio
>> Apr 13 14:17:20 ubuntu kernel: [ 3956.046878] tuner' 0-004b: Cmd 
>> VIDIOC_G_TUNER accepted for radio
>>
>>
>> So, the radio config isn't correct.
>>
>> I'll keep digging.
>>
>> Regards,
>> Tim
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>   
>>     
> Hi Hartmut,
> OK, I'll send you this info that I think I have worked out so far:
>
> .gpiomask = 1 << 21, is equivalent to:
> GPIO 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
> gpiomask 0x00200000 = 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
>
> from syslog:
>
> Apr 13 22:31:56 ubuntu kernel: [ 148.955428] tda1004x: setting up plls 
> for 48MHz sampling clock
> Apr 13 22:31:56 ubuntu kernel: [ 149.239381] tda1004x: found firmware 
> revision 29 -- ok
> Apr 13 22:31:57 ubuntu kernel: [ 149.431357] tda827x: tda827x_init:
> Apr 13 22:31:57 ubuntu kernel: [ 149.431365] saa7133[0]/core: setting 
> GPIO22 to static 1
> Apr 13 22:32:00 ubuntu kernel: [ 153.155969] tda827x: tda827xa_set_params:
> Apr 13 22:32:01 ubuntu kernel: [ 153.387931] tda827x: tda8275a AGC2 gain 
> is: 7
>
>
> Apr 13 22:32:08 ubuntu kernel: [ 160.737003] saa7133[0]/core: setting 
> GPIO22 to static 0
> Apr 13 22:35:28 ubuntu ntpd[5532]: Listening on interface #6 eth0, 
> fe80::21b:fcff:feb3:8532#123 Enabled
> Apr 13 22:35:28 ubuntu ntpd[5532]: Listening on interface #7 eth0, 
> 10.1.1.5#123 Enabled
> Apr 13 22:47:11 ubuntu kernel: [ 1063.436570] tuner' 0-004b: Cmd 
> VIDIOC_S_STD accepted for analog TV
>
> Seems to be:
> GPIO22 = 1 for DVB-T
> GPIO22 = 0 for analog-tv
>
> What then for radio? Perhaps GPIO21 is radio?
> Try this:
> .gpiomask = 0 << 22
> GPIO 22 21 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
> gpiomask 0x00000000 = 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> Should give start with analog-tv = on; radio =off
> .gpio = 0x00200000, for radio on (GPIO21 = 1)
> Result:
> No radio, but dvb-t, analog-tv is ok.
>
> My guess is that GPIO22 = 1 (dvb-t); = 0 (analog-tv, default)
> GPIO21 = 0 or 1 for radio
> But you would have to switch antenna from TV to radio via demux first?
> I can't see where/how to do that.
>
> It seems as if the gpiomask should be applied to GPIO22? Then how to 
> start radio?
>
> Regards,
> Tim
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   
Something I don't understand.

This card: KWORLD VS-DVBT210RF

Chips:
SAA7131E - video decoder
TDA10046A - DVB-T decoder
KS007 - remote controller
HC4052 - analog demux
24C02BN - eeprom
NXP 8275A - tuner

Now, other cards have something such as mt352 as an IF demod
I was under the impression that the 8275 went with an 8290 IF demod,
but there is no demod chip on this card.

How does that work?

The tuner on the Pinnacle 310i is under a metal shield, so I can't 
actually see it.

I'm just getting more confused - there has to be something for the IF stage!

Regards,
Tim

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
