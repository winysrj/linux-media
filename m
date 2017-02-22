Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:58991 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932435AbdBVLnR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 06:43:17 -0500
Subject: Re: [PATCH v9 2/2] Add support for OV5647 sensor.
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>
References: <cover.1487334912.git.roliveir@synopsys.com>
 <412e51e695630281d2084a77c0329fd273ea00d7.1487334912.git.roliveir@synopsys.com>
 <cea82e22-07eb-dd8a-c781-7384ac27823e@mentor.com>
 <c39814c2-20a0-db08-38c1-ce95ccc49738@synopsys.com>
 <21847f33-901c-7d26-15d8-6b92f10c8b15@mentor.com>
 <94622194-78dc-ad6f-3f6e-4d7df0ac5383@synopsys.com>
CC: <CARLOS.PALMINHA@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Message-ID: <822b6916-3de8-70f2-7a86-2723f31c76ba@mentor.com>
Date: Wed, 22 Feb 2017 13:43:09 +0200
MIME-Version: 1.0
In-Reply-To: <94622194-78dc-ad6f-3f6e-4d7df0ac5383@synopsys.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/22/2017 12:51 PM, Ramiro Oliveira wrote:
> Hi Zakari,
> 
> On 2/21/2017 8:36 PM, Vladimir Zapolskiy wrote:
>> Hi Ramiro,
>>
>> On 02/21/2017 06:42 PM, Ramiro Oliveira wrote:
>>> Hi Vladimir,
>>>
>>> Thank you for your feedback
>>>
>>> On 2/21/2017 3:54 PM, Vladimir Zapolskiy wrote:
>>>> Hi Ramiro,
>>>>
>>>> please find some review comments below.
>>>>
>>>> On 02/17/2017 03:14 PM, Ramiro Oliveira wrote:
>>>>> The OV5647 sensor from Omnivision supports up to 2592x1944 @ 15 fps, RAW 8
>>>>> and RAW 10 output formats, and MIPI CSI-2 interface.
>>>>>
>>>>> The driver adds support for 640x480 RAW 8.
>>>>>
>>>>> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
>>>>> ---
>>>>
>>>> [snip]
>>>>
>>>>> +
>>>>> +struct ov5647 {
>>>>> +	struct v4l2_subdev		sd;
>>>>> +	struct media_pad		pad;
>>>>> +	struct mutex			lock;
>>>>> +	struct v4l2_mbus_framefmt	format;
>>>>> +	unsigned int			width;
>>>>> +	unsigned int			height;
>>>>> +	int				power_count;
>>>>> +	struct clk			*xclk;
>>>>> +	/* External clock frequency currently supported is 30MHz */
>>>>> +	u32				xclk_freq;
>>>>
>>>> See a comment about 25MHz vs 30MHz below.
>>>>
>>>> Also I assume you can remove 'xclk_freq' from the struct fields,
>>>> it can be replaced by a local variable.
>>>>
>>>
>>> I'll do that.
>>>
>>>>> +};
>>>>
>>>> [snip]
>>>>
>>>>> +
>>>>> +static int ov5647_read(struct v4l2_subdev *sd, u16 reg, u8 *val)
>>>>> +{
>>>>> +	int ret;
>>>>> +	unsigned char data_w[2] = { reg >> 8, reg & 0xff };
>>>>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>>>>> +
>>>>> +	ret = i2c_master_send(client, data_w, 2);
>>>>> +	if (ret < 0) {
>>>>> +		dev_dbg(&client->dev, "%s: i2c read error, reg: %x\n",
>>>>
>>>> s/i2c read error/i2c write error/
>>>>
>>>
>>> I'm not sure I understand what you mean.
>>
>> That's a sed expression for string substitution. Here you do i2c_master_send()
>> but dev_dbg() comment says "i2c read error". It's a simple copy-paste typo to fix.
>>
> 
> Ohh... now I see. I'll change it.
> 
>>>>> +			__func__, reg);
>>>>> +		return ret;
>>>>> +	}
>>>>> +
>>
>> [snip]
>>
>>>>> +
>>>>> +static int sensor_power(struct v4l2_subdev *sd, int on)
>>
>> On the caller's side (functions ov5647_open() and ov5647_close()) the second
>> argument of the function is of 'bool' type, however .s_power callback from
>> struct v4l2_subdev_core_ops (see include/media/v4l2-subdev.h) defines it as
>> 'int'.
>>
>> It's just a nitpicking, please feel free to ignore the comment above or
>> please consider to change the arguments on callers' side to integers.
>>
>> Also you may consider to add 'ov5647_' prefix to the function name to
>> distinguish it from a potentially added in future sensor_power() function,
>> the original name sounds too generic.
>>
> 
> OK. I'll add the prefix and change the variable type from int to bool.
> 

Just to eliminate any potential misunderstanding, if you consider to reuse
the current sensor_power() function, please change variables from bool to int
on a caller's side, the signature of the function shall not be changed to
match .s_power type.

>>>>> +{
>>>>> +	int ret;
>>>>> +	struct ov5647 *ov5647 = to_state(sd);
>>>>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>>>>> +
>>>>> +	ret = 0;
>>>>> +	mutex_lock(&ov5647->lock);
>>>>> +
>>>>> +	if (on && !ov5647->power_count)	{
>>>>> +		dev_dbg(&client->dev, "OV5647 power on\n");
>>>>> +
>>>>> +		clk_set_rate(ov5647->xclk, ov5647->xclk_freq);
>>>>
>>>> Now clk_set_rate() is redundant, please remove it.
>>>>
>>>> If once it is needed again, please move it to the .probe function, so
>>>> it is called only once in the runtime.
>>>>
>>>
>>> Ok. I'll remove it for now.
>>>
>>>>> +
>>>>> +		ret = clk_prepare_enable(ov5647->xclk);
>>>>
>>>> I wonder would it be possible to unload the driver or to unbind the device
>>>> and leave the clock unintentionally enabled? If yes, then this is a bug.
>>>>
>>>
>>> You're saying that if the driver was unloaded and the clock was left enabled
>>> when the driver was loaded again this line would cause an error?
>>
>> Not exactly, here I saw a potential resource leak, namely a potentially left
>> prepared/enabled clock.
>>
>>>
>>> Should I disable the clock when the driver is removed?
>>>
>>
>> The driver (and framework) shall guarantee that when it is detached from
>> device(s) (e.g. by unloading "ov5647" kernel module or unbinding ov5647 device),
>> all acquired resources are released.
>>
>> But in this particular case most probably I've been overly alert, I believe
>> that V4L2 framework correcly handles device power states, so please ignore my
>> comment.
>>
>> To add something valuable to the review, could you please confirm that
>> ov5647_subdev_internal_ops data is in use by the driver?
>>
>> E.g. shouldn't it be registered by
>>
>>   sd->internal_ops = &ov5647_subdev_internal_ops;
>>
>> before calling v4l2_async_register_subdev(sd) ?
>>
> 
> You're right, it's not being registered. I think I'll remove them since they
> aren't being used.
> 

--
With best wishes,
Vladimir
