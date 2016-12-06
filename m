Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:35725 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbcLFRkm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 12:40:42 -0500
Received: by mail-pg0-f50.google.com with SMTP id p66so151524478pga.2
        for <linux-media@vger.kernel.org>; Tue, 06 Dec 2016 09:40:09 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        Bartosz =?utf-8?Q?Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>
Subject: Re: [PATCH v3 3/4] [media] davinci: vpif_capture: get subdevs from DT
References: <20161122155244.802-1-khilman@baylibre.com>
        <m2zikgh5f0.fsf@baylibre.com>
        <20161201075730.GP16630@valkosipuli.retiisi.org.uk>
        <2453889.B9pO7dWgEo@avalon>
        <d7aaa1d5-f11a-e361-b2fe-f0cf86d92008@xs4all.nl>
Date: Tue, 06 Dec 2016 09:40:06 -0800
In-Reply-To: <d7aaa1d5-f11a-e361-b2fe-f0cf86d92008@xs4all.nl> (Hans Verkuil's
        message of "Mon, 5 Dec 2016 13:27:36 +0100")
Message-ID: <m2mvg9ez2h.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 12/01/2016 10:16 AM, Laurent Pinchart wrote:
>> Hello,
>> 
>> On Thursday 01 Dec 2016 09:57:31 Sakari Ailus wrote:
>>> On Wed, Nov 30, 2016 at 04:14:11PM -0800, Kevin Hilman wrote:
>>>> Sakari Ailus <sakari.ailus@iki.fi> writes:
>>>>> On Wed, Nov 23, 2016 at 03:25:32PM -0800, Kevin Hilman wrote:
>>>>>> Sakari Ailus <sakari.ailus@iki.fi> writes:
>>>>>>> On Tue, Nov 22, 2016 at 07:52:43AM -0800, Kevin Hilman wrote:
>>>>>>>> Allow getting of subdevs from DT ports and endpoints.
>>>>>>>>
>>>>>>>> The _get_pdata() function was larely inspired by (i.e. stolen from)
>>>>>>>> am437x-vpfe.c
>>>>>>>>
>>>>>>>> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
>>>>>>>> ---
>>>>>>>>
>>>>>>>>  drivers/media/platform/davinci/vpif_capture.c | 130 +++++++++++++++-
>>>>>>>>  include/media/davinci/vpif_types.h     
>>>>>>>>        |   9 +-
>>>>>>>>  2 files changed, 133 insertions(+), 6 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/media/platform/davinci/vpif_capture.c
>>>>>>>> b/drivers/media/platform/davinci/vpif_capture.c index
>>>>>>>> 94ee6cf03f02..47a4699157e7 100644
>>>>>>>> --- a/drivers/media/platform/davinci/vpif_capture.c
>>>>>>>> +++ b/drivers/media/platform/davinci/vpif_capture.c
>>>>>>>> @@ -26,6 +26,8 @@
>>>>>>>>  #include <linux/slab.h>
>>>>>>>>
>>>>>>>>  #include <media/v4l2-ioctl.h>
>>>>>>>> +#include <media/v4l2-of.h>
>>>>>>>> +#include <media/i2c/tvp514x.h>
>>>>>>>
>>>>>>> Do you need this header?
>>>>>>
>>>>>> Yes, based on discussion with Hans, since there is no DT binding for
>>>>>> selecting the input pins of the TVP514x, I have to select it in the
>>>>>> driver, so I need the defines from this header.  More on this below...
>> 
>> That's really ugly :-( The problem should be fixed properly instead of adding 
>> one more offender.
>
> Do you have time for that, Laurent? I don't. Until that time we just need to
> make do with this workaround.
>
>> 
>>>>>>>>  #include "vpif.h"
>>>>>>>>  #include "vpif_capture.h"
>>>>>>>> @@ -650,6 +652,10 @@ static int vpif_input_to_subdev(
>>>>>>>>
>>>>>>>>  	vpif_dbg(2, debug, "vpif_input_to_subdev\n");
>>>>>>>>
>>>>>>>> +	if (!chan_cfg)
>>>>>>>> +		return -1;
>>>>>>>> +	if (input_index >= chan_cfg->input_count)
>>>>>>>> +		return -1;
>>>>>>>>  	subdev_name = chan_cfg->inputs[input_index].subdev_name;
>>>>>>>>  	if (subdev_name == NULL)
>>>>>>>>  		return -1;
>>>>>>>> @@ -657,7 +663,7 @@ static int vpif_input_to_subdev(
>>>>>>>>  	/* loop through the sub device list to get the sub device info
>>>>>>>>  	*/
>>>>>>>>  	for (i = 0; i < vpif_cfg->subdev_count; i++) {
>>>>>>>>  		subdev_info = &vpif_cfg->subdev_info[i];
>>>>>>>> -		if (!strcmp(subdev_info->name, subdev_name))
>>>>>>>> +		if (subdev_info && !strcmp(subdev_info->name,
>>>>>>>> subdev_name))
>>>>>>>>  			return i;
>>>>>>>>  	}
>>>>>>>>  	return -1;
>>>>>>>> @@ -1327,6 +1333,21 @@ static int vpif_async_bound(struct
>>>>>>>> v4l2_async_notifier *notifier,> >> >> 
>>>>>>>>  {
>>>>>>>>  	int i;
>>>>>>>>
>>>>>>>> +	for (i = 0; i < vpif_obj.config->asd_sizes[0]; i++) {
>>>>>>>> +		struct v4l2_async_subdev *_asd = vpif_obj.config
>>>>>>>> ->asd[i];
>>>>>>>> +		const struct device_node *node = _asd->match.of.node;
>>>>>>>> +
>>>>>>>> +		if (node == subdev->of_node) {
>>>>>>>> +			vpif_obj.sd[i] = subdev;
>>>>>>>> +			vpif_obj.config->chan_config
>>>>>>>> ->inputs[i].subdev_name =
>>>>>>>> +				(char *)subdev->of_node->full_name;
>> 
>> Can subdev_name be made const instead of blindly casting the full_name pointer 
>> ? If not this is probably unsafe, and if yes it should be done :-)
>> 
>>>>>>>> +			vpif_dbg(2, debug,
>>>>>>>> +				 "%s: setting input %d subdev_name =
>>>>>>>> %s\n",
>>>>>>>> +				 __func__, i, subdev->of_node
>>>>>>>> ->full_name);
>>>>>>>> +			return 0;
>>>>>>>> +		}
>>>>>>>> +	}
>>>>>>>> +
>>>>>>>>  	for (i = 0; i < vpif_obj.config->subdev_count; i++)
>>>>>>>>  		if (!strcmp(vpif_obj.config->subdev_info[i].name,
>>>>>>>>  			    subdev->name)) {
>>>>>>>> @@ -1422,6 +1443,110 @@ static int vpif_async_complete(struct
>>>>>>>> v4l2_async_notifier *notifier)
>>>>>>>>  	return vpif_probe_complete();
>>>>>>>>  }
>>>>>>>>
>>>>>>>> +static struct vpif_capture_config *
>>>>>>>> +vpif_capture_get_pdata(struct platform_device *pdev)
>>>>>>>> +{
>>>>>>>> +	struct device_node *endpoint = NULL;
>>>>>>>> +	struct v4l2_of_endpoint bus_cfg;
>>>>>>>> +	struct vpif_capture_config *pdata;
>>>>>>>> +	struct vpif_subdev_info *sdinfo;
>>>>>>>> +	struct vpif_capture_chan_config *chan;
>>>>>>>> +	unsigned int i;
>>>>>>>> +
>>>>>>>> +	dev_dbg(&pdev->dev, "vpif_get_pdata\n");
>>>>>>>> +
>>>>>>>> +	if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node)
>>>>>>>> +		return pdev->dev.platform_data;
>>>>>>>> +
>>>>>>>> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
>>>>>>>> +	if (!pdata)
>>>>>>>> +		return NULL;
>>>>>>>> +	pdata->subdev_info =
>>>>>>>> +		devm_kzalloc(&pdev->dev, sizeof(*pdata->subdev_info) *
>>>>>>>> +			     VPIF_CAPTURE_MAX_CHANNELS, GFP_KERNEL);
>>>>>>>> +
>>>>>>>> +	if (!pdata->subdev_info)
>>>>>>>> +		return NULL;
>>>>>>>> +	dev_dbg(&pdev->dev, "%s\n", __func__);
>>>>>>>> +
>>>>>>>> +	for (i = 0; ; i++) {
>>>>>>>> +		struct device_node *rem;
>>>>>>>> +		unsigned int flags;
>>>>>>>> +		int err;
>>>>>>>> +
>>>>>>>> +		endpoint = of_graph_get_next_endpoint(pdev
>>>>>>>> ->dev.of_node,
>>>>>>>> +						      endpoint);
>>>>>>>> +		if (!endpoint)
>>>>>>>> +			break;
>>>>>>>> +
>>>>>>>> +		sdinfo = &pdata->subdev_info[i];
>>>>>>>
>>>>>>> subdev_info[] has got VPIF_CAPTURE_MAX_CHANNELS entries only.
>>>>>>
>>>>>> Right, I need to make the loop only go for a max of
>>>>>> VPIF_CAPTURE_MAX_CHANNELS iterations.
>>>>>>
>>>>>>>> +		chan = &pdata->chan_config[i];
>>>>>>>> +		chan->inputs = devm_kzalloc(&pdev->dev,
>>>>>>>> +					    sizeof(*chan->inputs) *
>>>>>>>> +					    VPIF_DISPLAY_MAX_CHANNELS,
>>>>>>>> +					    GFP_KERNEL);
>>>>>>>> +
>>>>>>>> +		chan->input_count++;
>>>>>>>> +		chan->inputs[i].input.type = V4L2_INPUT_TYPE_CAMERA;
>>>>>>>
>>>>>>> I wonder what's the purpose of using index i on this array as well.
>>>>>>
>>>>>> The number of endpoints in DT is the number of input channels
>>>>>> configured (up to a max of VPIF_CAPTURE_MAX_CHANNELS.)
>>>>>>
>>>>>>> If you use that to access a corresponding entry in a different array,
>>>>>>> I'd just create a struct that contains the port configuration and the
>>>>>>> async sub-device. The omap3isp driver does that, for instance; see
>>>>>>> isp_of_parse_nodes() in drivers/media/platform/omap3isp/isp.c if
>>>>>>> you're interested. Up to you.
>>>>>>
>>>>>> OK, I'll have a look at that driver. The goal here with this series is
>>>>>> just to get this working with DT, but also not break the existing
>>>>>> legacy platform_device support, so I'm trying not to mess with the
>>>>>> driver-interal data structures too much.
>>>>>
>>>>> Ack.
>>>>>
>>>>>>>> +		chan->inputs[i].input.std = V4L2_STD_ALL;
>>>>>>>> +		chan->inputs[i].input.capabilities = V4L2_IN_CAP_STD;
>>>>>>>> +
>>>>>>>> +		/* FIXME: need a new property? ch0:composite ch1:
>>>>>>>> s-video */
>>>>>>>> +		if (i == 0)
>>>>>>>
>>>>>>> Can you assume that the first endopoint has got a particular kind of
>>>>>>> input? What if it's not connected?
>>>>>>
>>>>>> On all the boards I know of (there aren't many using this SoC), it's a
>>>>>> safe assumption.
>>>>>>
>>>>>>> If this is a different physical port (not in the meaning another) in
>>>>>>> the device, I'd use the reg property for this. Please see
>>>>>>> Documentation/devicetree/bindings/media/video-interfaces.txt .
>>>>>>
>>>>>> My understanding (which is admittedly somewhat fuzzy) of the TVP514x is
>>>>>> that it's not physically a different port.  Instead, it's just telling
>>>>>> the TVP514x which pin(s) will be active inputs (and what kind of signal
>>>>>> will be present.)
>>>>>>
>>>>>> I'm open to a better way to describe this input select from DT, but
>>>>>> based on what I heard from Hans, there isn't currently a good way to do
>>>>>> that except for in the driver:
>>>>>> (c.f. https://marc.info/?l=linux-arm-kernel&m=147887871615788)
>>>>>>
>>>>>> Based on further discussion in that thread, it sounds like there may be
>>>>>> a way forward coming soon, and I'll be glad to switch to that when it
>>>>>> arrives.
>> 
>> I'm afraid I have to disappoint Hans here, I don't have code for that yet.
>> 
>>>>> I'm not sure that properly supporting connectors will provide any help
>>>>> here.
>>>>>
>>>>> Looking at the s_routing() API, it's the calling driver that has to be
>>>>> aware of sub-device specific function parameters. As such it's not a
>>>>> very good idea to require that a driver is aware of the value range of
>>>>> another driver's parameter. I wonder if a simple enumeration interface
>>>>> would help here --- if I understand correctly, the purpose is just to
>>>>> provide a way to choose the input using VIDIOC_S_INPUT.
>>>>>
>>>>> I guess that's somehow ok as long as you have no other combinations of
>>>>> these devices but this is hardly future-proof. (And certainly not a
>>>>> problem created by this patch.)
>>>>
>>>> Yeah, this is far from future proof.
>>>>
>>>>> It'd be still nice to fix that as presumably we don't have the option of
>>>>> reworking how we expect the device tree to look like.
>>>>
>>>> Agreed.
>>>>
>>>> I'm just hoping someone can shed som light on "how we expect the device
>>>> tree to look".  ;)
>>>
>>> :-)
>>>
>>> For the tvp514x, do you need more than a single endpoint on the receiver
>>> side? Does the input that's selected affect the bus parameters?
>>>
>>> If it doesn't, you could create a custom endpoint property for the possible
>>> input values. The s_routing() really should be fixed though, but that could
>>> be postponed I guess. There are quite a few drivers using it.
>> 
>> There's two ways to look at s_routing() in my opinion, as the calling driver 
>> should really not hardcode any knowledge specific to a particular subdev. We 
>> can either have the calling driver discover the possible routing options at 
>> runtime through the subdev API, or modify the s_routing() API.
>> 
>
> Some historical perspective: s_routing was added well before the device tree
> was ever used for ARM. And at that time the vast majority of drivers were PCI
> or USB drivers, very few platform drivers existed (and those typically used
> sensors, not video receivers).
>
> Before s_routing existed the situation was even worse.
>
> Basically what s_routing does is a poor-man's device tree entry, telling the
> subdev how to route video or audio from connector to the output of the chip.
> Typically the card tables in PCI or USB drivers contain the correct arguments
> for s_routing. Of course, today we'd do that with the DT, but that was not an
> option years ago.

So I'm still confused on the path forward here.

I do not have the time (or the V4L2 knowledge/experience) to rework the
V4L2 internals to make this work, but I'm happy to test if someone else
is working on it.

In the meantime, what do we do with this series?  I have a couple minor
things to fixup based on review comments, but other than that, the
s_routing decision is blocking this from getting an update for use on DT
platforms.

The alternative is to go the OMAP route for legacy drivers like this and
just use pdata quirks for passing the legacy pdata (which has the input
and output routes hard-coded in platform_data). 

Kevin

