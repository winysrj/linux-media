Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:34637 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751207AbcISRqS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 13:46:18 -0400
Subject: Re: [PATCH] [media] videodev2.h.rst.exceptions: fix warnings
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        no To-header on input <""@pop.xs4all.nl>
References: <69c7fd363abd3b5ea05fb4c5a89ab06b0b4c3383.1474306315.git.mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Nick Dyer <nick@shmanahar.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-doc@vger.kernel.org,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <073f8b37-beef-ea7e-6f2e-fcf0ff54a1ae@xs4all.nl>
Date: Mon, 19 Sep 2016 19:46:10 +0200
MIME-Version: 1.0
In-Reply-To: <69c7fd363abd3b5ea05fb4c5a89ab06b0b4c3383.1474306315.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2016 07:32 PM, Mauro Carvalho Chehab wrote:
> Changeset ab6343956f9c ("[media] V4L2: Add documentation for SDI timings
> and related flags") added documentation for new V4L2 defines, but
> it forgot to update videodev2.h.rst.exceptions to point to where
> the documentation for those new values will be inside the book,
> causing those warnings:
> 
>     Documentation/output/videodev2.h.rst:6: WARNING: undefined label: v4l2-dv-bt-std-sdi (if the link has no caption the label must precede a section header)
>     Documentation/output/videodev2.h.rst:6: WARNING: undefined label: v4l2-dv-fl-first-field-extra-line (if the link has no caption the label must precede a section header)
>     Documentation/output/videodev2.h.rst:6: WARNING: undefined label: v4l2-in-st-no-v-lock (if the link has no caption the label must precede a section header)
>     Documentation/output/videodev2.h.rst:6: WARNING: undefined label: v4l2-in-st-no-std-lock (if the link has no caption the label must precede a section header)
> 
> Fixes: ab6343956f9c ("[media] V4L2: Add documentation for SDI timings and related flags")
> 
> Cc: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

I *know* I made the same change, but it looks like I may have forgotten to push to
my git branch :-(

Anyway, this is obviously correct.

Regards,

	Hans

> ---
>  Documentation/media/videodev2.h.rst.exceptions | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
> index 3828a2983acb..1d3f27d922b2 100644
> --- a/Documentation/media/videodev2.h.rst.exceptions
> +++ b/Documentation/media/videodev2.h.rst.exceptions
> @@ -268,12 +268,14 @@ replace define V4L2_DV_BT_STD_CEA861 dv-bt-standards
>  replace define V4L2_DV_BT_STD_DMT dv-bt-standards
>  replace define V4L2_DV_BT_STD_CVT dv-bt-standards
>  replace define V4L2_DV_BT_STD_GTF dv-bt-standards
> +replace define V4L2_DV_BT_STD_SDI dv-bt-standards
>  
>  replace define V4L2_DV_FL_REDUCED_BLANKING dv-bt-standards
>  replace define V4L2_DV_FL_CAN_REDUCE_FPS dv-bt-standards
>  replace define V4L2_DV_FL_REDUCED_FPS dv-bt-standards
>  replace define V4L2_DV_FL_HALF_LINE dv-bt-standards
>  replace define V4L2_DV_FL_IS_CE_VIDEO dv-bt-standards
> +replace define V4L2_DV_FL_FIRST_FIELD_EXTRA_LINE dv-bt-standards
>  
>  replace define V4L2_DV_BT_656_1120 dv-timing-types
>  
> @@ -301,6 +303,8 @@ replace define V4L2_IN_ST_NO_CARRIER input-status
>  replace define V4L2_IN_ST_MACROVISION input-status
>  replace define V4L2_IN_ST_NO_ACCESS input-status
>  replace define V4L2_IN_ST_VTR input-status
> +replace define V4L2_IN_ST_NO_V_LOCK input-status
> +replace define V4L2_IN_ST_NO_STD_LOCK input-status
>  
>  replace define V4L2_IN_CAP_DV_TIMINGS input-capabilities
>  replace define V4L2_IN_CAP_STD input-capabilities
> 
