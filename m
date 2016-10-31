Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33832 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S946126AbcJaWsV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 18:48:21 -0400
Date: Tue, 1 Nov 2016 00:47:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Rob Herring <robh@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>, ivo.g.dimitrov.75@gmail.com,
        sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: et8ek8: add device tree binding documentation
Message-ID: <20161031224739.GA3217@valkosipuli.retiisi.org.uk>
References: <20161023191706.GA25754@amd>
 <20161030204134.hpmfrnqhd4mg563o@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161030204134.hpmfrnqhd4mg563o@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob and Pavel,

On Sun, Oct 30, 2016 at 03:41:34PM -0500, Rob Herring wrote:
> On Sun, Oct 23, 2016 at 09:17:06PM +0200, Pavel Machek wrote:
> > 
> > Add device tree binding documentation for toshiba et8ek8 sensor.
> > 
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > ---
> > 
> > diff from v3: explain what clock-frequency means
> > 
> > 
> > diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
> > new file mode 100644
> > index 0000000..54863cf
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
> > @@ -0,0 +1,51 @@
> > +Toshiba et8ek8 5MP sensor
> > +
> > +Toshiba et8ek8 5MP sensor is an image sensor found in Nokia N900 device
> > +
> > +More detailed documentation can be found in
> > +Documentation/devicetree/bindings/media/video-interfaces.txt .
> > +
> > +
> > +Mandatory properties
> > +--------------------
> > +
> > +- compatible: "toshiba,et8ek8"
> > +- reg: I2C address (0x3e, or an alternative address)
> > +- vana-supply: Analogue voltage supply (VANA), 2.8 volts
> > +- clocks: External clock to the sensor
> > +- clock-frequency: Frequency of the external clock to the sensor. Camera
> > +  driver will set this frequency on the external clock.
> 
> This is fine if the frequency is fixed (e.g. an oscillator), but you 
> should use the clock binding if clocks are programable.

We've discussed the matter here (v3):

<URL:http://www.spinics.net/lists/linux-media/msg101210.html>

<URL:http://www.spinics.net/lists/linux-media/msg101233.html>

Pavel, could you add to the desciption e.g.:

"The clock frequency is a pre-determined frequency known to be suitable to
the board."

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
