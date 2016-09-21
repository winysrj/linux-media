Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37587 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751266AbcIUGqv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 02:46:51 -0400
Subject: Re: [PATCH] pxa_camera: merge soc_mediabus.c into pxa_camera.c
To: Robert Jarzmik <robert.jarzmik@free.fr>
References: <874d9ba3-7508-7efd-e83f-a7c630a1fbe3@xs4all.nl>
 <87r38ddai5.fsf@belgarion.home>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <68f66d44-2098-1b01-3ebb-2261afe4fd29@xs4all.nl>
Date: Wed, 21 Sep 2016 08:46:45 +0200
MIME-Version: 1.0
In-Reply-To: <87r38ddai5.fsf@belgarion.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/21/2016 08:37 AM, Robert Jarzmik wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
>> Linking soc_mediabus into this driver causes multiple definition linker warnings
>> if soc_camera is also enabled:
>>
>>    drivers/media/platform/soc_camera/built-in.o:(___ksymtab+soc_mbus_image_size+0x0): multiple definition of `__ksymtab_soc_mbus_image_size'
>>    drivers/media/platform/soc_camera/soc_mediabus.o:(___ksymtab+soc_mbus_image_size+0x0): first defined here
>>>> drivers/media/platform/soc_camera/built-in.o:(___ksymtab+soc_mbus_samples_per_pixel+0x0): multiple definition of `__ksymtab_soc_mbus_samples_per_pixel'
>>    drivers/media/platform/soc_camera/soc_mediabus.o:(___ksymtab+soc_mbus_samples_per_pixel+0x0): first defined here
>>    drivers/media/platform/soc_camera/built-in.o: In function `soc_mbus_config_compatible':
>>    (.text+0x3840): multiple definition of `soc_mbus_config_compatible'
>>    drivers/media/platform/soc_camera/soc_mediabus.o:(.text+0x134): first defined here
>>
>> Since we really don't want to have to use any of the soc-camera code this patch
>> copies the relevant code and data structures from soc_mediabus and renames it to pxa_mbus_*.
>>
>> The large table of formats has been culled a bit, removing formats that are not supported
>> by this driver.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Robert Jarzmik <robert.jarzmik@free.fr>
> 
> Hi Hans,
> 
> I wonder why you chose to copy-paste this code instead of adding in the Kconfig
> a "depends on !SOC_CAMERA". Any specific reason ? As this will have to be dealt
> with later anyway as you pointed out earlier, this format translation I mean, I
> was wondering if this was the best approach.

I thought about that, but that would make it impossible to COMPILE_TEST both the
pxa and the soc_camera driver. In addition, the pxa and soc_camera are the only
drivers that use this, and I prefer to just merge that code into pxa so that it can
be modified independently from soc_camera.

I really want to remove all dependencies to soc_camera. That will also make it easier
to refactor soc_camera once I get the atmel-isi driver out of soc_camera.

Regards,

	Hans
