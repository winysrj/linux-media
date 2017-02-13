Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:33470 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752621AbdBMUTy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 15:19:54 -0500
Subject: Re: [PATCH v8 2/2] Add support for OV5647 sensor.
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>
References: <cover.1486984040.git.roliveir@synopsys.com>
 <6b023e996ec7bcfc84b489f8d700eeff328bef7b.1486984040.git.roliveir@synopsys.com>
 <b947bd60-b08b-1841-eb8c-ee275a234ef3@mentor.com>
 <b44432b0-34aa-dd36-db4c-f154c98932e4@synopsys.com>
CC: <CARLOS.PALMINHA@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Kamil Debski <k.debski@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <551549a2-bd4d-9aed-b4b0-fa54e851f6ff@mentor.com>
Date: Mon, 13 Feb 2017 22:19:44 +0200
MIME-Version: 1.0
In-Reply-To: <b44432b0-34aa-dd36-db4c-f154c98932e4@synopsys.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro,

On 02/13/2017 09:14 PM, Ramiro Oliveira wrote:
> Hi Vladimir,
> 
> Thank you for your feedback.
> 
> On 2/13/2017 12:21 PM, Vladimir Zapolskiy wrote:
>> Hello Ramiro,
>>
>> On 02/13/2017 01:25 PM, Ramiro Oliveira wrote:
>>> Modes supported:
>>>  - 640x480 RAW 8
>>>

[snip]

>>> +static int ov5647_probe(struct i2c_client *client,
>>> +			const struct i2c_device_id *id)
>>> +{
>>> +	struct device *dev = &client->dev;
>>> +	struct ov5647 *sensor;
>>> +	int ret;
>>> +	struct v4l2_subdev *sd;
>>> +
>>> +	dev_info(&client->dev, "Installing OmniVision OV5647 camera driver\n");
>>
>> Please remove the informational line, it will pollute the kernel log for no
>> good reason.
>>
> 
> Is it okay if I change it to debug?
> 

Most probably here it is okay to change it to dev_dbg(), however

1) please note that ftrace functionality should provide all the magic for you,
   and by the way this makes dev_dbg() calls from ov5647_write(), ov5647_read(),
   ov5647_stream_on(), ov5647_stream_off() and __sensor_init() all redundant,

2) please move the informational message to the end of the .probe function,
   right before returning success to avoid duplicates on deferred re-probing:

	dev_dbg(&client->dev, "OmniVision OV5647 camera driver probed\n");
	                                                      ^^^^^^^^
[snip]

>>> +
>>> +static const struct i2c_device_id ov5647_id[] = {
>>> +	{ "ov5647", 0 },
>>> +	{ }
>>> +};
>>> +MODULE_DEVICE_TABLE(i2c, ov5647_id);
>>> +
>>> +#if IS_ENABLED(CONFIG_OF)
>>
>> From Kconfig the driver depends on OF.
>>
> 
> You're right. Do you think I should remove the dependency in Kconfig or the
> check here?
> 

Let see...

I've been able to locate only one place where OF dependency is utterly needed:

	ret = of_property_read_u32(dev->of_node, "clock-frequency",
				    &sensor->xclk_freq);
	if (ret) {
		dev_err(dev, "could not get xclk frequency\n");
		return ret;
	}

It might be preferred to change this snippet of code into something like one
below:

	sensor->xclk_freq = clk_get_rate(sensor->xclk);
	if (sensor->xclk_freq != 30000000) {
		dev_err(dev, "Unsupported clock frequency: %lu\n",
			sensor->xclk_freq);
		return -EINVAL;
	}

Then

1) in case of an OF platform "xclk" clock frequency can be set directly
   in a board DTS file, please reference to clock-bindings.txt,
2) next you can drop 'clock-frequency' property from the sensor bindings,
3) you can drop 'depends on OF' from drivers/media/i2c/Kconfig,
4) you can drop 'clk_set_rate()' from sensor_power().

The proposed code is slightly more flexible, at least the change gives
a little chance to run the driver successfully on a non-OF platform,
otherwise it is known in advance that the driver is unusable on any
non-OF platforms and thus an explicit CONFIG_OF build dependency makes
sense.

>>> +static const struct of_device_id ov5647_of_match[] = {
>>> +	{ .compatible = "ovti,ov5647" },
>>> +	{ /* sentinel */ },
>>> +};
>>> +MODULE_DEVICE_TABLE(of, ov5647_of_match);
>>> +#endif
>>> +
>>> +/**
>>> + * @short i2c driver structure
>>> + */
>>> +static struct i2c_driver ov5647_driver = {
>>> +	.driver = {
>>> +		.of_match_table = of_match_ptr(ov5647_of_match),
>>
>> Same comment as above, from Kconfig the driver depends on OF.
>>
> 
> I'm sorry but I'm not understanding what you're trying to say.
> 

You may take a look at of_match_ptr() macro definition from include/linux/of.h:

#ifdef CONFIG_OF
...
#define of_match_ptr(_ptr)      (_ptr)
...
#else
...
#define of_match_ptr(_ptr)      NULL
...
#endif

Hence if the code compilation always depends on the enabled CONFIG_OF option,
then of_match_ptr() macro should be dropped:

	.of_match_table = ov5647_of_match,

>>> +		.owner	= THIS_MODULE,
>>
>> .owner is set by the core, please remove it.
>>
> 
> Ok.
> 
>>> +		.name	= "ov5647",
>>
>> May be .name = SENSOR_NAME, ?
>>
>> Otherwise SENSOR_NAME macro is unused and it should be removed.
>>
> 
> I'll change it to .name = SENSOR_NAME,
> 
>>> +	},
>>> +	.probe		= ov5647_probe,
>>> +	.remove		= ov5647_remove,
>>> +	.id_table	= ov5647_id,
>>> +};
>>> +
>>> +module_i2c_driver(ov5647_driver);
>>> +
>>> +MODULE_AUTHOR("Ramiro Oliveira <roliveir@synopsys.com>");
>>> +MODULE_DESCRIPTION("A low-level driver for OmniVision ov5647 sensors");
>>> +MODULE_LICENSE("GPL v2");
>>>
>>

--
With best wishes,
Vladimir
