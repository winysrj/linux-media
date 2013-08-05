Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:51036 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3HEFKW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 01:10:22 -0400
MIME-Version: 1.0
In-Reply-To: <51FD78B5.6080507@gmail.com>
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com>
	<51FD78B5.6080507@gmail.com>
Date: Mon, 5 Aug 2013 10:40:20 +0530
Message-ID: <CALt3h78H3pmdyKJJibN35NB--DSZ9Mfdi-PpxH+MdCpbhU+=Jg@mail.gmail.com>
Subject: Re: [RFC v3 00/13] Exynos5 IS driver
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sun, Aug 4, 2013 at 3:10 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Arun,
>
>
> On 08/02/2013 05:02 PM, Arun Kumar K wrote:
>>
>> The patch series add support for Exynos5 camera subsystem. It
>> re-uses mipi-csis and fimc-lite from exynos4-is and adds a new
>> media device and fimc-is device drivers for exynos5.
>> The media device supports asynchronos subdev registration for the
>> fimc-is sensors and is based on the patch series from Sylwester
>> for exynos4-is [1].
>>
>> [1]http://www.mail-archive.com/linux-media@vger.kernel.org/msg64653.html
>>
>> Changes from v2
>> ---------------
>> - Added exynos5 media device driver from Shaik to this series
>> - Added ISP pipeline support in media device driver
>> - Based on Sylwester's latest exynos4-is development
>> - Asynchronos registration of sensor subdevs
>> - Made independent IS-sensor support
>> - Add s5k4e5 sensor driver
>> - Addressed review comments from Sylwester, Hans, Andrzej, Sachin
>
>
> This is starting to look pretty good to me, I hope we can merge this
> patch set for v3.12. Let use coming two weeks for one or two review/
> corrections round.

Sure. I will address the review comments quickly and send v4 version.

> In the meantime I've done numerous fixes to the patch series [1],
> especially the clock provider code was pretty buggy on the clean up
> paths. Let's go through the patches and see what can be improved yet.
>

Ok. Is the updated version available in your git repository
git://linuxtv.org/snawrocki/samsung.git?

Regards
Arun
