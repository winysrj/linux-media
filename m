Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.15]:33799 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbcGYSrm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2016 14:47:42 -0400
Received: from mail-io0-f177.google.com (mail-io0-f177.google.com [209.85.223.177])
	by imap.netup.ru (Postfix) with ESMTPA id B4EBF7C0557
	for <linux-media@vger.kernel.org>; Mon, 25 Jul 2016 21:47:39 +0300 (MSK)
Received: by mail-io0-f177.google.com with SMTP id b62so169687031iod.3
        for <linux-media@vger.kernel.org>; Mon, 25 Jul 2016 11:47:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160722161851.034752e7@recife.lan>
References: <1469210077-12313-1-git-send-email-aospan@netup.ru> <20160722161851.034752e7@recife.lan>
From: Abylay Ospan <aospan@netup.ru>
Date: Mon, 25 Jul 2016 14:47:18 -0400
Message-ID: <CAK3bHNW4cfRQuj2EYjdP6QjZR1T+NPXuZQwd2F8SM47W+W+DOg@mail.gmail.com>
Subject: Re: [PATCH] [dvbv5-scan] wait no more than timeout when scanning
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I have sent two patches to ML. One is for dvbv5-scan (v3 of this
patch) and second for lgdt3306a driver. Now I have achieved 4 minutes
for full scan (file us-ATSC-center-frequencies-8VSB with 68
frequencies inside). This is much better than 2 hours before :)
But need to test this patches if possible. Who works with lgdt3306a -
please test. Hope nothing is broken.

Thanks !

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
