Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27044 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbaE1MTS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 08:19:18 -0400
Message-ID: <5385D3BA.90201@linux.intel.com>
Date: Wed, 28 May 2014 15:16:58 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] smiapp: Add driver-specific control class, test pattern
 controls
References: <1401194628-31679-1-git-send-email-sakari.ailus@linux.intel.com> <1401267638-7606-1-git-send-email-sakari.ailus@linux.intel.com> <1867765.dyDJbEnErb@avalon>
In-Reply-To: <1867765.dyDJbEnErb@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
>
> Thank you for the patch.
>
> On Wednesday 28 May 2014 12:00:38 Sakari Ailus wrote:
>> Add smiapp driver specific control sub-class for test pattern controls. More
>> controls are expected since a fair amount of the standard functionality is
>> still unsupported. There are sensor model specific functionality as well
>> and expectedly thus also sensor specific controls. So reserve 128 controls
>> for this driver.
>>
>> This patch also adds test pattern controls for the four colour components.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>> This patch comes before the previous patch I sent to the thread. I missed
>> this when sending it.
>>
>>   include/uapi/linux/smiapp.h        | 34 ++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/v4l2-controls.h |  4 ++++
>>   2 files changed, 38 insertions(+)
>>   create mode 100644 include/uapi/linux/smiapp.h
>>
>> diff --git a/include/uapi/linux/smiapp.h b/include/uapi/linux/smiapp.h
>> new file mode 100644
>> index 0000000..116fc69
>> --- /dev/null
>> +++ b/include/uapi/linux/smiapp.h
>> @@ -0,0 +1,34 @@
>> +/*
>> + * include/media/smiapp.h
>> + *
>> + * Generic driver for SMIA/SMIA++ compliant camera modules
>> + *
>> + * Copyright (C) 2014 Intel Corporation
>> + * Contact: Sakari Ailus <sakari.ailus@iki.fi>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + */
>> +
>> +#ifndef __UAPI_LINUX_SMIAPP_H_
>> +#define __UAPI_LINUX_SMIAPP_H_
>> +
>> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_DISABLED			0
>> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_SOLID_COLOUR		1
>> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_COLOUR_BARS		2
>> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_COLOUR_BARS_GREY		3
>> +#define V4L2_SMIAPP_TEST_PATTERN_MODE_PN9			4
>> +
>> +#define V4L2_CID_SMIAPP_TEST_PATTERN_RED	(V4L2_CID_USER_SMIAPP_BASE |
>> 0x01)
>> +#define V4L2_CID_SMIAPP_TEST_PATTERN_GREENR	(V4L2_CID_USER_SMIAPP_BASE |
>> 0x02)
>> +#define V4L2_CID_SMIAPP_TEST_PATTERN_BLUE	(V4L2_CID_USER_SMIAPP_BASE |
>> 0x03)
>> +#define V4L2_CID_SMIAPP_TEST_PATTERN_GREENB	(V4L2_CID_USER_SMIAPP_BASE |
>> 0x04)
>
> Wouldn't it make sense to create a standard test pattern color control instead
> ? Several sensors can control the test pattern color in a way or another. Some
> of them might need more than one color though, so I'm not sure how much
> standardization would be possible.

Now that you mention it, I'd guess many raw bayer sensors can set 
colours for the test pattern (or image). The menu control has no 
standardised values so I didn't think of standardising controls that 
depend on it.

I'll update the patches (and add a new one for the standard controls).

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
