Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59899 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753298AbdGJPKS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 11:10:18 -0400
Date: Mon, 10 Jul 2017 16:10:16 +0100
From: Sean Young <sean@mess.org>
To: Rob Herring <robh@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 5/6] [media] dt-bindings: gpio-ir-tx: add support for
 GPIO IR Transmitter
Message-ID: <20170710151016.5iaokchdejxozrte@gofer.mess.org>
References: <cover.1499419624.git.sean@mess.org>
 <580c648de65344e9316ff153ba316efd4d527f12.1499419624.git.sean@mess.org>
 <20170710150538.ql26gswdf2obch6o@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170710150538.ql26gswdf2obch6o@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 10, 2017 at 10:05:38AM -0500, Rob Herring wrote:
> On Fri, Jul 07, 2017 at 10:52:03AM +0100, Sean Young wrote:
> > Document the device tree bindings for the GPIO Bit Banging IR
> > Transmitter.
> > 
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt b/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
> > new file mode 100644
> > index 0000000..bc08d89
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/leds/irled/gpio-ir-tx.txt
> > @@ -0,0 +1,11 @@
> > +Device tree bindings for IR LED connected through gpio pin which is used as
> > +remote controller transmitter.
> > +
> > +Required properties:
> > +	- compatible: should be "gpio-ir-tx".
> 
> As I mentioned in the prior version, missing the "gpios" property.

Absolutely right. I hadn't gotten round to sending out a new version
yet, I'll do that soon.


Thanks,

Sean
