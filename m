Return-path: <mchehab@pedra>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:58165 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab1EFRhP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2011 13:37:15 -0400
Message-ID: <4DC431C6.1010605@kolumbus.fi>
Date: Fri, 06 May 2011 20:37:10 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: "Adrian C." <anrxc@sysphere.org>
CC: linux-media@vger.kernel.org
Subject: Re: Remote control not working for Terratec Cinergy C (2.6.37 Mantis
 driver)
References: <alpine.LNX.2.00.1105040038430.10167@flfcurer.bet>
In-Reply-To: <alpine.LNX.2.00.1105040038430.10167@flfcurer.bet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

04.05.2011 01:42, Adrian C. kirjoitti:
> On Wed, 2 Mar 2011, Marko Ristola wrote:
> 
>> So this means, that my remote control works, pressing key with hex 
>> value 0x26 works.
> 
> It works.
> 
>> Unfortunately mantis_uart.c doesn't have IR input initialization at 
>> all
> 
> But it does not work. How can it work and not work at the same time?
The hardware device is active (it is enabled, messages are sent from
the remote to the Kernel Mantis software driver.
The bytes can be logged into /var/log/messages file.

That's all the driver is designed to do at this point.

> 
> 
> I have the Skystar HD2 (b), subsystem: 1ae4:0003 now, same chipset as 
> Cinergy S2 and some others, VP-1041. Lirc failed with my old COM 
> receiver so I tried to use the cards IR as fall-back, and of course I 
> failed again. This was on 2.6.38.4.
> 
> Only information I found is 1 year old[1]. "IR was in flux" but it still 
> doesn't work even though mantis pulls in all those ir-* modules, no 
> input device is created.
> 
> Can someone fill us in, please, will it be supported this year?
Would you please ask from Manu Abraham. Maybe he gets paid for doing it.
I have experimented with my remote control too a few years ago,
but I think it is good if Manu gets it as a job.

Regards,
Marko Ristola

> 
> 
> 1. http://www.mail-archive.com/linux-media@vger.kernel.org/msg14641.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

