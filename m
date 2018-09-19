Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:35683 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726887AbeISHGX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 03:06:23 -0400
Message-ID: <5BA1A6D0.4090506@huawei.com>
Date: Wed, 19 Sep 2018 09:30:56 +0800
From: zhong jiang <zhongjiang@huawei.com>
MIME-Version: 1.0
To: Michael Ira Krufky <mkrufky@linuxtv.org>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Brad Love <brad@nextdimension.cc>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: dvb-frontends: Use kmemdup instead of duplicating
 its function
References: <1537284628-62020-1-git-send-email-zhongjiang@huawei.com> <CAOcJUbzfv8DLpRAbAiodqDDQ5wH1uyqjJ-sKN+qJGr=xagQBNg@mail.gmail.com>
In-Reply-To: <CAOcJUbzfv8DLpRAbAiodqDDQ5wH1uyqjJ-sKN+qJGr=xagQBNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018/9/19 3:58, Michael Ira Krufky wrote:
> On Tue, Sep 18, 2018 at 11:42 AM zhong jiang <zhongjiang@huawei.com> wrote:
>> kmemdup has implemented the function that kmalloc() + memcpy().
>> We prefer to kmemdup rather than code opened implementation.
>>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>> ---
>>  drivers/media/dvb-frontends/lgdt3306a.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
>> index 0e1f5da..abec2e5 100644
>> --- a/drivers/media/dvb-frontends/lgdt3306a.c
>> +++ b/drivers/media/dvb-frontends/lgdt3306a.c
>> @@ -2205,15 +2205,13 @@ static int lgdt3306a_probe(struct i2c_client *client,
>>         struct dvb_frontend *fe;
>>         int ret;
>>
>> -       config = kzalloc(sizeof(struct lgdt3306a_config), GFP_KERNEL);
>> +       onfig = kmemdup(client->dev.platform_data,
>> +                       sizeof(struct lgdt3306a_config), GFP_KERNEL);
>>         if (config == NULL) {
>>                 ret = -ENOMEM;
>>                 goto fail;
>>         }
>>
>> -       memcpy(config, client->dev.platform_data,
>> -                       sizeof(struct lgdt3306a_config));
>> -
>>         config->i2c_addr = client->addr;
>>         fe = lgdt3306a_attach(config, client->adapter);
>>         if (fe == NULL) {
> Thank you for this patch, Zhong.  I suspect, however, that the patch
> might contain a typo.  It looks like the `c` got dropped off of the
> `config` variable.
I am sorry.  It's my fault.:-[ . Will repost

Thanks,
zhong jiang
> Did you test this before sending it in?
>
> Thanks again and best regards,
>
> Michael Krufky
>
> .
>
