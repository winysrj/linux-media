Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49184 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148Ab3GRPw3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 11:52:29 -0400
Message-ID: <51E80F10.8030406@iki.fi>
Date: Thu, 18 Jul 2013 18:51:44 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: Alban Browaeys <alban.browaeys@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Alban Browaeys <prahal@yahoo.com>
Subject: Re: [PATCH 1/4] [media] em28xx: fix assignment of the eeprom data.
References: <1374015476-26197-1-git-send-email-prahal@yahoo.com> <51E80622.3020803@googlemail.com>
In-Reply-To: <51E80622.3020803@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/2013 06:13 PM, Frank Schäfer wrote:
> Am 17.07.2013 00:57, schrieb Alban Browaeys:
>> Set the config structure pointer to the eeprom data pointer (data,
>> here eedata dereferenced) not the pointer to the pointer to
>> the eeprom data (eedata itself).
>>
>> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
>> ---
>>   drivers/media/usb/em28xx/em28xx-i2c.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
>> index 4851cc2..c4ff973 100644
>> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
>> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
>> @@ -726,7 +726,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned bus,
>>
>>   	*eedata = data;
>>   	*eedata_len = len;
>> -	dev_config = (void *)eedata;
>> +	dev_config = (void *)*eedata;
>>
>>   	switch (le16_to_cpu(dev_config->chip_conf) >> 4 & 0x3) {
>>   	case 0:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Does that SOB mean you will pick that patch via you tree, or was it only 
a mistake?

I have thought few times what should I reply to patches which are for 
modules I am maintaining and I will pick up and pull-request via own 
tree. Usually I just reply "patch applied" but maybe Signed-off-by is 
used for same.

regards
Antti

-- 
http://palosaari.fi/
