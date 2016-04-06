Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60945 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbcDFWQ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2016 18:16:57 -0400
From: Helen Koike <helen.koike@collabora.co.uk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: Re: [PATCH v2] [media] tpg: Export the tpg code from vivid as a
 module
References: <1459531093-7071-1-git-send-email-helen.koike@collabora.co.uk>
 <20160401152234.4803ad11@recife.lan>
Message-ID: <57058ACC.3000801@collabora.co.uk>
Date: Wed, 6 Apr 2016 19:16:44 -0300
MIME-Version: 1.0
In-Reply-To: <20160401152234.4803ad11@recife.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On 01/04/2016 15:22, Mauro Carvalho Chehab wrote:
> Hi Helen,
>
> This is just a quick look on it. See below.
>
> Em Fri, 1 Apr 2016 14:18:13 -0300
> Helen Mae Koike Fornazier <helen.koike@collabora.co.uk> escreveu:
>
>> The test pattern generator will be used by other drivers as the virtual
>> media controller (vimc)
>>
>> Signed-off-by: Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>
>> ---
>>
>> The patch is based on 'media/master' branch and available at
>>          https://github.com/helen-fornazier/opw-staging tpg/review/vivid
>>
>> Changes since last version:
>> 	* module name: tpg -> video-tpg
>> 	* header ifdef/define:
>> 		_TPG_H_ -> _MEDIA_TPG_H_
>> 		_TPG_COLORS_H_ -> _MEDIA_TPG_COLORS_H_
>>
>>   drivers/media/platform/Kconfig                  |    2 +
>>   drivers/media/platform/Makefile                 |    2 +
>>   drivers/media/platform/tpg/Kconfig              |    5 +
>>   drivers/media/platform/tpg/Makefile             |    3 +
>>   drivers/media/platform/tpg/tpg-colors.c         | 1415 ++++++++++++++
>>   drivers/media/platform/tpg/tpg-core.c           | 2334 +++++++++++++++++++++++
>>   drivers/media/platform/vivid/Kconfig            |    1 +
>>   drivers/media/platform/vivid/Makefile           |    2 +-
>>   drivers/media/platform/vivid/vivid-core.h       |    2 +-
>>   drivers/media/platform/vivid/vivid-tpg-colors.c | 1416 --------------
>>   drivers/media/platform/vivid/vivid-tpg-colors.h |   68 -
>>   drivers/media/platform/vivid/vivid-tpg.c        | 2314 ----------------------
>>   drivers/media/platform/vivid/vivid-tpg.h        |  598 ------
>>   include/media/tpg-colors.h                      |   68 +
>>   include/media/tpg.h                             |  597 ++++++
>>   15 files changed, 4429 insertions(+), 4398 deletions(-)
>>   create mode 100644 drivers/media/platform/tpg/Kconfig
>>   create mode 100644 drivers/media/platform/tpg/Makefile
>>   create mode 100644 drivers/media/platform/tpg/tpg-colors.c
>>   create mode 100644 drivers/media/platform/tpg/tpg-core.c
>>   delete mode 100644 drivers/media/platform/vivid/vivid-tpg-colors.c
>>   delete mode 100644 drivers/media/platform/vivid/vivid-tpg-colors.h
>>   delete mode 100644 drivers/media/platform/vivid/vivid-tpg.c
>>   delete mode 100644 drivers/media/platform/vivid/vivid-tpg.h
>>   create mode 100644 include/media/tpg-colors.h
>>   create mode 100644 include/media/tpg.h
>
> Please, generate the patch with -M, for us to see what was changed,
> instead of seeing a big diff where (I suspect that) 99% of the code
> didn't change.
>
> That helps a lot for us to know what actually changed, without needing
> to compare everything line per line.
>
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index 201f5c2..8f7cf86 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -284,6 +284,8 @@ menuconfig V4L_TEST_DRIVERS
>>   
>>   if V4L_TEST_DRIVERS
>>   
>> +source "drivers/media/platform/tpg/Kconfig"
>> +
>>   source "drivers/media/platform/vivid/Kconfig"
>>   
>>   config VIDEO_VIM2M
>> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
>> index bbb7bd1..569dd1a 100644
>> --- a/drivers/media/platform/Makefile
>> +++ b/drivers/media/platform/Makefile
>> @@ -12,6 +12,8 @@ obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
>>   
>>   obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
>>   
>> +obj-$(CONFIG_VIDEO_TPG)			+= tpg/
>> +obj-$(CONFIG_VIDEO_VIMC)		+= vimc/
>>   obj-$(CONFIG_VIDEO_VIVID)		+= vivid/
>>   obj-$(CONFIG_VIDEO_VIM2M)		+= vim2m.o
>>   
>> diff --git a/drivers/media/platform/tpg/Kconfig b/drivers/media/platform/tpg/Kconfig
>> new file mode 100644
>> index 0000000..1b6b19c0
>> --- /dev/null
>> +++ b/drivers/media/platform/tpg/Kconfig
>> @@ -0,0 +1,5 @@
>> +config VIDEO_TPG
>> +	tristate "Test Pattern Generator (TPG)"
>> +	default n
>> +	---help---
>> +	  Export functions to generate image patterns used in vivid and vimc drivers
>
> No need to have a menu for this. The best would be to do define it as:
>
> config VIDEO_TPG
> 	tristate
> 	depends on VIDEO_VIVID || VIDEO_VIMC
>
> This way, it will be automatically selected if the driver(s) that
> needs it is selected, without forcing the user to manually guess the
> reverse dependency. It also makes life easier for distros that have
> VIDEO_VIVID already enabled.
>
> Regards,
> Mauro
Conceptually, the tpg doesn't depends on vivid or vimc, it is a separate 
modules that export symbols conveniently used by Vivid, any other 
modules could use the tpg if they want to. Shouldn't we just let the 
"select VIDEO_V4L2_TPG" in the vivid's Kconfig? The tpg would be 
selected automatically.

Regards,
Helen



