Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:49582 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbeKUUjI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 15:39:08 -0500
Subject: Re: [PATCH v4 3/4] media: i2c: Add MAX9286 driver
To: jacopo mondi <jacopo@jmondi.org>
Cc: kieran.bingham@ideasonboard.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        sakari.ailus@iki.fi,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
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
 <6729cf7d-bd5d-d762-3f4a-f53a8791a397@lucaceresoli.net>
 <20181120174425.GF28299@w540>
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <f1e40fda-1e71-7b8c-adf3-ffc72897db44@lucaceresoli.net>
Date: Wed, 21 Nov 2018 11:05:00 +0100
MIME-Version: 1.0
In-Reply-To: <20181120174425.GF28299@w540>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 20/11/18 18:44, jacopo mondi wrote:
> Hi Luca,
> 
> On Tue, Nov 20, 2018 at 11:51:37AM +0100, Luca Ceresoli wrote:
>> Hi Kieran,
>>
>> On 20/11/18 01:32, Kieran Bingham wrote:
>>> Hi Luca,
>>>
>>> My apologies for my travel induced delay in responding here,
>>
>> No problem.
>>
>>> On 14/11/2018 02:04, Luca Ceresoli wrote:
>> [...]
>>>>>>> +static int max9286_probe(struct i2c_client *client,
>>>>>>> +			 const struct i2c_device_id *did)
>>>>>>> +{
>>>>>>> +	struct max9286_device *dev;
>>>>>>> +	unsigned int i;
>>>>>>> +	int ret;
>>>>>>> +
>>>>>>> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>>>>>>> +	if (!dev)
>>>>>>> +		return -ENOMEM;
>>>>>>> +
>>>>>>> +	dev->client = client;
>>>>>>> +	i2c_set_clientdata(client, dev);
>>>>>>> +
>>>>>>> +	for (i = 0; i < MAX9286_N_SINKS; i++)
>>>>>>> +		max9286_init_format(&dev->fmt[i]);
>>>>>>> +
>>>>>>> +	ret = max9286_parse_dt(dev);
>>>>>>> +	if (ret)
>>>>>>> +		return ret;
>>>>>>> +
>>>>>>> +	dev->regulator = regulator_get(&client->dev, "poc");
>>>>>>> +	if (IS_ERR(dev->regulator)) {
>>>>>>> +		if (PTR_ERR(dev->regulator) != -EPROBE_DEFER)
>>>>>>> +			dev_err(&client->dev,
>>>>>>> +				"Unable to get PoC regulator (%ld)\n",
>>>>>>> +				PTR_ERR(dev->regulator));
>>>>>>> +		ret = PTR_ERR(dev->regulator);
>>>>>>> +		goto err_free;
>>>>>>> +	}
>>>>>>> +
>>>>>>> +	/*
>>>>>>> +	 * We can have multiple MAX9286 instances on the same physical I2C
>>>>>>> +	 * bus, and I2C children behind ports of separate MAX9286 instances
>>>>>>> +	 * having the same I2C address. As the MAX9286 starts by default with
>>>>>>> +	 * all ports enabled, we need to disable all ports on all MAX9286
>>>>>>> +	 * instances before proceeding to further initialize the devices and
>>>>>>> +	 * instantiate children.
>>>>>>> +	 *
>>>>>>> +	 * Start by just disabling all channels on the current device. Then,
>>>>>>> +	 * if all other MAX9286 on the parent bus have been probed, proceed
>>>>>>> +	 * to initialize them all, including the current one.
>>>>>>> +	 */
>>>>>>> +	max9286_i2c_mux_close(dev);
>>>>>>> +
>>>>>>> +	/*
>>>>>>> +	 * The MAX9286 initialises with auto-acknowledge enabled by default.
>>>>>>> +	 * This means that if multiple MAX9286 devices are connected to an I2C
>>>>>>> +	 * bus, another MAX9286 could ack I2C transfers meant for a device on
>>>>>>> +	 * the other side of the GMSL links for this MAX9286 (such as a
>>>>>>> +	 * MAX9271). To prevent that disable auto-acknowledge early on; it
>>>>>>> +	 * will be enabled later as needed.
>>>>>>> +	 */
>>>>>>> +	max9286_configure_i2c(dev, false);
>>>>>>> +
>>>>>>> +	ret = device_for_each_child(client->dev.parent, &client->dev,
>>>>>>> +				    max9286_is_bound);
>>>>>>> +	if (ret)
>>>>>>> +		return 0;
>>>>>>> +
>>>>>>> +	dev_dbg(&client->dev,
>>>>>>> +		"All max9286 probed: start initialization sequence\n");
>>>>>>> +	ret = device_for_each_child(client->dev.parent, NULL,
>>>>>>> +				    max9286_init);
>>>>>>
>>>>>> I can't manage to like this initialization sequence, sorry. If at all
>>>>>> possible, each max9286 should initialize itself independently from each
>>>>>> other, like any normal driver.
>>>>>
>>>>> Yes, I think we're in agreement here, but unfortunately this section is
>>>>> a workaround for the fact that our devices share a common address space.
>>>>>
>>>>> We (currently) *must* disable both devices before we start the
>>>>> initialisation process for either on our platform currently...
>>>>
>>>> The model I proposed in my review to patch 1/4 (split remote physical
>>>> address from local address pool) allows to avoid this workaround.
>>>
>>>
>>> Having just talked this through with Jacopo I think I see that we have
>>> two topics getting intertwined here too.
>>>
>>>  - Address translation so that we can separate the camera addressing
>>>
>>>  - our 'device_is_bound/device_for_each_child()' workaround which lets
>>>    us make sure the buses are closed before we power on any camera
>>>    device.
>>>
>>>
>>> For the upstream process of this driver - I will remove the
>>> 'device_is_bound()/device_for_each_child()' workarounds.
>>>
>>>
>>> It is /ugly/ and needs more consideration, but I believe we do still
>>> need it (or something similar) for our platform currently.
>>>
>>>
>>>
>>> The other side of that is the address translation. I think I was wrong
>>> earlier and may have said we have address translation on both sides.
>>>
>>>
>>> I think I now see that we only have some minimal translation for two
>>> addresses on the remote (max9271) side, not the local (max9286) side.
>>
>> Can the remote (max9271) translate addresses for transactions
>> originating from the local side? This would make it possible to do a
>> proper address translation, although 2 addresses is a quite small amount.
>>
> 
> Yes, that's true for systems with a single max9286 [1]
> 
> We have a system with 2 de-serializers, and what happens is the
> following:
> 
> The system starts with the following configuration:
> 
> 1)
>                     +------- max9271@40
>                     +------- max9271@40
> Soc ----> max9286 --+------- max9271@40
>                     +------- max9271@40
> 
> with a single max9286 it would be easy. We operate on one channel at
> the time, do the reprogramming (or set up the translation, for the TI
> chip use case) when adding the adapter for the channel, and then we
> can talk with all remotes, which now have a different address
> 
> 2)
>                     +-------- max9271@50
>                     +--- / -- max9271@40
> Soc ----> max9286 --+--- / -- max9271@40
>                     +--- / -- max9271@40
> 
> 
>                     +--- / -- max9271@50
>                     +-------- max9271@51
> Soc ----> max9286 --+--- / -- max9271@40
>                     +--- / -- max9271@40
> 
>                     +--- / -- max9271@50
>                     +--- / -- max9271@51
> Soc ----> max9286 --+-------- max9271@52
>                     +--- / -- max9271@40
> 
>                     +--- / -- max9271@50
>                     +--- / -- max9271@51
> Soc ----> max9286 --+--- / -- max9271@52
>                     +-------- max9271@53
> 
> Of course, to do the reprogramming, we need to initially send messages
> to the default 0x40 address each max9271 boots with. If we don't close
> all channels but the one we intend to reprogram, all remotes would
> receive the same message, and thus will be re-programmed to the same
> address (not nice). [2]
> 
> Now, if you have two max9286, installed on the same i2c bus, then you
> need to make sure all channels of the 'others' are closed, before you
> can reprogram your remotes, otherwise, you would end up reprogramming
> all the remotes of the 'others' when trying to reprogram yours, as our
> local de-serializers, bounces everything they receives, not directed
> to them, to their remote sides.

