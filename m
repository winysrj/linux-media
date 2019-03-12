Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF04C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 040F2214AF
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DVHN+UkB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfCLPhT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:37:19 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38565 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbfCLPhS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 11:37:18 -0400
Received: by mail-wm1-f65.google.com with SMTP id a188so3098197wmf.3
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 08:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=PQJkbCpU8+ThT+vKjJY6WbjpvosMo/fuYsBpjR2aYJc=;
        b=DVHN+UkBugHSVaGO86cmrMRgsRkZTXWCF6tW1KgbNu55vTaRCnvXEhsx4xgAqiOb4T
         iHtqHvyQcNdsVuHzF7rFc5lXb62KWuS0Eef3ty9ieYm9To2NhU6GKKvvu431DMy4Kk/B
         fwKCbu6sdFsczU3OhL8sU4D2hgUPluxLkrcqOmdIJDiKrwlGgiUjXXmW1VMosFbvtTwO
         v2sY4cvubOnBbL5Qe5n2VaP1/OydsNLCfv1BhnrCYeapI6RJ0R7DzU2ow4JkMbUWX5y4
         x9QQu3CRJybuOroZjUNO3zc1VR5n680z6w6diya3xwoeblaibM9W2mqYb6B/U5VUI8Xh
         BiOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=PQJkbCpU8+ThT+vKjJY6WbjpvosMo/fuYsBpjR2aYJc=;
        b=Vq4actp8x1ndlatA7Oj83u6kDtdthZJA8wZdfVUq7ECs1qecI1UcpeC2NJZMVHyCiA
         rhCi9vq4gDtee5ExFz5SIIPSnmvigsnfqueF55NO/EW05BOHLcdE0OHDyPWC3/vlbnHN
         ox713Ij158OfU3/5BOl5KVoENhqVBC6+sqnzCEhURHkHtZJ/udP4rdpKhkBvGWyF1XVZ
         kHxitH+dw2e6Qr8z00OpmYeM7JGgX/Z1pEceAQPEaV4CKVw+yQ5+GuzK4d8BVzEx+q7i
         Ad6MkRyAo1RTVRiXgQMPijv8YSe0x+BeWnOBIPdNy+dALnPc3NvQfFZ5VHZviCMJ6cFP
         F6ag==
X-Gm-Message-State: APjAAAU7qLBqB3vbkLcE4cR4gmrcFZTQQlNtE9ucxZYWx7LTemvtMhOE
        k3hVEARgrD5a2NA2H+hGycBNDA==
X-Google-Smtp-Source: APXvYqy0TIaGqG8y8a0dyVTMRZUDsX+w2lnK3LbP2OewF7kWw7JyVbMLhqPHCkgmm1Atvx1QCmDRIA==
X-Received: by 2002:a1c:7519:: with SMTP id o25mr2841876wmc.24.1552405036384;
        Tue, 12 Mar 2019 08:37:16 -0700 (PDT)
