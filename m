Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54337 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbbDOOHz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2015 10:07:55 -0400
Message-id: <552E70B5.1060406@samsung.com>
Date: Wed, 15 Apr 2015 16:07:49 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com,
	Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v5 03/10] leds: Add support for max77693 mfd flash cell
References: <1429080520-10687-1-git-send-email-j.anaszewski@samsung.com>
 <1429080520-10687-4-git-send-email-j.anaszewski@samsung.com>
 <20150415093007.GG27451@valkosipuli.retiisi.org.uk>
In-reply-to: <20150415093007.GG27451@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.

On 04/15/2015 11:30 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Wed, Apr 15, 2015 at 08:48:33AM +0200, Jacek Anaszewski wrote:
> ...
>> +static int max77693_led_parse_dt(struct max77693_led_device *led,
>> +				struct max77693_led_config_data *cfg)
>> +{
>> +	struct device *dev = &led->pdev->dev;
>> +	struct max77693_sub_led *sub_leds = led->sub_leds;
>> +	struct device_node *node = dev->of_node, *child_node;
>> +	struct property *prop;
>> +	u32 led_sources[2];
>> +	int i, ret, fled_id;
>> +
>> +	of_property_read_u32(node, "maxim,boost-mode", &cfg->boost_mode);
>> +	of_property_read_u32(node, "maxim,boost-mvout", &cfg->boost_vout);
>> +	of_property_read_u32(node, "maxim,mvsys-min", &cfg->low_vsys);
>> +
>> +	for_each_available_child_of_node(node, child_node) {
>> +		prop = of_find_property(child_node, "led-sources", NULL);
>> +		if (prop) {
>> +			const __be32 *srcs = NULL;
>> +
>> +			for (i = 0; i < ARRAY_SIZE(led_sources); ++i) {
>> +				srcs = of_prop_next_u32(prop, srcs,
>> +							&led_sources[i]);
>> +				if (!srcs)
>> +					break;
>> +			}
>> +		} else {
>> +			dev_err(dev,
>> +				"led-sources DT property missing\n");
>> +			return -EINVAL;
>
> If you exit the loop in the middle, I think you'll need to do
> of_node_put(child_node) first.

Not all drivers seem to stick to this, but I checked and this is
indeed required. Not intuitive though.

>> +		}
>> +
>> +		if (i == 2) {
>> +			fled_id = FLED1;
>> +			led->fled_mask = FLED1_IOUT | FLED2_IOUT;
>> +		} else if (led_sources[0] == FLED1) {
>> +			fled_id = FLED1;
>> +			led->fled_mask |= FLED1_IOUT;
>> +		} else if (led_sources[0] == FLED2) {
>> +			fled_id = FLED2;
>> +			led->fled_mask |= FLED2_IOUT;
>> +		} else {
>> +			dev_err(dev,
>> +				"Wrong led-sources DT property value.\n");
>> +			return -EINVAL;
>
> Same here.
>
>> +		}
>> +
>> +		sub_leds[fled_id].fled_id = fled_id;
>> +
>> +		cfg->label[fled_id] =
>> +			of_get_property(child_node, "label", NULL) ? :
>> +						child_node->name;
>
> I think you should copy the string here, or keep a reference to child_node.

Many led drivers does the same. I am wondering whether this is a bug.

> of_property_read_string() might be useful.
>
>> +
>> +		ret = of_property_read_u32(child_node, "led-max-microamp",
>> +					&cfg->iout_torch_max[fled_id]);
>> +		if (ret < 0) {
>> +			cfg->iout_torch_max[fled_id] = TORCH_IOUT_MIN;
>> +			dev_warn(dev, "led-max-microamp DT property missing\n");
>> +		}
>> +
>> +		ret = of_property_read_u32(child_node, "flash-max-microamp",
>> +					&cfg->iout_flash_max[fled_id]);
>> +		if (ret < 0) {
>> +			cfg->iout_flash_max[fled_id] = FLASH_IOUT_MIN;
>> +			dev_warn(dev,
>> +				 "flash-max-microamp DT property missing\n");
>> +		}
>> +
>> +		ret = of_property_read_u32(child_node, "flash-max-timeout-us",
>> +					&cfg->flash_timeout_max[fled_id]);
>> +		if (ret < 0) {
>> +			cfg->flash_timeout_max[fled_id] = FLASH_TIMEOUT_MIN;
>> +			dev_warn(dev,
>> +				 "flash-max-timeout-us DT property missing\n");
>> +		}
>> +
>> +		if (++cfg->num_leds == 2 ||
>> +		    (max77693_fled_used(led, FLED1) &&
>> +		     max77693_fled_used(led, FLED2)))
>
> of_node_put(child_node);
>
>> +			break;
>> +	}
>> +
>> +	if (cfg->num_leds == 0) {
>> +		dev_err(dev, "No DT child node found for connected LED(s).\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>
> With these matters addressed,
>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>


-- 
Best Regards,
Jacek Anaszewski
