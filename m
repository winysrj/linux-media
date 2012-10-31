Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:34825 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935631Ab2JaOVH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 10:21:07 -0400
Message-ID: <509133BA.3020308@ti.com>
Date: Wed, 31 Oct 2012 16:20:42 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Richard Purdie <rpurdie@rpsys.net>, <linux-fbdev@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>, <linux-leds@vger.kernel.org>,
	<linux-media@vger.kernel.org>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [RFC 0/5] Generic panel framework
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com> <1348055129.2565.54.camel@deskari> <3150258.gEx8mFWcM9@avalon>
In-Reply-To: <3150258.gEx8mFWcM9@avalon>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig82F2B08D47BA017BD4514B04"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enig82F2B08D47BA017BD4514B04
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-10-31 15:13, Laurent Pinchart wrote:

>> OMAP SoC
>> =3D=3D=3D=3D=3D=3D=3D=3D
>>
>> So here's first the SoC specific display nodes. OMAP has a DSS (displa=
y
>> subsystem) block, which contains the following elements:
>>
>> - DISPC (display controller) reads the pixels from memory and outputs
>> them using specified video timings. DISPC has three outputs, LCD0, LCD=
1
>> and TV. These are SoC internal outputs, they do not go outside the SoC=
=2E
>>
>> - DPI gets its data from DISPC's LCD0, and outputs MIPI DPI (parallel
>> RBG)
>>
>> - Two independent DSI modules, which get their data from LCD0 or LCD1,=

>> and output MIPI DSI (a serial two-way video bus)
>>
>> - HDMI, gets data from DISPC's TV output and outputs HDMI
>>
>> / {
>> 	ocp {
>> 		dss {
>> 			dispc {
>> 				dss-lcd0: output@0 {
>> 				};
>>
>> 				dss-lcd1: output@1 {
>> 				};
>>
>> 				dss-tv: output@2 {
>> 				};
>> 			};
>>
>> 			dpi: dpi {
>> 				video-source =3D <&dss-lcd0>;
>> 			};
>>
>> 			dsi0: dsi@0 {
>> 				video-source =3D <&dss-lcd0>;
>> 			};
>>
>> 			dsi1: dsi@1 {
>> 				video-source =3D <&dss-lcd1>;
>> 			};
>>
>> 			hdmi: hdmi {
>> 				video-source =3D <&dss-tv>;
>> 			};
>> 		};
>> 	};
>> };
>>
>> I have defined all the relevant nodes, and video-source property is us=
ed
>> to point to the source for video data. I also define aliases for the S=
oC
>> outputs so that panels can use them.
>>
>> One thing to note is that the video sources for some of the blocks, li=
ke
>> DSI, are not hardcoded in the HW, so dsi0 could get its data from LCD0=

>> or LCD1.
>=20
> What about the source that are hardwired in hardware ? Shouldn't those =
be=20
> hardcoded in the driver instead ?

Even if both the DSI and the DISPC are parts of OMAP DSS, and part of
the SoC, they are separate IPs. We should look at them the same way we'd
consider chips that are outside the SoC.

So things that are internal to a device can (and I think should) be
hardcoded in the driver, but integration details, the connections
between the IPs, etc, should be described in the DT data.

Then again, we do have (and need) a driver for the "dss" node in the
above DT data. This dss represents dss_core, a "glue" IP that contains
the rest of the DSS blocks and muxes and such. It could be argued that
this dss_core driver does indeed know the integration details, and thus
there's no need to represent them in the DT data.

However, I do think that we should represent the DISPC outputs with
generic display entities inside CPF, just like DSI and the panels. And
we do need to set the connections between these entities. So the
question is, do we get those connections from the DT data, or are they
hardcoded in the dss_core driver.

I don't currently have strong opinions on either direction. Both make
sense to me. But I think this is SoC driver implementation specific, and
the common panel framework doesn't need to force this to either
direction. Both should be possible from CPF's point of view.

>> However, I don't think they are usually changed during runtime, and th=
e dss
>> driver cannot change them independently for sure (meaning that some up=
per
>> layer should tell it how to change the config). Thus I specify sane de=
faults
>> here, but the board dts files can of course override the video sources=
=2E
>=20
> I'm not sure whether default settings like those really belong to the D=
T. I'm=20
> no expert on that topic though.

I agree. But I also don't have a good solution how the driver would find
good choices for these settings...

