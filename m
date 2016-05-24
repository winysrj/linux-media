Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35572 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbcEXJQp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 05:16:45 -0400
Subject: Re: [PATCHv3] support for AD5820 camera auto-focus coil
To: Pavel Machek <pavel@ucw.cz>
References: <20160517181927.GA28741@amd> <20160521054336.GA27123@amd>
 <573FFF51.1000004@gmail.com> <20160521105607.GA20071@amd>
 <574049EF.2090208@gmail.com> <20160524090433.GA1277@amd>
Cc: pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	sakari.ailus@iki.fi
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <57441BF8.60606@gmail.com>
Date: Tue, 24 May 2016 12:16:40 +0300
MIME-Version: 1.0
In-Reply-To: <20160524090433.GA1277@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 24.05.2016 12:04, Pavel Machek wrote:
> Hi!
>
>>> +static int ad5820_registered(struct v4l2_subdev *subdev)
>>> +{
>>> +	struct ad5820_device *coil = to_ad5820_device(subdev);
>>> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
>>> +
>>> +	coil->vana = regulator_get(&client->dev, "VANA");
>>
>> devm_regulator_get()?
>
> I'd rather avoid devm_ here. Driver is simple enough to allow it.
>

Now thinking about it, what would happen here if regulator_get() returns 
-EPROBE_DEFER? Wouldn't it be better to move regulator_get to the 
probe() function, something like:

static int ad5820_probe(struct i2c_client *client,
			const struct i2c_device_id *devid)
{
	struct ad5820_device *coil;
	int ret = 0;

	coil = devm_kzalloc(sizeof(*coil), GFP_KERNEL);
	if (coil == NULL)
		return -ENOMEM;

	coil->vana = devm_regulator_get(&client->dev, NULL);
	if (IS_ERR(coil->vana)) {
		ret = PTR_ERR(coil->vana);
		if (ret != -EPROBE_DEFER)
			dev_err(&client->dev, "could not get regulator for vana\n");
		return ret;
	}

	mutex_init(&coil->power_lock);
...

with the appropriate changes to remove() because of the devm API usage.

>>> +#define AD5820_RAMP_MODE_LINEAR		(0 << 3)
>>> +#define AD5820_RAMP_MODE_64_16		(1 << 3)
>>> +
>>> +struct ad5820_platform_data {
>>> +	int (*set_xshutdown)(struct v4l2_subdev *subdev, int set);
>>> +};
>>> +
>>> +#define to_ad5820_device(sd)	container_of(sd, struct ad5820_device, subdev)
>>> +
>>> +struct ad5820_device {
>>> +	struct v4l2_subdev subdev;
>>> +	struct ad5820_platform_data *platform_data;
>>> +	struct regulator *vana;
>>> +
>>> +	struct v4l2_ctrl_handler ctrls;
>>> +	u32 focus_absolute;
>>> +	u32 focus_ramp_time;
>>> +	u32 focus_ramp_mode;
>>> +
>>> +	struct mutex power_lock;
>>> +	int power_count;
>>> +
>>> +	int standby : 1;
>>> +};
>>> +
>>
>> The same for struct ad5820_device, is it really part of the public API?
>
> Let me check what can be done with it.
> 									Pavel
>
