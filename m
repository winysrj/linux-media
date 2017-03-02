Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57347 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752503AbdCBMJQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 07:09:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: vsp1: Fix struct vsp1_drm documentation
Date: Thu, 02 Mar 2017 14:08:43 +0200
Message-ID: <3893724.eCjZMHPHA5@avalon>
In-Reply-To: <1488449542-28990-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1488449542-28990-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Thursday 02 Mar 2017 10:12:22 Kieran Bingham wrote:
> The struct vsp1_drm references a member 'planes' which doesn't exist.
> Correctly identify this documentation against the 'inputs'
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree, thank you.

> ---
>  drivers/media/platform/vsp1/vsp1_drm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.h
> b/drivers/media/platform/vsp1/vsp1_drm.h index 9e28ab9254ba..c8d2f88fc483
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.h
> +++ b/drivers/media/platform/vsp1/vsp1_drm.h
> @@ -21,7 +21,7 @@
>   * vsp1_drm - State for the API exposed to the DRM driver
>   * @pipe: the VSP1 pipeline used for display
>   * @num_inputs: number of active pipeline inputs at the beginning of an
> update - * @planes: source crop rectangle, destination compose rectangle
> and z-order + * @inputs: source crop rectangle, destination compose
> rectangle and z-order *	position for every input
>   */
>  struct vsp1_drm {

-- 
Regards,

Laurent Pinchart