Received: from arch-late (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id j1sm2921264wme.4.2019.03.12.08.37.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Mar 2019 08:37:15 -0700 (PDT)
References: <20180517125033.18050-1-rui.silva@linaro.org> <20180517125033.18050-7-rui.silva@linaro.org> <20180518065824.csio2fgwsxo2g2ow@valkosipuli.retiisi.org.uk> <m3tvr5xt9t.fsf@linaro.org> <20190310214834.GB7578@pendragon.ideasonboard.com> <m3wol4dw55.fsf@linaro.org> <20190312151053.GD4845@pendragon.ideasonboard.com>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>
Subject: Re: [PATCH v4 06/12] media: dt-bindings: add bindings for i.MX7 media driver
In-reply-to: <20190312151053.GD4845@pendragon.ideasonboard.com>
Date:   Tue, 12 Mar 2019 15:37:14 +0000
Message-ID: <m3sgvsdryt.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,
On Tue 12 Mar 2019 at 15:10, Laurent Pinchart wrote:
> Hi Rui,
>
> On Tue, Mar 12, 2019 at 02:07:02PM +0000, Rui Miguel Silva 
> wrote:
>> On Sun 10 Mar 2019 at 21:48, Laurent Pinchart wrote:
>> > On Fri, May 18, 2018 at 09:27:58AM +0100, Rui Miguel Silva 
>> > wrote:
>> >> On Fri 18 May 2018 at 06:58, Sakari Ailus wrote:
>> >>> On Thu, May 17, 2018 at 01:50:27PM +0100, Rui Miguel Silva 
>> >>> wrote:
>> >>>> Add bindings documentation for i.MX7 media drivers.
>> >>>> 
>> >>>> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
>> >>>> ---
>> >>>>  .../devicetree/bindings/media/imx7.txt        | 145 
>> >>>>  ++++++++++++++++++
>> >>>>  1 file changed, 145 insertions(+)
>> >>>>  create mode 100644 
>> >>>>  Documentation/devicetree/bindings/media/imx7.txt
>> >>>> 1
>> >>>> diff --git 
>> >>>> a/Documentation/devicetree/bindings/media/imx7.txt 
>> >>>> b/Documentation/devicetree/bindings/media/imx7.txt
>> >>>> new file mode 100644
>> >>>> index 000000000000..161cff8e6442
>> >>>> --- /dev/null
>> >>>> +++ b/Documentation/devicetree/bindings/media/imx7.txt
>> >>>> @@ -0,0 +1,145 @@
>> >>>> +Freescale i.MX7 Media Video Device
>> >>>> +==================================
>> >>>> +
>> >>>> +Video Media Controller node
>> >>>> +---------------------------
>> >>>
>> >>> Note that DT bindings document the hardware, they are as 
>> >>> such 
>> >>> not Linux dependent.
>> >> 
>> >> This was removed in this series, however I removed it in the 
>> >> wrong
>> >> patch, If you see patch 11/12 you will see this being 
>> >> removed. I
>> >> will fix this in v5. Thanks for notice it.
>> >> 
>> >>>> +
>> >>>> +This is the media controller node for video capture 
>> >>>> support. It is a
>> >>>> +virtual device that lists the camera serial interface 
>> >>>> nodes that the
>> >>>> +media device will control.
>> >>>
>> >>> Ditto.
>> >>>
>> >>>> +
>> >>>> +Required properties:
>> >>>> +- compatible : "fsl,imx7-capture-subsystem";
>> >>>> +- ports      : Should contain a list of phandles pointing 
>> >>>> to camera
>> >>>> +		sensor interface port of CSI
>> >>>> +
>> >>>> +example:
>> >>>> +
>> >>>> +capture-subsystem {
>> >>>
>> >>> What's the purpose of this node, if you only refer to 
>> >>> another 
>> >>> device? This one rather does not look like a real device at 
>> >>> all.
>> >>>
>> >>>> +	compatible = "fsl,imx7-capture-subsystem";
>> >>>> +	ports = <&csi>;
>> >>>> +};
>> >>>> +
>> >>>> +
>> >>>> +mipi_csi2 node
>> >>>> +--------------
>> >>>> +
>> >>>> +This is the device node for the MIPI CSI-2 receiver core 
>> >>>> in i.MX7 SoC. It is
>> >>>> +compatible with previous version of Samsung D-phy.
>> >>>> +
>> >>>> +Required properties:
>> >>>> +
>> >>>> +- compatible    : "fsl,imx7-mipi-csi2";
>> >>>> +- reg           : base address and length of the register 
>> >>>> set for the device;
>> >>>> +- interrupts    : should contain MIPI CSIS interrupt;
>> >>>> +- clocks        : list of clock specifiers, see
>> >>>> + 
>> >>>> Documentation/devicetree/bindings/clock/clock-bindings.txt 
>> >>>> for details;
>> >>>> +- clock-names   : must contain "pclk", "wrap" and "phy" 
>> >>>> entries, matching
>> >>>> +                  entries in the clock property;
>> >>>> +- power-domains : a phandle to the power domain, see
>> >>>> + 
>> >>>> Documentation/devicetree/bindings/power/power_domain.txt 
>> >>>> for details.
>> >>>> +- reset-names   : should include following entry "mrst";
>> >>>> +- resets        : a list of phandle, should contain reset 
>> >>>> entry of
>> >>>> +                  reset-names;
>> >>>> +- phy-supply    : from the generic phy bindings, a 
>> >>>> phandle to a regulator that
>> >>>> +	          provides power to MIPI CSIS core;
>> >>>> +- bus-width     : maximum number of data lanes supported 
>> >>>> (SoC specific);
>> >>>> +
>> >>>> +Optional properties:
>> >>>> +
>> >>>> +- clock-frequency : The IP's main (system bus) clock 
>> >>>> frequency in Hz, default
>> >>>> +		    value when this property is not 
>> >>>> specified is 166 MHz;
>> >>>> +
>> >>>> +port node
>> >>>> +---------
>> >>>> +
>> >>>> +- reg		  : (required) can take the values 0 or 1, 
>> >>>> where 0 is the
>> >>>> +                     related sink port and port 1 should 
>> >>>> be the source one;
>> >>>> +
>> >>>> +endpoint node
>> >>>> +-------------
>> >>>> +
>> >>>> +- data-lanes    : (required) an array specifying active 
>> >>>> physical MIPI-CSI2
>> >>>> +		    data input lanes and their mapping to 
>> >>>> logical lanes; the
>> >>>> +		    array's content is unused, only its 
>> >>>> length is meaningful;
>> >>>> +
>> >>>> +- fsl,csis-hs-settle : (optional) differential receiver 
>> >>>> (HS-RX) settle time;
>> >>>
>> >>> Could you calculate this, as other drivers do? It probably 
>> >>> changes> depending on the device runtime configuration.
>> >> 
>> >> The only reference to possible values to this parameter is 
>> >> given by
>> >> table in [0], can you point me out the formula for imx7 in 
>> >> the
>> >> documentation?
>> >> 
>> >> [0] https://community.nxp.com/thread/463777
>> >
>> > Can't you use the values from that table ? :-) You can get 
>> > the 
>> > link speed by querying the connected subdev and reading its
>> > V4L2_CID_PIXEL_RATE control.
>> 
>> Yeah, I good point to add support for others subdev's. I will 
>> try
>> to add your comments in a follow up series.
>
> Just for my information (no commitment), do you know the 
> timeframe for
> that ?

With no commitment I will try to take a look at this until end of
week, not sure if I can make it, but I will try.

---
Cheers,
	Rui


