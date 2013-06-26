Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1409 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3FZHQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 03:16:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Arun Kumar K <arun.kk@samsung.com>
Subject: Re: [RFC v2 06/10] exynos5-fimc-is: Adds isp subdev
Date: Wed, 26 Jun 2013 09:15:54 +0200
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	arunkk.samsung@gmail.com
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com> <1370005408-10853-7-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1370005408-10853-7-git-send-email-arun.kk@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306260915.54258.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri May 31 2013 15:03:24 Arun Kumar K wrote:
> fimc-is driver takes video data input from the ISP video node
> which is added in this patch. This node accepts Bayer input
> buffers which is given from the IS sensors.
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
> ---
>  drivers/media/platform/exynos5-is/fimc-is-isp.c |  438 +++++++++++++++++++++++
>  drivers/media/platform/exynos5-is/fimc-is-isp.h |   89 +++++
>  2 files changed, 527 insertions(+)
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.c
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.h
> 

The same comments I made for the scaler subdev apply here as well.

Regards,

	Hans
