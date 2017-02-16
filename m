Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33731 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752527AbdBPIy5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 03:54:57 -0500
Subject: Re: [PATCH v2 3/3] [media] dvbsky: MyGica T230C support
To: Stefan Bruens <stefan.bruens@rwth-aachen.de>
References: <20170215015122.4647-1-stefan.bruens@rwth-aachen.de>
 <884178a1fe9a4178a480b592e71820f7@rwthex-w2-b.rwth-ad.de>
 <599879d5-7925-6013-f8bb-a42df69e3f30@iki.fi>
 <8751632.4KFmXH3LkI@pebbles.site>
 <557ce694-5edd-169a-7062-da249137f2ed@iki.fi>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <2e741734-86d8-85df-b4f5-e47d99c6d0af@iki.fi>
Date: Thu, 16 Feb 2017 10:54:54 +0200
MIME-Version: 1.0
In-Reply-To: <557ce694-5edd-169a-7062-da249137f2ed@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/16/2017 10:48 AM, Antti Palosaari wrote:
> On 02/16/2017 01:31 AM, Stefan Bruens wrote:

>>>> +    /* attach demod */
>>>> +    memset(&si2168_config, 0, sizeof(si2168_config));
>>>
>>> prefer sizeof dst
>>
>> You mean sizeof(struct si2168_config) ?
>
> yeah. See chapter 14 from kernel coding style documentation, it handles
> issue slightly.

argh, I looked wrong! It is *correct*, do not change it. It is just as 
it should. Sorry about noise.

regards
Antti




-- 
http://palosaari.fi/
