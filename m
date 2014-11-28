Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44673 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaK1Jer (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 04:34:47 -0500
Message-id: <547841B3.2020902@samsung.com>
Date: Fri, 28 Nov 2014 10:34:43 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	sakari.ailus@linux.intel.com, kyungmin.park@samsung.com,
	b.zolnierkie@samsung.com, Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH/RFC v7 2/3] leds: Add LED Flash Class wrapper to LED
 subsystem
References: <1415808557-29557-1-git-send-email-j.anaszewski@samsung.com>
 <1415808557-29557-3-git-send-email-j.anaszewski@samsung.com>
 <20141127084354.GN8907@valkosipuli.retiisi.org.uk>
In-reply-to: <20141127084354.GN8907@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.
[...]
>> +static void led_clamp_align(struct led_flash_setting *s)
>> +{
>> +	u32 v, offset;
>> +
>> +	v = s->val + s->step / 2;
>> +	v = clamp(v, s->min, s->max);
>> +	offset = v - s->min;
>> +	offset = s->step * (offset / s->step);
>
> You could use the rounddown() macro. I.e.
>
> rounddown(v - s->min, s->step) + s->min;

I took this code snippet from v4l2-ctrls.c.
It allows for aligning the control value to the nearest
step - top or bottom, whereas rounddown only to the
bottom one.

Best Regards,
Jacek Anaszewski
