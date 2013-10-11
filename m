Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41735 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab3JKMay (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Oct 2013 08:30:54 -0400
Message-ID: <5257EF6A.4020005@ti.com>
Date: Fri, 11 Oct 2013 15:30:34 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: <linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	Jesse Barnes <jesse.barnes@intel.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	<linux-media@vger.kernel.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Zhang <markz@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Ragesh Radhakrishnan <Ragesh.R@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Sunil Joshi <joshi@samsung.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Marcus Lorentzon <marcus.lorentzon@huawei.com>
Subject: Re: [PATCH/RFC v3 00/19] Common Display Framework
References: <1376068510-30363-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <52498146.4050600@ti.com> <524C1058.2050500@samsung.com> <524C1E78.6030508@ti.com> <52556370.1050102@samsung.com> <52579CB2.8050601@ti.com> <5257DEB5.6000708@samsung.com>
In-Reply-To: <5257DEB5.6000708@samsung.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="tMAOsjUUUPehpl0OkIBt1PGoaEUBiDIFn"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--tMAOsjUUUPehpl0OkIBt1PGoaEUBiDIFn
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/10/13 14:19, Andrzej Hajda wrote:
> On 10/11/2013 08:37 AM, Tomi Valkeinen wrote:

>> The minimum bta-timeout should be deducable from the DSI bus speed,
>> shouldn't it? Thus there's no need to define it anywhere.
> Hmm, specification says "This specified period shall be longer then
> the maximum possible turnaround delay for the unit to which the
> turnaround request was sent".

Ah, you're right. We can't know how long the peripheral will take
responding. I was thinking of something that only depends on the
bus-speed and the timings for that.

> If I undrestand correctly you think about CDF topology like below:
>=20
> DispContr(SoC) ---> DSI-master(SoC) ---> encoder(DSI or I2C)
>=20
> But I think with mipi-dsi-bus topology could look like:
>=20
> DispContr(SoC) ---> encoder(DSI or I2C)
>=20
> DSI-master will not have its own entity, in the graph it could be
> represented
> by the link(--->), as it really does not process the video, only
> transports it.

At least in OMAP, the SoC's DSI-master receives parallel RGB data from
DISPC, and encodes it to DSI. Isn't that processing? It's basically a
DPI-to-DSI encoder. And it's not a simple pass-through, the DSI video
timings could be considerably different than the DPI timings.

> In case of version A I think everything is clear.
> In case of version B it does not seems so nice at the first sight, but
> still seems quite straightforward to me - special plink in encoder's
> node pointing
> to DSI-master, driver will find the device in runtime and use ops as ne=
eded
> (additional ops/helpers required).
> This is also the way to support devices which can be controlled by DSI
> and I2C
> in the same time. Anyway I suspect such scenario will be quite rare.

Okay, so if I gather it right, you say there would be something like
'dsi_adapter' (like i2c_adapter), which represents the dsi-master. And a
driver could get pointer to this, regardless of whether it the linux
device is a DSI device.

At least one issue with this approach is the endpoint problem (see below)=
=2E

>> And, if we want to separate the video and control, I see no reason to
>> explicitly require the video side to be present. I.e. we could as well=

>> have a DSI peripheral that has only the control bus used. How would th=
at
>> reflect to, say, the DT presentation? Say, if we have a version A of t=
he
>> encoder, we could have DT data like this (just a rough example):
>>
>> soc-dsi {
>> 	encoder {
>> 		input: endpoint {
>> 			remote-endpoint =3D <&soc-dsi-ep>;
> Here I would replace &soc-dsi-ep by phandle to display controller/crtc/=
=2E...
>=20
>> 			/* configuration for the DSI lanes */
>> 			dsi-lanes =3D <0 1 2 3 4 5>;
> Wow, quite advanced DSI.

Wha? That just means there is one clock lane and two datalanes, nothing
more =3D). We can select the polarity of a lane, so we describe both the
positive and negative lines there. So it says clk- is connected to pin
0, clk+ connected to pin 1, etc.

>> 		};
>> 	};
>> };
>>
>> So the encoder would be places inside the SoC's DSI node, similar to h=
ow
>> an i2c device would be placed inside SoC's i2c node. DSI configuration=

>> would be inside the video endpoint data.
>>
>> Version B would be almost the same:
>>
>> &i2c0 {
>> 	encoder {
>> 		input: endpoint {
>> 			remote-endpoint =3D <&soc-dsi-ep>;
> &soc-dsi-ep =3D> &disp-ctrl-ep
>> 			/* configuration for the DSI lanes */
>> 			dsi-lanes =3D <0 1 2 3 4 5>;
>> 		};
>> 	};
>> };
>>
>> Now, how would the video-bus-less device be defined?
>> It'd be inside the
>> soc-dsi node, that's clear. Where would the DSI lane configuration be?=

