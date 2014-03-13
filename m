Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46270 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbaCMPRz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 11:17:55 -0400
Message-ID: <5321CC1E.3080509@iki.fi>
Date: Thu, 13 Mar 2014 17:17:50 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [REVIEW PATCH 02/16] e4000: implement controls via v4l2 control
 framework
References: <1393461025-11857-1-git-send-email-crope@iki.fi> <1393461025-11857-3-git-send-email-crope@iki.fi> <20140313105727.43c3d689@samsung.com>
In-Reply-To: <20140313105727.43c3d689@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.03.2014 15:57, Mauro Carvalho Chehab wrote:
> Em Thu, 27 Feb 2014 02:30:11 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Implement gain and bandwidth controls using v4l2 control framework.
>> Pointer to control handler is provided by exported symbol.
>>
>> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/tuners/e4000.c      | 210 +++++++++++++++++++++++++++++++++++++-
>>   drivers/media/tuners/e4000.h      |  14 +++
>>   drivers/media/tuners/e4000_priv.h |  75 ++++++++++++++
>>   3 files changed, 298 insertions(+), 1 deletion(-)
>
> ...
>> diff --git a/drivers/media/tuners/e4000.h b/drivers/media/tuners/e4000.h
>> index e74b8b2..989f2ea 100644
>> --- a/drivers/media/tuners/e4000.h
>> +++ b/drivers/media/tuners/e4000.h
>> @@ -40,4 +40,18 @@ struct e4000_config {
>>   	u32 clock;
>>   };
>>
>> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_E4000)
>> +extern struct v4l2_ctrl_handler *e4000_get_ctrl_handler(
>> +		struct dvb_frontend *fe
>> +);
>> +#else
>> +static inline struct v4l2_ctrl_handler *e4000_get_ctrl_handler(
>> +		struct dvb_frontend *fe
>> +)
>> +{
>> +	pr_warn("%s: driver disabled by Kconfig\n", __func__);
>> +	return NULL;
>> +}
>> +#endif
>> +
>>   #endif
>
> There are two things to be noticed here:
>
> 1) Please don't add any EXPORT_SYMBOL() on a pure I2C module. You
> should, instead, use the subdev calls, in order to callback a
> function provided by the module;

That means, I have to implement it as a V4L subdev driver then...

Is there any problem to leave as it is? It just only provides control 
handler using that export. If you look those existing dvb frontend or 
tuner drivers there is many kind of resources exported just similarly 
(example DibCom PID filters, af9033 pid filters), so I cannot see why 
that should be different.

> 2) As you're now using request_module(), you don't need to use
> #if IS_ENABLED() anymore. It is up to the module to register
> itself as a V4L2 subdevice. The caller module should use the
> subdevice interface to run the callbacks.
>
> If you don't to that, you'll have several issues with the
> building system.

So basically you are saying I should implement that driver as a V4L 
subdev too?

regards
Antti

-- 
http://palosaari.fi/
