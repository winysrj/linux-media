Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:12832 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782AbaE2PKn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 11:10:43 -0400
Message-ID: <53874EBE.9040108@linux.intel.com>
Date: Thu, 29 May 2014 18:14:06 +0300
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
>> @@ -543,6 +594,14 @@ static int smiapp_init_controls(struct smiapp_sensor
>> *sensor) goto error;
>>   	}
>>
>> +	for (i = 0; i < ARRAY_SIZE(sensor->test_data); i++) {
>> +		struct v4l2_ctrl *ctrl = sensor->test_data[i];
>> +
>> +		ctrl->maximum =
>> +			ctrl->default_value =
>> +			ctrl->cur.val = (1 << sensor->csi_format->width) - 1;
>
> I think multiple assignments on the same line are discouraged.
>
> Furthermore, couldn't you move this above and use the right values directly
> when creating the controls ?

Good point. There might have been a reason to do this in a past version 
of the patch but it no longer exists.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