>> Another thing to note is that we have more outputs from OMAP than we h=
ave
>> outputs from DISPC. This means that the same video source is used by
>> multiple sinks (LCD0 used by DPI and DSI0). DPI and DSI0 cannot be use=
d at
>> the same time, obviously.
>=20
> It might not be really obvious, as I don't see what prevents DPI and DS=
I0 to=20
> be used at the same time :-) Do they share physical pins ?

I think they do, but even if they didn't, there's just one source for
two outputs. So if the SoC design is such that the only video source for
DPI is LCD0, and the only video source for DSI0 is LCD0, and presuming
you can't send the video data to both destinations, then only one of DPI
and DSI0 can be enabled at the same time.

Even if the LCD0 could send the pixel stream to both DPI and DSI0, it'd
be "interesting", because the original video timings and pixel clock are
programmed in the LCD0 output, and thus both DPI and DSI0 get the same
timings. If DPI would want to use some other mode, DSI would most likely
go nuts.

So my opinion is that we should only allow 1:1 connections between
sources and sinks. If a component has multiple outputs, and even if
those outputs give the exact same data, it should define multiple sources=
=2E

>> And third thing to note, DISPC node defines outputs explicitly, as it =
has
>> multiple outputs, whereas the external outputs do not as they have onl=
y one
>> output. Thus the node's output is implicitly the node itself. So, inst=
ead of
>> having:
>>
>> ds0: dsi@0 {
>> 	video-source =3D <&dss-lcd0>;
>> 	dsi0-out0: output@0 {
>> 	};
>> };
>>
>> I have:
>>
>> dsi0: dsi@0 {
>> 	video-source =3D <&dss-lcd0>;
>> };
>=20
> What about defining the data sinks instead of the data sources ? I find=
 it=20
> more logical for the DSS to get the panel it's connected to than the ot=
her way=20
> around.

Good question. We look at this from different angles. Is the DSS
connected to the panel, or is the panel connected to the DSS? ;)

I see this the same way than, say, regulators. We have a device and a
driver for it, and the driver wants to use a hw resource. If the
resource is a regulator, the DT data for the device will contain a
reference to the regulator. The driver will then get the regulator, and
use it to operate the device.

Similarly for the display devices. We have a driver for a, say, i2c
device. The DT data for that device will contain a reference to the
source for the video data. The driver for the device will then use this
reference to enable/disable/etc the video stream (i.e. operate the device=
).

The regulators don't even really know anything about the users of the
regulators. Somebody just "gets" a regulator and enables it. The same
should work for display entities also. There's no need for the video
source to know anything about the sink.

So looking at a chain like:

DISPC -> DPI -> Panel

I see the component on the right side using the component on its left.
And thus it makes sense to me to have references from right to left,
i.e. panel has reference to DPI, etc.

Also, it makes sense with DT data files. For example, for omap4 we'll
have omap4.dtsi, which describes common omap4 details. This file would
contain the omap dss nodes. Then we have omap4-panda.dts, which includes
omap4.dtsi. omap4-panda.dts contains data for the displays on this
board. Thus we have something like:

omap4.dtsi:

dss {
	dsi0: dsi@0 {
		...
	};
};

omap4-panda.dts:

/ {
	panel {
		video-source =3D <&dsi0>;
	};
};

So it comes out quite nicely. If we had the references the other way
around, omap4-panda.dts would need to have the panel definition, and
also override the dsi0 node from omap4.dtsi, and set the sink to the pane=
l.

I have to say we've had this mind-set with omapdss for a long time, so I
may be a bit blind to other alternative. Do you have any practical
examples how linking the other way around would be better?

>> Of this I'm a bit unsure. I believe in most cases there's only one out=
put,
>> so it'd be nice to have a shorter representation, but I'm not sure if =
it's
>> good to handle the cases for single and multiple outputs differently. =
Or if
>> it's good to mix control and data busses, as, for example, dsi0 can be=
 used
>> as both control and data bus. Having the output defined explicitly wou=
ld
>> separate the control and data bus nodes.
>>
>>
>> Simple DPI panel
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> Here a board has a DPI panel, which is controlled via i2c. Panel nodes=

>> are children of the control bus, so in this case we define the panel
>> under i2c2.
>>
>> &i2c2 {
>> 	dpi-lcd-panel {
>> 		video-source =3D <&dpi>;
>>
>> 	};
>> };
>>
>>
>> HDMI
>> =3D=3D=3D=3D
>>
>> OMAP has a HDMI output, but it cannot be connected directly to an HDMI=

