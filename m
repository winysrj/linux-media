Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:36949 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2BPTqU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 14:46:20 -0500
Date: Thu, 16 Feb 2012 21:46:15 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 1/6] V4L: Add V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 media
 bus format
Message-ID: <20120216194615.GF7784@valkosipuli.localdomain>
References: <1329416639-19454-1-git-send-email-s.nawrocki@samsung.com>
 <1329416639-19454-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329416639-19454-2-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, Feb 16, 2012 at 07:23:54PM +0100, Sylwester Nawrocki wrote:
> This patch adds media bus pixel code for the interleaved JPEG/YUYV image
> format used by S5C73MX Samsung cameras. The interleaved image data is
> transferred on MIPI-CSI2 bus as User Defined Byte-based Data.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  include/linux/v4l2-mediabus.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
> index 5ea7f75..c2f0e4e 100644
> --- a/include/linux/v4l2-mediabus.h
> +++ b/include/linux/v4l2-mediabus.h
> @@ -92,6 +92,9 @@ enum v4l2_mbus_pixelcode {
>  
>  	/* JPEG compressed formats - next is 0x4002 */
>  	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
> +
> +	/* Interleaved JPEG and YUV formats - next is 0x4102 */
> +	V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 = 0x4101,
>  };

Thanks for the patch. Just a tiny comment:

I'd go with a new hardware-specific buffer range, e.g. 0x5000.

Guennadi also proposed an interesting idea: a "pass-through" format. Does
your format have dimensions that the driver would use for something or is
that just a blob?

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
