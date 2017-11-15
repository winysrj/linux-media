Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:59644 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754183AbdKOSPL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 13:15:11 -0500
Date: Wed, 15 Nov 2017 19:15:05 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v1 01/10] dt-bindings: media: Add Renesas CEU bindings
Message-ID: <20171115181505.GB6736@w540>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
 <1510743363-25798-2-git-send-email-jacopo+renesas@jmondi.org>
 <CAMuHMdUG6gAEyyC0ANBzmj3KA-940+C7e9Nv_rLkBSjtfeKR1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdUG6gAEyyC0ANBzmj3KA-940+C7e9Nv_rLkBSjtfeKR1g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Wed, Nov 15, 2017 at 02:07:31PM +0100, Geert Uytterhoeven wrote:
> Hi Jacopo,
>
> CC devicetree folks

Yeah, sorry I forgot them. Sorry about this and thanks for adding the
address back!

>
> On Wed, Nov 15, 2017 at 11:55 AM, Jacopo Mondi
> <jacopo+renesas@jmondi.org> wrote:
> > Add bindings documentation for Renesas Capture Engine Unit (CEU).
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  .../devicetree/bindings/media/renesas,ceu.txt      | 87 ++++++++++++++++++++++
> >  1 file changed, 87 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/renesas,ceu.txt
> >
> > diff --git a/Documentation/devicetree/bindings/media/renesas,ceu.txt b/Documentation/devicetree/bindings/media/renesas,ceu.txt
> > new file mode 100644
> > index 0000000..a88e9cb
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
> > @@ -0,0 +1,87 @@
> > +Renesas Capture Engine Unit (CEU)
> > +----------------------------------------------
> > +
> > +The Capture Engine Unit is the image capture interface found on Renesas
> > +RZ chip series and on SH Mobile ones.
> > +
> > +The interface supports a single parallel input with up 8/16bits data bus width.
>
> ... with data bus widths up to 8/16 bits?
>
> > +
> > +Required properties:
> > +- compatible
> > +       Must be "renesas,renesas-ceu".
>
> The double "renesas" part looks odd to me. What about "renesas,ceu"?

I'm totally open for better "compatible" strings here, so yeah, let's
got for the shorter one you proposed...

> Shouldn't you add SoC-specific compatible values like "renesas,r7s72100-ceu",
> too?

Well, I actually have no SoC-specific data in the driver, so I don't
need SoC specific "compatible" values. But if it's a good practice
to have them anyway, I will add those in next spin..
>
> > +- reg
> > +       Physical address base and size.
> > +- interrupts
> > +       The interrupt line number.
>
> interrupt specifier

Yeah, it's not just the line number...

>

[snip]

> > +i2c1: i2c@fcfee400 {
> > +       pinctrl-names = "default";
> > +       pinctrl-0 = <&i2c1_pins>;
> > +
> > +       status = "okay";
> > +       clock-frequency = <100000>;
> > +
> > +       ov7670: camera@21 {
> > +               compatible = "ovti,ov7670";
> > +               reg = <0x21>;
> > +
> > +               pinctrl-names = "default";
> > +               pinctrl-0 = <&vio_pins>;
> > +
> > +               reset-gpios = <&port3 11 GPIO_ACTIVE_LOW>;
> > +               powerdown-gpios = <&port3 12 GPIO_ACTIVE_HIGH>;
> > +
> > +               clocks = <&xclk>;
> > +               clock-names = "xclk";
> > +
> > +               xclk: fixed_clk {
> > +                       compatible = "fixed-clock";
> > +                       #clock-cells = <0>;
> > +                       clock-frequency = <24000000>;
> > +               };

As Sakari pointed out in his review, this fixed clock is a detail
specific to the sensor used in the example (ov7670). For sake of
simplicity I can remove it.

Thanks
  j
