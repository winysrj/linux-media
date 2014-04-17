Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38563 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbaDQNI0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 09:08:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v2 46/48] adv7604: Add DT support
Date: Thu, 17 Apr 2014 15:08:29 +0200
Message-ID: <2010144.jYKNNgF1x7@avalon>
In-Reply-To: <1810096.BfEfAl25kc@avalon>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com> <534FB40A.20506@samsung.com> <1810096.BfEfAl25kc@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 17 April 2014 14:36:32 Laurent Pinchart wrote:
> On Thursday 17 April 2014 12:59:22 Sylwester Nawrocki wrote:
> > On 11/03/14 00:15, Laurent Pinchart wrote:
> > > Parse the device tree node to populate platform data.
> > > 
> > > Cc: devicetree@vger.kernel.org
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > > 
> > >  .../devicetree/bindings/media/i2c/adv7604.txt      | 56 +++++++++++++
> > >  drivers/media/i2c/adv7604.c                        | 92
> > >  +++++++++++++----
> > >  2 files changed, 134 insertions(+), 14 deletions(-)
> > >  create mode 100644
> > >  Documentation/devicetree/bindings/media/i2c/adv7604.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> > > b/Documentation/devicetree/bindings/media/i2c/adv7604.txt new file mode
> > > 100644
> > > index 0000000..0845c50
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> > > @@ -0,0 +1,56 @@
> > > +* Analog Devices ADV7604/11 video decoder with HDMI receiver
> > > +
> > > +The ADV7604 and ADV7611 are multiformat video decoders with an
> > > integrated
> > > HDMI +receiver. The ADV7604 has four multiplexed HDMI inputs and one
> > > analog input, +and the ADV7611 has one HDMI input and no analog input.
> > > +
> > > +Required Properties:
> > > +
> > > +  - compatible: Must contain one of the following
> > > +    - "adi,adv7604" for the ADV7604
> > > +    - "adi,adv7611" for the ADV7611
> > > +
> > > +  - reg: I2C slave address
> > > +
> > > +  - hpd-gpios: References to the GPIOs that control the HDMI hot-plug
> > > +    detection pins, one per HDMI input. The active flag indicates the
> > > GPIO
> > > +    level that enables hot-plug detection.
> > > +
> > > +Optional Properties:
> > > +
> > > +  - reset-gpios: Reference to the GPIO connected to the device's reset
> > > pin. +
> > > +  - adi,default-input: Index of the input to be configured as default.
> > > Valid
> > > +    values are 0..5 for the ADV7604 and 0 for the ADV7611.
> > 
> > I have some doubts about this property. Firstly, it seems it is not needed
> > for ADV7611 since it is always 0 for that device ?
> > Why can't we hard code in the driver some default input ?
> 
> I've thought about hardcoding a default input in the driver as well, but
> Hans wasn't really keen on the idea. Hans, could you please comment on this
> ?
> > And which inputs it refers to ? HDMI inputs A..D + analog ? If we keep
> > this
> > property I think exact mapping of numbers to inputs should be included
> > in description of this property.
> > 
> > > +  - adi,disable-power-down: Boolean property. When set forces the
> > > device
> > > to
> > > +    ignore the power-down pin. The property is valid for the ADV7604
> > > only
> > > as
> > > +    the ADV7611 has no power-down pin.
> > 
> > Does it refer to the !PWRDWN pin ? If so I would replace "power-down" with
> > PWRDWN, so it is clear what we're talking about when someone looks only
> > at the datasheet.
> > 
> > > +  - adi,disable-cable-reset: Boolean property. When set disables the
> > > HDMI
> > > +    receiver automatic reset when the HDMI cable is unplugged.
> > 
> > Couldn't this be configured from user space with some default assumed in
> > the driver ?
> 
> Good question. I'm not sure what the exact use case for this is.
> 
> Let's be careful not to introduce unneeded properties, I'll drop those two
> properties for now, we can implement support for the features later when
> needed.
> 
> > > +Example:
> > > +
> > > +	hdmi_receiver@4c {
> > > +		compatible = "adi,adv7611";
> > > +		reg = <0x4c>;
> > > +
> > > +		reset-gpios = <&ioexp 0 GPIO_ACTIVE_LOW>;
> > > +		hpd-gpios = <&ioexp 2 GPIO_ACTIVE_HIGH>;
> > > +
> > > +		adi,default-input = <0>;
> > > +
> > > +		#address-cells = <1>;
> > > +		#size-cells = <0>;
> > > +
> > > +		port@0 {
> > > +			reg = <0>;
> > > +		};
> > > +		port@1 {
> > > +			reg = <1>;
> > > +			hdmi_in: endpoint {
> > > +				remote-endpoint = <&ccdc_in>;
> > > +			};
> > > +		};
> > > +	};
> > > diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> > > index cce140c..de44213 100644
> > > --- a/drivers/media/i2c/adv7604.c
> > > +++ b/drivers/media/i2c/adv7604.c
> 
> [snip]
> 
> > > @@ -2836,21 +2906,15 @@ static int adv7604_remove(struct i2c_client
> > > *client)>
> > > 
> > >  /* -------------------------------------------------------------------
> > >  */
> > > 
> > > -static struct i2c_device_id adv7604_id[] = {
> > > -	{ "adv7604", ADV7604 },
> > > -	{ "adv7611", ADV7611 },
> > > -	{ }
> > > -};
> > > -MODULE_DEVICE_TABLE(i2c, adv7604_id);
> > > -
> > > 
> > >  static struct i2c_driver adv7604_driver = {
> > >  
> > >  	.driver = {
> > >  	
> > >  		.owner = THIS_MODULE,
> > >  		.name = "adv7604",
> > > 
> > > +		.of_match_table = of_match_ptr(adv7604_of_id),
> > 
> > of_match_ptr() isn't necessary here.
> 
> Thanks, will fix in v3.

On second thought, as the driver has non-DT users, keeping of_match_ptr() and 
marking the table as __maybe_unused will optimize the table out if neither 
CONFIG_OF nor CONFIG_MODULE is set. I'd thus prefer keeping of_match_ptr().

> > >  	},
> > >  	.probe = adv7604_probe,
> > >  	.remove = adv7604_remove,
> > > 
> > > -	.id_table = adv7604_id,
> > > +	.id_table = adv7604_i2c_id,
> > > 
> > >  };
> > >  
> > >  module_i2c_driver(adv7604_driver);

-- 
Regards,

Laurent Pinchart

