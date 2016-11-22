Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42912
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755411AbcKVOOs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 09:14:48 -0500
Date: Tue, 22 Nov 2016 12:14:40 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Rob Herring <robh@kernel.org>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC] Documentation: media, leds: move IR LED remote
 controllers from media to LED
Message-ID: <20161122121440.627f1c16@vento.lan>
In-Reply-To: <20161110132650.5109-1-andi.shyti@samsung.com>
References: <20161110132650.5109-1-andi.shyti@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Nov 2016 22:26:50 +0900
Andi Shyti <andi.shyti@samsung.com> escreveu:

> Hi,
> 
> this is purely a request for comments after a discussion had with
> Rob and Jacek [*] about where to place the ir leds binding. Rob wants
> the binding to be under led, while Jacek wants it in media...
> "Ubi maior minor cessat": it goes to LED and they can be organized
> in a subdirectory.
> 
> Standing to Rob "Bindings are grouped by types of h/w and IR LEDs
> are a type of LED": all remote controllers have an IR LED as core
> device, even though the framework is under drivers/media/rc/, thus
> they naturally belong to the LED binding group.
> 
> Please, let me know if this is the right approach.

IMHO, this is wrong. 

Ok, if you look at just the diode, the physics of an IR Light-emitting Diode
(LED) is identical  to the one for a visible light LED, just like the physics
of the LED diodes inside a display. Btw, the physics of an IR detector
diode is almost identical to the physics of a LED.

Yet, the hardware where those diodes are connected are very different,
and so their purpose.

The same way I don't think it would make sense to represent a LED
display using the same approach as a flash light, I don't think we
should to it for IR LEDs.

A visible light LED is used either to work as a flash light for a camera
or as a way to indicate a status. No machine2machine protocol there.
The circuitry for them is usually just a gatway that will turn it on
or off.

With regards to the IR hardware, an IR LED is used for machine2machine
signaling. It is part of a modulator circuit that uses a carrier of about
40kHz to modulate 16 or 32 bits words.

The IR device hardware usually also have another diode (the IR detector)
that receives IR rays. Visually, they look identical.

IMHO, it makes much more sense to keep both IR detector and light-emitting
diodes described together, as they are part of the same circuitry and
have a way more similarities than a flash light or a LED display.

Regards,
Mauro
