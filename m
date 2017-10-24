Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:50318 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932533AbdJXMvY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Oct 2017 08:51:24 -0400
Subject: Re: [RFC v4 01/17] [media] v4l: create v4l2_event_subscribe_v4l2()
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20171020215012.20646-1-gustavo@padovan.org>
 <20171020215012.20646-2-gustavo@padovan.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <49438973-5ae5-c6dd-4abc-41feaab5806c@xs4all.nl>
Date: Tue, 24 Oct 2017 14:51:16 +0200
MIME-Version: 1.0
In-Reply-To: <20171020215012.20646-2-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/20/2017 11:49 PM, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> We need a common function to subscribe all the common events in drivers,
> so far we had only V4L2_EVENT_CTRL, so such a function wasn't necessary,
> but we are about to introduce a new event for the upcoming explicit fences
> implementation, thus a common place is needed.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/v4l2-core/v4l2-event.c | 12 ++++++++++++
>  include/media/v4l2-event.h           |  8 ++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
> index 968c2eb08b5a..313ee9d1f9ee 100644
> --- a/drivers/media/v4l2-core/v4l2-event.c
> +++ b/drivers/media/v4l2-core/v4l2-event.c
> @@ -20,6 +20,7 @@
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-event.h>
> +#include <media/v4l2-ctrls.h>
>  
>  #include <linux/mm.h>
>  #include <linux/sched.h>
> @@ -354,3 +355,14 @@ int v4l2_src_change_event_subdev_subscribe(struct v4l2_subdev *sd,
>  	return v4l2_src_change_event_subscribe(fh, sub);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_src_change_event_subdev_subscribe);
> +
> +int v4l2_subscribe_event_v4l2(struct v4l2_fh *fh,
> +			      const struct v4l2_event_subscription *sub)
> +{
> +	switch (sub->type) {
> +	case V4L2_EVENT_CTRL:
> +		return v4l2_ctrl_subscribe_event(fh, sub);
> +	}
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL(v4l2_subscribe_event_v4l2);
> diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
> index 6741910c3a18..2b794f2ad824 100644
> --- a/include/media/v4l2-event.h
> +++ b/include/media/v4l2-event.h
> @@ -236,4 +236,12 @@ int v4l2_src_change_event_subscribe(struct v4l2_fh *fh,
>  int v4l2_src_change_event_subdev_subscribe(struct v4l2_subdev *sd,
>  					   struct v4l2_fh *fh,
>  					   struct v4l2_event_subscription *sub);
> +/**
> + * v4l2_subscribe_event_v4l2 - helper function that subscribe all v4l2 events
> + *
> + * @fh: pointer to struct v4l2_fh
> + * @sub: pointer to &struct v4l2_event_subscription
> + */
> +int v4l2_subscribe_event_v4l2(struct v4l2_fh *fh,

Why the _v4l2 suffix? It's weird and I think you can just drop it. Otherwise this looks good.

Regards,

	Hans

> +			      const struct v4l2_event_subscription *sub);
>  #endif /* V4L2_EVENT_H */
> 
