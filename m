Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:42683 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbeJPDX7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Oct 2018 23:23:59 -0400
Date: Mon, 15 Oct 2018 21:37:14 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: Re: [PATCH v3 1/4] dt-bindings: media: i2c: Add bindings for Maxim
 Integrated MAX9286
Message-ID: <20181015193714.GG21294@w540>
References: <20181009205726.7664-1-kieran.bingham@ideasonboard.com>
 <20181009205726.7664-2-kieran.bingham@ideasonboard.com>
 <20181015164524.kazxgbxwsc3abxok@valkosipuli.retiisi.org.uk>
 <71c30ead-66cd-2c84-3349-0dd393f66300@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HKEL+t8MFpg/ASTE"
Content-Disposition: inline
In-Reply-To: <71c30ead-66cd-2c84-3349-0dd393f66300@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--HKEL+t8MFpg/ASTE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Kieran,

On Mon, Oct 15, 2018 at 06:37:40PM +0100, Kieran Bingham wrote:
> Hi Sakari,
>
> Thank you for the review,
>
> On 15/10/18 17:45, Sakari Ailus wrote:
> > Hi Kieran,
> >
> > Could you cc the devicetree list for the next version, please?
>
> Argh - looks like I've missed the DT list on all three postings.
>
> No wonder the responses have been quiet :-)
>
> I'll do a v4 post after I've gone through some of your comments, and
> make sure I remember the DT guys this time :)
>
>
> > On Tue, Oct 09, 2018 at 09:57:23PM +0100, Kieran Bingham wrote:
> >> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> >>
> >> The MAX9286 deserializes video data received on up to 4 Gigabit
> >> Multimedia Serial Links (GMSL) and outputs them on a CSI-2 port using up
> >> to 4 data lanes.
> >>
> >> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> >> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> >>
> >> ---
> >> v3:
> >>  - Update binding descriptions
> >> ---
> >>  .../bindings/media/i2c/maxim,max9286.txt      | 182 ++++++++++++++++++
> >>  1 file changed, 182 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
> >> new file mode 100644
> >> index 000000000000..a73e3c0dc31b
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
> >> @@ -0,0 +1,182 @@
> >> +Maxim Integrated Quad GMSL Deserializer
> >> +---------------------------------------
> >> +
> >> +The MAX9286 deserializer receives video data on up to 4 Gigabit Multimedia
> >> +Serial Links (GMSL) and outputs them on a CSI-2 port using up to 4 data lanes.
> >
> > CSI-2 D-PHY I presume?
>
> Yes, that's how I've adapted the driver based on the latest bus changes.
>
> Niklas - Could you confirm that everything in VIN/CSI2 is configured to
> use D-PHY and not C-PHY at all ?
>
>
> >> +
> >> +In addition to video data, the GMSL links carry a bidirectional control
> >> +channel that encapsulates I2C messages. The MAX9286 forwards all I2C traffic
> >> +not addressed to itself to the other side of the links, where a GMSL
> >> +serializer will output it on a local I2C bus. In the other direction all I2C
> >> +traffic received over GMSL by the MAX9286 is output on the local I2C bus.
> >> +
> >> +Required Properties:
> >> +
> >> +- compatible: Shall be "maxim,max9286"
> >> +- reg: I2C device address
> >> +
> >> +Optional Properties:
> >> +
> >> +- poc-supply: Regulator providing Power over Coax to the cameras
> >> +- pwdn-gpios: GPIO connected to the #PWDN pin
> >
> > If this is basically a hardware reset pin, then you could call it e.g.
> > enable-gpios or reset-gpios. There was recently a similar discussion
> > related to ad5820 DT bindings.

Techinically is a powerdown control, it shuts the current to the chip,
not reset it.

>
> Ah yes ... now which polarity ;-)

The signal is active low (when is at physical level 0, the chip is
off).

According to the gpio bindings documentation

"The gpio-specifier's polarity flag should represent the physical level at the
GPIO controller that achieves (or represents, for inputs) a logically asserted
value at the device."

Sakari's argument, which I understand and has been debated before, is
to use generic names (ie. don't use the pin name as specified by the HW
manual, but name it after its function. It doesn't matter if your pin
is called "#RST", just call it "reset-gpios' and state the pin name in the
documentation if you like to.)

I count much more 'enable-gpios' compared to 'powerdown-gpios', so
that seems the obvious choice, as generic names have not yet been
documented anywhere as far as I know, but the most common ones should
be used.

Using generic names is good because in the power up/down routines,
you don't have to care about the signals polarities, but only
about their logical levels. At power-up if you have an "enable-gpio"
just set it to logical 1, the gpio framework translates it to the
appropriate physical level. Easier to write and to review.

