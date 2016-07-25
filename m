Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.15]:36459 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750697AbcGYECM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2016 00:02:12 -0400
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com [209.85.223.175])
	by imap.netup.ru (Postfix) with ESMTPA id 85ED17C054E
	for <linux-media@vger.kernel.org>; Mon, 25 Jul 2016 07:02:08 +0300 (MSK)
Received: by mail-io0-f175.google.com with SMTP id q83so151560579iod.1
        for <linux-media@vger.kernel.org>; Sun, 24 Jul 2016 21:02:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160722161851.034752e7@recife.lan>
References: <1469210077-12313-1-git-send-email-aospan@netup.ru> <20160722161851.034752e7@recife.lan>
From: Abylay Ospan <aospan@netup.ru>
Date: Mon, 25 Jul 2016 00:01:48 -0400
Message-ID: <CAK3bHNV1jmLjZupqBi-6y_CRcgTsvEg3wWpaUkFh5BKREUvz5A@mail.gmail.com>
Subject: Re: [PATCH] [dvbv5-scan] wait no more than timeout when scanning
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I have checked 'do_timeout' - it's bit different that we want. I just
updated patch to use 'clock_gettime(CLOCK_MONOTONIC' to avoid
timestamps 'rollup'.
Hope it's ok. The problem is really annoying because scanning takes a
lot of time.
Without this patch command 'dvbv5-scan
us-ATSC-center-frequencies-8VSB' takes about 2 hours.
with patch it takes just 6min 45sec - which better but has a room for
optimization inside lgdt3306a.c driver - it waits about 4 sec for each
read status which I think is too long. If we have signal we should
lock in about 100-500 msec. I will check this question later.

2016-07-22 15:18 GMT-04:00 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> Hi Abylay,
>
> Em Fri, 22 Jul 2016 13:54:37 -0400
> Abylay Ospan <aospan@netup.ru> escreveu:
>
>> some frontends (mentioned on lgdt3306a) wait timeout inside code like:
>> for (i = 20; i > 0; i--) {
>>   msleep(50);
>>
>> If there is no-LOCK then dvbv5-scan spent a lot of time (doing 40x calls).
>> This patch introduce timeout which 4 sec * multiply. So we do not wait more
>> than 4 sec (or so) if no-LOCK.
>>
>> Signed-off-by: Abylay Ospan <aospan@netup.ru>
>> ---
>>  utils/dvb/dvbv5-scan.c | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
>> index 689bc0b..1fc33d7 100644
>> --- a/utils/dvb/dvbv5-scan.c
>> +++ b/utils/dvb/dvbv5-scan.c
>> @@ -182,12 +182,23 @@ static int print_frontend_stats(struct arguments *args,
>>       return 0;
>>  }
>>
>> +/* return timestamp in msec */
>> +uint64_t get_timestamp()
>> +{
>> +     struct timeval now;
>> +     gettimeofday(&now, 0);
>> +     return now.tv_sec * 1000 + now.tv_usec/1000;
>
> This is not good, as gettimeofday() is not monotonic, and may be affected
> by clock adjustments.
>
> IMHO, the best would be to adjust the do_timeout() to handle
> args->timeout_multiply.
>
> Regards,
> Mauro
>
>> +}
>> +
>>  static int check_frontend(void *__args,
>>                         struct dvb_v5_fe_parms *parms)
>>  {
>>       struct arguments *args = __args;
>>       int rc, i;
>>       fe_status_t status;
>> +     uint64_t start = get_timestamp();
>> +     /* msec timeout by default 4 sec * multiply */
>> +     uint64_t timeout = args->timeout_multiply * 4 * 1000;
>>
>>       args->n_status_lines = 0;
>>       for (i = 0; i < args->timeout_multiply * 40; i++) {
>> @@ -203,6 +214,10 @@ static int check_frontend(void *__args,
>>               print_frontend_stats(args, parms);
>>               if (status & FE_HAS_LOCK)
>>                       break;
>> +
>> +             if ((get_timestamp() - start) > timeout)
>> +                     break;
>> +
>>               usleep(100000);
>
> It would also make sense to remove the usleep here and
> use something else that would be checking timeout_flag,
> like:
>
>         for (i = 1; i < 100; i++) {
>                 if (timeout_flag)
>                         break;
>                 usleep(1000);
>         }
>
>
> --
> Thanks,
> Mauro



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
