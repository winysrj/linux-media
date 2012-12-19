Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35685 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab2LSPIN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Dec 2012 10:08:13 -0500
Message-ID: <50D1D846.6010005@ti.com>
Date: Wed, 19 Dec 2012 17:07:50 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Jani Nikula <jani.nikula@linux.intel.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	<linux-fbdev@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	<dri-devel@lists.freedesktop.org>,
	Rob Clark <rob.clark@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <1608840.IleINgrx5J@avalon> <87pq28hb72.fsf@intel.com> <1671267.x0lxGrFjjV@avalon> <87pq26ay2z.fsf@intel.com>
In-Reply-To: <87pq26ay2z.fsf@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigAF592F4E085896D02B582D18"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigAF592F4E085896D02B582D18
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-12-19 16:57, Jani Nikula wrote:

> It just seems to me that, at least from a DRM/KMS perspective, adding
> another layer (=3DCDF) for HDMI or DP (or legacy outputs) would be
> overengineering it. They are pretty well standardized, and I don't see
> there would be a need to write multiple display drivers for them. Each
> display controller has one, and can easily handle any chip specific
> requirements right there. It's my gut feeling that an additional
> framework would just get in the way. Perhaps there could be more common=

> HDMI/DP helper style code in DRM to reduce overlap across KMS drivers,
> but that's another thing.
>=20
> So is the HDMI/DP drivers using CDF a more interesting idea from a
> non-DRM perspective? Or, put another way, is it more of an alternative
> to using DRM? Please enlighten me if there's some real benefit here tha=
t
> I fail to see!

The use of CDF is an option, not something that has to be done. A DRM
driver developer may use it if it gives benefit for him for that
particular driver.

I don't know much about desktop display hardware, but I guess that using
CDF would not really give much there. In some cases it could, if the IPs
used on the graphics card are something that are used elsewhere also
(sounds quite unlikely, though). In that case there could be separate
drivers for the IPs.

And note that CDF is not really about the dispc side, i.e. the part that
creates the video stream from pixels in the memory. It's more about the
components after that, and how to connect those components.

> For DSI panels (or DSI-to-whatever bridges) it's of course another
> story. You typically need a panel specific driver. And here I see the
> main point of the whole CDF: decoupling display controllers and the
> panel drivers, and sharing panel (and converter chip) specific drivers
> across display controllers. Making it easy to write new drivers, as
> there would be a model to follow. I'm definitely in favour of coming up=

> with some framework that would tackle that.

Right. But if you implement drivers for DSI panels with CDF for, say,
OMAP, I think it's simpler to use CDF also for HDMI/DP on OMAP.
Otherwise it'll be a mishmash with two different models.

 Tomi



--------------enigAF592F4E085896D02B582D18
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQ0dhGAAoJEPo9qoy8lh711fIP/0tG7PP7vl6yQyl1cZsWGR/e
+yijVtgqI/F0hcyDjE6QvUvW/W0Qum+Tlb6tNjmoSnr1UakIZc84SR+AUW652XTx
qlb2QPAvvjUezqthYztqYR/zBgfVFJ/z1NiWpzKLxFVoU1L5n8XojNkEqUSLtG04
rlC6pXzZxDR3ilugVLOlneCUzY0Gc7caG8baZJoxdhNInWTHRzReGKTvG34UMeSu
bqwGKVbtPSN7vH09aKTqXkmOMRJv8T2EvK58rkwq5fxojkvCmHov++K9/yyOOw54
OtrCDMLIwuPrbR0K7Z66bFjZpVc2+NBUhqx7amny0dp4XrJspKWwB8b5hN+czjIc
fvq9v5KRWTL2LbKn/bXBcM4icSayiqWXrEp/5fRZNK5XmT5OAd/bk8r4WU7xG4Eu
sLt/pqnGFS3u/pzIDibi0iLhQvBwn7F8Eh6kUmT0z9y5VvaezZW1ENHPHFLt6sje
BELJQKzQaSUqMwnOG1FQMG8Erltat4/WkAfUAy5l9JrLCbBFCDQSyaKAn2vtYCZ7
ohPhCZAh6XtJgbkQQKa2nrMt0OVDYqSH/aWts9SPIwP84GL9Ynu37ntl1szxEXj1
m3H/hrd1fuwQrdsI5MULYN3VRzhzaAIu7AebA++0fRtHsFLFDwG/T9oeGSAui8c4
NXGhyrKy8xqw2nxs6aEY
=rYAb
-----END PGP SIGNATURE-----

--------------enigAF592F4E085896D02B582D18--
