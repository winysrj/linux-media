Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61141 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab3AVLEU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 06:04:20 -0500
Message-id: <50FE722E.1030901@samsung.com>
Date: Tue, 22 Jan 2013 12:04:14 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Wolfram Sang <w.sang@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 14/33] media: Convert to devm_ioremap_resource()
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-15-git-send-email-thierry.reding@avionic-design.de>
In-reply-to: <1358762966-20791-15-git-send-email-thierry.reding@avionic-design.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/21/2013 11:09 AM, Thierry Reding wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/platform/exynos-gsc/gsc-core.c   |  8 +++-----
>  drivers/media/platform/mx2_emmaprp.c           |  6 +++---
>  drivers/media/platform/s3c-camif/camif-core.c  |  8 +++-----
>  drivers/media/platform/s5p-fimc/fimc-core.c    |  8 +++-----
>  drivers/media/platform/s5p-fimc/fimc-lite.c    |  8 +++-----
>  drivers/media/platform/s5p-fimc/mipi-csis.c    |  8 +++-----
>  drivers/media/platform/s5p-g2d/g2d.c           |  8 +++-----
>  drivers/media/platform/s5p-jpeg/jpeg-core.c    |  8 +++-----
>  drivers/media/platform/s5p-mfc/s5p_mfc.c       |  8 +++-----
>  drivers/media/platform/soc_camera/mx2_camera.c | 12 ++++++------
>  10 files changed, 33 insertions(+), 49 deletions(-)

That's a nice cleanup. For exynos-gsc, s3c-camif, s5p-* drivers

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--

Thanks,
Sylwester
