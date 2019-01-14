Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA2EC43612
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1DD420659
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="bXVSTOg7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfANNPQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:15:16 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:47456 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfANNPQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 08:15:16 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id B116C530;
        Mon, 14 Jan 2019 14:15:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547471713;
        bh=pgi9ij8xnZCwMfvIFh6rTKOnKGqUAXc+PevDbWNqQ+I=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=bXVSTOg74PcuKt6QDgjrVoGMJzVN0J4+F2bL9YmVw99aot0yVXKdUEpYtbrBj5He0
         X/u/hCfenlTNshcoEKHmoF7JkyCOxua33pSDs9psD+pFG68+qCkz0wJBdkrLLg7NaV
         Sp+a6x57ir3jcTdtqKXqopdIZ7DEffViq9cmNZiY=
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH v2] media: i2c: adv748x: Use devm to allocate the device
 struct
To:     =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <20190111161703.7972-1-kieran.bingham+renesas@ideasonboard.com>
 <20190114130622.GE30160@bigcity.dyn.berto.se>
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Organization: Ideas on Board
Message-ID: <061caa6f-6a8f-8f1c-fe19-c9b778fcabb1@ideasonboard.com>
Date:   Mon, 14 Jan 2019 13:15:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190114130622.GE30160@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

On 14/01/2019 13:06, Niklas Söderlund wrote:
> Hi Kieran,
> 
> Thanks for your work.
> 
> On 2019-01-11 16:17:03 +0000, Kieran Bingham wrote:
>> From: Steve Longerbeam <steve_longerbeam@mentor.com>
>>
>> Switch to devm_kzalloc() when allocating the adv748x device struct.
>>
>> The sizeof() is updated to determine the correct allocation size from
>> the dereferenced pointer type rather than hardcoding the struct type.
> 
> I would put this under a changes since v1 section and not for inclusion 
> on the commit message upstream. Apart from that

I considered that, but this is an actual change as well as the
s/kzalloc/devm_kzalloc/ on top of the existing code - so I felt it was
worthy of keeping in the changelog.

(The original code uses sizeof(struct...) instead of sizeof(*s))

> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Thanks

Kieran


> 
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> [Kieran: Change sizeof() to dereference the pointer type]
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>  drivers/media/i2c/adv748x/adv748x-core.c | 5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
>> index 060d0c5b4989..1e5c7bbcf6b2 100644
>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
>> @@ -674,7 +674,7 @@ static int adv748x_probe(struct i2c_client *client,
>>  	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
>>  		return -EIO;
>>  
>> -	state = kzalloc(sizeof(struct adv748x_state), GFP_KERNEL);
>> +	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
>>  	if (!state)
>>  		return -ENOMEM;
>>  
>> @@ -772,7 +772,6 @@ static int adv748x_probe(struct i2c_client *client,
>>  	adv748x_dt_cleanup(state);
>>  err_free_mutex:
>>  	mutex_destroy(&state->mutex);
>> -	kfree(state);
>>  
>>  	return ret;
>>  }
>> @@ -791,8 +790,6 @@ static int adv748x_remove(struct i2c_client *client)
>>  	adv748x_dt_cleanup(state);
>>  	mutex_destroy(&state->mutex);
>>  
>> -	kfree(state);
>> -
>>  	return 0;
>>  }
>>  
>> -- 
>> 2.17.1
>>
> 

