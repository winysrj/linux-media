Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:49966 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753651AbcKWC27 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 21:28:59 -0500
Date: Wed, 23 Nov 2016 11:28:56 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Rob Herring <robh@kernel.org>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC] Documentation: media,
 leds: move IR LED remote controllers from media to LED
Message-id: <20161123022856.gliio3nyfclx6hj2@gangnam.samsung>
References: <20161110132650.5109-1-andi.shyti@samsung.com>
 <CGME20161122141450epcas4p4a07f3db61d459fe775cbad7048affe7a@epcas4p4.samsung.com>
 <20161122121440.627f1c16@vento.lan>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20161122121440.627f1c16@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

> > this is purely a request for comments after a discussion had with
> > Rob and Jacek [*] about where to place the ir leds binding. Rob wants
> > the binding to be under led, while Jacek wants it in media...
> > "Ubi maior minor cessat": it goes to LED and they can be organized
> > in a subdirectory.
> > 
> > Standing to Rob "Bindings are grouped by types of h/w and IR LEDs
> > are a type of LED": all remote controllers have an IR LED as core
> > device, even though the framework is under drivers/media/rc/, thus
> > they naturally belong to the LED binding group.
> > 
> > Please, let me know if this is the right approach.
> 
> IMHO, this is wrong. 
> 
> Ok, if you look at just the diode, the physics of an IR Light-emitting Diode
> (LED) is identical  to the one for a visible light LED, just like the physics
> of the LED diodes inside a display. Btw, the physics of an IR detector
> diode is almost identical to the physics of a LED.
> 
> Yet, the hardware where those diodes are connected are very different,
> and so their purpose.
> 
> The same way I don't think it would make sense to represent a LED
> display using the same approach as a flash light, I don't think we
> should to it for IR LEDs.
> 
> A visible light LED is used either to work as a flash light for a camera
> or as a way to indicate a status. No machine2machine protocol there.
> The circuitry for them is usually just a gatway that will turn it on
> or off.
> 
> With regards to the IR hardware, an IR LED is used for machine2machine
> signaling. It is part of a modulator circuit that uses a carrier of about
> 40kHz to modulate 16 or 32 bits words.
> 
> The IR device hardware usually also have another diode (the IR detector)
> that receives IR rays. Visually, they look identical.
> 
> IMHO, it makes much more sense to keep both IR detector and light-emitting
> diodes described together, as they are part of the same circuitry and
> have a way more similarities than a flash light or a LED display.

thanks for the reply, I agree with you, that's why I first put
the ir-spi of tm2 in the media directory where all the ir leds
devices are. That's what Jacek recommended and what you are
recommending (that's also why this is an RFC and not a patch).

Rob, if I place the tm2 ir-spi in the led bindings in a
sub-directory it will be the only device there for the time
being. But the ir-spi it's not unique in its kind, there are many
others and they are all under the media directory. My opinion is
that all the ir-leds devices should be in the same place.

Would, then, make sense to split the ir-leds devices in two
different locations?

Would it be a valid alternative to create instead an 'rc'
directory for the ir-leds bindings that can either be under
media or in the higher directory?

Thanks,
Andi
