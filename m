Return-path: <linux-media-owner@vger.kernel.org>
Received: from unicorn.mansr.com ([81.2.72.234]:51486 "EHLO unicorn.mansr.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751098AbdISJsM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 05:48:12 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Cc: Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>,
        Mason <slash.tmp@free.fr>
Subject: Re: [PATCH v1] media: rc: Add driver for tango IR decoder
References: <e05783d3-012d-0798-9a54-ff42039e728d@sigmadesigns.com>
        <yw1xd16oyqas.fsf@mansr.com>
        <a898310b-3286-43cb-3c0e-4359239c49cf@sigmadesigns.com>
Date: Tue, 19 Sep 2017 10:48:09 +0100
In-Reply-To: <a898310b-3286-43cb-3c0e-4359239c49cf@sigmadesigns.com> (Marc
        Gonzalez's message of "Tue, 19 Sep 2017 10:45:36 +0200")
Message-ID: <yw1x60cfyq7a.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marc Gonzalez <marc_gonzalez@sigmadesigns.com> writes:

> On 18/09/2017 17:33, Måns Rullgård wrote:
>
>> Marc Gonzalez writes:
>> 
>>> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
>>> index d9ce8ff55d0c..f84923289964 100644
>>> --- a/drivers/media/rc/Kconfig
>>> +++ b/drivers/media/rc/Kconfig
>>> @@ -469,6 +469,11 @@ config IR_SIR
>>>  	   To compile this driver as a module, choose M here: the module will
>>>  	   be called sir-ir.
>>>  +config IR_TANGO
>>> +	tristate "Sigma Designs SMP86xx IR decoder"
>>> +	depends on RC_CORE
>>> +	depends on ARCH_TANGO || COMPILE_TEST
>>> +
>>>  config IR_ZX
>>>  	tristate "ZTE ZX IR remote control"
>>>  	depends on RC_CORE
>> 
>> This hunk looks damaged.
>
> It appears that the SMTP server has been mangling outgoing messages
> for a few months. I will find a work-around.
>
>> What have you changed compared to my original code?
>
> o Rename tangox to tango
> o Handle protocol selection (enable/disable) in the change_protocol callback,
> instead of unconditionally in open/close
> o Delete open/close callbacks
> o Rebase driver on top of linuxtv/master
> o Use ir_nec_bytes_to_scancode() in tango_ir_handle_nec()
> o Use devm_rc_allocate_device() in tango_ir_probe()
> o Use Use devm_rc_register_device() in tango_ir_probe()
> o Rename rc->input_name to rc->device_name
> o List all NEC variants for rc->allowed_protocols

Did you test the NEC32 variant?  I don't have anything that produces
such codes.

> o Change type of clkrate to u64
> o Fix tango_ir_probe and tango_ir_remove for devm
> o Move around some init calls in tango_ir_probe() for devm
> o Use relaxed variants of MMIO accessors

Thanks for fixing it up.

>> I tested all three protocols with a few random remotes I had lying
>> around back when I wrote the driver, but that's quite a while ago.
>
> OK, I don't think I changed anything wrt RC-5 and RC-6 handling.
> It would be great if you could give the driver a quick spin to check
> these two protocols. But if you don't have time, no problem.

I'll try to find the time.

>> You should also write a devicetree binding.
>
> Will do.
>
>> Finally, when sending patches essentially written by someone else,
>> please make sure to set a From: line for correct attribution.  It's not
>> nice to take other people's code and apparently pass it off as your own
>> even you've made a few small changes.
>
> It was not my intent to "take other people's code and apparently pass it off
> as my own". I clearly stated where I got the driver from, and your copyright
> notice is right there, at the top of the driver. But I understand that you
> also want to be credited as the author in the git log, and I will fix that
> in v2. Please accept my apologies.

No problem.  I know you're not intentionally trying to mislead anyone.

-- 
Måns Rullgård
