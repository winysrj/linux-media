Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41016 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751985AbcLLLtj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 06:49:39 -0500
Date: Mon, 12 Dec 2016 13:49:00 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: mchehab@kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, geert+renesas@glider.be,
        akpm@linux-foundation.org, linux@roeck-us.net, hverkuil@xs4all.nl,
        dheitmueller@kernellabs.com, slongerbeam@gmail.com,
        lars@metafoo.de, robert.jarzmik@free.fr, pavel@ucw.cz,
        pali.rohar@gmail.com, sakari.ailus@linux.intel.com,
        mark.rutland@arm.com, CARLOS.PALMINHA@synopsys.com
Subject: Re: [PATCH v5 1/2] Add OV5647 device tree documentation
Message-ID: <20161212114900.GS16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc5229b9-0705-4189-39d5-7c3e0a96c008@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro,

On Mon, Dec 12, 2016 at 11:39:31AM +0000, Ramiro Oliveira wrote:
> Hi Sakari,
> 
> Thank you for the feedback.
> 
> On 12/7/2016 10:33 PM, Sakari Ailus wrote:
> > Hi Ramiro,
> > 
> > Thank you for the patch.
> > 
> > On Mon, Dec 05, 2016 at 05:36:33PM +0000, Ramiro Oliveira wrote:
> >> Add device tree documentation.
> >>
> >> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
> >> ---
> >>  .../devicetree/bindings/media/i2c/ov5647.txt          | 19 +++++++++++++++++++
> >>  1 file changed, 19 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5647.txt b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
> >> new file mode 100644
> >> index 0000000..4c91b3b
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
> >> @@ -0,0 +1,19 @@
> >> +Omnivision OV5647 raw image sensor
> >> +---------------------------------
> >> +
> >> +OV5647 is a raw image sensor with MIPI CSI-2 and CCP2 image data interfaces
> >> +and CCI (I2C compatible) control bus.
> >> +
> >> +Required properties:
> >> +
> >> +- compatible	: "ovti,ov5647";
> >> +- reg		: I2C slave address of the sensor;
> >> +
> >> +The common video interfaces bindings (see video-interfaces.txt) should be
> >> +used to specify link to the image data receiver. The OV5647 device
> >> +node should contain one 'port' child node with an 'endpoint' subnode.
> >> +
> >> +Following properties are valid for the endpoint node:
> >> +
> >> +- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
> >> +  video-interfaces.txt.  The sensor supports only two data lanes.
> > 
> > Doesn't this sensor require a external clock, a reset GPIO and / or a
> > regulator or a few? Do you need data-lanes, unless you can change the order
> > or the number?
> 
> In the setup I'm using, I'm not aware of any reset GPIO or regulator. I do use a
> external clock but it's fixed and not controlled by SW. Should I add a property
> for this?

The sensor datasheet defines a power-up and power-down sequence for the
device. If you don't implement these sequences in the driver on a DT based
system, nothing suggests that they're implemented correctly. Could it be
that the boot loader simply enables the regulators or another device
requires them to be enabled?

I presume at least the reset GPIO should be controlled explicitly in order
to ensure correct function. Although hardware can be surprising: I have one
production system that has no reset GPIO for the sensor albeit the sensor
datasheet says that's part of the power up sequence.

> 
> > 
> > An example DT snippet wouldn't hurt.
> 
> Sure, I can add a example snippet.
> 
> > 
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
