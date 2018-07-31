Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38408 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731905AbeGaNGV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 09:06:21 -0400
Received: by mail-wr1-f66.google.com with SMTP id v14-v6so16266267wro.5
        for <linux-media@vger.kernel.org>; Tue, 31 Jul 2018 04:26:28 -0700 (PDT)
Subject: Re: [PATCH 18/22] partial revert of "[media] tvp5150: add HW input
 connectors support"
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Marco Felsch <m.felsch@pengutronix.de>, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, p.zabel@pengutronix.de,
        afshin.nasser@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
 <20180628162054.25613-19-m.felsch@pengutronix.de>
 <20180730151842.0fd99d01@coco.lan>
 <3a9f8715-a3a6-b250-82ad-6f2df6500767@redhat.com>
 <20180731070659.43afe417@coco.lan>
From: Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <759d76b0-dab2-17bb-970c-38233bafc708@redhat.com>
Date: Tue, 31 Jul 2018 13:26:09 +0200
MIME-Version: 1.0
In-Reply-To: <20180731070659.43afe417@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 07/31/2018 12:06 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 31 Jul 2018 10:52:56 +0200
> Javier Martinez Canillas <javierm@redhat.com> escreveu:
> 
>> Hello Mauro,
>>
>> On 07/30/2018 08:18 PM, Mauro Carvalho Chehab wrote:
>>> Em Thu, 28 Jun 2018 18:20:50 +0200
>>> Marco Felsch <m.felsch@pengutronix.de> escreveu:
>>>   
>>>> From: Javier Martinez Canillas <javierm@redhat.com>
>>>>
>>>> Commit f7b4b54e6364 ("[media] tvp5150: add HW input connectors support")
>>>> added input signals support for the tvp5150, but the approach was found
>>>> to be incorrect so the corresponding DT binding commit 82c2ffeb217a
>>>> ("[media] tvp5150: document input connectors DT bindings") was reverted.
>>>>
>>>> This left the driver with an undocumented (and wrong) DT parsing logic,
>>>> so lets get rid of this code as well until the input connectors support
>>>> is implemented properly.
>>>>
>>>> It's a partial revert due other patches added on top of mentioned commit
>>>> not allowing the commit to be reverted cleanly anymore. But all the code
>>>> related to the DT parsing logic and input entities creation are removed.
>>>>
>>>> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
>>>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>> [m.felsch@pengutronix.de: rm TVP5150_INPUT_NUM define]
>>>> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
>>>> ---  
>>>
>>> ...
>>>   
>>>> -static int tvp5150_registered(struct v4l2_subdev *sd)
>>>> -{
>>>> -#ifdef CONFIG_MEDIA_CONTROLLER
>>>> -	struct tvp5150 *decoder = to_tvp5150(sd);
>>>> -	int ret = 0;
>>>> -	int i;
>>>> -
>>>> -	for (i = 0; i < TVP5150_INPUT_NUM; i++) {
>>>> -		struct media_entity *input = &decoder->input_ent[i];
>>>> -		struct media_pad *pad = &decoder->input_pad[i];
>>>> -
>>>> -		if (!input->name)
>>>> -			continue;
>>>> -
>>>> -		decoder->input_pad[i].flags = MEDIA_PAD_FL_SOURCE;
>>>> -
>>>> -		ret = media_entity_pads_init(input, 1, pad);
>>>> -		if (ret < 0)
>>>> -			return ret;
>>>> -
>>>> -		ret = media_device_register_entity(sd->v4l2_dev->mdev, input);
>>>> -		if (ret < 0)
>>>> -			return ret;
>>>> -
>>>> -		ret = media_create_pad_link(input, 0, &sd->entity,
>>>> -					    DEMOD_PAD_IF_INPUT, 0);
>>>> -		if (ret < 0) {
>>>> -			media_device_unregister_entity(input);
>>>> -			return ret;
>>>> -		}
>>>> -	}
>>>> -#endif  
>>>
>>> Hmm... I suspect that reverting this part may cause problems for drivers
>>> like em28xx when compiled with MC, as they rely that the supported demods
>>> will have 3 pads (DEMOD_NUM_PADS).
>>>  
>>
>> I don't see how this change could affect em28xx and other drivers. The function
>> tvp5150_registered() being removed here, only register the media entity and add
>> a link if input->name was set. This is set in tvp5150_parse_dt() and only if a
>> input connector as defined in the Device Tree file.
>>
>> In other words, all the code removed by this patch is DT-only and isn't used by
>> any media driver that makes use of the tvp5151.
>>
>> As mentioned in the commit message, this code has never been used (besides from
>> my testings) and should had been removed when the DT binding was reverted, but
>> for some reasons the first patch landed and the second didn't at the time.
> 
> Short answer: 
> 
> Yeah, you're right. Yet, patch 19/22 will cause regressions.
>
> Long answer:
> 
> That's easy enough to test.
> 
> Without this patch, a em28xx-based board (Terratec Grabster AV350) reports:
> 
> $ ./mc_nextgen_test -D
> digraph board {
> 	rankdir=TB
> 	colorscheme=x11
> 	labelloc="t"
> 	label="Grabster AV 350
>  driver:em28xx, bus: usb-0000:00:14.0-2
> "
> 	intf_devnode_7 [label="intf_devnode_7\nvideo\n/dev/video0", shape=box, style=filled, fillcolor=yellow]
> 	intf_devnode_10 [label="intf_devnode_10\nvbi\n/dev/vbi0", shape=box, style=filled, fillcolor=yellow]
> 	entity_1 [label="{{<pad_2> 0} | entity_1\nATV decoder\ntvp5150 0-005c | {<pad_3> 1 | <pad_4> 2}}", shape=Mrecord, style=filled, fillcolor=lightblue]
> 	entity_6 [label="{{<pad_12> 0} | entity_6\nV4L I/O\n2-2:1.0 video}", shape=Mrecord, style=filled, fillcolor=aquamarine]
> 	entity_9 [label="{{<pad_13> 0} | entity_9\nVBI I/O\n2-2:1.0 vbi}", shape=Mrecord, style=filled, fillcolor=aquamarine]
> 	entity_14 [label="{entity_14\nunknown entity type\nComposite | {<pad_15> 0}}", shape=Mrecord, style=filled, fillcolor=cadetblue]
> 	entity_16 [label="{entity_16\nunknown entity type\nS-Video | {<pad_17> 0}}", shape=Mrecord, style=filled, fillcolor=cadetblue]
> 	intf_devnode_7 -> entity_6 [dir="none" color="orange"]
> 	intf_devnode_10 -> entity_9 [dir="none" color="orange"]
> 	entity_1:pad_3 -> entity_6:pad_12 [color=blue]
> 	entity_1:pad_4 -> entity_9:pad_13 [color=blue]
> 	entity_14:pad_15 -> entity_1:pad_2 [color=blue]
> 	entity_16:pad_17 -> entity_1:pad_2 [color=blue style="dashed"]
> }
> 
> tvp5150 reports 3 pads (one input, two output pads), and media core
> properly connects the source pads.
> 
> With patch 18/22, I got the same graph. So, yeah, applying this patch
> won't cause regressions.
>

Yes, I didn't have time to review the other patches in the set yet. I was just
referring to patch 18/22 that it is really a standalone change and I've posted
it several times already. So I think that one is safe to merge.

> However, when we apply patch 19/22:
> 
> $ mc_nextgen_test -D
> digraph board {
> 	rankdir=TB
> 	colorscheme=x11
> 	labelloc="t"
> 	label="Grabster AV 350
>  driver:em28xx, bus: usb-0000:00:14.0-2
> "
> 	intf_devnode_7 [label="intf_devnode_7\nvideo\n/dev/video0", shape=box, style=filled, fillcolor=yellow]
> 	intf_devnode_10 [label="intf_devnode_10\nvbi\n/dev/vbi0", shape=box, style=filled, fillcolor=yellow]
> 	entity_1 [label="{{<pad_2> 0 | <pad_3> 1 | <pad_4> 2} | entity_1\nATV decoder\ntvp5150 0-005c | {<pad_5> 3}}", shape=Mrecord, style=filled, fillcolor=lightblue]
> 	entity_6 [label="{{<pad_12> 0} | entity_6\nV4L I/O\n2-2:1.0 video}", shape=Mrecord, style=filled, fillcolor=aquamarine]
> 	entity_9 [label="{{<pad_13> 0} | entity_9\nVBI I/O\n2-2:1.0 vbi}", shape=Mrecord, style=filled, fillcolor=aquamarine]
> 	entity_14 [label="{entity_14\nunknown entity type\nComposite | {<pad_15> 0}}", shape=Mrecord, style=filled, fillcolor=cadetblue]
> 	entity_16 [label="{entity_16\nunknown entity type\nS-Video | {<pad_17> 0}}", shape=Mrecord, style=filled, fillcolor=cadetblue]
> 	intf_devnode_7 -> entity_6 [dir="none" color="orange"]
> 	intf_devnode_10 -> entity_9 [dir="none" color="orange"]
> 	entity_1:pad_3 -> entity_6:pad_12 [color=blue]
> 	entity_1:pad_4 -> entity_9:pad_13 [color=blue]
> 	entity_14:pad_15 -> entity_1:pad_2 [color=blue]
> 	entity_16:pad_17 -> entity_1:pad_2 [color=blue style="dashed"]
> }
> 
> The graph is not built correct, as it is linking tvp5150's input pads as
> if they were output ones.
> 
> The problem is that now you need to teach drivers/media/v4l2-core/v4l2-mc.c
> to do the proper wiring for tvp5150.
> 
> I suspect that fixing v4l2-mc for doing that is not hard, but it may
> require changes at the other demods. Thankfully there aren't many
> demod drivers, but such patch should be applied before patch 19/22.
> 
> In the specific case of demods that don't support sliced VBI (or
> where sliced VBI is not coded), there should be just one source pad.
> 
> On demods with sliced VBI, there are actually two source pads,
> although, for simplicity, maybe we could map them as just one.
> 
> If we map as just one source pad, it is probably easy to change the
> code at v4l2-mc to do the right thing.
> 
> I'll do some tests here and try to code it.
>

Yes, another thing that patch 19/22 should take into account is DTs that
don't have input connectors defined. So probably TVP5150_PORT_YOUT should
be 0 instead of TVP5150_PORT_NUM - 1 as is the case in the current patch.

In other words, it should work both when input connectors are defined in
the DT and when these are not defined and only an output port is defined.

> Thanks,
> Mauro
> 

Best regards,
-- 
Javier Martinez Canillas
Software Engineer - Desktop Hardware Enablement
Red Hat
