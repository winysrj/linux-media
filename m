Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36014 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbbKRTjU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 14:39:20 -0500
Received: by lbblt2 with SMTP id lt2so30929275lbb.3
        for <linux-media@vger.kernel.org>; Wed, 18 Nov 2015 11:39:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <564CCCA1.6010808@web.de>
References: <564C9355.1090203@web.de>
	<564CA4EB.60400@gmail.com>
	<564CCCA1.6010808@web.de>
Date: Wed, 18 Nov 2015 20:39:18 +0100
Message-ID: <CAOEt8JJxi5kzjWxzuPzfr43NR5p+Fk0+VkqeDsBB2JEq2isgMg@mail.gmail.com>
Subject: Re: [BUG] TechniSat SkyStar S2 - problem tuning DVB-S2 channels
From: David Jedelsky <david.jedelsky@gmail.com>
To: Robert <wslegend@web.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert,

I'm not sure whether it helps, but if your card is based on az6027, as
is my USB TechniSat SkyStar 2 HD CI, then attached patch could be
helpful. I had to create it to get DVB-S2 working on my device.
http://djed.cz/az6027-i2c.patch

Regards,
David

PS: trying to send once more with link instead of attachment (as
linuxmedia list rejected my previous mail)

On Wed, Nov 18, 2015 at 8:08 PM, Robert <wslegend@web.de> wrote:
> Hi Jemma,
>
> On 18.11.2015 17:18, Jemma Denson wrote:
>> What program are you using to try and tune? Is it trying to tune in
>> using DVB-S2? The "other" driver was done quite some while ago, and
>> included some clunky code to fallback to S2 if DVB-S tuning failed as it
>> was developed before the DVB API had support for supplying DVB-S2 as a
>> delivery system and this was the only way of supporting S2 back then.
>> This was removed in the in-tree driver as it isn't needed anymore, but
>> this does mean that the tuning program needs to supply the correct
>> delivery system.
>>
>> Have you tried it with dvbv5-scan & dvbv5-zap?
>
> Normally i'm using kaffeine, but i have tried dvbv5-scan now.
> Unfortunately it segfaults. I have attached the full output including
> the backtrace [1]
>
>
> Greetings,
> Robert
>
>
> [1]
> https://paste.linuxlounge.net/?c3886ef444f9aa37#2ah2g19a9CfJMA/pBDikwoWj7S4AG2slhacWjXy8jEo=
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
