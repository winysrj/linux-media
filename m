Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29019 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbbIPI4W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2015 04:56:22 -0400
Message-id: <55F92E8C.3020701@samsung.com>
Date: Wed, 16 Sep 2015 10:55:40 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 4/7] [media] exynos4-is: use monotonic timestamps as
 advertized
References: <1442332148-488079-1-git-send-email-arnd@arndb.de>
 <1442332148-488079-5-git-send-email-arnd@arndb.de>
In-reply-to: <1442332148-488079-5-git-send-email-arnd@arndb.de>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/09/15 17:49, Arnd Bergmann wrote:
> The exynos4 fimc capture driver claims to use monotonic
> timestamps but calls ktime_get_real_ts(). This is both
> an incorrect API use, and a bad idea because of the y2038
> problem and the fact that the wall clock time is not reliable
> for timestamps across suspend or settimeofday().
> 
> This changes the driver to use the normal v4l2_get_timestamp()
> function like all other drivers.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
