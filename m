Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57667 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab3J2AGe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Oct 2013 20:06:34 -0400
Message-ID: <526EFC06.70101@gmail.com>
Date: Tue, 29 Oct 2013 01:06:30 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	LMML <linux-media@vger.kernel.org>, devicetree@vger.kernel.org,
	Grant Likely <grant.likely@linaro.org>,
	Arun Kumar K <arun.kk@samsung.com>,
	Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [GIT PULL FOR 3.13] Exynos5 SoC FIMC-IS imaging subsystem driver
References: <5261967E.6010001@samsung.com> <20131028201136.6f66d3f7@samsung.com>
In-Reply-To: <20131028201136.6f66d3f7@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 10/28/2013 11:11 PM, Mauro Carvalho Chehab wrote:
>> The following changes since commit 8ca5d2d8e58df7235b77ed435e63c484e123fede:
>> >
>> >     [media] uvcvideo: Fix data type for pan/tilt control (2013-10-17 06:55:29 -0300)
>> >
>> >  are available in the git repository at:
>> >
>> >     git://linuxtv.org/snawrocki/samsung.git for-v3.13-2
>> >
>> >  for you to fetch changes up to 6eb89d71b27e6731755ab5722f3cdc0f6e8273f2:
>> >
>> >     V4L: Add s5k4e5 sensor driver (2013-10-18 21:36:42 +0200)
>> >
>> >  ----------------------------------------------------------------
>> >  Arun Kumar K (12):
>> >         exynos5-fimc-is: Add Exynos5 FIMC-IS device tree bindings documentation
>
> As agreed during KS, the subsystem maintainers should wait for a documentation
> review on DT by the DT maintainers, at least for a while.
>
> So, I'd like to see either their reviews on this patch:
> 	https://patchwork.linuxtv.org/patch/20439/
>
> Or their ack for us to apply it.

I agree with you on that. Just please note the first version of this patch
has been posted *5 months* ago https://patchwork.linuxtv.org/patch/18684

Stephen has reviewed subsequent version about 3 months ago:
https://patchwork.linuxtv.org/patch/19521

Then we got no more comments from DT maintainers, I have reviewed this patch
multiple times on the mailing lists:
https://patchwork.linuxtv.org/patch/19715
https://patchwork.linuxtv.org/patch/19749

And explicitly asked for an Ack:
https://patchwork.linuxtv.org/patch/19832

Then those 2 versions passed silently:
https://patchwork.linuxtv.org/patch/20055
https://patchwork.linuxtv.org/patch/20225

And...huh...we got another review, I didn't notice it until now:
https://patchwork.linuxtv.org/patch/20439 Thanks Mark.

Arun, care to address those review comments and send us an updated
binding documentation patch ?

Hence I think we have waited for a while. ;)

>> >         exynos5-fimc-is: Add driver core files
>> >         exynos5-fimc-is: Add common driver header files
>> >         exynos5-fimc-is: Add register definition and context header
>> >         exynos5-fimc-is: Add isp subdev
>> >         exynos5-fimc-is: Add scaler subdev
>> >         exynos5-fimc-is: Add sensor interface
>> >         exynos5-fimc-is: Add the hardware pipeline control
>> >         exynos5-fimc-is: Add the hardware interface module
>> >         exynos5-is: Add Kconfig and Makefile
>> >         V4L: Add DT binding doc for s5k4e5 image sensor
>
> Same applies to this patch:
> 	https://patchwork.linuxtv.org/patch/20448/

This one also have been on the mailing list for quite some time and it
uses already standard bindings, so I assumed it is OK to merge it.

https://patchwork.linuxtv.org/project/linux-media/list/?state=*&q=s5k4e5

But if there must be an Ack then we shall wait, it will probably won't
make a big difference now, if this patch is postponed by 3 more months.

--
Thanks,
Sylwester
