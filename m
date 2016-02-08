Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-145.synserver.de ([212.40.185.145]:1244 "EHLO
	smtp-out-195.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751489AbcBHJ34 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2016 04:29:56 -0500
Subject: Re: [PATCH v3] adv7604: add direct interrupt handling
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
References: <1452698143-31897-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <569CC821.6040905@xs4all.nl> <56B85ED0.9050302@xs4all.nl>
Cc: magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	william.towle@codethink.co.uk, sergei.shtylyov@cogentembedded.com
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <56B8600F.1080003@metafoo.de>
Date: Mon, 8 Feb 2016 10:29:51 +0100
MIME-Version: 1.0
In-Reply-To: <56B85ED0.9050302@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/08/2016 10:24 AM, Hans Verkuil wrote:
> Hi Ulrich,
> 
> On 01/18/2016 12:10 PM, Hans Verkuil wrote:
>> On 01/13/2016 04:15 PM, Ulrich Hecht wrote:
>>> When probed from device tree, the i2c client driver can handle the
>>> interrupt on its own.
>>>
>>> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
>>> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> ---
>>> v3: uses IRQ_RETVAL
>>>
>>> v2: implements the suggested style changes and drops the IRQF_TRIGGER_LOW
>>> flag, which is handled in the device tree.
>>>
>>>
>>>  drivers/media/i2c/adv7604.c | 24 ++++++++++++++++++++++--
>>>  1 file changed, 22 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
>>> index 5bd81bd..ab4cb25 100644
>>> --- a/drivers/media/i2c/adv7604.c
>>> +++ b/drivers/media/i2c/adv7604.c
>>> @@ -31,6 +31,7 @@
>>>  #include <linux/gpio/consumer.h>
>>>  #include <linux/hdmi.h>
>>>  #include <linux/i2c.h>
>>> +#include <linux/interrupt.h>
>>>  #include <linux/kernel.h>
>>>  #include <linux/module.h>
>>>  #include <linux/slab.h>
>>> @@ -1971,6 +1972,16 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
>>>  	return 0;
>>>  }
>>>  
>>> +static irqreturn_t adv76xx_irq_handler(int irq, void *devid)
>>> +{
>>> +	struct adv76xx_state *state = devid;
>>> +	bool handled;
>>> +
>>> +	adv76xx_isr(&state->sd, 0, &handled);
>>> +
>>> +	return IRQ_RETVAL(handled);
>>> +}
>>> +
>>>  static int adv76xx_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
>>>  {
>>>  	struct adv76xx_state *state = to_state(sd);
>>> @@ -2844,8 +2855,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
>>>  		state->pdata.op_656_range = 1;
>>>  	}
>>>  
>>> -	/* Disable the interrupt for now as no DT-based board uses it. */
>>> -	state->pdata.int1_config = ADV76XX_INT1_CONFIG_DISABLED;
>>> +	state->pdata.int1_config = ADV76XX_INT1_CONFIG_ACTIVE_LOW;
>>
>> Hmm, this hardcodes the interrupt to active low. Can you use the DT to determine
>> whether it should be active low or high?
> 
> Just a reminder: I don't want to accept this patch without this change. In most
> cases an interrupt is active on high, not low, so I don't like to see this
> hardcoded.

I think the important part here is to configure the IRQ here in the same way
as the flags that are passed to request_irq(). Right now it does not pass
any flags to request_irq() which means the result is pretty much
unpredictable and depends on the default configuration of the IRQ chip
(which might change between kernel versions).

>>>  	/* Use the default I2C addresses. */
>>>  	state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] = 0x42;
>>> @@ -3235,6 +3245,16 @@ static int adv76xx_probe(struct i2c_client *client,
>>>  	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
>>>  			client->addr << 1, client->adapter->name);
>>>  
>>> +	if (client->irq) {
>>> +		err = devm_request_threaded_irq(&client->dev,
>>> +						client->irq,
>>> +						NULL, adv76xx_irq_handler,
>>> +						IRQF_ONESHOT,
>>> +						dev_name(&client->dev), state);
>>> +		if (err)
>>> +			goto err_entity;
>>> +	}
>>> +

