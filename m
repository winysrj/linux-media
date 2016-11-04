Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:37089 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753813AbcKDE2l (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2016 00:28:41 -0400
Date: Fri, 04 Nov 2016 13:28:38 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/6] Documentation: bindings: add documentation for
 ir-spi device driver
Message-id: <20161104042838.kwjv66ldun6g4hlv@gangnam.samsung>
References: <20161102104010.26959-1-andi.shyti@samsung.com>
 <CGME20161102104149epcas5p4da68197e232df7ad922f2f9cb0714a43@epcas5p4.samsung.com>
 <20161102104010.26959-6-andi.shyti@samsung.com>
 <70f4426b-e2e6-1fb7-187a-65ed4bce0668@samsung.com>
 <20161103101048.ofyoko4mkcypf44u@gangnam.samsung>
 <70e31ed5-e1ec-cac3-3c3d-02c75f1418bd@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <70e31ed5-e1ec-cac3-3c3d-02c75f1418bd@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

> > > Only DT bindings of LED class drivers should be placed in
> > > Documentation/devicetree/bindings/leds. Please move it to the
> > > media bindings.
> > 
> > that's where I placed it first, but Rob asked me to put it in the
> > LED directory and Cc the LED mailining list.
> > 
> > That's the discussion of the version 2:
> > 
> > https://lkml.org/lkml/2016/9/12/380
> > 
> > Rob, Jacek, could you please agree where I can put the binding?
> 
> I'm not sure if this is a good approach. I've noticed also that
> backlight bindings have been moved to leds, whereas they don't look
> similarly.
> 
> We have common.txt LED bindings, that all LED class drivers' bindings
> have to follow. Neither backlight bindings nor these ones do that,
> which introduces some mess.
> 
> Eventually adding a sub-directory, e.g. remote_control could make it
> somehow logically justified, but still - shouldn't bindings be
> placed in the documentation directory related to the subsystem of the
> driver they are predestined to?

In principle I agree with you, also because I understood that the
led kind of bindings are for those LEDs which main function is to
emit light.

There is no need for a remote control directory, because there is
one already under bindings/media, where all the remote
controllers are placed.

Now this is a matter of interpretation, is this an IR LED used by
the driver as remote controller or is this a remote controller
with just an IR LED?

In any case, I will wait for you and Rob to agree where is best
to place the binding, then I will send a new version.

Thanks,
Andi
