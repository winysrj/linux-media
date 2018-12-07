Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1BF3C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EB842083D
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:47:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9EB842083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbeLGLra (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 06:47:30 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:56606 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbeLGLra (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 06:47:30 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id VEbMg6BPRgJOKVEbPgYd1K; Fri, 07 Dec 2018 12:47:27 +0100
Subject: Re: [RFC PATCH] media/Kconfig: always enable MEDIA_CONTROLLER and
 VIDEO_V4L2_SUBDEV_API
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
References: <89b0af6f-1371-50d9-5c19-fac7bb6562a3@xs4all.nl>
 <20181207092655.40e89b88@coco.lan>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0c25b853-048d-65c3-31fd-9adf9a4a9b9e@xs4all.nl>
Date:   Fri, 7 Dec 2018 12:47:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20181207092655.40e89b88@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfBkmSujOW97EMPdIL+Awklw9lW8+4hg+uNjzy5OOO+stush9+pmfqc1WZa+ic0oaaUNc7CY2EDuXuw17gns4/19plBhOhEuOcNAgKO+qE2wa0Z2khpMb
 EEbc/+L6fgsyQEy1uoBXIkzSd4FawzUI0+3W0hIsky7KARCPkrneWgkOIsrBqPyThGmyv0Yy8jVIH9e6ya9k/piSNln/aGl2xyDXxJBxHjfapsrfjIUTEHop
 6TQx7nP00lvGy5oI+64nIADueuPO8kvuvRMYeV7BP0GhicuCCYRj3xtMjCt0jURmnPD2OxcnEO9aXbvfRM3sOxHk/qKGRbXhbb++fzlEKIg=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/07/2018 12:26 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 7 Dec 2018 10:09:04 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> This patch selects MEDIA_CONTROLLER for all camera, analog TV and
>> digital TV drivers and selects VIDEO_V4L2_SUBDEV_API automatically.
>>
>> This will allow us to simplify drivers that currently have to add
>> #ifdef CONFIG_MEDIA_CONTROLLER or #ifdef VIDEO_V4L2_SUBDEV_API
>> to their code, since now this will always be available.
>>
>> The original intent of allowing these to be configured by the
>> user was (I think) to save a bit of memory. 
> 
> No. The original intent was/is to be sure that adding the media
> controller support won't be breaking existing working drivers.

That doesn't make sense. If enabling this option would break existing
drivers, then something is really wrong, isn't it?

> 
>> But as more and more
>> drivers have a media controller and all regular distros already
>> enable one or more of those drivers, the memory for the MC code is
>> there anyway.
>>
>> Complexity has always been the bane of media drivers, so reducing
>> complexity at the expense of a bit more memory (which is a rounding
>> error compared to the amount of video buffer memory needed) is IMHO
>> a good thing.
>>
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>> ---
>> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
>> index 8add62a18293..56eb01cc8bb4 100644
>> --- a/drivers/media/Kconfig
>> +++ b/drivers/media/Kconfig
>> @@ -31,6 +31,7 @@ comment "Multimedia core support"
>>  #
>>  config MEDIA_CAMERA_SUPPORT
>>  	bool "Cameras/video grabbers support"
>> +	select MEDIA_CONTROLLER
>>  	---help---
>>  	  Enable support for webcams and video grabbers.
>>
>> @@ -38,6 +39,7 @@ config MEDIA_CAMERA_SUPPORT
>>
>>  config MEDIA_ANALOG_TV_SUPPORT
>>  	bool "Analog TV support"
>> +	select MEDIA_CONTROLLER
>>  	---help---
>>  	  Enable analog TV support.
>>
>> @@ -50,6 +52,7 @@ config MEDIA_ANALOG_TV_SUPPORT
>>
>>  config MEDIA_DIGITAL_TV_SUPPORT
>>  	bool "Digital TV support"
>> +	select MEDIA_CONTROLLER
>>  	---help---
>>  	  Enable digital TV support.
> 
> See my comments below.
> 
>>
>> @@ -95,7 +98,6 @@ source "drivers/media/cec/Kconfig"
>>
>>  config MEDIA_CONTROLLER
>>  	bool "Media Controller API"
>> -	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT
>>  	---help---
>>  	  Enable the media controller API used to query media devices internal
>>  	  topology and configure it dynamically.
> 
> I have split comments with regards to it. Yeah, nowadays media controller
> has becoming more important. Still, a lot of media drivers work fine
> without them.
> 
> Anyway, if we're willing to make it mandatory, better to just remove the
> entire config option or to make it a silent one. 

Well, that assumes that the media controller will only be used by media
drivers, and not alsa or anyone else who wants to experiment with the MC.

I won't object to making it silent (since it does reflect the current
situation), but since this functionality is not actually specific to media
drivers I think that is a good case to be made to allow it to be selected
manually.

> 
>> @@ -119,16 +121,11 @@ config VIDEO_DEV
>>  	tristate
>>  	depends on MEDIA_SUPPORT
>>  	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
>> +	select VIDEO_V4L2_SUBDEV_API if MEDIA_CONTROLLER
>>  	default y
>>
>>  config VIDEO_V4L2_SUBDEV_API
>> -	bool "V4L2 sub-device userspace API"
>> -	depends on VIDEO_DEV && MEDIA_CONTROLLER
>> -	---help---
>> -	  Enables the V4L2 sub-device pad-level userspace API used to configure
>> -	  video format, size and frame rate between hardware blocks.
>> -
>> -	  This API is mostly used by camera interfaces in embedded platforms.
>> +	bool
> 
> NACK. 
> 
> There is a very good reason why the subdev API is optional: there
> are drivers that use camera sensors but are not MC-centric. On those,
> the USB bridge driver is responsible to setup the subdevice. 
> 
> This options helps to ensure that camera sensors used by such drivers
> won't stop working because of the lack of the subdev-API.

But they won't stop working if this is enabled. This option is used as
a dependency by drivers that require this functionality, but enabling
it will never break other drivers that don't need this. Those drivers
simply won't use it.

Also note that it is the bridge driver that controls whether or not
the v4l-subdevX devices are created. If the bridge driver doesn't
explicitly enable it AND the subdev driver explicitly supports it,
those devices will not be created.

Regards,

	Hans

> 
>>
>>  source "drivers/media/v4l2-core/Kconfig"
>>
> 
> 
> 
> Thanks,
> Mauro
> 