To comply with GPIO bindings we would have to

        enable-gpios: <&gpio 13 GPIO_ACTIVE_LOW>;

And at power up we would have to use the logical value, and for an
enable signal, setting it to "1" at power up would be the natural choice.
However to have our line set to physical 1 and have the chip powered
we would have to:

        gpiod_set_value(&enable, 0);

Which makes any reason to use generic names vanish.

All of this to say that, even if less popular, I would call it
"powerdown-gpios", which is anyway quite generic, and describe it as:

powerdown-gpios: Power down GPIO signal, pin name "PWDN". Active low.

So that at power_up:
        gpiod_set_value(&pwdn, 0);

And at power down:
        gpiod_set_value(&pwdn, 1);

>
>
> >> +
> >> +Required endpoint nodes:
> >> +-----------------------
> >> +
> >> +The connections to the MAX9286 GMSL and its endpoint nodes are modeled using
> >> +the OF graph bindings in accordance with the video interface bindings defined
> >> +in Documentation/devicetree/bindings/media/video-interfaces.txt.
> >> +
> >> +The following table lists the port number corresponding to each device port.
> >> +
> >> +        Port            Description
> >> +        ----------------------------------------
> >> +        Port 0          GMSL Input 0
> >> +        Port 1          GMSL Input 1
> >> +        Port 2          GMSL Input 2
> >> +        Port 3          GMSL Input 3
> >> +        Port 4          CSI-2 Output
> >> +
> >> +Optional Endpoint Properties for GSML Input Ports (Port [0-3]):

I guess Sakari means s/3/4 here:                                 ^

Or didn't I get his questions and then neither your answer :) ?

Thanks
  j

> >
> > Isn't port 4 included?
>
> Hrm ... yes well I guess these are mandatory for port 4. I'll look at
> the wording here.
>
> >
> >> +
> >> +- remote-endpoint: phandle to the remote GMSL source endpoint subnode in the
> >> +  remote node port.
> >> +
> >> +Required Endpoint Properties for CSI-2 Output Port (Port 4):
> >> +
> >> +- data-lanes: array of physical CSI-2 data lane indexes.
> >> +- clock-lanes: index of CSI-2 clock lane.
> >
> > Is any number of lanes supported? How about lane remapping? If you do not
> > have lane remapping, the clock-lanes property is redundant.
>
>
> Uhm ... Niklas?
>
>
> >
> >> +
> >> +Required i2c-mux nodes:
> >> +----------------------
> >> +
> >> +Each GMSL link is modeled as a child bus of an i2c bus multiplexer/switch, in
> >> +accordance with bindings described in
> >> +Documentation/devicetree/bindings/i2c/i2c-mux.txt. The serializer device on
> >> +the remote end of the GMSL link shall be modelled as a child node of the
> >> +corresponding I2C bus.
> >> +
> >> +Required i2c child bus properties:
> >> +- all properties described as required i2c child bus nodes properties in
> >> +  Documentation/devicetree/bindings/i2c/i2c-mux.txt.
> >> +
> >> +Example:
> >> +-------
> >> +
> >> +	gmsl-deserializer@2c {
> >> +		compatible = "maxim,max9286";
> >> +		reg = <0x2c>;
> >> +		poc-supply = <&camera_poc_12v>;
> >> +		pwdn-gpios = <&gpio 13 GPIO_ACTIVE_LOW>;
> >> +
> >> +		#address-cells = <1>;
> >> +		#size-cells = <0>;
> >> +
> >> +		ports {
> >> +			#address-cells = <1>;
> >> +			#size-cells = <0>;
> >> +
> >> +			port@0 {
> >> +				reg = <0>;
> >> +				max9286_in0: endpoint {
> >> +					remote-endpoint = <&rdacm20_out0>;
> >> +				};
> >> +			};
> >> +
> >> +			port@1 {
> >> +				reg = <1>;
> >> +				max9286_in1: endpoint {
> >> +					remote-endpoint = <&rdacm20_out1>;
> >> +				};
> >> +			};
> >> +
> >> +			port@2 {
> >> +				reg = <2>;
> >> +				max9286_in2: endpoint {
> >> +					remote-endpoint = <&rdacm20_out2>;
> >> +				};
> >> +			};
> >> +
> >> +			port@3 {
> >> +				reg = <3>;
> >> +				max9286_in3: endpoint {
> >> +					remote-endpoint = <&rdacm20_out3>;
> >> +				};
> >> +			};
> >> +
> >> +			port@4 {
> >> +				reg = <4>;
> >> +				max9286_out: endpoint {
> >> +					clock-lanes = <0>;
> >> +					data-lanes = <1 2 3 4>;
> >> +					remote-endpoint = <&csi40_in>;
> >> +				};
> >> +			};
> >> +		};
> >> +
> >> +		i2c@0 {
> >> +			#address-cells = <1>;
> >> +			#size-cells = <0>;
> >> +			reg = <0>;
> >> +
> >> +			camera@51 {
> >> +				compatible = "imi,rdacm20";
> >> +				reg = <0x51 0x61>;
> >
> > What's the second value for in the reg property? There's more of the same
> > below.
> >
>
> These are specific to the RDACM20:
>
> From the RDACM20 documentation:
>
> - reg: Pair of I2C device addresses, the first to be assigned to the
> serializer, the second to be assigned to the camera sensor.
>
> Each RDACM20 camera boots up with the same I2C addresses. The driver
> remaps them to the new values specified here.
>
> But they are not relevant to the max9286 except for the example of
> adding in the rdacm20.
>
>
> >> +
> >> +				port {
> >> +					rdacm20_out0: endpoint {
> >> +						remote-endpoint = <&max9286_in0>;
> >> +					};
> >> +				};
> >> +
> >> +			};
> >> +		};
> >> +
> >> +		i2c@1 {
> >> +			#address-cells = <1>;
> >> +			#size-cells = <0>;
> >> +			reg = <1>;
> >> +
> >> +			camera@52 {
> >> +				compatible = "imi,rdacm20";
> >> +				reg = <0x52 0x62>;
> >> +				port {
> >> +					rdacm20_out1: endpoint {
> >> +						remote-endpoint = <&max9286_in1>;
> >> +					};
> >> +				};
> >> +			};
> >> +		};
> >> +
> >> +		i2c@2 {
> >> +			#address-cells = <1>;
> >> +			#size-cells = <0>;
> >> +			reg = <2>;
> >> +
> >> +			camera@53 {
> >> +				compatible = "imi,rdacm20";
> >> +				reg = <0x53 0x63>;
> >> +				port {
> >> +					rdacm20_out2: endpoint {
> >> +						remote-endpoint = <&max9286_in2>;
> >> +					};
> >> +				};
> >> +			};
> >> +		};
> >> +
> >> +		i2c@3 {
> >> +			#address-cells = <1>;
> >> +			#size-cells = <0>;
> >> +			reg = <3>;
> >> +
> >> +			camera@54 {
> >> +				compatible = "imi,rdacm20";
> >> +				reg = <0x54 0x64>;
> >> +				port {
> >> +					rdacm20_out3: endpoint {
> >> +						remote-endpoint = <&max9286_in3>;
> >> +					};
> >> +				};
> >> +			};
> >> +		};
> >> +	};
> >

