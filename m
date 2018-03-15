Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35176 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbeCOI6C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Mar 2018 04:58:02 -0400
Received: by mail-wr0-f196.google.com with SMTP id n12so7433044wra.2
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2018 01:58:01 -0700 (PDT)
Subject: Re: [PATCH] [media] ov5645: Move an error code assignment in
 ov5645_probe()
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <4efad917-ca08-f257-e9a1-b5bcb7df2df2@users.sourceforge.net>
 <20180314221702.5rtdttyqjcpysjkd@kekkonen.localdomain>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <1da1eeff-b566-e7a4-c1ef-a90ff635c846@linaro.org>
Date: Thu, 15 Mar 2018 10:57:58 +0200
MIME-Version: 1.0
In-Reply-To: <20180314221702.5rtdttyqjcpysjkd@kekkonen.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 15.03.2018 00:17, Sakari Ailus wrote:
> On Wed, Mar 14, 2018 at 10:15:43PM +0100, SF Markus Elfring wrote:
>> From: Markus Elfring <elfring@users.sourceforge.net>
>> Date: Wed, 14 Mar 2018 22:02:52 +0100
>>
>> Move an assignment for a specific error code so that it is stored only once
>> in this function implementation.
>>
>> This issue was detected by using the Coccinelle software.
> 
> How?
> 
>>
>> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
>> ---
>>  drivers/media/i2c/ov5645.c | 6 +-----
>>  1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
>> index d28845f7356f..374576380fd4 100644
>> --- a/drivers/media/i2c/ov5645.c
>> +++ b/drivers/media/i2c/ov5645.c
>> @@ -1284,13 +1284,11 @@ static int ov5645_probe(struct i2c_client *client,
>>  	ret = ov5645_read_reg(ov5645, OV5645_CHIP_ID_HIGH, &chip_id_high);
>>  	if (ret < 0 || chip_id_high != OV5645_CHIP_ID_HIGH_BYTE) {
>>  		dev_err(dev, "could not read ID high\n");
>> -		ret = -ENODEV;
>>  		goto power_down;
>>  	}
>>  	ret = ov5645_read_reg(ov5645, OV5645_CHIP_ID_LOW, &chip_id_low);
>>  	if (ret < 0 || chip_id_low != OV5645_CHIP_ID_LOW_BYTE) {
>>  		dev_err(dev, "could not read ID low\n");
>> -		ret = -ENODEV;
>>  		goto power_down;
>>  	}
>>  
>> @@ -1300,7 +1298,6 @@ static int ov5645_probe(struct i2c_client *client,
>>  			      &ov5645->aec_pk_manual);
>>  	if (ret < 0) {
>>  		dev_err(dev, "could not read AEC/AGC mode\n");
>> -		ret = -ENODEV;
>>  		goto power_down;
>>  	}
>>  
>> @@ -1308,7 +1305,6 @@ static int ov5645_probe(struct i2c_client *client,
>>  			      &ov5645->timing_tc_reg20);
>>  	if (ret < 0) {
>>  		dev_err(dev, "could not read vflip value\n");
>> -		ret = -ENODEV;
>>  		goto power_down;
>>  	}
>>  
>> @@ -1316,7 +1312,6 @@ static int ov5645_probe(struct i2c_client *client,
>>  			      &ov5645->timing_tc_reg21);
>>  	if (ret < 0) {
>>  		dev_err(dev, "could not read hflip value\n");
>> -		ret = -ENODEV;
>>  		goto power_down;
>>  	}
>>  
>> @@ -1334,6 +1329,7 @@ static int ov5645_probe(struct i2c_client *client,
>>  
>>  power_down:
>>  	ov5645_s_power(&ov5645->sd, false);
>> +	ret = -ENODEV;
> 
> I don't think this is where people would expect you to set the error code
> in general. It should rather take place before goto, not after it. That'd
> mean another variable, and I'm not convinced the result would improve the
> driver.

I agree with Sakari.

> 
>>  free_entity:
>>  	media_entity_cleanup(&ov5645->sd.entity);
>>  free_ctrl:
> 

-- 
Best regards,
Todor Tomov