>> Not inside 'endpoint' node, as that's for video and wouldn't exist in
>> this case. Would we have the same lane configuration in two places, on=
ce
>> for video and once for control?
> I think it is control setting, so it should be put outside endpoint nod=
e.
> Probably it could be placed in encoder node.

Well, one point of the endpoints is also to allow "switching" of video
devices.

For example, I could have a board with a SoC's DSI output, connected to
two DSI panels. There would be some kind of mux between, so that I can
select which of the panels is actually connected to the SoC.

Here the first panel could use 2 datalanes, the second one 4. Thus, the
DSI master would have two endpoints, the other one using 2 and the other
4 datalanes.

If we decide that kind of support is not needed, well, is there even
need for the V4L2 endpoints in the DT data at all?

>> I agree that having DSI/DBI control and video separated would be
>> elegant. But I'd like to hear what is the technical benefit of that? A=
t
>> least to me it's clearly more complex to separate them than to keep th=
em
>> together (to the extent that I don't yet see how it is even possible),=

>> so there must be a good reason for the separation. I don't understand
>> that reason. What is it?
> Roughly speaking it is a question where is the more convenient place to=

> put bunch
> of opses, technically both solutions can be somehow implemented.

Well, it's also about dividing a single physical bus into two separate
interfaces to it. It sounds to me that it would be much more complex
with locking. With a single API, we can just say "the caller handles
locking". With two separate interfaces, there must be locking at the
lower level.

> Pros of mipi bus:
> - no fake entity in CDF, with fake opses, I have to use similar entitie=
s
> in MIPI-CSI
> camera pipelines and it complicates life without any benefit(at least
> from user side),

You mean the DSI-master? I don't see how it's "fake", it's a video
processing unit that has to be configured. Even if we forget the control
side, and just think about plain video stream with DSI video mode,
there's are things to configure with it.

What kind of issues you have in the CSI side, then?

> - CDF models only video buses, control bus is a domain of Linux buses,

Yes, but in this case the buses are the same. It makes me a bit nervous
to have two separate ways (video and control) to use the same bus, in a
case like video where timing is critical.

So yes, we can consider video and control buses as "virtual" buses, and
the actual transport is the DSI bus. Maybe it can be done. It just makes
me a bit nervous =3D).

> - less platform_bus abusing,

Well, platform.txt says

"This pseudo-bus
is used to connect devices on busses with minimal infrastructure,
like those used to integrate peripherals on many system-on-chip
processors, or some "legacy" PC interconnects; as opposed to large
formally specified ones like PCI or USB."

I don't think DSI and DBI as platform bus is that far from the
description. They are "simple", no probing point-to-point (in practice)
buses. There's not much "bus" to speak of, just a point-to-point link.

> - better device tree topology (at least for common cases),

Even if we use platform devices for DSI peripherals, we can have them
described under the DSI master node.

> - quite simple in case of typical devices.

Still more complex than single API for both video and control =3D).

 Tomi



--tMAOsjUUUPehpl0OkIBt1PGoaEUBiDIFn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSV+9qAAoJEPo9qoy8lh71dyYQAILsipTm4acpeElIiDlpVlR8
0OwVV3yMDItT/R0SFKgRZGeyPvM3qgovt+VwwXLH4/+jNhnQmcJqJ8tgHJ7LmwWj
3Bg26+xrKOp5Zq/LmBmm27bl8/NY3hyh5rFqm4Vu10c5BKB7WfjdGdvwISieXtrp
R4sfcw9E1mE6cF7R4uhmpwzs8WgauGnGuw6GRO7H7qpQ5ZuA9miOMaeZGF+mpD5v
KTs46qtPfdtaj9ZcwpaW0ysMsSfn8UP8ZxknM12/MZt5davFCLOb5ek9l3oEaTYi
ryrucwoVkCASZqCt53YTjgmthYsdsgOUdf34EL01/RDAFDAa27Hymlorg23sDsAS
bDLUty6W/tA7ec+h2LFtGrXog0kVOUbj78r4KQbJuSTvER5bSAQZUf1mSfvUBG2L
ZqIxaGwi2S5iQq+awU9RZmyoY7r6/9AQU/xhIfF3eQOVKedcfhOY4KECKVYciXtK
iXWR0eVxzHtwY3nlIQBimV7MamvJWpy8xN6RjvoaFgFeppQ4y0F2e1PDnCUeFGm1
fV0zulApeCyzQHiSmUw7zuzR9alCBo1bz652+E9VlER9h9o87Xzg/fSxA4k2WUYA
ylPdlqIf2EeYomcSdkynD8036+VQApox96eJWbBl76HcdjXPAcVcUaOqHHpWcwxx
wl088fiXlO9NLSNQ53kU
=cRJP
-----END PGP SIGNATURE-----

--tMAOsjUUUPehpl0OkIBt1PGoaEUBiDIFn--
