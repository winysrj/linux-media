Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49731 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751014AbcIIPEJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Sep 2016 11:04:09 -0400
Subject: Re: [GIT PULL STABLE 4.6] af9035 regression
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1e077824-104b-4665-96c8-de46c1a63a5d@iki.fi>
 <20160909114906.66c77b1b@vento.lan>
Cc: LMML <linux-media@vger.kernel.org>,
        =?UTF-8?Q?Stefan_P=c3=b6schel?= <basic.master@gmx.de>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <943812ea-cec5-46a1-8652-a468ebb2cb42@iki.fi>
Date: Fri, 9 Sep 2016 18:04:07 +0300
MIME-Version: 1.0
In-Reply-To: <20160909114906.66c77b1b@vento.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/2016 05:49 PM, Mauro Carvalho Chehab wrote:
> Hi Antti,
>
> Em Sat, 3 Sep 2016 02:40:52 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> The following changes since commit 2dcd0af568b0cf583645c8a317dd12e344b1c72a:
>>
>>    Linux 4.6 (2016-05-15 15:43:13 -0700)
>
> Is this patchset really meant to Kernel 4.6? if so, you should send
> the path to stable@vger.kernel.org, c/c the mailing list.
>
> It helps to point the original patch that fixed the issue upstream,
> as they won't apply the fix if it was not fixed upstream yet.

I think you already applied upstream patch, that one is just back-ported 
to 4.6.

It is that patch:
https://patchwork.linuxtv.org/patch/36795/

and it contains all the needed tags including Cc stable. Could you send 
it to stable?

Antti

>
> Regards,
> Mauro
>
>>
>> are available in the git repository at:
>>
>>    git://linuxtv.org/anttip/media_tree.git af9035_fix
>>
>> for you to fetch changes up to 7bb87ff5255defe87916f32cd1fcef163a489339:
>>
>>    af9035: fix dual tuner detection with PCTV 79e (2016-09-03 02:23:44
>> +0300)
>>
>> ----------------------------------------------------------------
>> Stefan Pöschel (1):
>>        af9035: fix dual tuner detection with PCTV 79e
>>
>>   drivers/media/usb/dvb-usb-v2/af9035.c | 53
>> +++++++++++++++++++++++++++++++++++------------------
>>   drivers/media/usb/dvb-usb-v2/af9035.h |  2 +-
>>   2 files changed, 36 insertions(+), 19 deletions(-)
>>
>
>
>
> Thanks,
> Mauro
>

-- 
http://palosaari.fi/
