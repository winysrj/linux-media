Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15228 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaJFJew (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Oct 2014 05:34:52 -0400
Message-id: <54326223.3050201@samsung.com>
Date: Mon, 06 Oct 2014 11:34:27 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: Paul Bolle <pebolle@tiscali.nl>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Valentin Rothberg <valentinrothberg@gmail.com>
Subject: Re: [PATCH 3/4] [media] Remove optional dependency on PLAT_S5P
References: <1412586626.4054.42.camel@x220> <4788945.SoI4OqN9Zu@wuerfel>
In-reply-to: <4788945.SoI4OqN9Zu@wuerfel>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/10/14 11:26, Arnd Bergmann wrote:
> On Monday 06 October 2014 11:10:26 Paul Bolle wrote:
>>  config VIDEO_SAMSUNG_S5P_TV
>>         bool "Samsung TV driver for S5P platform"
>>         depends on PM_RUNTIME
>> -       depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
>> +       depends on ARCH_EXYNOS || COMPILE_TEST
>>         default n
>>         ---help---
>>           Say Y here to enable selecting the TV output devices for
>>
> 
> I wonder if it should now allow being built for ARCH_S5PV210.
> Maybe it was a mistake to remove the PLAT_S5P symbol without changing
> the use here?
> 
> Does S5PV210 have this device?

Yes, it does. Indeed, in all patches in this series we should
have replaced PLAT_S5P with ARCH_S5PV210.

--
Thanks,
Sylwester
