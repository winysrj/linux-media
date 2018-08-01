Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36156 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389336AbeHAPSV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 11:18:21 -0400
Date: Wed, 1 Aug 2018 10:32:21 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, p.zabel@pengutronix.de,
        afshin.nasser@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 18/22] partial revert of "[media] tvp5150: add HW input
 connectors support"
Message-ID: <20180801103221.1eeba3ec@coco.lan>
In-Reply-To: <20180801121047.qgl7w3msasscacrm@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
        <20180628162054.25613-19-m.felsch@pengutronix.de>
        <20180730151842.0fd99d01@coco.lan>
        <3a9f8715-a3a6-b250-82ad-6f2df6500767@redhat.com>
        <20180731070659.43afe417@coco.lan>
        <759d76b0-dab2-17bb-970c-38233bafc708@redhat.com>
        <20180731123652.r23m4zlkdulet22z@pengutronix.de>
        <7c849709-f3e4-98bb-fad9-a85f6e90bb71@redhat.com>
        <20180731133056.rqaolpoz7lea4y4f@pengutronix.de>
        <20180731165600.25831676@coco.lan>
        <20180801121047.qgl7w3msasscacrm@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 1 Aug 2018 14:10:47 +0200
Marco Felsch <m.felsch@pengutronix.de> escreveu:

> Hi Mauro,
> 
> On 18-07-31 16:56, Mauro Carvalho Chehab wrote:
> > Em Tue, 31 Jul 2018 15:30:56 +0200
> > Marco Felsch <m.felsch@pengutronix.de> escreveu:
> >   
> > > Hi Javier,
> > > 
> > > On 18-07-31 14:52, Javier Martinez Canillas wrote:  
> > > > Hi Marco,
> > > > 
> > > > On 07/31/2018 02:36 PM, Marco Felsch wrote:
> > > > 
> > > > [snip]
> > > >     
> > > > >>
> > > > >> Yes, another thing that patch 19/22 should take into account is DTs that
> > > > >> don't have input connectors defined. So probably TVP5150_PORT_YOUT should
> > > > >> be 0 instead of TVP5150_PORT_NUM - 1 as is the case in the current patch.
> > > > >>
> > > > >> In other words, it should work both when input connectors are defined in
> > > > >> the DT and when these are not defined and only an output port is defined.    
> > > > > 
> > > > > Yes, it would be a approach to map the output port dynamicaly to the
> > > > > highest port number. I tried to keep things easy by a static mapping.
> > > > > Maybe a follow up patch can change this behaviour.
> > > > > 
> > > > > Anyway, input connectors aren't required. There must be at least one
> > > > > port child node with a correct port-number in the DT.
> > > > >    
> > > > 
> > > > Yes, that was my point. But your patch uses the port child reg property as
> > > > the index for the struct device_node *endpoints[TVP5150_PORT_NUM] array.
> > > > 
> > > > If there's only one port child (for the output) then the DT binding says
> > > > that the reg property isn't required, so this will be 0 and your patch will
> > > > wrongly map it to TVP5150_PORT_AIP1A. That's why I said that the output port
> > > > should be the first one in your enum tvp5150_ports and not the last one.    
> > > 
> > > Yes, now I got you. I implemted this in such a way in my first apporach.
> > > But at the moment I don't know why I changed this. Maybe to keep the
> > > decoder->input number in sync with the em28xx devices, which will set the
> > > port by the s_routing() callback.
> > > 
> > > Let me check this.  
> 
> I will prepare a follow up patch wich fix this behaviour, if possible.
> 
> > 
> > Anyway, with the patchset I sent (with one fix), it will do the right
> > thing with regards to the pad output:
> > 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=tvp5150  
> 
> Thanks for your work :)
> I have just one question. Is it correct to set the .sig_type only for the
> tvp5150 'main' entity or should it be set for the dynamical connector
> entities too?

It should be needed only for entities with multiple pads, when
the pad index is not enough to uniquely identify what's there at
the pad. I don't think this applies to typical connectors
(although it might make sense on HDMI, where it may contain
different signals besides video, like CEC and ethernet).

> 
> > 
> > $ mc_nextgen_test -D 
> > digraph board {
> > 	rankdir=TB
> > 	colorscheme=x11
> > 	labelloc="t"
> > 	label="Grabster AV 350
> >  driver:em28xx, bus: usb-0000:00:14.0-2
> > "
> > 	intf_devnode_7 [label="intf_devnode_7\nvideo\n/dev/video0", shape=box, style=filled, fillcolor=yellow]
> > 	intf_devnode_10 [label="intf_devnode_10\nvbi\n/dev/vbi0", shape=box, style=filled, fillcolor=yellow]
> > 	entity_1 [label="{{<pad_2> 0 | <pad_3> 1 | <pad_4> 2} | entity_1\nATV decoder\ntvp5150 0-005c | {<pad_5> 3}}", shape=Mrecord, style=filled, fillcolor=lightblue]
> > 	entity_6 [label="{{<pad_12> 0} | entity_6\nV4L I/O\n2-2:1.0 video}", shape=Mrecord, style=filled, fillcolor=aquamarine]
> > 	entity_9 [label="{{<pad_13> 0} | entity_9\nVBI I/O\n2-2:1.0 vbi}", shape=Mrecord, style=filled, fillcolor=aquamarine]
> > 	entity_14 [label="{entity_14\nunknown entity type\nComposite | {<pad_15> 0}}", shape=Mrecord, style=filled, fillcolor=cadetblue]
> > 	entity_16 [label="{entity_16\nunknown entity type\nS-Video | {<pad_17> 0}}", shape=Mrecord, style=filled, fillcolor=cadetblue]
> > 	intf_devnode_7 -> entity_6 [dir="none" color="orange"]
> > 	intf_devnode_10 -> entity_9 [dir="none" color="orange"]
> > 	entity_1:pad_5 -> entity_6:pad_12 [color=blue]
> > 	entity_1:pad_5 -> entity_9:pad_13 [color=blue]
> > 	entity_14:pad_15 -> entity_1:pad_2 [color=blue]
> > 	entity_16:pad_17 -> entity_1:pad_2 [color=blue style="dashed"]
> > }
> > 
> > It won't do the right thing with regards to the input, though, as
> > the code at v4l2-mc.c expects just one input. So, both composite and
> > S-Video connectors (created outside tvp5150, based on the input entries
> > at em28xx cards table) are linked to pad 0.   
> 
> Should we add comment for this behaviour in v4l2-mc.c? Since the
> MEDIA_ENT_F_CONN_RF case updates the pad number.

I don't think so... The stuff at v4l2-mc are there to help setting the
pipelines for devnode-based devices that also exposes their internal
wiring via MC. For those, it is up to the Kernel to create and manage
the pipelines. It is not used by MC-based devices, as, for those, 
the pipelines should be created by userspace via the MC device node.

Thanks,
Mauro
