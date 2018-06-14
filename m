Return-path: <linux-media-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:33288 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755302AbeFNPSc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 11:18:32 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC 0/2] media: adv748x: Fix decimal unit addresses
Date: Thu, 14 Jun 2018 15:48:06 +0200
Message-Id: <1528984088-24801-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	Hi Rob et al.

Recent dtc assumes unit addresses are always hexadecimal (without
prefix), while the bases of reg property values depend on their
prefixes, and thus can be either decimal or hexadecimal.

This leads to (with W=1):

    Warning (graph_port): video-receiver@70/port@10: graph node unit address error, expected "a"
    Warning (graph_port): video-receiver@70/port@11: graph node unit address error, expected "b"

In this particular case, the unit addresses are (assumed hexadecimal) 10
resp. 11, while the reg properties are decimal 10 resp. 11, and thus
don't match.

This RFC patch series corrects the unit addresses to match the reg
address values for the DT bindings for adi,adv748x and its users.
There's at least one other violator (port@10 in
arch/arm/boot/dts/vf610-zii-dev-rev-c.dts), which I didn't fix.

However, ePAPR v1.1 states:

    The unit-address component of the name is specific to the bus type
    on which the node sits. It consists of one or more ASCII characters
    from the set of characters in Table 2-1. The unit-address must match
    the first address specified in the reg property of the node. If the
    node has no reg property, the @ and unit-address must be omitted and
    the node-name alone differentiates the node from other nodes at the
    same level in the tree. The binding for a particular bus may specify
    additional, more specific requirements for the format of reg and the
    unit-address.

i.e. nothing about an hexadecimal address requirement?

Should this series be applied, or should the warnings be ignored, until
dtc is fixed?

Thanks for your comments!

Geert Uytterhoeven (2):
  media: dt-bindings: adv748x: Fix decimal unit addresses
  arm64: dts: renesas: salvator-common: Fix adv7482 decimal unit
    addresses

 Documentation/devicetree/bindings/media/i2c/adv748x.txt | 4 ++--
 arch/arm64/boot/dts/renesas/salvator-common.dtsi        | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.7.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
