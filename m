Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:41895 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab2EGEzy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 00:55:54 -0400
Message-ID: <4FA6C155.6030100@iki.fi>
Date: Sun, 06 May 2012 21:22:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v4 10/12] V4L: Add auto focus targets to the selections
 API
References: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com> <1336156337-10935-11-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1336156337-10935-11-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the patch.

Sylwester Nawrocki wrote:
> The camera automatic focus algorithms may require setting up
> a spot or rectangle coordinates or multiple such parameters.
> 
> The automatic focus selection targets are introduced in order
> to allow applications to query and set such coordinates. Those
> selections are intended to be used together with the automatic
> focus controls available in the camera control class.

Have you thought about multiple autofocus windows, and how could they be
implemented on top of this patch?

I'm not saying that we should implement them now, but at least we should
think how we _would_ implement them when needed. They aren't that exotic
functionality these days after all.

I'd guess this would involve an additional bitmask control and defining
a set of new targets. A comment in the source might help here ---
perhaps a good rule is to start new ranges at 0x1000 as you're doing
already.

> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/selection-api.xml  |   33 +++++++++++++++++++-
>  .../DocBook/media/v4l/vidioc-g-selection.xml       |   11 +++++++
>  include/linux/videodev2.h                          |    5 +++
>  3 files changed, 48 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
> index b299e47..490d29a 100644
> --- a/Documentation/DocBook/media/v4l/selection-api.xml
> +++ b/Documentation/DocBook/media/v4l/selection-api.xml
> @@ -1,6 +1,6 @@
>  <section id="selection-api">
>  
> -  <title>Experimental API for cropping, composing and scaling</title>
> +  <title>Experimental selections API</title>
>  
>        <note>
>  	<title>Experimental</title>
> @@ -9,6 +9,10 @@
>  interface and may change in the future.</para>
>        </note>
>  
> + <section>
> +
> + <title>Image cropping, composing and scaling</title>
> +
>    <section>
>      <title>Introduction</title>
>  
> @@ -321,5 +325,32 @@ V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> for other devices</para>
>        </example>
>  
>     </section>
> + </section>
> +
> +   <section>
> +     <title>Automatic focus regions of interest</title>
> +
> +<para> The camera automatic focus algorithms may require configuration of
> +regions of interest in form of rectangle or spot coordinates. The automatic
> +focus selection targets allow applications to query and set such coordinates.
> +Those selections are intended to be used together with the
> +<constant>V4L2_CID_AUTO_FOCUS_AREA</constant> <link linkend="camera-controls">
> +camera class</link> control. The <constant>V4L2_SEL_TGT_AUTO_FOCUS_ACTUAL
> +</constant> target is used for querying or setting actual spot or rectangle
> +coordinates, while <constant>V4L2_SEL_TGT_AUTO_FOCUS_BOUNDS</constant> target
> +determines bounds for a single spot or rectangle.
> +These selections are only effective when the <constant>V4L2_CID_AUTO_FOCUS_AREA
> +</constant>control is set to <constant>V4L2_AUTO_FOCUS_AREA_SPOT</constant> or
> +<constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>. The new coordinates shall
> +be accepted and applied to hardware when the focus area control value is
> +changed and also during a &VIDIOC-S-SELECTION; ioctl call, only when the focus
> +area control is already set to required value.</para>
> +
> +<para> For the <constant>V4L2_AUTO_FOCUS_AREA_SPOT</constant> case, the selection
> +rectangle <structfield> width</structfield> and <structfield>height</structfield>
> +are not used, i.e. shall be set to 0 by applications and ignored by drivers for
> +the &VIDIOC-S-SELECTION; ioctl and shall be ignored by applications for the
> +&VIDIOC-G-SELECTION; ioctl.</para>
> +   </section>
>  
>  </section>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
> index bb04eff..87df4da 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
> @@ -195,6 +195,17 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
>              <entry>0x0103</entry>
>              <entry>The active area and all padding pixels that are inserted or modified by hardware.</entry>
>  	  </row>
> +	  <row>
> +            <entry><constant>V4L2_SEL_TGT_AUTO_FOCUS_ACTUAL</constant></entry>
> +            <entry>0x1000</entry>
> +	    <entry>Actual automatic focus rectangle or spot coordinates.</entry>
> +	  </row>
> +	  <row>
> +            <entry><constant>V4L2_SEL_TGT_AUTO_FOCUS_BOUNDS</constant></entry>
> +            <entry>0x1002</entry>

This should be 0x1001, I believe.

> +            <entry>Bounds of the automatic focus region of interest.
> +	    </entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index c1fae94..6bfd6c5 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -777,6 +777,11 @@ struct v4l2_crop {
>  /* Current composing area plus all padding pixels */
>  #define V4L2_SEL_TGT_COMPOSE_PADDED	0x0103
>  
> +/* Auto focus region of interest */
> +#define V4L2_SEL_TGT_AUTO_FOCUS_ACTUAL	0x1000
> +/* Auto focus region (spot coordinates) bounds */
> +#define V4L2_SEL_TGT_AUTO_FOCUS_BOUNDS	0x1001
> +
>  /**
>   * struct v4l2_selection - selection info
>   * @type:	buffer type (do not use *_MPLANE types)

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
