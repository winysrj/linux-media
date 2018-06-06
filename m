Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:40224 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932490AbeFFIpN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 04:45:13 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [RFC PATCH v1 1/4] media: dt-bindings: max9286: add device tree
 binding
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo@jmondi.org>
References: <20180605233435.18102-1-kieran.bingham+renesas@ideasonboard.com>
 <20180605233435.18102-2-kieran.bingham+renesas@ideasonboard.com>
 <CAMuHMdUYbEK36E4hD+nVDfM5_nuY8SubkgBCtcYuSy+eZLNt5Q@mail.gmail.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <a70e1391-550a-f327-7f6b-3e730622b5e4@ideasonboard.com>
Date: Wed, 6 Jun 2018 09:45:07 +0100
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUYbEK36E4hD+nVDfM5_nuY8SubkgBCtcYuSy+eZLNt5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert

On 06/06/18 07:34, Geert Uytterhoeven wrote:
> Hi Kieran,
> 
> On Wed, Jun 6, 2018 at 1:34 AM, Kieran Bingham
> <kieran.bingham+renesas@ideasonboard.com> wrote:
>> Provide device tree binding documentation for the MAX9286 Quad GMSL
>> deserialiser.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> Thanks for your patch!


Thanks for your review,


>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/max9286.txt
>> @@ -0,0 +1,75 @@
>> +* Maxim Integrated MAX9286 GMSL Quad 1.5Gbps GMSL Deserializer
>> +
>> +Required Properties:
>> + - compatible: Shall be "maxim,max9286"
>> +
>> +The following required properties are defined externally in
>> +Documentation/devicetree/bindings/i2c/i2c-mux.txt:
>> + - Standard I2C mux properties.
>> + - I2C child bus nodes.
>> +
>> +A maximum of 4 I2C child nodes can be specified on the MAX9286, to
>> +correspond with a maximum of 4 input devices.
>> +
>> +The device node must contain one 'port' child node per device input and output
>> +port, in accordance with the video interface bindings defined in
>> +Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
>> +are numbered as follows.
>> +
>> +      Port        Type
>> +    ----------------------
>> +       0          sink
>> +       1          sink
>> +       2          sink
>> +       3          sink
>> +       4          source
> 
> I assume the source and at least one sink are thus mandatory?

Yes, that would make some sense :D

> Would it make sense to use port 0 for the source?
> This would simplify extending the binding to devices with more input
> ports later.

I think that sounds like a reasonable suggestion too.

I'm not sure how much extending this device (family) would get yet, but it
doesn't hurt to future proof.

--
Regards

Kieran


> Gr{oetje,eeting}s,
> 
>                         Geert
> 
