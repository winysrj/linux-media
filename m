Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:45775 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755343AbcIEJBZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 05:01:25 -0400
Subject: Re: [PATCH v5] [media] vimc: Virtual Media Controller core, capture
 and sensor
To: Helen Koike <helen.koike@collabora.co.uk>,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        jgebben@codeaurora.org, mchehab@osg.samsung.com
References: <5aae6086-6ba3-c278-ec48-043b17b4aa33@xs4all.nl>
 <1471471756-6114-1-git-send-email-helen.koike@collabora.co.uk>
 <ee909db9-eb2b-d81a-347a-fe12112aa1cf@xs4all.nl>
 <f231cdc7-1b31-6ac1-8e88-37b8b89e9fc2@collabora.co.uk>
Cc: Helen Fornazier <helen.fornazier@gmail.com>,
        Helen Koike <helen.koike@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <700a9e7b-0bb6-7923-6528-12d65c4f62b4@xs4all.nl>
Date: Mon, 5 Sep 2016 11:01:13 +0200
MIME-Version: 1.0
In-Reply-To: <f231cdc7-1b31-6ac1-8e88-37b8b89e9fc2@collabora.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/2016 10:05 PM, Helen Koike wrote:
> Hi Hans,
> 
> Thank you for your review.
> 
> On 2016-08-22 07:57 AM, Hans Verkuil wrote:
>> Hi Helen,
>>
>> A few small code comments are below.
>>
>> Note that if I try to capture I see these two messages in the kernel log:
>>
>> [588197.368145] vimc vimc.0: Entity type for entity Sensor A was not initialized!
>> [588197.368169] vimc vimc.0: Entity type for entity Sensor B was not initialized!
> 
> 
> I correct this, I am sending it in v6.
> 
> 
>>
>> I also can't capture anything: v4l2-ctl --stream-mmap just sits there, waiting for
>> frames, I guess.
>>
>> I'm not sure if that has to do with the two warnings above.
> 
> 
> This is weird, v4l2-ctl --stream-mmap works for me even with those 
> messages above, could you try again with the v6 please?

Yup, v6 fixed it for me. Not sure what was the cause, but it's now working fine.

Once I have Laurent's Ack I'll take it.

Thanks for all your hard work, I'm sure you expected this to get in sooner, but
better late than never!

	Hans

