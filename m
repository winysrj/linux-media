Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60757 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2GTKDU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 06:03:20 -0400
Received: by vbbff1 with SMTP id ff1so2751407vbb.19
        for <linux-media@vger.kernel.org>; Fri, 20 Jul 2012 03:03:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADPsn1bniYQQ-pefrX+XdbLk1n-Na_dSYWspORkGCwo5+XBtrw@mail.gmail.com>
References: <1342700047-31806-1-git-send-email-sangwook.lee@linaro.org>
	<1342700047-31806-2-git-send-email-sangwook.lee@linaro.org>
	<500862C0.2000507@gmail.com>
	<CADPsn1bniYQQ-pefrX+XdbLk1n-Na_dSYWspORkGCwo5+XBtrw@mail.gmail.com>
Date: Fri, 20 Jul 2012 11:03:19 +0100
Message-ID: <CADPsn1YVOcE=XQk2ayzeLGyse4yYZKJt3voffOf7pVqhk+ZzpA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] v4l: Add factory register values form S5K4ECGX sensor
From: Sangwook Lee <sangwook.lee@linaro.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org,
	david.a.cohen@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Opps, the previous email has a HTML part, so resending.




Hi Sylwester

Thank for the review.

On 19 July 2012 20:40, Sylwester Nawrocki <sylvester.nawrocki@gmail.com> wrote:
>
> Hi Sangwook,
>
> On 07/19/2012 02:14 PM, Sangwook Lee wrote:
> > Add factory default settings for S5K4ECGX sensor registers.
> > I copied them from the reference code of Samsung S.LSI.
>
> I'm pretty sure we can do better than that. I've started S5K6AAFX sensor
> driver development with similar set of write-only register address/value
> arrays, that stored mainly register default values after the device reset,
> or were configuring presets that were never used.
>
> If you lok at the s5k6aa driver, you'll find only one relatively small
> array of register values for the analog processing block settings.
> It's true that I had to reverse engineer a couple of things, but I also
>
> had a relatively good datasheet for the sensor.
>

Yes, I already saw analog settings in s5k6aa. Compared to s5k6aa,
I couldn't also understand why the sensor has lots of initial values.
Is it because s5k4ecgx is slightly more complicated than s5k6aa ?

> > According to comments from the reference code, they do not
> > recommend any changes of these settings.
>
> Yes, but it doesn't mean cannot convert, at least part of, those ugly
> tables into function calls.


Yes, the biggest table seems to be one time for boot-up, at least I need to
remove one more macro (token)

>
> Have you tried to contact Samsung S.LSI for a datasheet that would
> contain better registers' description ?


As you might know, there is a limitation for me to get those information. :-)
Instead, if I look into the source code of Google Nexus S which uses s5k4ecgx,

  https://android.googlesource.com/kernel/samsung.git

I can discover that both Google and Samsung are using the same huge table
just for initial settings from the sensor booting-up. I added the
original author
of this sensor driver. Hopes he might add some comments :-)



Thanks
Sangwook

>
> --
>
> Thanks,
> Sylwester
