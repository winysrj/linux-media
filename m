Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:6854 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2GSO0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 10:26:20 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v5 1/2] media: add new mediabus format enums for dm365
Date: Thu, 19 Jul 2012 16:25:52 +0200
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
References: <1342707191-3938-1-git-send-email-prabhakar.lad@ti.com> <1342707191-3938-2-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1342707191-3938-2-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207191625.52118.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 19 July 2012 16:13:10 Prabhakar Lad wrote:
> From: Manjunath Hadli <manjunath.hadli@ti.com>
> 
> add new enum entries for supporting the media-bus formats on dm365.
> These include some bayer and some non-bayer formats.
> V4L2_MBUS_FMT_YDYUYDYV8_1X16 and V4L2_MBUS_FMT_UV8_1X8 are used
> internal to the hardware by the resizer.
> V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8 represents the bayer ALAW format
> that is supported by dm365 hardware.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  Documentation/DocBook/media/v4l/subdev-formats.xml |  250 +++++++++++++++++++-
>  include/linux/v4l2-mediabus.h                      |   10 +-
>  2 files changed, 252 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
> index 49c532e..77a4ccc 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -353,9 +353,9 @@
>  	<listitem><para>The number of bits per pixel component. All components are
>  	transferred on the same number of bits. Common values are 8, 10 and 12.</para>
>  	</listitem>
> -	<listitem><para>If the pixel components are DPCM-compressed, a mention of the
> -	DPCM compression and the number of bits per compressed pixel component.</para>
> -	</listitem>
> +	<listitem><para>The compression (optional). If the pixel components are
> +	ALAW- or DPCM-compressed, a mention of the compression scheme and the
> +	number of bits per compressed pixel component.</para></listitem>
>  	<listitem><para>The number of bus samples per pixel. Pixels that are wider than
>  	the bus width must be transferred in multiple samples. Common values are
>  	1 and 2.</para></listitem>
> @@ -504,6 +504,74 @@
>  	      <entry>r<subscript>1</subscript></entry>
>  	      <entry>r<subscript>0</subscript></entry>
>  	    </row>
> +	    <row id="V4L2-MBUS-FMT-SBGGR10-ALAW8-1X8">
> +	      <entry>V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8</entry>
> +	      <entry>0x3015</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SGBRG10-ALAW8-1X8">
> +	      <entry>V4L2_MBUS_FMT_SGBRG10_ALAW8_1X8</entry>
> +	      <entry>0x3016</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>g<subscript>7</subscript></entry>
> +	      <entry>g<subscript>6</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SGRBG10-ALAW8-1X8">
> +	      <entry>V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8</entry>
> +	      <entry>0x3017</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>g<subscript>7</subscript></entry>
> +	      <entry>g<subscript>6</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SRGGB10-ALAW8-1X8">
> +	      <entry>V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8</entry>
> +	      <entry>0x3018</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>r<subscript>7</subscript></entry>
> +	      <entry>r<subscript>6</subscript></entry>
> +	      <entry>r<subscript>5</subscript></entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	    </row>
>  	    <row id="V4L2-MBUS-FMT-SBGGR10-DPCM8-1X8">
>  	      <entry>V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8</entry>
>  	      <entry>0x300b</entry>
> @@ -853,10 +921,16 @@
>        <title>Packed YUV Formats</title>
>  
>        <para>Those data formats transfer pixel data as (possibly downsampled) Y, U
> -      and V components. The format code is made of the following information.
> +      and V components. Some formats include dummy bits in some of their samples
> +      and are collectively referred to as "YDYC" (Y-Dummy-Y-Chroma) formats.
> +      One cannot rely on the values of these dummy bits as those are undefined.
> +      </para>
> +      <para>The format code is made of the following information.
>        <itemizedlist>
>  	<listitem><para>The Y, U and V components order code, as transferred on the
> -	bus. Possible values are YUYV, UYVY, YVYU and VYUY.</para></listitem>
> +	bus. Possible values are YUYV, UYVY, YVYU and VYUY for formats with no
> +	dummy bit, and YDYUYDYV, YDYVYDYU, YUYDYDYV and YVYDYDYU for YDYC formats.

Almost:

"YUYDYDYV and YVYDYDYU" -> "YUYDYVYD and YVYDYUYD" :-)

Fix this and you can add my "Acked-by: Hans Verkuil <hans.verkuil@cisco.com>".

Regards,

	Hans

