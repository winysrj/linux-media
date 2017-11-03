Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38416 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756057AbdKCLoC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Nov 2017 07:44:02 -0400
Date: Fri, 3 Nov 2017 13:43:58 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Rob Herring <robh@kernel.org>
Cc: Wenyou Yang <wenyou.yang@microchip.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        devicetree@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] media: ov7740: Document device tree bindings
Message-ID: <20171103114358.a2guahtnqyka7t7b@valkosipuli.retiisi.org.uk>
References: <20171031011146.6899-1-wenyou.yang@microchip.com>
 <20171031011146.6899-3-wenyou.yang@microchip.com>
 <20171101215157.5hemcpuplikvtpqx@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171101215157.5hemcpuplikvtpqx@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On Wed, Nov 01, 2017 at 04:51:57PM -0500, Rob Herring wrote:
> On Tue, Oct 31, 2017 at 09:11:44AM +0800, Wenyou Yang wrote:
> > Add the device tree binding documentation for the ov7740 sensor driver.
> > 
> > Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
> > ---
> > 
> > Changes in v4: None
> > Changes in v3:
> >  - Explicitly document the "remote-endpoint" property.
> > 
> > Changes in v2: None
> > 
> >  .../devicetree/bindings/media/i2c/ov7740.txt       | 47 ++++++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7740.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/media/i2c/ov7740.txt b/Documentation/devicetree/bindings/media/i2c/ov7740.txt
> > new file mode 100644
> > index 000000000000..af781c3a5f0e
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/ov7740.txt
> > @@ -0,0 +1,47 @@
> > +* Omnivision OV7740 CMOS image sensor
> > +
> > +The Omnivision OV7740 image sensor supports multiple output image
> > +size, such as VGA, and QVGA, CIF and any size smaller. It also
> > +supports the RAW RGB and YUV output formats.
> > +
> > +The common video interfaces bindings (see video-interfaces.txt) should
> > +be used to specify link to the image data receiver. The OV7740 device
> > +node should contain one 'port' child node with an 'endpoint' subnode.
> > +
> > +Required Properties:
> > +- compatible:	"ovti,ov7740".
> > +- reg:		I2C slave address of the sensor.
> > +- clocks:	Reference to the xvclk input clock.
> > +- clock-names:	"xvclk".
> > +
> > +Optional Properties:
> > +- reset-gpios: Rreference to the GPIO connected to the reset_b pin,
> > +  if any. Active low with pull-ip resistor.
> > +- powerdown-gpios: Reference to the GPIO connected to the pwdn pin,
> > +  if any. Active high with pull-down resistor.
> > +
> > +Endpoint node mandatory properties:
> > +- remote-endpoint: A phandle to the bus receiver's endpoint node.
> 
> This is not really necessary. What's required is documenting how many 
> ports and how many endpoints for each port which you have above.

I actually requested adding that as the practice, as far as I've understood
it, has been to document all properties relevant for the hardware (apart
from things such as assigned-clocks etc.).

The port and endpoints have been elaborated above and I think that should
be fine as-is.

The graph bindings document (referred by video-interfaces.txt) the
remote-endpoint property in an endpoint as an optional property, however
you can't really use the sensor if it's not connected to anything. The same
goes for video-interfaces.txt: remote-endpoint in an endpoint is optional.

I have no objections removing remote-endpoint here, though, if you think
it's not relevant here.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
