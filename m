Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:52816 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754336AbcHDKND (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 06:13:03 -0400
Subject: Re: [PATCH] V4L2: Add documentation for SDI timings and related flags
To: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
	linux-media@vger.kernel.org
References: <1469113476-1645-1-git-send-email-charles-antoine.couret@nexvision.fr>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <080c0d20-6268-f1a0-9120-d6e4909bdcd5@xs4all.nl>
Date: Thu, 4 Aug 2016 12:11:34 +0200
MIME-Version: 1.0
In-Reply-To: <1469113476-1645-1-git-send-email-charles-antoine.couret@nexvision.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/21/2016 05:04 PM, Charles-Antoine Couret wrote:
> Signed-off-by: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
> ---
>  Documentation/media/uapi/v4l/vidioc-enuminput.rst  | 31 +++++++++++++++++-----
>  .../media/uapi/v4l/vidioc-g-dv-timings.rst         | 15 +++++++++++
>  2 files changed, 39 insertions(+), 7 deletions(-)
> 

<snip>

> diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
> index f7bf21f..9acfa19 100644
> --- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
> @@ -339,6 +339,13 @@ EBUSY
>  
>         -  The timings follow the VESA Generalized Timings Formula standard
>  
> +    -  .. row 7
> +
> +       -  ``V4L2_DV_BT_STD_SDI``
> +
> +       -  The timings follow the SDI Timings standard.
> +	  There are no horizontal syncs/porches at all in this format.
> +	  Total blanking timings must be set in hsync or vsync fields only.

Didn't you mention on irc that there are actually two blanking timings for
vertical blanking? Something frontporch like? I can't remember the details,
but if I remember correctly, then you should specify what goes where.

Regards,

	Hans

>  
>  
>  .. _dv-bt-flags:
> @@ -415,3 +422,11 @@ EBUSY
>  	  R'G'B' values use limited range (i.e. 16-235) as opposed to full
>  	  range (i.e. 0-255). All formats defined in CEA-861 except for the
>  	  640x480p59.94 format are CE formats.
> +
> +    -  .. row 8
> +
> +       -  ``V4L2_DV_FL_FIRST_FIELD_EXTRA_LINE``
> +
> +       -  Some formats like SMPTE-125M have an interlaced signal with a odd
> +	  total height. For these formats, if this flag is set, the first
> +	  field has the extra line. Else, it is the second field.
> 
