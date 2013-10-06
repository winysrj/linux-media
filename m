Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:51244 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab3JFAJn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Oct 2013 20:09:43 -0400
Message-ID: <5250AA3F.6030701@samsung.com>
Date: Sun, 06 Oct 2013 09:09:35 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-fbdev@vger.kernel.org, kgene.kim@samsung.com,
	gregkh@linuxfoundation.org, jg1.han@samsung.com,
	dh09.lee@samsung.com, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, tomi.valkeinen@ti.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH V5 1/5] ARM: dts: Add MIPI PHY node to exynos4.dtsi
References: <1380396467-29278-1-git-send-email-s.nawrocki@samsung.com> <1380396467-29278-2-git-send-email-s.nawrocki@samsung.com> <524A5D68.8080904@ti.com> <524B3B04.3000704@gmail.com> <524AE9BC.6060103@ti.com>
In-Reply-To: <524AE9BC.6060103@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 10/02/13 00:26, Kishon Vijay Abraham I wrote:
> On Wednesday 02 October 2013 02:43 AM, Sylwester Nawrocki wrote:
>> On 10/01/2013 07:28 AM, Kishon Vijay Abraham I wrote:
>>> On Sunday 29 September 2013 12:57 AM, Sylwester Nawrocki wrote:
>>>>>   Add PHY provider node for the MIPI CSIS and MIPI DSIM PHYs.
>>>>>
>>>>>   Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>>>>>   Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>>>   Acked-by: Felipe Balbi<balbi@ti.com>
>>>
>>> Can this patch be taken through exynos dt tree?
>>
>> Yes, that makes more sense indeed. Kukjin, would you mind taking
>> this patch to your tree ?
>
Sure. Applied this whole series.

> FWIW
> Acked-by: Kishon Vijay Abraham I<kishon@ti.com>
>>

Thanks,
Kukjin
