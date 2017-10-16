Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:59798 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752196AbdJPOTi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 10:19:38 -0400
Subject: Re: [PATCH v3 1/2] media: i2c: OV5647: ensure clock lane in LP-11
 state before streaming on
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Jacob Chen <jacob-chen@iotwrt.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mchehab@kernel.org>, <vladimir_zapolskiy@mentor.com>,
        <hans.verkuil@cisco.com>, <sakari.ailus@linux.intel.com>,
        <Luis.Oliveira@synopsys.com>, <p.zabel@pengutronix.de>,
        Joao Pinto <Joao.Pinto@synopsys.com>
References: <20171001102238.21585-1-jacob-chen@iotwrt.com>
 <20171016122331.p6pwvb6nkdkq57py@valkosipuli.retiisi.org.uk>
From: Luis Oliveira <Luis.Oliveira@synopsys.com>
Message-ID: <f105f473-c089-b10f-afaa-302c09074c2a@synopsys.com>
Date: Mon, 16 Oct 2017 15:19:09 +0100
MIME-Version: 1.0
In-Reply-To: <20171016122331.p6pwvb6nkdkq57py@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Sorry for the delay and thank you for the fix.
I just checked the databook and the changes makes sense.

cheers,
Luis

On 16-Oct-17 13:23, Sakari Ailus wrote:
> Luis,
> 
> Any comment on these?
> 
> On Sun, Oct 01, 2017 at 06:22:37PM +0800, Jacob Chen wrote:
>> When I was supporting Rpi Camera Module on the ASUS Tinker board,
>> I found this driver have some issues with rockchip's mipi-csi driver.
>> It didn't place clock lane in LP-11 state before performing
>> D-PHY initialisation.
>>
>> From our experience, on some OV sensors,
>> LP-11 state is not achieved while BIT(5)-0x4800 is cleared.
>>
>> So let's set BIT(5) and BIT(0) both while not streaming, in order to
>> coax the clock lane into LP-11 state.
>>
>> 0x4800 : MIPI CTRL 00
>> 	BIT(5) : clock lane gate enable
>> 		0: continuous
>> 		1: none-continuous
>> 	BIT(0) : manually set clock lane
>> 		0: Not used
>> 		1: used
>>
>> Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
>> ---
>>  drivers/media/i2c/ov5647.c | 13 ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
>> index 95ce90fdb876..247302d01f53 100644
>> --- a/drivers/media/i2c/ov5647.c
>> +++ b/drivers/media/i2c/ov5647.c
>> @@ -253,6 +253,10 @@ static int ov5647_stream_on(struct v4l2_subdev *sd)
>>  {
>>  	int ret;
>>  
>> +	ret = ov5647_write(sd, 0x4800, 0x04);
>> +	if (ret < 0)
>> +		return ret;
>> +
>>  	ret = ov5647_write(sd, 0x4202, 0x00);
>>  	if (ret < 0)
>>  		return ret;
>> @@ -264,6 +268,10 @@ static int ov5647_stream_off(struct v4l2_subdev *sd)
>>  {
>>  	int ret;
>>  
>> +	ret = ov5647_write(sd, 0x4800, 0x25);
>> +	if (ret < 0)
>> +		return ret;
>> +
>>  	ret = ov5647_write(sd, 0x4202, 0x0f);
>>  	if (ret < 0)
>>  		return ret;
>> @@ -320,7 +328,10 @@ static int __sensor_init(struct v4l2_subdev *sd)
>>  			return ret;
>>  	}
>>  
>> -	return ov5647_write(sd, 0x4800, 0x04);
>> +	/*
>> +	 * stream off to make the clock lane into LP-11 state.
>> +	 */
>> +	return ov5647_stream_off(sd);
>>  }
>>  
>>  static int ov5647_sensor_power(struct v4l2_subdev *sd, int on)
>> -- 
>> 2.14.1
>>
> 
Reviewed-by: Luis Oliveira <lolivei@synopsys.com>
