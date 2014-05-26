Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32499 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaEZJET (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 05:04:19 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N66000BDBV0K050@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 26 May 2014 10:04:12 +0100 (BST)
Message-id: <5383038C.2060909@samsung.com>
Date: Mon, 26 May 2014 11:04:12 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] m5mols: Replace missing header
References: <1401047695-2046-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1401047695-2046-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 25/05/14 21:54, Laurent Pinchart wrote:
> The include/media/s5p_fimc.h header has been removed in commit
> 49b2f4c56fbf70ca693d6df1c491f0566d516aea ("exynos4-is: Remove support
> for non-dt platforms"). This broke compilation of the m5mols driver.
> 
> Include the include/media/exynos-fimc.h header instead, which contains
> the S5P_FIMC_TX_END_NOTIFY definition required by the driver.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks for the fix. I though about adding to this patch:

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

But it seems the patch is already in Mauro's tree.

> ---
>  drivers/media/i2c/m5mols/m5mols_capture.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> (Resending to linux-media has the original patch seems not to have made it to
> the list for an unknown reason.)
> 
> This is a regression in Mauro's latest master branch.
> 
> diff --git a/drivers/media/i2c/m5mols/m5mols_capture.c b/drivers/media/i2c/m5mols/m5mols_capture.c
> index ab34cce..1a03d02 100644
> --- a/drivers/media/i2c/m5mols/m5mols_capture.c
> +++ b/drivers/media/i2c/m5mols/m5mols_capture.c
> @@ -26,7 +26,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-subdev.h>
>  #include <media/m5mols.h>
> -#include <media/s5p_fimc.h>
> +#include <media/exynos-fimc.h>
>  
>  #include "m5mols.h"
>  #include "m5mols_reg.h"

-- 
Regards,
Sylwester
