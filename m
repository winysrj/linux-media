Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout11.t-online.de ([194.25.134.85])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1JkRW7-0008Hv-Fe
	for linux-dvb@linuxtv.org; Sat, 12 Apr 2008 00:14:44 +0200
Message-ID: <47FFE2CC.3090405@t-online.de>
Date: Sat, 12 Apr 2008 00:14:36 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: timf <timf@iinet.net.au>
References: <47FE3ECC.8020209@iinet.net.au> <47FE8FD1.3050004@t-online.de>
	<1207870241.17744.8.camel@pc08.localdom.local>
	<47FFA5C5.7000704@iinet.net.au>
In-Reply-To: <47FFA5C5.7000704@iinet.net.au>
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

Hi, Tim

timf schrieb:
> hermann pitton wrote:
>> Am Freitag, den 11.04.2008, 00:08 +0200 schrieb Hartmut Hackmann:
>>  
>>> HI, Tim
>>>
>>> timf schrieb:
>>>    
>>>> Hi Hartmut,
>>>> OK, found some more spare time, but very, very frustrated!
>>>>
>>>> 1) Tried ubuntu 7.04, 7.10, 8.04
>>>>     Tried with just modules that exist in kernel (no v4l-dvb)
>>>>    Tried v4l-dvb from June 2007 and tried current v4l-dvb
>>>>    Tried with/without Hartmut patch - changeset 7376    49ba58715fe0
>>>>    Tried with .gpio_config   = TDA10046_GP11_I, or .gpio_config   = 
>>>> TDA10046_GP01_I,
>>>>    Tried using configs in saa7134-dvb.c matching tiger, tiger_s, 
>>>> pinnacle 310i, twinhan 3056
>>>>
>>>>     # Australia / Perth (Roleystone transmitter)
>>>>     # T freq bw fec_hi fec_lo mod transmission-mode guard-interval 
>>>> hierarchy
>>>>     # SBS
>>>>     T 704500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
>>>>     # ABC
>>>>     T 725500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>>>     # Seven
>>>>     T 746500000 7MHz 2/3 NONE QAM64 8k 1/16 NONE
>>>>     # Nine
>>>>     T 767500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>>>     # Ten
>>>>     T 788500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
>>>>
>>>> 2) I have these saa7134 cards:
>>>>     - pinnacle 310i
>>>>     - kworld 210
>>>>
>>>>     This cx88 card:
>>>>     - dvico DVB-T Pro hybrid (analog tv not work)
>>>>
>>>> -   problem only occurs with kworld 210 in linux (works fine in WinXP)
>>>>
>>>> 3) In WinXP, all channels, both analog tv and dvb-t found
>>>>
>>>> 4) In linux, if start dvb-t first, never scans SBS - dmesg1
>>>>
>>>> 5) In linux, if start analog tv first, stop, then start dvb-t, scan 
>>>> finds SBS - dmesg2
>>>>
>>>>       
>>> a) The pinnacle 310i finds everything?
>>>     It has the same chipset, but an almost perfectly handled tuner 
>>> chip...
>>>     This means that your initial config file is ok...
>>> b) Does this mean that in case 4, all other channels are found?
>>> c) Case 5: This finds everything?
>>> d) What happens if you use the scan data of the pinnacle card?
>>>     Does it tune SBS? Does it just take more time to stabilize?
>>>     This can be understood.
>>> e) Just to be sure: did you clarify the open point with .antenna_switch
>>>     (i think so)
>>> f) the kernel logs are as expected.
>>> <snip>
>>>
>>>
>>>    
>>>> 6) Herman mentioned something called a "mode-switch" in the 
>>>> archives, but not any description.
>>>>       
>>> I guess he meant the switching between analog, radio and dvb-t. This 
>>> is the
>>> GPIO handling and card depending.
>>>     
>>
>> Tim must have it from when I mentioned the special case of card=87 and
>> 94.
>>
>>  
>>>> I tried to find some data sheets for tda8275 tda8290 but only found 
>>>> the publicity pdf file from Phillips,
>>>> so at least I can see they go together, so I presume this 
>>>> "mode-switch" is coded into those modules.
>>>> But those modules work for all other cards, so now I'm lost again.
>>>>
>>>> What else should I try?
>>>>
>>>>       
>>> If my assumptions above are wrong, there is one other chance:
>>> Recently i saw another card that does the (unusual) mode switching
>>> like card 87. So to be sure, you might try to force this card type (be
>>> aware of the antenna inputs, if in doubt, try both.
>>>
>>> Best regards
>>>    Hartmut
>>>
>>>     
>>
>> For the Medion8800 Quad and CTX948 also showing this issue, needs to
>> tune analog first to have good recepton on DVB-T, they are a little
>> weaker on analog than other cards, but after that on DVB-T, they are as
>> good than known good others.
>>
>> Cheers,
>> Hermann
>>
>>
>>   
> Hi Hartmut and Hermann,
> 
> a) The pinnacle 310i finds everything?
>    It has the same chipset, but an almost perfectly handled tuner chip...
>    This means that your initial config file is ok...
> 
> Answer - Yes, the non-working remote (and constant unknown key messages) 
> is all that is
> wrong with the pinnacle 310i.
> I tested it for your new tda8290 tda8275 patches - didn't I send you the 
> results?
> It works fine!
> 
> b) Does this mean that in case 4, all other channels are found?
> 
> Answer - In linux, if start dvb-t first, never scans SBS
>     - yes all other channels are viewable/scannable.
> 
> c) Case 5: This finds everything?
> 
> Answer - In linux, if start analog tv first, stop, then start dvb-t, 
> scan finds SBS
>     - yes all channels are viewable/scannable.
> 
> d) What happens if you use the scan data of the pinnacle card?
>    Does it tune SBS? Does it just take more time to stabilize?
>    This can be understood.
> 
> Answer - the same answer applies as for b) and c)
> 
> e) Just to be sure: did you clarify the open point with .antenna_switch
>    (i think so)
> 
> Answer - yes that was me being over-enthusiastic - made no difference
> as you pointed out.
> 
> 
> OK, this modification has achieved, I think success. I can now view/scan 
> all channels
> in analog tv or dvb-t in either order.
> That is, I now don't have to start analog tv first, before dvb-t will 
> start.
> 
> In saa7134- cards.c - no change.
> 
> In saa7134-dvb.c:
> 
> Remove this:
> ------------------------------------
> static struct tda1004x_config kworld_dvb_t_210_config = {
>    .demod_address = 0x08,
>    .invert        = 1,
>    .invert_oclk   = 0,
>    .xtal_freq     = TDA10046_XTAL_16M,
>    .agc_config    = TDA10046_AGC_TDA827X,
>    .gpio_config   = TDA10046_GP11_I,
>    .if_freq       = TDA10046_FREQ_045,
>    .i2c_gate      = 0x4b,
>    .tuner_address = 0x61,
>    .antenna_switch= 1,
>    .request_firmware = philips_tda1004x_request_firmware
> };
> ------------------------------
> 
> Add this:
> 
> ------------------------------
> static int kw210_tuner_init(struct dvb_frontend *fe)
> {
>    struct saa7134_dev *dev = fe->dvb->priv;
>    philips_tda827x_tuner_init(fe);
>    /* route TDA8275a AGC input to the channel decoder */
>    saa7134_set_gpio(dev, 22, 1);
>    return 0;
> }
> 
> static int kw210_tuner_sleep(struct dvb_frontend *fe)
> {
>    struct saa7134_dev *dev = fe->dvb->priv;
>    /* route TDA8275a AGC input to the analog IF chip*/
>    saa7134_set_gpio(dev, 22, 0);
>    philips_tda827x_tuner_sleep(fe);
>    return 0;
> }
> 
> static struct tda827x_config kw210_cfg = {
>    .tuner_callback = saa7134_tuner_callback,
>    .init = kw210_tuner_init,
>    .sleep = kw210_tuner_sleep,
>    .config = 0
> };
> 
> static struct tda1004x_config kworld_dvb_t_210_config = {
>    .demod_address = 0x08,
>    .invert        = 1,
>    .invert_oclk   = 0,
>    .xtal_freq     = TDA10046_XTAL_16M,
>    .agc_config    = TDA10046_AGC_TDA827X,
>    .gpio_config   = TDA10046_GP11_I,
>    .if_freq       = TDA10046_FREQ_045,
>    .tuner_address = 0x61,
>    .request_firmware = philips_tda1004x_request_firmware
> };
> ----------------------------
> 
> Change this:
> 
>    case SAA7134_BOARD_KWORLD_DVBT_210:
>        dev->dvb.frontend = dvb_attach(tda10046_attach, 
> &kworld_dvb_t_210_config, &dev->i2c_adap);
>        if (dev->dvb.frontend) {
>            if (dvb_attach(tda827x_attach,dev->dvb.frontend,
>                   kworld_dvb_t_210_config.tuner_address, &dev->i2c_adap,
>                                &kw210_cfg) == NULL) {
>                wprintk("no tda827x tuner found at addr: %02x\n",
>                    kworld_dvb_t_210_config.tuner_address);
>            }
>        }
>        break;
> ---------------------------------------------
> 
> However, I need you to explain something for me.
> 
> There is no difference if I use this:
> 
>    saa7134_set_gpio(dev, 22, 1);
> 
> or this:
> 
>    saa7134_set_gpio(dev, 21, 1);
> 
> I await your guidance, meanwhile I shall apply my
> modification to enable the remote and ensure it
> doesn't have any effect.
> 
> Many thanks to you both,
> 
> Regards,
> Tim
> 
Again progress, excellent!
I think we will need one further interation. If i go through your
changes and comments, i come to the opinion that we will get the same
with less changes. But if i understand this right, its astonishing that your
card worked a bit. But let me go through your last patch again tomorrow -
i am too tired now.

Best regards
   Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
