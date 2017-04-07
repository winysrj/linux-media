Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35505 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752879AbdDGKAn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 06:00:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 6/8] v4l: media/drv-intf/soc_mediabus.h: include dependent header file
Date: Fri, 07 Apr 2017 13:01:29 +0300
Message-ID: <2155093.Y2052RbRLf@avalon>
In-Reply-To: <1491484330-12040-7-git-send-email-sakari.ailus@linux.intel.com>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com> <1491484330-12040-7-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Thursday 06 Apr 2017 16:12:08 Sakari Ailus wrote:
> media/drv-intf/soc_mediabus.h does depend on struct v4l2_mbus_config which
> is defined in media/v4l2-mediabus.h. Include it.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Was this provided indirectly before, through v4l2-of.h perhaps ? If so, 
shouldn't this patch be moved before 5/8 ? Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  include/media/drv-intf/soc_mediabus.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/media/drv-intf/soc_mediabus.h
> b/include/media/drv-intf/soc_mediabus.h index 2ff7737..0449788 100644
> --- a/include/media/drv-intf/soc_mediabus.h
> +++ b/include/media/drv-intf/soc_mediabus.h
> @@ -14,6 +14,8 @@
>  #include <linux/videodev2.h>
>  #include <linux/v4l2-mediabus.h>
> 
> +#include <media/v4l2-mediabus.h>
> +
>  /**
>   * enum soc_mbus_packing - data packing types on the media-bus
>   * @SOC_MBUS_PACKING_NONE:	no packing, bit-for-bit transfer to RAM, one

-- 
Regards,

Laurent Pinchart
