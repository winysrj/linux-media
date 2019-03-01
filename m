Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F01C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 11:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D13ED2186A
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 11:08:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXTypfZl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733133AbfCALIC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 06:08:02 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41902 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727932AbfCALIC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 06:08:02 -0500
Received: by mail-wr1-f65.google.com with SMTP id n2so25389444wrw.8;
        Fri, 01 Mar 2019 03:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GynrsnCtwxb9Dr34GDltTnNeZLoE6uGCA4nKr/xmvU0=;
        b=nXTypfZlqA5k3sjuZYZ0KJsK+oHUZL3TA/64iePnp90/xeBokkFmY7rdJKAZ0tZ9Yk
         QbmxxmbVP41s4KG0RZStRAOmkqoS/Aa8c1kXDqSkxBtvDMLIdTBmQ2eKQTMGVUy6KIxH
         TeN6a/IQor/wWuvHpIjCd+94rg2P+kqLAiR+7MO9XzyI7ZoOHKMjLhnzSIaO25k78rxV
         tu0ohQLVSO+il926DyUTWe96tX6w/THnlAp1BMXnz6b2XVFJv+dzBZJudKGSVVbTCW5G
         /4L4aoEQ7Q04+lHaJ07m5dlekjjXqm6Z5/cG7id1NFh4qVmEkCbL4vMPo9RDm3Ex0+UY
         pL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GynrsnCtwxb9Dr34GDltTnNeZLoE6uGCA4nKr/xmvU0=;
        b=kh5IsD9LumlUOgo19lvTeL7ckYHAzT4JLwZxlhmewolhR4nppKYwWs3z4qgMPcSuia
         dNZdyRRwiWwrkzxubqKVu7zbeMobt/7G2Wcoez0UBOQxwzvueT1HBrA32VM6YFLotsbL
         p7RY3jmVcDoFbCKWF2gT9l2vQcALemv8xaq/Ze7YiG2n/X8X4tRUzHJrqGp3XVnm1ap8
         MtXY7PzsXld8b5LZ7pKabu9T/3+4E1LpKVeiJQnFJmXaApLG8g/GFVyzfHcbS1Q7PpiQ
         UH+23KyQ6wdEyHeiMoxjOoBtmIw32gPNT7qSOckrBLd7SQ9k1LkG7zmEHZQhOaeDtxpF
         kr2A==
X-Gm-Message-State: APjAAAVnDxFC0694ez9PWupt9XU+A8i/XEER+ZTh2IJUR+mVL0M9w2P8
        itVMVLLxd4J8QXN2TKlPSZo=
X-Google-Smtp-Source: APXvYqwg639k3VEwtTrNtK0wbxAAR9WTHBvEYoOoTYtDBIc89PSTcf1Nzj9Ql9/QHaH4OOI3nsenAw==
X-Received: by 2002:adf:cd87:: with SMTP id q7mr3235893wrj.92.1551438479866;
        Fri, 01 Mar 2019 03:07:59 -0800 (PST)
Received: from ?IPv6:2a00:23c4:1c4c:e100:88de:abfa:71ef:1b73? ([2a00:23c4:1c4c:e100:88de:abfa:71ef:1b73])
        by smtp.googlemail.com with ESMTPSA id n189sm12234781wmb.28.2019.03.01.03.07.59
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 03:07:59 -0800 (PST)
Subject: Re: [PATCH 1/3] media: dt-bindings: add bindings for Toshiba TC358746
To:     Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     hans.verkuil@cisco.com, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, graphics@pengutronix.de
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
 <20181218141240.3056-2-m.felsch@pengutronix.de>
 <20190218100333.qvptfllrd4pyhsyb@paasikivi.fi.intel.com>
 <20190301105235.a23jwiwmxejuv2yf@pengutronix.de>
From:   Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <a51ecc47-df19-a48b-3d82-01b21d03972c@gmail.com>
Date:   Fri, 1 Mar 2019 11:07:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.2
MIME-Version: 1.0
In-Reply-To: <20190301105235.a23jwiwmxejuv2yf@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On 01/03/2019 10:52, Marco Felsch wrote:
> Hi Sakari,
> 
> On 19-02-18 12:03, Sakari Ailus wrote:
>> Hi Marco,
>>
>> My apologies for reviewing this so late. You've received good comments
>> already. I have a few more.
> 
> Thanks for your review for the other patches as well =) Sorry for my
> delayed response.
> 
>> On Tue, Dec 18, 2018 at 03:12:38PM +0100, Marco Felsch wrote:
>>> Add corresponding dt-bindings for the Toshiba tc358746 device.
>>>
>>> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
>>> ---
>>>   .../bindings/media/i2c/toshiba,tc358746.txt   | 80 +++++++++++++++++++
>>>   1 file changed, 80 insertions(+)
>>>   create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
>>> new file mode 100644
>>> index 000000000000..499733df744a
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
>>> @@ -0,0 +1,80 @@
>>> +* Toshiba TC358746 Parallel to MIPI CSI2-TX or MIPI CSI2-RX to Parallel Bridge
>>> +
>>> +The Toshiba TC358746 is a bridge that converts a Parallel-in stream to MIPI CSI-2 TX
>>> +or a MIPI CSI-2 RX stream into a Parallel-out. It is programmable through I2C.
>>
>> This is interesting. The driver somehow needs to figure out the direction
>> of the data flow if it does not originate from DT. I guess it shouldn't as
>> it's not the property of an individual device, albeit in practice in all
>> hardware I've seen the direction of the pipeline is determinable and this
>> is visible in the kAPI as well. So I'm suggesting no changes due to this in
>> bindings, likely we'll need to address it somehow elsewhere going forward.
> 
> What did you mean with "... and this is visible in the kAPI as well"?
> I'm relative new in the linux-media world but I never saw a device which
> supports two directions. Our customer which uses that chip use it
> only in parallel-in/csi-out mode. To be flexible the switching should be
> done by a subdev-ioctl but it is also reasonable to define a default value
> within the DT.

