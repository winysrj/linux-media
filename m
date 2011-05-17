Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51756 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab1EQUGb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 16:06:31 -0400
Message-ID: <4DD2D53F.8020403@gmail.com>
Date: Tue, 17 May 2011 22:06:23 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, kgene.kim@samsung.com,
	sungchun.kang@samsung.com, jonghun.han@samsung.com,
	stern@rowland.harvard.edu, rjw@sisk.pl
Subject: Re: [PATCH 3/3 v5] v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI
 receivers
References: <1305127030-30162-1-git-send-email-s.nawrocki@samsung.com> <201105141729.58363.laurent.pinchart@ideasonboard.com> <4DCF9DDA.4060600@gmail.com> <201105152310.07178.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105152310.07178.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On 05/15/2011 11:10 PM, Laurent Pinchart wrote:
> On Sunday 15 May 2011 11:33:14 Sylwester Nawrocki wrote:
>> On 05/14/2011 05:29 PM, Laurent Pinchart wrote:
>>> On Wednesday 11 May 2011 17:17:10 Sylwester Nawrocki wrote:

<snip>

>>
>> I perhaps need to isolate functions out from of s5pcsis_resume/suspend and
>> then call that in s_power op and s5pcsis_resume/suspend. Don't really like
>> this idea though... It would virtually render pm_runtime_* calls unusable
>> in this sub-device driver, those would make sense only in the host driver..
> 
> I think using the pm_runtime_* calls make sense, they could replace the subdev
> s_power operation in the long term. We'll need to evaluate that (I'm not sure
> if runtime PM is available on all platforms targeted by V4L2 for instance).

That sounds like a really good direction. It would let us have clear standardized
rules for power handling in V4L2. And with new chips of more complicated
topologies the power handling details could be taken care of by the Runtime PM
subsystem. As the runtime PM becomes more granular it appears a good alternative
for simple subdev s_power call.

Unfortunately still only a few architectures support runtime PM at device bus level
in the mainline. What I identified is:
 arm/mach-exynos4
 arm/mach-omap1
 arm/mach-omap2
 arm/mach-shmobile

So very few, no x86 here.

As we have I2C, SPI and platform device v4l subdevs ideally those buses should
support Runtime PM.

>> I just wanted to put all what is needed to control device's power in the PM
>> helpers and then use pm_runtime_* calls where required.

--
Regards,

Sylwester Nawrocki
