Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:63971 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3ABWLZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 17:11:25 -0500
Message-ID: <50E4B088.7070007@gmail.com>
Date: Wed, 02 Jan 2013 23:11:20 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RFC v2 02/15] [media] Add a V4L2 OF parser
References: <1356969793-27268-1-git-send-email-s.nawrocki@samsung.com> <1356969793-27268-3-git-send-email-s.nawrocki@samsung.com> <Pine.LNX.4.64.1301021255380.7829@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1301021255380.7829@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 01/02/2013 12:58 PM, Guennadi Liakhovetski wrote:
>> --- /dev/null
>> +++ b/drivers/media/v4l2-core/v4l2-of.c
>> @@ -0,0 +1,249 @@
>> +/*
>> + * V4L2 OF binding parsing library
>> + *
>> + * Copyright (C) 2012 Renesas Electronics Corp.
>> + * Author: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of version 2 of the GNU General Public License as
>> + * published by the Free Software Foundation.
>> + */
>> +#include<linux/kernel.h>
>> +#include<linux/module.h>
>> +#include<linux/of.h>
>> +#include<linux/slab.h>
>
> Is slab.h really needed? I didn't have it in my version. Maybe you meant
> to include string.h for memset()?

I don't think it is needed, it looks like my mistake. I'll check it again
and replace it with string.h.

I've also noticed there are EXPORT_SYMBOL() missing for the first two 
functions
in this file. I'll fix it in next version.

---

Thanks,
Sylwester