The mode is set by a pin strap at reset time (MSEL). It's not 
programmable by i2c. As far as I can see, looking at the registers, it's 
also not readable by i2c, so there's no easy way for a driver which 
supports both modes to see what the pinstrap is set to.

I'm not sure if the driver could tell from the direction of the 
endpoints it's linked to which mode to use, but if not it'll need to be 
told somehow and a DT property seems reasonable to me. Given that the 
same pins are used in each direction I think the direction is most 
likely to be hard wired and board specific.

Regards,
Ian.

>>> +
>>> +Required Properties:
>>> +
>>> +- compatible: should be "toshiba,tc358746"
>>> +- reg: should be <0x0e>
>>> +- clocks: should contain a phandle link to the reference clock source
>>> +- clock-names: the clock input is named "refclk".
>>> +
>>> +Optional Properties:
>>> +
>>> +- reset-gpios: gpio phandle GPIO connected to the reset pin
>>> +
>>> +Parallel Endpoint:
>>> +
>>> +Required Properties:
>>
>> It'd be nice if the relation between these sections would be somehow
>> apparent. E.g. using different underlining, such as in
>> Documentation/devicetree/bindings/media/ti,omap3isp.txt .
> 
> Thats a really good example thanks.
> 
>>
>>> +
>>> +- reg: should be <0>
>>> +- bus-width: the data bus width e.g. <8> for eight bit bus, or <16>
>>> +	     for sixteen bit wide bus.
>>> +
>>> +MIPI CSI-2 Endpoint:
>>> +
>>> +Required Properties:
>>> +
>>> +- reg: should be <1>
>>> +- data-lanes: should be <1 2 3 4> for four-lane operation,
>>> +	      or <1 2> for two-lane operation
>>> +- clock-lanes: should be <0>
>>> +- link-frequencies: List of allowed link frequencies in Hz. Each frequency is
>>> +		    expressed as a 64-bit big-endian integer. The frequency
>>> +		    is half of the bps per lane due to DDR transmission.
>>> +
>>> +Optional Properties:
>>> +
>>> +- clock-noncontinuous: Presence of this boolean property decides whether the
>>> +		       MIPI CSI-2 clock is continuous or non-continuous.
>>> +
>>> +For further information on the endpoint node properties, see
>>> +Documentation/devicetree/bindings/media/video-interfaces.txt.
>>> +
>>> +Example:
>>> +
>>> +&i2c {
>>> +	tc358746: tc358746@0e {
>>
>> The node name should be a generic name of the type of the device, not the
>> name of the specific device as such. A similar Cadence device uses
>> "csi-bridge".
> 
> Okay, I will change that.
> 
>>
>>> +		reg = <0x0e>;
>>> +		compatible = "toshiba,tc358746";
>>> +		pinctrl-names = "default";
>>> +		clocks = <&clk_cam_ref>;
>>> +		clock-names = "refclk";
>>> +		reset-gpios = <&gpio3 2 GPIO_ACTIVE_LOW>;
>>> +
>>> +		#address-cells = <1>;
>>> +		#size-cells = <0>;
>>> +
>>> +		port@0 {
>>> +			reg = <0>;
>>> +
>>> +			tc358746_parallel_in: endpoint {
>>> +				bus-width = <8>;
>>> +				remote-endpoint = <&micron_parallel_out>;
>>> +			};
>>> +		};
>>> +
>>> +		port@1 {
>>> +			reg = <1>;
>>> +
>>> +			tc358746_mipi2_out: endpoint {
>>> +				remote-endpoint = <&mipi_csi2_in>;
>>> +				data-lanes = <1 2>;
>>> +				clock-lanes = <0>;
>>> +				clock-noncontinuous;
>>> +				link-frequencies = /bits/ 64 <216000000>;
>>> +			};
>>> +		};
>>> +	};
>>> +};
>>
>> -- 
>> Kind regards,
>>
>> Sakari Ailus
>> sakari.ailus@linux.intel.com
>>
> 
