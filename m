Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-229.synserver.de ([212.40.185.229]:1146 "EHLO
	smtp-out-188.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753788AbbKLKka (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 05:40:30 -0500
Message-ID: <5644682B.1000303@metafoo.de>
Date: Thu, 12 Nov 2015 11:21:31 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
CC: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	magnus.damm@gmail.com, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] media: adv7180: increase delay after reset to 5ms
References: <1447162740-28096-1-git-send-email-ulrich.hecht+renesas@gmail.com> <1743324.8Mae4aQqGO@avalon>
In-Reply-To: <1743324.8Mae4aQqGO@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2015 12:10 AM, Laurent Pinchart wrote:
> Hi Ulrich,
> 
> (CC'ing Lars-Peter Clausen)
> 
> Thank you for the patch.
> 
> On Tuesday 10 November 2015 14:39:00 Ulrich Hecht wrote:
>> Initialization of the ADV7180 chip fails on the Renesas R8A7790-based
>> Lager board about 50% of the time.  This patch resolves the issue by
>> increasing the minimum delay after reset from 2 ms to 5 ms, following the
>> recommendation in the ADV7180 datasheet:
>>
>> "Executing a software reset takes approximately 2 ms. However, it is
>> recommended to wait 5 ms before any further I2C writes are performed."
>>
>> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Lars, would you like to take this in your tree with other Analog Devices 
> patches, or should I take it ?

I don't have a tree, usually Hans applies the patches directly.

Patch looks good, thanks.

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> 
>> ---
>>  drivers/media/i2c/adv7180.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
>> index f82c8aa..3c3c4bf 100644
>> --- a/drivers/media/i2c/adv7180.c
>> +++ b/drivers/media/i2c/adv7180.c
>> @@ -1112,7 +1112,7 @@ static int init_device(struct adv7180_state *state)
>>  	mutex_lock(&state->mutex);
>>
>>  	adv7180_write(state, ADV7180_REG_PWR_MAN, ADV7180_PWR_MAN_RES);
>> -	usleep_range(2000, 10000);
>> +	usleep_range(5000, 10000);
>>
>>  	ret = state->chip_info->init(state);
>>  	if (ret)
> 

