Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:55089 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753087AbeBIN6Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 08:58:25 -0500
Received: by mail-wm0-f67.google.com with SMTP id i186so15534284wmi.4
        for <linux-media@vger.kernel.org>; Fri, 09 Feb 2018 05:58:24 -0800 (PST)
Subject: Re: [PATCH v2 9/9] [media] Add documentation for YUV420 bus format
To: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        michal.simek@xilinx.com, hyun.kwon@xilinx.com
Cc: Satish Kumar Nagireddy <satishna@xilinx.com>
References: <1518139327-21947-1-git-send-email-satishna@xilinx.com>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <97e51a9a-04da-e441-25ea-945acc249f80@gmail.com>
Date: Fri, 9 Feb 2018 13:58:22 +0000
MIME-Version: 1.0
In-Reply-To: <1518139327-21947-1-git-send-email-satishna@xilinx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/02/18 01:22, Satish Kumar Nagireddy wrote:
> The code is MEDIA_BUS_FMT_VYYUYY8_1X24
> 
> Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
> ---
>   Documentation/media/uapi/v4l/subdev-formats.rst | 34 +++++++++++++++++++++++++
>   1 file changed, 34 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
> index b1eea44..a4d7d87 100644
> --- a/Documentation/media/uapi/v4l/subdev-formats.rst
> +++ b/Documentation/media/uapi/v4l/subdev-formats.rst
> @@ -7283,6 +7283,40 @@ The following table list existing packed 48bit wide YUV formats.
>         - y\ :sub:`1`
>         - y\ :sub:`0`
> 
> +      - MEDIA_BUS_FMT_VYYUYY8_1X24
> +      - 0x202c
> +      -
> +      -
> +      -
> +      -
> +      -
> +      -
> +      -
> +      -
> +      - v\ :sub:`7`
> +      - v\ :sub:`6`
> +      - v\ :sub:`5`
> +      - v\ :sub:`4`
> +      - v\ :sub:`3`
> +      - v\ :sub:`2`
> +      - v\ :sub:`1`
> +      - v\ :sub:`0`
> +      - u\ :sub:`7`
> +      - u\ :sub:`6`
> +      - u\ :sub:`5`
> +      - u\ :sub:`4`
> +      - u\ :sub:`3`
> +      - u\ :sub:`2`
> +      - u\ :sub:`1`
> +      - u\ :sub:`0`
> +      - y\ :sub:`7`
> +      - y\ :sub:`6`
> +      - y\ :sub:`5`
> +      - y\ :sub:`4`
> +      - y\ :sub:`3`
> +      - y\ :sub:`2`
> +      - y\ :sub:`1`
> +      - y\ :sub:`0`

If this bus format name doesn't really describe how the pixels are sent 
on the bus, maybe the documentation should? Is this for something like 
MIPI CSI-2 YUV420 non-legacy modes where the bus format alternates on 
odd/even lines?

Regards,
IanJ

> 
>   .. raw:: latex
> 
> --
> 2.7.4
> 
> This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
> 
