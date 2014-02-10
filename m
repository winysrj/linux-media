Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:55899 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbaBJT41 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 14:56:27 -0500
Received: by mail-qc0-f179.google.com with SMTP id e16so11279016qcx.24
        for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 11:56:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52F8A906.9060303@imgtec.com>
References: <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com>
	<1391861250-26068-1-git-send-email-a.seppala@gmail.com>
	<1391861250-26068-2-git-send-email-a.seppala@gmail.com>
	<52F8A906.9060303@imgtec.com>
Date: Mon, 10 Feb 2014 21:56:23 +0200
Message-ID: <CAKv9HNYruPq7=G10BhiOYcx_fVz86mqQ4PKm=GKshNmNNmkYdg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] rc-core: Add Manchester encoder (phase encoder)
 support to rc-core
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi James.

On 10 February 2014 12:25, James Hogan <james.hogan@imgtec.com> wrote:
> Hi Antti,
>
> On 08/02/14 12:07, Antti Seppälä wrote:
>> Adding a simple Manchester encoder to rc-core.
>> Manchester coding is used by at least RC-5 protocol and its variants.
>>
>> Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
>> ---
>>  drivers/media/rc/ir-raw.c       | 44 +++++++++++++++++++++++++++++++++++++++++
>>  drivers/media/rc/rc-core-priv.h | 14 +++++++++++++
>>  2 files changed, 58 insertions(+)
>>
>> diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
>> index 9d734dd..7fea9ac 100644
>> --- a/drivers/media/rc/ir-raw.c
>> +++ b/drivers/media/rc/ir-raw.c
>> @@ -240,6 +240,50 @@ ir_raw_get_allowed_protocols(void)
>>       return protocols;
>>  }
>>
>> +int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
>> +                       const struct ir_raw_timings_manchester *timings,
>> +                       unsigned int n, unsigned int data)
>> +{
>> +     bool need_pulse;
>> +     int i, count = 0;
>> +     i = 1 << (n - 1);
>> +
>> +     if (n > max || max < 2)
>> +             return -EINVAL;
>> +
>> +     if (timings->pulse_space_start) {
>> +             init_ir_raw_event_duration((*ev)++, 1, timings->clock);
>> +             init_ir_raw_event_duration((*ev), 0, timings->clock);
>> +             count += 2;
>> +     } else {
>> +             init_ir_raw_event_duration((*ev), 1, timings->clock);
>> +             count++;
>> +     }
>> +     i >>= 1;
>
> If you use pulse_space_start to encode the first bit, did you mean to
> discard the highest bit of data?
>

I did not mean to discard data but to just start the ir pulse with
logic 1 as that first bit is discarded when decoding.

>> +
>> +     while (i > 0) {
>> +             if (count > max)
>
> if count > max I think you've already overflowed the buffer (max is more
> of a max count rather than max buffer index).
>

I guess you're right. I'll address this in next version of my patch.

>> +                     return -EINVAL;
>> +
>> +             need_pulse = !(data & i);
>> +             if (need_pulse == !!(*ev)->pulse) {
>> +                     (*ev)->duration += timings->clock;
>> +             } else {
>> +                     init_ir_raw_event_duration(++(*ev), need_pulse,
>> +                                                timings->clock);
>> +                     count++;
>
> I guess you need to check for buffer space here too.
>

This comment seems also correct. Thank you for reviewing.

>> +             }
>> +
>> +             init_ir_raw_event_duration(++(*ev), !need_pulse,
>> +                                        timings->clock);
>> +             count++;
>> +             i >>= 1;
>> +     }
>> +
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL(ir_raw_gen_manchester);
>
> Cheers
> James
>
