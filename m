Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd16922.kasserver.com ([85.13.137.202]:34612 "EHLO
	dd16922.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab0FHEZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jun 2010 00:25:51 -0400
Message-ID: <4C0DC655.8040204@helmutauer.de>
Date: Tue, 08 Jun 2010 06:25:57 +0200
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: linux-media@vger.kernel.org
Subject: Re: v4l-dvb - Is it still usable for a distribution ?
References: <20100607112744.7B3B010FC20F@dd16922.kasserver.com>	<4C0CF124.4010103@redhat.com>	<AANLkTinisZ5DtH1Izn6WZS8isrF_G3oFZuppoHuwhlUj@mail.gmail.com>	<4C0D63AF.7090203@helmutauer.de> <AANLkTinavLdYZDZi1SjOyeKupWRX9kjA-Le7GFMQCWUB@mail.gmail.com>
In-Reply-To: <AANLkTinavLdYZDZi1SjOyeKupWRX9kjA-Le7GFMQCWUB@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

>> Is your imon driver fully compatible with the lirc_imon in the display part ?
> 
> Yes, works perfectly fine with the exact same lcdproc setup here --
> both vfd and lcd tested.
> 
fine - I will give it a try !

>> It would be very helpful to add a parameter for disabling the IR Part, I have many users which
>> are using only the display part.
> 
> Hm. I was going to suggest that if people aren't using the receiver,
> there should be no need to disable IR, but I guess someone might want
> to use an mce remote w/an mce receiver, and that would have
> interesting results if they had one of the imon IR receivers
> programmed for mce mode. 
>
Thats what I meant :)

> I'll keep it in mind for the next time I'm
> poking at the imon code in depth. 
Maybe you can use the already available ir_protocol parameter.

-- 
Helmut Auer, helmut@helmutauer.de
