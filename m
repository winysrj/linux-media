Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38416 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752675AbcKCWUW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Nov 2016 18:20:22 -0400
Date: Fri, 4 Nov 2016 00:20:14 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Rob Herring <robh@kernel.org>, ivo.g.dimitrov.75@gmail.com,
        sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: et8ek8: add device tree binding documentation
Message-ID: <20161103222014.GI3217@valkosipuli.retiisi.org.uk>
References: <20161023191706.GA25754@amd>
 <20161030204134.hpmfrnqhd4mg563o@rob-hp-laptop>
 <20161103124749.GA22180@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161103124749.GA22180@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel and Rob,

On Thu, Nov 03, 2016 at 01:47:49PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > +Mandatory properties
> > > +--------------------
> > > +
> > > +- compatible: "toshiba,et8ek8"
> > > +- reg: I2C address (0x3e, or an alternative address)
> > > +- vana-supply: Analogue voltage supply (VANA), 2.8 volts
> > > +- clocks: External clock to the sensor
> > > +- clock-frequency: Frequency of the external clock to the sensor. Camera
> > > +  driver will set this frequency on the external clock.
> > 
> > This is fine if the frequency is fixed (e.g. an oscillator), but you 
> > should use the clock binding if clocks are programable.
> 
> It is fixed. So I assume this can stay as is? Or do you want me to add
> "The clock frequency is a pre-determined frequency known to be
> suitable to the board." as Sakari suggests?
> 
> > > +- reset-gpios: XSHUTDOWN GPIO
> > 
> > Please state what the active polarity is.
> 
> As in "This gpio will be set to 1 when the chip is powered." ?

How about:

"The XSHUTDOWN signal is active high. The sensor is in hardware standby
mode when the signal is in low state."

These bindings start looking more precise than the smiapp ones. :-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
