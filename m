Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730213AbeHNBcf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 21:32:35 -0400
MIME-Version: 1.0
References: <20180809192944.7371-1-kieran.bingham@ideasonboard.com>
 <20180813174544.GA11379@rob-hp-laptop> <dedade62-91ed-2c92-dac7-fe4a8f9d9452@ideasonboard.com>
In-Reply-To: <dedade62-91ed-2c92-dac7-fe4a8f9d9452@ideasonboard.com>
From: Rob Herring <robh@kernel.org>
Date: Mon, 13 Aug 2018 16:48:05 -0600
Message-ID: <CAL_JsqJQNtRNq+b3sJ4eEse1pzWy3F-WgbDF7=t-TrvFx6WcUQ@mail.gmail.com>
Subject: Re: [PATCH v3] dt-bindings: media: adv748x: Document re-mappable addresses
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 13, 2018 at 1:17 PM Kieran Bingham
<kieran.bingham@ideasonboard.com> wrote:
>
> Hi Rob,
>
> On 13/08/18 18:45, Rob Herring wrote:
> > On Thu, Aug 09, 2018 at 08:29:44PM +0100, Kieran Bingham wrote:
> >> The ADV748x supports configurable slave addresses for its I2C pages.
> >> Document the page names, and provide an example for setting each of the
> >> pages explicitly.
> >
> > It would be good to say why you need this.
>
> In fact - I should probably have added a fixes tag here, which would
> have added more context:
>
> Fixes: 67537fe960e5 ("media: i2c: adv748x: Add support for
> i2c_new_secondary_device")

That doesn't really explain things from a DT perspective.

> Should I repost with this fixes tag?
> Or can it be collected with the RB tag?

I'll leave that to Hans.

> > The only use I can think of
> > is if there are other devices on the bus and you need to make sure the
> > addresses don't conflict.
>
> Yes, precisely. This driver has 'slave pages' which are created and
> mapped by the driver. The device has default addresses which are used by
> the driver - but it's very easy for these to conflict with other devices
> on the same I2C bus.
>
> Because the mappings are simply a software construct, we have a means to
> specify the desired mappings through DT at the board level - which
> allows the boards to ensure that conflicts do not appear.
>
>
> > Arguably, that information could be figured out without this in DT.
>
> How so ?
>
> Scanning the bus is error prone, and dependant upon driver state (and
> presence), and we have no means currently of requesting 'free/unused'
> addresses from the I2C core framework.

True. But assuming all devices are in DT, then you just need to scan
the child nodes of the bus and get a map of the used addresses. Though
if you had 2 or more devices like this, then you'd need to maintain
s/w allocated addresses too. It could all be maintained with a bitmap
which you initialize with addresses in DT.

Rob
