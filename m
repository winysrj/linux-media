Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:60356 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753648AbaCaKKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 06:10:41 -0400
Message-ID: <53393F1D.1030603@codethink.co.uk>
Date: Mon, 31 Mar 2014 11:10:37 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
MIME-Version: 1.0
To: Josh Wu <josh.wu@atmel.com>
CC: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: Re: [RFCv3,3/3] soc_camera: initial of code
References: <1396216471-11532-3-git-send-email-ben.dooks@codethink.co.uk> <1396258114-30124-1-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1396258114-30124-1-git-send-email-josh.wu@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31/03/14 10:28, Josh Wu wrote:
> Hi, Ben
>
> Thanks for the patch, I just test atmel-isi with the your patch,
> I find the "mclk" registered in soc-camera driver cannot be find
> by the soc-camera sensors. See comment in below:

Ok, I guess that the driver I have does not need the
mclk clock.

>
>> ... ...
>
>> +#ifdef CONFIG_OF
>> +static int soc_of_bind(struct soc_camera_host *ici,
>> +		       struct device_node *ep,
>> +		       struct device_node *remote)
>> +{
>> +	struct soc_camera_device *icd;
>> +	struct soc_camera_desc sdesc = {.host_desc.bus_id = ici->nr,};
>> +	struct soc_camera_async_client *sasc;
>> +	struct soc_camera_async_subdev *sasd;
>> +	struct v4l2_async_subdev **asd_array;
>> +	char clk_name[V4L2_SUBDEV_NAME_SIZE];
>> +	int ret;
>> +
>> +	/* alloacte a new subdev and add match info to it */
>> +	sasd = devm_kzalloc(ici->v4l2_dev.dev, sizeof(*sasd), GFP_KERNEL);
>> +	if (!sasd)
>> +		return -ENOMEM;
>> +
>> +	asd_array = devm_kzalloc(ici->v4l2_dev.dev,
>> +				 sizeof(struct v4l2_async_subdev **),
>> +				 GFP_KERNEL);
>> +	if (!asd_array)
>> +		return -ENOMEM;
>> +
>> +	sasd->asd.match.of.node = remote;
>> +	sasd->asd.match_type = V4L2_ASYNC_MATCH_OF;
>> +	asd_array[0] = &sasd->asd;
>> +
>> +	/* Or shall this be managed by the soc-camera device? */
>> +	sasc = devm_kzalloc(ici->v4l2_dev.dev, sizeof(*sasc), GFP_KERNEL);
>> +	if (!sasc)
>> +		return -ENOMEM;
>> +
>> +	/* HACK: just need a != NULL */
>> +	sdesc.host_desc.board_info = ERR_PTR(-ENODATA);
>> +
>> +	ret = soc_camera_dyn_pdev(&sdesc, sasc);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	sasc->sensor = &sasd->asd;
>> +
>> +	icd = soc_camera_add_pdev(sasc);
>> +	if (!icd) {
>> +		platform_device_put(sasc->pdev);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	//sasc->notifier.subdevs = asd;
>> +	sasc->notifier.subdevs = asd_array;
>> +	sasc->notifier.num_subdevs = 1;
>> +	sasc->notifier.bound = soc_camera_async_bound;
>> +	sasc->notifier.unbind = soc_camera_async_unbind;
>> +	sasc->notifier.complete = soc_camera_async_complete;
>> +
>> +	icd->sasc = sasc;
>> +	icd->parent = ici->v4l2_dev.dev;
>> +
>> +	snprintf(clk_name, sizeof(clk_name), "of-%s",
>> +		 of_node_full_name(remote));
>
> The clk_name you register here is a OF string, but for the i2c sensors, which
> call the v4l2_clk_get by using dev_name(&client->dev). It is format like:
> "1-0030", combined i2c adaptor ID and addr.
> So the i2c sensor can not find this registered mclk as the name is not match.

Hmm, this sounds like something that really should go
away and be handled by the clk system instead.

[snip]


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
