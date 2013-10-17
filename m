Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:48395 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3JQISj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 04:18:39 -0400
Message-ID: <525F9D4D.4000702@ti.com>
Date: Thu, 17 Oct 2013 11:18:21 +0300
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
References: <1376068510-30363-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <52498146.4050600@ti.com> <524C1058.2050500@samsung.com> <524C1E78.6030508@ti.com> <52556370.1050102@samsung.com> <52579CB2.8050601@ti.com> <5257DEB5.6000708@samsung.com> <5257EF6A.4020005@ti.com> <5258084A.9000509@samsung.com> <52580EFF.2020401@ti.com> <525F9660.3010408@samsung.com>
In-Reply-To: <525F9660.3010408@samsung.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="jn6Bd8XGEEQ5Ob3sdNWusFGeXx82AE6xD"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--jn6Bd8XGEEQ5Ob3sdNWusFGeXx82AE6xD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17/10/13 10:48, Andrzej Hajda wrote:

> The main function of DSI is to transport pixels from one IP to another =
IP
> and this function IMO should not be modeled by display entity.
> "Power, clocks, etc" will be performed via control bus according to
> panel demands.
> If 'DSI chip' has additional functions for video processing they can
> be modeled by CDF entity if it makes sense.

Now I don't follow. What do you mean with "display entity" and with "CDF
entity"? Are they the same?

Let me try to clarify my point:

On OMAP SoC we have a DSI encoder, which takes input from the display
controller in parallel RGB format, and outputs DSI.

Then there are external encoders that take MIPI DPI as input, and output
DSI.

The only difference with the above two components is that the first one
is embedded into the SoC. I see no reason to represent them in different
ways (i.e. as you suggested, not representing the SoC's DSI at all).

Also, if you use DSI burst mode, you will have to have different video
timings in the DSI encoder's input and output. And depending on the
buffering of the DSI encoder, you could have different timings in any cas=
e.

Furthermore, both components could have extra processing. I know the
external encoders sometimes do have features like scaling.

>> We still have two different endpoint configurations for the same
>> DSI-master port. If that configuration is in the DSI-master's port nod=
e,
>> not inside an endpoint data, then that can't be supported.
> I am not sure if I understand it correctly. But it seems quite simple:
> when panel starts/resumes it request DSI (via control bus) to fulfill
> its configuration settings.
> Of course there are some settings which are not panel dependent and tho=
se
> should reside in DSI node.

Exactly. And when the two panels require different non-panel-dependent
settings, how do you represent them in the DT data?

>>> We say then: callee handles locking :)
>> Sure, but my point was that the caller handling the locking is much
>> simpler than the callee handling locking. And the latter causes
>> atomicity issues, as the other API could be invoked in between two cal=
ls
>> for the first API.
>>
>>    =20
> Could you describe such scenario?

If we have two independent APIs, ctrl and video, that affect the same
underlying hardware, the DSI bus, we could have a scenario like this:

thread 1:

ctrl->op_foo();
ctrl->op_bar();

thread 2:

video->op_baz();

Even if all those ops do locking properly internally, the fact that
op_baz() can be called in between op_foo() and op_bar() may cause problem=
s.

To avoid that issue with two APIs we'd need something like:

thread 1:

ctrl->lock();
ctrl->op_foo();
ctrl->op_bar();
ctrl->unlock();

thread 2:

video->lock();
video->op_baz();
video->unlock();

>>> Platform devices
>>> ~~~~~~~~~~~~~~~~
>>> Platform devices are devices that typically appear as autonomous
>>> entities in the system. This includes legacy port-based devices and
>>> host bridges to peripheral buses, and most controllers integrated
>>> into system-on-chip platforms.  What they usually have in common
>>> is direct addressing from a CPU bus.  Rarely, a platform_device will
>>> be connected through a segment of some other kind of bus; but its
>>> registers will still be directly addressable.
>> Yep, "typically" and "rarely" =3D). I agree, it's not clear. I think t=
here
>> are things with DBI/DSI that clearly point to a platform device, but
>> also the other way.
> Just to be sure, we are talking here about DSI-slaves, ie. for example
> about panels,
> where direct accessing from CPU bus usually is not possible.

Yes. My point is that with DBI/DSI there's not much bus there (if a
normal bus would be PCI/USB/i2c etc), it's just a point to point link
without probing or a clearly specified setup sequence.

If DSI/DBI was used only for control, a linux bus would probably make
sense. But DSI/DBI is mainly a video transport channel, with the
control-part being "secondary".

And when considering that the video and control data are sent over the
same channel (i.e. there's no separate, independent ctrl channel), and
the strict timing restrictions with video, my gut feeling is just that
all the extra complexity brought with separating the control to a
separate bus is not worth it.

 Tomi



--jn6Bd8XGEEQ5Ob3sdNWusFGeXx82AE6xD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSX51NAAoJEPo9qoy8lh71Y6oQAIe10EjnDvVhHyJhewZX8vW3
Q06vQ53O9llqu34XGuQLsxz7OLlIbFhKHcHuI3FBEXsJ04bvR4YVeDmwKbqNO089
sQKczSh18zWW01jYMSlGeZxox9i6l/YcAX1/ZbxAJ6Y88a3J+VfyPmkMbkr0CM0n
fAlmggrlLSmEXWeEPtX9aURTpqbxPtED9t4GMTaQTmA2/eKQjIZNdHcHynR6UH/a
vAjdJsnFb+BBG1uiU+VmgtD5ZHh//5PEDWS0if8SgfyejXx66o+7vYN04V7u3XU4
YyvSzfhGQl05HtK/kb+g8iIqn0lK/uG/01qkmaiVmTSS91RecixXfQXeeSZvvZ7F
G3CyuVmChIpVJirO7TPNmk6QjY/b9qZChsRrNXvlMP+7VL2WZ+7vvai090r7WJ2W
ety6GDj62zi8wTOa1Z4vXWhasB759pnm4M3Nvaunhp9Ik5wwcu4jlV7tN5oy7mqa
OFB6Aj+ULmNq/Dy4SNVb9YiTBXL7YUrOnxa6SiH9bWAcKNQtVEDefC+sX+lqNUbZ
0qnPbiRlqSK+PduUkoemm7zhBRD1m3nk774Ix4N9V3LhdPueTbMjD5RMLcKOyw+2
gYgz7r1dHMWr65BcnkHt2PriFc/R1tq93VIJKqFdM50A6Er0fdkFucXfeRQMEuCw
NAos1QZbccO3HgX4KvKF
=0Q6x
-----END PGP SIGNATURE-----

--jn6Bd8XGEEQ5Ob3sdNWusFGeXx82AE6xD--
