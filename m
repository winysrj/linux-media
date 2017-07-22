Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:52275 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750838AbdGVNlR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Jul 2017 09:41:17 -0400
Subject: Re: [PATCHv3 6/6] media: drop use of MEDIA_API_VERSION
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <20170722113057.45202-1-hverkuil@xs4all.nl>
 <20170722113057.45202-7-hverkuil@xs4all.nl>
 <20170722102446.3f45f569@vento.lan>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f201646f-ca12-036e-6009-773cd2d3451b@xs4all.nl>
Date: Sat, 22 Jul 2017 15:41:15 +0200
MIME-Version: 1.0
In-Reply-To: <20170722102446.3f45f569@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/07/17 15:24, Mauro Carvalho Chehab wrote:
> Em Sat, 22 Jul 2017 13:30:57 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Set media_version to LINUX_VERSION_CODE, just as we did for
>> driver_version.
>>
>> Nobody ever rememebers to update the version number, but
>> LINUX_VERSION_CODE will always be updated.
>>
>> Move the MEDIA_API_VERSION define to the ifndef __KERNEL__ section of the
>> media.h header. That way kernelspace can't accidentally start to use
>> it again.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/media-device.c | 3 +--
>>  include/uapi/linux/media.h   | 5 +++--
>>  2 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>> index 979e4307d248..3c99294e3ebf 100644
>> --- a/drivers/media/media-device.c
>> +++ b/drivers/media/media-device.c
>> @@ -69,9 +69,8 @@ static int media_device_get_info(struct media_device *dev,
>>  	strlcpy(info->serial, dev->serial, sizeof(info->serial));
>>  	strlcpy(info->bus_info, dev->bus_info, sizeof(info->bus_info));
>>  
>> -	info->media_version = MEDIA_API_VERSION;
>> +	info->media_version = info->driver_version = LINUX_VERSION_CODE;
>>  	info->hw_revision = dev->hw_revision;
>> -	info->driver_version = LINUX_VERSION_CODE;
>>  
>>  	return 0;
>>  }
>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>> index fac96c64fe51..4865f1e71339 100644
>> --- a/include/uapi/linux/media.h
>> +++ b/include/uapi/linux/media.h
>> @@ -30,8 +30,6 @@
>>  #include <linux/types.h>
>>  #include <linux/version.h>
>>  
>> -#define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 0)
>> -
>>  struct media_device_info {
>>  	char driver[16];
>>  	char model[32];
>> @@ -187,6 +185,9 @@ struct media_device_info {
>>  #define MEDIA_ENT_T_V4L2_SUBDEV_LENS	MEDIA_ENT_F_LENS
>>  #define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	MEDIA_ENT_F_ATV_DECODER
>>  #define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	MEDIA_ENT_F_TUNER
>> +
>> +/* Obsolete symbol for media_version, no longer used in the kernel */
>> +#define MEDIA_API_VERSION		KERNEL_VERSION(0, 1, 0)
> 
> IMHO, it should, instead be identical to LINUX_VERSION_CODE, as
> applications might be relying on it in order to check what
> media API version they receive from the MC queries.

That's useless. The only reason you want to use media_version in an application
is to check whether a feature is present provided you know for which kernel
version it appeared. So you will explicitly compare it against e.g. 4.x.0.
Never against LINUX_VERSION_CODE.

In fact, any application using this today will do something like:

media_version >= MEDIA_API_VERSION

and that should keep working in the future. Since any kernel release is >= 0.1.0
this will always work.

media_version >= LINUX_VERSION_CODE is dangerous since this define comes from
a userspace header (/usr/include/linux/version.h) which may be newer/older than the
actual running kernel. So the result of "media_version >= LINUX_VERSION_CODE" is
effectively undefined.

Regards,

	Hans

> 
> The problem is that this macro is defined only internally inside
> the Kernel tree.
> 
>>  #endif
>>  
>>  /* Entity flags */
> 
> 
> 
> Thanks,
> Mauro
> 
