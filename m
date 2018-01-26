Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:39966 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751973AbeAZH7j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 02:59:39 -0500
Received: by mail-wm0-f54.google.com with SMTP id v123so19333579wmd.5
        for <linux-media@vger.kernel.org>; Thu, 25 Jan 2018 23:59:39 -0800 (PST)
Subject: Re: SAA716x DVB driver
To: Soeren Moch <smoch@web.de>, Jemma Denson <jdenson@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Luis Alves <ljalvs@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <526637b0-7124-84eb-4ebc-689e83d96117@web.de>
From: =?UTF-8?Q?Tycho_L=c3=bcrsen?= <tycholursen@gmail.com>
Message-ID: <7f491dce-55fb-9229-cf2e-e20ac8821dc9@gmail.com>
Date: Fri, 26 Jan 2018 08:59:35 +0100
MIME-Version: 1.0
In-Reply-To: <526637b0-7124-84eb-4ebc-689e83d96117@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Soeren


Op 25-01-18 om 20:56 schreef Soeren Moch:
> Hi all,
>
> I know anything about this driver. I'm still ready to maintain this, in
> fact I'm doing this for years.
> Why do you look for another maintainer instead of supporting my pull
> request?
I did support your pull request, still do!
The reason for looking for another maintainer is that you said that it 
makes no sense maintaining this driver in-tree when your ff part is not 
supported. And Mauro still does not want to merge it as is, due to that 
ff part of the driver.
>   In the long lasting discussion about this there was not a
> single technical reason why this driver cannot be merged as is,
> especially in staging as first step to do the required cleanup.
>
> Regards,
> Soeren
>
> On 25.01.2018 18:08, Jemma Denson wrote:
>> Hi Tycho,
>>
>> On 20/01/18 15:49, Tycho Lürsen wrote:
>>> Right, but we still need a maintainer. Are you capable/willing to
>>> volunteer for the job?
>> If no-one else will then yes I can, but I can't claim to know these devices
>> inside out. It would really depend on what's required of a maintainer, I'm
>> struggling to find this documented anywhere.
>>
>> Cards I can't test with would really need someone to be able to add a
>> tested-by to verify they work.
>>
>>>>> I think that your proposal to use a stripped version of Luis Alves
>>>>> repo is a no go, since it contains a couple of demod/tuner drivers
>>>>> that are not upstreamed yet. That complicates the upstreaming process
>>>>> too much, I think.
>>>> Oh, I would have stripped it *right* down and removed every card except
>>>> my TBS6280. The end result would probably be pretty close to Soeren's at
>>>> that point anyway, so I was starting to think like what you've done and
>>>> base it on that instead.
>>> If you want, I can strip the driver down a lot more and ad back the
>>> drivers you need. Just tell me what it is you need.
>> As above, it's really just a case of making it maintainable. If someone
>> can step forward and ack for them working then they could be included
>> but if not then I think it's best dropping them until that happens.
>>
>>
>> Jemma.
Cheers,
Tycho.
