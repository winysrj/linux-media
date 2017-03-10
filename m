Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:40001 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750922AbdCJI46 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 03:56:58 -0500
Subject: Re: [PATCHv3 04/15] ov7670: get xclk
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20170306145616.38485-1-hverkuil@xs4all.nl>
 <20170306145616.38485-5-hverkuil@xs4all.nl>
 <20170309203816.GQ3220@valkosipuli.retiisi.org.uk>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4ecb5aa4-40b6-5d78-03ba-239efbd0137e@xs4all.nl>
Date: Fri, 10 Mar 2017 09:55:53 +0100
MIME-Version: 1.0
In-Reply-To: <20170309203816.GQ3220@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/17 21:38, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Mar 06, 2017 at 03:56:05PM +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Get the clock for this sensor.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/i2c/ov7670.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
>> index 50e4466a2b37..da0843617a49 100644
>> --- a/drivers/media/i2c/ov7670.c
>> +++ b/drivers/media/i2c/ov7670.c
>> @@ -10,6 +10,7 @@
>>   * This file may be distributed under the terms of the GNU General
>>   * Public License, version 2.
>>   */
>> +#include <linux/clk.h>
>>  #include <linux/init.h>
>>  #include <linux/module.h>
>>  #include <linux/slab.h>
>> @@ -227,6 +228,7 @@ struct ov7670_info {
>>  		struct v4l2_ctrl *hue;
>>  	};
>>  	struct ov7670_format_struct *fmt;  /* Current format */
>> +	struct clk *clk;
>>  	int min_width;			/* Filter out smaller sizes */
>>  	int min_height;			/* Filter out smaller sizes */
>>  	int clock_speed;		/* External clock speed (MHz) */
>> @@ -1587,6 +1589,15 @@ static int ov7670_probe(struct i2c_client *client,
>>  			info->pclk_hb_disable = true;
>>  	}
>>  
>> +	info->clk = devm_clk_get(&client->dev, "xclk");
>> +	if (IS_ERR(info->clk))
>> +		return -EPROBE_DEFER;
>> +	clk_prepare_enable(info->clk);
>> +
>> +	info->clock_speed = clk_get_rate(info->clk) / 1000000;
>> +	if (info->clock_speed < 10 || info->clock_speed > 48)
>> +		return -EINVAL;
> 
> clk_disable_unprepare() before return?

It is my understanding that devm_clk_get will call that for you.

Correct me if I am wrong.

Regards,

	Hans

> 
>> +
>>  	/* Make sure it's an ov7670 */
>>  	ret = ov7670_detect(sd);
>>  	if (ret) {
>> @@ -1667,6 +1678,7 @@ static int ov7670_remove(struct i2c_client *client)
>>  
>>  	v4l2_device_unregister_subdev(sd);
>>  	v4l2_ctrl_handler_free(&info->hdl);
>> +	clk_disable_unprepare(info->clk);
>>  	return 0;
>>  }
>>  
> 
