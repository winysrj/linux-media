Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33643 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaEHQJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 12:09:51 -0400
Message-id: <536BAC34.2020904@samsung.com>
Date: Thu, 08 May 2014 18:09:24 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 1/5] ARM: S5PV210: Remove camera support from mach-goni.c
References: <1397583272-28295-1-git-send-email-s.nawrocki@samsung.com>
 <1397583272-28295-2-git-send-email-s.nawrocki@samsung.com>
 <081001cf65cc$cbef8700$63ce9500$@samsung.com>
In-reply-to: <081001cf65cc$cbef8700$63ce9500$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/14 08:07, Kukjin Kim wrote:
> Sylwester Nawrocki wrote:
>> > 
>> > S5PV210 is going to get DT support, so we can remove the camera
>> > bits from the only board using camera on S5PV210. This allows to
>> > clean the exynos4-is driver by dropping code for non-dt platforms.
>> > This patch can be dropped if a patch removing the whole board
>> > file is applied first.
>> > 
>> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> Hi Sylwester,
> 
> Cleanup is always welcome ;-)
> 
> I think, when this series is ready for mainline, this will be handled in
> media tree. So,
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Hi Kukjin,

Thank you, patch queued up for the media tree!

--
Regards,
Sylwester
