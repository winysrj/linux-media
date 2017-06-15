Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36503 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751902AbdFOMJ3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 08:09:29 -0400
Subject: Re: [PATCH 5/8] v4l2-flash: Flash ops aren't mandatory
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-6-git-send-email-sakari.ailus@linux.intel.com>
 <3e0a8823-a8b4-3f78-25e0-22d8cb8ad090@gmail.com>
 <20170614211939.GR12407@valkosipuli.retiisi.org.uk>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org, pavel@ucw.cz
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <5d6284a8-812b-fd4f-be52-1617e1bc9212@gmail.com>
Date: Thu, 15 Jun 2017 14:08:43 +0200
MIME-Version: 1.0
In-Reply-To: <20170614211939.GR12407@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 06/14/2017 11:19 PM, Sakari Ailus wrote:
> Hi Jacek,
> 
> On Wed, Jun 14, 2017 at 11:14:13PM +0200, Jacek Anaszewski wrote:
>> Hi Sakari,
>>
>> On 06/14/2017 11:47 AM, Sakari Ailus wrote:
>>> None of the flash operations are not mandatory and therefore there should
>>> be no need for the flash ops structure either. Accept NULL.
>>>
>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>> ---
>>>  drivers/media/v4l2-core/v4l2-flash-led-class.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
>>> index 6d69119..fdb79da 100644
>>> --- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
>>> +++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
>>> @@ -18,7 +18,7 @@
>>>  #include <media/v4l2-flash-led-class.h>
>>>  
>>>  #define has_flash_op(v4l2_flash, op)				\
>>> -	(v4l2_flash && v4l2_flash->ops->op)
>>> +	(v4l2_flash && v4l2_flash->ops && v4l2_flash->ops->op)
>>
>> This change doesn't seem to be related to the patch subject.
> 
> Yes, it is: if there's a chance that ops is NULL, then you have to test here
> you actually have the ops struct around. The test is no longer in
> v4l2_flash_init().

Indeed.

Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>

>>>  #define call_flash_op(v4l2_flash, op, arg)			\
>>>  		(has_flash_op(v4l2_flash, op) ?			\
>>> @@ -618,7 +618,7 @@ struct v4l2_flash *v4l2_flash_init(
>>>  	struct v4l2_subdev *sd;
>>>  	int ret;
>>>  
>>> -	if (!fled_cdev || !ops || !config)
>>> +	if (!fled_cdev || !config)
>>>  		return ERR_PTR(-EINVAL);
>>>  
>>>  	led_cdev = &fled_cdev->led_cdev;
>>>
> 

-- 
Best regards,
Jacek Anaszewski
