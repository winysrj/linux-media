Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49793 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048AbaE2PFB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 11:05:01 -0400
Message-ID: <53874D6B.9000402@linux.intel.com>
Date: Thu, 29 May 2014 18:08:27 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v3 2/3] smiapp: Add driver-specific test pattern menu
 item definitions
References: <1401374448-30411-1-git-send-email-sakari.ailus@linux.intel.com> <1401374448-30411-3-git-send-email-sakari.ailus@linux.intel.com> <2661194.GTh768bpeF@avalon>
In-Reply-To: <2661194.GTh768bpeF@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
>> diff --git a/include/uapi/linux/smiapp.h b/include/uapi/linux/smiapp.h
>> new file mode 100644
>> index 0000000..53938f4
>> --- /dev/null
>> +++ b/include/uapi/linux/smiapp.h
>> @@ -0,0 +1,29 @@
>> +/*
>> + * include/uapi/linux/smiapp.h
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
>
> Out of curiosity, what's PN9 ?

It's a sequence of pseudo-random binary numbers, e.g.:

<URL:http://en.wikipedia.org/wiki/Pseudorandom_binary_sequence>

9 is the order of the polynomial.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
