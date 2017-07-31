Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:52301 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751046AbdGaQHX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 12:07:23 -0400
Subject: Re: [PATCH v4 2/6] [media] extended-controls.rst: add PorterDuff mode
 control
To: Jacob Chen <jacob-chen@iotwrt.com>,
        linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, nicolas@ndufresne.ca
References: <1501515182-26705-1-git-send-email-jacob-chen@iotwrt.com>
 <1501515182-26705-3-git-send-email-jacob-chen@iotwrt.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d5bc50d0-f468-f1b4-b52a-4f1c10d7d9af@xs4all.nl>
Date: Mon, 31 Jul 2017 18:07:17 +0200
MIME-Version: 1.0
In-Reply-To: <1501515182-26705-3-git-send-email-jacob-chen@iotwrt.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2017 05:32 PM, Jacob Chen wrote:
> PorterDuff mode control are used to determine
> how two images are combined.
> 
> Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
> ---
>  Documentation/media/uapi/v4l/extended-controls.rst | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> index abb1057..f9c93bb 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -3021,6 +3021,10 @@ Image Process Control IDs
>      The video deinterlacing mode (such as Bob, Weave, ...). The menu items are
>      driver specific and are documented in :ref:`v4l-drivers`.
>  
> +``V4L2_CID_PORTER_DUFF_MODE (menu)``
> +    The PorterDuff blend modes. PorterDuff is way to overlay, combine and
> +    trim images as if they were pieces of cardboard, device could use to
> +    determine how two images are combined.

A little rewrite:

    The PorterDuff blend modes. PorterDuff is a method to overlay, combine and
    trim images as if they were pieces of cardboard. The device uses this to
    determine how two images are combined.

Also add a link to the same android article that you pointed to in the header.

Regards,

	Hans

>  
>  .. _dv-controls:
>  
> 
