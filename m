Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42226 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab0GDAqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Jul 2010 20:46:35 -0400
Received: by qwh6 with SMTP id 6so455911qwh.19
        for <linux-media@vger.kernel.org>; Sat, 03 Jul 2010 17:46:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C2FB6E8.5090001@redhat.com>
References: <20100616201046.GA10000@redhat.com>
	<20100703040227.GA31255@redhat.com>
	<4C2FB6E8.5090001@redhat.com>
Date: Sat, 3 Jul 2010 20:41:21 -0400
Message-ID: <AANLkTimbfm9nGxtNyCnpNFz3WhP1g6CzMQvRP0lJe9Dc@mail.gmail.com>
Subject: Re: [PATCH] IR/mceusb: kill pinnacle-device-specific nonsense
From: Jarod Wilson <jarod@wilsonet.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday, July 3, 2010, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em 03-07-2010 01:02, Jarod Wilson escreveu:
>> I have pinnacle hardware now. None of this pinnacle-specific crap is at
>> all necessary (in fact, some of it needed to be removed to actually make
>> it work). The only thing unique about this device is that it often
>> transfers inbound data w/a header of 0x90, meaning 16 bytes of IR data
>> following it, so I had to make adjustments for that, and now its working
>> perfectly fine.
>>
>> v2: stillborn
>>
>> v3: remove completely unnecessary usb_reset_device() call that only served
>> to piss off the pinnacle device regularly and unify/simplify some of the
>> generation-specific device initialization code.
>>
>> post-mortem: it seems the pinnacle hardware actually still gets pissed off
>> from time to time, but I can (try) to fix that later (if possible). The
>> patch is still quite helpful from a code reduction standpoint.
>>
>> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>
> I've already applied a previous version of this patch:
>
> http://git.linuxtv.org/v4l-dvb.git?a=commit;h=afd46362e573276e3fb0a44834ad320c97947233
>
> Could you please rebase it against my tree?

D'oh, sure, will do, should be able to knock that out tonight.

>> ---
>>  Makefile                  |    2 +-
>>  drivers/media/IR/mceusb.c |  110 +++++++++------------------------------------
>>  2 files changed, 22 insertions(+), 90 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 6e39ec7..0417c74 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -1,7 +1,7 @@
>>  VERSION = 2
>>  PATCHLEVEL = 6
>>  SUBLEVEL = 35
>> -EXTRAVERSION = -rc1
>> +EXTRAVERSION = -rc1-ir
>
> Please, don't patch the upstream Makefile ;)

Gah, I saw that and meant to remove it. The perils of rushing things
the night before going on vacation...

--jarod



-- 
Jarod Wilson
jarod@wilsonet.com
