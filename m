Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:49396 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab3JBNY3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 09:24:29 -0400
Message-ID: <524C1E78.6030508@ti.com>
Date: Wed, 2 Oct 2013 16:24:08 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>
CC: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	<linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
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
References: <1376068510-30363-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <52498146.4050600@ti.com> <524C1058.2050500@samsung.com>
In-Reply-To: <524C1058.2050500@samsung.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="HcKWl3BC7JP9ldlbPvb3JOx09gkQG3PMf"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--HcKWl3BC7JP9ldlbPvb3JOx09gkQG3PMf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Andrzej,

On 02/10/13 15:23, Andrzej Hajda wrote:

>> Using Linux buses for DBI/DSI
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>>
>> I still don't see how it would work. I've covered this multiple times =
in
>> previous posts so I'm not going into more details now.
>>
>> I implemented DSI (just command mode for now) as a video bus but with =
bunch of
>> extra ops for sending the control messages.
>=20
> Could you post the list of ops you have to create.

I'd rather not post the ops I have in my prototype, as it's still a
total hack. However, they are very much based on the current OMAP DSS's
ops, so I'll describe them below. I hope I find time to polish my CDF
hacks more, so that I can publish them.

> I have posted some time ago my implementation of DSI bus:
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/=
69358/focus=3D69362

A note about the DT data on your series, as I've been stuggling to
figure out the DT data for OMAP: some of the DT properties look like
configuration, not hardware description. For example,
"samsung,bta-timeout" doesn't describe hardware.

> I needed three quite generic ops to make it working:
> - set_power(on/off),
> - set_stream(on/off),
> - transfer(dsi_transaction_type, tx_buf, tx_len, rx_buf, rx_len)
> I have recently replaced set_power by PM_RUNTIME callbacks,
> but I had to add .initialize ops.

We have a bit more on omap:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/inclu=
de/video/omapdss.h#n648

Some of those should be removed and some should be omap DSI's internal
matters, not part of the API. But it gives an idea of the ops we use.
Shortly about the ops:

- (dis)connect, which might be similar to your initialize. connect is
meant to "connect" the pipeline, reserving the video ports used, etc.

- enable/disable, enable the DSI bus. If the DSI peripheral requires a
continous DSI clock, it's also started at this point.

- set_config configures the DSI bus (like, command/video mode, etc.).

- configure_pins can be ignored, I think that function is not needed.

- enable_hs and enable_te, used to enable/disable HS mode and
tearing-elimination

- update, which does a single frame transfer

- bus_lock/unlock can be ignored

- enable_video_output starts the video stream, when using DSI video mode

- the request_vc, set_vc_id, release_vc can be ignored

- Bunch of transfer funcs. Perhaps a single func could be used, as you
do. We have sync write funcs, which do a BTA at the end of the write and
wait for reply, and nosync version, which just pushes the packet to the
TX buffers.

- bta_sync, which sends a BTA and waits for the peripheral to reply

- set_max_rx_packet_size, used to configure the max rx packet size.

> Regarding the discussion how and where to implement control bus I have
> though about different alternatives:
> 1. Implement DSI-master as a parent dev which will create DSI-slave
> platform dev in a similar way as for MFD devices (ssbi.c seems to me a
> good example).
> 2. Create universal mipi-display-bus which will cover DSI, DBI and
> possibly other buses - they have have few common things - for example
> MIPI-DCS commands.
>=20
> I am not really convinced to either solution all have some advantages
> and disadvantages.

I think a dedicated DSI bus and your alternatives all have the same
issues with splitting the DSI control into two. I've shared some of my
thoughts here:

http://article.gmane.org/gmane.comp.video.dri.devel/90651
http://article.gmane.org/gmane.comp.video.dri.devel/91269
http://article.gmane.org/gmane.comp.video.dri.devel/91272

I still think that it's best to consider DSI and DBI as a video bus (not
as a separate video bus and a control bus), and provide the packet
transfer methods as part of the video ops.

 Tomi



--HcKWl3BC7JP9ldlbPvb3JOx09gkQG3PMf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSTB54AAoJEPo9qoy8lh71r/EP/3eJ+9ZB888hqyiG5bvceFAG
C0vMm0LNqTKUPSxWjt87jUYaN0nh+SwqjKsVV3YYwjOG8Eh4kdNOrnuB6D0LrwJd
iOXYWq4aeGD7kDTkQNd0RRJkobDbqERGVJ7/27vCBbZPJENacK1dTy4SXoxpbVvV
yFtIXAhpmjxbeiddOrHWd1uBjbNKDwZc1+qXKsfbVyawfdX/ELA0zBYXyolyIB6n
+Ejnt9LB3Uod1yt0NXo7dygHTc2iF9cIaK41h9M9y7QAcJL2zYbzayZy/FyJbN+Z
VmSJTOgTEOMYrF+mbGecMcO5+y6UUkGjjJC0dG1g6cCtgwCCN8phyTk1QOS2Bqqc
If/mWD+HJQ6XOSVVxRzOoKOrSF2U/SmUWTyB5tBxC4h24NpGKnd2CTHGho5WFqe7
BgdhzTS5XQ8cT4D/GszauTqhxoopw7HweqKtBH+H1oR7OySTpXnd8lcVlPTjT7Lc
febVi8jRw/lnsXidD7BUR39z0MzXRou6P3awLkcw7ODBIoSP6agXb59XDG4XruAY
Oc+OE4b2JCd3cdJiVn4otX5Fd8FpyTccnL1X0btobOkb4ARSHBCUVzIqoCcqkCT2
rivn/J/3wCLJJESwwQFIfdBHvPhNT53JDe7LDABys5PFlsXK73doePfq0e/NX+Ez
eSW109c3VYEtAFNX6zzO
=+zvp
-----END PGP SIGNATURE-----

--HcKWl3BC7JP9ldlbPvb3JOx09gkQG3PMf--
