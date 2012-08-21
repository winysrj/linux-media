Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752Ab2HULBF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 07:01:05 -0400
Message-ID: <50336A6D.8030106@redhat.com>
Date: Tue, 21 Aug 2012 08:01:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/6] [media] Cleanup media Kconfig files
References: <1345486935-18002-1-git-send-email-mchehab@redhat.com> <1345486935-18002-5-git-send-email-mchehab@redhat.com> <CAK9yfHzbL0QKoEx9YWdRSczN3jPCzUzpDnoOXN7tFmogL0HpLg@mail.gmail.com>
In-Reply-To: <CAK9yfHzbL0QKoEx9YWdRSczN3jPCzUzpDnoOXN7tFmogL0HpLg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-08-2012 00:41, Sachin Kamat escreveu:
> Hi Mauro,
> 
> On 20 August 2012 23:52, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>> - get rid of ridden V4L2_COMMON symbol
>>
>>   This symbol is not needed anymore; it can be folded with V4L2
>>   one, simplifying the Kconfig a little bit;
>>
>> - Comment why some Kconfig items are needed;
>>
>> - Remove if test for MEDIA_CAMERA_SUPPORT, replacing it by
>>   depends on.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>  drivers/media/Kconfig            |  5 -----
>>  drivers/media/i2c/Kconfig        |  2 +-
>>  drivers/media/platform/Kconfig   |  6 ++----
>>  drivers/media/v4l2-core/Kconfig  | 27 ++++++++++++++++-----------
>>  drivers/media/v4l2-core/Makefile |  2 +-
>>  5 files changed, 20 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
>> index d5b4e72..9c3698a 100644
>> --- a/drivers/media/Kconfig
>> +++ b/drivers/media/Kconfig
>> @@ -99,11 +99,6 @@ config VIDEO_DEV
>>         depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT
>>         default y
>>
>> -config VIDEO_V4L2_COMMON
>> -       tristate
>> -       depends on (I2C || I2C=n) && VIDEO_DEV
>> -       default (I2C || I2C=n) && VIDEO_DEV
>> -
>>  config VIDEO_V4L2_SUBDEV_API
>>         bool "V4L2 sub-device userspace API (EXPERIMENTAL)"
>>         depends on VIDEO_DEV && MEDIA_CONTROLLER && EXPERIMENTAL
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index 7fe4acf..ad2c9de 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -322,7 +322,7 @@ comment "MPEG video encoders"
>>
>>  config VIDEO_CX2341X
>>         tristate "Conexant CX2341x MPEG encoders"
>> -       depends on VIDEO_V4L2 && VIDEO_V4L2_COMMON
>> +       depends on VIDEO_V4L2 && VIDEO_V4L2
> 
> VIDEO_V4L2 is duplicated.

Indeed. That's the problem with scripted patches ;)

Well, the original statement there sucks, as, before this patch,
VIDEO_V4L2_COMMON was a requirement for VIDEO_V4L2.

I suspect that there are lots of duplicated dependencies like
the above all over the Kconfigs.

For example, I suspect it is possible to get merge both VIDEO_DEV
and VIDEO_V4L2, but cleaning those Kconfig symbols will
require some time and patience.

Regards,
Mauro
