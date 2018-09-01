Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55939 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbeIAQtq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Sep 2018 12:49:46 -0400
Received: by mail-wm0-f65.google.com with SMTP id f21-v6so7482254wmc.5
        for <linux-media@vger.kernel.org>; Sat, 01 Sep 2018 05:37:50 -0700 (PDT)
Subject: Re: [PATCH] media: ov2680: register the v4l2 subdev async at the end
 of probe
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        linux-media@vger.kernel.org
References: <20180831151906.9315-1-javierm@redhat.com>
 <20180901114629.rupnr7xaeyxjqfdk@valkosipuli.retiisi.org.uk>
From: Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <0e0e3893-98b4-28f0-8088-91b19c806129@redhat.com>
Date: Sat, 1 Sep 2018 14:37:44 +0200
MIME-Version: 1.0
In-Reply-To: <20180901114629.rupnr7xaeyxjqfdk@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the feedback.

On 09/01/2018 01:46 PM, Sakari Ailus wrote:
> Hi Javier,
> 
> On Fri, Aug 31, 2018 at 05:19:06PM +0200, Javier Martinez Canillas wrote:
>> The driver registers the subdev async in the middle of the probe function
>> but this has to be done at the very end of the probe function to prevent
>> registering a device whose probe function could fail (i.e: the clock and
>> regulators enable can fail, the I2C transfers could return errors, etc).
>>
>> It could also lead to a media device driver that is waiting to bound the
>> v4l2 subdevice to incorrectly expose its media device to userspace, since
>> the subdev is registered but later its media entity is cleaned up on error.
>>
>> Fixes: 3ee47cad3e69 ("media: ov2680: Add Omnivision OV2680 sensor driver")
>> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
>>
>> ---
>>
>>  drivers/media/i2c/ov2680.c | 9 ++++-----
>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
>> index f753a1c333ef..2ef920a17278 100644
>> --- a/drivers/media/i2c/ov2680.c
>> +++ b/drivers/media/i2c/ov2680.c
>> @@ -983,10 +983,6 @@ static int ov2680_v4l2_init(struct ov2680_dev *sensor)
>>  
>>  	sensor->sd.ctrl_handler = hdl;
>>  
>> -	ret = v4l2_async_register_subdev(&sensor->sd);
>> -	if (ret < 0)
>> -		goto cleanup_entity;
>> -
>>  	return 0;
>>  
>>  cleanup_entity:
>> @@ -1096,6 +1092,10 @@ static int ov2680_probe(struct i2c_client *client)
>>  	if (ret < 0)
>>  		goto error_cleanup;
> 
> How about instead moving ov2680_check_id() call earlier in probe()? That
> would seem to be a better fix: the driver should check the device is around
> before registering anything.
>

Yes, that would work too. We can't move it too early though since it has to
be after the DT was parsed, the regulator, clocks and gpio looked up, etc.

But moving ov2680_check_id() before ov2680_v4l2_init() would work indeed,
in that case ov2680_v4l2_init() should be renamed to ov2680_v4l2_register()
I think to make it clear that the function not only does initialization but
also register the v4l2 subdevice.

I'll post a v2 doing what you suggest.

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
