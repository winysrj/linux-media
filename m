Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55544 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752105AbdHPU5J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 16:57:09 -0400
Date: Wed, 16 Aug 2017 23:57:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] dt: bindings: Document DT bindings for Analog
 devices as3645a
Message-ID: <20170816205706.rcg3lz6hg2wgjphw@valkosipuli.retiisi.org.uk>
References: <20170816125440.27534-1-sakari.ailus@linux.intel.com>
 <20170816125514.27634-1-sakari.ailus@linux.intel.com>
 <8b966328-138a-5777-f8b5-692e692567e8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b966328-138a-5777-f8b5-692e692567e8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

Thanks for the review.

On Wed, Aug 16, 2017 at 10:27:27PM +0200, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> Thanks for the patch. One issue below.
> 
> On 08/16/2017 02:55 PM, Sakari Ailus wrote:
> > From: Sakari Ailus <sakari.ailus@iki.fi>
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  .../devicetree/bindings/leds/ams,as3645a.txt       | 56 ++++++++++++++++++++++
> >  1 file changed, 56 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/leds/ams,as3645a.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/leds/ams,as3645a.txt b/Documentation/devicetree/bindings/leds/ams,as3645a.txt
> > new file mode 100644
> > index 000000000000..00066e3f9036
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/leds/ams,as3645a.txt
> > @@ -0,0 +1,56 @@
> > +Analog devices AS3645A device tree bindings
> > +
> > +The AS3645A flash LED controller can drive two LEDs, one high current
> > +flash LED and one indicator LED. The high current flash LED can be
> > +used in torch mode as well.
> > +
> > +Ranges below noted as [a, b] are closed ranges between a and b, i.e. a
> > +and b are included in the range.
> > +
> > +
> > +Required properties
> > +===================
> > +
> > +compatible	: Must be "ams,as3645a".
> > +reg		: The I2C address of the device. Typically 0x30.
> > +
> > +
> > +Required properties of the "flash" child node
> > +=============================================
> > +
> > +flash-timeout-us: Flash timeout in microseconds. The value must be in
> > +		  the range [100000, 850000] and divisible by 50000.
> > +flash-max-microamp: Maximum flash current in microamperes. Has to be
> > +		    in the range between [200000, 500000] and
> > +		    divisible by 20000.
> > +led-max-microamp: Maximum torch (assist) current in microamperes. The
> > +		  value must be in the range between [20000, 160000] and
> > +		  divisible by 20000.
> > +ams,input-max-microamp: Maximum flash controller input current. The
> > +			value must be in the range [1250000, 2000000]
> > +			and divisible by 50000.
> > +
> > +
> > +Required properties of the "indicator" child node
> > +=================================================
> > +
> > +led-max-microamp: Maximum indicator current. The allowed values are
> > +		  2500, 5000, 7500 and 10000.
> 
> Most LED bindings mention also optional label property in the form:
> 
> - label : See Documentation/devicetree/bindings/leds/common.txt
> 
> > +
> > +Example
> > +=======
> > +
> > +	as3645a: flash@30 {
> > +		reg = <0x30>;
> > +		compatible = "ams,as3645a";
> > +		flash {
> 
> 			label = "as3645a:flash";
> 
> > +			flash-timeout-us = <150000>;
> > +			flash-max-microamp = <320000>;
> > +			led-max-microamp = <60000>;
> > +			ams,input-max-microamp = <1750000>;
> > +		};
> > +		indicator {
> 
> 			label = "as3645a:indicator";
> 
> > +			led-max-microamp = <10000>;
> > +		};
> > +	};
> > 

I'll make the above fixes for v2 (and add flash child node label property).

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
