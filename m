Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:47771 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab1HaIgH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 04:36:07 -0400
Received: from epcpsbgm2.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LQS00JKQAK3EFP0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Aug 2011 17:36:03 +0900 (KST)
Received: from jtppark (12-23-121-105.csky.net [12.23.121.105])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LQS00I00AK3W8@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 31 Aug 2011 17:36:03 +0900 (KST)
Date: Wed, 31 Aug 2011 17:35:58 +0900
From: Jeongtae Park <jtp.park@samsung.com>
Subject: RE: [PATCH] MAINTAINERS: add entries for s5p-mfc and s5p-tv drivers
In-reply-to: <1312968749-15988-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Cc: kgene.kim@samsung.com, 'Kamil Debski' <k.debski@samsung.com>,
	younglak1004.kim@samsung.com, kyungmin.park@samsung.com
Reply-to: jtp.park@samsung.com
Message-id: <005a01cc67b9$02315560$06940020$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1312968749-15988-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Authors of the code definitely should be maintainers.
I think everyone will agree.

Best Regards
/jtpark
> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Marek Szyprowski
> Sent: Wednesday, August 10, 2011 6:32 PM
> To: linux-media@vger.kernel.org
> Cc: Marek Szyprowski; Kyungmin Park; Kamil Debski; Tomasz Stanislawski
> Subject: [PATCH] MAINTAINERS: add entries for s5p-mfc and s5p-tv drivers
> 
> Both driver has been merged to v3.1-rc1, so add its authors as maintainers.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  MAINTAINERS |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 51d42fb..0618d9a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1084,6 +1084,24 @@ F:	arch/arm/plat-s5p/dev-fimc*
>  F:	arch/arm/plat-samsung/include/plat/*fimc*
>  F:	drivers/media/video/s5p-fimc/
> 
> +ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC) SUPPORT
> +M:	Kyungmin Park <kyungmin.park@samsung.com>
> +M:	Kamil Debski <k.debski@samsung.com>

M:	Jeongtae Park<jtp.park@samsung.com>

> +L:	linux-arm-kernel@lists.infradead.org
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	arch/arm/plat-s5p/dev-mfc.c
> +F:	drivers/media/video/s5p-mfc/
> +
> +ARM/SAMSUNG S5P SERIES TV SUBSYSTEM SUPPORT
> +M:	Kyungmin Park <kyungmin.park@samsung.com>
> +M:	Tomasz Stanislawski <t.stanislaws@samsung.com>
> +L:	linux-arm-kernel@lists.infradead.org
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	arch/arm/plat-s5p/dev-tv.c
> +F:	drivers/media/video/s5p-tv/
> +
>  ARM/SHMOBILE ARM ARCHITECTURE
>  M:	Paul Mundt <lethal@linux-sh.org>
>  M:	Magnus Damm <magnus.damm@gmail.com>
> --
> 1.7.1.569.g6f426
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

