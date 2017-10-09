Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:48919 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750930AbdJIIgG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 04:36:06 -0400
Received: by mail-wm0-f52.google.com with SMTP id i124so20172305wmf.3
        for <linux-media@vger.kernel.org>; Mon, 09 Oct 2017 01:36:05 -0700 (PDT)
Subject: Re: [PATCH] [media] ov5645: I2C address change
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, hansverk@cisco.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>
References: <1506950925-13924-1-git-send-email-todor.tomov@linaro.org>
 <20171004103008.g7azpn4a3hfj4fs2@valkosipuli.retiisi.org.uk>
 <3073637.dhNDna4gKQ@avalon>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <edc2f078-0896-d9c7-f52a-e5d0604fdeea@linaro.org>
Date: Mon, 9 Oct 2017 11:36:01 +0300
MIME-Version: 1.0
In-Reply-To: <3073637.dhNDna4gKQ@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On  4.10.2017 13:47, Laurent Pinchart wrote:
> CC'ing the I2C mainling list and the I2C maintainer.
> 
> On Wednesday, 4 October 2017 13:30:08 EEST Sakari Ailus wrote:
>> Hi Todor,
>>
>> On Mon, Oct 02, 2017 at 04:28:45PM +0300, Todor Tomov wrote:
>>> As soon as the sensor is powered on, change the I2C address to the one
>>> specified in DT. This allows to use multiple physical sensors connected
>>> to the same I2C bus.
>>>
>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>>
>> The smiapp driver does something similar and I understand Laurent might be
>> interested in such functionality as well.
>>
>> It'd be nice to handle this through the I²C framework instead and to define
>> how the information is specified through DT. That way it could be made
>> generic, to work with more devices than just this one.
>>
>> What do you think?

Thank you for this suggestion.

The way I have done it is to put the new I2C address in the DT and the driver
programs the change using the original I2C address. The original I2C address
is hardcoded in the driver. So maybe we can extend the DT binding and the I2C
framework so that both addresses come from the DT and avoid hiding the
original I2C address in the driver. This sounds good to me.

Then changing the address could be device specific and also this must be done
right after power on so that there are no address conflicts. So I don't think
that we can support this through the I2C framework only, the drivers that we
want to do that will have to be expanded with this functionality. Or do you
have any other idea?

Best regards,
Todor 

>>
>> Cc Laurent.
>>
>>> ---
>>>
>>>  drivers/media/i2c/ov5645.c | 42 ++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 42 insertions(+)
>>>
>>> diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
>>> index d28845f..8541109 100644
>>> --- a/drivers/media/i2c/ov5645.c
>>> +++ b/drivers/media/i2c/ov5645.c
>>> @@ -33,6 +33,7 @@
>>>  #include <linux/i2c.h>
>>>  #include <linux/init.h>
>>>  #include <linux/module.h>
>>> +#include <linux/mutex.h>
>>>  #include <linux/of.h>
>>>  #include <linux/of_graph.h>
>>>  #include <linux/regulator/consumer.h>
>>> @@ -42,6 +43,8 @@
>>>  #include <media/v4l2-fwnode.h>
>>>  #include <media/v4l2-subdev.h>
>>>
>>> +static DEFINE_MUTEX(ov5645_lock);
>>> +
>>>  #define OV5645_VOLTAGE_ANALOG               2800000
>>>  #define OV5645_VOLTAGE_DIGITAL_CORE         1500000
>>>  #define OV5645_VOLTAGE_DIGITAL_IO           1800000
>>> @@ -590,6 +593,31 @@ static void ov5645_regulators_disable(struct ov5645
>>> *ov5645)
>>>  		dev_err(ov5645->dev, "io regulator disable failed\n");
>>>  }
>>>
>>> +static int ov5645_write_reg_to(struct ov5645 *ov5645, u16 reg, u8 val,
>>> +			       u16 i2c_addr)
>>> +{
>>> +	u8 regbuf[3] = {
>>> +		reg >> 8,
>>> +		reg & 0xff,
>>> +		val
>>> +	};
>>> +	struct i2c_msg msgs = {
>>> +		.addr = i2c_addr,
>>> +		.flags = 0,
>>> +		.len = 3,
>>> +		.buf = regbuf
>>> +	};
>>> +	int ret;
>>> +
>>> +	ret = i2c_transfer(ov5645->i2c_client->adapter, &msgs, 1);
>>> +	if (ret < 0)
>>> +		dev_err(ov5645->dev,
>>> +			"%s: write reg error %d on addr 0x%x: reg=0x%x, val=0x%x\n",
>>> +			__func__, ret, i2c_addr, reg, val);
>>> +
>>> +	return ret;
>>> +}
>>> +
>>>  static int ov5645_write_reg(struct ov5645 *ov5645, u16 reg, u8 val)
>>>  {
>>>  	u8 regbuf[3];
>>> @@ -729,10 +757,24 @@ static int ov5645_s_power(struct v4l2_subdev *sd,
>>> int on)
>>>  	 */
>>>  	if (ov5645->power_count == !on) {
>>>  		if (on) {
>>> +			mutex_lock(&ov5645_lock);
>>> +
>>>  			ret = ov5645_set_power_on(ov5645);
>>>  			if (ret < 0)
>>>  				goto exit;
>>>
>>> +			ret = ov5645_write_reg_to(ov5645, 0x3100,
>>> +						ov5645->i2c_client->addr, 0x78);
>>> +			if (ret < 0) {
>>> +				dev_err(ov5645->dev,
>>> +					"could not change i2c address\n");
>>> +				ov5645_set_power_off(ov5645);
>>> +				mutex_unlock(&ov5645_lock);
>>> +				goto exit;
>>> +			}
>>> +
>>> +			mutex_unlock(&ov5645_lock);
>>> +
>>>  			ret = ov5645_set_register_array(ov5645,
>>>  					ov5645_global_init_setting,
>>>  					ARRAY_SIZE(ov5645_global_init_setting));
> 
