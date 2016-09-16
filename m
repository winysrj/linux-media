Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:53173 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751180AbcIPIoq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 04:44:46 -0400
Subject: Re: [PATCH v8 1/2] media: adv7604: automatic "default-input"
 selection
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
References: <20160915132408.20776-1-ulrich.hecht+renesas@gmail.com>
 <20160915132408.20776-2-ulrich.hecht+renesas@gmail.com>
 <1962610.tCZYpFzJAm@avalon>
Cc: niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, magnus.damm@gmail.com,
        william.towle@codethink.co.uk
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2e0c5872-e914-6dd2-cd9c-4b39416f8180@xs4all.nl>
Date: Fri, 16 Sep 2016 10:44:41 +0200
MIME-Version: 1.0
In-Reply-To: <1962610.tCZYpFzJAm@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

What should I do with this? I dropped it for now.

I'm just going ahead and post the pull request without this patch as I
don't want this to be a blocker.

Regards,

	Hans

On 09/15/2016 06:42 PM, Laurent Pinchart wrote:
> Hi Ulrich,
> 
> Thank you for the patch.
> 
> On Thursday 15 Sep 2016 15:24:07 Ulrich Hecht wrote:
>> Fall back to input 0 if "default-input" property is not present.
>>
>> Additionally, documentation in commit bf9c82278c34 ("[media]
>> media: adv7604: ability to read default input port from DT") states
>> that the "default-input" property should reside directly in the node
>> for adv7612.
> 
> Actually it doesn't. The DT bindings specifies "default-input" as an endpoint 
> property, even though the example sets it in the device node. That's 
> inconsistent so the DT bindings document should be fixed. I believe the 
> property should be set in the device node, it doesn't make much sense to have 
> different default inputs per port.
> 
>> Hence, also adjust the parsing to make the implementation
>> consistent with this.
>>
>> Based on patch by William Towle <william.towle@codethink.co.uk>.
>>
>> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
>> ---
>>  drivers/media/i2c/adv7604.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
>> index 4003831..055c9df 100644
>> --- a/drivers/media/i2c/adv7604.c
>> +++ b/drivers/media/i2c/adv7604.c
>> @@ -3077,10 +3077,13 @@ static int adv76xx_parse_dt(struct adv76xx_state
>> *state) if (!of_property_read_u32(endpoint, "default-input", &v))
>>  		state->pdata.default_input = v;
>>  	else
>> -		state->pdata.default_input = -1;
>> +		state->pdata.default_input = 0;
>>
>>  	of_node_put(endpoint);
>>
>> +	if (!of_property_read_u32(np, "default-input", &v))
>> +		state->pdata.default_input = v;
>> +
>>  	flags = bus_cfg.bus.parallel.flags;
>>
>>  	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> 
