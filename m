Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60726 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752928AbdCPQnP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Mar 2017 12:43:15 -0400
Subject: Re: [PATCH v3 5/6] drm: bridge: dw-hdmi: Add Documentation on
 supported input formats
To: Neil Armstrong <narmstrong@baylibre.com>
References: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
 <1488904944-14285-6-git-send-email-narmstrong@baylibre.com>
Cc: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org
From: Archit Taneja <architt@codeaurora.org>
Message-ID: <b17af5d6-bf7b-f5f5-e96b-11a6c569b117@codeaurora.org>
Date: Thu, 16 Mar 2017 22:13:04 +0530
MIME-Version: 1.0
In-Reply-To: <1488904944-14285-6-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 3/7/2017 10:12 PM, Neil Armstrong wrote:
> This patch adds a new DRM documentation entry and links to the input
> format table added in the dw_hdmi header.
>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  Documentation/gpu/dw-hdmi.rst | 15 +++++++++++++++
>  Documentation/gpu/index.rst   |  1 +

Maybe we create a sub-directory for bridges here? Maybe
a hierarchy similar to tinydrm's?

Looks good otherwise.

Archit

>  2 files changed, 16 insertions(+)
>  create mode 100644 Documentation/gpu/dw-hdmi.rst
>
> diff --git a/Documentation/gpu/dw-hdmi.rst b/Documentation/gpu/dw-hdmi.rst
> new file mode 100644
> index 0000000..486faad
> --- /dev/null
> +++ b/Documentation/gpu/dw-hdmi.rst
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
> index e998ee0..0725449 100644
> --- a/Documentation/gpu/index.rst
> +++ b/Documentation/gpu/index.rst
> @@ -10,6 +10,7 @@ Linux GPU Driver Developer's Guide
>     drm-kms
>     drm-kms-helpers
>     drm-uapi
> +   dw-hdmi
>     i915
>     tinydrm
>     vc4
>

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
