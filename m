Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34806 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab2B2KAk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Feb 2012 05:00:40 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M05002VCFT2IM60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Feb 2012 10:00:38 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0500MO8FT2WX@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Feb 2012 10:00:38 +0000 (GMT)
Date: Wed, 29 Feb 2012 11:00:27 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 32/33] smiapp: Add driver.
In-reply-to: <3598400.2MKjxpiZx5@avalon>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, teturtia@gmail.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com, k.debski@gmail.com,
	riverful@gmail.com
Message-id: <4F4DF73B.8060405@samsung.com>
References: <20120220015605.GI7784@valkosipuli.localdomain>
 <2925645.UTNbXqr535@avalon> <20120229054149.GB14920@valkosipuli.localdomain>
 <3598400.2MKjxpiZx5@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/29/2012 10:35 AM, Laurent Pinchart wrote:
>>>> +	if (sensor->pixel_array->ctrl_handler.error) {
>>>> +		dev_err(&client->dev,
>>>> +			"pixel array controls initialization failed (%d)\n",
>>>> +			sensor->pixel_array->ctrl_handler.error);
>>>
>>> Shouldn't you call v4l2_ctrl_handler_free() here ?
>>
>> Yes. Fixed.
>>
>>>> +		return sensor->pixel_array->ctrl_handler.error;
>>>> +	}
>>>> +
>>>> +	sensor->pixel_array->sd.ctrl_handler =
>>>> +		&sensor->pixel_array->ctrl_handler;
>>>> +
>>>> +	v4l2_ctrl_cluster(2, &sensor->hflip);
>>>
>>> Shouldn't you move this before the control handler check ?
>>
>> Why? It can't fail.
> 
> I thought it could fail. You could then leave it here, but it would be easier 
> from a maintenance point of view to check the error code after completing all 
> control-related initialization, as it would avoid introducing a bug if for 
> some reason the v4l2_ctrl_cluster() function needs to return an error later.

By calling v4l2_ctrl_cluster() after the control handler check you're sure
sensor->hflip is a pointer to a valid control. In case the HFLIP control
creation fails and you try to cluster that, unpredictable things may happen.
Well, predictable, e.g. BUG_ON() in v4l2_ctrl_cluster(). :-)

So using v4l2_ctrl_cluster() before checking ctrl_handler.error would require
validating the control pointer or maybe something more.

-- 

Regards,
Sylwester
