Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42944 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbeJCNK6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2018 09:10:58 -0400
MIME-Version: 1.0
References: <20181002140515.16299-1-ricardo.ribalda@gmail.com> <4555006.y1GbRfQLCO@avalon>
In-Reply-To: <4555006.y1GbRfQLCO@avalon>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 3 Oct 2018 08:23:43 +0200
Message-ID: <CAPybu_02_hMAVWO2r1-t+S60HPaqEtnQzgF-Moxg7Zx+-PGj6A@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] [media] imx214: device tree binding
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>, jacopo@jmondi.org,
        phdm@macq.eu, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent
On Tue, Oct 2, 2018 at 10:06 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Ricardo,
>
> Thank you for the patch.
>
> On Tuesday, 2 October 2018 17:05:15 EEST Ricardo Ribalda Delgado wrote:
> > Document bindings for imx214 camera sensor
> >
> > Cc: devicetree@vger.kernel.org
> > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> > ---
> > Changelog from v3:
> >
> > Sakari Ailus:
> > -s/should/shall/
> > -remove clock-lanes
> >
> > Philippe De Muyter:
> > -s/imx274/imx214/
> >
> > Laurent Pinchart:
> > -s/to to/to/
> > -Better description of lanes
> > -clock-names: Shall be "xclk"
> > -Drop clock-freq
> >
> >  .../devicetree/bindings/media/i2c/imx214.txt  | 53 +++++++++++++++++++
> >  1 file changed, 53 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/i2c/imx214.txt
> >
> > diff --git a/Documentation/devicetree/bindings/media/i2c/imx214.txt
> > b/Documentation/devicetree/bindings/media/i2c/imx214.txt new file mode
> > 100644
> > index 000000000000..421a019ab7f9
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/imx214.txt
> > @@ -0,0 +1,53 @@
> > +* Sony 1/3.06-Inch 13.13Mp CMOS Digital Image Sensor
> > +
> > +The Sony imx214 is a 1/3.06-inch CMOS active pixel digital image sensor
> > with +an active array size of 4224H x 3200V. It is programmable through an
> > I2C +interface. The I2C address can be configured to 0x1a or 0x10,
> > depending on +how the hardware is wired.
> > +Image data is sent through MIPI CSI-2, through 2 or 4 lanes at a maximum
> > +throughput of 1.2Gbps/lane.
> > +
> > +
> > +Required Properties:
> > +- compatible: value should be "sony,imx214" for imx214 sensor
> > +- reg: I2C bus address of the device
> > +- enable-gpios: GPIO descriptor for the enable pin.
> > +- vdddo-supply: Chip digital IO regulator (1.8V).
> > +- vdda-supply: Chip analog regulator (2.7V).
> > +- vddd-supply: Chip digital core regulator (1.12V).
> > +- clocks: Reference to the xclk clock.
> > +- clock-names:  Shall be "xclk".
> > +
> > +Optional Properties:
> > +- flash-leds: See ../video-interfaces.txt
> > +- lens-focus: See ../video-interfaces.txt
> > +
> > +The imx214 device node shall contain one 'port' child node with
> > +an 'endpoint' subnode. For further reading on port node refer to
> > +Documentation/devicetree/bindings/media/video-interfaces.txt.
> > +
> > +Required Properties on endpoint:
> > +- data-lanes: check ../video-interfaces.txt
>
> As I suppose you got access to the datasheet which doesn't appear to be
> public, I'll take this as an opportunity to fish for information :-) Does the
> sensor support remapping data lanes ? Could you please document that here ?
>
> You should also state that only the 2 lanes and 4 lanes options are valid, and
> what lanes can be used in those cases. I assume that would be <1 2> and <1 2 3
> 4>, but if other options are possible, it would be useful to document that.

I wish I had. This is the best documentation that I got access to,
after a lot of googling:
http://www.ahdsensor.com/downloadRepository/3acdda8d-b531-4a76-a27d-9dd09be980ee.pdf

I never understood this secrecy around datasheets. How the f*&& are we
going to buy chips and make desings around them if we cannot get
information?! Sorry that was my daily vent

The 2 and 4 lane option was obtained from the functional description
of the chip (page 1). The obvious order would be <1 2>, but I have
also seen <1 3> in other chips, so I rather not mention it on the
devicetree doc.

Thanks a lot for your review :)

>
> With this updated,
>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> > +- link-frequencies: check ../video-interfaces.txt
> > +- remote-endpoint: check ../video-interfaces.txt
> > +
> > +Example:
> > +
> > +     camera_rear@1a {
> > +             compatible = "sony,imx214";
> > +             reg = <0x1a>;
> > +             vdddo-supply = <&pm8994_lvs1>;
> > +             vddd-supply = <&camera_vddd_1v12>;
> > +             vdda-supply = <&pm8994_l17>;
> > +             lens-focus = <&ad5820>;
> > +             enable-gpios = <&msmgpio 25 GPIO_ACTIVE_HIGH>;
> > +             clocks = <&mmcc CAMSS_MCLK0_CLK>;
> > +             clock-names = "xclk";
> > +             port {
> > +                     imx214_ep: endpoint {
> > +                             data-lanes = <1 2 3 4>;
> > +                             link-frequencies = /bits/ 64 <480000000>;
> > +                             remote-endpoint = <&csiphy0_ep>;
> > +                     };
> > +             };
> > +     };
>
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>


-- 
Ricardo Ribalda
