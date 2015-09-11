Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32676 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbbIKJhb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 05:37:31 -0400
Subject: Re: [PATCH 08/18] [media] s5c73m3: Export OF module alias information
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
References: <1440054451-1223-1-git-send-email-javier@osg.samsung.com>
 <1440054451-1223-9-git-send-email-javier@osg.samsung.com>
 <55F22C24.1070407@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <55F2A0D3.5080903@samsung.com>
Date: Fri, 11 Sep 2015 11:37:23 +0200
MIME-version: 1.0
In-reply-to: <55F22C24.1070407@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2015 03:19 AM, Javier Martinez Canillas wrote:
> Hello,
>
> On 08/20/2015 09:07 AM, Javier Martinez Canillas wrote:
>> The SPI core always reports the MODALIAS uevent as "spi:<modalias>"
>> regardless of the mechanism that was used to register the device
>> (i.e: OF or board code) and the table that is used later to match
>> the driver with the device (i.e: SPI id table or OF match table).
>>
>> So drivers needs to export the SPI id table and this be built into
>> the module or udev won't have the necessary information to autoload
>> the needed driver module when the device is added.
>>
>> But this means that OF-only drivers needs to have both OF and SPI id
>> tables that have to be kept in sync and also the dev node compatible
>> manufacturer prefix is stripped when reporting the MODALIAS. Which can
>> lead to issues if two vendors use the same SPI device name for example.
>>
>> To avoid the above, the SPI core behavior may be changed in the future
>> to not require an SPI device table for OF-only drivers and report the
>> OF module alias. So, it's better to also export the OF table even when
>> is unused now to prevent breaking module loading when the core changes.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> ---
>>
>>  drivers/media/i2c/s5c73m3/s5c73m3-spi.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
>> index fa4a5ebda6b2..9983635ec253 100644
>> --- a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
>> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
>> @@ -31,6 +31,7 @@ static const struct of_device_id s5c73m3_spi_ids[] = {
>>  	{ .compatible = "samsung,s5c73m3" },
>>  	{ }
>>  };
>> +MODULE_DEVICE_TABLE(of, s5c73m3_spi_ids;);
>>  
>>  enum spi_direction {
>>  	SPI_DIR_RX,
>>
> Any comments about this patch?
>
> Best regards,
Ups, forgot about it.

Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>

Regards
Andrzej

