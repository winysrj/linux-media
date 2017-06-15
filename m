Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:65177 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbdFOHV2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 03:21:28 -0400
Subject: Re: [RFC 2/2] [media] bcm2835-unicam: Driver for CCP2/CSI2 camera
 interface
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
 <e268d99095dea34a049d9cacf9c18e855050abe1.1497452006.git.dave.stevenson@raspberrypi.org>
 <ec774750-d6a9-d8b7-9b38-0fd97fe7678d@xs4all.nl>
From: Stefan Wahren <stefan.wahren@i2se.com>
Message-ID: <9565e24b-6f5e-f90b-6a5c-23f1df7bd4e8@i2se.com>
Date: Thu, 15 Jun 2017 09:20:59 +0200
MIME-Version: 1.0
In-Reply-To: <ec774750-d6a9-d8b7-9b38-0fd97fe7678d@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: de-DE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 15.06.2017 um 09:12 schrieb Hans Verkuil:
> Hi Dave,
>
> Here is a quick review of this driver. Once a v2 is posted I'll do a
> more thorough
> check.
>
> On 06/14/2017 05:15 PM, Dave Stevenson wrote:
>> Add driver for the Unicam camera receiver block on
>> BCM283x processors.
>>
>> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
>> ---
>>   drivers/media/platform/Kconfig                   |    1 +
>>   drivers/media/platform/Makefile                  |    2 +
>>   drivers/media/platform/bcm2835/Kconfig           |   14 +
>>   drivers/media/platform/bcm2835/Makefile          |    3 +
>>   drivers/media/platform/bcm2835/bcm2835-unicam.c  | 2100
>> ++++++++++++++++++++++
>>   drivers/media/platform/bcm2835/vc4-regs-unicam.h |  257 +++
>>   6 files changed, 2377 insertions(+)
>>   create mode 100644 drivers/media/platform/bcm2835/Kconfig
>>   create mode 100644 drivers/media/platform/bcm2835/Makefile
>>   create mode 100644 drivers/media/platform/bcm2835/bcm2835-unicam.c
>>   create mode 100644 drivers/media/platform/bcm2835/vc4-regs-unicam.h
>>
>> diff --git a/drivers/media/platform/Kconfig
>> b/drivers/media/platform/Kconfig
>> index 8da521a..1111aa9 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -135,6 +135,7 @@ source "drivers/media/platform/am437x/Kconfig"
>>   source "drivers/media/platform/xilinx/Kconfig"
>>   source "drivers/media/platform/rcar-vin/Kconfig"
>>   source "drivers/media/platform/atmel/Kconfig"
>> +source "drivers/media/platform/bcm2835/Kconfig"
>>     config VIDEO_TI_CAL
>>       tristate "TI CAL (Camera Adaptation Layer) driver"
>> diff --git a/drivers/media/platform/Makefile
>> b/drivers/media/platform/Makefile
>> index 6bbdf94..9c5e412 100644
>> --- a/drivers/media/platform/Makefile
>> +++ b/drivers/media/platform/Makefile
>> @@ -81,3 +81,5 @@ obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)    += mtk-vcodec/
>>   obj-$(CONFIG_VIDEO_MEDIATEK_MDP)    += mtk-mdp/
>>     obj-$(CONFIG_VIDEO_MEDIATEK_JPEG)    += mtk-jpeg/
>> +
>> +obj-y                    += bcm2835/
>> diff --git a/drivers/media/platform/bcm2835/Kconfig
>> b/drivers/media/platform/bcm2835/Kconfig
>> new file mode 100644
>> index 0000000..9f9be9e
>> --- /dev/null
>> +++ b/drivers/media/platform/bcm2835/Kconfig
>> @@ -0,0 +1,14 @@
>> +# Broadcom VideoCore4 V4L2 camera support
>> +
>> +config VIDEO_BCM2835_UNICAM
>> +    tristate "Broadcom BCM2835 Unicam video capture driver"
>> +    depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>> +    depends on ARCH_BCM2708 || ARCH_BCM2709 || ARCH_BCM2835 ||
>> COMPILE_TEST
>

ARCH_BCM2708 and ARCH_BCM2709 isn't available upstream and should be
dropped.
