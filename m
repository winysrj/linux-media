Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:38325 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732664AbeKNUG5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 15:06:57 -0500
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
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <e6143de9-f253-1a89-21e0-d1e2c0444e7b@lucaceresoli.net>
Date: Wed, 14 Nov 2018 11:04:13 +0100
MIME-Version: 1.0
In-Reply-To: <07ee8a2c-81a8-ca32-96cf-67d6a883e3f5@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On 14/11/18 01:46, Kieran Bingham wrote:
> Hi Luca,
> 
> Thank you for your review,
> 
> On 13/11/2018 14:49, Luca Ceresoli wrote:
>> Hi Kieran, All,
>>
>> below a few minor questions, and a big one at the bottom.
>>
>> On 02/11/18 16:47, Kieran Bingham wrote:
>>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>
>>> The MAX9286 is a 4-channel GMSL deserializer with coax or STP input and
>>> CSI-2 output. The device supports multicamera streaming applications,
>>> and features the ability to synchronise the attached cameras.
>>>
>>> CSI-2 output can be configured with 1 to 4 lanes, and a control channel
>>> is supported over I2C, which implements an I2C mux to facilitate
>>> communications with connected cameras across the reverse control
>>> channel.
>>>
>>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>
>> [...]
>>
>>> +struct max9286_device {
>>> +	struct i2c_client *client;
>>> +	struct v4l2_subdev sd;
>>> +	struct media_pad pads[MAX9286_N_PADS];
>>> +	struct regulator *regulator;
>>> +	bool poc_enabled;
>>> +	int streaming;
>>> +
>>> +	struct i2c_mux_core *mux;
>>> +	unsigned int mux_channel;
>>> +
>>> +	struct v4l2_ctrl_handler ctrls;
>>> +
>>> +	struct v4l2_mbus_framefmt fmt[MAX9286_N_SINKS];
>>
>> 5 pads, 4 formats. Why does the source node have no fmt?
> 
> The source pad is a CSI2 link - so a 'frame format' would be inappropriate.

Ok, thanks for the clarification.

>>> +static int max9286_probe(struct i2c_client *client,
>>> +			 const struct i2c_device_id *did)
>>> +{
>>> +	struct max9286_device *dev;
>>> +	unsigned int i;
>>> +	int ret;
>>> +
>>> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>>> +	if (!dev)
>>> +		return -ENOMEM;
>>> +
>>> +	dev->client = client;
>>> +	i2c_set_clientdata(client, dev);
>>> +
>>> +	for (i = 0; i < MAX9286_N_SINKS; i++)
>>> +		max9286_init_format(&dev->fmt[i]);
>>> +
>>> +	ret = max9286_parse_dt(dev);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	dev->regulator = regulator_get(&client->dev, "poc");
>>> +	if (IS_ERR(dev->regulator)) {
>>> +		if (PTR_ERR(dev->regulator) != -EPROBE_DEFER)
>>> +			dev_err(&client->dev,
>>> +				"Unable to get PoC regulator (%ld)\n",
>>> +				PTR_ERR(dev->regulator));
>>> +		ret = PTR_ERR(dev->regulator);
>>> +		goto err_free;
>>> +	}
>>> +
>>> +	/*
>>> +	 * We can have multiple MAX9286 instances on the same physical I2C
>>> +	 * bus, and I2C children behind ports of separate MAX9286 instances
>>> +	 * having the same I2C address. As the MAX9286 starts by default with
>>> +	 * all ports enabled, we need to disable all ports on all MAX9286
>>> +	 * instances before proceeding to further initialize the devices and
>>> +	 * instantiate children.
>>> +	 *
>>> +	 * Start by just disabling all channels on the current device. Then,
>>> +	 * if all other MAX9286 on the parent bus have been probed, proceed
>>> +	 * to initialize them all, including the current one.
>>> +	 */
>>> +	max9286_i2c_mux_close(dev);
>>> +
>>> +	/*
>>> +	 * The MAX9286 initialises with auto-acknowledge enabled by default.
>>> +	 * This means that if multiple MAX9286 devices are connected to an I2C
>>> +	 * bus, another MAX9286 could ack I2C transfers meant for a device on
>>> +	 * the other side of the GMSL links for this MAX9286 (such as a
>>> +	 * MAX9271). To prevent that disable auto-acknowledge early on; it
>>> +	 * will be enabled later as needed.
>>> +	 */
>>> +	max9286_configure_i2c(dev, false);
>>> +
>>> +	ret = device_for_each_child(client->dev.parent, &client->dev,
>>> +				    max9286_is_bound);
>>> +	if (ret)
>>> +		return 0;
>>> +
>>> +	dev_dbg(&client->dev,
>>> +		"All max9286 probed: start initialization sequence\n");
>>> +	ret = device_for_each_child(client->dev.parent, NULL,
>>> +				    max9286_init);
>>
>> I can't manage to like this initialization sequence, sorry. If at all
>> possible, each max9286 should initialize itself independently from each
>> other, like any normal driver.
> 
> Yes, I think we're in agreement here, but unfortunately this section is
> a workaround for the fact that our devices share a common address space.
> 
> We (currently) *must* disable both devices before we start the
> initialisation process for either on our platform currently...

The model I proposed in my review to patch 1/4 (split remote physical
address from local address pool) allows to avoid this workaround.

> That said - I think this section needs to be removed from the upstream
> part at least for now. I think we should probably carry this
> 'workaround' separately.
> 
> This part is the core issue that I talked about in my presentation at
> ALS-Japan [0]
> 
>  [0] https://sched.co/EaXa

Oh, interesting, I hadn't noticed that you gave this talk -- at the same
conference as Vladimir's talk! No video recording apparently, but are
slides available at least?

>> First, it requires that each chip on the remote side can configure its
>> own slave address. Not all chips do.
>>
>> Second, using a static i2c address map does not scale well and limits
>> hotplugging, as I discussed in my reply to patch 1/4. The problem should
>> be solvable cleanly if the MAX9286 supports address translation like the
>> TI chips.
> 
> I don't think we can treat GMSL as hot-pluggable currently ... But as we
> discussed - I see that we should think about this for FPD-Link

I've been mixing hotplug and DT overlays and that generated confusion,
sorry. My point exists even with no hotplug, see the reply to patch 1/4.

-- 
Luca
