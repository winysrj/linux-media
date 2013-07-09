Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:43275 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab3GIMET (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jul 2013 08:04:19 -0400
Received: by mail-vc0-f173.google.com with SMTP id ht10so4199543vcb.4
        for <linux-media@vger.kernel.org>; Tue, 09 Jul 2013 05:04:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201306260927.17210.hverkuil@xs4all.nl>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-6-git-send-email-arun.kk@samsung.com>
	<201306260927.17210.hverkuil@xs4all.nl>
Date: Tue, 9 Jul 2013 17:34:18 +0530
Message-ID: <CALt3h79RD2cejJBDStMqcuhi9BUo5EAn+5trNzJHHo_s_zYr7g@mail.gmail.com>
Subject: Re: [RFC v2 05/10] exynos5-fimc-is: Adds the sensor subdev
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review.

On Wed, Jun 26, 2013 at 12:57 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Fri May 31 2013 15:03:23 Arun Kumar K wrote:
>> FIMC-IS uses certain sensors which are exclusively controlled
>> from the IS firmware. This patch adds the sensor subdev for the
>> fimc-is sensors.
>>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
>
> Not surprisingly I really hate the idea of sensor drivers that are tied to
> a specific SoC, since it completely destroys the reusability of such drivers.
>

Yes agree to it.

> I understand that you have little choice to do something special here, but
> I was wondering whether there is a way of keeping things as generic as
> possible.
>
> I'm just brainstorming here, but as far as I can see this driver is basically
> a partial sensor driver: it handles the clock, the format negotiation and
> power management. Any sensor driver needs that.
>
> What would be nice is if the fmic specific parts are replaced by callbacks
> into the bridge driver using v4l2_subdev_notify().
>
> The platform data (or DT) can also state if this sensor is firmware controlled
> or not. If not, then the missing bits can be implemented in the future by
> someone who needs that.
>
> That way the driver itself remains independent from fimc.
>
> And existing sensor drivers can be adapted to be usable with fimc as well by
> adding support for the notify callback.
>
> Would a scheme along those lines work?
>

Yes this should make the implementation very generic.
Will check the feasibility of this approach.

Thanks & Regards
Arun
