Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:48962 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729055AbeHNIZ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 04:25:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Rob Herring <robh@kernel.org>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] dt-bindings: media: adv748x: Document re-mappable addresses
Date: Tue, 14 Aug 2018 08:40:37 +0300
Message-ID: <2887621.fdKYYZGugR@avalon>
In-Reply-To: <CAL_JsqJQNtRNq+b3sJ4eEse1pzWy3F-WgbDF7=t-TrvFx6WcUQ@mail.gmail.com>
References: <20180809192944.7371-1-kieran.bingham@ideasonboard.com> <dedade62-91ed-2c92-dac7-fe4a8f9d9452@ideasonboard.com> <CAL_JsqJQNtRNq+b3sJ4eEse1pzWy3F-WgbDF7=t-TrvFx6WcUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On Tuesday, 14 August 2018 01:48:05 EEST Rob Herring wrote:
> On Mon, Aug 13, 2018 at 1:17 PM Kieran Bingham wrote:
> > On 13/08/18 18:45, Rob Herring wrote:
> > > On Thu, Aug 09, 2018 at 08:29:44PM +0100, Kieran Bingham wrote:
> > >> The ADV748x supports configurable slave addresses for its I2C pages.
> > >> Document the page names, and provide an example for setting each of the
> > >> pages explicitly.
> > > 
> > > It would be good to say why you need this.
> > 
> > In fact - I should probably have added a fixes tag here, which would
> > have added more context:
> > 
> > Fixes: 67537fe960e5 ("media: i2c: adv748x: Add support for
> > i2c_new_secondary_device")
> 
> That doesn't really explain things from a DT perspective.
> 
> > Should I repost with this fixes tag?
> > Or can it be collected with the RB tag?
> 
> I'll leave that to Hans.
> 
> > > The only use I can think of
> > > is if there are other devices on the bus and you need to make sure the
> > > addresses don't conflict.
> > 
> > Yes, precisely. This driver has 'slave pages' which are created and
> > mapped by the driver. The device has default addresses which are used by
> > the driver - but it's very easy for these to conflict with other devices
> > on the same I2C bus.
> > 
> > Because the mappings are simply a software construct, we have a means to
> > specify the desired mappings through DT at the board level - which
> > allows the boards to ensure that conflicts do not appear.
> > 
> > > Arguably, that information could be figured out without this in DT.
> > 
> > How so ?
> > 
> > Scanning the bus is error prone, and dependant upon driver state (and
> > presence), and we have no means currently of requesting 'free/unused'
> > addresses from the I2C core framework.
> 
> True. But assuming all devices are in DT, then you just need to scan
> the child nodes of the bus and get a map of the used addresses. Though
> if you had 2 or more devices like this, then you'd need to maintain
> s/w allocated addresses too. It could all be maintained with a bitmap
> which you initialize with addresses in DT.

We've discussed this topic with Wolfram before, and unfortunately the base 
assumption of assuming all devices are in DT often doesn't hold :-( For all 
kind of reasons vendors often don't provide a full description of I2C buses, 
especially when slave devices don't need to be accessed from Linux. Sometimes 
they lack DT bindings for some I2C slaves that are not essential and still 
want to provide a partial but functional DT. Sometimes devices are hooked up 
to an I2C bus for debugging purposes only and end up never being used, so 
nobody bothers describing them. Sometimes an I2C slave has multiple slave 
addresses which DT writes are not aware of. Those are just a few examples.

One alternative would be to add a DT property to the I2C master node to list 
the known to be free addresses. I'm not sure that's better though. We should 
also keep in mind that some I2C slaves could have restrictions on which 
secondary addresses can be used, so we would need to pass constraints to the 
I2C address allocator, which would quickly become a mess.

-- 
Regards,

Laurent Pinchart
