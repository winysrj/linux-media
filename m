Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:62509 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab1EVMgr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2011 08:36:47 -0400
Message-ID: <4DD90415.8000908@maxwell.research.nokia.com>
Date: Sun, 22 May 2011 15:39:49 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	nkanchev@mm-sol.com, g.liakhovetski@gmx.de, hverkuil@xs4all.nl,
	dacohen@gmail.com, riverful@gmail.com, andrew.b.adams@gmail.com,
	shpark7@stanford.edu
Subject: Re: [PATCH 3/3] adp1653: Add driver for LED flash controller
References: <4DD4F3CA.3040300@maxwell.research.nokia.com> <1305801686-32360-3-git-send-email-sakari.ailus@maxwell.research.nokia.com> <4DD7A8BC.4020207@gmail.com>
In-Reply-To: <4DD7A8BC.4020207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro Carvalho Chehab wrote:
> Em 19-05-2011 07:41, Sakari Ailus escreveu:
>> This patch adds the driver for the adp1653 LED flash controller. This
>> controller supports a high power led in flash and torch modes and an
>> indicator light, sometimes also called privacy light.
>>
>> The adp1653 is used on the Nokia N900.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
>> Signed-off-by: Tuukka Toivonen <tuukkat76@gmail.com>
>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Signed-off-by: David Cohen <dacohen@gmail.com>
>> ---
>>  drivers/media/video/Kconfig   |    7 +
>>  drivers/media/video/Makefile  |    2 +
>>  drivers/media/video/adp1653.c |  481 +++++++++++++++++++++++++++++++++++++++++
>>  include/media/adp1653.h       |  126 +++++++++++
>>  4 files changed, 616 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/media/video/adp1653.c
>>  create mode 100644 include/media/adp1653.h
>>
>> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>> index 00f51dd..c004dbb 100644
>> --- a/drivers/media/video/Kconfig
>> +++ b/drivers/media/video/Kconfig
>> @@ -344,6 +344,13 @@ config VIDEO_TCM825X
>>  	  This is a driver for the Toshiba TCM825x VGA camera sensor.
>>  	  It is used for example in Nokia N800.
>>  
>> +config VIDEO_ADP1653
>> +	tristate "ADP1653 flash support"
>> +	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
>> +	---help---
>> +	  This is a driver for the ADP1653 flash controller. It is used for
>> +	  example in Nokia N900.
>> +
>>  config VIDEO_SAA7110
>>  	tristate "Philips SAA7110 video decoder"
>>  	depends on VIDEO_V4L2 && I2C
> 
> The patches look sane. I have just one comment: Please, create a separate
> section for the LED controls. OK, some patches already messed the Kconfig stuff
> by mixing sensors together with video decoders, but let's not make the things
> worse.

Hi Mauro,

Thanks for the comment! I'll fix this in the Kconfig for the next patchset.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
