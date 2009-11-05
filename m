Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:46751 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbZKEFXU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 00:23:20 -0500
Message-ID: <26256.64.213.30.2.1257398603.squirrel@webmail.exetel.com.au>
In-Reply-To: <829197380911042051l295e9796g65fe1b163f72a70c@mail.gmail.com>
References: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
    <829197380911042051l295e9796g65fe1b163f72a70c@mail.gmail.com>
Date: Thu, 5 Nov 2009 16:23:23 +1100 (EST)
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: "Robert Lowery" <rglowery@exemail.com.au>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Wed, Nov 4, 2009 at 10:00 PM, Robert Lowery <rglowery@exemail.com.au>
> wrote:
>> Hi,
>>
>> I have been having some difficulties getting my DVICO dual digital 4
>> (rev1) working with recent kernels, failing to tune and getting errors
>> like the following
>>
>> kernel: [ 315.032076] dvb-usb: bulk message failed: -110 (4/0)
>> kernel: [ 315.032080] cxusb: i2c read failed
>>
>> and making the machine very slow as documented at
>> https://bugs.launchpad.net/ubuntu/+source/linux-meta/+bug/459523
>>
>> Using the v4l-dvb tree, I was able to bisect the issue down to
>> http://linuxtv.org/hg/v4l-dvb/rev/7276a5854219
>>
>> At first I though I could workaround the issue by setting no_poweroff=1,
>> but that did not work.  The following diff did however resolve the
>> issue.
>>
>> diff -r 43878f8dbfb0 linux/drivers/media/common/tuners/tuner-xc2028.c
>> --- a/linux/drivers/media/common/tuners/tuner-xc2028.c        Sun Nov 01
>> 07:17:46
>> 2009 -0200
>> +++ b/linux/drivers/media/common/tuners/tuner-xc2028.c        Tue Nov 03
>> 14:24:05
>> 2009 +1100
>> @@ -1240,7 +1240,7 @@
>>         .get_frequency     = xc2028_get_frequency,
>>         .get_rf_strength   = xc2028_signal,
>>         .set_params        = xc2028_set_params,
>> -        .sleep             = xc2028_sleep,
>> +        //.sleep             = xc2028_sleep,
>>  #if 0
>>         int (*get_bandwidth)(struct dvb_frontend *fe, u32 *bandwidth);
>>         int (*get_status)(struct dvb_frontend *fe, u32 *status);
>>
>> This led me to dvb_frontend.c where I could see i2c_gate_ctrl() was
>> being
>> called if .sleep was non zero.  Setting dvb_powerdown_on_sleep=0 worked
>> around the issue by stoppign i2c_gate_ctrl() being called, so I suspect
>> i2c_gate_ctrl() is triggering the issue somehow.
>>
>> Any thoughts on a proper solution for this issue?
>>
>> -Rob
>
> Hello Rob,
>
> The problem is not actually the i2c_gate_ctrl().  It's the fact that
> the xc3028 is being put to sleep but cannot be woken up.
>
> The GPIOs are probably setup for this card improperly in the board
> profile.  This will result in the xc3028 being put to sleep, but then
> it cannot be woken up because the wrong GPIO is being pulled low to
> reset the chip in the xc3028 reset callback.
>
> Yet another case where blindly enabling the power management on the
> xc3028 by default was a really crappy idea.
>
> You can either track down the which GPIO is actually connected to the
> xc3028 reset pin for your board, or disable the xc3028 power
> management by setting the disable_power_mgmt field in the xc3028
> config when the call is made to xc2028_set_config for your card.
>
> Devin

Hi Devin,

Thanks for your reply.

I don't think your suggestion to use disable_power_mgmt will work as I
already tried setting the no_poweroff=1 kernel module without success (and
even tried recompiling with xc2028_sleep returning 0 immediately, but
until I stopped the .sleep being set at all in xc2028_dvb_tuner_ops, the
problem kept happening.

The only thing that fixed it without code change was to set
dvb_powerdown_on_sleep=0.

Looking at the below code from dvb_frontend.c, the only difference I could
see between setting no_poweroff=1 and not setting .sleep is the latter
stops i2c_gate_ctrl being called.

        if (dvb_powerdown_on_sleep) {
                if (fe->ops.set_voltage)
                        fe->ops.set_voltage(fe, SEC_VOLTAGE_OFF);
                if (fe->ops.tuner_ops.sleep) {
                        if (fe->ops.i2c_gate_ctrl)
                                fe->ops.i2c_gate_ctrl(fe, 1);
                        fe->ops.tuner_ops.sleep(fe);
                        if (fe->ops.i2c_gate_ctrl)
                                fe->ops.i2c_gate_ctrl(fe, 0);
                }
                if (fe->ops.sleep)
                        fe->ops.sleep(fe);
        }

I'm not very familiar with this code.  Am I missing something?

-Rob

>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


