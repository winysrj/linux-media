Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:60722 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbeKTVU0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 16:20:26 -0500
Subject: Re: [PATCH v4 3/4] media: i2c: Add MAX9286 driver
To: kieran.bingham@ideasonboard.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        sakari.ailus@iki.fi
Cc: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
References: <20181102154723.23662-1-kieran.bingham@ideasonboard.com>
 <20181102154723.23662-4-kieran.bingham@ideasonboard.com>
 <5238fa80-7678-97a8-47ee-6a26970d862d@lucaceresoli.net>
 <07ee8a2c-81a8-ca32-96cf-67d6a883e3f5@ideasonboard.com>
 <e6143de9-f253-1a89-21e0-d1e2c0444e7b@lucaceresoli.net>
 <417f5bc8-533d-2c2f-2325-3e728d53329b@ideasonboard.com>
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <6729cf7d-bd5d-d762-3f4a-f53a8791a397@lucaceresoli.net>
Date: Tue, 20 Nov 2018 11:51:37 +0100
MIME-Version: 1.0
In-Reply-To: <417f5bc8-533d-2c2f-2325-3e728d53329b@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On 20/11/18 01:32, Kieran Bingham wrote:
> Hi Luca,
> 
> My apologies for my travel induced delay in responding here,

No problem.

> On 14/11/2018 02:04, Luca Ceresoli wrote:
[...]
>>>>> +static int max9286_probe(struct i2c_client *client,
>>>>> +			 const struct i2c_device_id *did)
>>>>> +{
>>>>> +	struct max9286_device *dev;
>>>>> +	unsigned int i;
>>>>> +	int ret;
>>>>> +
>>>>> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>>>>> +	if (!dev)
>>>>> +		return -ENOMEM;
>>>>> +
>>>>> +	dev->client = client;
>>>>> +	i2c_set_clientdata(client, dev);
>>>>> +
>>>>> +	for (i = 0; i < MAX9286_N_SINKS; i++)
>>>>> +		max9286_init_format(&dev->fmt[i]);
>>>>> +
>>>>> +	ret = max9286_parse_dt(dev);
>>>>> +	if (ret)
>>>>> +		return ret;
>>>>> +
>>>>> +	dev->regulator = regulator_get(&client->dev, "poc");
>>>>> +	if (IS_ERR(dev->regulator)) {
>>>>> +		if (PTR_ERR(dev->regulator) != -EPROBE_DEFER)
>>>>> +			dev_err(&client->dev,
>>>>> +				"Unable to get PoC regulator (%ld)\n",
>>>>> +				PTR_ERR(dev->regulator));
>>>>> +		ret = PTR_ERR(dev->regulator);
>>>>> +		goto err_free;
>>>>> +	}
>>>>> +
>>>>> +	/*
>>>>> +	 * We can have multiple MAX9286 instances on the same physical I2C
>>>>> +	 * bus, and I2C children behind ports of separate MAX9286 instances
>>>>> +	 * having the same I2C address. As the MAX9286 starts by default with
>>>>> +	 * all ports enabled, we need to disable all ports on all MAX9286
>>>>> +	 * instances before proceeding to further initialize the devices and
>>>>> +	 * instantiate children.
>>>>> +	 *
>>>>> +	 * Start by just disabling all channels on the current device. Then,
>>>>> +	 * if all other MAX9286 on the parent bus have been probed, proceed
>>>>> +	 * to initialize them all, including the current one.
>>>>> +	 */
>>>>> +	max9286_i2c_mux_close(dev);
>>>>> +
>>>>> +	/*
>>>>> +	 * The MAX9286 initialises with auto-acknowledge enabled by default.
>>>>> +	 * This means that if multiple MAX9286 devices are connected to an I2C
>>>>> +	 * bus, another MAX9286 could ack I2C transfers meant for a device on
>>>>> +	 * the other side of the GMSL links for this MAX9286 (such as a
>>>>> +	 * MAX9271). To prevent that disable auto-acknowledge early on; it
>>>>> +	 * will be enabled later as needed.
>>>>> +	 */
>>>>> +	max9286_configure_i2c(dev, false);
>>>>> +
>>>>> +	ret = device_for_each_child(client->dev.parent, &client->dev,
>>>>> +				    max9286_is_bound);
>>>>> +	if (ret)
>>>>> +		return 0;
>>>>> +
>>>>> +	dev_dbg(&client->dev,
>>>>> +		"All max9286 probed: start initialization sequence\n");
>>>>> +	ret = device_for_each_child(client->dev.parent, NULL,
>>>>> +				    max9286_init);
>>>>
>>>> I can't manage to like this initialization sequence, sorry. If at all
>>>> possible, each max9286 should initialize itself independently from each
>>>> other, like any normal driver.
>>>
>>> Yes, I think we're in agreement here, but unfortunately this section is
>>> a workaround for the fact that our devices share a common address space.
>>>
>>> We (currently) *must* disable both devices before we start the
>>> initialisation process for either on our platform currently...
>>
>> The model I proposed in my review to patch 1/4 (split remote physical
>> address from local address pool) allows to avoid this workaround.
> 
> 
> Having just talked this through with Jacopo I think I see that we have
> two topics getting intertwined here too.
> 
>  - Address translation so that we can separate the camera addressing
> 
>  - our 'device_is_bound/device_for_each_child()' workaround which lets
>    us make sure the buses are closed before we power on any camera
>    device.
> 
> 
> For the upstream process of this driver - I will remove the
> 'device_is_bound()/device_for_each_child()' workarounds.
> 
> 
> It is /ugly/ and needs more consideration, but I believe we do still
> need it (or something similar) for our platform currently.
> 
> 
> 
> The other side of that is the address translation. I think I was wrong
> earlier and may have said we have address translation on both sides.
> 
> 
> I think I now see that we only have some minimal translation for two
> addresses on the remote (max9271) side, not the local (max9286) side.

Can the remote (max9271) translate addresses for transactions
originating from the local side? This would make it possible to do a
proper address translation, although 2 addresses is a quite small amount.

BTW all the TI chips I'm looking at can do address translation but, as
far as I understand, only when acting as "slave proxy", i.e. when
attached to the bus master. If the Maxim chips do the same, the "remote
translation" would be unusable.

> We have the ability to reprogram addresses through, and that's what we
> are using.

Sadly, it looks pretty much unavoidable...

> There's a lot more local discussion going on here that I may have missed
> so I hope Jacopo, Niklas, or Laurent may add more here if relevant :)
> 
> 
> 
> 
>>> That said - I think this section needs to be removed from the upstream
>>> part at least for now. I think we should probably carry this
>>> 'workaround' separately.
>>>
>>> This part is the core issue that I talked about in my presentation at
>>> ALS-Japan [0]
>>>
>>>  [0] https://sched.co/EaXa
>>
>> Oh, interesting, I hadn't noticed that you gave this talk -- at the same
>> conference as Vladimir's talk! No video recording apparently, but are
>> slides available at least?
> 
> Hrm ... I was sure I uploaded to the conference so that they should have
> been available on that URL - but they are not showing.
> 
> They are available here:
> 
> 	https://www.slideshare.net/KieranBingham/gmsl-in-linux

Thanks.

> (Please excuse the incorrect date on the first slide :D)
> 
> I had put a proposal in to give this talk again at ELCE but
> unfortunately it didn't get accepted.
>
> Seems it really would have been useful to have a slot. Lets hope next
> ELCE is too late and we work out a good system by then :)

Indeed it would have been!

But hey, The FOSDEM CFPs are still open!

Bye,
-- 
Luca
