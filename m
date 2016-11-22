Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:35954 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbcKVAJn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 19:09:43 -0500
Received: by mail-pg0-f51.google.com with SMTP id f188so734166pgc.3
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2016 16:09:42 -0800 (PST)
From: Kevin Hilman <khilman@baylibre.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        devicetree@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        Bartosz =?utf-8?Q?Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 4/4] [media] dt-bindings: add TI VPIF documentation
References: <20161119003208.10550-1-khilman@baylibre.com>
        <20161119003208.10550-4-khilman@baylibre.com>
        <165090919.oFnaNnsijv@wuerfel>
Date: Mon, 21 Nov 2016 16:09:40 -0800
In-Reply-To: <165090919.oFnaNnsijv@wuerfel> (Arnd Bergmann's message of "Mon,
        21 Nov 2016 15:15:07 +0100")
Message-ID: <m28tsc1ikb.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> On Friday, November 18, 2016 4:32:08 PM CET Kevin Hilman wrote:
>> +
>> +Required properties:
>> +- compatible: must be "ti,vpif-capture"
>> +- reg: physical base address and length of the registers set for the device;
>> +- interrupts: should contain IRQ line for the VPIF
>> +
>> 
>
> Shouldn't this have a SoC specific identifier or a version number
> in the compatible string? "vpif" seems rather generic, so it's
> likely that TI made more than one variant of it.

AFAICT, they used this for a single generation of davinci SoCs (dm6467,
da850) and then moved on to using something completely different.

But, that still proves your point because it's very SoC specific, so
I'll make the compatible specific.

Thanks for the review,

Kevin
