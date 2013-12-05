Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38730 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752985Ab3LEJWa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Dec 2013 04:22:30 -0500
Date: Thu, 5 Dec 2013 09:22:16 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v9] s5k5baf: add camera sensor driver
Message-ID: <20131205092216.GG29200@e106331-lin.cambridge.arm.com>
References: <1383233370-8648-1-git-send-email-a.hajda@samsung.com>
 <529FB817.1030401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529FB817.1030401@gmail.com>
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 04, 2013 at 11:17:43PM +0000, Sylwester Nawrocki wrote:
> On 10/31/2013 04:29 PM, Andrzej Hajda wrote:
> > Driver for Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor
> > with embedded SoC ISP.
> > The driver exposes the sensor as two V4L2 subdevices:
> > - S5K5BAF-CIS - pure CMOS Image Sensor, fixed 1600x1200 format,
> >    no controls.
> > - S5K5BAF-ISP - Image Signal Processor, formats up to 1600x1200,
> >    pre/post ISP cropping, downscaling via selection API, controls.
> >
> > Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> > Signed-off-by: Andrzej Hajda<a.hajda@samsung.com>
> > Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> > ---
> > Hi,
> >
> > This is the 9th iteration of the patch.
> > In this iteration 'binary' blobs from source
> > file have been moved to separate firmware file.
> > Firmware file will be uploaded to appropriate
> > repository.
> [...]
> > v9
> > - patch, ccm and cis configuration blobs moved to
> >    firmware set files,
> > - minor improvements of bindings,
> > - cosmetic changes
>
> Hi Mark,

Hi Sylwester,

>
> What do you think about this DT binding now, could we have your Ack ?

Other than a minor nit below, the binding looks fine to me.

With the fixed, for the binding:

Acked-by: Mark Rutland <mark.rutland@arm.com>

> I think we still need to move the DT binding into a separate patch.

If you're going to post the patch again, then please do split the
binding into a separate patch.

[...]

> > diff --git a/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
> > new file mode 100644
> > index 0000000..23ebe0f
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
> > @@ -0,0 +1,57 @@
> > +Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor with embedded SoC ISP
> > +--------------------------------------------------------------------
> > +
> > +Required properties:
> > +
> > +- compatible   : "samsung,s5k5baf";
> > +- reg                  : I2C slave address of the sensor;
> > +- vdda-supply          : analog power supply 2.8V (2.6V to 3.0V);
> > +- vddreg-supply        : regulator input power supply 1.8V (1.7V to 1.9V)
> > +                 or 2.8V (2.6V to 3.0);
> > +- vddio-supply         : I/O power supply 1.8V (1.65V to 1.95V)
> > +                 or 2.8V (2.5V to 3.1V);
> > +- stbyn-gpios          : GPIO connected to STDBYN pin;
> > +- rstn-gpios   : GPIO connected to RSTN pin;
> > +- clocks       : clock-specifiers (per the common clock bindings) for the
> > +                 clocks described in clock-names;

Clocks are referred to by phandle + clock-specifier pairs rather than
just clock-specifiers, it would be nice to fix up the terminology here.

Thanks,
Mark.
