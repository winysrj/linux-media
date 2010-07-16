Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56519 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965234Ab0GPNf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jul 2010 09:35:58 -0400
Message-ID: <4C40603B.8000208@gmail.com>
Date: Fri, 16 Jul 2010 15:35:55 +0200
From: Maurus Cuelenaere <mcuelenaere@gmail.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: 'Kukjin Kim' <kgene.kim@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/10 v2] ARM: Samsung: Add FIMC register and platform
 definitions
References: <1279185041-6004-1-git-send-email-s.nawrocki@samsung.com> <1279185041-6004-2-git-send-email-s.nawrocki@samsung.com> <012101cb24cb$83187410$89495c30$%kim@samsung.com> <000301cb24eb$13434000$39c9c000$%nawrocki@samsung.com>
In-Reply-To: <000301cb24eb$13434000$39c9c000$%nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Op 16-07-10 15:30, Sylwester Nawrocki schreef:
> Hi,
>
> thank you for the review. Please se my comments below.
>
>> -----Original Message-----
>> From: Kukjin Kim [mailto:kgene.kim@samsung.com]
>> Sent: Friday, July 16, 2010 11:45 AM
>> To: 'Sylwester Nawrocki'; linux-samsung-soc@vger.kernel.org; linux-arm-
>> kernel@lists.infradead.org
>> Cc: p.osciak@samsung.com; m.szyprowski@samsung.com;
>> kyungmin.park@samsung.com; linux-media@vger.kernel.org
>> Subject: RE: [PATCH 01/10 v2] ARM: Samsung: Add FIMC register and
>> platform definitions
>>
>> Sylwester Nawrocki wrote:
>>> FIMC device is a camera interface embedded in S3C/S5P Samsung SOC
>> series.
>>> It supports ITU-R BT.601/656 and MIPI-CSI2 standards, memory to
>> memory
>>> operations, color conversion, resizing and rotation.
>>>
>>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>  arch/arm/plat-samsung/include/plat/fimc.h      |   31 ++
>>>  arch/arm/plat-samsung/include/plat/regs-fimc.h |  361
>>> ++++++++++++++++++++++++
>>>  2 files changed, 392 insertions(+), 0 deletions(-)
>>>  create mode 100644 arch/arm/plat-samsung/include/plat/fimc.h
>>>  create mode 100644 arch/arm/plat-samsung/include/plat/regs-fimc.h
>>>
>>> diff --git a/arch/arm/plat-samsung/include/plat/fimc.h
>> b/arch/arm/plat-
>>> samsung/include/plat/fimc.h
>>> new file mode 100644
>>> index 0000000..be1e853
>>> --- /dev/null
>>> +++ b/arch/arm/plat-samsung/include/plat/fimc.h
>>> @@ -0,0 +1,31 @@
>>> +/* linux/arch/arm/plat-samsung/include/plat/fimc.h
>>> + *
>>> + * Platform header file for FIMC driver
>>> + *
>>> + * Copyright (c) 2010 Samsung Electronics
>>> + *
>>> + * Sylwester Nawrocki, <s.nawrocki@samsung.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>> modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> + */
>>> +
>>> +#ifndef FIMC_H_
>>> +#define FIMC_H_
>>> +
>>> +#include <linux/device.h>
>>> +#include <linux/platform_device.h>
>>> +
>>> +
>> 2 empty lines...
> I don't mind at all changing these to single line if it is 
> the adopted style, however I didn't file like so when looking
> through the existing headers.
>
>>> +#define FIMC_MAX_FIFO_TARGETS	1
>>> +#define FIMC_LCD_FIFO_TARGET	0
>>> +
>>> +struct s3c_fifo_link;
>>> +
>>> +struct samsung_plat_fimc {
>>> +	struct s3c_fifo_link	*fifo_targets[FIMC_MAX_FIFO_TARGETS];
>>> +};
>>> +
>>> +#endif /* FIMC_H_ */
>>> +
>> No need last empty line...
> C89 and C99 standard requires a new line character at the end of file.
> The compiler should issue a warning when the new line character 
> at the end of file is missing, otherwise it is not compliant with 
> the above C standards.
> So I would rather add a new line where it is missing rather than 
> removing it.
> There is lots of header files already in arch/arm/plat-samsung where 
> there is even more than one empty line at the end of file. 

AFAIK there *already is* an empty line, git just omits it in diffs.
Try removing the last line with your editor and see what git diff gives, it'll
show "\ No newline at end of file".

-- 
Maurus Cuelenaere
