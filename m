Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41940 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964773Ab3BHKvi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Feb 2013 05:51:38 -0500
Message-ID: <5114D8A2.6010806@ti.com>
Date: Fri, 8 Feb 2013 12:51:14 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Figa <t.figa@samsung.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <Ragesh.R@linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Rob Clark <rob.clark@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	sunil joshi <joshi@samsung.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <1987992.4TmVjQaiLj@amdc1227> <50EC5283.80006@stericsson.com> <3057999.UZLp2j2DkQ@avalon> <510F8807.2020406@stericsson.com>
In-Reply-To: <510F8807.2020406@stericsson.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig308484A2EEB6AD9AAACDD463"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enig308484A2EEB6AD9AAACDD463
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-02-04 12:05, Marcus Lorentzon wrote:

> As discussed at FOSDEM I will give DSI bus with full feature set a
> try.

Please do, but as a reminder I want to raise the issues I see with a DSI
bus:

- A device can be a child of only one bus. So if DSI is used only for
video, the device is a child of, say, i2c bus, and thus there's no DSI
bus. How to configure and use DSI in this case?

- If DSI is used for both control and video, we have two separate APIs
for the bus. What I mean here is that for the video-only case above, we
need a video-only-API for DSI. This API should contain all necessary
methods to configure DSI. But we need similar methods for the control
API also.

So, I hope you come up with some solution for this, but as I see it,
it's easily the most simple and clear option to have one video_source
style entity for the DSI bus itself, which is used for both control and
video.

 Tomi



--------------enig308484A2EEB6AD9AAACDD463
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRFNiiAAoJEPo9qoy8lh71BaQP/3CSjn7rhwfgye1Vb2vLQ/n6
ec5YmiNyMSvvW/8TyDAC7uYpSErDjwyZ6P0ZaCi2CgAIYWa6glsXpgZPRNOogRls
6BQNCTovsQ7Dj98KKJTsYz+p20imlAnBjMU+PW4xOsW2WPIPxMJr+32k9OeOvBmr
gjNJ01t6xhlfRNRly+Yfdf/y62sDswhPdFKU30h6lx0zkGpEBKdD+8vnBlz6dxbE
aIKi+qzsgaxy0mP1wDHrzK12j7VLrhuLLfFW/NJx1xOWArHNoPM4+lvLsRtOOX7X
rkbsvIO/vY0IcCPzWnrRI1NbNPpFPmKnZ/hy+1oUhWIfuKzw2AyEZ0laXzMo/iB2
prKTGGDbstup891bj6QJZiq16XSmNLeAbNs9og8BbFtuXkyto6EJcjkkOtvjJrv1
ErF+/AUrNeQKzl2pM+ciiQMpAQ/KDOFBNLJo1CjEZ0TP+PpBnEyAvQ0++c0YYZMX
xAZx0uLeMOLPGXU6Ea4wDODCCLQI7TSrS2DAhSqjX7N/29qwtPcbRb3pAvxmXDr3
5GXTmfXSjbLvpSWVLXBd/nXgXYrD4Jp4sHB+rY1kmouS+nQZ5kO9GZf06sU91H4X
1NRCPobxTba/x8bnKlr/QFdc0CDYGZbZK9CQ/TrYxXN3ZiLMugOrS3UUSVTTByo0
OM5tqbyJZuCYbRBV7a+6
=9+uQ
-----END PGP SIGNATURE-----

--------------enig308484A2EEB6AD9AAACDD463--
