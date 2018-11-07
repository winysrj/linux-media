Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:47539 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbeKHAiI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Nov 2018 19:38:08 -0500
Subject: Re: [PATCH 1/1] v4l: uAPI doc: Simplify NATIVE_SIZE selection target
 documentation
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: p.zabel@pengutronix.de
References: <20181107150449.24956-1-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2e6b7a4b-cf41-b08a-690a-4d63c9edbabc@xs4all.nl>
Date: Wed, 7 Nov 2018 16:07:18 +0100
MIME-Version: 1.0
In-Reply-To: <20181107150449.24956-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/07/18 16:04, Sakari Ailus wrote:
> The NATIVE_SIZE target is documented for mem2mem devices but no driver has
> ever apparently used it. It may be never needed; remove it for now.
> 
> Suggested-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks,

	Hans

> ---
>  Documentation/media/uapi/v4l/v4l2-selection-targets.rst | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/v4l2-selection-targets.rst b/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
> index 87433ec76c6b..bee31611947e 100644
> --- a/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
> +++ b/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
> @@ -42,12 +42,7 @@ of the two interfaces they are used.
>      * - ``V4L2_SEL_TGT_NATIVE_SIZE``
>        - 0x0003
>        - The native size of the device, e.g. a sensor's pixel array.
> -	``left`` and ``top`` fields are zero for this target. Setting the
> -	native size will generally only make sense for memory to memory
> -	devices where the software can create a canvas of a given size in
> -	which for example a video frame can be composed. In that case
> -	V4L2_SEL_TGT_NATIVE_SIZE can be used to configure the size of
> -	that canvas.
> +	``left`` and ``top`` fields are zero for this target.
>        - Yes
>        - Yes
>      * - ``V4L2_SEL_TGT_COMPOSE``
> 
