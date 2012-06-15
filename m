Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46509 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2FONzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 09:55:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl, snjw23@gmail.com,
	t.stanislaws@samsung.com
Subject: Re: [PATCH v4 2/7] v4l: Remove "_ACTUAL" from subdev selection API target definition names
Date: Fri, 15 Jun 2012 15:55:28 +0200
Message-ID: <2070008.tlNKc1tQnO@avalon>
In-Reply-To: <1339767880-8412-2-git-send-email-sakari.ailus@iki.fi>
References: <4FDB3C2E.9060502@iki.fi> <1339767880-8412-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 15 June 2012 16:44:35 Sakari Ailus wrote:
> The string "_ACTUAL" does not say anything more about the target names. Drop
> it. V4L2 selection API was changed by "V4L: Remove "_ACTIVE" from the
> selection target name definitions" by Sylwester Nawrocki. This patch does
> the same for the V4L2 subdev API.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/dev-subdev.xml     |   25
> +++++++++---------- .../media/v4l/vidioc-subdev-g-selection.xml        |  
> 12 ++++---- drivers/media/video/omap3isp/ispccdc.c             |    4 +-
>  drivers/media/video/omap3isp/isppreview.c          |    4 +-
>  drivers/media/video/omap3isp/ispresizer.c          |    4 +-
>  drivers/media/video/smiapp/smiapp-core.c           |   22 ++++++++--------
>  drivers/media/video/v4l2-subdev.c                  |    4 +-
>  include/linux/v4l2-subdev.h                        |    4 +-
>  8 files changed, 39 insertions(+), 40 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml
> b/Documentation/DocBook/media/v4l/dev-subdev.xml index 4afcbbe..ac715dd
> 100644
> --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
> +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
> @@ -289,8 +289,8 @@
>        &v4l2-rect; by the coordinates of the top left corner and the
> rectangle size. Both the coordinates and sizes are expressed in
> pixels.</para>
> 
> -      <para>As for pad formats, drivers store try and active
> -      rectangles for the selection targets of ACTUAL type <xref
> +      <para>As for pad formats, drivers store try and active rectangles for
> +      the selection targets <xref
>        linkend="v4l2-subdev-selection-targets">.</xref></para>

Could you please also fix the xref issue ? According to 
http://www.docbook.org/tdg/en/html/xref.html, the xref element is supposed to 
be empty. You can either use something like

... the selection targets described in <xref .../>

or a link element around "selection targets".

>        <para>On sink pads, cropping is applied relative to the
> @@ -308,7 +308,7 @@
>        <para>Scaling support is optional. When supported by a subdev,
>        the crop rectangle on the subdev's sink pad is scaled to the
>        size configured using the &VIDIOC-SUBDEV-S-SELECTION; IOCTL
> -      using <constant>V4L2_SUBDEV_SEL_COMPOSE_ACTUAL</constant>
> +      using <constant>V4L2_SUBDEV_SEL_TGT_COMPOSE</constant>
>        selection target on the same pad. If the subdev supports scaling
>        but not composing, the top and left values are not used and must
>        always be set to zero.</para>
> @@ -333,22 +333,21 @@
>        <title>Types of selection targets</title>
> 
>        <section>
> -	<title>ACTUAL targets</title>
> +	<title>Actual targets</title>
> 
> -	<para>ACTUAL targets reflect the actual hardware configuration
> -	at any point of time. There is a BOUNDS target
> -	corresponding to every ACTUAL.</para>
> +	<para>Actual targets (without a postfix) reflect the actual hardware
> +	configuration at any point of time.</para>
>        </section>

Don't we have a bounds target for every actual target ?

>        <section>
>  	<title>BOUNDS targets</title>
> 
> -	<para>BOUNDS targets is the smallest rectangle that contains
> -	all valid ACTUAL rectangles. It may not be possible to set the
> -	ACTUAL rectangle as large as the BOUNDS rectangle, however.
> -	This may be because e.g. a sensor's pixel array is not
> -	rectangular but cross-shaped or round. The maximum size may
> -	also be smaller than the BOUNDS rectangle.</para>
> +	<para>BOUNDS targets is the smallest rectangle that contains all
> +	valid actual rectangles. It may not be possible to set the actual
> +	rectangle as large as the BOUNDS rectangle, however. This may be
> +	because e.g. a sensor's pixel array is not rectangular but
> +	cross-shaped or round. The maximum size may also be smaller than the
> +	BOUNDS rectangle.</para>
>        </section>
> 
>      </section>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
> b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml index
> 208e9f0..96ab51e 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
> @@ -72,10 +72,10 @@
>      <section>
>        <title>Types of selection targets</title>
> 
> -      <para>There are two types of selection targets: actual and bounds.
> -      The ACTUAL targets are the targets which configure the hardware.
> -      The BOUNDS target will return a rectangle that contain all
> -      possible ACTUAL rectangles.</para>
> +      <para>There are two types of selection targets: plain and bounds. The

plain or actual ?

> +      actual targets are the targets which configure the hardware. The
> BOUNDS +      target will return a rectangle that contain all possible
> actual +      rectangles.</para>
>      </section>
> 
>      <section>
> @@ -93,7 +93,7 @@
>          &cs-def;
>  	<tbody valign="top">
>  	  <row>
> -	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL</constant></entry>
> +	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP</constant></entry>
>  	    <entry>0x0000</entry>
>  	    <entry>Actual crop. Defines the cropping
>  	    performed by the processing step.</entry>
> @@ -104,7 +104,7 @@
>  	    <entry>Bounds of the crop rectangle.</entry>
>  	  </row>
>  	  <row>
> -	    
<entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL</constant></entry>
> +	    <entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE</constant></entry>
> <entry>0x0100</entry>
>  	    <entry>Actual compose rectangle. Used to configure scaling
>  	    on sink pads and composition on source pads.</entry>

-- 
Regards,

Laurent Pinchart

