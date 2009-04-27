Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4094 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZD0LL0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 07:11:26 -0400
Message-ID: <18729.62.70.2.252.1240830670.squirrel@webmail.xs4all.nl>
Date: Mon, 27 Apr 2009 13:11:10 +0200 (CEST)
Subject: Re: [REVIEW] v4l2 loopback
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Antonio Ospite" <ospite@studenti.unina.it>
Cc: "Vasily" <vasaka@gmail.com>, linux-media@vger.kernel.org,
	mchehab@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Vasily,
>
> Your patch seems to be reversed, not a big deal for review purposes, of
> course.
> I think you know that if you are working on a hg clone you can simply
> issue "hg diff" to get the right patch, or you could even use 'quilt' to
> ease your work.
>
> Just very few comments about syntax and style, since I am not a v4l
> dev :)
>
> On Mon, 27 Apr 2009 04:22:58 +0300
> Vasily <vasaka@gmail.com> wrote:
>
>> Hello Hans,
>>
>> Here is version with most issues fixed except usage of struct
>> v4l2_device
>> Can you please tell me more what should I use it for? I do not use any
>> subdevice feature. It does not remove usage of video_device struct
>> as I see from vivi driver it just used to be registered and unregistered
>> and for messages, may be I missed something?
>> So  can you tell please what I should use it for in loopback driver?
>> Just add it to v4l2_loopback_device structure and registe it?
>> ---
>> This patch introduces v4l2 loopback module
>>
>> From: Vasily Levin <vasaka@gmail.com>
>>
>> This is v4l2 loopback driver which can be used to make available any
>> userspace
>> video as v4l2 device. Initialy it was written to make videoeffects
>> available
>> to Skype, but in fact it have many more uses.
>>
>> Priority: normal
>>
>> Signed-off-by: Vasily Levin <vasaka@gmail.com>
>>
>> diff -uprN v4l-dvb.my.p/linux/drivers/media/video/Kconfig
>> v4l-dvb.orig/linux/drivers/media/video/Kconfig
>> --- v4l-dvb.my.p/linux/drivers/media/video/Kconfig	2009-04-26
>> 21:30:37.000000000 +0300
>> +++ v4l-dvb.orig/linux/drivers/media/video/Kconfig	2009-04-25
>> 04:41:20.000000000 +0300
>> @@ -479,13 +479,6 @@ config VIDEO_VIVI
>>  	  Say Y here if you want to test video apps or debug V4L devices.
>>  	  In doubt, say N.
>>
>> -config VIDEO_V4L2_LOOPBACK
>> -	tristate "v4l2 loopback driver"
>> -	depends on VIDEO_V4L2 && VIDEO_DEV
>> -	help
>> -	  Say Y if you want to use v4l2 loopback driver.
>> -	  This driver can be compiled as a module, called v4l2loopback.
>> -
>
> The description here could be improved, don't you think so?
>
>>  source "drivers/media/video/bt8xx/Kconfig"
>>
>>  config VIDEO_PMS
>> diff -uprN v4l-dvb.my.p/linux/drivers/media/video/Makefile
>> v4l-dvb.orig/linux/drivers/media/video/Makefile
>> --- v4l-dvb.my.p/linux/drivers/media/video/Makefile	2009-04-26
>> 21:30:37.000000000 +0300
>> +++ v4l-dvb.orig/linux/drivers/media/video/Makefile	2009-04-25
>> 04:41:20.000000000 +0300
>> @@ -132,7 +132,6 @@ obj-$(CONFIG_VIDEO_IVTV) += ivtv/
>>  obj-$(CONFIG_VIDEO_CX18) += cx18/
>>
>>  obj-$(CONFIG_VIDEO_VIVI) += vivi.o
>> -obj-$(CONFIG_VIDEO_V4L2_LOOPBACK) += v4l2loopback.o
>>  obj-$(CONFIG_VIDEO_CX23885) += cx23885/
>>
>>  obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
>> diff -uprN v4l-dvb.my.p/linux/drivers/media/video/v4l2loopback.c
>> v4l-dvb.orig/linux/drivers/media/video/v4l2loopback.c
>> --- v4l-dvb.my.p/linux/drivers/media/video/v4l2loopback.c	2009-04-27
>> 03:07:08.000000000 +0300
>> +++ v4l-dvb.orig/linux/drivers/media/video/v4l2loopback.c	1970-01-01
>> 03:00:00.000000000 +0300
>> @@ -1,732 +0,0 @@
>> -/*
>> - *      v4l2loopback.c  --  video 4 linux loopback driver
>> - *
>> - *      Copyright (C) 2005-2009
>> - *          Vasily Levin (vasaka@gmail.com)
>> - *
>> - *      This program is free software; you can redistribute it and/or
>> modify
>> - *      it under the terms of the GNU General Public License as
>> published by
>> - *      the Free Software Foundation; either version 2 of the License,
>> or
>> - *      (at your option) any later version.
>> - *
>> - */
>
> Nitpicking here: just one space before the text?
>
>> -#include <linux/version.h>
>> -#include <linux/vmalloc.h>
>> -#include <linux/mm.h>
>> -#include <linux/time.h>
>> -#include <linux/module.h>
>> -#include <media/v4l2-ioctl.h>
>> -#include "v4l2loopback.h"
>> -
>> -#define YAVLD_STREAMING
>> -
>> -MODULE_DESCRIPTION("V4L2 loopback video device");
>> -MODULE_VERSION("0.1.1");
>> -MODULE_AUTHOR("Vasily Levin");
>> -MODULE_LICENSE("GPL");
>> -
>
> "GPL v2"? I am not sure if this is of any importance.
>
>> -/* module parameters */
>> -static int debug = 0;
>> -module_param(debug, int, 0);
>> -MODULE_PARM_DESC(debug,"if debug output is enabled, values are 0, 1 or
>> 2");
>> -
>
> To do debug prints, these days, most kernel modules defines DEBUG at
> the top of the file (just when needed) and then use pr_debug() or better
> dev_dbg() into code.

Actually, I prefer a debug module parameter. That way you can enable
debugging without recompiling. Given the complexity of video drivers that
is often very desirable.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

