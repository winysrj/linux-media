Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:62939 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab3GPWLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jul 2013 18:11:34 -0400
Message-ID: <51E5C511.70202@gmail.com>
Date: Wed, 17 Jul 2013 00:11:29 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arunkk.samsung@gmail.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [RFC v2 06/10] exynos5-fimc-is: Adds isp subdev
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com> <1370005408-10853-7-git-send-email-arun.kk@samsung.com> <51C38F82.1040507@gmail.com> <CALt3h7_Bo3P9WsZORXXWtXrWLS4Uoeq10HYr0WsgO5wVzqQ95w@mail.gmail.com>
In-Reply-To: <CALt3h7_Bo3P9WsZORXXWtXrWLS4Uoeq10HYr0WsgO5wVzqQ95w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/09/2013 01:42 PM, Arun Kumar K wrote:
>>> +       /* Check if same as sensor width&   height */
>>> >>
>>> >>  +       sensor_width = p->sensor->drvdata->pixel_width;
>>> >>  +       sensor_height = p->sensor->drvdata->pixel_height;
>>> >>  +       if ((sensor_width != f->fmt.pix_mp.width) ||
>>> >>  +               (sensor_height != f->fmt.pix_mp.height)) {
>> >
>> >
>> >  What's the point of this check ?
>> >
> Check was added to ensure ISP input width and height is
> set same as the sensor output or not.
> But yes this cannot be extended to generic (non-IS controlled) sensors.
> Will drop this check and let media controller take care.
>
>> >
>>> >>  +               f->fmt.pix_mp.width = sensor_width;
>>> >>  +               f->fmt.pix_mp.height = sensor_height;
>>> >>  +       }

I meant that you could do the assignment unconditionally, since you
always end up with sensor_width/height assigned to pix_mp.width/height.
Indeed, this should be handled by subdev ioctls, and any discrepancies
should be detected while starting streaming and reported to user space.

--
Thanks,
Sylwester
