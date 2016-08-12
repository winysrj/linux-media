Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:42558 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962AbcHLNRr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 09:17:47 -0400
Subject: Re: [PATCH v2] V4L2: Add documentation for SDI timings and related
 flags
To: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
	linux-media@vger.kernel.org
References: <1470325151-14522-1-git-send-email-charles-antoine.couret@nexvision.fr>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <574b72df-b860-4568-8828-1f88e49c8d06@xs4all.nl>
Date: Fri, 12 Aug 2016 15:17:41 +0200
MIME-Version: 1.0
In-Reply-To: <1470325151-14522-1-git-send-email-charles-antoine.couret@nexvision.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/04/2016 05:39 PM, Charles-Antoine Couret wrote:

A commit log is missing here.

> Signed-off-by: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
> ---
>  Documentation/media/uapi/v4l/vidioc-enuminput.rst  | 31 +++++++++++++++++-----
>  .../media/uapi/v4l/vidioc-g-dv-timings.rst         | 16 +++++++++++
>  2 files changed, 40 insertions(+), 7 deletions(-)
> 

<snip>

> diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
> index f7bf21f..0205bf6 100644
> --- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
> @@ -339,6 +339,14 @@ EBUSY
>  
>         -  The timings follow the VESA Generalized Timings Formula standard
>  
> +    -  .. row 7
> +
> +       -  ``V4L2_DV_BT_STD_SDI``
> +
> +       -  The timings follow the SDI Timings standard.
> +	  There are not always horizontal syncs/porches or similar in this format.
> +	  If it is not precised by standard, blanking timings must be set in
> +	  hsync or vsync fields by default.

OK. This is confusing. The text was changed after my question about something porch-like
in the SMPTE-125M standard. But I see nothing like that after re-reading it.

So what sort of 'porch' timing were you thinking of?

I wonder if I shouldn't just use the text from your first patch:

       -  ``V4L2_DV_BT_STD_SDI``

       -  The timings follow the SDI Timings standard.
	  There are no horizontal syncs/porches at all in this format.
	  Total blanking timings must be set in hsync or vsync fields only.

Regards,

	Hans
