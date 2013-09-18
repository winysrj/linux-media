Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:50405 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab3IRLsW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Sep 2013 07:48:22 -0400
MIME-Version: 1.0
In-Reply-To: <5238C090.6090201@gmail.com>
References: <1377066881-5423-1-git-send-email-arun.kk@samsung.com>
	<1377066881-5423-2-git-send-email-arun.kk@samsung.com>
	<52377DE5.3070808@gmail.com>
	<CALt3h79YMgdkju17SF8M3NKLkJ+6Gjzy2vwXDYTXc8B-GaecyQ@mail.gmail.com>
	<5238C090.6090201@gmail.com>
Date: Wed, 18 Sep 2013 17:18:21 +0530
Message-ID: <CALt3h7_JgsuNyzVvL1eZ=zThk_22V0bLARxkhtLGJ2PQG1Qf4Q@mail.gmail.com>
Subject: Re: [PATCH v7 01/13] [media] exynos5-is: Adding media device driver
 for exynos5
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Kumar Gala <galak@codeaurora.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	kilyeon.im@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wed, Sep 18, 2013 at 2:20 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Arun,
>
>
> On 09/17/2013 01:29 PM, Arun Kumar K wrote:
>>
>> Wont this make fimc-is to be enabled to use fimc-lite?
>
>
> Hmm, it would be runtime PM active, yes. But it doesn't mean the
> Cortex-A5's firmware would need to be running.
>
>
>> As such there is no dependency like that in hardware and we can
>> use fimc-lite alone in DMA out mode without fimc-is.
>
>
> If you are sure about it, then fimc-lite nodes could stay at root level.
> Still, it would be more appropriate IMO to have the FIMC-IS sub-/peripheral
> devices, like I2C or SPI bus controllers, instantiated by the FIMC-IS
> driver.
>

Yes I2C and SPI bus controllers are part of FIMC-IS and it can be
instantiated within the FIMC-IS driver.

> And what about "glue logic" linking FIMC-LITEs with the rest of the
> imaging subsystem ? Are you sure the is no some weird inter-dependencies ?
> Note that there is no board files any more, where we could hack some
> details.
>

There is no dependency like that which I am aware of and we have tested
here mipi & fimc-lite without fimc-is and it worked well.

>
>> If its modified as per your suggestion, how will the scenario of
>> sensor ->  mipi-csis ->  fimc-lite ->  memory look like without fimc-is?
>
>
> The exynos5-fimc-is module would need to be loaded for that. If you're
> sure the hardware can work independently, we could leave out the fimc-lite
> nodes at root level.
>

Yes sensor-> mipi -> fimc-lite -> memory without fimc-is is very well possible
in Exynos5 and its tested.

So I will make the remaining changes you suggested and send new patchset.

Regards
Arun
