Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44441 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751072AbaLHCAJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Dec 2014 21:00:09 -0500
Date: Mon, 8 Dec 2014 04:00:02 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Emil Renner Berthing <kernel@esmil.dk>
Subject: Re: [PATCH 3/3] Add RGB666_1X24_CPADHI media bus format
Message-ID: <20141208020002.GH15559@valkosipuli.retiisi.org.uk>
References: <1417602500-29152-1-git-send-email-p.zabel@pengutronix.de>
 <1417602500-29152-3-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417602500-29152-3-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Wed, Dec 03, 2014 at 11:28:20AM +0100, Philipp Zabel wrote:
> Commit 9e74d2926a28 ("staging: imx-drm: add LVDS666 support for parallel
> display") describes a 24-bit bus format where three 6-bit components each
> take the lower part of 8 bits with the two high bits zero padded. Add a
> component-wise padded media bus format RGB666_1X24_CPADHI to support this
> connection.
> 
> Cc: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  Documentation/DocBook/media/v4l/subdev-formats.xml | 30 ++++++++++++++++++++++
>  include/uapi/linux/media-bus-format.h              |  1 +
>  2 files changed, 31 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
> index 9afb846..c259b9e 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -469,6 +469,36 @@
>  	      <entry>b<subscript>1</subscript></entry>
>  	      <entry>b<subscript>0</subscript></entry>
>  	    </row>
> +	    <row id="MEDIA-BUS-FMT-RGB666-1X24_CPADHI">
> +	      <entry>MEDIA_BUS_FMT_RGB666_1X24_CPADHI</entry>

s/_/-/

> +	      <entry>0x1015</entry>
> +	      <entry></entry>
> +	      &dash-ent-8;
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>r<subscript>5</subscript></entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>

Could you add a note on CPADHI in the documentation above, under "Packed RGB
Formats", please? This could be an addition to the PADHI/PADHI bullet IMO.

>  	    <row id="MEDIA-BUS-FMT-RGB888-1X24">
>  	      <entry>MEDIA_BUS_FMT_RGB888_1X24</entry>
>  	      <entry>0x100a</entry>
> diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
> index 977316e..ec80fb8 100644
> --- a/include/uapi/linux/media-bus-format.h
> +++ b/include/uapi/linux/media-bus-format.h
> @@ -45,6 +45,7 @@
>  #define MEDIA_BUS_FMT_RGB565_2X8_BE		0x1007
>  #define MEDIA_BUS_FMT_RGB565_2X8_LE		0x1008
>  #define MEDIA_BUS_FMT_RGB666_1X18		0x1009
> +#define MEDIA_BUS_FMT_RGB666_1X24_CPADHI	0x1015
>  #define MEDIA_BUS_FMT_RGB666_LVDS_SPWG		0x1010
>  #define MEDIA_BUS_FMT_RGB888_1X24		0x100a
>  #define MEDIA_BUS_FMT_BGR888_1X24		0x1013

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
