Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:7268 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbbEDOJk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 10:09:40 -0400
Message-ID: <55477DA3.20002@cisco.com>
Date: Mon, 04 May 2015 16:09:39 +0200
From: "Mats Randgaard (matrandg)" <matrandg@cisco.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [RFC 02/12] [media] tc358743: register v4l2 asynchronous subdevice
References: <1427713856-10240-1-git-send-email-p.zabel@pengutronix.de> <1427713856-10240-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427713856-10240-3-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/30/2015 01:10 PM, Philipp Zabel wrote:
> Add support for registering the sensor subdevice using the v4l2-async API.
>
> Signed-off-by: Philipp Zabel<p.zabel@pengutronix.de>
> ---
>   drivers/media/i2c/tc358743.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> index a86cbe0..dfc10f0 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -1711,6 +1711,16 @@ static int tc358743_probe(struct i2c_client *client,
>   		goto err_hdl;
>   	}
>   
> +	state->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	err = media_entity_init(&sd->entity, 1, &state->pad, 0);
> +	if (err < 0)
> +		goto err_hdl;
> +
> +	sd->dev = &client->dev;

sd->dev = &client->dev is already done by v4l2_i2c_subdev_init() ~50 
lines above

The rest of the code seems fine to me, but I can not test it since the 
kernel we use is too old to support async subdevs.

Regards,
Mats Randgaard

> +	err = v4l2_async_register_subdev(sd);
> +	if (err < 0)
> +		goto err_hdl;
> +
>   	INIT_DELAYED_WORK(&state->delayed_work_enable_hotplug,
>   			tc358743_delayed_work_enable_hotplug);
>   
> @@ -1731,6 +1741,7 @@ static int tc358743_probe(struct i2c_client *client,
>   	return 0;
>   
>   err_hdl:
> +	media_entity_cleanup(&sd->entity);
>   	v4l2_ctrl_handler_free(&state->hdl);
>   	return err;
>   }
> @@ -1742,6 +1753,7 @@ static int tc358743_remove(struct i2c_client *client)
>   
>   	cancel_delayed_work(&state->delayed_work_enable_hotplug);
>   	destroy_workqueue(state->work_queues);
> +	v4l2_async_unregister_subdev(sd);
>   	v4l2_device_unregister_subdev(sd);
>   	v4l2_ctrl_handler_free(&state->hdl);
>   

