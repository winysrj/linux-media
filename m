Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33747 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaLCMr7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 07:47:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 1/3] Add BGR888_1X24 and GBR888_1X24 media bus formats
Date: Wed, 03 Dec 2014 14:48:35 +0200
Message-ID: <1857174.h7s3t8B9N4@avalon>
In-Reply-To: <1417602500-29152-1-git-send-email-p.zabel@pengutronix.de>
References: <1417602500-29152-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Wednesday 03 December 2014 11:28:18 Philipp Zabel wrote:
> This patch adds two more 24-bit RGB formats. BGR888 is more or less common,
> GBR888 is used on the internal connection between the IPU display interface
> and the TVE (VGA DAC) on i.MX53 SoCs.

Were RGB and BGR patented that they had to use a new format ? :-)

> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  Documentation/DocBook/media/v4l/subdev-formats.xml | 60 +++++++++++++++++++
>  include/uapi/linux/media-bus-format.h              |  4 +-
>  2 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml
> b/Documentation/DocBook/media/v4l/subdev-formats.xml index 52d7f04..f163767
> 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -499,6 +499,66 @@
>  	      <entry>b<subscript>1</subscript></entry>
>  	      <entry>b<subscript>0</subscript></entry>
>  	    </row>
> +	    <row id="MEDIA-BUS-FMT-BGR888-1X24">
> +	      <entry>MEDIA_BUS_FMT_BGR888_1X24</entry>
> +	      <entry>0x1013</entry>
> +	      <entry></entry>
> +	      &dash-ent-8;
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	      <entry>g<subscript>7</subscript></entry>
> +	      <entry>g<subscript>6</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>r<subscript>7</subscript></entry>
> +	      <entry>r<subscript>6</subscript></entry>
> +	      <entry>r<subscript>5</subscript></entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="MEDIA-BUS-FMT-GBR888-1X24">
> +	      <entry>MEDIA_BUS_FMT_GBR888_1X24</entry>
> +	      <entry>0x1014</entry>
> +	      <entry></entry>
> +	      &dash-ent-8;
> +	      <entry>g<subscript>7</subscript></entry>
> +	      <entry>g<subscript>6</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	      <entry>r<subscript>7</subscript></entry>
> +	      <entry>r<subscript>6</subscript></entry>
> +	      <entry>r<subscript>5</subscript></entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	    </row>
>  	    <row id="MEDIA-BUS-FMT-RGB888-2X12-BE">
>  	      <entry>MEDIA_BUS_FMT_RGB888_2X12_BE</entry>
>  	      <entry>0x100b</entry>
> diff --git a/include/uapi/linux/media-bus-format.h
> b/include/uapi/linux/media-bus-format.h index 7f8b1e2..6d7f0c7 100644
> --- a/include/uapi/linux/media-bus-format.h
> +++ b/include/uapi/linux/media-bus-format.h
> @@ -33,7 +33,7 @@
> 
>  #define MEDIA_BUS_FMT_FIXED			0x0001
> 
> -/* RGB - next is	0x1013 */
> +/* RGB - next is	0x1015 */
>  #define MEDIA_BUS_FMT_RGB444_1X12		0x100e
>  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
>  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
> @@ -47,6 +47,8 @@
>  #define MEDIA_BUS_FMT_RGB666_1X18		0x1009
>  #define MEDIA_BUS_FMT_RGB666_LVDS_SPWG		0x1010
>  #define MEDIA_BUS_FMT_RGB888_1X24		0x100a
> +#define MEDIA_BUS_FMT_BGR888_1X24		0x1013
> +#define MEDIA_BUS_FMT_GBR888_1X24		0x1014

Could you move these right before RGB888_1X24 to keep them sorted 
alphabetically ? Same for the documentation part.

With this changed,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  #define MEDIA_BUS_FMT_RGB888_2X12_BE		0x100b
>  #define MEDIA_BUS_FMT_RGB888_2X12_LE		0x100c
>  #define MEDIA_BUS_FMT_RGB888_LVDS_SPWG		0x1011

-- 
Regards,

Laurent Pinchart

