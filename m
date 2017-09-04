Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:49055 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753694AbdIDN2J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 09:28:09 -0400
Subject: Re: [PATCH v7 07/18] omap3isp: Fix check for our own sub-devices
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
 <20170903174958.27058-8-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f8a4ba8c-f749-26ab-0897-c929b3f23e9f@xs4all.nl>
Date: Mon, 4 Sep 2017 15:28:04 +0200
MIME-Version: 1.0
In-Reply-To: <20170903174958.27058-8-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2017 07:49 PM, Sakari Ailus wrote:
> We only want to link sub-devices that were bound to the async notifier the
> isp driver registered but there may be other sub-devices in the
> v4l2_device as well. Check for the correct async notifier.

Just to be sure I understand this correctly: the original code wasn't wrong as such,
but this new test is just more precise.

Right?

	Hans

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/platform/omap3isp/isp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index a546cf774d40..3b1a9cd0e591 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2155,7 +2155,7 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
>  		return ret;
>  
>  	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
> -		if (!sd->asd)
> +		if (sd->notifier != &isp->notifier)
>  			continue;
>  
>  		ret = isp_link_entity(isp, &sd->entity,
> 
