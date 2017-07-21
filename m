Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60173 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbdGUSJ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 14:09:59 -0400
Subject: Re: [PATCH] dvb_frontend: initialize variable s with FE_NONE instead
 of 0
To: shuah@kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-media@vger.kernel.org
References: <20170721160100.22617-1-colin.king@canonical.com>
 <85739b36-5d04-a64f-e3d5-b8f84bf9d19a@kernel.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <776ac501-57a2-1e39-1546-3b168d602bf3@canonical.com>
Date: Fri, 21 Jul 2017 19:09:56 +0100
MIME-Version: 1.0
In-Reply-To: <85739b36-5d04-a64f-e3d5-b8f84bf9d19a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/07/17 19:05, Shuah Khan wrote:
> On 07/21/2017 10:01 AM, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> In a previous commit, we added FE_NONE as an unknown fe_status.
>> Initialize variable s to FE_NONE instead of the more opaque value 0.
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> The change looks good to me.
> Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
> 
> I think this patch should be part of a patch series that includes
> the uAPI Documentation change, uAPI change, and the following
> patch:
> 
> [PATCH][V2] dvb_frontend: ensure that inital front end status initialized
> 
> based on Mauro's review comments. Anyway, I will leave it to Mauro to
> decide how he wants the patches split and if he is okay with uAPI change.
> 

OK, I'm off on vacation very shortly, so I won't be able to respond for
any further resubmissions for a couple of weeks.

> thanks,
> -- Shuah
> 
>> ---
>>  drivers/media/dvb-core/dvb_frontend.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
>> index 18cc3bbc699c..114994ca0929 100644
>> --- a/drivers/media/dvb-core/dvb_frontend.c
>> +++ b/drivers/media/dvb-core/dvb_frontend.c
>> @@ -460,7 +460,7 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
>>  
>>  static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
>>  {
>> -	enum fe_status s = 0;
>> +	enum fe_status s = FE_NONE;
>>  	int retval = 0;
>>  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache, tmp;
>>
> 
