Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33790 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JETLl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 15:11:41 -0400
Message-ID: <506F30E8.10206@gmail.com>
Date: Fri, 05 Oct 2012 21:11:36 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 10/14] media: soc-camera: support OF cameras
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <1348754853-28619-11-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1348754853-28619-11-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/27/2012 04:07 PM, Guennadi Liakhovetski wrote:
> With OF we aren't getting platform data any more. To minimise changes we
> create all the missing data ourselves, including compulsory struct
> soc_camera_link objects. Host-client linking is now done, based on the OF
> data. Media bus numbers also have to be assigned dynamically.
>
> Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> ---
...
>   static int soc_camera_i2c_notify(struct notifier_block *nb,
>   				 unsigned long action, void *data)
>   {
> @@ -1203,13 +1434,20 @@ static int soc_camera_i2c_notify(struct notifier_block *nb,
>   	struct v4l2_subdev *subdev;
>   	int ret;
>
> -	if (client->addr != icl->board_info->addr ||
> -	    client->adapter->nr != icl->i2c_adapter_id)
> +	dev_dbg(dev, "%s(%lu): %x on %u\n", __func__, action,
> +		client->addr, client->adapter->nr);
> +
> +	if (!soc_camera_i2c_client_match(icl, client))
>   		return NOTIFY_DONE;
>
>   	switch (action) {
>   	case BUS_NOTIFY_BIND_DRIVER:
>   		client->dev.platform_data = icl;
> +		if (icl->of_link) {
> +			struct soc_camera_of_client *sofc = container_of(icl->of_link,
> +						struct soc_camera_of_client, of_link);
> +			soc_camera_of_i2c_ifill(sofc, client);
> +		}
>
>   		return NOTIFY_OK;
>   	case BUS_NOTIFY_BOUND_DRIVER:

There is no need for different handling of this event as well ?
Further, there is code like:

	adap = i2c_get_adapter(icl->i2c_adapter_id);

which is clearly not going to work in OF case. Could you clarify how
it is supposed to work ?

--

Thanks,
Sylwester
