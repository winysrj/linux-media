Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0047.outbound.protection.outlook.com ([104.47.36.47]:59392
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755771AbeBPRAU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Feb 2018 12:00:20 -0500
Date: Fri, 16 Feb 2018 09:00:15 -0800
From: Hyun Kwon <hyun.kwon@xilinx.com>
To: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        Hyun Kwon <hyunk@xilinx.com>,
        Satish Kumar Nagireddy <SATISHNA@xilinx.com>
Subject: Re: [PATCH v3 5/9] [media] Add documentation for YUV420 bus format
Message-ID: <20180216170015.GB9665@smtp.xilinx.com>
References: <1518676948-19560-1-git-send-email-satishna@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1518676948-19560-1-git-send-email-satishna@xilinx.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Satish,

Thanks for the patch.

On Wed, 2018-02-14 at 22:42:28 -0800, Satish Kumar Nagireddy wrote:
> The code is MEDIA_BUS_FMT_VYYUYY8_1X24
> 
> Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
> ---
>  Documentation/media/uapi/v4l/subdev-formats.rst | 34 +++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
> index b1eea44..afff6d5 100644
> --- a/Documentation/media/uapi/v4l/subdev-formats.rst
> +++ b/Documentation/media/uapi/v4l/subdev-formats.rst
> @@ -7283,6 +7283,40 @@ The following table list existing packed 48bit wide YUV formats.
>        - y\ :sub:`1`
>        - y\ :sub:`0`
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
> +      - v\ :sub:`3`
> +      - v\ :sub:`2`
> +      - v\ :sub:`1`
> +      - v\ :sub:`0`
> +      - y\ :sub:`7`
> +      - y\ :sub:`6`
> +      - y\ :sub:`5`
> +      - y\ :sub:`4`
> +      - y\ :sub:`3`
> +      - y\ :sub:`2`
> +      - y\ :sub:`1`
> +      - y\ :sub:`0`
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

This is under 48bit yub bus format section. Better to be grouped with
other similar formats, ex 24bit yuv bus formats.

Then this can be squashed into the patch where the bus format is added.

Thanks,
-hyun

>  
>  .. raw:: latex
>  
> -- 
> 2.7.4
> 
