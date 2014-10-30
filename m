Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46815 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaJ3GEb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 02:04:31 -0400
Received: by mail-wg0-f46.google.com with SMTP id x13so3442850wgg.19
        for <linux-media@vger.kernel.org>; Wed, 29 Oct 2014 23:04:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141029070849.0a1c6d56@recife.lan>
References: <1408253089-9487-1-git-send-email-olli.salonen@iki.fi>
	<20141029070849.0a1c6d56@recife.lan>
Date: Thu, 30 Oct 2014 08:04:29 +0200
Message-ID: <CAAZRmGxSDQhKERhMeRqae-8RBsjjuDq0kN6HmEiLfodz7dhCMg@mail.gmail.com>
Subject: Re: [PATCH] si2157: Add support for delivery system SYS_ATSC
From: Olli Salonen <olli.salonen@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

No, for ClearQAM the delivery_system should be set to 0x10 and this
patch does not include that. At the time of submission of that patch I
only had the trace from the ATSC case.

ATSC & ClearQAM USB sniffs here:
http://trsqr.net/olli/hvr955q/

Cheers,
-olli

On 29 October 2014 11:08, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> Hi Olli,
>
> Em Sun, 17 Aug 2014 08:24:49 +0300
> Olli Salonen <olli.salonen@iki.fi> escreveu:
>
>> Set the property for delivery system also in case of SYS_ATSC. This
>> behaviour is observed in the sniffs taken with Hauppauge HVR-955Q
>> Windows driver.
>>
>> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
>> ---
>>  drivers/media/tuners/si2157.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
>> index 6c53edb..3b86d59 100644
>> --- a/drivers/media/tuners/si2157.c
>> +++ b/drivers/media/tuners/si2157.c
>> @@ -239,6 +239,9 @@ static int si2157_set_params(struct dvb_frontend *fe)
>>               bandwidth = 0x0f;
>>
>>       switch (c->delivery_system) {
>> +     case SYS_ATSC:
>> +                     delivery_system = 0x00;
>> +                     break;
>
> Did you check if it uses the same delivery system also for clear-QAM?
>
> If so, this patch is missing SYS_DVBC_ANNEX_B inside this case.
>
> Ah, FYI, I merged the demod used on HVR-955Q at a separate topic branch
> upstream:
>         http://git.linuxtv.org/cgit.cgi/media_tree.git/log/?h=lgdt3306a
>
> Regards,
> Mauro
