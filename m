Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA73C64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9FA620892
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:33:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9FA620892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbeLGLdQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 06:33:16 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:36259 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725987AbeLGLdQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 06:33:16 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id VENag65gBgJOKVENdgYZpT; Fri, 07 Dec 2018 12:33:14 +0100
Subject: Re: [PATCH 2/5] media: dt-bindings: Add binding for si470x radio
To:     =?UTF-8?Q?Pawe=c5=82_Chmiel?= <pawel.mikolaj.chmiel@gmail.com>,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc:     fischerdouglasc@gmail.com, keescook@chromium.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20181205154750.17996-1-pawel.mikolaj.chmiel@gmail.com>
 <20181205154750.17996-3-pawel.mikolaj.chmiel@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2c8bb6ef-5f37-69ef-6829-a9e9ad04579b@xs4all.nl>
Date:   Fri, 7 Dec 2018 12:33:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20181205154750.17996-3-pawel.mikolaj.chmiel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfBpph9FW1f2S+h/GnTx6UOx/mchn8Va9qf4EDRylPcxi74RMC6uk2oOYC9CZo7csCLbcsLDeIdA1BSXCNJOfsu+aVHpMqm8r2xr+mNrERJJixLef7Mip
 HwcTLpdVVKrPyBuOFCwyHafWSP06Mb/xKVBkWKekiznG6cHygUE9iL3sn13zuzUpMXBRpWZCtHMYmK+TaxnrHWZxWbway46L+mgWQDnWCpw+ey+ILduMC06O
 yrMU45s0nEgaJMwYbP5E8kCQFLKeXX2L1dVidZlIEMH1sjSD24k74mc18Y1z0KQdroGxD8+Oa0V9hcB5x5wWaoVGS7PAgfk2kvxf83p6OY9D70+ZXMbWvDt+
 Vx/b4BZaKJzBLxw9Fn2F8PztXPnFHk0Moi+ilDB22e+s7kQjMhWy/J1TozzZH8nBzgjnRsqz57rKfqFyEZX5J2HXhXiwwolW74CNps42ksJZfOWbWbw=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Please combine 2/5 with 5/5. No need to have two patches for these bindings.

Regards,

	Hans

On 12/05/2018 04:47 PM, Paweł Chmiel wrote:
> Add device tree bindings for si470x family radio receiver driver.
> 
> Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
> ---
>  .../devicetree/bindings/media/si470x.txt      | 24 +++++++++++++++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/si470x.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/si470x.txt b/Documentation/devicetree/bindings/media/si470x.txt
> new file mode 100644
> index 000000000000..9294fdfd3aae
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/si470x.txt
> @@ -0,0 +1,24 @@
> +* Silicon Labs FM Radio receiver
> +
> +The Silicon Labs Si470x is family of FM radio receivers with receive power scan
> +supporting 76-108 MHz, programmable through an I2C interface.
> +Some of them includes an RDS encoder.
> +
> +Required Properties:
> +- compatible: Should contain "silabs,si470x"
> +- reg: the I2C address of the device
> +
> +Optional Properties:
> +- interrupts : The interrupt number
> +
> +Example:
> +
> +&i2c2 {
> +        si470x@63 {
> +                compatible = "silabs,si470x";
> +                reg = <0x63>;
> +
> +                interrupt-parent = <&gpj2>;
> +                interrupts = <4 IRQ_TYPE_EDGE_FALLING>;
> +        };
> +};
> 

