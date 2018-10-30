Return-path: <linux-media-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:43290 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbeJaIgl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 04:36:41 -0400
Subject: Re: [PATCH 1/7] dt-bindings: mfd: ds90ux9xx: add description of TI
 DS90Ux9xx ICs
To: Luca Ceresoli <luca@lucaceresoli.net>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sandeep Jain <Sandeep_Jain@mentor.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
References: <20181008211205.2900-1-vz@mleia.com>
 <20181008211205.2900-2-vz@mleia.com>
 <fd0a91c9-6e38-5a18-12e5-955fbf81bfce@lucaceresoli.net>
From: Vladimir Zapolskiy <vz@mleia.com>
Message-ID: <8ae609a1-f3ce-e216-d572-bf509ca482f9@mleia.com>
Date: Wed, 31 Oct 2018 01:40:54 +0200
MIME-Version: 1.0
In-Reply-To: <fd0a91c9-6e38-5a18-12e5-955fbf81bfce@lucaceresoli.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luca,

thank you for review, please find my comments below.

On 10/30/2018 06:43 PM, Luca Ceresoli wrote:
> Hi Vladimir,
> 
> On 08/10/18 23:11, Vladimir Zapolskiy wrote:
>> From: Sandeep Jain <Sandeep_Jain@mentor.com>
>>
>> The change adds device tree binding description of TI DS90Ux9xx
>> series of serializer and deserializer controllers which support video,
>> audio and control data transmission over FPD-III Link connection.
> [...]
>> +Example:
>> +
>> +serializer: serializer@c {
>> +	compatible = "ti,ds90ub927q", "ti,ds90ux9xx";
>> +	reg = <0xc>;
>> +	power-gpios = <&gpio5 12 GPIO_ACTIVE_HIGH>;
>> +	ti,backward-compatible-mode = <0>;
>> +	ti,low-frequency-mode = <0>;
>> +	ti,pixel-clock-edge = <0>;
>> +	...
>> +}
>> +
>> +deserializer: deserializer@3c {
>> +	compatible = "ti,ds90ub940q", "ti,ds90ux9xx";
>> +	reg = <0x3c>;
>> +	power-gpios = <&gpio6 31 GPIO_ACTIVE_HIGH>;
>> +	...
>> +}
> 
> Interesting patchset, thanks. At the moment I'm working on a driver for
> the TI FPD-III camera serdes chips [0]. At very first sight they have
> many commonalities with the display chipsets [1] you implemented. Did
> you have a look into them? Do you think they could be implemented by the
> same driver?

Absolutely, I believe that it should be no more than a matter of adding
the correspondent data fields to describe IC specifics to the set of the
published drivers.

In general, and from my experience, there is no big difference between
camera and display ICs from the series, my understanding is that it's
just a marketing or common usecase difference.

> 
> The camera serdes chips lack some features found on the display chips
> (e.g. audio, white balance). OTOH they have dual or quad input
> deserializers, which adds complexity.

For what it's worth the shown core drivers support DS90Ux940 (2 mutually
exclusive links, the support is already added to the series of drivers)
and DS90UB964 (4 parallel independent links) ICs, both deserializers are
used in connection to camera sensors.

So, the short answer is that multi-link ICs are also well supported,
and my intention is to push the essential core drivers firstly, then
add remarkably more trivial DRM and V4L2 drivers as cell drivers.

> I'm commenting on the details in reply to the following patches
> documenting the DT bindings.
> 

Thank you for review, I'm planning to collect more review comments and
publish v2 in about two weeks, any kind of essential rework is not
expected, the selected design of having an MFD and the drivers are
proven to be easily scalable, as usual any additional wanted features
could be added later on.

> [0] http://www.ti.com/interface/fpd-link-serdes/camera-serdes/overview.html
> [1] http://www.ti.com/interface/fpd-link-serdes/display-serdes/overview.html
> 

--
Best wishes,
Vladimir
