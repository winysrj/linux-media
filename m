Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47681 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729667AbeGMMlb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 08:41:31 -0400
Date: Fri, 13 Jul 2018 13:27:02 +0100
From: Sean Young <sean@mess.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 1/2] media: dt-bindings: bind nokia,n900-ir to generic
 pwm-ir-tx driver
Message-ID: <20180713122702.246b4yeyor4qqdst@gofer.mess.org>
References: <20180713095936.17673-1-sean@mess.org>
 <20180713111320.GB31525@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180713111320.GB31525@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 13, 2018 at 01:13:20PM +0200, Pavel Machek wrote:
> Hi!
> 
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  .../devicetree/bindings/media/nokia,n900-ir   | 20 -------------------
> >  arch/arm/boot/dts/omap3-n900.dts              |  2 +-
> >  drivers/media/rc/pwm-ir-tx.c                  |  1 +
> >  3 files changed, 2 insertions(+), 21 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/media/nokia,n900-ir
> > 
> > diff --git a/Documentation/devicetree/bindings/media/nokia,n900-ir b/Documentation/devicetree/bindings/media/nokia,n900-ir
> > deleted file mode 100644
> > index 13a18ce37dd1..000000000000
> > --- a/Documentation/devicetree/bindings/media/nokia,n900-ir
> > +++ /dev/null
> > @@ -1,20 +0,0 @@
> > -Device-Tree bindings for LIRC TX driver for Nokia N900(RX51)
> > -
> > -Required properties:
> > -	- compatible: should be "nokia,n900-ir".
> > -	- pwms: specifies PWM used for IR signal transmission.
> > -
> > -Example node:
> > -
> > -	pwm9: dmtimer-pwm@9 {
> > -		compatible = "ti,omap-dmtimer-pwm";
> > -		ti,timers = <&timer9>;
> > -		ti,clock-source = <0x00>; /* timer_sys_ck */
> > -		#pwm-cells = <3>;
> > -	};
> > -
> > -	ir: n900-ir {
> > -		compatible = "nokia,n900-ir";
> > -
> > -		pwms = <&pwm9 0 26316 0>; /* 38000 Hz */
> > -	};
> 
> Removing documentation is bad idea, I guess. The binding still exists
> and new kernels should still support it.

I've sent out a v3 correcting this.

Thank you for the review!


Sean
