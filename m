Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58488 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521AbaE2O55 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 10:57:57 -0400
Message-ID: <53874BBE.1000801@linux.intel.com>
Date: Thu, 29 May 2014 18:01:18 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v3 3/3] smiapp: Implement the test pattern control
References: <1401374448-30411-1-git-send-email-sakari.ailus@linux.intel.com> <1401374448-30411-4-git-send-email-sakari.ailus@linux.intel.com> <2777039.3n5AP3eAS8@avalon>
In-Reply-To: <2777039.3n5AP3eAS8@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
>> @@ -404,6 +404,16 @@ static void smiapp_update_mbus_formats(struct
>> smiapp_sensor *sensor) pixel_order_str[pixel_order]);
>>   }
>>
>> +static const char * const smiapp_test_patterns[] = {
>> +	"Disabled",
>> +	"Solid Colour",
>> +	"Eight Vertical Colour Bars",
>> +	"Colour Bars With Fade to Grey",
>> +	"Pseudorandom Sequence (PN9)",
>> +};
>> +
>> +static const struct v4l2_ctrl_ops smiapp_ctrl_ops;
>
> Is this needed ?

Not anymore. It was necessary when there was configuration information 
for custom controls. I'll remove it.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
