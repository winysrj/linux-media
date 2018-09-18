Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54766 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbeIRQXl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 12:23:41 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 1/3] i2c: adv748x: store number of CSI-2 lanes described
 in device tree
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
 <3637555.oe00WY7olM@avalon>
 <73aff0c2-d058-c4ee-2d4c-e63eac724e98@ideasonboard.com>
 <1715235.WJqBHKOvrx@avalon>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <21b8a885-48c5-70c8-8866-1830c45c27a9@ideasonboard.com>
Date: Tue, 18 Sep 2018 11:51:34 +0100
MIME-Version: 1.0
In-Reply-To: <1715235.WJqBHKOvrx@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 18/09/18 11:46, Laurent Pinchart wrote:
> Hi Kieran,
> 
> On Tuesday, 18 September 2018 13:37:55 EEST Kieran Bingham wrote:
>> On 18/09/18 11:28, Laurent Pinchart wrote:
>>> On Tuesday, 18 September 2018 13:19:39 EEST Kieran Bingham wrote:
>>>> On 18/09/18 02:45, Niklas Söderlund wrote:
>>>>> The adv748x CSI-2 transmitters TXA and TXB can use different number of
>>>>> lines to transmit data on. In order to be able configure the device
>>>>> correctly this information need to be parsed from device tree and stored
>>>>> in each TX private data structure.
>>>>>
>>>>> TXA supports 1, 2 and 4 lanes while TXB supports 1 lane.
>>>>
>>>> Am I right in assuming that it is the CSI device which specifies the
>>>> number of lanes in their DT?
>>>
>>> Do you mean the CSI-2 receiver ? Both the receiver and the transmitter
>>> should specify the data lanes in their DT node.
>>
>> Yes, I should have said CSI-2 receiver.
>>
>> Aha - so *both* sides of the link have to specify the lanes and
>> presumably match with each other?
> 
> Yes, they should certainly match :-)

I assumed so :) - do we need to validate that at a framework level?
(or perhaps it already is, all I've only looked at this morning is
e-mails :D )

> 
>>>> Could we make this clear in the commit log (and possibly an extra
>>>> comment in the code). At first I was assuming we would have to declare
>>>> the number of lanes in the ADV748x TX DT node, but I don't think that's
>>>> the case.
>>>>
>>>>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>>>> ---
>>>>>
>>>>>  drivers/media/i2c/adv748x/adv748x-core.c | 49 ++++++++++++++++++++++++
>>>>>  drivers/media/i2c/adv748x/adv748x.h      |  1 +
>>>>>  2 files changed, 50 insertions(+)
>>>>>
>>>>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c
>>>>> b/drivers/media/i2c/adv748x/adv748x-core.c index
>>>>> 85c027bdcd56748d..a93f8ea89a228474 100644
>>>>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
>>>>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> 
> [snip]
> 
>>>>> +static int adv748x_parse_csi2_lanes(struct adv748x_state *state,
>>>>> +				    unsigned int port,
>>>>> +				    struct device_node *ep)
>>>>> +{
>>>>> +	struct v4l2_fwnode_endpoint vep;
>>>>> +	unsigned int num_lanes;
>>>>> +	int ret;
>>>>> +
>>>>> +	if (port != ADV748X_PORT_TXA && port != ADV748X_PORT_TXB)
>>>>> +		return 0;
>>>>> +
>>>>> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &vep);
>>>>> +	if (ret)
>>>>> +		return ret;
>>>>> +
>>>>> +	num_lanes = vep.bus.mipi_csi2.num_data_lanes;
>>>>> +
>>>>
>>>> If I'm not mistaken we are parsing /someone elses/ DT node here (the CSI
>>>> receiver or such).
>>>
>>> Aren't we parsing our own endpoint ? The ep argument comes from ep_np in
>>> adv748x_parse_dt(), and that's the endpoint iterator used with
>>>
>>> 	for_each_endpoint_of_node(state->dev->of_node, ep_np)
>>
>> Bah - my head was polluted with the async subdevice stuff where we were
>> getting the endpoint of the other device, but of course that's
>> completely unrelated here.
>>
>>>> Is it now guaranteed on the mipi_csi2 bus to have the (correct) lanes
>>>> defined?
>>>>
>>>> Do we need to fall back to some safe defaults at all (1 lane?) ?
>>>> Actually - perhaps there is no safe default. I guess if the lanes aren't
>>>> configured correctly we're not going to get a good signal at the other
>>>> end.
>>>
>>> The endpoints should contain a data-lanes property. That's the case in the
>>> mainline DT sources, but it's not explicitly stated as a mandatory
>>> property. I think we should update the bindings.
>>
>> Yes, - as this code change is making the property mandatory - we should
>> certainly state that in the bindings, unless we can fall back to a
>> sensible default (perhaps the max supported on that component?)
> 
> I'm not sure there's a sensible default, I'd rather specify it explicitly. 
> Note that the data-lanes property doesn't just specify the number of lanes, 
> but also how they are remapped, when that feature is supported by the CSI-2 
> transmitter or receiver.


Ok understood. As I feared - we can't really default - because it has to
match and be defined.

So making the DT property mandatory really is the way to go then.



>>>>> +	if (vep.base.port == ADV748X_PORT_TXA) {
>>>>> +		if (num_lanes != 1 && num_lanes != 2 && num_lanes != 4) {
>>>>> +			adv_err(state, "TXA: Invalid number (%d) of lanes\n",
>>>>> +				num_lanes);
>>>>> +			return -EINVAL;
>>>>> +		}
>>>>> +
>>>>> +		state->txa.num_lanes = num_lanes;
>>>>> +		adv_dbg(state, "TXA: using %d lanes\n", state->txa.num_lanes);
>>>>> +	}
>>>>> +
>>>>> +	if (vep.base.port == ADV748X_PORT_TXB) {
>>>>> +		if (num_lanes != 1) {
>>>>> +			adv_err(state, "TXB: Invalid number (%d) of lanes\n",
>>>>> +				num_lanes);
>>>>> +			return -EINVAL;
>>>>> +		}
>>>>> +
>>>>> +		state->txb.num_lanes = num_lanes;
>>>>> +		adv_dbg(state, "TXB: using %d lanes\n", state->txb.num_lanes);
>>>>> +	}
>>>>> +
>>>>> +	return 0;
>>>>> +}
> 
> [snip]
> 

-- 
Regards
--
Kieran
