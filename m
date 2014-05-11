Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:58755 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392AbaEKUZg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 16:25:36 -0400
Received: by mail-ee0-f44.google.com with SMTP id c41so4036441eek.17
        for <linux-media@vger.kernel.org>; Sun, 11 May 2014 13:25:34 -0700 (PDT)
Message-ID: <536FDCD3.5030301@googlemail.com>
Date: Sun, 11 May 2014 22:25:55 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, m.chehab@samsung.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/5] em28xx: fix i2c_set_adapdata() call in em28xx_i2c_register()
References: <1395493263-2158-1-git-send-email-fschaefer.oss@googlemail.com> <1395493263-2158-2-git-send-email-fschaefer.oss@googlemail.com> <536C948B.8080106@xs4all.nl>
In-Reply-To: <536C948B.8080106@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Hans,

Am 09.05.2014 10:40, schrieb Hans Verkuil:
> Hi Frank,
>
> I've got a comment about this patch:
>
> On 03/22/2014 02:01 PM, Frank Schäfer wrote:
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>  drivers/media/usb/em28xx/em28xx-i2c.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
>> index ba6433c..04e8577 100644
>> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
>> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
>> @@ -939,7 +939,7 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned bus,
>>  	dev->i2c_bus[bus].algo_type = algo_type;
>>  	dev->i2c_bus[bus].dev = dev;
>>  	dev->i2c_adap[bus].algo_data = &dev->i2c_bus[bus];
>> -	i2c_set_adapdata(&dev->i2c_adap[bus], &dev->v4l2_dev);
>> +	i2c_set_adapdata(&dev->i2c_adap[bus], dev);
> As far as I can see nobody is calling i2c_get_adapdata. Should this line be removed
> altogether?
>
> If it is used somewhere, can you point me that?
Good catch.
Indeed, nobody is using it anymore so it can removed instead.
Drop this patch, I will send a new one in a minute.

> I'm taking the other patches from this series (using the v2 version of patch 4/5) since
> those look fine.
Thanks !

Regards,
Frank


>
> Regards,
>
> 	Hans
>
>>  
>>  	retval = i2c_add_adapter(&dev->i2c_adap[bus]);
>>  	if (retval < 0) {
>>

