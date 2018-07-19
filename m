Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:43186 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727975AbeGSI0x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 04:26:53 -0400
Subject: Re: [PATCH] ARM: shmobile: defconfig: Remove SOC_CAMERA
To: Simon Horman <horms@verge.net.au>, Jacopo Mondi <jacopo@jmondi.org>
Cc: magnus.damm@gmail.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <1531920672-31153-1-git-send-email-jacopo@jmondi.org>
 <20180719074405.znqjtno2l2a6exti@verge.net.au>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <54e7045b-c3b2-b625-22ab-3677d69ed93d@xs4all.nl>
Date: Thu, 19 Jul 2018 09:44:57 +0200
MIME-Version: 1.0
In-Reply-To: <20180719074405.znqjtno2l2a6exti@verge.net.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/19/2018 09:44 AM, Simon Horman wrote:
> On Wed, Jul 18, 2018 at 03:31:12PM +0200, Jacopo Mondi wrote:
>> As the soc_camera framework is going to be deprecated soon, remove the
>> associated configuration options from shmobile defconfig.
>>
>> Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
>> ---
>> Hi Simon,
>>    I expect Hans to collect this patch as he did for SH defconfig ones.
>> Please let us know if that's not ok with you.
> 
> I'd slightly prefer if shmobile_defconfig changes went through me.
> My motivation is to reduce the chances of merge conflicts.

Feel free to take it!

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
>>
>> Thanks
>>    j
>> ---
>>
>>  arch/arm/configs/shmobile_defconfig | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/arch/arm/configs/shmobile_defconfig b/arch/arm/configs/shmobile_defconfig
>> index b49887e..239f2c7 100644
>> --- a/arch/arm/configs/shmobile_defconfig
>> +++ b/arch/arm/configs/shmobile_defconfig
>> @@ -141,8 +141,6 @@ CONFIG_MEDIA_CAMERA_SUPPORT=y
>>  CONFIG_MEDIA_CONTROLLER=y
>>  CONFIG_VIDEO_V4L2_SUBDEV_API=y
>>  CONFIG_V4L_PLATFORM_DRIVERS=y
>> -CONFIG_SOC_CAMERA=y
>> -CONFIG_SOC_CAMERA_PLATFORM=y
>>  CONFIG_VIDEO_RCAR_VIN=y
>>  CONFIG_V4L_MEM2MEM_DRIVERS=y
>>  CONFIG_VIDEO_RENESAS_JPU=y
>> --
>> 2.7.4
>>
