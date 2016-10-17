Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35541 "EHLO
        mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932972AbcJQWgR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 18:36:17 -0400
Subject: Re: [PATCH v4 3/8] media: adv7180: add support for NEWAVMODE
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
 <1470247430-11168-4-git-send-email-steve_longerbeam@mentor.com>
 <3171592.lqAHMF38Fl@avalon>
Cc: lars@metafoo.de, mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <34b5e02c-fcfc-1dbe-f67e-aeced11debf5@gmail.com>
Date: Mon, 17 Oct 2016 15:36:14 -0700
MIME-Version: 1.0
In-Reply-To: <3171592.lqAHMF38Fl@avalon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/16/2016 05:18 AM, Laurent Pinchart wrote:
> Hi Steve,
>
> Thank you for the patch.
>
> On Wednesday 03 Aug 2016 11:03:45 Steve Longerbeam wrote:
>> Parse the optional v4l2 endpoint DT node. If the bus type is
>> V4L2_MBUS_BT656 and the endpoint node specifies "newavmode",
>> configure the BT.656 bus in NEWAVMODE.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>
>> ---
>>
>> v4: no changes
>> v3:
>> - the newavmode endpoint property is now private to adv7180.
>> ---
>>   .../devicetree/bindings/media/i2c/adv7180.txt      |  4 ++
>>   drivers/media/i2c/adv7180.c                        | 46 +++++++++++++++++--
>>   2 files changed, 47 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7180.txt
>> b/Documentation/devicetree/bindings/media/i2c/adv7180.txt index
>> 0d50115..6c175d2 100644
>> --- a/Documentation/devicetree/bindings/media/i2c/adv7180.txt
>> +++ b/Documentation/devicetree/bindings/media/i2c/adv7180.txt
>> @@ -15,6 +15,10 @@ Required Properties :
>>   		"adi,adv7282"
>>   		"adi,adv7282-m"
>>
>> +Optional Endpoint Properties :
>> +- newavmode: a boolean property to indicate the BT.656 bus is operating
>> +  in Analog Device's NEWAVMODE. Valid for BT.656 busses only.
> This is a vendor-specific property, it should be prefixed with "adi,".

Ok, I'll do that in next version.

>   Could
> you also explain how this mode works ? I'd like to make sure it qualifies for
> a DT property.

The blurb in the ADV718x manual is terse:

"When NEWAVMODE is 0 (enabled), EAV/SAV codes are generated to
suit Analog Devices encoders. No adjustments are possible."

"Setting NEWAVMODE to 1 (default) enables the manual position
of the VSYNC, FIELD, and AV codes using Register 0x32 to
Register 0x33 and Register 0xE5 to Register 0xEA. Default register
settings are CCIR656 compliant;"

So it's not clear to me how the generated EAV and SAV codes are
different from standard CCIR656, but apparently they are.

Steve


>
>> +
>>   Example:
>>
>>   	i2c0@1c22000 {
>> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
>> index 6e093c22..467953e 100644
>> --- a/drivers/media/i2c/adv7180.c
>> +++ b/drivers/media/i2c/adv7180.c
>> @@ -31,6 +31,7 @@
>>   #include <media/v4l2-event.h>
>>   #include <media/v4l2-device.h>
>>   #include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-of.h>
>>   #include <linux/mutex.h>
>>   #include <linux/delay.h>
>>
>> @@ -106,6 +107,7 @@
>>   #define ADV7180_REG_SHAP_FILTER_CTL_1	0x0017
>>   #define ADV7180_REG_CTRL_2		0x001d
>>   #define ADV7180_REG_VSYNC_FIELD_CTL_1	0x0031
>> +#define ADV7180_VSYNC_FIELD_CTL_1_NEWAVMODE 0x02
>>   #define ADV7180_REG_MANUAL_WIN_CTL_1	0x003d
>>   #define ADV7180_REG_MANUAL_WIN_CTL_2	0x003e
>>   #define ADV7180_REG_MANUAL_WIN_CTL_3	0x003f
>> @@ -214,6 +216,7 @@ struct adv7180_state {
>>   	struct mutex		mutex; /* mutual excl. when accessing chip */
>>   	int			irq;
>>   	v4l2_std_id		curr_norm;
>> +	bool			newavmode;
>>   	bool			powered;
>>   	bool			streaming;
>>   	u8			input;
>> @@ -864,9 +867,15 @@ static int adv7180_init(struct adv7180_state *state)
>>   	if (ret < 0)
>>   		return ret;
>>
>> -	/* Manually set V bit end position in NTSC mode */
>> -	return adv7180_write(state, ADV7180_REG_NTSC_V_BIT_END,
>> -					ADV7180_NTSC_V_BIT_END_MANUAL_NVEND);
>> +	if (!state->newavmode) {
>> +		/* Manually set V bit end position in NTSC mode */
>> +		ret = adv7180_write(state, ADV7180_REG_NTSC_V_BIT_END,
>> +				    ADV7180_NTSC_V_BIT_END_MANUAL_NVEND);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>> +	return 0;
>>   }
>>
>>   static int adv7180_set_std(struct adv7180_state *state, unsigned int std)
>> @@ -1217,6 +1226,13 @@ static int init_device(struct adv7180_state *state)
>>   	if (ret)
>>   		goto out_unlock;
>>
>> +	if (state->newavmode) {
>> +		ret = adv7180_write(state, ADV7180_REG_VSYNC_FIELD_CTL_1,
>> +				    ADV7180_VSYNC_FIELD_CTL_1_NEWAVMODE);
>> +		if (ret < 0)
>> +			goto out_unlock;
>> +	}
>> +
>>   	ret = adv7180_program_std(state);
>>   	if (ret)
>>   		goto out_unlock;
>> @@ -1257,6 +1273,28 @@ out_unlock:
>>   	return ret;
>>   }
>>
>> +static void adv7180_of_parse(struct adv7180_state *state)
>> +{
>> +	struct i2c_client *client = state->client;
>> +	struct device_node *np = client->dev.of_node;
>> +	struct device_node *endpoint;
>> +	struct v4l2_of_endpoint	ep;
>> +
>> +	endpoint = of_graph_get_next_endpoint(np, NULL);
>> +	if (!endpoint) {
>> +		v4l_warn(client, "endpoint node not found\n");
>> +		return;
>> +	}
>> +
>> +	v4l2_of_parse_endpoint(endpoint, &ep);
>> +	if (ep.bus_type == V4L2_MBUS_BT656) {
>> +		if (of_property_read_bool(endpoint, "newavmode"))
>> +			state->newavmode = true;
>> +	}
>> +
>> +	of_node_put(endpoint);
>> +}
>> +
>>   static int adv7180_probe(struct i2c_client *client,
>>   			 const struct i2c_device_id *id)
>>   {
>> @@ -1279,6 +1317,8 @@ static int adv7180_probe(struct i2c_client *client,
>>   	state->field = V4L2_FIELD_ALTERNATE;
>>   	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
>>
>> +	adv7180_of_parse(state);
>> +
>>   	if (state->chip_info->flags & ADV7180_FLAG_MIPI_CSI2) {
>>   		state->csi_client = i2c_new_dummy(client->adapter,
>>   				ADV7180_DEFAULT_CSI_I2C_ADDR);

