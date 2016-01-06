Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37409 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbcAFLjN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2016 06:39:13 -0500
Subject: Re: [PATCH 09/10] [media] tvp5150: Initialize the chip on probe
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1451910332-23385-1-git-send-email-javier@osg.samsung.com>
 <1451910332-23385-10-git-send-email-javier@osg.samsung.com>
 <1730920.ntKvfybiDd@avalon>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Message-ID: <568CFCD9.1010809@osg.samsung.com>
Date: Wed, 6 Jan 2016 08:39:05 -0300
MIME-Version: 1.0
In-Reply-To: <1730920.ntKvfybiDd@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On 01/06/2016 07:59 AM, Laurent Pinchart wrote:
> Hi Javier,
> 
> Thankk you for the patch.
>

Thanks a lot for your feedback.
 
> On Monday 04 January 2016 09:25:31 Javier Martinez Canillas wrote:
>> After power-up, the tvp5150 decoder is in a unknown state until the
>> RESETB pin is driven LOW which reset all the registers and restarts
>> the chip's internal state machine.
>>
>> The init sequence has some timing constraints and the RESETB signal
>> can only be used if the PDN (Power-down) pin is first released.
>>
>> So, the initialization sequence is as follows:
>>
>> 1- PDN (active-low) is driven HIGH so the chip is power-up
>> 2- A 20 ms delay is needed before sending a RESETB (active-low) signal.
>> 3- The RESETB pulse duration is 500 ns.
>> 4- A 200 us delay is needed for the I2C client to be active after reset.
>>
>> This patch used as a reference the logic in the IGEPv2 board file from
>> the ISEE 2.6.37 vendor tree.
>>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> ---
>>
>>  drivers/media/i2c/tvp5150.c | 35 +++++++++++++++++++++++++++++++++++
>>  1 file changed, 35 insertions(+)
>>
>> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
>> index caac96a577f8..fed89a811ab7 100644
>> --- a/drivers/media/i2c/tvp5150.c
>> +++ b/drivers/media/i2c/tvp5150.c
>> @@ -5,6 +5,7 @@
>>   * This code is placed under the terms of the GNU General Public License v2
>> */
>>
>> +#include <linux/of_gpio.h>
> 
> Let's keep the headers sorted alphabetically if you don't mind :-)
>

Right, sorry about that.
 
>>  #include <linux/i2c.h>
>>  #include <linux/slab.h>
>>  #include <linux/videodev2.h>
>> @@ -1197,6 +1198,36 @@ static int tvp5150_detect_version(struct tvp5150
>> *core) return 0;
>>  }
>>
>> +static inline int tvp5150_init(struct i2c_client *c)
>> +{
>> +	struct gpio_desc *pdn_gpio;
>> +	struct gpio_desc *reset_gpio;
>> +
>> +	pdn_gpio = devm_gpiod_get_optional(&c->dev, "powerdown", GPIOD_OUT_HIGH);
>> +	if (IS_ERR(pdn_gpio))
>> +		return PTR_ERR(pdn_gpio);
>> +
>> +	if (pdn_gpio) {
>> +		gpiod_set_value_cansleep(pdn_gpio, 0);
>> +		/* Delay time between power supplies active and reset */
>> +		msleep(20);
> 
> How about usleep_range() instead ?
>

Documentation/timers/timers-howto.txt says that usleep_range() should be
used for 1ms - 20ms and msleep() for 20ms+ so since this was a boundary
value, I chose for msleep() but I can use usleep_range() if you want.

I've no strong opinion on this.

>> +	}
>> +
>> +	reset_gpio = devm_gpiod_get_optional(&c->dev, "reset", GPIOD_OUT_HIGH);
>> +	if (IS_ERR(reset_gpio))
>> +		return PTR_ERR(reset_gpio);
>> +
>> +	if (reset_gpio) {
>> +		/* RESETB pulse duration */
>> +		ndelay(500);
> 
> Is the timing so sensitive that we need a delay, or could we use 
> usleep_range() ?
>

According to my tests, it is a minimum value but I chose to do a delay since
the time is very short and also Documentation/timers/timers-howto.txt says
that using usleep for very short periods may not be worth it due the overhead
of setting up the hrtimers for usleep.

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