> 
> 
>>
>> I am assuming that the initial pipeline is correct and that you should be able
>> to start streaming. If not, then attempting to start streaming should return an
>> error.
>>
>> On 08/18/2016 12:09 AM, Helen Koike wrote:
>>> From: Helen Fornazier <helen.fornazier@gmail.com>
>>>
>>> First version of the Virtual Media Controller.
>>> Add a simple version of the core of the driver, the capture and
>>> sensor nodes in the topology, generating a grey image in a hardcoded
>>> format.
>>>
>>> Signed-off-by: Helen Koike <helen.koike@collabora.com>
>>
>> <snip>
>>
>>> +static int vimc_cap_querycap(struct file *file, void *priv,
>>> +			     struct v4l2_capability *cap)
>>> +{
>>> +	struct vimc_cap_device *vcap = video_drvdata(file);
>>> +
>>> +	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
>>> +	strlcpy(cap->card, KBUILD_MODNAME, sizeof(cap->card));
>>> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
>>> +		 "platform:%s", vcap->v4l2_dev->name);
>>> +
>>> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>>
>> This line should be moved to vimc_cap_create:
>>
>> 	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>>
>> This is new. The v4l2 core will fill in the querycap capabilities for you
>> based on vdev->device_caps.
>>
>>> +
>>> +	return 0;
>>> +}
>>
>> <snip>
>>
>>> +static int vimc_device_register(struct vimc_device *vimc)
>>> +{
>>> +	unsigned int i;
>>> +	int ret = 0;
>>> +
>>> +	/* Allocate memory for the vimc_ent_devices pointers */
>>> +	vimc->ved = devm_kcalloc(vimc->mdev.dev, vimc->pipe_cfg->num_ents,
>>> +				 sizeof(*vimc->ved), GFP_KERNEL);
>>> +	if (!vimc->ved)
>>> +		return -ENOMEM;
>>> +
>>> +	/* Register the media device */
>>> +	ret = media_device_register(&vimc->mdev);
>>> +	if (ret) {
>>> +		dev_err(vimc->mdev.dev,
>>> +			"media device register failed (err=%d)\n", ret);
>>> +		return ret;
>>> +	}
>>> +
>>> +	/* Link the media device within the v4l2_device */
>>> +	vimc->v4l2_dev.mdev = &vimc->mdev;
>>> +
>>> +	/* Register the v4l2 struct */
>>> +	ret = v4l2_device_register(vimc->mdev.dev, &vimc->v4l2_dev);
>>> +	if (ret) {
>>> +		dev_err(vimc->mdev.dev,
>>> +			"v4l2 device register failed (err=%d)\n", ret);
>>> +		return ret;
>>> +	}
>>> +
>>> +	/* Initialize entities */
>>> +	for (i = 0; i < vimc->pipe_cfg->num_ents; i++) {
>>> +		struct vimc_ent_device *(*create_func)(struct v4l2_device *,
>>> +						       const char *const,
>>> +						       u16,
>>> +						       const unsigned long *);
>>> +
>>> +		/* Register the specific node */
>>> +		switch (vimc->pipe_cfg->ents[i].node) {
>>> +		case VIMC_ENT_NODE_SENSOR:
>>> +			create_func = vimc_sen_create;
>>> +			break;
>>> +
>>> +		case VIMC_ENT_NODE_CAPTURE:
>>> +			create_func = vimc_cap_create;
>>> +			break;
>>> +
>>> +		/* TODO: Instantiate the specific topology node */
>>> +		case VIMC_ENT_NODE_INPUT:
>>> +		case VIMC_ENT_NODE_DEBAYER:
>>> +		case VIMC_ENT_NODE_SCALER:
>>> +		default:
>>> +			/* TODO: remove this when all the entities specific
>>> +			 * code are implemented
>>> +			 */
>>> +			create_func = vimc_raw_create;
>>> +			break;
>>> +		}
>>> +
>>> +		vimc->ved[i] = create_func(&vimc->v4l2_dev,
>>> +					   vimc->pipe_cfg->ents[i].name,
>>> +					   vimc->pipe_cfg->ents[i].pads_qty,
>>> +					   vimc->pipe_cfg->ents[i].pads_flag);
>>> +		if (IS_ERR(vimc->ved[i])) {
>>> +			ret = PTR_ERR(vimc->ved[i]);
>>> +			vimc->ved[i] = NULL;
>>> +			goto err;
>>> +		}
>>> +
>>> +		/* Set use_count to keep track of the ved structure */
>>> +		vimc->ved[i]->ent->use_count = i;
>>> +	}
>>> +
>>> +	/* Initialize the links between entities */
>>> +	for (i = 0; i < vimc->pipe_cfg->num_links; i++) {
>>> +		const struct vimc_ent_link *link = &vimc->pipe_cfg->links[i];
>>> +
>>> +		ret = media_create_pad_link(vimc->ved[link->src_ent]->ent,
>>> +					    link->src_pad,
>>> +					    vimc->ved[link->sink_ent]->ent,
>>> +					    link->sink_pad,
>>> +					    link->flags);
>>> +		if (ret)
>>> +			goto err;
>>> +	}
>>> +
>>> +	/* Expose all subdev's nodes*/
>>> +	ret = v4l2_device_register_subdev_nodes(&vimc->v4l2_dev);
>>> +	if (ret) {
>>> +		dev_err(vimc->mdev.dev,
>>> +			"vimc subdev nodes registration failed (err=%d)\n",
>>> +			ret);
>>> +		goto err;
>>> +	}
>>> +
>>> +	return 0;
>>> +
>>> +err:
>>> +	/* Destroy de so far created topology */
>>
>> s/de/the/
>>
>>> +	vimc_device_unregister(vimc);
>>> +
>>> +	return ret;
>>> +}
>>
>> Regards,
>>
>> 	Hans
>>
> 
> 
> Regards,
> Helen
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
