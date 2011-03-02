Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53165 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab1CBJMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2011 04:12:17 -0500
Received: by qyg14 with SMTP id 14so5127920qyg.19
        for <linux-media@vger.kernel.org>; Wed, 02 Mar 2011 01:12:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D6D3464.2030602@kolumbus.fi>
References: <AANLkTinfJiCpMOTx4-mc6jW3Bpe_3qduLYpqvRi8U+ga@mail.gmail.com>
	<4D6D3464.2030602@kolumbus.fi>
Date: Wed, 2 Mar 2011 10:12:14 +0100
Message-ID: <AANLkTik-YJ_TpWgwD2Nw1R4HUgixEL1mAYgwD_GZLDsc@mail.gmail.com>
Subject: Re: Remote control not working for Terratec Cinergy C (2.6.37 Mantis driver)
From: Jonas Hanschke <jonas.hanschke@gmail.com>
To: Marko Ristola <marko.ristola@kolumbus.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks for answering, Marko.

And sorry for asking a maybe stupid question - how do I turn on the
debug output?
There is no such option in make menuconfig, and modinfo -p mantis only returns:
verbose:verbose startup messages, default is 1 (yes)

In general, should the remote control appear as an input device (like
it used to with the old, not-merged mantis driver) or is it possible
that the approach has changed to an LIRC-driver where no input device
is created?

Also: your mail suggests that support may just be broken in the
mainline kernel. In that case the info from the DVB wiki would just be
incorrect and I would be looking for a solution that does not exist -
is that just a hunch or do you acutally know it's not working?

Jonas

2011/3/1 Marko Ristola <marko.ristola@kolumbus.fi>:
> 28.02.2011 19:26, Jonas Hanschke kirjoitti:
>>
>> Hi,
>>
>> despite lots of time spent tinkering around and looking for help on
>> the web, I've had no success in getting to work the remote control of
>> my DVB-C card.
>>
>> It is a Terratec Cinergy C:
>> http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C
>>
>> and am using the Mantis driver. Since it was merged into the kernel
>> tree in 2.6.33, watching TV works without patches, but the remote
>> control does not, although it is supposed to be supported, according
>> to the link above.
>>
>> Kernel is a vanilla 2.6.37.2 with custom configuration on an old AMD
>> Athlon XP machine, running debian Squeeze.
>>
>>
>> When I modprobe the Mantis driver, the following IR-modules are pulled
>> in automagically:
>> ir_lirc_codec
>> lirc_dev
>> ir_core
>>
>> However, no input device is created during module loading. dmesg output:
>> Mantis 0000:01:0a.0: PCI INT A ->  Link[APC1] ->  GSI 16 (level, high) ->
>>  IRQ 16
>> DVB: registering new adapter (Mantis DVB adapter)
>> IR LIRC bridge handler initialized
>> DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
>>
>> Am I missing some additional modules? Are there any dependencies on
>> other kernel config options that are not handled automatically by make
>> menuconf?
>>
>> If additional information is needed, I will be happy to provide it.
>> However, I am not sure what is useful and what is not and did not want
>> to bloat this message.
>
> Before merging into v4l-dvb, doing modprobe mantis was enough.
> I don't know how it should work with recent kernels.
> I haven't seen remote control working lately.
>
> Turning mantis module debug options on gives some information
> what is happening into /var/log/messages.
>
> Regards,
> Marko Ristola
>
>>
>> Thanks in advance,
>>
>> Jonas
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
