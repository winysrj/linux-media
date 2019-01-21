Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C713C282DB
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 10:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A6012085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 10:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfAUK7h (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 05:59:37 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33073 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfAUK7h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 05:59:37 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1glXIm-0004S0-2Z; Mon, 21 Jan 2019 11:59:36 +0100
Message-ID: <1548068375.3287.1.camel@pengutronix.de>
Subject: Re: [PATCH v2 1/3] media: dt-bindings: media: document allegro-dvt
 bindings
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Michael Tretter <m.tretter@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     mchehab@kernel.org, robh+dt@kernel.org, kernel@pengutronix.de,
        tfiga@chromium.org
Date:   Mon, 21 Jan 2019 11:59:35 +0100
In-Reply-To: <20190118133716.29288-2-m.tretter@pengutronix.de>
References: <20190118133716.29288-1-m.tretter@pengutronix.de>
         <20190118133716.29288-2-m.tretter@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, 2019-01-18 at 14:37 +0100, Michael Tretter wrote:
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
> +
> +Example:
> +	al5e: al5e@a0009000 {

Should the node names be "vpu" or "video-codec"?

> +		compatible = "allegro,al5e";
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

regards
Philipp
