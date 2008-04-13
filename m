Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout04.t-online.de ([194.25.134.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1JlB58-0002pp-14
	for linux-dvb@linuxtv.org; Mon, 14 Apr 2008 00:53:55 +0200
Message-ID: <48028EF9.6030209@t-online.de>
Date: Mon, 14 Apr 2008 00:53:45 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: timf <timf@iinet.net.au>
References: <47FE3ECC.8020209@iinet.net.au>	<47FE8FD1.3050004@t-online.de>	<1207870241.17744.8.camel@pc08.localdom.local>	<47FFA5C5.7000704@iinet.net.au>	<47FFE2CC.3090405@t-online.de>	<4801A18D.3090401@iinet.net.au>	<4801BD4D.7090708@iinet.net.au>
	<48022CB7.1040006@iinet.net.au> <48023E17.1070103@iinet.net.au>
	<4802576F.1070106@t-online.de> <48025E28.8020704@iinet.net.au>
	<48026BBB.5030201@t-online.de> <48027653.1000001@iinet.net.au>
	<48027E03.5010704@t-online.de> <48028513.5010208@iinet.net.au>
In-Reply-To: <48028513.5010208@iinet.net.au>
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

Hi

timf schrieb:
> Hartmut Hackmann wrote:
>> Hi,
>>
>> timf schrieb:
>>> Hartmut Hackmann wrote:
>>>> Hi, Tim
>>>> <snip>
>>>>>>
>>>>>> I think i know now how your card needs to be configured.
>>>>>> Something that seems not to be really clear for you is the 
>>>>>> configuration
>>>>>> of the so-called AGC (automatic gain control) of the tuner. This
>>>>>> needs to be switched according to the function the tuner is used for:
>>>>>> analog TV -> FM Radio -> DVB-T.
>>>>>> This is done with the 4052 analog mux and requires 2 control bits 
>>>>>> -> the GPIOs.
>>>>>> GPIO 21 is used to switch between analog TV and FM radio.
>>>>>> Typically GPIO21=0 -> analog TV, GPIO21=1 -> FM Radio.
>>>>>> In your case, GPIO22 is used to switch between DVB-T and analog 
>>>>>> while most cards
>>>>>> use GPIO1 of the tda10046 for this.
>>>>>>
>>>>>> You should need to make chages only in saa7134-dvb, dvb_init()
>>>>>> - remove the old
>>>>>>     case SAA7134_BOARD_KWORLD_DVBT_210: (plus code)
>>>>>> -and add it to
>>>>>>     case SAA7134_BOARD_FLYDVBT_HYBRID_CARDBUS:
>>>>>>
>>>>>> That should do it (though we should add a .antenna switch to the 
>>>>>> configuration).
>>>>>>
>>>>>> Best regards
>>>>>>   Hartmut
>>>>>>
>>>>> Hi Hartmut,
>>>>>
>>>>>
>>
>> <snip>
>>
>>> Hi Hartmut,
>>>
>>>
>>> 1) With    .gpio_config   = TDA10046_GP11_I,
>>>
>>> root@ubuntu:/home/timf# tzap -r "TEN HD"
>>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>> tuning to 788500000 Hz
>>> video pid 0x0202, audio pid 0x0000
>>> status 00 | signal 9d9d | snr 3333 | ber 0001fffe | unc 0000004d |
>>> status 1f | signal 9d9d | snr fdfd | ber 000001b8 | unc ffffffff | 
>>> FE_HAS_LOCK
>>> status 1f | signal 9c9c | snr fdfd | ber 000001de | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 9c9c | snr fefe | ber 0000017c | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 9c9c | snr fefe | ber 00000182 | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 9c9c | snr fefe | ber 000001a4 | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 9b9b | snr fefe | ber 00000202 | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 9b9b | snr fefe | ber 0000021c | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 9b9b | snr fefe | ber 00000226 | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 9c9c | snr fefe | ber 00000234 | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 9b9b | snr fefe | ber 00000290 | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 9b9b | snr fefe | ber 00000240 | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 9c9c | snr fefe | ber 000001fa | unc 00000000 | 
>>> FE_HAS_LOCK
>>>
>>> Analog-tv also scans fine.
>>>
>>
>> Things should look like this.
>>
>>> 2) With
>>> //    .gpio_config   = TDA10046_GP11_I,
>>>    .gpio_config   = TDA10046_GP00_I,
>>>
>>> timf@ubuntu:~$ sudo -s -H
>>> [sudo] password for timf:
>>> root@ubuntu:/home/timf# tzap -r "TEN HD"
>>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>> tuning to 788500000 Hz
>>> video pid 0x0202, audio pid 0x0000
>>> status 00 | signal 0000 | snr 9494 | ber 0001fffe | unc 00000000 |
>>> status 1f | signal 0000 | snr ecec | ber 00019622 | unc ffffffff | 
>>> FE_HAS_LOCK
>>> status 1f | signal 0000 | snr f8f8 | ber 00014eac | unc ffffffff | 
>>> FE_HAS_LOCK
>>> status 00 | signal 0000 | snr 5e5e | ber 0001fffe | unc 00000000 |
>>> status 1f | signal 0000 | snr fcfc | ber 00002bcc | unc ffffffff | 
>>> FE_HAS_LOCK
>>> status 1f | signal 0000 | snr fdfd | ber 000018a2 | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 0000 | snr fdfd | ber 00000e74 | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 0000 | snr fdfd | ber 00000912 | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 0000 | snr fefe | ber 000006b6 | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 0000 | snr fefe | ber 0000068e | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 0000 | snr fdfd | ber 000005c2 | unc 00000000 | 
>>> FE_HAS_LOCK
>>> status 1f | signal 0000 | snr fefe | ber 00000584 | unc 00000000 | 
>>> FE_HAS_LOCK
>>>
>>> However, analog-tv fails to scan anything -> "no signal"
>>>
>> This is wrong. Although the channel decoder locks, the signal at its
>> input is very low.
>>
>> But this means: The analog -> dvb switch is the GPIO of the channel 
>> decoder
>> *not* GPIO22
>>
>> so we can fix: we need  .gpio_config   = TDA10046_GP11_I
>>
>>> 3) antenna_switch
>>>
>>> static int philips_tda827x_tuner_init(struct dvb_frontend *fe)
>>> {
>>>    struct saa7134_dev *dev = fe->dvb->priv;
>>>    struct tda1004x_state *state = fe->demodulator_priv;
>>>
>>>    switch (state->config->antenna_switch) {
>>>    case 0: break;
>>>    case 1:    dprintk("setting GPIO21 to 0 (TV antenna?)\n");
>>>        saa7134_set_gpio(dev, 21, 0);
>>>        break;
>>>    case 2: dprintk("setting GPIO21 to 1 (Radio antenna?)\n");
>>>        saa7134_set_gpio(dev, 21, 1);
>>>        break;
>>>    }
>>>    return 0;
>>> }
>>>
>>> static int philips_tda827x_tuner_sleep(struct dvb_frontend *fe)
>>> {
>>>    struct saa7134_dev *dev = fe->dvb->priv;
>>>    struct tda1004x_state *state = fe->demodulator_priv;
>>>
>>>    switch (state->config->antenna_switch) {
>>>    case 0: break;
>>>    case 1: dprintk("setting GPIO21 to 1 (Radio antenna?)\n");
>>>        saa7134_set_gpio(dev, 21, 1);
>>>        break;
>>>    case 2:    dprintk("setting GPIO21 to 0 (TV antenna?)\n");
>>>        saa7134_set_gpio(dev, 21, 0);
>>>        break;
>>>    }
>>>    return 0;
>>> }
>>>
>>> If I put .antenna_switch = 1 or 2, in my struct, dvb-t fails to scan.
>>> I can't put antenna_switch in my struct, can I, as I am using gpio22?
>>> So I took it out, and in saa7134-cards.c, changed .radio to this:
>>>
>> I don't believe that this is right.
>> It is just a static signal and can't be anything else.
>>
>>>    [SAA7134_BOARD_KWORLD_DVBT_210] = {
>>>        .name           = "KWorld DVB-T 210",
>>>        .audio_clock    = 0x00187de7,
>>>        .tuner_type     = TUNER_PHILIPS_TDA8290,
>>>        .radio_type     = UNSET,
>>>        .tuner_addr    = ADDR_UNSET,
>>>        .radio_addr    = ADDR_UNSET,
>>>        .mpeg           = SAA7134_MPEG_DVB,
>>>        .gpiomask    = 0 << 21,
>>>        .inputs = {{
>>>            .name   = name_tv,
>>>            .vmux   = 1,
>>>            .amux   = TV,
>>>            .tv     = 1,
>>>        },{
>>>            .name   = name_comp1,
>>>            .vmux   = 3,
>>>            .amux   = LINE1,
>>>        },{
>>>            .name   = name_svideo,
>>>            .vmux   = 8,
>>>            .amux   = LINE1,
>>>        }},
>>>        .radio = {
>>>            .name   = name_radio,
>>>            .amux   = TV,
>>>            .gpio    = 0x00000000,
>>
>> This is wrong. It has to be .gpio = 0x0200000, as it was in the original
>> source code.
>>
>>>        },
>>>    },
>>> I still can't tune to a radio cahnnel.
>>> I'm not sure how to switch to radio, I'm not even sure which gpio 
>>> it's on.
>>> I assume it's on gpio21, but I've tried various configs - none work.
>>>
>>> Regards,
>>> Tim
>>>
>> Tim, seriously: For me it looks like you messed up the entire code. I 
>> would
>> recommend you roll back completely and start over again.
>>
>>
>> Hartmut
>>
> OK, this is using v4l-dvb as downloaded via mercurial 9 April2008.
> No modifications.
> 
> root@ubuntu:/home/timf# tzap -r "TEN HD"
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 788500000 Hz
> video pid 0x0202, audio pid 0x0000
> status 00 | signal 9e9e | snr 5d5d | ber 0001fffe | unc 00000000 |
> status 1f | signal 9d9d | snr fdfd | ber 0000010c | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9d9d | snr fefe | ber 00000104 | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9d9d | snr fefe | ber 00000106 | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9d9d | snr fefe | ber 00000116 | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9d9d | snr fefe | ber 0000010e | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9d9d | snr fefe | ber 000000f6 | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9d9d | snr fefe | ber 0000012c | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9d9d | snr fefe | ber 00000108 | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9c9c | snr fefe | ber 0000011e | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9c9c | snr fefe | ber 00000114 | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9d9d | snr fefe | ber 000000f4 | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9c9c | snr fefe | ber 0000010e | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9c9c | snr fefe | ber 0000013a | unc 00000000 | 
> FE_HAS_LOCK
> status 1f | signal 9c9c | snr fefe | ber 00000232 | unc 00000000 | 
> FE_HAS_LOCK
> 
> Analog-tv - "no signal" - no channels scanned
> 
> Regards,
> Tim
> 
DVB-T works now but not analog? We never had this before.
Just to be sure:
- you are aware that you can't use analog and dvb simultanously?
- you are aware that after stopping a dvb application it takes about a
   second before the dvb driver releases the card and the analog tuner can be used?
- did you mix up the antenna inputs?

Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
