Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41380 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab2LQP3p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 10:29:45 -0500
Message-ID: <50CF3A4B.8030206@ti.com>
Date: Mon, 17 Dec 2012 17:29:15 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linux-media@vger.kernel.org>, Archit Taneja <archit@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Inki Dae <inki.dae@samsung.com>,
	Jesse Barker <jesse.barker@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Tom Gall <tom.gall@linaro.org>,
	Vikas Sajjan <vikas.sajjan@linaro.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <50AF8D79.1070309@ti.com> <1608840.IleINgrx5J@avalon>
In-Reply-To: <1608840.IleINgrx5J@avalon>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigBD476092AD842E19B0435E94"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigBD476092AD842E19B0435E94
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-12-17 16:36, Laurent Pinchart wrote:
> Hi Tomi,
>=20
> I finally have time to work on a v3 :-)
>=20
> On Friday 23 November 2012 16:51:37 Tomi Valkeinen wrote:
>> On 2012-11-22 23:45, Laurent Pinchart wrote:
>>> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>>>
>>> Hi everybody,
>>>
>>> Here's the second RFC of what was previously known as the Generic Pan=
el
>>> Framework.
>>
>> Nice work! Thanks for working on this.
>>
>> I was doing some testing with the code, seeing how to use it in omapds=
s.
>> Here are some thoughts:
>>
>> In your model the DSS gets the panel devices connected to it from
>> platform data. After the DSS and the panel drivers are loaded, DSS get=
s
>> a notification and connects DSS and the panel.
>>
>> I think it's a bit limited way. First of all, it'll make the DT data a=

>> bit more complex (although this is not a major problem). With your
>> model, you'll need something like:
>>
>> soc-base.dtsi:
>>
>> dss {
>> 	dpi0: dpi {
>> 	};
>> };
>>
>> board.dts:
>>
>> &dpi0 {
>> 	panel =3D &dpi-panel;
>> };
>>
>> / {
>> 	dpi-panel: dpi-panel {
>> 		...panel data...;
>> 	};
>> };
>>
>> Second, it'll prevent hotplug, and even if real hotplug would not be
>> supported, it'll prevent cases where the connected panel must be found=

>> dynamically (like reading ID from eeprom).
>=20
> Hotplug definitely needs to be supported, as the common display framewo=
rk also=20
> targets HDMI and DP. The notification mechanism was actually designed t=
o=20
> support hotplug.

HDMI or DP hotplug may or may not be a different thing than what I talk
about here. We may have two kinds of hotplug: real linux device hotplug,
i.e. a linux device appears or is removed during runtime, or just a
cable hotplug, handled inside a driver, which doesn't have any effect on
the linux devices.

If we do implement HDMI and DP monitors with real linux drivers, then
yes, we could use real hotplug. But we could as well have the monitor
driver always registered, and just have a driver internal cable-hotplug
system.

To be honest, I'm not sure if implementing real hotplug is easily
possible, as we don't have real, probable (probe-able =3D) busses. So eve=
n
if we'd get a hotplug event of a new display device, what kind of device
would the bus master register? It has no way to know that.

> How do you see the proposal preventing hotplug ?

Well, probably it doesn't prevent. But it doesn't feel right to me.

Say, if we have a DPI panel, controlled via foo-bus, which has a probing
mechanism. When the foo-bus master detects a new hardware device, it'll
create linux device for it. The driver for this device will then be
probed. In the probe function it should somehow register itself to the
cdf, or perhaps the previous entity in the chain.

This sounds to me that the link is from the panel to the previous
entity, not the other way around as you describe, and also the previous
entity doesn't know of the panel entities.

>> Third, it kinda creates a cyclical dependency: the DSS needs to know
>> about the panel and calls ops in the panel, and the panel calls ops in=

>> the DSS. I'm not sure if this is an actual problem, but I usually find=

