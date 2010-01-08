Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:44225 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0AHIMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2010 03:12:23 -0500
Received: by iwn32 with SMTP id 32so2959871iwn.33
        for <linux-media@vger.kernel.org>; Fri, 08 Jan 2010 00:12:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6ab2c27e1001080007h70bcf309u65251763a70200c6@mail.gmail.com>
References: <33305.64.213.30.2.1259216241.squirrel@webmail.exetel.com.au>
	 <55306.115.70.135.213.1262748017.squirrel@webmail.exetel.com.au>
	 <1262829099.3065.61.camel@palomino.walls.org>
	 <1128.115.70.135.213.1262840633.squirrel@webmail.exetel.com.au>
	 <6ab2c27e1001070548y1a96f390uc7b7fbd18a78a564@mail.gmail.com>
	 <6ab2c27e1001070604m323ccb02g10a8c302c3edee79@mail.gmail.com>
	 <6ab2c27e1001070618ud7019b9s69180353010a1c96@mail.gmail.com>
	 <6ab2c27e1001070642k4d5bd81cud404fe77bc7a6bc5@mail.gmail.com>
	 <1197.115.70.135.213.1262917283.squirrel@webmail.exetel.com.au>
	 <6ab2c27e1001080007h70bcf309u65251763a70200c6@mail.gmail.com>
Date: Fri, 8 Jan 2010 16:12:21 +0800
Message-ID: <6ab2c27e1001080012r40960ab6te09948e46405f4ba@mail.gmail.com>
Subject: Re: [RESEND] Re: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1) tuning
	regression
From: Terry Wu <terrywu2009@gmail.com>
To: Robert Lowery <rglowery@exemail.com.au>
Cc: Andy Walls <awalls@radix.net>, mchehab@redhat.com,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Vincent McIntyre <vincent.mcintyre@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


Please refer to the XCEIVE document.
And set the correct SCODE.

>>  380.912010] xc2028 4-0061: Loading SCODE for >>type=DTV6 QAM DTV7 DTV78 (What is this type ???)
>>DTV8 ZARLINK456 SCODE HAS_IF_4760
>>(620003e0), id 0000000000000000.


Terry

