Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:34660 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbbBBO6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 09:58:04 -0500
Date: Mon, 02 Feb 2015 12:57:55 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v2] [media] Add RGB444_1X12 and RGB565_1X16 media
 bus formats
Message-id: <20150202125755.5bf5ecc9.m.chehab@samsung.com>
In-reply-to: <1420544615-18788-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1420544615-18788-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue,  6 Jan 2015 12:43:35 +0100
Boris Brezillon <boris.brezillon@free-electrons.com> escreveu:

> Add RGB444_1X12 and RGB565_1X16 format definitions and update the
> documentation.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Mauro, Sakari,
> 
> This patch has been rejected as 'Not Applicable'.
> Is there anyting wrong in it ?

I was expecting that this patch would be merged together with the
remaining series, via the DRM tree. That's basically why I gave
my ack:
	https://lkml.org/lkml/2014/11/3/661

HINT: when a subsystem maintainer gives an ack, that likely means that
he expects that the patch will be applied via some other tree.

Regards,
Mauro

> 
> Best Regards,
> 
> Boris
> 
>  Documentation/DocBook/media/v4l/subdev-formats.xml | 40 ++++++++++++++++++++++
>  include/uapi/linux/media-bus-format.h              |  4 ++-
>  2 files changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
> index c5ea868..be57efa 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -192,6 +192,24 @@ see <xref linkend="colorspaces" />.</entry>
>  	    </row>
>  	  </thead>
>  	  <tbody valign="top">
> +	    <row id="MEDIA-BUS-FMT-RGB444-1X12">
> +	      <entry>MEDIA_BUS_FMT_RGB444_1X12</entry>
> +	      <entry>0x100d</entry>
> +	      <entry></entry>
> +	      &dash-ent-20;
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
>  	    <row id="MEDIA-BUS-FMT-RGB444-2X8-PADHI-BE">
>  	      <entry>MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE</entry>
>  	      <entry>0x1001</entry>
> @@ -304,6 +322,28 @@ see <xref linkend="colorspaces" />.</entry>
>  	      <entry>g<subscript>4</subscript></entry>
>  	      <entry>g<subscript>3</subscript></entry>
>  	    </row>
> +	    <row id="MEDIA-BUS-FMT-RGB565-1X16">
> +	      <entry>MEDIA_BUS_FMT_RGB565_1X16</entry>
> +	      <entry>0x100d</entry>
> +	      <entry></entry>
> +	      &dash-ent-16;
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
>  	    <row id="MEDIA-BUS-FMT-BGR565-2X8-BE">
>  	      <entry>MEDIA_BUS_FMT_BGR565_2X8_BE</entry>
>  	      <entry>0x1005</entry>
> diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
> index 23b4090..37091c6 100644
> --- a/include/uapi/linux/media-bus-format.h
> +++ b/include/uapi/linux/media-bus-format.h
> @@ -33,11 +33,13 @@
>  
>  #define MEDIA_BUS_FMT_FIXED			0x0001
>  
> -/* RGB - next is	0x100e */
> +/* RGB - next is	0x1010 */
> +#define MEDIA_BUS_FMT_RGB444_1X12		0x100e
>  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
>  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
>  #define MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE	0x1003
>  #define MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE	0x1004
> +#define MEDIA_BUS_FMT_RGB565_1X16		0x100f
>  #define MEDIA_BUS_FMT_BGR565_2X8_BE		0x1005
>  #define MEDIA_BUS_FMT_BGR565_2X8_LE		0x1006
>  #define MEDIA_BUS_FMT_RGB565_2X8_BE		0x1007
