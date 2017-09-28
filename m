Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54548 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752359AbdI1MPD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 08:15:03 -0400
Date: Thu, 28 Sep 2017 15:15:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 12/17] media: v4l2-fwnode.h: better describe bus union
 at fwnode endpoint struct
Message-ID: <20170928121500.ghuzoviwsf7jpkpm@valkosipuli.retiisi.org.uk>
References: <cover.1506548682.git.mchehab@s-opensource.com>
 <dfcea28fc432a398b4b87902a2bcb097ad416b2c.1506548682.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfcea28fc432a398b4b87902a2bcb097ad416b2c.1506548682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the patch.

On Wed, Sep 27, 2017 at 06:46:55PM -0300, Mauro Carvalho Chehab wrote:
> Now that kernel-doc handles nested unions, better document the
> bus union at struct v4l2_fwnode_endpoint.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  include/media/v4l2-fwnode.h | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index 7adec9851d9e..5f4716f967d0 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -79,7 +79,18 @@ struct v4l2_fwnode_bus_mipi_csi1 {
>   * struct v4l2_fwnode_endpoint - the endpoint data structure
>   * @base: fwnode endpoint of the v4l2_fwnode
>   * @bus_type: bus type
> - * @bus: bus configuration data structure
> + * @bus: union with bus configuration data structure
> + * @bus.parallel: pointer for &struct v4l2_fwnode_bus_parallel.
> + *		  Used if the bus is parallel.
> + * @bus.mipi_csi1: pointer for &struct v4l2_fwnode_bus_mipi_csi1.
> + *		   Used if the bus is Mobile Industry Processor

s/Mobile.*Interface/MIPI Alliance/

Same below.

Please see:

<URL:https://mipi.org/content/what-does-mipi-stand>

With that,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> + * 		   Interface's Camera Serial Interface version 1
> + * 		   (MIPI CSI1) or Standard Mobile Imaging Architecture's
> + *		   Compact Camera Port 2 (SMIA CCP2).
> + * @bus.mipi_csi2: pointer for &struct v4l2_fwnode_bus_mipi_csi2.
> + *		   Used if the bus is Mobile Industry Processor
> + * 		   Interface's Camera Serial Interface version 2
> + *		   (MIPI CSI2).
>   * @link_frequencies: array of supported link frequencies
>   * @nr_of_link_frequencies: number of elements in link_frequenccies array
>   */

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
