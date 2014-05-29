Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41976 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782AbaE2OrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 10:47:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v3 1/3] v4l: Add test pattern colour component controls
Date: Thu, 29 May 2014 16:47:40 +0200
Message-ID: <48325310.Ydj7bxFi9C@avalon>
In-Reply-To: <1401374448-30411-2-git-send-email-sakari.ailus@linux.intel.com>
References: <1401374448-30411-1-git-send-email-sakari.ailus@linux.intel.com> <1401374448-30411-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Thursday 29 May 2014 17:40:46 Sakari Ailus wrote:
> In many cases the test pattern has selectable values for each colour
> component. Implement controls for raw bayer components. Additional controls
> should be defined for colour components that are not covered by these
> controls.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml | 34 +++++++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c         |  4 ++++
>  include/uapi/linux/v4l2-controls.h           |  4 ++++
>  3 files changed, 42 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml
> b/Documentation/DocBook/media/v4l/controls.xml index 47198ee..bf23994
> 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -4677,6 +4677,40 @@ interface and may change in the future.</para>
>  	    conversion.
>  	    </entry>
>  	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_TEST_PATTERN_RED</constant></entry> +	   
> <entry>integer</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Test pattern red colour component.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_TEST_PATTERN_GREENR</constant></entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Test pattern green (next to red)
> +	    colour component.

What about non-Bayer RGB sensors ? Should they use the GREENR or the GREENB 
control for the green component ? Or a different control ?

I'm wondering whether we shouldn't have a single test pattern color control 
and create a color type using Hans' complex controls API.

> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_TEST_PATTERN_BLUE</constant></entry> +	   
> <entry>integer</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Test pattern blue colour component.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_TEST_PATTERN_GREENB</constant></entry> +	 
>   <entry>integer</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Test pattern green (next to blue)
> +	    colour component.
> +	    </entry>
> +	  </row>
>  	  <row><entry></entry></row>
>  	</tbody>
>        </tgroup>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> b/drivers/media/v4l2-core/v4l2-ctrls.c index 55c6832..a4104a7 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -839,6 +839,10 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_VBLANK:			return "Vertical Blanking";
>  	case V4L2_CID_HBLANK:			return "Horizontal Blanking";
>  	case V4L2_CID_ANALOGUE_GAIN:		return "Analogue Gain";
> +	case V4L2_CID_TEST_PATTERN_RED:		return "Red Pixel Value";
> +	case V4L2_CID_TEST_PATTERN_GREENR:	return "Green (Red) Pixel Value";
> +	case V4L2_CID_TEST_PATTERN_BLUE:	return "Blue Pixel Value";
> +	case V4L2_CID_TEST_PATTERN_GREENB:	return "Green (Blue) Pixel Value";
> 
>  	/* Image processing controls */
>  	case V4L2_CID_IMAGE_PROC_CLASS:		return "Image Processing Controls";
> diff --git a/include/uapi/linux/v4l2-controls.h
> b/include/uapi/linux/v4l2-controls.h index 2ac5597..5c55a19 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -855,6 +855,10 @@ enum v4l2_jpeg_chroma_subsampling {
>  #define V4L2_CID_VBLANK				(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 1)
>  #define V4L2_CID_HBLANK				(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 2)
>  #define V4L2_CID_ANALOGUE_GAIN			(V4L2_CID_IMAGE_SOURCE_CLASS_BASE 
+ 3)
> +#define V4L2_CID_TEST_PATTERN_RED		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 
4)
> +#define V4L2_CID_TEST_PATTERN_GREENR		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE 
+
> 5) +#define V4L2_CID_TEST_PATTERN_BLUE		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE 
+
> 6) +#define V4L2_CID_TEST_PATTERN_GREENB		
(V4L2_CID_IMAGE_SOURCE_CLASS_BASE
> + 7)
> 
> 
>  /* Image processing controls */

-- 
Regards,

Laurent Pinchart

