Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39330 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752518AbdDDJkp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 05:40:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org,
        Jose.Abreu@synopsys.com, kieran.bingham@ideasonboard.com,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v6 5/6] drm: bridge: dw-hdmi: Add Documentation on supported input formats
Date: Tue, 04 Apr 2017 12:41:29 +0300
Message-ID: <6024220.Z10L9xYqQj@avalon>
In-Reply-To: <1491230558-10804-6-git-send-email-narmstrong@baylibre.com>
References: <1491230558-10804-1-git-send-email-narmstrong@baylibre.com> <1491230558-10804-6-git-send-email-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

Thank you for the patch.

On Monday 03 Apr 2017 16:42:37 Neil Armstrong wrote:
> This patch adds a new DRM documentation entry and links to the input
> format table added in the dw_hdmi header.
> 
> Reviewed-by: Archit Taneja <architt@codeaurora.org>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/gpu/bridge/dw-hdmi.rst | 15 +++++++++++++++
>  Documentation/gpu/index.rst          |  1 +
>  2 files changed, 16 insertions(+)
>  create mode 100644 Documentation/gpu/bridge/dw-hdmi.rst
> 
> diff --git a/Documentation/gpu/bridge/dw-hdmi.rst
> b/Documentation/gpu/bridge/dw-hdmi.rst new file mode 100644
> index 0000000..486faad
> --- /dev/null
> +++ b/Documentation/gpu/bridge/dw-hdmi.rst
> @@ -0,0 +1,15 @@
> +=======================================================
> + drm/bridge/dw-hdmi Synopsys DesignWare HDMI Controller
> +=======================================================
> +
> +Synopsys DesignWare HDMI Controller
> +===================================
> +
> +This section covers everything related to the Synopsys DesignWare HDMI
> +Controller implemented as a DRM bridge.
> +
> +Supported Input Formats and Encodings
> +-------------------------------------
> +
> +.. kernel-doc:: include/drm/bridge/dw_hdmi.h
> +   :doc: Supported input formats and encodings
> diff --git a/Documentation/gpu/index.rst b/Documentation/gpu/index.rst
> index e998ee0..d81c6ff 100644
> --- a/Documentation/gpu/index.rst
> +++ b/Documentation/gpu/index.rst
> @@ -15,6 +15,7 @@ Linux GPU Driver Developer's Guide
>     vc4
>     vga-switcheroo
>     vgaarbiter
> +   bridge/dw-hdmi
>     todo
> 
>  .. only::  subproject and html

-- 
Regards,

Laurent Pinchart