>> cable. TI uses tpd12s015 chip in its board, which provides ESD,
>> level-shifting and whatnot (I'm an SW guy, google for the chip to read=

>> the details =3D). tpd12s015 has a few GPIOs and powers that need to be=

>> controlled, so we need a driver for it.
>>
>> There's no control bus for the tpd12s015, so it's platform device. The=
n
>> there's the device for the HDMI monitor, and the DDC lines are connect=
ed
>> to OMAP's i2c4, thus the hdmi monitor device is a child of i2c.
>>
>> / {
>> 	hdmi-connector: tpd12s015 {
>> 		video-source =3D <&hdmi>;
>> 	};
>> };
>>
>> &i2c4 {
>> 	hdmi-monitor {
>> 		video-source =3D <&hdmi-connector>;
>> 	};
>> };
>=20
> So this implied we would have the following chain ?
>=20
> DISPC (on SoC) -> HDMI (on SoC) -> TPD12S015 (on board) -> HDMI monitor=
 (off=20
> board)=20

Yes.

Although to be honest, I'm not sure if the TPD12S015 should be part of
the chain, or somehow separate. It's so simple, kinda pass-through IP,
that it would be nicer to have the HDMI monitor connected to the OMAP
HDMI. But this is omap specific question, not really CPF thing.

> Should we then have a driver for the HDMI monitor ?

Yes, that is my opinion:

- It would be strange if for some video chains we would have panel
devices in the end of the chain, and for some we wouldn't. I guess we'd
need some trickery to make them both work the same way if there's no
panel devices for some cases.

- While in 99% of the cases we can use a common, simple HDMI monitor
driver, there could be HDMI monitors with special features. We could
detect this monitor by reading the EDID and if it's this special case,
use a specific driver for it instead of the common HDMI driver. This is
perhaps not very likely with HDMI, but I could imagine eDP panels with
special features.

So I imagine that we could use hot-plug here. The HDMI monitor device
would not exist until a HDMI cable is connected. The SoC's HDMI driver
(or whatever is before the HDMI monitor in the chain) gets a hotplug
interrupt, and it would then add the device, which would then trigger
probe of the corresponding HDMI monitor driver.

Actually, thinking about this, what I said in the above paragraph
wouldn't work. The SoC's HDMI driver can't know what kind of device to
create, unless we have a HDMI bus and HDMI devices. Which, I think, we
shouldn't have, as HDMI monitors are usually controlled via i2c, and
thus the HDMI monitors should be i2c devices.

So I don't really know how this hotplug would work =3D). It's just an
idea, not a scenario I have at hand.

 Tomi



--------------enig82F2B08D47BA017BD4514B04
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQkTO6AAoJEPo9qoy8lh71jkoP/i/z2SdOdspllc6dfpA5YJCw
fwrushk7rv2OwVQUxS6RVLU94aufhujeQCN7LxRRhi1TWYIRrbyLCY8q0Zb2/aPG
8QfmoYOroyZ1QylLDv7Aa7BGddOOqiF5jfLOt5+U9PLL4dpBYxoG1myIo7uzushp
D752mLCQS0VfNOu0aoLnX8cjhHenS5ISaRXPcRUYrkJjOOFN80cRk7S2JH6PHs1L
YE/Jc88ysOznHEz0MTpEE498d7I7seEeK9Rs9gefpRZAo5/XTWzerdDkVINm7FCh
uTLWzXdXs7eJg4KGaSfFsJJVyw76Zr3txTs7f8W6/9LnbVUowUewHO1fKlFYp8n7
bz57scIuboX+x4BtjdaWGtxMMeXwfJnB2OBGebPyeMI10hybfOl3ikd9/4ynF4vZ
6C3QarZbR8Yz9Bt4syn2YZdmjTJpRyxS91iqZl2bcnsYWFSHFwWoECAJY+uVvwMR
Af2uPO1MhviwdH97xLoXqaV2j5zjdzxnPgIcUctdSePIxyTWAYlmRq6ZVlbpmSoR
/U65itWoLU7l4lO1xhkkplHlKU3NjOPc0bwNtYNm4YVA7xMQ7+xdPsPu3L4BFMQC
O2FlQCn7B4+udqhwpQQS9Gw23pUPlJigtc275KNHI4mO/O8iXvdrXaxn+hj2g3AI
Rrv7S/+jmJzhHszR8zYq
=zodO
-----END PGP SIGNATURE-----

--------------enig82F2B08D47BA017BD4514B04--
