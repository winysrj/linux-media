Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46490 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab3DVKFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 06:05:53 -0400
Message-id: <51750B7D.3050401@samsung.com>
Date: Mon, 22 Apr 2013 12:05:49 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: dri-devel@lists.freedesktop.org,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	linux-samsung-soc@vger.kernel.org,
	"patches@linaro.org" <patches@linaro.org>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	linaro-kernel@lists.linaro.org,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4] drm/exynos: prepare FIMD clocks
References: <1365419265-21238-1-git-send-email-vikas.sajjan@linaro.org>
 <3109033.iP2qIPD33v@flatron>
 <CAKohpok+tNxCmy-TMRweObPLSVHECZzdgJxRh2iDWyXQCiJuqg@mail.gmail.com>
 <1731019.P1JXV7Hkkn@amdc1227>
In-reply-to: <1731019.P1JXV7Hkkn@amdc1227>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/22/2013 11:56 AM, Tomasz Figa wrote:
> On Monday 22 of April 2013 10:44:00 Viresh Kumar wrote:
>> On 21 April 2013 20:13, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>>> 3) after those two changes, all that remains is to fix compliance with
>>> Common Clock Framework, in other words:
>>>
>>> s/clk_enable/clk_prepare_enable/
>>>
>>> and
>>>
>>> s/clk_disable/clk_disable_unprepare/
>>
>> We don't have to call  clk_{un}prepare() everytime for your platform as
>> you aren't doing anything in it. So just call them once at probe/remove and
>> call clk_enable/disable everywhere else.

Yes, I agree with that. Additionally clk_(un)prepare must not be called in
atomic context, so some drivers will have to work like this anyway.
Or the clocks could be prepared/unprepared in the device open/close file op
for instance.

> Can you assure that in future SoCs, on which this driver will be used, this 
> assumption will still hold true or even that in current Exynos driver this 
> behavior won't be changed?


