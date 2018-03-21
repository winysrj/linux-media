Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:53997 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbeCUH0n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 03:26:43 -0400
Received: by mail-it0-f66.google.com with SMTP id b136-v6so5649176iti.3
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2018 00:26:43 -0700 (PDT)
Subject: Re: [PATCH] media: ov5645: add missing of_node_put() in error path
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1521476057-28792-1-git-send-email-akinobu.mita@gmail.com>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <9164528c-fbd0-51e1-a94d-29d72735d1e1@linaro.org>
Date: Wed, 21 Mar 2018 15:26:39 +0800
MIME-Version: 1.0
In-Reply-To: <1521476057-28792-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you Akinobu.

Acked-by: Todor Tomov <todor.tomov@linaro.org>

On 20.03.2018 00:14, Akinobu Mita wrote:
> The device node obtained with of_graph_get_next_endpoint() should be
> released by calling of_node_put().  But it was not released when
> v4l2_fwnode_endpoint_parse() failed.
> 
> This change moves the of_node_put() call before the error check and
> fixes the issue.
> 
> Cc: Todor Tomov <todor.tomov@linaro.org>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  drivers/media/i2c/ov5645.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
> index d28845f..a31fe18 100644
> --- a/drivers/media/i2c/ov5645.c
> +++ b/drivers/media/i2c/ov5645.c
> @@ -1131,13 +1131,14 @@ static int ov5645_probe(struct i2c_client *client,
>  
>  	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint),
>  					 &ov5645->ep);
> +
> +	of_node_put(endpoint);
> +
>  	if (ret < 0) {
>  		dev_err(dev, "parsing endpoint node failed\n");
>  		return ret;
>  	}
>  
> -	of_node_put(endpoint);
> -
>  	if (ov5645->ep.bus_type != V4L2_MBUS_CSI2) {
>  		dev_err(dev, "invalid bus type, must be CSI2\n");
>  		return -EINVAL;
> 
