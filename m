Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.15]:34850 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbcGYT1G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2016 15:27:06 -0400
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com [209.85.223.170])
	by imap.netup.ru (Postfix) with ESMTPA id 2D80F7C059F
	for <linux-media@vger.kernel.org>; Mon, 25 Jul 2016 22:27:00 +0300 (MSK)
Received: by mail-io0-f170.google.com with SMTP id 38so170967833iol.0
        for <linux-media@vger.kernel.org>; Mon, 25 Jul 2016 12:26:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOcJUby+9gTrFUF14pvo1iMa2azD5TfGM8WgeZY1+Bh8CTYVzA@mail.gmail.com>
References: <1469471939-25393-1-git-send-email-aospan@netup.ru> <CAOcJUby+9gTrFUF14pvo1iMa2azD5TfGM8WgeZY1+Bh8CTYVzA@mail.gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Mon, 25 Jul 2016 15:26:39 -0400
Message-ID: <CAK3bHNW_6XXkJjotWeJRGTVi5f0L_e04KxXoa3oerwF+zLebBA@mail.gmail.com>
Subject: Re: [PATCH] [media] lgdt3306a: remove 20*50 msec unnecessary timeout
To: Michael Ira Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

thanks for update. ok, I will investigate this more heavily later.
Please, do not merge this patch. Seems like we need more
consultation/testing (as I understand especially on 'weak' ATSC
signals).


2016-07-25 14:55 GMT-04:00 Michael Ira Krufky <mkrufky@linuxtv.org>:
> On Mon, Jul 25, 2016 at 2:38 PM, Abylay Ospan <aospan@netup.ru> wrote:
>> inside lgdt3306a_search we reading demod status 20 times with 50 msec sleep after each read.
>> This gives us more than 1 sec of delay. Removing this delay should not affect demod functionality.
>>
>> Signed-off-by: Abylay Ospan <aospan@netup.ru>
>> ---
>>  drivers/media/dvb-frontends/lgdt3306a.c | 16 ++++------------
>>  1 file changed, 4 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
>> index 179c26e..dad7ad3 100644
>> --- a/drivers/media/dvb-frontends/lgdt3306a.c
>> +++ b/drivers/media/dvb-frontends/lgdt3306a.c
>> @@ -1737,24 +1737,16 @@ static int lgdt3306a_get_tune_settings(struct dvb_frontend *fe,
>>  static int lgdt3306a_search(struct dvb_frontend *fe)
>>  {
>>         enum fe_status status = 0;
>> -       int i, ret;
>> +       int ret;
>>
>>         /* set frontend */
>>         ret = lgdt3306a_set_parameters(fe);
>>         if (ret)
>>                 goto error;
>>
>> -       /* wait frontend lock */
>> -       for (i = 20; i > 0; i--) {
>> -               dbg_info(": loop=%d\n", i);
>> -               msleep(50);
>> -               ret = lgdt3306a_read_status(fe, &status);
>> -               if (ret)
>> -                       goto error;
>> -
>> -               if (status & FE_HAS_LOCK)
>> -                       break;
>> -       }
>> +       ret = lgdt3306a_read_status(fe, &status);
>> +       if (ret)
>> +               goto error;
>>
>>         /* check if we have a valid signal */
>>         if (status & FE_HAS_LOCK)
>
> Your patch removes a loop that was purposefully written here to handle
> conditions that are not ideal.  Are you sure this change is best for
> all users?
>
> I would disagree with merging this patch.
>
> Best regards,
>
> Michael Ira Krufky



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
