Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19763 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaIYKkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 06:40:10 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Message-id: <5423F0FA.7030404@samsung.com>
Date: Thu, 25 Sep 2014 12:39:54 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] [media] exynos4-is: fix some warnings when compiling on
 arm64
References: <416b6af26812eb995333c5bd5a9263775b8c4699.1411607687.git.mchehab@osg.samsung.com>
In-reply-to: <416b6af26812eb995333c5bd5a9263775b8c4699.1411607687.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/09/14 03:24, Mauro Carvalho Chehab wrote:
> Got those warnings when compiling with gcc 4.9.1 for arm64:
> 
> drivers/media/platform/exynos4-is/fimc-isp-video.c: In function ‘isp_video_capture_buffer_queue’:
> drivers/media/platform/exynos4-is/fimc-isp-video.c:221:4: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 7 has type ‘dma_addr_t’ [-Wformat=]
>     isp_dbg(2, &video->ve.vdev,
[...]
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Thanks Mauro,

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

