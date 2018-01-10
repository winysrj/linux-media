Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54349 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752983AbeAJJdS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 04:33:18 -0500
Date: Wed, 10 Jan 2018 10:33:12 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
Subject: Re: [PATCH v5 1/4] dt-bindings: media: Add bindings for OV5695
Message-ID: <20180110093312.GE25666@w540>
References: <1515549967-5302-1-git-send-email-zhengsq@rock-chips.com>
 <1515549967-5302-2-git-send-email-zhengsq@rock-chips.com>
 <20180110092010.GC6834@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20180110092010.GC6834@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 10, 2018 at 10:20:10AM +0100, jacopo mondi wrote:
> Hi Shunqian,
>
> On Wed, Jan 10, 2018 at 10:06:04AM +0800, Shunqian Zheng wrote:
> > Add device tree binding documentation for the OV5695 sensor.
> >
> > Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> > ---
> >  .../devicetree/bindings/media/i2c/ov5695.txt       | 41 ++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5695.txt
> >
> > diff --git a/Documentation/devicetree/bindings/media/i2c/ov5695.txt b/Documentation/devicetree/bindings/media/i2c/ov5695.txt
> > new file mode 100644
> > index 0000000..2f2f698
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/ov5695.txt
> > @@ -0,0 +1,41 @@
> > +* Omnivision OV5695 MIPI CSI-2 sensor
> > +
> > +Required Properties:
> > +- compatible: shall be "ovti,ov5695"
> > +- clocks: reference to the xvclk input clock
> > +- clock-names: shall be "xvclk"
> > +- avdd-supply: Analog voltage supply, 2.8 volts
> > +- dovdd-supply: Digital I/O voltage supply, 1.8 volts
> > +- dvdd-supply: Digital core voltage supply, 1.2 volts
> > +- reset-gpios: Low active reset gpio
> > +
> > +The device node shall contain one 'port' child node with an
> > +'endpoint' subnode for its digital output video port,
> > +in accordance with the video interface bindings defined in
> > +Documentation/devicetree/bindings/media/video-interfaces.txt.
> > +The endpoint optional property 'data-lanes' shall be "<1 2>".
>
> What happens if the property is not present? What's the default?
>
> I would:
>
> Required Properties:
> - compatible: ..
> ....
>
> Option Endpoint Properties:

Optional, not Option, sorry about this
