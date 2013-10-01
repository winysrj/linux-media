Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56461 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab3JAON5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Oct 2013 10:13:57 -0400
Message-ID: <524B3B04.3000704@gmail.com>
Date: Tue, 01 Oct 2013 23:13:40 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
	kgene.kim@samsung.com, dh09.lee@samsung.com, jg1.han@samsung.com,
	tomi.valkeinen@ti.com, plagnioj@jcrosoft.com,
	linux-fbdev@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH V5 1/5] ARM: dts: Add MIPI PHY node to exynos4.dtsi
References: <1380396467-29278-1-git-send-email-s.nawrocki@samsung.com> <1380396467-29278-2-git-send-email-s.nawrocki@samsung.com> <524A5D68.8080904@ti.com>
In-Reply-To: <524A5D68.8080904@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/01/2013 07:28 AM, Kishon Vijay Abraham I wrote:
> On Sunday 29 September 2013 12:57 AM, Sylwester Nawrocki wrote:
>> >  Add PHY provider node for the MIPI CSIS and MIPI DSIM PHYs.
>> >
>> >  Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> >  Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> >  Acked-by: Felipe Balbi<balbi@ti.com>
>
> Can this patch be taken through exynos dt tree?

Yes, that makes more sense indeed. Kukjin, would you mind taking
this patch to your tree ?

Thanks,
Sylwester
