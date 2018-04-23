Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52086 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754746AbeDWL73 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 07:59:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Peter Rosin <peda@axentia.se>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        architt@codeaurora.org, a.hajda@samsung.com, airlied@linux.ie,
        daniel@ffwll.ch, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] dt-bindings: display: bridge: thc63lvd1024: Add lvds map property
Date: Mon, 23 Apr 2018 14:59:40 +0300
Message-ID: <4581508.09qg8X0yyC@avalon>
In-Reply-To: <20180423073504.GN4235@w540>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org> <17d6f6b0-e657-4a5f-63a6-572cdf062bd3@axentia.se> <20180423073504.GN4235@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Monday, 23 April 2018 10:35:04 EEST jacopo mondi wrote:
> On Sun, Apr 22, 2018 at 10:02:41PM +0200, Peter Rosin wrote:
> > On 2018-04-19 11:31, Jacopo Mondi wrote:
> >> The THC63LVD1024 LVDS to RGB bridge supports two different input mapping
> >> modes, selectable by means of an external pin.
> >> 
> >> Describe the LVDS mode map through a newly defined mandatory property in
> >> device tree bindings.
> >> 
> >> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >> ---
> >> 
> >>  .../devicetree/bindings/display/bridge/thine,thc63lvd1024.txt    | 3 +++
> >>  1 file changed, 3 insertions(+)
> >> 
> >> diff --git
> >> a/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
> >> b/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
> >> index 37f0c04..0937595 100644
> >> ---
> >> a/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
> >> +++
> >> b/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
> >> @@ -12,6 +12,8 @@ Required properties:
> >>  - compatible: Shall be "thine,thc63lvd1024"
> >>  - vcc-supply: Power supply for TTL output, TTL CLOCKOUT signal, LVDS
> >>  input,
> >>    PPL and digital circuitry
> >> 
> >> +- thine,map: LVDS mapping mode selection signal, pin name "MAP". Shall
> >> be <1>
> >> +  for mapping mode 1, <0> for mapping mode 2
> > 
> > Since the MAP pin is an input pin, I would expect there to be an optional
> > gpio specifier like thine,map-gpios so that the driver can set it
> > according to the value given in thine,map in case the HW has a line from
> > some gpio output to the MAP pin (instead of hardwired hi/low which seem
> > to be your thinking).
> 
> I see... As the only use case I had has the pin tied to vcc, I
> thought about making it a binary property, and I wonder in how many
> cases the chip 'MAP' pin would actually be GPIO controlled input and
> not an hardwired one instead. I don't see the LVDS mapping mode to be
> changed at runtime, but you are right, who knows....
> 
> Do you think we can add an options 'thine,map-gpios' property along
> to the proposed ones?

If the MAP pin is connected to an SoC-controlled GPIO for a given platform 
then we will likely need a thine,map-gpios property to control the pin. I 
think we can leave it out for now and add it later if the need arises.

The thine,map property serves a different purpose, it indicates the level of 
the MAP pin for platforms where the pin is hardwired. If we later introduce a 
thine,map-gpios property it should be mutually exclusive with the thine,map 
property. The level of the MAP pin should be then software-controlled, not set 
through DT.

> >>  Optional properties:
> >>  - powerdown-gpios: Power down GPIO signal, pin name "/PDWN". Active low
> >> 
> >> @@ -36,6 +38,7 @@ Example:
> >>  		vcc-supply = <&reg_lvds_vcc>;
> >>  		powerdown-gpios = <&gpio4 15 GPIO_ACTIVE_LOW>;
> >> +		thine,map = <1>;
> >> 
> >>  		ports {
> >>  			#address-cells = <1>;

-- 
Regards,

Laurent Pinchart
