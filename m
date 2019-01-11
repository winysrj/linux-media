Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B99FC43612
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 18:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 442DD21848
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 18:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387468AbfAKSXL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 13:23:11 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:38917 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729711AbfAKSXL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 13:23:11 -0500
Received: from svr-orw-mbx-02.mgc.mentorg.com ([147.34.90.202])
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1gi1SU-0004h5-2i from Steve_Longerbeam@mentor.com ; Fri, 11 Jan 2019 10:23:06 -0800
Received: from [172.30.90.140] (147.34.91.1) by svr-orw-mbx-02.mgc.mentorg.com
 (147.34.90.202) with Microsoft SMTP Server (TLS) id 15.0.1320.4; Fri, 11 Jan
 2019 10:23:03 -0800
Subject: Re: [PATCH 2/2] media: i2c: adv748x: Use devm to allocate the device
 struct
To:     <kieran.bingham+renesas@ideasonboard.com>,
        <linux-media@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>
References: <20190111154345.29145-2-kieran.bingham+renesas@ideasonboard.com>
 <52412a2d-bf8a-916f-96f9-8f4af93a18c7@ideasonboard.com>
From:   Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <66d56bb8-b85a-7447-2191-b9c1766a3f6a@mentor.com>
Date:   Fri, 11 Jan 2019 10:23:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <52412a2d-bf8a-916f-96f9-8f4af93a18c7@ideasonboard.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SVR-ORW-MBX-09.mgc.mentorg.com (147.34.90.209) To
 svr-orw-mbx-02.mgc.mentorg.com (147.34.90.202)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/11/19 8:08 AM, Kieran Bingham wrote:
> Hi Steve,
>
> On 11/01/2019 15:43, Kieran Bingham wrote:
>> From: Steve Longerbeam <steve_longerbeam@mentor.com>
> Thank you for the patch, (which was forwarded to me from the BSP team)
>
>> Switch to devm_kzalloc() when allocating the adv748x device struct.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   drivers/media/i2c/adv748x/adv748x-core.c | 6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
>> index 097e5c3a8e7e..4af2ae8fcc0a 100644
>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
>> @@ -774,7 +774,8 @@ static int adv748x_probe(struct i2c_client *client,
>>   	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
>>   		return -EIO;
>>   
>> -	state = kzalloc(sizeof(struct adv748x_state), GFP_KERNEL);
>> +	state = devm_kzalloc(&client->dev, sizeof(struct adv748x_state),
> I would instead use:
>
> 	state = devm_kzalloc(&client->dev, sizeof(*state));

Agreed!

>
> I will submit a v2 with this change made.

Thanks Kieran.

Steve

