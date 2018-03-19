Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:35007 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755373AbeCSIgJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 04:36:09 -0400
Date: Mon, 19 Mar 2018 09:35:58 +0100
From: Simon Horman <horms@verge.net.au>
To: Rob Herring <robh@kernel.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: media: rcar_vin: Use status "okay"
Message-ID: <20180319083558.b4wr3zha25bj25fh@verge.net.au>
References: <1520588080-31264-1-git-send-email-geert+renesas@glider.be>
 <20180317231028.xehdgkpagjs6nerm@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180317231028.xehdgkpagjs6nerm@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 18, 2018 at 07:47:57AM -0500, Rob Herring wrote:
> On Fri, Mar 09, 2018 at 10:34:40AM +0100, Geert Uytterhoeven wrote:
> > According to the Devicetree Specification, "ok" is not a valid status.
> 
> Correct.
> 
> > Fixes: 47c71bd61b772cd7 ("[media] rcar_vin: add devicetree support")
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> > For the checkpatch TODO list?
> > https://www.devicetree.org/
> > 
> >  Documentation/devicetree/bindings/media/rcar_vin.txt | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> > index 68c5c497b7fa5551..a19517e1c669eb35 100644
> > --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> > +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> > @@ -81,7 +81,7 @@ Board setup example for Gen2 platforms (vin1 composite video input)
> >  -------------------------------------------------------------------
> >  
> >  &i2c2   {
> > -        status = "ok";
> > +        status = "okay";
> 
> However, I prefer that status not be in examples as it applies to any 
> node and the SoC/board split is not relevant to binding docs. I'd 
> cleaned all these up except for the cases with SoC/board split.

Hi Rob,

I'm a little confused. This example is a board override for
a node (implicitly) defined in the DT of an SoC. Could you clarify
when the status should be omitted?

> 
> >          pinctrl-0 = <&i2c2_pins>;
> >          pinctrl-names = "default";
> >  
> > @@ -104,7 +104,7 @@ Board setup example for Gen2 platforms (vin1 composite video input)
> >          pinctrl-0 = <&vin1_pins>;
> >          pinctrl-names = "default";
> >  
> > -        status = "ok";
> > +        status = "okay";
> >  
> >          port {
> >                  #address-cells = <1>;
> > -- 
> > 2.7.4
> > 
> 
