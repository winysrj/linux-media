Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02978C31680
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 17:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D097820989
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 17:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfAURme convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 12:42:34 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58547 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727597AbfAURme (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 12:42:34 -0500
Received: from litschi.hi.pengutronix.de ([2001:67c:670:100:feaa:14ff:fe6a:8db5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <m.tretter@pengutronix.de>)
        id 1gldai-0004an-JN; Mon, 21 Jan 2019 18:42:32 +0100
Date:   Mon, 21 Jan 2019 18:42:31 +0100
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        mchehab@kernel.org, robh+dt@kernel.org, kernel@pengutronix.de,
        tfiga@chromium.org
Subject: Re: [PATCH v2 1/3] media: dt-bindings: media: document allegro-dvt
 bindings
Message-ID: <20190121184231.16b3170e@litschi.hi.pengutronix.de>
In-Reply-To: <26befa99cb1ddb0c36823cb573f2012d4bd98015.camel@ndufresne.ca>
References: <20190118133716.29288-1-m.tretter@pengutronix.de>
        <20190118133716.29288-2-m.tretter@pengutronix.de>
        <1548068375.3287.1.camel@pengutronix.de>
        <26befa99cb1ddb0c36823cb573f2012d4bd98015.camel@ndufresne.ca>
Organization: Pengutronix
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 2001:67c:670:100:feaa:14ff:fe6a:8db5
X-SA-Exim-Mail-From: m.tretter@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, 21 Jan 2019 11:17:43 -0500, Nicolas Dufresne wrote:
> Le lundi 21 janvier 2019 à 11:59 +0100, Philipp Zabel a écrit :
> > On Fri, 2019-01-18 at 14:37 +0100, Michael Tretter wrote:  
> > > Add device-tree bindings for the Allegro DVT video IP core found on the
> > > Xilinx ZynqMP EV family.
> > > 
> > > Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
> > > ---
> > > Changes since v1:
> > > none
> > > 
> > > ---
> > >  .../devicetree/bindings/media/allegro.txt     | 35 +++++++++++++++++++
> > >  1 file changed, 35 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/media/allegro.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/media/allegro.txt b/Documentation/devicetree/bindings/media/allegro.txt
> > > new file mode 100644
> > > index 000000000000..765f4b0c1a57
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/media/allegro.txt
> > > @@ -0,0 +1,35 @@
> > > +Device-tree bindings for the Allegro DVT video IP codecs present in the Xilinx
> > > +ZynqMP SoC. The IP core may either be a H.264/H.265 encoder or H.264/H.265
> > > +decoder ip core.
> > > +
> > > +Each actual codec engines is controlled by a microcontroller (MCU). Host
> > > +software uses a provided mailbox interface to communicate with the MCU. The
> > > +MCU share an interrupt.
> > > +
> > > +Required properties:
> > > +  - compatible: value should be one of the following
> > > +    "allegro,al5e-1.1", "allegro,al5e": encoder IP core
> > > +    "allegro,al5d-1.1", "allegro,al5d": decoder IP core
> > > +  - reg: base and length of the memory mapped register region and base and
> > > +    length of the memory mapped sram
> > > +  - reg-names: must include "regs" and "sram"
> > > +  - interrupts: shared interrupt from the MCUs to the processing system
> > > +  - interrupt-names: "vcu_host_interrupt"
> > > +
> > > +Example:
> > > +	al5e: al5e@a0009000 {  
> > 
> > Should the node names be "vpu" or "video-codec"?  
> 
> Xilinx calls this IP the "vcu", so "vpu" would be even more confusing.

The term vcu, as used by Xilinx, includes the encoder, decoder, both
microblaze processors, and the "VCU Settings" module. The already
existing "xlnx,vcu" binding refers to this "VCU Settings" module (or
"VCU System-Level Control" or "LogicoreIP").

> Was this just a typo ? That being said, is this referring to the actual
> HW or the firmware that runs on a microblaze (the firmware being
> Allegro specific) ?

The binding refers to actual hardware, i.e., encoder + microblaze or
decoder + microblaze. My understanding is that the microblaze is a
generic microblaze, but is integrated with the Allegro specific
encoder/decoder IP into a single codec IP block.

Michael

> 
> >   
> > > +		compatible = "allegro,al5e";
> > > +		reg = <0 0xa0009000 0 0x1000>,
> > > +		      <0 0xa0000000 0 0x8000>;
> > > +		reg-names = "regs", "sram";
> > > +		interrupt-names = "vcu_host_interrupt";
> > > +		interrupts = <0 96 4>;
> > > +	};
> > > +	al5d: al5d@a0029000 {
> > > +		compatible = "allegro,al5d";
> > > +		reg = <0 0xa0029000 0 0x1000>,
> > > +		      <0 0xa0020000 0 0x8000>;
> > > +		reg-names = "regs", "sram";
> > > +		interrupt-names = "vcu_host_interrupt";
> > > +		interrupts = <0 96 4>;
> > > +	};  
> > 
> > regards
> > Philipp  
