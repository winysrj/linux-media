Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43724 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbeKTK7D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 05:59:03 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v4 3/4] media: i2c: Add MAX9286 driver
Reply-To: kieran.bingham@ideasonboard.com
To: Luca Ceresoli <luca@lucaceresoli.net>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, sakari.ailus@iki.fi
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
Message-ID: <417f5bc8-533d-2c2f-2325-3e728d53329b@ideasonboard.com>
Date: Mon, 19 Nov 2018 16:32:30 -0800
MIME-Version: 1.0
In-Reply-To: <e6143de9-f253-1a89-21e0-d1e2c0444e7b@lucaceresoli.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luca,

My apologies for my travel induced delay in responding here,



On 14/11/2018 02:04, Luca Ceresoli wrote:
> Hi Kieran,
> 
> On 14/11/18 01:46, Kieran Bingham wrote:
>> Hi Luca,
>>
>> Thank you for your review,
>>
>> On 13/11/2018 14:49, Luca Ceresoli wrote:
>>> Hi Kieran, All,
>>>
>>> below a few minor questions, and a big one at the bottom.
>>>
>>> On 02/11/18 16:47, Kieran Bingham wrote:
>>>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>>
>>>> The MAX9286 is a 4-channel GMSL deserializer with coax or STP input and
>>>> CSI-2 output. The device supports multicamera streaming applications,
>>>> and features the ability to synchronise the attached cameras.
>>>>
>>>> CSI-2 output can be configured with 1 to 4 lanes, and a control channel
>>>> is supported over I2C, which implements an I2C mux to facilitate
>>>> communications with connected cameras across the reverse control
>>>> channel.
>>>>
>>>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>>>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>>
>>> [...]
>>>
>>>> +struct max9286_device {
>>>> +	struct i2c_client *client;
>>>> +	struct v4l2_subdev sd;
>>>> +	struct media_pad pads[MAX9286_N_PADS];
>>>> +	struct regulator *regulator;
>>>> +	bool poc_enabled;
>>>> +	int streaming;
>>>> +
>>>> +	struct i2c_mux_core *mux;
>>>> +	unsigned int mux_channel;
>>>> +
>>>> +	struct v4l2_ctrl_handler ctrls;
>>>> +
>>>> +	struct v4l2_mbus_framefmt fmt[MAX9286_N_SINKS];
>>>
>>> 5 pads, 4 formats. Why does the source node have no fmt?
>>
>> The source pad is a CSI2 link - so a 'frame format' would be inappropriate.
> 
> Ok, thanks for the clarification.
> 
>>>> +static int max9286_probe(struct i2c_client *client,
>>>> +			 const struct i2c_device_id *did)
>>>> +{
>>>> +	struct max9286_device *dev;
>>>> +	unsigned int i;
>>>> +	int ret;
>>>> +
>>>> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>>>> +	if (!dev)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	dev->client = client;
>>>> +	i2c_set_clientdata(client, dev);
>>>> +
>>>> +	for (i = 0; i < MAX9286_N_SINKS; i++)
>>>> +		max9286_init_format(&dev->fmt[i]);
>>>> +
>>>> +	ret = max9286_parse_dt(dev);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	dev->regulator = regulator_get(&client->dev, "poc");
>>>> +	if (IS_ERR(dev->regulator)) {
>>>> +		if (PTR_ERR(dev->regulator) != -EPROBE_DEFER)
>>>> +			dev_err(&client->dev,
>>>> +				"Unable to get PoC regulator (%ld)\n",
>>>> +				PTR_ERR(dev->regulator));
>>>> +		ret = PTR_ERR(dev->regulator);
>>>> +		goto err_free;
>>>> +	}
>>>> +
>>>> +	/*
>>>> +	 * We can have multiple MAX9286 instances on the same physical I2C
>>>> +	 * bus, and I2C children behind ports of separate MAX9286 instances
>>>> +	 * having the same I2C address. As the MAX9286 starts by default with
>>>> +	 * all ports enabled, we need to disable all ports on all MAX9286
>>>> +	 * instances before proceeding to further initialize the devices and
>>>> +	 * instantiate children.
>>>> +	 *
>>>> +	 * Start by just disabling all channels on the current device. Then,
>>>> +	 * if all other MAX9286 on the parent bus have been probed, proceed
>>>> +	 * to initialize them all, including the current one.
>>>> +	 */
>>>> +	max9286_i2c_mux_close(dev);
>>>> +
>>>> +	/*
>>>> +	 * The MAX9286 initialises with auto-acknowledge enabled by default.
>>>> +	 * This means that if multiple MAX9286 devices are connected to an I2C
>>>> +	 * bus, another MAX9286 could ack I2C transfers meant for a device on
>>>> +	 * the other side of the GMSL links for this MAX9286 (such as a
>>>> +	 * MAX9271). To prevent that disable auto-acknowledge early on; it
>>>> +	 * will be enabled later as needed.
>>>> +	 */
>>>> +	max9286_configure_i2c(dev, false);
>>>> +
>>>> +	ret = device_for_each_child(client->dev.parent, &client->dev,
>>>> +				    max9286_is_bound);
>>>> +	if (ret)
>>>> +		return 0;
>>>> +
>>>> +	dev_dbg(&client->dev,
>>>> +		"All max9286 probed: start initialization sequence\n");
>>>> +	ret = device_for_each_child(client->dev.parent, NULL,
>>>> +				    max9286_init);
>>>
>>> I can't manage to like this initialization sequence, sorry. If at all
>>> possible, each max9286 should initialize itself independently from each
>>> other, like any normal driver.
>>
>> Yes, I think we're in agreement here, but unfortunately this section is
>> a workaround for the fact that our devices share a common address space.
>>
>> We (currently) *must* disable both devices before we start the
>> initialisation process for either on our platform currently...
> 
> The model I proposed in my review to patch 1/4 (split remote physical
> address from local address pool) allows to avoid this workaround.


Having just talked this through with Jacopo I think I see that we have
two topics getting intertwined here too.

 - Address translation so that we can separate the camera addressing

 - our 'device_is_bound/device_for_each_child()' workaround which lets
   us make sure the buses are closed before we power on any camera
   device.


For the upstream process of this driver - I will remove the
'device_is_bound()/device_for_each_child()' workarounds.


It is /ugly/ and needs more consideration, but I believe we do still
need it (or something similar) for our platform currently.



The other side of that is the address translation. I think I was wrong
earlier and may have said we have address translation on both sides.


I think I now see that we only have some minimal translation for two
addresses on the remote (max9271) side, not the local (max9286) side.

We have the ability to reprogram addresses through, and that's what we
are using.


There's a lot more local discussion going on here that I may have missed
so I hope Jacopo, Niklas, or Laurent may add more here if relevant :)




>> That said - I think this section needs to be removed from the upstream
>> part at least for now. I think we should probably carry this
>> 'workaround' separately.
>>
>> This part is the core issue that I talked about in my presentation at
>> ALS-Japan [0]
>>
>>  [0] https://sched.co/EaXa
> 
> Oh, interesting, I hadn't noticed that you gave this talk -- at the same
> conference as Vladimir's talk! No video recording apparently, but are
> slides available at least?

Hrm ... I was sure I uploaded to the conference so that they should have
been available on that URL - but they are not showing.

They are available here:

	https://www.slideshare.net/KieranBingham/gmsl-in-linux

(Please excuse the incorrect date on the first slide :D)

I had put a proposal in to give this talk again at ELCE but
unfortunately it didn't get accepted.

Seems it really would have been useful to have a slot. Lets hope next
ELCE is too late and we work out a good system by then :)


>>> First, it requires that each chip on the remote side can configure its
>>> own slave address. Not all chips do.
>>>
>>> Second, using a static i2c address map does not scale well and limits
>>> hotplugging, as I discussed in my reply to patch 1/4. The problem should
>>> be solvable cleanly if the MAX9286 supports address translation like the
>>> TI chips.
>>
>> I don't think we can treat GMSL as hot-pluggable currently ... But as we
>> discussed - I see that we should think about this for FPD-Link
> 
> I've been mixing hotplug and DT overlays and that generated confusion,
> sorry. My point exists even with no hotplug, see the reply to patch 1/4.


Ok - I understand how you were using the terminology / analogy's now.
Lets move back to patch 1/4 :)


-- 
Regards
--
Kieran
