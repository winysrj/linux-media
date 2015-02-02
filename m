Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:59376 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061AbbBBPIw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 10:08:52 -0500
Message-ID: <54CF92DD.6020308@xs4all.nl>
Date: Mon, 02 Feb 2015 16:08:13 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v2 1/3] Add BGR888_1X24 and GBR888_1X24 media bus formats
References: <1417614811-15634-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1417614811-15634-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/2014 02:53 PM, Philipp Zabel wrote:
> This patch adds two more 24-bit RGB formats. BGR888 is more or less common,
> GBR888 is used on the internal connection between the IPU display interface
> and the TVE (VGA DAC) on i.MX53 SoCs.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

This three-part patch series doesn't apply. Is it on top of another patch
series?

Anyway, it can't be merged unless it is actually used in a driver.

I'm changing this to 'Changes Requested' in patchwork.

Regards,

	Hans

> ---
> Changes since v1:
>  - Reordered 24-bit RGB formats alphabetically
> ---
>  Documentation/DocBook/media/v4l/subdev-formats.xml | 60 ++++++++++++++++++++++
>  include/uapi/linux/media-bus-format.h              |  4 +-
>  2 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
> index 52d7f04..a8da9d3 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -469,6 +469,66 @@
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
>  	    <row id="MEDIA-BUS-FMT-RGB888-1X24">
>  	      <entry>MEDIA_BUS_FMT_RGB888_1X24</entry>
>  	      <entry>0x100a</entry>
> diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
> index 7f8b1e2..10b40dd 100644
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
> @@ -46,6 +46,8 @@
>  #define MEDIA_BUS_FMT_RGB565_2X8_LE		0x1008
>  #define MEDIA_BUS_FMT_RGB666_1X18		0x1009
>  #define MEDIA_BUS_FMT_RGB666_LVDS_SPWG		0x1010
> +#define MEDIA_BUS_FMT_BGR888_1X24		0x1013
> +#define MEDIA_BUS_FMT_GBR888_1X24		0x1014
>  #define MEDIA_BUS_FMT_RGB888_1X24		0x100a
>  #define MEDIA_BUS_FMT_RGB888_2X12_BE		0x100b
>  #define MEDIA_BUS_FMT_RGB888_2X12_LE		0x100c
> 

