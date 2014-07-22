Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:48386 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbaGVQ2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 12:28:08 -0400
Received: by mail-oa0-f45.google.com with SMTP id i7so10025148oag.4
        for <linux-media@vger.kernel.org>; Tue, 22 Jul 2014 09:28:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140722131059.4ad26777.m.chehab@samsung.com>
References: <1406027388-10336-1-git-send-email-ljalvs@gmail.com>
	<20140722131059.4ad26777.m.chehab@samsung.com>
Date: Tue, 22 Jul 2014 17:28:07 +0100
Message-ID: <CAGj5WxBiioMVJTgX9zKqMsFTmL3Cjnb3pVkLc6eaCGJHsFf0Zw@mail.gmail.com>
Subject: Re: [PATCH] si2157: Fix DVB-C bandwidth.
From: Luis Alves <ljalvs@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That's right,
A few days ago I also checked that with Antti. I've also had made some
debugging and DVB core is in fact passing the correct bandwidth to the
driver.

But the true is that it doesn't work...
The sample I have is a dvb-c mux using QAM128 @ 6 Mbaud (which results
in 7MHz bw) using 7MHz filter value will make the TS stream
unwatchable (lots of continuity errors).

Can this be a hardware fault?
All closed source drivers I've seen are hardcoding this value to 8MHz
when working in dvb-c (easily seen on i2c sniffs).


On Tue, Jul 22, 2014 at 5:10 PM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Em Tue, 22 Jul 2014 12:09:48 +0100
> Luis Alves <ljalvs@gmail.com> escreveu:
>
>> This patch fixes DVB-C reception.
>> Without setting the bandwidth to 8MHz the received stream gets corrupted.
>>
>> Regards,
>> Luis
>>
>> Signed-off-by: Luis Alves <ljalvs@gmail.com>
>> ---
>>  drivers/media/tuners/si2157.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
>> index 6c53edb..e2de428 100644
>> --- a/drivers/media/tuners/si2157.c
>> +++ b/drivers/media/tuners/si2157.c
>> @@ -245,6 +245,7 @@ static int si2157_set_params(struct dvb_frontend *fe)
>>                       break;
>>       case SYS_DVBC_ANNEX_A:
>>                       delivery_system = 0x30;
>> +                     bandwidth = 0x08;
>
> Hmm... this patch looks wrong, as it will break DVB-C support where
> the bandwidth is lower than 6MHz.
>
> The DVB core sets c->bandwidth_hz for DVB-C based on the rolloff and
> the symbol rate. If this is not working for you, then something else
> is likely wrong.
>
> I suggest you to add a printk() there to show what's the value set
> at c->bandwidth_hz and what's the symbol rate that you're using.
>
> On DVB-C, the rolloff is fixed (1.15 for annex A and 1.13 for Annex C).
> Not sure if DVB-C2 allows selecting a different rolloff factor, nor
> if si2157 works with DVB-C2.
>
>>                       break;
>>       default:
>>                       ret = -EINVAL;
