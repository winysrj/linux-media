Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34065 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965015AbcLVTFH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Dec 2016 14:05:07 -0500
MIME-Version: 1.0
In-Reply-To: <11494368.ZdobxT7gGY@avalon>
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1482307838-47415-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1482307838-47415-7-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <11494368.ZdobxT7gGY@avalon>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 22 Dec 2016 20:05:05 +0100
Message-ID: <CAMuHMdXj-xBrnBXfYu6BeXr7Gfv4wogH4z610Ddq-BSyVS=-8Q@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] dt-bindings: media: Add Renesas R-Car DRIF binding
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Antti Palosaari <crope@iki.fi>,
        Chris Paterson <chris.paterson2@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Dec 22, 2016 at 6:05 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Wednesday 21 Dec 2016 08:10:37 Ramesh Shanmugasundaram wrote:
>> Add binding documentation for Renesas R-Car Digital Radio Interface
>> (DRIF) controller.
>>
>> Signed-off-by: Ramesh Shanmugasundaram
>> <ramesh.shanmugasundaram@bp.renesas.com> ---
>>  .../devicetree/bindings/media/renesas,drif.txt     | 202 ++++++++++++++++++
>>  1 file changed, 202 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/renesas,drif.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/renesas,drif.txt
>> b/Documentation/devicetree/bindings/media/renesas,drif.txt new file mode
>> 100644
>> index 0000000..1f3feaf
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/renesas,drif.txt

>> +Optional properties of an internal channel when:
>> +     - It is the only enabled channel of the bond (or)
>> +     - If it acts as primary among enabled bonds
>> +--------------------------------------------------------
>> +- renesas,syncmd       : sync mode
>> +                      0 (Frame start sync pulse mode. 1-bit width pulse
>> +                         indicates start of a frame)
>> +                      1 (L/R sync or I2S mode) (default)
>> +- renesas,lsb-first    : empty property indicates lsb bit is received
>> first.
>> +                      When not defined msb bit is received first (default)
>> +- renesas,syncac-active: Indicates sync signal polarity, 0/1 for low/high
>> +                      respectively. The default is 1 (active high)
>> +- renesas,dtdl         : delay between sync signal and start of reception.
>> +                      The possible values are represented in 0.5 clock
>> +                      cycle units and the range is 0 to 4. The default
>> +                      value is 2 (i.e.) 1 clock cycle delay.
>> +- renesas,syncdl       : delay between end of reception and sync signal
>> edge.
>> +                      The possible values are represented in 0.5 clock
>> +                      cycle units and the range is 0 to 4 & 6. The default
>> +                      value is 0 (i.e.) no delay.
>
> Most of these properties are pretty similar to the video bus properties
> defined at the endpoint level in
> Documentation/devicetree/bindings/media/video-interfaces.txt. I believe it
> would make sense to use OF graph and try to standardize these properties
> similarly.

Note that the last two properties match the those in
Documentation/devicetree/bindings/spi/sh-msiof.txt.
We may want to use one DRIF channel as a plain SPI slave with the
(modified) MSIOF driver in the future.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
