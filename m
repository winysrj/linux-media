Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:34913 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1947994AbdDYOaG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 10:30:06 -0400
Received: by mail-lf0-f47.google.com with SMTP id 75so91749626lfs.2
        for <linux-media@vger.kernel.org>; Tue, 25 Apr 2017 07:30:05 -0700 (PDT)
Date: Tue, 25 Apr 2017 16:30:02 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Kieran Bingham <kbingham@kernel.org>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH 2/2] rcar-vin: group: use correct of_node
Message-ID: <20170425143002.GB4676@bigcity.dyn.berto.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
 <1493057666-27961-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1493057666-27961-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for your patch.

On 2017-04-24 19:14:26 +0100, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> The unbind function dereferences the subdev->dev node to obtain the
> of_node. In error paths, the subdev->dev can be set to NULL, whilst the
> correct reference to the of_node is available as subdev->of_node.
> 
> Correct the dereferencing, and move the variable outside of the loop as
> it is constant against the subdev, and not initialised per CSI, for both
> the bind and unbind functions
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 48557628e76d..a530dc388b95 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -469,7 +469,7 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
>  
>  	v4l2_set_subdev_hostdata(subdev, vin);
>  
> -	if (vin->digital.asd.match.of.node == subdev->dev->of_node) {
> +	if (vin->digital.asd.match.of.node == subdev->of_node) {
>  		/* Find surce and sink pad of remote subdevice */

This code is already present in upstream. Could you break this out in a 
separate patch and resubmit it?

>  
>  		ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
> @@ -738,12 +738,11 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
>  				     struct v4l2_async_subdev *asd)
>  {
>  	struct rvin_dev *vin = notifier_to_vin(notifier);
> +	struct device_node *del = subdev->of_node;
>  	unsigned int i;
>  
>  	mutex_lock(&vin->group->lock);
>  	for (i = 0; i < RVIN_CSI_MAX; i++) {
> -		struct device_node *del = subdev->dev->of_node;
> -
>  		if (vin->group->bridge[i].asd.match.of.node == del) {
>  			vin_dbg(vin, "Unbind bridge %s\n", subdev->name);
>  			vin->group->bridge[i].subdev = NULL;
> @@ -768,13 +767,13 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
>  				   struct v4l2_async_subdev *asd)
>  {
>  	struct rvin_dev *vin = notifier_to_vin(notifier);
> +	struct device_node *new = subdev->of_node;
>  	unsigned int i;
>  
>  	v4l2_set_subdev_hostdata(subdev, vin);
>  
>  	mutex_lock(&vin->group->lock);
>  	for (i = 0; i < RVIN_CSI_MAX; i++) {
> -		struct device_node *new = subdev->dev->of_node;
>  
>  		if (vin->group->bridge[i].asd.match.of.node == new) {
>  			vin_dbg(vin, "Bound bridge %s\n", subdev->name);

And I will squash these fixes in to the next version of my 'Gen3 with 
media controller support' series since that is not yet picked up. Is 
that OK with you?

> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
