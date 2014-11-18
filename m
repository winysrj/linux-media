Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49229 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752060AbaKRI4p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 03:56:45 -0500
Message-ID: <546B09A0.7060705@xs4all.nl>
Date: Tue, 18 Nov 2014 09:56:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
CC: hans.verkuil@xs4all.nl
Subject: Re: [REVIEW PATCH v2 3/5] v4l: Add intput and output capability flags
 for native size setting
References: <1416289220-32673-1-git-send-email-sakari.ailus@iki.fi> <1416289220-32673-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1416289220-32673-4-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

A few notes:

Typo in subject: intput -> input

On 11/18/14 06:40, Sakari Ailus wrote:
> Add input and output capability flags for setting native size of the device,
> and document them.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/vidioc-enuminput.xml  |    8 ++++++++
>  Documentation/DocBook/media/v4l/vidioc-enumoutput.xml |    8 ++++++++
>  include/uapi/linux/videodev2.h                        |    2 ++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
> index 493a39a..603fece 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
> @@ -287,6 +287,14 @@ input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
>  	    <entry>0x00000004</entry>
>  	    <entry>This input supports setting the TV standard by using VIDIOC_S_STD.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_IN_CAP_NATIVE_SIZE</constant></entry>
> +	    <entry>0x00000008</entry>
> +	    <entry>This input supports setting the native size using
> +	    the <constant>V4L2_SEL_TGT_NATIVE_SIZE</constant>
> +	    selection target, see <xref
> +	    linkend="v4l2-selections-common"/>.</entry>
> +	  </row>

I would expand on this a little bit (or alternatively add that to the
V4L2_SEL_TGT_NATIVE_SIZE documentation itself, at your discretion):

"Setting the native size will generally only make sense for memory
to memory devices where the software can create a canvas of a given
size in which for example a video frame can be composed. In that case
V4L2_SEL_TGT_NATIVE_SIZE can be used to configure the size of that
canvas."

Or words to that effect.

Regards,

	Hans

>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml b/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
> index 2654e09..773fb12 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
> @@ -172,6 +172,14 @@ input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
>  	    <entry>0x00000004</entry>
>  	    <entry>This output supports setting the TV standard by using VIDIOC_S_STD.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_OUT_CAP_NATIVE_SIZE</constant></entry>
> +	    <entry>0x00000008</entry>
> +	    <entry>This output supports setting the native size using
> +	    the <constant>V4L2_SEL_TGT_NATIVE_SIZE</constant>
> +	    selection target, see <xref
> +	    linkend="v4l2-selections-common"/>.</entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 1c2f84f..e445b48 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1249,6 +1249,7 @@ struct v4l2_input {
>  #define V4L2_IN_CAP_DV_TIMINGS		0x00000002 /* Supports S_DV_TIMINGS */
>  #define V4L2_IN_CAP_CUSTOM_TIMINGS	V4L2_IN_CAP_DV_TIMINGS /* For compatibility */
>  #define V4L2_IN_CAP_STD			0x00000004 /* Supports S_STD */
> +#define V4L2_IN_CAP_NATIVE_SIZE		0x00000008 /* Supports setting native size */
>  
>  /*
>   *	V I D E O   O U T P U T S
> @@ -1272,6 +1273,7 @@ struct v4l2_output {
>  #define V4L2_OUT_CAP_DV_TIMINGS		0x00000002 /* Supports S_DV_TIMINGS */
>  #define V4L2_OUT_CAP_CUSTOM_TIMINGS	V4L2_OUT_CAP_DV_TIMINGS /* For compatibility */
>  #define V4L2_OUT_CAP_STD		0x00000004 /* Supports S_STD */
> +#define V4L2_OUT_CAP_NATIVE_SIZE	0x00000008 /* Supports setting native size */
>  
>  /*
>   *	C O N T R O L S
> 