2010/1/8 Terry Wu <terrywu2009@gmail.com>:
> Hi,
>
>    XCEIVE's documents are attached.
>
> Terry
>
> 2010/1/8 Robert Lowery <rglowery@exemail.com.au>:
>> Hi Terry,
>>
>> Thanks for your comments, my responses are inline below.
>>
>>> Hi,
>>>
>>>     You can check the dmesg output to verify which XCEIVE
>>> firmware/SCODE is using.
>>>     For examples,
>>>     (1). DVB-T 7MHz bandwidth, frequency=177.5MHz and BASE F8MHZ/DTV7
>>> firmware is using,
>>> SCODE SCODE DTV7 ZARLINK456/HAS_IF_5260
>>> [  266.008596] xc2028 0-0061: Loading firmware for type=BASE F8MHZ (3),
>> id 0000000000000000.
>>> [  267.098011] xc2028 0-0061: Loading firmware for type=D2633 DTV7 (90),
>> id 0000000000000000.
>>> [  267.111148] xc2028 0-0061: Loading SCODE for type=DTV7 ZARLINK456
>> SCODE HAS_IF_5260 (62000080), id 0000000000000000.
>>>
>>>     (2). DVB-T 7MHz bandwidth, frequency=177.5MHz and BASE F8MHZ/DTV78
>>> firmware is using,
>>> SCODE DTV78 ZARLINK456/SCODE HAS_IF_4760
>>> [ 1089.192377] xc2028 0-0061: Loading firmware for type=BASE F8MHZ (3),
>> id 0000000000000000.
>>> [ 1090.265461] xc2028 0-0061: Loading firmware for type=D2633 DTV78
>> (110), id 0000000000000000.
>>> [ 1090.278523] xc2028 0-0061: Loading SCODE for type=DTV78 ZARLINK456
>> SCODE HAS_IF_4760 (62000100), id 0000000000000000.
>>
>> My firmware load logging looks as follows
>> [  376.312248] xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id
>> 0000000000000000.
>> [  380.832015] xc2028 4-0061: Loading firmware for type=D2633 DTV7 (90),
>> id 0000000000000000.
>> [  380.912010] xc2028 4-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78
>> DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
>>
>>>
>>> Terry
>>>
>>> 2010/1/7 Terry Wu <terrywu2009@gmail.com>:
>>>> Hi,
>>>>    The following codes in the 6MHz patch are not for 6MHz.
>>>>    Please read the mchehab's comments.
>>>>    1.28                /*
>>>>    1.29 -               * We must adjust the offset by 500kHz in two
>> cases in order
>>>>    1.30 -               * to correctly center the IF output:
>>>>    1.31 -               * 1) When the ZARLINK456 or DIBCOM52 tables
>> were
>>>> explicitly
>>>>    1.32 -               *    selected and a 7MHz channel is tuned;
>>  1.33 -               * 2) When tuning a VHF channel with DTV78
>> firmware.
>>>>    1.34 +               * We must adjust the offset by 500kHz  when
>>  1.35 +               * tuning a 7MHz VHF channel with DTV78 firmware
>>  1.36 +               * (used in Australia)
>>>>    1.37                 */
>>>>    1.38 -              if (((priv->cur_fw.type & DTV7) &&
>>>>    1.39 -                   (priv->cur_fw.scode_table & (ZARLINK456 |
>> DIBCOM52))) ||
>>>>    1.40 -                  ((priv->cur_fw.type & DTV78) && freq <
>> 470000000))
>>>>    1.41 +              if ((priv->cur_fw.type & DTV78) && freq <
>> 470000000)
>>>>    1.42                        offset -= 500000;
>>>>    BTW, the DTV7 firmware or DTV78 firmware is using if you are tuning
>> a VHF channel (frequency < 470MHz).
>>>>    And the above mchehab's new codes will not  do "offset -= 500000;"
>> if DTV7 firmware is using.
>>>> Terry
>> Mauro's new code does the 500000 offset unconditionally for DTV7 by
>> setting offset = 2250000, not just when the ZARLINK456 or DIBCOM52 tables
>> were explicitly selected.  This change is what appears to cause issues for
>> me.
>>
>> The working (old) code used to do something like the following for DTV7
>>
>> +               offset = 2750000;
>> ...
>> +               if (((priv->cur_fw.type & DTV7) &&
>> +                    (priv->cur_fw.scode_table & (ZARLINK456 | DIBCOM52))) ||
>> +                   ((priv->cur_fw.type & DTV78) && freq < 470000000))
>>                        offset -= 500000;
>>
>> My firmware type is DTV7, but priv->cur_fw.scode_table == 1<<29 == SCODE,
>> which does not match the test for (ZARLINK456 | DIBCOM52), so offset is
>> left as 2750000 which works perfectly for me.
>>
>> The current hg tip which does not work well for me now does a
>> -               else if (priv->cur_fw.type & DTV7)
>> -                       offset = 2250000;
>>
>> including the 500kHz offset adjustment in the initial value.  This causes
>> a lot of stuttering, corruption etc for me.
>>
>> My patch set proposes to revert back to the original working code, but
>> still implement the change from testing against ATSC to DTV6 for (Taiwan?)
>>
>> That is
>> diff -r 32b2a1875752 linux/drivers/media/common/tuners/tuner-xc2028.c ---
>> a/linux/drivers/media/common/tuners/tuner-xc2028.c      Fri Nov 20 12:47:40
>> 2009 +0100
>> +++ b/linux/drivers/media/common/tuners/tuner-xc2028.c  Fri Nov 27 10:29:22
>> 2009 +1100
>> @@ -936,7 +936,7 @@
>>         */
>>        if (new_mode == T_ANALOG_TV) {
>>                rc = send_seq(priv, {0x00, 0x00});
>> -       } else if (priv->cur_fw.type & ATSC) {
>> +       } else if (priv->cur_fw.type & DTV6) {
>>                offset = 1750000;
>>        } else {
>>                offset = 2750000;
>>
>> Were you able to test my proposed patches to see if they continue to work
>> for you
>>
>> -Rob
>>
>>>> 2010/1/7 Terry Wu <terrywu2009@gmail.com>:
>>>>> Hi,
>>>>> And the 6MHz patch you mentioned is a wrong patch.
>>>>> http://linuxtv.org/hg/v4l-dvb/rev/e6a8672631a0
>>>>>     +          if (priv->cur_fw.type & DTV6)
>>>>>     +                  offset = 1750000;
>>>>>     +          if (priv->cur_fw.type & DTV7)
>>>>>     +                  offset = 2250000;
>>>>>     +          else    /* DTV8 or DTV78 */
>>>>>     +                  offset = 2750000;
>>>>> and latest patch should be:
>>>>>     +          if (priv->cur_fw.type & DTV6)
>>>>>     +                  offset = 1750000;
>>>>>     +          else if (priv->cur_fw.type & DTV7)
>>>>>     +                  offset = 2250000;
>>>>>     +          else    /* DTV8 or DTV78 */
>>>>>     +                  offset = 2750000;
>>>>> Terry
>>>>> 2010/1/7 Terry Wu <terrywu2009@gmail.com>:
>>>>>> Hi,
>>>>>>    The 6MHz patch is for Taiwan only.
>>>>>>    It should not change anything for 7MHz and 8MHz.
>>>>>> Terry
>>>>>> 2010/1/7 Robert Lowery <rglowery@exemail.com.au>:
>>>>>>>> On Wed, 2010-01-06 at 14:20 +1100, Robert Lowery wrote:
>>>>>>>>> > On Mon, 2010-01-04 at 21:27 -0500, Andy Walls wrote:
>>>>>>>>> >> On Mon, 2010-01-04 at 15:27 +1100, Robert Lowery wrote:
>>>>>>>>> >> > > Mauro,
>>>>>>>>> >> > >
>>>>>>>>> >> > > I've split the revert2.diff that I sent you previously to
>>>>>>>>> fix the
>>>>>>>>> >> tuning
>>>>>>>>> >> > > regression on my DViCO Dual Digital 4 (rev 1) into three
>>>>>>>>> separate
>>>>>>>>> >> patches
>>>>>>>>> >> > > that will hopefully allow you to review more easily.
>>>>>>>>> >> > >
>>>>>>>>> >> > > The first two patches revert their respective changesets
>> and
>>>>>>>>> nothing
>>>>>>>>> >> else,
>>>>>>>>> >> > > fixing the issue for me.
>>>>>>>>> >> > > 12167:966ce12c444d tuner-xc2028: Fix 7 MHz DVB-T
>>>>>>>>> >> > > 11918:e6a8672631a0 tuner-xc2028: Fix offset frequencies for
>>>>>>>>> DVB @
>>>>>>>>> >> 6MHz
>>>>>>>>> >> > >
>>>>>>>>> >> > > The third patch does what I believe is the obvious
>>>>>>>>> equivalent fix
>>>>>>>>> to
>>>>>>>>> >> > > e6a8672631a0 but without the cleanup that breaks tuning on
>>>>>>>>> my
>>>>>>>>> card.
>>>>>>>>> >> > >
>>>>>>>>> >> > > Please review and merge
>>>>>>>>> >> > >
>>>>>>>>> >> > > Signed-off-by: Robert Lowery <rglowery@exemail.com.au>
>>>>>>>>> >> >
>>>>>>>>> >> > Mauro,
>>>>>>>>> >> >
>>>>>>>>> >> > I'm yet to receive a response from you on this clear
>>>>>>>>> regression
>>>>>>>>> >> introduced
>>>>>>>>> >> > in the 2.6.31 kernel.  You attention would be appreciated
>>>>>>>>> >> >
>>>>>>>>> >> > Thanks
>>>>>>>>> >> >
>>>>>>>>> >> > -Rob
>>>>>>>>> >> Robert,
>>>>>>>>> >> The changes in question (mostly authored by me) are based on
>> documentation on what offsets are to be used with the firmware
>>>>>>>>> for
>>>>>>>>> various DVB bandwidths and demodulators.  The change was tested by
>> Terry
>>>>>>>>> >> on a Leadtek DVR 3100 H Analog/DVB-T card (CX23418, ZL10353,
>>>>>>>>> XC3028)
>>>>>>>>> and
>>>>>>>>> >> some other cards I can't remember, using a DVB-T pattern
>>>>>>>>> generator
>>>>>>>>> for
>>>>>>>>> 7
>>>>>>>>> >> and 8 MHz in VHF and UHF, and live DVB-T broadcasts in UHF for
>> 6
>>>>>>>>> MHz.
>>>>>>>>> (Devin,
>>>>>>>>> >>  Maybe you can double check on the offsets in tuner-xc2028.c
>>>>>>>>> with any
>>>>>>>>> documentation you have available to you?)
>>>>>>>>> >> I haven't been following this thread really at all as the board
>>>>>>>>> in
>>>>>>>>> the
>>>>>>>>> subject line was unfamiliar to me, so sorry for any late response or
>>>>>>>>> dumb
>>>>>>>>> questions by me.
>>>>>>>>> >> May I ask:
>>>>>>>>> >> 1. what are the exact problem frequencies?
>>>>>>>>> >> 2. what is the data source from which you are getting the
>>>>>>>>> frequency
>>>>>>>>> information?
>>>>>>>>> >> 3. what does tuner-xc2028 debug logging show as the firmware
>>>>>>>>> loaded
>>>>>>>>> when
>>>>>>>>> >> tune to one of the the problem frequencies?
>>>>>>>>> >
>>>>>>>>> >
>>>>>>>>> > Robert,
>>>>>>>>> >
>>>>>>>>> > I just found that ACMA has a very nice compilation licensed DTV
>> transmitters in Australia and their frequencies.  Have a look at
>>>>>>>>> the
>>>>>>>>> Excel spreadsheet linked on this page:
>>>>>>>>> >
>>>>>>>>> >    http://acma.gov.au/WEB/STANDARD/pc=PC_9150
>>>>>>>>> >
>>>>>>>>> > The DTV tab has a list of the Area, callsign, and DTV center
>>>>>>>>> freq. The
>>>>>>>>> Glossary tab mentions that DTV broadcasters can have an offset of +/-
>>>>>>>>> 125
>>>>>>>>> kHz from the DTV center freq.
>>>>>>>>> >
>>>>>>>>> > If you could verify that the frequencies you are using for the
>>>>>>>>> problem
>>>>>>>>> stations match the list, that would help eliminate commanded
>> tuning
>>>>>>>>> frequency as source of the problem.
>>>>>>>>> Andy, I don't think this issue is frequency, it is the removal of the
>>>>>>>>> 500kHz offset.
>>>>>>>> OK.  I forgot there were two offsets at play here: one for the RF
>> frequency and one for the SCODE/Intermediate Frequency.
>>>>>>>> Right, the S-CODE offsets are somewhat of a mystery to me as I
>> don't
>>>>>>>> exactly know the mathematical basis behind them.  The 500 kHz came
>> from
>>>>>>>> the best interpretation Maruo and I could make at the time, but it
>> could
>>>>>>>> very well be the wrong thing.  (I was guessing it came from a relation
>>>>>>>> something like this: 8 MHz - 7 MHz / 2 = 500 kHz)
>>>>>>>> If it is the wrong thing, and it looks like it could be, we can
>> back
>>>>>>>> it
>>>>>>>> out.  As my colleauge, who used to work at CERN, says "Experiment
>> trumps
>>>>>>>> theory ... *every* time".  Terry had positive results, you and Vincent
>>>>>>>> have negative results.  So I'd like to see what Devin finds, if he can
>>>>>>>> test with a DVB-T generator.
>>>>>>> Andy,
>>>>>>> Resend of my proposed patches attached.
>>>>>>> My hypothesis is that 02_revert_e6a8672631a0.diff was really meant
>> to
>>>>>>> just
>>>>>>> change the ATSC test to DTV6 but at the same time a cleanup that was
>> done
>>>>>>> inadvertently removed the 500kHz offset subtraction for DTV7
>> introducing
>>>>>>> the defect.  01_revert_966ce12c444d.diff partially fixed this
>> regression
>>>>>>> for Terry, but not for me or Vincent.
>>>>>>> I'm having trouble convincing Mauro of this though :), so I would
>> appreciate it if Terry could test my patch set and confirm it is ok
>> for
>>>>>>> him.
>>>>>>> So in short, my 01 and 02 patches attached revert the changes that
>> break
>>>>>>> tuning for me and 03 re-implements the DTV6 fix, but without the
>> cleanup
>>>>>>> which breaks me.
>>>>>>> Please review and comment
>>>>>>> -Rob
>>>>>>>>> The channel with the biggest problem (most stuttering) is Channel
>> 8
>>>>>>>>> in
>>>>>>>>> Melbourne, which looks correct at 191.625 MHz on the above site.
>>>>>>>> OK.  Vincent must have been the one with all the Sydney stations.
>> DTV Channel GTV8 (Fc = 191.625 MHz at 50 kW) for Melbourne is
>> interesting; it comes from the same towers as the adjacent analog
>> channels HSV7 (Fr = 182.25 MHz @ 200 kW) and GTV9 (Fr = 196.25 MHz
>> @
>>>>>>>> 200
>>>>>>>> kW).
>>>>>>>> I guess if anything is off center when setting up the XC3028, the
>> analog
>>>>>>>> stations may show up as strong noise - a situation that would not
>> be
>>>>>>>> obvious with a single channel DVB-T signal generator.  GTV8 is
>> probably
>>>>>>>> a good channel for you to use for testing.
>>>>>>>> (BTW, given that the analog channel of where GTV8 now resides would
>> have
>>>>>>>> been Fr = 189.25 MHz, I would have expected GTV8 to really be
>> operating
>>>>>>>> at Fc = Fr + 2.25 MHz = 191.50 MHz and not 191.625 MHz)
>>>>>>>>> With debug enabled on the the current hg tip (stuttering case) we
>> have
>>>>>>>>> divisor= 00 00 2f 58 (freq=191.625)
>>>>>>>>> With the patch reverted (working case)
>>>>>>>>> divisor= 00 00 2f 38 (freq=191.625)
>>>>>>>>> Have you reviewed my patch.  It leaves your original DTV6 fix in
>> place,
>>>>>>>>> but reverts the cleanup which broke the offset calculation for me.
>>>>>>>> I don't have a copy in my email archives, I'll have to go check for
>> them
>>>>>>>> on the list archives.
>>>>>>>> Regards,
>>>>>>>> Andy
>>>>>>>>> -Rob
>>>>>>>>> >
>>>>>>>>> > Regards,
>>>>>>>>> > Andy
>>>>>>>>> >
>>>>>>>>> >
>>>>>>>>> >> BTW, I note that in linux/drivers/media/dvb/dvb-usb/cxusb.c:
>> cxusb_dvico_xc3028_tuner_attach(), this declaration
>>>>>>>>> >>         static struct xc2028_ctrl ctl = {
>>>>>>>>> >>                 .fname       = XC2028_DEFAULT_FIRMWARE,
>>         .max_len     = 64,
>>>>>>>>> >>                 .demod       = XC3028_FE_ZARLINK456,
>>>>>>>>> >>         };
>>>>>>>>> >> really should have ".type = XC2028_AUTO" or ".type =
>>>>>>>>> XC2028_D2633",
>>>>>>>>> but
>>>>>>>>> since XC2028_AUTO has a value of 0, it probably doesn't matter.
>> Regards,
>>>>>>>>> >> Andy
>>>>>>>> --
>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>> linux-media" in
>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>>
>>
>>
>
