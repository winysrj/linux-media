Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:50826 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbZFOWYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 18:24:39 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Date: Mon, 15 Jun 2009 17:24:34 -0500
Subject: RE: [PATCH 7/10 - v2] DM355 platform changes for vpfe capture driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40139DF95B3@dlee06.ent.ti.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com>
 <1244739649-27466-7-git-send-email-m-karicheri2@ti.com>
 <1244739649-27466-8-git-send-email-m-karicheri2@ti.com>
 <200906141622.55197.hverkuil@xs4all.nl>
In-Reply-To: <200906141622.55197.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Please see my response below.

>> +	/* { plus irq  }, */
>>  	/* { I2C_BOARD_INFO("tlv320aic3x", 0x1b), }, */
>
>Huh? What's this? I only know the tlv320aic23b and that's an audio driver.
>
[MK] Thanks to David for answering this.
>> -	/* { I2C_BOARD_INFO("tvp5146", 0x5d), }, */
>>  };
>>
>>  static void __init evm_init_i2c(void)
>> @@ -178,6 +191,57 @@ static struct platform_device dm355evm_dm9000 = {
>>  	.num_resources	= ARRAY_SIZE(dm355evm_dm9000_rsrc),
>>  };
>>
>> +#define TVP514X_STD_ALL	(V4L2_STD_NTSC | V4L2_STD_PAL)
>> +/* Inputs available at the TVP5146 */
>> +static struct v4l2_input tvp5146_inputs[] = {
>> +	{
>> +		.index = 0,
>> +		.name = "COMPOSITE",
>
>Please, don't use all-caps. Just use "Composite" and "S-Video".
>
[MK] Ok
>> +		.type = V4L2_INPUT_TYPE_CAMERA,
>> +		.std = TVP514X_STD_ALL,
>> +	},
>> +	{
>> +		.index = 1,
>> +		.name = "SVIDEO",
>> +		.type = V4L2_INPUT_TYPE_CAMERA,
>> +		.std = TVP514X_STD_ALL,
>> +	},
>> +};
>> +
>> +/*
>> + * this is the route info for connecting each input to decoder
>> + * ouput that goes to vpfe. There is a one to one correspondence
>> + * with tvp5146_inputs
>> + */
>> +static struct v4l2_routing tvp5146_routes[] = {
>
>As mentioned elsewhere: v4l2_routing will disappear, so please don't use it.
>
[MK] Will change.
>> +	{
>> +		.input = INPUT_CVBS_VI2B,
>> +		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
>> +	},
>> +	{
>> +		.input = INPUT_SVIDEO_VI2C_VI1C,
>> +		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
>> +	},
>> +};
>> +
>> +static struct vpfe_subdev_info vpfe_sub_devs[] = {
>> +	{
>> +		.name = "tvp5146",
>> +		.grp_id = 0,
>> +		.num_inputs = ARRAY_SIZE(tvp5146_inputs),
>> +		.inputs = tvp5146_inputs,
>> +		.routes = tvp5146_routes,
>> +		.can_route = 1,
>> +	}
>> +};
>
>A general remark: currently you link your inputs directly to a subdev. This
>approach has two disadvantages:
>
>1) It doesn't work if there are no subdevs at all (e.g. because everything
>goes through an fpga).
>
[MK] Not sure what you mean here. If there is an FPGA, there should be something to make a selection between FPGA vs the rest of the decoders. FPGA will have an input and there should be some way it reports the detected standard etc. So why can't it be implemented by a sub device (may be less configuration since most of the logic is in FPGA).  
>2) It fixes the reported order of the inputs to the order of the subdevs.
>
[MK]Is that an issue? I don't see why.
>I think it is better to have a separate array of input descriptions that
>refer to a subdev when an input is associated with that subdev. 
[MK] Are suggesting an link from input array entry into sub device entry input index? How do you translate the input from application to a sub device or FPGA input? What if there are two "composite" inputs on two different sub devices?

>flexible that way, and I actually think that the vpfe driver will be
>simplified as well.
[MK], Not sure at this point.

Murali
m-karicher2@ti.com
