Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:43596 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3AVV51 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 16:57:27 -0500
Received: by mail-ee0-f42.google.com with SMTP id b47so3626108eek.1
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 13:57:26 -0800 (PST)
Message-ID: <50FF0B43.5050802@gmail.com>
Date: Tue, 22 Jan 2013 22:57:23 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 3/3] V4L: Add driver for OV9650/52 image sensors
References: <1358630842-12689-1-git-send-email-sylvester.nawrocki@gmail.com> <1358630842-12689-4-git-send-email-sylvester.nawrocki@gmail.com> <201301211034.46222.hverkuil@xs4all.nl>
In-Reply-To: <201301211034.46222.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/21/2013 10:34 AM, Hans Verkuil wrote:
> On Sat January 19 2013 22:27:22 Sylwester Nawrocki wrote:
>> This patch adds V4L2 sub-device driver for OV9650/OV9652 image sensors.
>>
>> The driver exposes following V4L2 controls:
>> - auto/manual exposure,
>> - auto/manual white balance,
>> - auto/manual gain,
>> - brightness, saturation, sharpness,
>> - horizontal/vertical flip,
>> - color bar test pattern,
>> - banding filter (power line frequency).
>>
>> Frame rate can be configured with g/s_frame_interval pad level ops.
>> Supported resolution are only: SXGA, VGA, QVGA.
>>
>> Signed-off-by: Sylwester Nawrocki<sylvester.nawrocki@gmail.com>
>
> Some small comments:
>
> <snip>
>
>> +
>> +static int ov965x_log_status(struct v4l2_subdev *sd)
>> +{
>> +	v4l2_ctrl_handler_log_status(sd->ctrl_handler, sd->name);
>> +	return 0;
>> +}
>
> A short helper function (v4l2_ctrl_subdev_log_status) would simplify this
> as that can be used as a core op directly.
>
>> +
>
> <snip>
>
>> +
>> +static int ov965x_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
>> +				  struct v4l2_event_subscription *sub)
>> +{
>> +	return v4l2_ctrl_subscribe_event(fh, sub);
>> +}
>> +
>> +static int ov965x_unsubscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
>> +				    struct v4l2_event_subscription *sub)
>> +{
>> +	return v4l2_event_unsubscribe(fh, sub);
>> +}
>
> I suggest that two helper functions are added (v4l2_ctrl_subdev_subscribe_event
> and v4l2_event_subdev_unsubscribe) that can be used as a core op directly.

I had a feeling such helpers are indeed missing. I guess I just needed some
incentive to add them myself ;D

>> diff --git a/include/media/ov9650.h b/include/media/ov9650.h
>> new file mode 100644
>> index 0000000..2fab780
>> --- /dev/null
>> +++ b/include/media/ov9650.h
>> @@ -0,0 +1,27 @@
>> +/*
>> + * OV9650/OV9652 camera sensors driver
>> + *
>> + * Copyright (C) 2013 Sylwester Nawrocki<sylvester.nawrocki@gmail.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +#ifndef OV9650_H_
>> +#define OV9650_H_
>> +
>> +/**
>> + * struct ov9650_platform_data - ov9650 driver platform data
>> + * @mclk_frequency: the sensor's master clock frequency
>
> What's the unit? Hz?

Oh, too bad, didn't mention the unit. It is supposed to be in Hz, yes.
I'll fix it.

>> + * @gpio_pwdn:	    number of a GPIO connected to OV965X PWDN pin
>> + * @gpio_reset:     number of a GPIO connected to OV965X RESET pin
>> + *
>> + * If any of @gpio_pwdn or @gpio_reset are unused then should be
>
> s/then should/then they should/
>
>> + * set to negative value. @mclk_frequency must always be specified.
>
> s/set to/set to a/

Amended. Thank you for the review!

--

Regards,
Sylwester


