Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E94AC31681
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 17:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D176720663
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 17:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548090831;
	bh=PDEwgNil0pt/FeKOWao1VbtgPA10jMT46+PghKPNDc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=iXiwb07xEdwhNwcJ3B3ur/j1DN94xNwR0L3XDcGWukoAKwmU2z+e808qeW9B3MY5m
	 mySgsSXCoj071fhaIAxZFcrMJvOmZXrpmLh5p3wOk/aDArOtSp8p8VNGUGG+2H/7hQ
	 o3p5ECufw6jQS0JUdwtqc16Xg6SLlvhH9ofjIKGg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfAURNu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 12:13:50 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42342 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfAURNu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 12:13:50 -0500
Received: by mail-ot1-f68.google.com with SMTP id v23so21133915otk.9;
        Mon, 21 Jan 2019 09:13:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8N55HbATCjr3273I82PnuDeCiv1JKrEMn6dgRSmObYk=;
        b=M+iR1fLnPQWdbM/Y5wNs5p/NSSVtvtoOtJ5MbeweFrgnD7SAfhw0I1MXk6UzXYqQ9w
         x9gXJ9jzUg2MxYxVlSyGcoMW7yWIlGg3JNwxXm+lIk2zjblt3uwb4fsHuX8Me+9O9ZQ4
         z+DDSlJr5qe42s7RJ7+f0cuhMbg7UiTKjbT2ZoF4sBFRzKbQJqv8rAhat16TA8IgvTvL
         +lJA1RR9uUOk9/f8P5CyJvaBa9CHGANWWWMNvHgfgNOefGapxmSWIngxGU+sPFS+q8W6
         DJkx6Olh+tQ9fuEbNx9VWbB27g41Op83eaisgxHMDDNRrA2564oOXaoCtWxm3BXjQoQQ
         /CKw==
X-Gm-Message-State: AJcUukfnwkmJ+h1iZiaRxGtxM75X4+fOdDXd4Cu72FxKrfi1MXws5rwq
        lY+EzJ8GnfjEVHwcoGo9hw==
X-Google-Smtp-Source: ALg8bN7MG66M0xCVvS9aCOIjn6P59mYrptZnpJYlQxFWfxhREQ+6DG8+JgE/hzD6lRMZBuTCduDGzw==
X-Received: by 2002:a9d:19eb:: with SMTP id k98mr9904959otk.205.1548090829488;
        Mon, 21 Jan 2019 09:13:49 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id l16sm5699504otr.13.2019.01.21.09.13.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 21 Jan 2019 09:13:49 -0800 (PST)
Date:   Mon, 21 Jan 2019 11:13:48 -0600
From:   Rob Herring <robh@kernel.org>
To:     Michael Tretter <m.tretter@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, mchehab@kernel.org, tfiga@chromium.org
Subject: Re: [PATCH v2 1/3] media: dt-bindings: media: document allegro-dvt
 bindings
Message-ID: <20190121171348.GA4532@bogus>
References: <20190118133716.29288-1-m.tretter@pengutronix.de>
 <20190118133716.29288-2-m.tretter@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190118133716.29288-2-m.tretter@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Jan 18, 2019 at 02:37:14PM +0100, Michael Tretter wrote:
> Add device-tree bindings for the Allegro DVT video IP core found on the
> Xilinx ZynqMP EV family.
> 
> Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
> ---
> Changes since v1:
> none
> 
> ---
>  .../devicetree/bindings/media/allegro.txt     | 35 +++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/allegro.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/allegro.txt b/Documentation/devicetree/bindings/media/allegro.txt
> new file mode 100644
> index 000000000000..765f4b0c1a57
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/allegro.txt
> @@ -0,0 +1,35 @@
> +Device-tree bindings for the Allegro DVT video IP codecs present in the Xilinx
> +ZynqMP SoC. The IP core may either be a H.264/H.265 encoder or H.264/H.265
> +decoder ip core.
> +
> +Each actual codec engines is controlled by a microcontroller (MCU). Host
> +software uses a provided mailbox interface to communicate with the MCU. The
> +MCU share an interrupt.
> +
> +Required properties:
> +  - compatible: value should be one of the following
> +    "allegro,al5e-1.1", "allegro,al5e": encoder IP core
> +    "allegro,al5d-1.1", "allegro,al5d": decoder IP core
> +  - reg: base and length of the memory mapped register region and base and
> +    length of the memory mapped sram
> +  - reg-names: must include "regs" and "sram"
> +  - interrupts: shared interrupt from the MCUs to the processing system
> +  - interrupt-names: "vcu_host_interrupt"

No point in having *-names when there is only one entry.

> +
> +Example:
> +	al5e: al5e@a0009000 {

video-codec as suggested.

> +		compatible = "allegro,al5e";

Doesn't match the documentation above.

> +		reg = <0 0xa0009000 0 0x1000>,
> +		      <0 0xa0000000 0 0x8000>;
> +		reg-names = "regs", "sram";
> +		interrupt-names = "vcu_host_interrupt";
> +		interrupts = <0 96 4>;
> +	};
> +	al5d: al5d@a0029000 {
> +		compatible = "allegro,al5d";
> +		reg = <0 0xa0029000 0 0x1000>,
> +		      <0 0xa0020000 0 0x8000>;
> +		reg-names = "regs", "sram";
> +		interrupt-names = "vcu_host_interrupt";
> +		interrupts = <0 96 4>;
> +	};
> -- 
> 2.20.1
> 
