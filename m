Return-path: <mchehab@pedra>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:45722 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab1CBUlt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2011 15:41:49 -0500
Message-ID: <4D6EAB79.5010200@kolumbus.fi>
Date: Wed, 02 Mar 2011 22:41:29 +0200
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Jonas Hanschke <jonas.hanschke@gmail.com>
CC: linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: Remote control not working for Terratec Cinergy C (2.6.37 Mantis
 driver)
References: <AANLkTinfJiCpMOTx4-mc6jW3Bpe_3qduLYpqvRi8U+ga@mail.gmail.com>	<4D6D3464.2030602@kolumbus.fi> <AANLkTik-YJ_TpWgwD2Nw1R4HUgixEL1mAYgwD_GZLDsc@mail.gmail.com>
In-Reply-To: <AANLkTik-YJ_TpWgwD2Nw1R4HUgixEL1mAYgwD_GZLDsc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

02.03.2011 11:12, Jonas Hanschke kirjoitti:
> Thanks for answering, Marko.
>
> And sorry for asking a maybe stupid question - how do I turn on the
> debug output?
> There is no such option in make menuconfig, and modinfo -p mantis only returns:
> verbose:verbose startup messages, default is 1 (yes)

I emailed this to Manu Abraham too, because he is the main author for mantis drivers.

You can do:

rmmod mantis
modprobe mantis verbose=7

I have hardware:
[ 4487.836265] Mantis 0000:05:05.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
[ 4487.837955] DVB: registering new adapter (Mantis DVB adapter)
[ 4487.869550] IR RC5(x) protocol handler initialized
[ 4487.923905] IR RC6 protocol handler initialized
[ 4487.940785] IR JVC protocol handler initialized
[ 4487.953168] IR Sony protocol handler initialized
[ 4487.974220] lirc_dev: IR Remote Control driver registered, major 249
[ 4487.990015] IR LIRC bridge handler initialized
[ 4488.697914] TDA10021: i2c-addr = 0x0c, id = 0x7c
[ 4488.697931] DVB: registering adapter 0 frontend 0 (Philips TDA10021 DVB-C)...
[ 4831.498140] Mantis 0000:05:05.0: PCI INT A disabled

Here is what comes with verbose=7:

...
[ 4890.486686] -- Stat=<4000800> Mask=<800> --<IRQ-1>
[ 4890.486695] mantis_uart_read (0): Reading ... <26>
[ 4890.486704] mantis_uart_work (0): UART BUF:0 <26>
[ 4890.486708]
[ 4890.486714] mantis_uart_read (0): Reading ... <26>
[ 4890.486719] mantis_uart_work (0): UART BUF:0 <26>

So this means, that my remote control works, pressing key with hex value 0x26 works.
Unfortunately mantis_uart.c doesn't have IR input initialization at all,
so the remote control button press is just ignored in mantis_uart.c:mantis_uart_work() function.

So this is partially implemented in mantis driver, No UART can work with Mantis in vanilla kernel.

You can try to check mantis directory and mantis_uart.c, and see if there are some input_device_XXX functions.
A good reference for implementation might be media/dvb/ttpci/av7110_ir.c: it looks like a working implementation with input device
support.

Regards,
Marko Ristola

>
> In general, should the remote control appear as an input device (like
> it used to with the old, not-merged mantis driver) or is it possible
> that the approach has changed to an LIRC-driver where no input device
> is created?
>
> Also: your mail suggests that support may just be broken in the
> mainline kernel. In that case the info from the DVB wiki would just be
> incorrect and I would be looking for a solution that does not exist -
> is that just a hunch or do you acutally know it's not working?
>
> Jonas
>
> 2011/3/1 Marko Ristola<marko.ristola@kolumbus.fi>:
>> 28.02.2011 19:26, Jonas Hanschke kirjoitti:
>>>
>>> Hi,
>>>
>>> despite lots of time spent tinkering around and looking for help on
>>> the web, I've had no success in getting to work the remote control of
>>> my DVB-C card.
>>>
>>> It is a Terratec Cinergy C:
>>> http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C
>>>
>>> and am using the Mantis driver. Since it was merged into the kernel
>>> tree in 2.6.33, watching TV works without patches, but the remote
>>> control does not, although it is supposed to be supported, according
>>> to the link above.
>>>
>>> Kernel is a vanilla 2.6.37.2 with custom configuration on an old AMD
>>> Athlon XP machine, running debian Squeeze.
>>>
>>>
>>> When I modprobe the Mantis driver, the following IR-modules are pulled
>>> in automagically:
>>> ir_lirc_codec
>>> lirc_dev
>>> ir_core
>>>
>>> However, no input device is created during module loading. dmesg output:
>>> Mantis 0000:01:0a.0: PCI INT A ->    Link[APC1] ->    GSI 16 (level, high) ->
>>>   IRQ 16
>>> DVB: registering new adapter (Mantis DVB adapter)
>>> IR LIRC bridge handler initialized
>>> DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
>>>
>>> Am I missing some additional modules? Are there any dependencies on
>>> other kernel config options that are not handled automatically by make
>>> menuconf?
>>>
>>> If additional information is needed, I will be happy to provide it.
>>> However, I am not sure what is useful and what is not and did not want
>>> to bloat this message.
>>
>> Before merging into v4l-dvb, doing modprobe mantis was enough.
>> I don't know how it should work with recent kernels.
>> I haven't seen remote control working lately.
>>
>> Turning mantis module debug options on gives some information
>> what is happening into /var/log/messages.
>>
>> Regards,
>> Marko Ristola
>>
>>>
>>> Thanks in advance,
>>>
>>> Jonas
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

