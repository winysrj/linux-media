Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:33500 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732267AbeHBOjt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 10:39:49 -0400
Received: by mail-qt0-f178.google.com with SMTP id h4-v6so2072760qtj.7
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2018 05:48:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a5c8d552eaf567a09ba9d3cbc50771c5128cd805.camel@baylibre.com>
References: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr>
 <20180801193320.25313-5-maxi.jourdan@wanadoo.fr> <a5c8d552eaf567a09ba9d3cbc50771c5128cd805.camel@baylibre.com>
From: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Date: Thu, 2 Aug 2018 14:48:43 +0200
Message-ID: <CAHStOZ6Buk2JbT5A-sJsrJTTHLNb6omGpVCeYEZ6bpqSxqsZAQ@mail.gmail.com>
Subject: Re: [RFC 4/4] dt-bindings: media: add Amlogic Meson Video Decoder Bindings
To: Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Maxime Jourdan <maxi.jourdan@wanadoo.fr>,
        linux-media@vger.kernel.org,
        linux-amlogic <linux-amlogic@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin & Jerome,

2018-08-02 12:33 GMT+02:00 Jerome Brunet <jbrunet@baylibre.com>:
> Maxime, when formatting your patchset, remember to put the bindings
> documentation before actually using them. This patch could be the first one of
> your series.

Noted, thanks.

2018-08-01 22:13 GMT+02:00 Martin Blumenstingl
<martin.blumenstingl@googlemail.com>:
>> +- VDEC_2 is used as a helper for corner cases like H.264 4K on older SoCs.
>> +It is not handled by this driver.
> is it currently not handled or will it never be?

I don't think it will ever be, at least from me. This VDEC unit is
rarely used and only for a few corner cases on SoCs like meson8b, and
I have no intention of supporting them for now as there are other
limitations.

> any reason why you are not using the DMC syscon (as added in your
> patch "dt-bindings: soc: amlogic: add meson-canvas documentation")
> instead of mapping the DMC region again?

To answer you and Jerome, I didn't use it because I wanted to keep
both patchsets separate in case of testing. In hindsight though, I
should have used the canvas module in the vdec in the RFC.
So yeah, this will definitely be used by the final product.

>> +- interrupts: should contain the vdec and esparser IRQs.
> are these two IRQs the "currently supported" ones or are there more
> for the whole IP block (but just not implemented yet)?

There are more IRQs within the VDEC but they are not used at the
moment. Some are for the demuxer, VDEC_2, etc..

> AFAIK the "correct" format is (just like you've done for the clocks below):
>        reg = <0x0 0xc8820000 0x0 0x10000>,
>                  <0x0 0xc110a580 0x0 0xe4>,
>                  <0x0 0xc8838000 0x0 0x60>;
>

> AFAIK the "correct" format is (just like you've done for the clocks below):
>        interrupts = <GIC_SPI 44 IRQ_TYPE_EDGE_RISING>,
>                            <GIC_SPI 32 IRQ_TYPE_EDGE_RISING>;
>

>> +       amlogic,ao-sysctrl = <&sysctrl_AO>;
> this is not documented above - is it needed?

Duly noted, thanks.
