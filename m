Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33125 "EHLO
	mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965442AbcHBMwG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2016 08:52:06 -0400
Date: Tue, 2 Aug 2016 09:51:18 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
To: Baole Ni <baolex.ni@intel.com>
Cc: mchehab@kernel.org, mchehab@infradead.org, mchehab@redhat.com,
	m.chehab@samsung.com, gregkh@linuxfoundation.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.kozlowski@samsung.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	amitoj1606@gmail.com, arnd@arndb.de, hverkuil@xs4all.nl,
	chuansheng.liu@intel.com
Subject: Re: [PATCH 0947/1285] Replace numeric parameter like 0444 with
 macro
Message-ID: <20160802095118.47dcc5a6@recife.lan>
In-Reply-To: <20160802120134.13166-1-baolex.ni@intel.com>
References: <20160802120134.13166-1-baolex.ni@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue,  2 Aug 2016 20:01:34 +0800
Baole Ni <baolex.ni@intel.com> escreveu:

> I find that the developers often just specified the numeric value
> when calling a macro which is defined with a parameter for access permission.
> As we know, these numeric value for access permission have had the corresponding macro,
> and that using macro can improve the robustness and readability of the code,
> thus, I suggest replacing the numeric parameter with the macro.

Gah!

A patch series with 1285 patches with identical subject!

Please don't ever do something like that. My inbox is not trash!

Instead, please group the changes per subsystem, and use different
names for each patch. Makes easier for people to review.

also, you need to send the patches to the subsystem mainatiner, and
not adding a random list of people like this:

To: gregkh@linuxfoundation.org, maurochehab@gmail.com, mchehab@infradead.org, mchehab@redhat.com, m.chehab@samsung.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, k.kozlowski@samsung.com

Btw, use *just* the more recent email of the maintainer, instead of
spamming trash to all our emails (even to the ones that we don't use
anymore!

I'll just send all those things to /dev/null until you fix your
email sending process.

Regards,
Mauro

> 
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Baole Ni <baolex.ni@intel.com>
> ---
>  drivers/staging/media/omap1/omap1_camera.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/omap1/omap1_camera.c b/drivers/staging/media/omap1/omap1_camera.c
> index 54b8dd2..6e125dc 100644
> --- a/drivers/staging/media/omap1/omap1_camera.c
> +++ b/drivers/staging/media/omap1/omap1_camera.c
> @@ -1692,7 +1692,7 @@ static struct platform_driver omap1_cam_driver = {
>  
>  module_platform_driver(omap1_cam_driver);
>  
> -module_param(sg_mode, bool, 0644);
> +module_param(sg_mode, bool, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
>  MODULE_PARM_DESC(sg_mode, "videobuf mode, 0: dma-contig (default), 1: dma-sg");
>  
>  MODULE_DESCRIPTION("OMAP1 Camera Interface driver");
