Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31673 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbbEZNTy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 09:19:54 -0400
Message-id: <5564371E.2040705@samsung.com>
Date: Tue, 26 May 2015 11:04:30 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	sakari.ailus@iki.fi
Subject: Re: [PATCH v9 8/8] exynos4-is: Add support for v4l2-flash subdevs
References: <1432566843-6391-1-git-send-email-j.anaszewski@samsung.com>
 <1432566843-6391-9-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1432566843-6391-9-git-send-email-j.anaszewski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/05/15 17:14, Jacek Anaszewski wrote:
> This patch adds support for external v4l2-flash devices.
> The support includes parsing "camera-flashes" DT property

"samsung,camera-flashes" ?

> and asynchronous sub-device registration.

> +static int fimc_md_register_flash_entities(struct fimc_md *fmd)
> +{
> +	struct device_node *parent = fmd->pdev->dev.of_node, *np_sensor,
> +		*np_flash;
> +	struct v4l2_async_notifier *notifier = &fmd->subdev_notifier;
> +	struct v4l2_async_subdev *asd;
> +	int i, j, num_flashes = 0, num_elems;
> +
> +	num_elems = of_property_count_elems_of_size(parent,
> +				"samsung,camera-flashes", sizeof(np_flash));

I think this should be of_property_count_u32_elems(), phandle is always
a 32-bit value [1], while size of a pointer depends on the architecture.


> +	/* samsung,camera-flashes property is optional */
> +	if (num_elems < 0)
> +		return 0;
> +
> +	/* samsung,camera-flashes array must have even number of elements */
> +	if ((num_elems & 1) || (num_elems > FIMC_MAX_SENSORS * 2))
> +		return -EINVAL;
> +
> +	for (i = 0; i < num_elems; i += 2) {
> +		np_sensor = of_parse_phandle(parent,
> +					     "samsung,camera-flashes", i);
> +
> +		for (j = 0; j < fmd->num_sensors; j++)
> +			if (fmd->async_subdevs.sensors[j].match.of.node ==
> +			    np_sensor)
> +				break;
> +
> +		of_node_put(np_sensor);

Would be good to add some comment here, why is the sensor required.
It's just a DT correctness check? Couldn't we carry on with the flash
registration after just emitting some warning?

> +		if (j == fmd->num_sensors)
> +			continue;
> +
> +		np_flash = of_parse_phandle(parent, "samsung,camera-flashes",
> +						i + 1);
> +
> +		asd = &fmd->async_subdevs.flashes[num_flashes++];
> +		asd->match_type = V4L2_ASYNC_MATCH_OF;
> +		asd->match.of.node = np_flash;
> +		notifier->subdevs[notifier->num_subdevs++] = asd;
> +
> +		of_node_put(np_flash);
> +	}
> +
> +	return 0;
> +}

Otherwise looks good to me.

-- 
Thanks,
Sylwester

[1]
http://lxr.free-electrons.com/source/Documentation/devicetree/booting-without-of.txt#L545

