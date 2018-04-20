Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:44894 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754899AbeDTNsQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 09:48:16 -0400
Subject: Re: [PATCH v2 02/10] media-request: Add a request complete operation
 to allow m2m scheduling
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
 <20180419154124.17512-3-paul.kocialkowski@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2bf8e1f2-796a-c25e-c8cf-8795ed55850a@xs4all.nl>
Date: Fri, 20 Apr 2018 15:48:11 +0200
MIME-Version: 1.0
In-Reply-To: <20180419154124.17512-3-paul.kocialkowski@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/19/18 17:41, Paul Kocialkowski wrote:
> When using the request API in the context of a m2m driver, the
> operations that come with a m2m run scheduling call in their
> (m2m-specific) ioctl handler are delayed until the request is queued
> (for instance, this includes queuing buffers and streamon).
> 
> Thus, the m2m run scheduling calls are not called in due time since the
> request AP's internal plumbing will (rightfully) use the relevant core
> functions directly instead of the ioctl handler.
> 
> This ends up in a situation where nothing happens if there is no
> run-scheduling ioctl called after queuing the request.
> 
> In order to circumvent the issue, a new media operation is introduced,
> called at the time of handling the media request queue ioctl. It gives
> m2m drivers a chance to schedule a m2m device run at that time.
> 
> The existing req_queue operation cannot be used for this purpose, since
> it is called with the request queue mutex held, that is eventually needed
> in the device_run call to apply relevant controls.

I'll need to think about this a bit more. I understand the problem so something
needs to be done. I would like to avoid adding yet another op, though.

Regards,

	Hans

> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  drivers/media/media-request.c | 3 +++
>  include/media/media-device.h  | 2 ++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/media/media-request.c b/drivers/media/media-request.c
> index 415f7e31019d..28ac5ccfe6a2 100644
> --- a/drivers/media/media-request.c
> +++ b/drivers/media/media-request.c
> @@ -157,6 +157,9 @@ static long media_request_ioctl_queue(struct media_request *req)
>  		media_request_get(req);
>  	}
>  
> +	if (mdev->ops->req_complete)
> +		mdev->ops->req_complete(req);
> +
>  	return ret;
>  }
>  
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 07e323c57202..c7dcf2079cc9 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -55,6 +55,7 @@ struct media_entity_notify {
>   * @req_alloc: Allocate a request
>   * @req_free: Free a request
>   * @req_queue: Queue a request
> + * @req_complete: Complete a request
>   */
>  struct media_device_ops {
>  	int (*link_notify)(struct media_link *link, u32 flags,
> @@ -62,6 +63,7 @@ struct media_device_ops {
>  	struct media_request *(*req_alloc)(struct media_device *mdev);
>  	void (*req_free)(struct media_request *req);
>  	int (*req_queue)(struct media_request *req);
> +	void (*req_complete)(struct media_request *req);
>  };
>  
>  /**
> 
