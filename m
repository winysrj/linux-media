Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51786 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932280AbaLBAEO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 19:04:14 -0500
Date: Tue, 2 Dec 2014 01:56:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [REVIEW PATCH v2.1 08/11] of: smiapp: Add documentation
Message-ID: <20141201235626.GU8907@valkosipuli.retiisi.org.uk>
References: <1416289426-804-9-git-send-email-sakari.ailus@iki.fi>
 <1417364809-4693-1-git-send-email-sakari.ailus@iki.fi>
 <20141201104200.GC17070@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201104200.GC17070@leverpostej>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mark,

Thank you for the review.

On Mon, Dec 01, 2014 at 10:42:01AM +0000, Mark Rutland wrote:
> On Sun, Nov 30, 2014 at 04:26:48PM +0000, Sakari Ailus wrote:
> > Document the smiapp device tree properties.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> > since v2:
> > - Cleanups
> > - Removed clock-names property documentation
> > - Port node documentation was really endpoint node documentation
> > - Added remote-endpoint as mandatory endpoint node properties
> > 
> >  .../devicetree/bindings/media/i2c/nokia,smia.txt   |   64 ++++++++++++++++++++
> >  MAINTAINERS                                        |    1 +
> >  2 files changed, 65 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> > new file mode 100644
> > index 0000000..2114a4d
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> > @@ -0,0 +1,64 @@
> > +SMIA/SMIA++ sensor
> > +
> > +SMIA (Standard Mobile Imaging Architecture) is an image sensor standard
> > +defined jointly by Nokia and ST. SMIA++, defined by Nokia, is an extension
> > +of that. These definitions are valid for both types of sensors.
> > +
> > +More detailed documentation can be found in
> > +Documentation/devicetree/bindings/media/video-interfaces.txt .
> > +
> > +
> > +Mandatory properties
> > +--------------------
> > +
> > +- compatible: "nokia,smia"
> > +- reg: I2C address (0x10, or an alternative address)
> > +- vana-supply: Analogue voltage supply (VANA), typically 2,8 volts (sensor
> > +  dependent).
> > +- clocks: External clock phandle
> 
> Not just a phandle, there's a clock-specifier too.
> 
> Just describe what the clock logically is, don't bother with describing
> the format of the property (whcih is standardised elsewhere).

I'll change this to "External clock to the sensor".

> > +- clock-frequency: Frequency of the external clock to the sensor
> 
> Is this the preferred frequency to operate the device at? Is there not a
> standard frequency to use? We can query the rate from the clock
> otherwise.

This is a board-specific fixed frequency. There is no standard one, but
this depends on several factors such as EMC-safe frequency bands and which
frequencies can actually be supported by the clock source.

The sensor has a PLL so other frequencies can be produced later on.

> > +- link-frequency: List of allowed data link frequencies. An array of 64-bit
> > +  elements.
> 
> Something like 'allowed-link-frequencies' might be better, unlesss this
> is derived from another binding?

I'll use that instead.

This is an array of safe link frequencies (e.g. CSI-2 bus) that can be
derived from the clock-frequency.

> > +
> > +
> > +Optional properties
> > +-------------------
> > +
> > +- nokia,nvm-size: The size of the NVM, in bytes. If the size is not given,
> > +  the NVM contents will not be read.
> 
> Where 'NVM' standas for what?
> 
> What is this used for?

NVM is for non-volatile memory. All except cheapest camera modules contain
an EEPROM chip which contains unit specific tuning data. This data is parsed
and used by the user space.

The smiapp driver only provides read access to this data over sysfs
interface.

The EEPROM chip is typically a part of the same I2C device and thus accessed
through the sensor --- see smiapp_read_nvm() in
drivers/media/i2c/smiapp/smiapp-core.c .

> > +- reset-gpios: XSHUTDOWN GPIO
> > +
> > +
> > +Endpoint node mandatory properties
> > +----------------------------------
> > +
> > +- clock-lanes: <0>
> > +- data-lanes: <1..n>
> > +- remote-endpoint: A phandle to the bus receiver's endpoint node.
> > +
> > +
> > +Example
> > +-------
> > +
> > +&i2c2 {
> > +	clock-frequency = <400000>;
> > +
> > +	smiapp_1: camera@10 {
> > +		compatible = "nokia,smia";
> > +		reg = <0x10>;
> > +		reset-gpios = <&gpio3 20 0>;
> > +		vana-supply = <&vaux3>;
> > +		clocks = <&omap3_isp 0>;
> > +		clock-names = "ext_clk";
> 
> This wasn't described above. Either mandate it in the binding (and
> define clock in terms of clock-names) or drop it.

This is leftover from time when I had this property around. There's just a
single clock so I guess there's no need to call it by a name.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
