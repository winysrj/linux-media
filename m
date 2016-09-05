Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44369 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932174AbcIELtO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 07:49:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn
Subject: Re: [PATCH] staging: media: omap4iss: mark omap4iss_flush() static
Date: Mon, 05 Sep 2016 14:49:40 +0300
Message-ID: <1671412.XD9t8jCPcC@avalon>
In-Reply-To: <1472971301-4650-1-git-send-email-baoyou.xie@linaro.org>
References: <1472971301-4650-1-git-send-email-baoyou.xie@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Baoyou,

Thank you for the patch.

On Sunday 04 Sep 2016 14:41:41 Baoyou Xie wrote:
> We get 1 warning when building kernel with W=1:
> drivers/staging/media/omap4iss/iss.c:64:6: warning: no previous prototype
> for 'omap4iss_flush' [-Wmissing-prototypes]
> 
> In fact, this function is only used in the file in which it is
> declared and don't need a declaration, but can be made static.
> so this patch marks this function with 'static'.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/staging/media/omap4iss/iss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss.c
> b/drivers/staging/media/omap4iss/iss.c index 6ceb4eb..e27c7a9 100644
> --- a/drivers/staging/media/omap4iss/iss.c
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -61,7 +61,7 @@ static void iss_print_status(struct iss_device *iss)
>   * See this link for reference:
>   *   http://www.mail-archive.com/linux-omap@vger.kernel.org/msg08149.html
>   */
> -void omap4iss_flush(struct iss_device *iss)
> +static void omap4iss_flush(struct iss_device *iss)
>  {
>  	iss_reg_write(iss, OMAP4_ISS_MEM_TOP, ISS_HL_REVISION, 0);
>  	iss_reg_read(iss, OMAP4_ISS_MEM_TOP, ISS_HL_REVISION);

-- 
Regards,

Laurent Pinchart

