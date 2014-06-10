Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4516 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaFJMQg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jun 2014 08:16:36 -0400
Message-ID: <5396F6E1.9000603@xs4all.nl>
Date: Tue, 10 Jun 2014 14:15:29 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
CC: laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v3 1/3] v4l: Add test pattern colour component controls
References: <1401374448-30411-1-git-send-email-sakari.ailus@linux.intel.com> <1401374448-30411-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1401374448-30411-2-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/29/14 16:40, Sakari Ailus wrote:
> In many cases the test pattern has selectable values for each colour
> component. Implement controls for raw bayer components. Additional controls
> should be defined for colour components that are not covered by these
> controls.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  Documentation/DocBook/media/v4l/controls.xml | 34 ++++++++++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c         |  4 ++++
>  include/uapi/linux/v4l2-controls.h           |  4 ++++
>  3 files changed, 42 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 47198ee..bf23994 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -4677,6 +4677,40 @@ interface and may change in the future.</para>
>  	    conversion.
>  	    </entry>
>  	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_TEST_PATTERN_RED</constant></entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Test pattern red colour component.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_TEST_PATTERN_GREENR</constant></entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Test pattern green (next to red)
> +	    colour component.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_TEST_PATTERN_BLUE</constant></entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Test pattern blue colour component.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_TEST_PATTERN_GREENB</constant></entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Test pattern green (next to blue)
> +	    colour component.
> +	    </entry>
> +	  </row>
>  	  <row><entry></entry></row>
>  	</tbody>
>        </tgroup>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 55c6832..a4104a7 100644
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
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 2ac5597..5c55a19 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -855,6 +855,10 @@ enum v4l2_jpeg_chroma_subsampling {
>  #define V4L2_CID_VBLANK				(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 1)
>  #define V4L2_CID_HBLANK				(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 2)
>  #define V4L2_CID_ANALOGUE_GAIN			(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 3)
> +#define V4L2_CID_TEST_PATTERN_RED		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 4)
> +#define V4L2_CID_TEST_PATTERN_GREENR		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 5)
> +#define V4L2_CID_TEST_PATTERN_BLUE		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 6)
> +#define V4L2_CID_TEST_PATTERN_GREENB		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 7)
>  
>  
>  /* Image processing controls */
> 