--HKEL+t8MFpg/ASTE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbxOxqAAoJEHI0Bo8WoVY8hgAP/As60CFDS1qR2m829TXvd72u
Z8CiUEdw1KruCg/IN4diQAou87GzADmZj9OVRqGcNI4Q4Yra6HjSyBEmvpGLBLXg
RDDRpaca2GPHkKN60I7f81N0xO6u4G433gce8KeygyMF9vGqlaokuv9qfLepfcSS
MSDEws489OtSxTlL31x1ws2JIzIOQpuMau+rxN6w1EqNgTuHTAmz4jHjwyegl+9B
g/D77fPzoIpf6ok+N6+jhlC8OPbWyAImuLKMfojLmObNpyimsy5qePqeX3sFQYOw
fyEy1y5zhfPCD2767cHWWCMb1qAU4m1OwR6Wf7J4G21ajBRxXbsMaHXSyTjcknv/
m9xJvjNatkCO6uH6xPyjgYyhj9POWdMEzY2qefMlSGawSpsAcXf89CbYGtA7LpOZ
RjgQZopcUYwW3jmdbYObKJPm4rMP4E05AXp3tlAwvIypRujSwjCoVE6vwWsmwThO
Kc7OBMkPFuNZV9AsZoSqozj96d4UxZyygr6/gRx5SibfQUE6gio+PX7vGl2l0X6a
SJqZGDBpRWCFdguJpcCgxj3iynnuAmxFj6RZ7s7t4P8EGm5mlpT9pLYAHF0Fxdxu
OzlmvgHuVyGlHrtdIjUB6IQ4eZWezolB+laQeQ/YxK/QbrBrqV2aW2EW83BHrfLK
4A1aQGKEtnLAzbtwy5N4
=erBR
-----END PGP SIGNATURE-----

--HKEL+t8MFpg/ASTE--
