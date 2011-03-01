Return-path: <mchehab@pedra>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:57031 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1CASLf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 13:11:35 -0500
Message-ID: <4D6D3464.2030602@kolumbus.fi>
Date: Tue, 01 Mar 2011 20:01:08 +0200
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Jonas Hanschke <jonas.hanschke@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Remote control not working for Terratec Cinergy C (2.6.37 Mantis
 driver)
References: <AANLkTinfJiCpMOTx4-mc6jW3Bpe_3qduLYpqvRi8U+ga@mail.gmail.com>
In-Reply-To: <AANLkTinfJiCpMOTx4-mc6jW3Bpe_3qduLYpqvRi8U+ga@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

28.02.2011 19:26, Jonas Hanschke kirjoitti:
> Hi,
>
> despite lots of time spent tinkering around and looking for help on
> the web, I've had no success in getting to work the remote control of
> my DVB-C card.
>
> It is a Terratec Cinergy C:
> http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C
>
> and am using the Mantis driver. Since it was merged into the kernel
> tree in 2.6.33, watching TV works without patches, but the remote
> control does not, although it is supposed to be supported, according
> to the link above.
>
> Kernel is a vanilla 2.6.37.2 with custom configuration on an old AMD
> Athlon XP machine, running debian Squeeze.
>
>
> When I modprobe the Mantis driver, the following IR-modules are pulled
> in automagically:
> ir_lirc_codec
> lirc_dev
> ir_core
>
> However, no input device is created during module loading. dmesg output:
> Mantis 0000:01:0a.0: PCI INT A ->  Link[APC1] ->  GSI 16 (level, high) ->  IRQ 16
> DVB: registering new adapter (Mantis DVB adapter)
> IR LIRC bridge handler initialized
> DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
>
> Am I missing some additional modules? Are there any dependencies on
> other kernel config options that are not handled automatically by make
> menuconf?
>
> If additional information is needed, I will be happy to provide it.
> However, I am not sure what is useful and what is not and did not want
> to bloat this message.

Before merging into v4l-dvb, doing modprobe mantis was enough.
I don't know how it should work with recent kernels.
I haven't seen remote control working lately.

Turning mantis module debug options on gives some information
what is happening into /var/log/messages.

Regards,
Marko Ristola

>
> Thanks in advance,
>
> Jonas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

