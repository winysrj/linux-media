Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50951 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab3KHCmG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Nov 2013 21:42:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	"open list:MT9M032 APTINA SE..." <linux-media@vger.kernel.org>
Subject: Re: [PATCH v5] videodev2: Set vb2_rect's width and height as unsigned
Date: Fri, 08 Nov 2013 03:42:37 +0100
Message-ID: <3183788.gODlx1VQRn@avalon>
In-Reply-To: <1383763336-5822-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1383763336-5822-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Thank you for the patch.

On Wednesday 06 November 2013 19:42:16 Ricardo Ribalda Delgado wrote:
> As discussed on the media summit 2013, there is no reason for the width
> and height to be signed.
> 
> Therefore this patch is an attempt to convert those fields from __s32 to
> __u32.
> 
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi> (documentation and smiapp)
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
> v5: Comments by Sakari Ailus
> -Fix typos in summary
> 
> v4: Wrong patch format
> 
> v3: Comments by Sakari Ailus
> -Update also doc
> 
> v2: Comments by Sakari Ailus and Laurent Pinchart
> 
> -Fix alignment on all drivers
> -Replace min with min_t where possible and remove unneeded checks
> 
>  Documentation/DocBook/media/v4l/compat.xml         | 12 ++++++++
>  Documentation/DocBook/media/v4l/dev-overlay.xml    |  8 ++---
>  Documentation/DocBook/media/v4l/vidioc-cropcap.xml |  8 ++---
>  drivers/media/i2c/mt9m032.c                        | 16 +++++-----
>  drivers/media/i2c/mt9p031.c                        | 28 ++++++++++--------
>  drivers/media/i2c/mt9t001.c                        | 26 ++++++++++-------
>  drivers/media/i2c/mt9v032.c                        | 34  ++++++++++--------
>  drivers/media/i2c/smiapp/smiapp-core.c             |  8 ++---
>  drivers/media/i2c/soc_camera/mt9m111.c             |  4 +--
>  drivers/media/i2c/tvp5150.c                        | 14 ++++-----
>  drivers/media/pci/bt8xx/bttv-driver.c              |  6 ++--
>  drivers/media/pci/saa7134/saa7134-video.c          |  4 ---
>  drivers/media/platform/soc_camera/soc_scale_crop.c |  4 +--
>  include/uapi/linux/videodev2.h                     |  4 +--
>  14 files changed, 97 insertions(+), 79 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml
> b/Documentation/DocBook/media/v4l/compat.xml index 0c7195e..5dbe68b 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2523,6 +2523,18 @@ that used it. It was originally scheduled for removal
> in 2.6.35. </orderedlist>
>      </section>
> 
> +    <section>
> +      <title>V4L2 in Linux 3.12</title>
> +      <orderedlist>
> +        <listitem>
> +		<para> In struct <structname>v4l2_rect</structname>, the type
> +of <structfield>width</structfield> and <structfield>height</structfield>
> +fields changed from _s32 to _u32.
> +	  </para>
> +        </listitem>
> +      </orderedlist>
> +    </section>
> +
>      <section id="other">
>        <title>Relation of V4L2 to other Linux multimedia APIs</title>
> 
> diff --git a/Documentation/DocBook/media/v4l/dev-overlay.xml
> b/Documentation/DocBook/media/v4l/dev-overlay.xml index 40d1d76..a44ac66
> 100644
> --- a/Documentation/DocBook/media/v4l/dev-overlay.xml
> +++ b/Documentation/DocBook/media/v4l/dev-overlay.xml
> @@ -346,16 +346,14 @@ rectangle, in pixels.</entry>
>  rectangle, in pixels. Offsets increase to the right and down.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>__s32</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>width</structfield></entry>
>  	    <entry>Width of the rectangle, in pixels.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>__s32</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>height</structfield></entry>
> -	    <entry>Height of the rectangle, in pixels. Width and
> -height cannot be negative, the fields are signed for hysterical
> -reasons. <!-- video4linux-list@redhat.com on 22 Oct 2002 subject

I like the concept of hysterical reasons :-)

> +	    <entry>Height of the rectangle, in pixels.<!--
> video4linux-list@redhat.com on 22 Oct 2002 subject "Re:[V4L][patches!]
> Re:v4l2/kernel-2.5" --></entry>
>  	  </row>
>  	</tbody>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
> b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml index bf7cc97..26b8f8f
> 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
> @@ -133,16 +133,14 @@ rectangle, in pixels.</entry>
>  rectangle, in pixels.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>__s32</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>width</structfield></entry>
>  	    <entry>Width of the rectangle, in pixels.</entry>
>  	  </row>
>  	  <row>
> -	    <entry>__s32</entry>
> +	    <entry>__u32</entry>
>  	    <entry><structfield>height</structfield></entry>
> -	    <entry>Height of the rectangle, in pixels. Width
> -and height cannot be negative, the fields are signed for
> -hysterical reasons. <!-- video4linux-list@redhat.com
> +	    <entry>Height of the rectangle, in pixels.<!--
> video4linux-list@redhat.com on 22 Oct 2002 subject "Re:[V4L][patches!]
> Re:v4l2/kernel-2.5" --> </entry>
>  	  </row>
> diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
> index 846b15f..85ec3ba 100644
> --- a/drivers/media/i2c/mt9m032.c
> +++ b/drivers/media/i2c/mt9m032.c
> @@ -459,13 +459,15 @@ static int mt9m032_set_pad_crop(struct v4l2_subdev
> *subdev, MT9M032_COLUMN_START_MAX);
>  	rect.top = clamp(ALIGN(crop->rect.top, 2), MT9M032_ROW_START_MIN,
>  			 MT9M032_ROW_START_MAX);
> -	rect.width = clamp(ALIGN(crop->rect.width, 2), MT9M032_COLUMN_SIZE_MIN,
> -			   MT9M032_COLUMN_SIZE_MAX);
> -	rect.height = clamp(ALIGN(crop->rect.height, 2), MT9M032_ROW_SIZE_MIN,
> -			    MT9M032_ROW_SIZE_MAX);
> -
> -	rect.width = min(rect.width, MT9M032_PIXEL_ARRAY_WIDTH - rect.left);
> -	rect.height = min(rect.height, MT9M032_PIXEL_ARRAY_HEIGHT - rect.top);
> +	rect.width = clamp_t(unsigned int, ALIGN(crop->rect.width, 2),
> +			     MT9M032_COLUMN_SIZE_MIN, MT9M032_COLUMN_SIZE_MAX);
> +	rect.height = clamp_t(unsigned int, ALIGN(crop->rect.height, 2),
> +			      MT9M032_ROW_SIZE_MIN, MT9M032_ROW_SIZE_MAX);

Would it make sense to define the size-related macros as unsigned integers 
instead of using clamp_t ? For instance MT9M032_PIXEL_ARRAY_WIDTH could be 
defined as 1600U instead of 1600. Same for the other Aptina sensor drivers. 
This might introduce other issues, so I don't know whether that would be a 
good solution.

> +	rect.width = min_t(unsigned int, rect.width,
> +			   MT9M032_PIXEL_ARRAY_WIDTH - rect.left);
> +	rect.height = min_t(unsigned int, rect.height,
> +			    MT9M032_PIXEL_ARRAY_HEIGHT - rect.top);
> 
>  	__crop = __mt9m032_get_pad_crop(sensor, fh, crop->which);
> 

-- 
Regards,

Laurent Pinchart

