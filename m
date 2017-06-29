Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43722 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752796AbdF2OIA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 10:08:00 -0400
Subject: Re: [PATCH v1 2/2] drm: rcar-du: Repair vblank for DRM page flips
 using the VSP1
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, laurent.pinchart@ideasonboard.com
Cc: David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <cover.22236bc88adc598797b31ea82329ec99304fe34d.1498744799.git-series.kieran.bingham+renesas@ideasonboard.com>
 <1f52573cfb6e72b49af7a1071ffe136623fafc75.1498744799.git-series.kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <45eba5b6-d5a2-1007-1af5-2a076dd0630e@ideasonboard.com>
Date: Thu, 29 Jun 2017 15:07:55 +0100
MIME-Version: 1.0
In-Reply-To: <1f52573cfb6e72b49af7a1071ffe136623fafc75.1498744799.git-series.kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> @@ -658,10 +660,14 @@ static irqreturn_t rcar_du_crtc_irq(int irq, void *arg)
>  	rcar_du_crtc_write(rcrtc, DSRCR, status & DSRCR_MASK);
>  
>  	if (status & DSSR_FRM) {
> -		drm_crtc_handle_vblank(&rcrtc->crtc);
> -
> -		if (rcdu->info->gen < 3)
> +		/*
> +		 * Gen 3 vblank and page flips are handled through the VSP
> +		 * completion handler
> +		 */
> +		if (rcdu->info->gen < 3) {

Of course as is obvious immediately after hitting send, this check was supposed
to be removed now that the interrupt is not registered.

Sorry for the noise and pre-released patch!

--
Kieran
