Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:55680 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754934AbeDTNim (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 09:38:42 -0400
Subject: Re: [PATCH v2 01/10] media: v4l2-ctrls: Add missing v4l2 ctrl unlock
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
 <20180419154124.17512-2-paul.kocialkowski@bootlin.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <47861cbd-e385-66c0-798d-f6ff3f454bac@xs4all.nl>
Date: Fri, 20 Apr 2018 15:38:32 +0200
MIME-Version: 1.0
In-Reply-To: <20180419154124.17512-2-paul.kocialkowski@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/19/18 17:41, Paul Kocialkowski wrote:
> This adds a missing v4l2_ctrl_unlock call that is required to avoid
> deadlocks.
> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index f67e9f5531fa..ba05a8b9a095 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -3614,10 +3614,12 @@ void v4l2_ctrl_request_complete(struct media_request *req,
>  			continue;
>  
>  		v4l2_ctrl_lock(ctrl);
> +
>  		if (ref->req)
>  			ptr_to_ptr(ctrl, ref->req->p_req, ref->p_req);
>  		else
>  			ptr_to_ptr(ctrl, ctrl->p_cur, ref->p_req);
> +
>  		v4l2_ctrl_unlock(ctrl);
>  	}
>  
> @@ -3677,8 +3679,11 @@ void v4l2_ctrl_request_setup(struct media_request *req,
>  				}
>  			}
>  		}
> -		if (!have_new_data)
> +
> +		if (!have_new_data) {
> +			v4l2_ctrl_unlock(master);
>  			continue;
> +		}

Oops! Thanks for finding this. I'll fold this into the relevant patch in my tree.

>  
>  		for (i = 0; i < master->ncontrols; i++) {
>  			if (master->cluster[i]) {
> 

Regards,

	Hans
