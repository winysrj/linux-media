Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27204 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3BANpv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 08:45:51 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHJ00LV5NIE0860@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Feb 2013 13:45:49 +0000 (GMT)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MHJ000D6NKDCF50@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Feb 2013 13:45:49 +0000 (GMT)
Message-id: <510BC70C.3030901@samsung.com>
Date: Fri, 01 Feb 2013 14:45:48 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH RFC] media: Rename media_entity_remote_source to
 media_entity_remote_pad
References: <1358843095-4839-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1358843095-4839-1-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Thanks for the patch.

On 01/22/2013 09:24 AM, Andrzej Hajda wrote:
> Function media_entity_remote_source actually returns the remote pad to
> the given one, regardless if this is the source or the sink pad.
> Name media_entity_remote_pad is more adequate for this function.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  Documentation/media-framework.txt                |    2 +-
>  drivers/media/media-entity.c                     |   13 ++++++-------
>  drivers/media/platform/omap3isp/isp.c            |    6 +++---
>  drivers/media/platform/omap3isp/ispccdc.c        |    2 +-
>  drivers/media/platform/omap3isp/ispccp2.c        |    2 +-
>  drivers/media/platform/omap3isp/ispcsi2.c        |    2 +-
>  drivers/media/platform/omap3isp/ispvideo.c       |    6 +++---
>  drivers/media/platform/s3c-camif/camif-capture.c |    2 +-
>  drivers/media/platform/s5p-fimc/fimc-capture.c   |    8 ++++----
>  drivers/media/platform/s5p-fimc/fimc-lite.c      |    4 ++--
>  drivers/media/platform/s5p-fimc/fimc-mdevice.c   |    2 +-
>  drivers/staging/media/davinci_vpfe/vpfe_video.c  |   12 ++++++------
>  include/media/media-entity.h                     |    2 +-
>  13 files changed, 31 insertions(+), 32 deletions(-)

Regards,
Sylwester
