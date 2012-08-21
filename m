Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:45255 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663Ab2HUFuI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 01:50:08 -0400
Received: by lagr15 with SMTP id r15so3181881lag.7
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2012 22:50:04 -0700 (PDT)
Message-ID: <1345528197.15491.8.camel@lappyti>
Subject: Re: [RFC 0/5] Generic panel framework
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Date: Tue, 21 Aug 2012 08:49:57 +0300
In-Reply-To: <3937256.gcqPRVoNWN@avalon>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <4948190.AFNtaaFKXQ@avalon> <1345462770.2684.23.camel@deskari>
	 <3937256.gcqPRVoNWN@avalon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-7Ghrz/zwBKSEXzPlMIaP"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-7Ghrz/zwBKSEXzPlMIaP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-08-21 at 01:29 +0200, Laurent Pinchart wrote:
> Hi Tomi,
>=20
> On Monday 20 August 2012 14:39:30 Tomi Valkeinen wrote:
> > On Sat, 2012-08-18 at 03:16 +0200, Laurent Pinchart wrote:
> > > Hi Tomi,
> > >=20
> > > mipi-dbi-bus might not belong to include/video/panel/ though, as it c=
an be
> > > used for non-panel devices (at least in theory). The future mipi-dsi-=
bus
> > > certainly will.
> >=20
> > They are both display busses. So while they could be used for anything,
> > I find it quite unlikely as there are much better alternatives for
> > generic bus needs.
>=20
> My point is that they could be used for display devices other than panels=
.=20
> This is especially true for DSI, as there are DSI to HDMI converters.=20
> Technically speaking that's also true for DBI, as DBI chips convert from =
DBI=20
> to DPI, but we can group both the DBI-to-DPI chip and the panel in a sing=
le=20
> panel object.

Ah, ok. I thought "panels" would include these buffer/converter chips.

I think we should have one driver for one indivisible hardware entity.
So if you've got a panel module that contains DBI receiver, buffer
memory and a DPI panel, let's just have one "DBI panel" driver for it.

If we get lots of different panel modules containing the same DBI RX IP,
we could have the DBI IP part as a common library, but still have one
panel driver per panel module.

But how do you see the case for separate converter/buffer chips? Are
they part of the generic panel framework? I guess they kinda have to be.
On one side they use the "panel" API control the bus they are connected
to, and on the other they offer an API for the connected panel to use
the bus they provide.

Did you just mean we should have a separate directory for them, while
still part of the same framework, or...?

 Tomi


--=-7Ghrz/zwBKSEXzPlMIaP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQMyGFAAoJEPo9qoy8lh71pwEQAK0yqtosKZNKoX1XylVzkcR9
d390PM3GE/A6sxGag56lRtRkfYKWtVKKPo44N7zVKRSWPe6p+OP8WmD+v9nR7plY
vrWSXLkdiRtg/8zeiM1kz8Bywnx72QREbzBeCyV5Pyd95DFqcC8/bcvJb6MlPZAe
sQM/in1ne45rxJkygv9eyRArk1lIqPZXLMktLeblSadD9uHKjzG9bhq+zE0AXQiN
+ZLbEhQ5bjDskPaZUYP0nVm73VS1Fj2hG6TtegAiFhrFN3PntWmcdmWfVPAa5yqU
P4vPTRIQc7dz1tukrCTYitF2SOvUFOv5ZIOHGGTtjGqKlXB/t5L912TXd6rULX76
7nmgACSyRZ+QUnETpV51RsoH6v3OXEpG5tZeIt/30Kn6sobKW5Ce8f72eGkanduW
gp9t2Zxa2ZMxAIR0A+fWE0p80vTR4JAZdpi+J33W9tFJ8mK8Sdfb3HF0uCfQl7u+
bKEsqtQ6j+vFIkijeHrKVpoBMuSGWeMLsrwSlpl8BSvC9FAQ4cB/jV/mYBHpn/pC
7t4p2kPsdpKoUwI7QzP6Xyi6Ldaw3u56oD6xC3QmQsSEY6J4aLgUqTMFpyVIXnK/
ACwIBI+HrQtaQ3GGSa5ecFn94aU/Gmhtn2LXq1AzJJ3BPQkQMdDn9uphWCw0qDy+
PMccsuqsidmAhwotpZ6n
=tg4e
-----END PGP SIGNATURE-----

--=-7Ghrz/zwBKSEXzPlMIaP--

