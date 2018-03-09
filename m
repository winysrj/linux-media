Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:41506 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932069AbeCIPQH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:16:07 -0500
Subject: Re: [PATCH v12 06/33] rcar-vin: move subdevice handling to async
 callbacks
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
 <20180307220511.9826-7-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <69f71ad0-c62e-aa37-6e9b-be2ddb3b1e03@xs4all.nl>
Date: Fri, 9 Mar 2018 16:16:03 +0100
MIME-Version: 1.0
In-Reply-To: <20180307220511.9826-7-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/18 23:04, Niklas Söderlund wrote:
> In preparation for Gen3 support move the subdevice initialization and
> clean up from rvin_v4l2_{register,unregister}() directly to the async
> callbacks. This simplifies the addition of Gen3 support as the
> rvin_v4l2_register() can be shared for both Gen2 and Gen3 while direct
> subdevice control are only used on Gen2.
> 
> While moving this code drop a large comment which is copied from the
> framework documentation and fold rvin_mbus_supported() into its only
> caller. Also move the initialization and cleanup code to separate
> functions to increase readability.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 108 +++++++++++++++++++---------
>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  35 ---------
>  2 files changed, 74 insertions(+), 69 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 47f06acde2e698f2..663309ca9c04f208 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -46,46 +46,88 @@ static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
>  	return -EINVAL;
>  }
>  
> -static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
> +/* The vin lock shuld be held when calling the subdevice attach and detach */

shuld -> should

Actually, I'd say 'shall' instead of 'should'.

After that trivial change you can add my:

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
