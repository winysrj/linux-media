Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42372 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab3KHWRi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Nov 2013 17:17:38 -0500
Message-ID: <527D62FC.3010001@gmail.com>
Date: Fri, 08 Nov 2013 23:17:32 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	kernel-janitors@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [patch] [media] exynos4-is: cleanup a define
References: <20131108095224.GJ27977@elgon.mountain>
In-Reply-To: <20131108095224.GJ27977@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


(dropping some unrelated e-mail addresses from Cc)

On 11/08/2013 10:52 AM, Dan Carpenter wrote:
> This define is only used in s5pcsis_irq_handler():
>
> 	if ((status&  S5PCSIS_INTSRC_NON_IMAGE_DATA)&&  pktbuf->data) {
>
> The problem is that "status" is a 32 bit and (0xff<<  28) is larger than
> 32 bits and that sets off a static checker warning.  I consulted with
> Sylwester Nawrocki and the define should actually be (0xf<<  28).
>
> Signed-off-by: Dan Carpenter<dan.carpenter@oracle.com>

Thanks for the fix, patch added to my tree for v3.14.

> diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
> index 9fc2af6..31dfc50 100644
> --- a/drivers/media/platform/exynos4-is/mipi-csis.c
> +++ b/drivers/media/platform/exynos4-is/mipi-csis.c
> @@ -91,7 +91,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
>   #define S5PCSIS_INTSRC_ODD_BEFORE	(1<<  29)
>   #define S5PCSIS_INTSRC_ODD_AFTER	(1<<  28)
>   #define S5PCSIS_INTSRC_ODD		(0x3<<  28)
> -#define S5PCSIS_INTSRC_NON_IMAGE_DATA	(0xff<<  28)
> +#define S5PCSIS_INTSRC_NON_IMAGE_DATA	(0xf<<  28)
>   #define S5PCSIS_INTSRC_FRAME_START	(1<<  27)
>   #define S5PCSIS_INTSRC_FRAME_END	(1<<  26)
>   #define S5PCSIS_INTSRC_ERR_SOT_HS	(0xf<<  12)

--
Regards,
Sylwester
