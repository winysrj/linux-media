Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:38157 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932386AbdBPQG2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 11:06:28 -0500
Received: by mail-it0-f48.google.com with SMTP id c7so29764400itd.1
        for <linux-media@vger.kernel.org>; Thu, 16 Feb 2017 08:06:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170215220822.nsws6kzrd6ihvmqt@rob-hp-laptop>
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
 <1486485683-11427-4-git-send-email-bgolaszewski@baylibre.com> <20170215220822.nsws6kzrd6ihvmqt@rob-hp-laptop>
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date: Thu, 16 Feb 2017 17:06:20 +0100
Message-ID: <CAMpxmJUuaa+aZQaPaYokfNrehzOTuvT7jJPpxpDLQiuEyY2Oqw@mail.gmail.com>
Subject: Re: [PATCH 03/10] media: dt-bindings: vpif: extend the example with
 an output port
To: Rob Herring <robh@kernel.org>
Cc: Kevin Hilman <khilman@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        linux-devicetree <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        arm-soc <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-02-15 23:08 GMT+01:00 Rob Herring <robh@kernel.org>:
> On Tue, Feb 07, 2017 at 05:41:16PM +0100, Bartosz Golaszewski wrote:
>> This makes the example more or less correspond with the da850-evm
>> hardware setup.
>>
>> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>> ---
>>  .../devicetree/bindings/media/ti,da850-vpif.txt    | 35 ++++++++++++++++++----
>>  1 file changed, 29 insertions(+), 6 deletions(-)
>
> Spoke too soon...
>
>>
>> diff --git a/Documentation/devicetree/bindings/media/ti,da850-vpif.txt b/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
>> index 9c7510b..543f6f3 100644
>> --- a/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
>> +++ b/Documentation/devicetree/bindings/media/ti,da850-vpif.txt
>> @@ -28,19 +28,27 @@ I2C-connected TVP5147 decoder:
>>               reg = <0x217000 0x1000>;
>>               interrupts = <92>;
>>
>> -             port {
>> -                     vpif_ch0: endpoint@0 {
>> +             port@0 {
>> +                     vpif_input_ch0: endpoint@0 {
>>                               reg = <0>;
>>                               bus-width = <8>;
>> -                             remote-endpoint = <&composite>;
>> +                             remote-endpoint = <&composite_in>;
>>                       };
>>
>> -                     vpif_ch1: endpoint@1 {
>> +                     vpif_input_ch1: endpoint@1 {
>>                               reg = <1>;
>>                               bus-width = <8>;
>>                               data-shift = <8>;
>>                       };
>>               };
>> +
>> +             port@1 {
>
> The binding doc says nothing about supporting a 2nd port.
>

I assumed that "It should contain at least one port child node" means
there can be more than one.

Thanks,
Bartosz

>
>> +                     vpif_output_ch0: endpoint@0 {
>> +                             reg = <0>;
>
> Don't need reg here.
>
>> +                             bus-width = <8>;
>> +                             remote-endpoint = <&composite_out>;
>> +                     };
>> +             };
>>       };
