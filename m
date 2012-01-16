Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63668 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab2APV5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 16:57:34 -0500
Received: by eekc14 with SMTP id c14so288706eek.19
        for <linux-media@vger.kernel.org>; Mon, 16 Jan 2012 13:57:32 -0800 (PST)
Message-ID: <4F149D45.3010603@gmail.com>
Date: Mon, 16 Jan 2012 22:57:25 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com
Subject: Re: [RFC 16/17] smiapp: Add driver.
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-16-git-send-email-sakari.ailus@maxwell.research.nokia.com> <4F072B6C.9060808@gmail.com> <4F08CEDE.7030105@maxwell.research.nokia.com>
In-Reply-To: <4F08CEDE.7030105@maxwell.research.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 01/08/2012 12:01 AM, Sakari Ailus wrote:
>>> +/*
>>> + *
>>> + * V4L2 Controls handling
>>> + *
>>> + */
>>> +
>>> +static void __smiapp_update_exposure_limits(struct smiapp_sensor *sensor)
>>> +{
>>> +	struct v4l2_ctrl *ctrl = sensor->exposure;
>>> +	int max;
>>> +
>>> +	max = sensor->pixel_array->compose[SMIAPP_PAD_SOURCE].height
>>> +		+ sensor->vblank->val -
>>> +		sensor->limits[SMIAPP_LIMIT_COARSE_INTEGRATION_TIME_MAX_MARGIN];
>>> +
>>> +	ctrl->maximum = max;
>>> +	if (ctrl->default_value>   max)
>>> +		ctrl->default_value = max;
>>> +	if (ctrl->val>   max)
>>> +		ctrl->val = max;
>>> +	if (ctrl->cur.val>   max)
>>> +		ctrl->cur.val = max;
>>> +}
>>
>> One more driver that needs control value range update. :)
> 
> :-)
> 
> Are there other drivers that would need something like that, too?
> Anything in the control framework that I have missed related to this?

Yes, I needed that in s5p-fimc driver for the alpha component control.
The alpha channel value range depends on colour format and the control 
needs to be updated accordingly to changes done with VIDIOC_S_FMT.

And no, there is yet nothing in the control framework to support this.
Hans just prepared some proof-of-concept patch [1], but the decision was
to hold on until there appear more drivers needing control value range
update, due to hight complication of life in the userland.

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg39674.html

--
Regards,
Sylwester
