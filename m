Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:58508 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752186AbeBTPY6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Feb 2018 10:24:58 -0500
Subject: Re: [RFCv4 11/21] media: v4l2_fh: add request entity field
To: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180220044425.169493-1-acourbot@chromium.org>
 <20180220044425.169493-12-acourbot@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5b0fcac9-18e1-433f-7977-2a90f3d961f8@xs4all.nl>
Date: Tue, 20 Feb 2018 16:24:53 +0100
MIME-Version: 1.0
In-Reply-To: <20180220044425.169493-12-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/20/18 05:44, Alexandre Courbot wrote:
> Allow drivers to assign a request entity to v4l2_fh. This will be useful
> for request-aware ioctls to find out which request entity to use.
> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  include/media/v4l2-fh.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
> index ea73fef8bdc0..f54cb319dd64 100644
> --- a/include/media/v4l2-fh.h
> +++ b/include/media/v4l2-fh.h
> @@ -28,6 +28,7 @@
>  
>  struct video_device;
>  struct v4l2_ctrl_handler;
> +struct media_request_entity;
>  
>  /**
>   * struct v4l2_fh - Describes a V4L2 file handler
> @@ -43,6 +44,7 @@ struct v4l2_ctrl_handler;
>   * @navailable: number of available events at @available list
>   * @sequence: event sequence number
>   * @m2m_ctx: pointer to &struct v4l2_m2m_ctx
> + * @entity: the request entity this fh operates on behalf of
>   */
>  struct v4l2_fh {
>  	struct list_head	list;
> @@ -60,6 +62,7 @@ struct v4l2_fh {
>  #if IS_ENABLED(CONFIG_V4L2_MEM2MEM_DEV)
>  	struct v4l2_m2m_ctx	*m2m_ctx;
>  #endif
> +	struct media_request_entity *entity;

The name 'media_request_entity' is very confusing.

In the media controller API terminology an entity represents a piece
of hardware with inputs and outputs (very rough description), but a
request is not an entity. It may be associated with an entity, though.

So calling this field 'entity' is also very misleading.

As with previous patches, I'll have to think about this and try and
come up with better, less confusing names.

Regards,

	Hans

>  };
>  
>  /**
> 
