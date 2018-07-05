Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754048AbeGEULl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 16:11:41 -0400
MIME-Version: 1.0
References: <20180703140803.19580-1-rui.silva@linaro.org> <20180703140803.19580-2-rui.silva@linaro.org>
 <20180704085801.GB4463@w540> <m3a7r7robk.fsf@linaro.org>
In-Reply-To: <m3a7r7robk.fsf@linaro.org>
From: Rob Herring <robh@kernel.org>
Date: Thu, 5 Jul 2018 14:11:28 -0600
Message-ID: <CAL_JsqLEO6DBpSes30Wk++2MOyypDt_N=yU_H00GyQzJMY-A3g@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] media: ov2680: dt: Add bindings for OV2680
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: jmondi <jacopo@jmondi.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 4, 2018 at 9:52 AM Rui Miguel Silva <rui.silva@linaro.org> wrote:
>
> Hi Jacopo,
> Hope your fine.
> Thanks for the review.
>
> On Wed 04 Jul 2018 at 09:58, jacopo mondi wrote:
> > Hi Rui,
> >    sorry, I'm a bit late, you're already at v7 and I don't want
> >    to
> > slow down inclusion with a few minor comments.
> >
> > Please bear with me and see below...
> >
> > On Tue, Jul 03, 2018 at 03:08:02PM +0100, Rui Miguel Silva
> > wrote:
> >> Add device tree binding documentation for the OV2680 camera
> >> sensor.
> >>
> >> CC: devicetree@vger.kernel.org
> >> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> >> ---
> >>  .../devicetree/bindings/media/i2c/ov2680.txt  | 46
> >>  +++++++++++++++++++
> >>  1 file changed, 46 insertions(+)
> >>  create mode 100644
> >>  Documentation/devicetree/bindings/media/i2c/ov2680.txt
> >>
> >> diff --git
> >> a/Documentation/devicetree/bindings/media/i2c/ov2680.txt
> >> b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
> >> new file mode 100644
> >> index 000000000000..11e925ed9dad
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
> >> @@ -0,0 +1,46 @@
> >> +* Omnivision OV2680 MIPI CSI-2 sensor
> >> +
> >> +Required Properties:
> >> +- compatible: should be "ovti,ov2680".
> >> +- clocks: reference to the xvclk input clock.
> >> +- clock-names: should be "xvclk".
> >
> > Having a single clock source I think you can omit 'clock-names'
> > (or at
> > least not marking it as required)
>
> yeah, I see you point, but really all other OV sensors share this
> and
> the bellow clock/data-lanes properties as required, I will let Rob
> or
> Sakari take a call in this one.

I generally tell folks that *-names is not needed when there's only 1,
but having alignment across bindings is good too.

Rob
