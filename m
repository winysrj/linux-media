Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55212 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751144AbdHCMYl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Aug 2017 08:24:41 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v3 2/4] drm: rcar-du: Wait for flip completion instead of
 vblank in commit tail
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <20170729210855.9187-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170729210855.9187-3-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <765d5eb9-c70c-6a3f-3d68-35f4c95c7805@ideasonboard.com>
Date: Thu, 3 Aug 2017 13:24:36 +0100
MIME-Version: 1.0
In-Reply-To: <20170729210855.9187-3-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 29/07/17 22:08, Laurent Pinchart wrote:
> Page flips can take more than one vertical blanking to complete if
> arming the page flips races with the vertical blanking interrupt.
> Waiting for one vblank to complete the atomic commit in the commit tail
> handler is thus incorrect, and can lead to framebuffers being released
> while still being scanned out.
> 
> Fix this by waiting for flip completion instead, using the
> drm_atomic_helper_wait_for_flip_done() helper.
> 
> Fixes: 0d230422d256 ("drm: rcar-du: Register a completion callback with VSP1")
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/gpu/drm/rcar-du/rcar_du_kms.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> index b91257dee98f..221e22922396 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> @@ -262,7 +262,7 @@ static void rcar_du_atomic_commit_tail(struct drm_atomic_state *old_state)
>  	drm_atomic_helper_commit_modeset_enables(dev, old_state);
>  
>  	drm_atomic_helper_commit_hw_done(old_state);
> -	drm_atomic_helper_wait_for_vblanks(dev, old_state);
> +	drm_atomic_helper_wait_for_flip_done(dev, old_state);

Ahh yes, that makes sense!

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


>  	drm_atomic_helper_cleanup_planes(dev, old_state);
>  }
> 
