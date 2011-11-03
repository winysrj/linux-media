Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab1KCSjS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Nov 2011 14:39:18 -0400
Message-ID: <4EB2DFD1.1000207@redhat.com>
Date: Thu, 03 Nov 2011 16:39:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "'Kamil Debski'" <k.debski@samsung.com>, kyungmin.park@samsung.com
CC: jtp.park@samsung.com, linux-media@vger.kernel.org,
	"'Marek Szyprowski'" <m.szyprowski@samsung.com>,
	kgene.kim@samsung.com
Subject: Re: [PATCH] MAINTAINERS: add a maintainer for s5p-mfc driver
References: <007601cc8a26$3809f9f0$a81dedd0$%park@samsung.com>
In-Reply-To: <007601cc8a26$3809f9f0$a81dedd0$%park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-10-2011 01:03, Jeongtae Park escreveu:
> Add a maintainer for s5p-mfc driver.
> 
> Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Kamil Debski <k.debski@samsung.com>
> ---
>  MAINTAINERS |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5e207a8..ef16770 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1087,6 +1087,7 @@ F:        drivers/media/video/s5p-fimc/
>  ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC) SUPPORT
>  M:     Kyungmin Park <kyungmin.park@samsung.com>
>  M:     Kamil Debski <k.debski@samsung.com>
> +M:     Jeongtae Park <jtp.park@samsung.com>
>  L:     linux-arm-kernel@lists.infradead.org
>  L:     linux-media@vger.kernel.org
>  S:     Maintained


Hmm... Kamil and Kyungmin are the current maintainers... I need
their acks in order to apply this patch.

Regards,
Mauro.

