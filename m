Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:58326 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729946AbeHCIYS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Aug 2018 04:24:18 -0400
Subject: Re: [PATCH] media: platform: cros-ec-cec: fix dependency on
 MFD_CROS_EC
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180724093624.1670671-1-arnd@arndb.de>
 <20180802195824.26a9720a@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cb43f8ab-ea10-b847-7724-ee9a87f88ca2@xs4all.nl>
Date: Fri, 3 Aug 2018 08:29:26 +0200
MIME-Version: 1.0
In-Reply-To: <20180802195824.26a9720a@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/2018 12:58 AM, Mauro Carvalho Chehab wrote:
> Em Tue, 24 Jul 2018 11:35:59 +0200
> Arnd Bergmann <arnd@arndb.de> escreveu:
> 
>> Without the MFD driver, we run into a link error:
> 
> Weird... I'm not seeing this driver at the media tree... was it merged via
> some other tree?

Yes, it's going via the mfd subsystem. This driver touched on the mfd, drm and
media subsystems, in the end it was decided to let the mfd subsystem take this
since it had the most impact on that subsystem.

Regards,

	Hans

> 
>>
>> drivers/media/platform/cros-ec-cec/cros-ec-cec.o: In function `cros_ec_cec_transmit':
>> cros-ec-cec.c:(.text+0x474): undefined reference to `cros_ec_cmd_xfer_status'
>> drivers/media/platform/cros-ec-cec/cros-ec-cec.o: In function `cros_ec_cec_set_log_addr':
>> cros-ec-cec.c:(.text+0x60b): undefined reference to `cros_ec_cmd_xfer_status'
>> drivers/media/platform/cros-ec-cec/cros-ec-cec.o: In function `cros_ec_cec_adap_enable':
>> cros-ec-cec.c:(.text+0x77d): undefined reference to `cros_ec_cmd_xfer_status'
>>
>> As we can compile-test all the dependency, the extra '| COMPILE_TEST' is
>> not needed to get the build coverage, and we can simply turn MFD_CROS_EC
>> into a hard dependency to make it build in all configurations.
>>
>> Fixes: cd70de2d356e ("media: platform: Add ChromeOS EC CEC driver")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/media/platform/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index 92b182da8e4d..018fcbed82e4 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -535,7 +535,7 @@ if CEC_PLATFORM_DRIVERS
>>  
>>  config VIDEO_CROS_EC_CEC
>>  	tristate "ChromeOS EC CEC driver"
>> -	depends on MFD_CROS_EC || COMPILE_TEST
>> +	depends on MFD_CROS_EC
>>  	select CEC_CORE
>>  	select CEC_NOTIFIER
>>  	---help---
> 
> 
> 
> Thanks,
> Mauro
> 
