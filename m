Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39318 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752202AbdDDJkJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 05:40:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org,
        mchehab@kernel.org, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com
Subject: Re: [PATCH v6 4/6] drm: bridge: dw-hdmi: Switch to V4L bus format and encodings
Date: Tue, 04 Apr 2017 12:40:54 +0300
Message-ID: <4948994.ktJJpZgFXr@avalon>
In-Reply-To: <1491230558-10804-5-git-send-email-narmstrong@baylibre.com>
References: <1491230558-10804-1-git-send-email-narmstrong@baylibre.com> <1491230558-10804-5-git-send-email-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

Thank you for the patch.

On Monday 03 Apr 2017 16:42:36 Neil Armstrong wrote:
> Some display pipelines can only provide non-RBG input pixels to the HDMI TX
> Controller, this patch takes the pixel format from the plat_data if
> provided.

The commit message doesn't seem to match the subject line.

> Reviewed-by: Jose Abreu <joabreu@synopsys.com>
> Reviewed-by: Archit Taneja <architt@codeaurora.org>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 326 +++++++++++++++++++--------
>  include/drm/bridge/dw_hdmi.h              |  63 ++++++
>  2 files changed, 294 insertions(+), 95 deletions(-)

[snip]

> diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
> index bcceee8..45c2c15 100644
> --- a/include/drm/bridge/dw_hdmi.h
> +++ b/include/drm/bridge/dw_hdmi.h
> @@ -14,6 +14,67 @@
>  
>  struct dw_hdmi;
>  
> +/**
> + * DOC: Supported input formats and encodings
> + *
> + * Depending on the Hardware configuration of the Controller IP, it
> supports
> + * a subset of the following input formats and encodings on it's internal
> + * 48bit bus.
> + *

s/it's/its/

[snip]

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
