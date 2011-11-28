Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35991 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab1K1LJb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 06:09:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 1/2] v4l: Add new alpha component control
Date: Mon, 28 Nov 2011 12:09:36 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
References: <1322235572-22016-1-git-send-email-s.nawrocki@samsung.com> <1322235572-22016-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1322235572-22016-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111281209.37375.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Friday 25 November 2011 16:39:31 Sylwester Nawrocki wrote:
> This control is intended for the video capture or memory-to-memory devices
> that are capable of setting up a per-pixel alpha component to some
> arbitrary value. The V4L2_CID_ALPHA_COMPONENT control allows to set the
> alpha component for all pixels to a value in range from 0 to 255.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/DocBook/media/v4l/compat.xml         |   11 ++++++++
>  Documentation/DocBook/media/v4l/controls.xml       |   25
> +++++++++++++++---- .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |  
>  7 ++++-
>  drivers/media/video/v4l2-ctrls.c                   |    7 +++++
>  include/linux/videodev2.h                          |    6 ++--
>  5 files changed, 45 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml
> b/Documentation/DocBook/media/v4l/compat.xml index b68698f..0adda43 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2379,6 +2379,17 @@ that used it. It was originally scheduled for
> removal in 2.6.35. </orderedlist>
>      </section>
> 
> +    <section>
> +      <title>V4L2 in Linux 3.3</title>
> +      <orderedlist>
> +        <listitem>
> +	  <para>Added <constant>V4L2_CID_ALPHA_COMPONENT</constant> control
> +	    to the <link linkend="control">User controls class</link>.
> +	  </para>
> +        </listitem>
> +      </orderedlist>
> +    </section>
> +
>      <section id="other">
>        <title>Relation of V4L2 to other Linux multimedia APIs</title>
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml
> b/Documentation/DocBook/media/v4l/controls.xml index 3bc5ee8..4fd83c0
> 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -324,12 +324,6 @@ minimum value disables backlight compensation.</entry>
>  		(usually a microscope).</entry>
>  	  </row>
>  	  <row>
> -	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
> -	    <entry></entry>
> -	    <entry>End of the predefined control IDs (currently
> -<constant>V4L2_CID_ILLUMINATORS_2</constant> + 1).</entry>
> -	  </row>
> -	  <row>
>  	    <entry><constant>V4L2_CID_MIN_BUFFERS_FOR_CAPTURE</constant></entry>
>  	    <entry>integer</entry>
>  	    <entry>This is a read-only control that can be read by the
> application @@ -345,6 +339,25 @@ and used as a hint to determine the
> number of OUTPUT buffers to pass to REQBUFS. The value is the minimum
> number of OUTPUT buffers that is necessary for hardware to work.</entry>
>  	  </row>
> +	  <row id="v4l2-alpha-component">
> +	    <entry><constant>V4L2_CID_ALPHA_COMPONENT</constant></entry>
> +	    <entry>integer</entry>
> +	    <entry> Sets the alpha color component on the capture device or on
> +	    the capture buffer queue of a mem-to-mem device. When a mem-to-mem
> +	    device produces frame format that includes an alpha component
> +	    (e.g. <link linkend="rgb-formats">packed RGB image formats</link>)
> +	    and the alpha value is not defined by the mem-to-mem input data
> +	    this control lets you select the alpha component value of all
> +	    pixels. It is applicable to any pixel format that contains an alpha
> +	    component.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
> +	    <entry></entry>
> +	    <entry>End of the predefined control IDs (currently
> +	      <constant>V4L2_CID_ALPHA_COMPONENT</constant> + 1).</entry>
> +	  </row>
>  	  <row>
>  	    <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
>  	    <entry></entry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml index
> 4db272b..c13278b 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> @@ -428,8 +428,11 @@ colorspace
> <constant>V4L2_COLORSPACE_SRGB</constant>.</para> <para>Bit 7 is the most
> significant bit. The value of a = alpha bits is undefined when reading
> from the driver, ignored when writing to the driver, except when alpha
> blending has been negotiated for a -<link linkend="overlay">Video
> Overlay</link> or <link
> -linkend="osd">Video Output Overlay</link>.</para>
> +<link linkend="overlay">Video Overlay</link> or <link linkend="osd">
> +Video Output Overlay</link> or when alpha component has been configured
> +for a <link linkend="capture">Video Capture</link> by means of <link
> +linkend="v4l2-alpha-component"> <constant>V4L2_CID_ALPHA_COMPONENT
> +</constant> </link> control.</para>
> 
>      <example>
>        <title><constant>V4L2_PIX_FMT_BGR24</constant> 4 &times; 4 pixel
> diff --git a/drivers/media/video/v4l2-ctrls.c
> b/drivers/media/video/v4l2-ctrls.c index 5552f81..882cc84 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -466,6 +466,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_ILLUMINATORS_2:		return "Illuminator 2";
>  	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:	return "Minimum Number of Capture
> Buffers"; case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:	return "Minimum Number of
> Output Buffers"; +	case V4L2_CID_ALPHA_COMPONENT:		return "Alpha
> Component";
> 
>  	/* MPEG controls */
>  	/* Keep the order of the 'case's the same as in videodev2.h! */
> @@ -714,6 +715,12 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type, /* Max is calculated as RGB888 that is 2^24 */
>  		*max = 0xFFFFFF;
>  		break;
> +	case V4L2_CID_ALPHA_COMPONENT:
> +		*type = V4L2_CTRL_TYPE_INTEGER;
> +		*step = 1;
> +		*min = 0;
> +		*max = 0xff;
> +		break;
>  	case V4L2_CID_FLASH_FAULT:
>  		*type = V4L2_CTRL_TYPE_BITMASK;
>  		break;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 4b752d5..fdda200 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1204,10 +1204,10 @@ enum v4l2_colorfx {
>  #define V4L2_CID_MIN_BUFFERS_FOR_CAPTURE	(V4L2_CID_BASE+39)
>  #define V4L2_CID_MIN_BUFFERS_FOR_OUTPUT		(V4L2_CID_BASE+40)
> 
> -/* last CID + 1 */
> -#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+41)
> +#define V4L2_CID_ALPHA_COMPONENT		(V4L2_CID_BASE+41)
> 
> -/* Minimum number of buffer neede by the device */
> +/* last CID + 1 */
> +#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+42)
> 
>  /*  MPEG-class control IDs defined by V4L2 */
>  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)

-- 
Regards,

Laurent Pinchart