This last sentence is the one point that makes things so hard on the
GMSL chips. In my previous email(s) I partially forgot about this, so I
was hoping  a better implementation could be possible. Thanks for
re-focusing me.

It would have been lovely if the hardware designers had at least put an
i2c mux between the soc and those chatty deserializers... :-\

> 3)
>                        +-------- max9271@50
>                        +--- / -- max9271@40
> Soc --+-> max9286@4c --+--- / -- max9271@40
>       |                +--- / -- max9271@40
>       |
>       |-> max9286@6c --+-------- max9271@50  <-- not nice
>                        +-------- max9271@50
>                        +-------- max9271@50
>                        +-------- max9271@50
> 
>                        +--- / -- max9271@50
>                        +-------- max9271@51
> Soc --+-> max9286@4c --+--- / -- max9271@40
>       |                +--- / -- max9271@40
>       |
>       |-> max9286@6c --+-------- max9271@51 <-- not nice
>                        +-------- max9271@51
>                        +-------- max9271@51
>                        +-------- max9271@51
> 
> ....
> 
> With the (not nice) 'max9286_is_bound()' we make sure we close all
> channels on all max9286 first
> 
> 4)
>                        +--- / -- max9271@40
>                        +--- / -- max9271@40
> Soc --+-> max9286@4c --+--- / -- max9271@40
>       |                +--- / -- max9271@40
>       |
>       |-> max9286@6c --+--- / -- max9271@40
>                        +--- / -- max9271@40
>                        +--- / -- max9271@40
>                        +--- / -- max9271@40
> 
> And then only the last one to probe calls the re-programming
> phase for all its fellows de-serializers on the bus.
> 
> 5)
>                        +-------- max9271@50
>                        +--- / -- max9271@40
> Soc --+-> max9286@4c --+--- / -- max9271@40
>       |                +--- / -- max9271@40
>       |
>       |-> max9286@6c --+--- / -- max9271@40
>                        +--- / -- max9271@40
>                        +--- / -- max9271@40
>                        +--- / -- max9271@40
>     ....
> 
> 
>                        +--- / -- max9271@50
>                        +--- / -- max9271@51
> Soc --+-> max9286@4c --+--- / -- max9271@52
>       |                +--- / -- max9271@53
>       |
>       |-> max9286@6c --+-------- max9271@54
>                        +--- / -- max9271@40
>                        +--- / -- max9271@40
>                        +--- / -- max9271@40
> 
> When addr reprogramming is done, we enter the image streaming phase,
> with all channels open, as now, all remotes, have a different i2c
> address assigned.
> 
> Suggestions on how to better handle this are very welcome. The point
> here is that, to me, this is a gmsl-specific implementation thing.
> 
> Do you think for your chips, if they do translations, can you easy mask
> them with the i2c address you want (being that specified in the remote
> node or selected from an i2c-addr-pool, or something else) without
> having to care about others remotes to be accidentally programmed to
> an i2c address they're not intended to be assigned to.

Yes. The TI chips have a "passthrough-all" option to propagate all
transactions with an unknown address, but it's mostly meant for
debugging. In normal usage the local chip will propagate (with addresses
translated) only transactions coming with a known slave address,
including its own address(es), the remote (de)ser aliases and the remote
chip aliases. All aliases are disabled until programmed.

> Hope this helps clarify your concerns, and I think the actual issue
> to discuss, at least on bindings, would be the i2c-address assignment
> method, as this impacts GMSL, as well as other implementation that
> would use the same binding style as this patches.

Absolutely.

Bye,
-- 
Luca
