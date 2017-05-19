Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60089 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754291AbdESRnS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 13:43:18 -0400
Subject: NACK: [PATCH] [media] rainshadow-cec: ensure exit_loop is initialized
To: Arnd Bergmann <arnd@arndb.de>, Eric Anholt <eric@anholt.net>,
        David Airlie <airlied@linux.ie>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
References: <20170519173939.6489-1-colin.king@canonical.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <393f9ca7-3675-ee45-2bd3-378c10cb412e@canonical.com>
Date: Fri, 19 May 2017 18:43:15 +0100
MIME-Version: 1.0
In-Reply-To: <20170519173939.6489-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19/05/17 18:39, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> exit_loop is not being initialized, so it contains garbage. Ensure it is
> initialized to false.
> 
> Detected by CoverityScan, CID#1436409 ("Uninitialzed scalar variable")
> 
> Fixes: ea6a69defd3311 ("[media] rainshadow-cec: avoid -Wmaybe-uninitialized warning")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/gpu/drm/vc4/vc4_v3d.c                     | 2 +-
>  drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/vc4/vc4_v3d.c b/drivers/gpu/drm/vc4/vc4_v3d.c
> index c53afec34586..c42210203f6e 100644
> --- a/drivers/gpu/drm/vc4/vc4_v3d.c
> +++ b/drivers/gpu/drm/vc4/vc4_v3d.c
> @@ -218,7 +218,7 @@ int vc4_v3d_get_bin_slot(struct vc4_dev *vc4)
>   * overall CMA pool before they make scenes complicated enough to run
>   * out of bin space.
>   */
> -int
> +static int
>  vc4_allocate_bin_bo(struct drm_device *drm)
>  {
>  	struct vc4_dev *vc4 = to_vc4_dev(drm);
> diff --git a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
> index 8d3ca2c8b20f..ad468efc4399 100644
> --- a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
> +++ b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
> @@ -119,7 +119,7 @@ static void rain_irq_work_handler(struct work_struct *work)
>  
>  	while (true) {
>  		unsigned long flags;
> -		bool exit_loop;
> +		bool exit_loop = false;
>  		char data;
>  
>  		spin_lock_irqsave(&rain->buf_lock, flags);
> 
Sorry, got another fix included into that. I'll re-submit
