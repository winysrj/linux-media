Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:55302 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750726AbdGGO2B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 10:28:01 -0400
Subject: Re: [PATCH 1/1] docs-rst: v4l: Fix sink compose selection target
 documentation
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20170707142039.15954-1-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <50e2f7dc-5940-ff6c-0df3-ca950e951351@xs4all.nl>
Date: Fri, 7 Jul 2017 16:27:44 +0200
MIME-Version: 1.0
In-Reply-To: <20170707142039.15954-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/17 16:20, Sakari Ailus wrote:
> The rectangle which the sink compose rectangle is related to is documented
> to be the source compose bounds rectangle. This is in obvious conflict with
> the ground rule of the format propagation (from sink to source). The reason
> behind this is that this was always supposed to be the sink compose bounds
> rectangle. Fix it.
> 
> Fixes: 955f645aea04 ("[media] v4l: Add subdev selections documentation")
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Sooo much clearer now. It was terminally confusing...

Thanks,

	Hans

> ---
>  Documentation/media/uapi/v4l/dev-subdev.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
> index f0e762167730..2205a3abb2a9 100644
> --- a/Documentation/media/uapi/v4l/dev-subdev.rst
> +++ b/Documentation/media/uapi/v4l/dev-subdev.rst
> @@ -370,7 +370,7 @@ circumstances. This may also cause the accessed rectangle to be adjusted
>  by the driver, depending on the properties of the underlying hardware.
>  
>  The coordinates to a step always refer to the actual size of the
> -previous step. The exception to this rule is the source compose
> +previous step. The exception to this rule is the sink compose
>  rectangle, which refers to the sink compose bounds rectangle --- if it
>  is supported by the hardware.
>  
> 
