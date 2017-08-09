Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:38843 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdHII1n (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 04:27:43 -0400
MIME-Version: 1.0
In-Reply-To: <20170809074844.3elw7posdcohjaiy@valkosipuli.retiisi.org.uk>
References: <20170725153735.239734-1-arnd@arndb.de> <20170809074844.3elw7posdcohjaiy@valkosipuli.retiisi.org.uk>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 9 Aug 2017 10:27:41 +0200
Message-ID: <CAK8P3a0QQeBZObjaX7E6pUzbzBTRHuaPny7fupGZu0m5ArMSvQ@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: add KConfig dependencies
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 9, 2017 at 9:48 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Arnd,
>
> Thanks for the patch.
>
> On Tue, Jul 25, 2017 at 05:36:45PM +0200, Arnd Bergmann wrote:
>> @@ -618,8 +618,9 @@ config VIDEO_OV6650
>>
>>  config VIDEO_OV5670
>>       tristate "OmniVision OV5670 sensor support"
>> -     depends on I2C && VIDEO_V4L2
>> +     depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>>       depends on MEDIA_CAMERA_SUPPORT
>> +     depends on MEDIA_CONTROLLER
>>       select V4L2_FWNODE
>>       ---help---
>>         This is a Video4Linux2 sensor-level driver for the OmniVision
>
> Applied, with dropping explicit MEDIA_CONTROLLER. VIDEO_V4L2_SUBDEV_API
> already depends on MEDIA_CONTROLLER.

makes sense, thanks!

       Arnd