>> it simpler if calls are done only in one direction.
>=20
> I don't see any way around that. The panel is not a standalone entity t=
hat can=20
> only receive calls (as it needs to control video streams, per your requ=
est=20
> :-)) or only emit calls (as something needs to control it, userspace do=
esn't=20
> control the panel directly).

Right, but as I see it, the destination of the panel's calls, and the
source of the calls to panel are different things. The destination is
the bus layer, dealing with the video signal being transferred. The
source is a bit higher level thing, something that's controlling the
display in general.

>> Here we wouldn't have similar display_entity as you have, but video so=
urces
>> and displays. Video sources are elements in the video pipeline, and a =
video
>> source is used only by the next downstream element. The last element i=
n the
>> pipeline would not be a video source, but a display, which would be us=
ed by
>> the upper layer.
>=20
> I don't think we should handle pure sources, pure sinks (displays) and =
mixed=20
> entities (transceivers) differently. I prefer having abstract entities =
that=20
> can have a source and a sink, and expose the corresponding operations. =
That=20
> would make pipeline handling much easier, as the code will only need to=
 deal=20
> with a single type of object. Implementing support for entities with mu=
ltiple=20
> sinks and/or sources would also be possible.

Ok. I think having pure sources is simpler model, but it's true that if
we need to iterate and study the pipeline during runtime, it's probably
better to have single entities with multiple sources/sinks.

>> Video source's ops would deal with things related to the video bus in
>> question, like configuring data lanes, sending DSI packets, etc. The
>> display ops would be more high level things, like enable, update, etc.=

>> Actually, I guess you could consider the display to represent and deal=

>> with the whole pipeline, while video source deals with the bus between=

>> two display entities.
>=20
> What is missing in your proposal is an explanation of how the panel is =

> controlled. What does your register_display() function register the dis=
play=20
> with, and what then calls the display operations ?

In my particular case, the omapfb calls the display operations, which is
the higher level "manager" for the whole display. So omapfb does calls
both to the DSS side and to the panel side of the pipeline.

I agree that making calls to both ends is a bit silly, but then again, I
think it also happens in your model, it's just hidden there.

 Tomi



--------------enigBD476092AD842E19B0435E94
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQzzpLAAoJEPo9qoy8lh71insP/AuJDJUbn5Qxl0k99pqKTTts
+iGUb/ldCnUhb4MEakickx6cw0dPEXVGJ0y/7tC/fxl5CJy3aGXFUYd0JU3l9NHC
cNNOfYqJve9Pv90UXO0j6l0z952WJazxa2p3sYtXNTWWNmEVz7QCJhvMHizxeZ56
viVAhGnuBBtvTI4DMYnG2h2pK5suoDLDOV8l135B1EcU4xj5XXZWS8fBq5xHc/Br
o7E/iHarYizgQ1U5zzOmHMeUdhPywFfFh1hmGMy2EamxVfn68QII00jbZSxDkTJo
mslb/ZkkYVPEd2qrAuwJD8TZnpSXNeBk42hiqAK9MX6ML9lVXG9EE1e6WXkYcqRT
v/AVRNr6h0/CxN8buoxIDiwK40zrY21I1xW16HKiJ6t5gG3Bse6qyPhOyf6D+GaU
5dKEDbLZKJIqBL/uDC5smQqhkvAlVDdEgqEHStUgIp8OtGVvbOAlbFz7ZyepFrsr
3girAb95MrYYLbX6zXAtLQT+eNEEF4jsQj9FiliqN2BaUNiCAnlPF+kdC0vztkpC
9Rd/F468uRQaBPM+CYkbR+noyij6dS7SN894XOqcnyr/MxW9eeIUWW002hEbLUeZ
uYvn1lJlffEjKBSizRhSh4fWmi7wA5f+qMlbi0uPNMlIdW+17gp09rjo/VXyQm3d
M+EJPnAyVeFoZRm8yQYc
=ORoA
-----END PGP SIGNATURE-----

--------------enigBD476092AD842E19B0435E94--
