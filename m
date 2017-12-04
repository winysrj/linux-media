Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:60973 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751156AbdLDJpq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Dec 2017 04:45:46 -0500
Subject: Re: [PATCH v8 03/28] rcar-vin: unregister video device on driver
 removal
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <20171129194342.26239-1-niklas.soderlund+renesas@ragnatech.se>
 <20171129194342.26239-4-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5e305596-e4c4-ac51-78c5-63449196eda8@xs4all.nl>
Date: Mon, 4 Dec 2017 10:45:41 +0100
MIME-Version: 1.0
In-Reply-To: <20171129194342.26239-4-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/29/2017 08:43 PM, Niklas Söderlund wrote:
> If the video device was registered by the complete() callback it should
> be unregistered when the driver is removed. Protect from printing a
> uninitialized video device node name by adding a checking in
> rvin_v4l2_unregister() by checking that the video device is registered.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 2 ++
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 +++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index f7a4c21909da6923..6d99542ec74b49a7 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -272,6 +272,8 @@ static int rcar_vin_remove(struct platform_device *pdev)
>  
>  	pm_runtime_disable(&pdev->dev);
>  
> +	rvin_v4l2_unregister(vin);
> +
>  	v4l2_async_notifier_unregister(&vin->notifier);
>  	v4l2_async_notifier_cleanup(&vin->notifier);
>  
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 178aecc94962abe2..32a658214f48fa49 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -841,6 +841,9 @@ static const struct v4l2_file_operations rvin_fops = {
>  
>  void rvin_v4l2_unregister(struct rvin_dev *vin)
>  {
> +	if (!video_is_registered(&vin->vdev))
> +		return;
> +
>  	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
>  		  video_device_node_name(&vin->vdev));
>  
> 
