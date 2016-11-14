Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753706AbcKNQKu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 11:10:50 -0500
MIME-Version: 1.0
In-Reply-To: <20161110100203.2qv6j6acywpjerfi@gangnam.samsung>
References: <20161102104010.26959-1-andi.shyti@samsung.com>
 <CGME20161102104149epcas5p4da68197e232df7ad922f2f9cb0714a43@epcas5p4.samsung.com>
 <20161102104010.26959-6-andi.shyti@samsung.com> <70f4426b-e2e6-1fb7-187a-65ed4bce0668@samsung.com>
 <20161103101048.ofyoko4mkcypf44u@gangnam.samsung> <70e31ed5-e1ec-cac3-3c3d-02c75f1418bd@samsung.com>
 <20161109182621.ttfxtdt32q3cqce7@rob-hp-laptop> <13210179-ea3f-6106-e3c0-fa30b83e23cc@samsung.com>
 <20161110100203.2qv6j6acywpjerfi@gangnam.samsung>
From: Rob Herring <robh@kernel.org>
Date: Mon, 14 Nov 2016 10:10:23 -0600
Message-ID: <CAL_Jsq+c_HCFVu1MimrRM2amy1nPrA04Vxpa6D+0mLJG-0SXRA@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] Documentation: bindings: add documentation for
 ir-spi device driver
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 10, 2016 at 4:02 AM, Andi Shyti <andi.shyti@samsung.com> wrote:
> Hi Jacek,
>
>> > > > > Only DT bindings of LED class drivers should be placed in
>> > > > > Documentation/devicetree/bindings/leds. Please move it to the
>> > > > > media bindings.
>> > > >
>> > > > that's where I placed it first, but Rob asked me to put it in the
>> > > > LED directory and Cc the LED mailining list.
>> > > >
>> > > > That's the discussion of the version 2:
>> > > >
>> > > > https://lkml.org/lkml/2016/9/12/380
>> > > >
>> > > > Rob, Jacek, could you please agree where I can put the binding?
>> > >
>> > > I'm not sure if this is a good approach. I've noticed also that
>> > > backlight bindings have been moved to leds, whereas they don't look
>> > > similarly.
>> > >
>> > > We have common.txt LED bindings, that all LED class drivers' bindings
>> > > have to follow. Neither backlight bindings nor these ones do that,
>> > > which introduces some mess.
>> >
>> > And there are probably LED bindings that don't follow common.txt either.
>> >
>> > > Eventually adding a sub-directory, e.g. remote_control could make it
>> > > somehow logically justified, but still - shouldn't bindings be
>> > > placed in the documentation directory related to the subsystem of the
>> > > driver they are predestined to?
>> >
>> > No. While binding directories often mirror the driver directories, they
>> > are not the same. Bindings are grouped by types of h/w and IR LEDs are a
>> > type of LED.
>> >
>> > If you prefer a sub-dir, that is fine with me.
>>
>> Fine. So how about sub-dir "ir" ?
>
> would we put here all the remote control bindings that currently
> are under media?

No. Only if they are just an LED that happens to be IR.

Rob
