Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.50.161]:44258 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751248AbdGQEeC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 00:34:02 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id AE1B6197AB
        for <linux-media@vger.kernel.org>; Sun, 16 Jul 2017 23:10:39 -0500 (CDT)
Subject: Re: [PATCH] ddbridge: constify i2c_algorithm structure
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20170710011536.GA24235@embeddedgus>
 <20170710171654.3b45ae08@audiostation.wuest.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-ID: <341450f0-94eb-0bed-2ebf-0f6fdcaf2ef8@embeddedor.com>
Date: Sun, 16 Jul 2017 23:10:38 -0500
MIME-Version: 1.0
In-Reply-To: <20170710171654.3b45ae08@audiostation.wuest.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,


On 07/10/2017 10:16 AM, Daniel Scheller wrote:
> Am Sun, 9 Jul 2017 20:15:36 -0500
> schrieb "Gustavo A. R. Silva" <garsilva@embeddedor.com>:
>
>> Check for i2c_algorithm structures that are only stored in
>> the algo field of an i2c_adapter structure. This field is
>> declared const, so i2c_algorithm structures that have this
>> property can be declared as const also.
>>
>> This issue was identified using Coccinelle and the following
>> semantic patch:
>>
>> @r disable optional_qualifier@
>> identifier i;
>> position p;
>> @@
>> static struct i2c_algorithm i@p = { ... };
>>
>> @ok@
>> identifier r.i;
>> struct i2c_adapter e;
>> position p;
>> @@
>> e.algo = &i@p;
>>
>> @bad@
>> position p != {r.p,ok.p};
>> identifier r.i;
>> @@
>> i@p
>>
>> @depends on !bad disable optional_qualifier@
>> identifier r.i;
>> @@
>> static
>> +const
>>   struct i2c_algorithm i = { ... };
>>
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>> ---
>>   drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c
>> b/drivers/media/pci/ddbridge/ddbridge-core.c index cd1723e..9663a4c
>> 100644 --- a/drivers/media/pci/ddbridge/ddbridge-core.c
>> +++ b/drivers/media/pci/ddbridge/ddbridge-core.c
>> @@ -200,7 +200,7 @@ static u32 ddb_i2c_functionality(struct
>> i2c_adapter *adap) return I2C_FUNC_SMBUS_EMUL;
>>   }
>>   
>> -static struct i2c_algorithm ddb_i2c_algo = {
>> +static const struct i2c_algorithm ddb_i2c_algo = {
>>   	.master_xfer   = ddb_i2c_master_xfer,
>>   	.functionality = ddb_i2c_functionality,
>>   };
> Hi Gustavo,
> Hi all,
>
> please hold this single one patch from the constify patches back for
> now, since we're in the process of bumping the whole driver to a newer
> version which involves lots of code shuffling. With this, quite some
> GIT rebasing work needs to be done, and adding this one liner at a
> later time (thus rebasing it) is way easier.
>
> To be sure this will not be forgotten afterwards, I've already posted a
> patch applying the exact change at [1].
>
> Thank you very much!
>
> [1] https://patchwork.linuxtv.org/patch/42393/

Thank you!

-- 
Gustavo A. R. Silva
