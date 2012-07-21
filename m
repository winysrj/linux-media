Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52328 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750939Ab2GUH4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jul 2012 03:56:31 -0400
Date: Sat, 21 Jul 2012 10:56:27 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Prabhakar Lad <prabhakar.lad@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v6 2/2] v4l2: add new pixel formats supported on dm365
Message-ID: <20120721075627.GF22859@valkosipuli.retiisi.org.uk>
References: <1342796290-18947-1-git-send-email-prabhakar.lad@ti.com>
 <1342796290-18947-3-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342796290-18947-3-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thanks for the patch.

On Fri, Jul 20, 2012 at 08:28:10PM +0530, Prabhakar Lad wrote:
> From: Manjunath Hadli <manjunath.hadli@ti.com>
> 
> add new macro V4L2_PIX_FMT_SGRBG10ALAW8 and associated formats
> to represent Bayer format frames compressed by A-LAW algorithm,
> add V4L2_PIX_FMT_UV8 to represent storage of CbCr data (UV interleaved)
> only.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |   34 +++++++++++
>  Documentation/DocBook/media/v4l/pixfmt-uv8.xml     |   62 ++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml         |    2 +
>  include/linux/videodev2.h                          |    8 +++
>  4 files changed, 106 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-uv8.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> new file mode 100644
> index 0000000..61cced5
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
> @@ -0,0 +1,34 @@
> +	<refentry>
> +	  <refmeta>
> +	    <refentrytitle>
> +	      V4L2_PIX_FMT_SRGGB10ALAW8 ('aRA8'),
> +	      V4L2_PIX_FMT_SGRBG10ALAW8 ('agA8'),
> +	      V4L2_PIX_FMT_SGBRG10ALAW8 ('aGA8'),
> +	      V4L2_PIX_FMT_SBGGR10ALAW8 ('aBA8'),

Could you use the same order as in Documentation/video4linux/4CCs.txt ? I
know it's different in some existing documentation.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
