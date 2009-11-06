Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:47048 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759236AbZKFANX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 19:13:23 -0500
Message-ID: <39786.64.213.30.2.1257466403.squirrel@webmail.exetel.com.au>
In-Reply-To: <829197380911051551q3b844c5ek490a5eb7c96783e9@mail.gmail.com>
References: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
    <829197380911042051l295e9796g65fe1b163f72a70c@mail.gmail.com>
    <26256.64.213.30.2.1257398603.squirrel@webmail.exetel.com.au>
    <829197380911050602t30bc69d0sd0b269c39bf759e@mail.gmail.com>
    <702870ef0911051257k52c142e8ne1b32506f1efb45c@mail.gmail.com>
    <829197380911051304g1544e277s870f869be14e1a18@mail.gmail.com>
    <25126.64.213.30.2.1257464759.squirrel@webmail.exetel.com.au>
    <829197380911051551q3b844c5ek490a5eb7c96783e9@mail.gmail.com>
Date: Fri, 6 Nov 2009 11:13:23 +1100 (EST)
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: "Robert Lowery" <rglowery@exemail.com.au>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: "Vincent McIntyre" <vincent.mcintyre@gmail.com>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Thu, Nov 5, 2009 at 6:45 PM, Robert Lowery <rglowery@exemail.com.au>
> wrote:
>> Do you mean something like this (untested) patch?  I'll try it out
>> tonight.
>>
>> diff -r 43878f8dbfb0 linux/drivers/media/dvb/dvb-usb/cxusb.c
>> --- a/linux/drivers/media/dvb/dvb-usb/cxusb.c   Sun Nov 01 07:17:46 2009
>> -0200
>> +++ b/linux/drivers/media/dvb/dvb-usb/cxusb.c   Fri Nov 06 10:39:38 2009
>> +1100
>> @@ -666,6 +666,14 @@
>>        .parallel_ts = 1,
>>  };
>>
>> +static struct zl10353_config cxusb_zl10353_xc3028_config_no_i2c_gate =
>> {
>> +       .demod_address = 0x0f,
>> +       .if2 = 45600,
>> +       .no_tuner = 1,
>> +       .parallel_ts = 1,
>> +       .disable_i2c_gate_ctrl = 1,
>> +};
>> +
>>  static struct mt352_config cxusb_mt352_xc3028_config = {
>>        .demod_address = 0x0f,
>>        .if2 = 4560,
>> @@ -897,7 +905,7 @@
>>        cxusb_bluebird_gpio_pulse(adap->dev, 0x02, 1);
>>
>>        if ((adap->fe = dvb_attach(zl10353_attach,
>> -                                  &cxusb_zl10353_xc3028_config,
>> +                                
>>  &cxusb_zl10353_xc3028_config_no_i2c_gate,
>>                                   &adap->dev->i2c_adap)) == NULL)
>>                return -EIO;
>
> Wow, that looks shockingly similar to the patch I did for an em28xx
> boards a couple of months ago, even down to the part where you added
> "_no_i2c_gate" to the end!  :-)

I might have got some inspiration from somewhere :)

>
> Yeah, that's the fix, although from the diff I can't tell if you're
> doing it for all zl10353 boards in cxusb.c or just yours.  I would
> have to see the source to know for sure.

I only changed cxusb_dualdig4_frontend_attach() so it should be just my
board.  The only other board that was using cxusb_zl10353_xc3028_config
was cxusb_nano2_frontend_attach(), but I left that as is since I don't
know if that board is similarily affected.

I'l try it out tonight and confirm it fixes the problem

Thanks for your help

-Rob

>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>


