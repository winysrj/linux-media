Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12237 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab1DFIO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 04:14:58 -0400
Date: Wed, 06 Apr 2011 10:14:53 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 5/7] v4l: s5p-fimc: add pm_runtime support
In-reply-to: <007c01cbf3f2$c6e7b420$54b71c60$%han@samsung.com>
To: Jonghun Han <jonghun.han@samsung.com>
Cc: 'Marek Szyprowski' <m.szyprowski@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Andrzej Pietrasiwiecz' <andrzej.p@samsung.com>,
	'Arnd Bergmann' <arnd@arndb.de>,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	=?EUC-KR?B?J7DtwOe47Sc=?= <jemings@samsung.com>
Message-id: <4D9C20FD.2010608@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=EUC-KR
Content-transfer-encoding: 7BIT
References: <1302012410-17984-1-git-send-email-m.szyprowski@samsung.com>
 <1302012410-17984-6-git-send-email-m.szyprowski@samsung.com>
 <007c01cbf3f2$c6e7b420$54b71c60$%han@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jonghun,

On 04/06/2011 02:37 AM, Jonghun Han wrote:
...
> 
> Hi Marek,
> 
> runtime_pm is used to minimize current.
> In my opinion, the followings will be better.
> 1. Adds pm_runtime_get_sync before running of the first job.
>    IMO, dma_run callback function is the best place for calling in case of
> M2M.
Yeah, sounds reasonable.

> 2. And then in the ISR, call pm_runtime_put_sync in the ISR bottom-half if
> there is no remained job.

So you are switching the clocks off in the interrupt context, I'm not sure
whether this is a good idea. Perhaps we could just use pm_runtime_put()
in this case?

> 
> I had already implemented and tested.
> But it remained code cleanup. I hope I can post it on the next week.

The purpose of Marek's simple patch was to just enable the FIMC IP
to illustrate the IOMMU driver's operation. I have prepared more complete
patch for runtime PM and system suspend/resume in the mem-to-mem driver
as well, but I want to consolidate this with the video capture driver before
sending upstream.
Anyway I'm looking forward to see your patch so we can work out some common
version. Also I've got a few patches for this rc period which I intend to post
this week.

Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
