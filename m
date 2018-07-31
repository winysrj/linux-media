Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56731 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729888AbeGaPL1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 11:11:27 -0400
Date: Tue, 31 Jul 2018 15:30:56 +0200
From: Marco Felsch <m.felsch@pengutronix.de>
To: Javier Martinez Canillas <javierm@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 18/22] partial revert of "[media] tvp5150: add HW input
 connectors support"
Message-ID: <20180731133056.rqaolpoz7lea4y4f@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
 <20180628162054.25613-19-m.felsch@pengutronix.de>
 <20180730151842.0fd99d01@coco.lan>
 <3a9f8715-a3a6-b250-82ad-6f2df6500767@redhat.com>
 <20180731070659.43afe417@coco.lan>
 <759d76b0-dab2-17bb-970c-38233bafc708@redhat.com>
 <20180731123652.r23m4zlkdulet22z@pengutronix.de>
 <7c849709-f3e4-98bb-fad9-a85f6e90bb71@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c849709-f3e4-98bb-fad9-a85f6e90bb71@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On 18-07-31 14:52, Javier Martinez Canillas wrote:
> Hi Marco,
> 
> On 07/31/2018 02:36 PM, Marco Felsch wrote:
> 
> [snip]
> 
> >>
> >> Yes, another thing that patch 19/22 should take into account is DTs that
> >> don't have input connectors defined. So probably TVP5150_PORT_YOUT should
> >> be 0 instead of TVP5150_PORT_NUM - 1 as is the case in the current patch.
> >>
> >> In other words, it should work both when input connectors are defined in
> >> the DT and when these are not defined and only an output port is defined.
> > 
> > Yes, it would be a approach to map the output port dynamicaly to the
> > highest port number. I tried to keep things easy by a static mapping.
> > Maybe a follow up patch can change this behaviour.
> > 
> > Anyway, input connectors aren't required. There must be at least one
> > port child node with a correct port-number in the DT.
> >
> 
> Yes, that was my point. But your patch uses the port child reg property as
> the index for the struct device_node *endpoints[TVP5150_PORT_NUM] array.
> 
> If there's only one port child (for the output) then the DT binding says
> that the reg property isn't required, so this will be 0 and your patch will
> wrongly map it to TVP5150_PORT_AIP1A. That's why I said that the output port
> should be the first one in your enum tvp5150_ports and not the last one.

Yes, now I got you. I implemted this in such a way in my first apporach.
But at the moment I don't know why I changed this. Maybe to keep the
decoder->input number in sync with the em28xx devices, which will set the
port by the s_routing() callback.

Let me check this.

Best Regards,
Marco

> > Regards,
> > Marco
> > 
> 
> Best regards,
