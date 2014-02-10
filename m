Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:42195 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaBJUJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 15:09:34 -0500
Received: by mail-qa0-f53.google.com with SMTP id cm18so10223152qab.40
        for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 12:09:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52F8AA42.2020409@imgtec.com>
References: <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com>
	<1391861250-26068-1-git-send-email-a.seppala@gmail.com>
	<1391861250-26068-3-git-send-email-a.seppala@gmail.com>
	<52F8AA42.2020409@imgtec.com>
Date: Mon, 10 Feb 2014 22:09:33 +0200
Message-ID: <CAKv9HNZj2Jr4GnHXAtvqfaVsmQFVUxBmZZT-rBePoHB0X8ShiA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] ir-rc5-sz: Add ir encoding support
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James.

On 10 February 2014 12:30, James Hogan <james.hogan@imgtec.com> wrote:
> Hi Antti,
>
> On 08/02/14 12:07, Antti Seppälä wrote:
>> The encoding in rc5-sz first inserts a pulse and then simply utilizes the
>> generic Manchester encoder available in rc-core.
>>
>> Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
>> ---
>>  drivers/media/rc/ir-rc5-sz-decoder.c | 35 +++++++++++++++++++++++++++++++++++
>>  1 file changed, 35 insertions(+)
>>
>> diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
>> index 984e5b9..0d5e552 100644
>> --- a/drivers/media/rc/ir-rc5-sz-decoder.c
>> +++ b/drivers/media/rc/ir-rc5-sz-decoder.c
>> @@ -127,9 +127,44 @@ out:
>>       return -EINVAL;
>>  }
>>
>> +static struct ir_raw_timings_manchester ir_rc5_sz_timings = {
>> +     .pulse_space_start      = 0,
>> +     .clock                  = RC5_UNIT,
>> +};
>> +
>> +/*
>> + * ir_rc5_sz_encode() - Encode a scancode as a stream of raw events
>> + *
>> + * @protocols:  allowed protocols
>> + * @scancode:   scancode filter describing scancode (helps distinguish between
>> + *              protocol subtypes when scancode is ambiguous)
>> + * @events:     array of raw ir events to write into
>> + * @max:        maximum size of @events
>> + *
>> + * This function returns -EINVAL if the scancode filter is invalid or matches
>> + * multiple scancodes. Otherwise the number of ir_raw_events generated is
>> + * returned.
>> + */
>> +static int ir_rc5_sz_encode(u64 protocols,
>> +                         const struct rc_scancode_filter *scancode,
>> +                         struct ir_raw_event *events, unsigned int max)
>> +{
>> +     int ret;
>> +     struct ir_raw_event *e = events;
>
> Probably worth checking scancode->mask == 0xfff too?
>

I guess so. However if I'm not mistaken this makes all wakeup_filter
writes fail in user space if wakeup_filter_mask is not set. Is that
intended?

>> +
>> +     /* RC5-SZ scancode is raw enough for manchester as it is */
>> +     ret = ir_raw_gen_manchester(&e, max, &ir_rc5_sz_timings, RC5_SZ_NBITS,
>> +                                 scancode->data);
>> +     if (ret < 0)
>> +             return ret;
>
> I suspect it needs some more space at the end too, to be sure that no
> more bits afterwards are accepted.
>

I'm sorry but I'm not sure I completely understood what you meant
here. For RC-5-SZ the entire scancode gets encoded and nothing more.
Do you mean that the encoder should append some ir silence to the end
result to make sure the ir sample has ended?

-Antti