> +	</para></listitem>
>  	<listitem><para>The number of bits per pixel component. All components are
>  	transferred on the same number of bits. Common values are 8, 10 and 12.</para>
>  	</listitem>
> @@ -877,7 +951,21 @@
>        U, Y, V, Y order will be named <constant>V4L2_MBUS_FMT_UYVY8_2X8</constant>.
>        </para>
>  
> -      <para>The following table lisst existing packet YUV formats.</para>
> +	<para><xref linkend="v4l2-mbus-pixelcode-yuv8"/> list existing packet YUV
> +	formats and describes the organization of each pixel data in each sample.
> +	When a format pattern is split across multiple samples each of the samples
> +	in the pattern is described.</para>
> +
> +	<para>The role of each bit transferred over the bus is identified by one
> +	of the following codes.</para>
> +
> +	<itemizedlist>
> +	   <listitem><para>y<subscript>x</subscript> for luma component bit number x</para></listitem>
> +	   <listitem><para>u<subscript>x</subscript> for blue chroma component bit number x</para></listitem>
> +	   <listitem><para>v<subscript>x</subscript> for red chroma component bit number x</para></listitem>
> +	   <listitem><para>- for non-available bits (for positions higher than the bus width)</para></listitem>
> +	   <listitem><para>d for dummy bits</para></listitem>
> +	</itemizedlist>
>  
>        <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-yuv8">
>  	<title>YUV Formats</title>
> @@ -965,6 +1053,56 @@
>  	      <entry>y<subscript>1</subscript></entry>
>  	      <entry>y<subscript>0</subscript></entry>
>  	    </row>
> +	    <row id="V4L2-MBUS-FMT-UV8-1X8">
> +	      <entry>V4L2_MBUS_FMT_UV8_1X8</entry>
> +	      <entry>0x2015</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>u<subscript>7</subscript></entry>
> +	      <entry>u<subscript>6</subscript></entry>
> +	      <entry>u<subscript>5</subscript></entry>
> +	      <entry>u<subscript>4</subscript></entry>
> +	      <entry>u<subscript>3</subscript></entry>
> +	      <entry>u<subscript>2</subscript></entry>
> +	      <entry>u<subscript>1</subscript></entry>
> +	      <entry>u<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>v<subscript>7</subscript></entry>
> +	      <entry>v<subscript>6</subscript></entry>
> +	      <entry>v<subscript>5</subscript></entry>
> +	      <entry>v<subscript>4</subscript></entry>
> +	      <entry>v<subscript>3</subscript></entry>
> +	      <entry>v<subscript>2</subscript></entry>
> +	      <entry>v<subscript>1</subscript></entry>
> +	      <entry>v<subscript>0</subscript></entry>
> +	    </row>
>  	    <row id="V4L2-MBUS-FMT-UYVY8-1_5X8">
>  	      <entry>V4L2_MBUS_FMT_UYVY8_1_5X8</entry>
>  	      <entry>0x2002</entry>
> @@ -2415,6 +2553,106 @@
>  	      <entry>u<subscript>1</subscript></entry>
>  	      <entry>u<subscript>0</subscript></entry>
>  	    </row>
> +	    <row id="V4L2-MBUS-FMT-YDYUYDYV8-1X16">
> +	      <entry>V4L2_MBUS_FMT_YDYUYDYV8_1X16</entry>
> +	      <entry>0x2014</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	      <entry>d<subscript>7</subscript></entry>
> +	      <entry>d<subscript>6</subscript></entry>
> +	      <entry>d<subscript>5</subscript></entry>
> +	      <entry>d<subscript>4</subscript></entry>
> +	      <entry>d<subscript>3</subscript></entry>
> +	      <entry>d<subscript>2</subscript></entry>
> +	      <entry>d<subscript>1</subscript></entry>
> +	      <entry>d<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	      <entry>u<subscript>7</subscript></entry>
> +	      <entry>u<subscript>6</subscript></entry>
> +	      <entry>u<subscript>5</subscript></entry>
> +	      <entry>u<subscript>4</subscript></entry>
> +	      <entry>u<subscript>3</subscript></entry>
> +	      <entry>u<subscript>2</subscript></entry>
> +	      <entry>u<subscript>1</subscript></entry>
> +	      <entry>u<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	      <entry>d<subscript>7</subscript></entry>
> +	      <entry>d<subscript>6</subscript></entry>
> +	      <entry>d<subscript>5</subscript></entry>
> +	      <entry>d<subscript>4</subscript></entry>
> +	      <entry>d<subscript>3</subscript></entry>
> +	      <entry>d<subscript>2</subscript></entry>
> +	      <entry>d<subscript>1</subscript></entry>
> +	      <entry>d<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	      <entry>v<subscript>7</subscript></entry>
> +	      <entry>v<subscript>6</subscript></entry>
> +	      <entry>v<subscript>5</subscript></entry>
> +	      <entry>v<subscript>4</subscript></entry>
> +	      <entry>v<subscript>3</subscript></entry>
> +	      <entry>v<subscript>2</subscript></entry>
> +	      <entry>v<subscript>1</subscript></entry>
> +	      <entry>v<subscript>0</subscript></entry>
> +	    </row>
>  	    <row id="V4L2-MBUS-FMT-YUYV10-1X20">
>  	      <entry>V4L2_MBUS_FMT_YUYV10_1X20</entry>
>  	      <entry>0x200d</entry>
> diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
> index 5ea7f75..a871a4a 100644
> --- a/include/linux/v4l2-mediabus.h
> +++ b/include/linux/v4l2-mediabus.h
> @@ -47,8 +47,9 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
>  	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
>  
> -	/* YUV (including grey) - next is 0x2014 */
> +	/* YUV (including grey) - next is 0x2016 */
>  	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
> +	V4L2_MBUS_FMT_UV8_1X8 = 0x2015,
>  	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
>  	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
>  	V4L2_MBUS_FMT_YUYV8_1_5X8 = 0x2004,
> @@ -65,14 +66,19 @@ enum v4l2_mbus_pixelcode {
>  	V4L2_MBUS_FMT_VYUY8_1X16 = 0x2010,
>  	V4L2_MBUS_FMT_YUYV8_1X16 = 0x2011,
>  	V4L2_MBUS_FMT_YVYU8_1X16 = 0x2012,
> +	V4L2_MBUS_FMT_YDYUYDYV8_1X16 = 0x2014,
>  	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
>  	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
>  
> -	/* Bayer - next is 0x3015 */
> +	/* Bayer - next is 0x3019 */
>  	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
>  	V4L2_MBUS_FMT_SGBRG8_1X8 = 0x3013,
>  	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
>  	V4L2_MBUS_FMT_SRGGB8_1X8 = 0x3014,
> +	V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8 = 0x3015,
> +	V4L2_MBUS_FMT_SGBRG10_ALAW8_1X8 = 0x3016,
> +	V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8 = 0x3017,
> +	V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8 = 0x3018,
>  	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 = 0x300b,
>  	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8 = 0x300c,
>  	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 = 0x3009,
> 
