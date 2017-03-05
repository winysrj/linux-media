Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:34610 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750904AbdCEQ57 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Mar 2017 11:57:59 -0500
Received: by mail-lf0-f52.google.com with SMTP id k202so63712935lfe.1
        for <linux-media@vger.kernel.org>; Sun, 05 Mar 2017 08:57:58 -0800 (PST)
Subject: Re: [PATCH v3 3/3] drm: rcar-du: Register a completion callback with
 VSP1
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        laurent.pinchart@ideasonboard.com
References: <cover.8e2f9686131cb2299b859f056e902b4208061a4e.1488729419.git-series.kieran.bingham+renesas@ideasonboard.com>
 <591c0ba30211d53613a456d51f2bb523e6ef5e06.1488729419.git-series.kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <d89dac27-b98b-1074-3677-bec3f29675e0@cogentembedded.com>
Date: Sun, 5 Mar 2017 19:57:54 +0300
MIME-Version: 1.0
In-Reply-To: <591c0ba30211d53613a456d51f2bb523e6ef5e06.1488729419.git-series.kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 03/05/2017 07:00 PM, Kieran Bingham wrote:

> Currently we process page flip events on every display interrupt,
> however this does not take into consideration the processing time needed
> by the VSP1 utilised in the pipeline.
>
> Register a callback with the VSP driver to obtain completion events, and
> track them so that we only perform page flips when the full display
> pipeline has completed for the frame.
>
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
[...]
>  #endif /* __RCAR_DU_CRTC_H__ */
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> index b0ff304ce3dc..cbb6f54c99ef 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> @@ -28,6 +28,13 @@
>  #include "rcar_du_kms.h"
>  #include "rcar_du_vsp.h"
>
> +static void rcar_du_vsp_complete(void *private)
> +{
> +	struct rcar_du_crtc *crtc = (struct rcar_du_crtc *)private;

    No need for explicit cast.

> +
> +	rcar_du_crtc_finish_page_flip(crtc);
> +}
> +
>  void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
>  {
>  	const struct drm_display_mode *mode = &crtc->crtc.state->adjusted_mode;
[...]

MBR, Sergei
