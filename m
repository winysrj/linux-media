Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:43651 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941Ab2JHJBX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Oct 2012 05:01:23 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so2767223lbo.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 02:01:20 -0700 (PDT)
Message-ID: <1349686878.3227.40.camel@deskari>
Subject: Re: [PATCH 1/2 v6] of: add helper to parse display timings
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Date: Mon, 08 Oct 2012 12:01:18 +0300
In-Reply-To: <Pine.LNX.4.64.1210081000530.11034@axis700.grange>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
	 <1349373560-11128-2-git-send-email-s.trumtrar@pengutronix.de>
	 <Pine.LNX.4.64.1210042307300.3744@axis700.grange>
	 <506F0833.1090704@wwwdotorg.org>
	 <Pine.LNX.4.64.1210081000530.11034@axis700.grange>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-UJ1ZVwdXI0O4oyoyQOoC"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-UJ1ZVwdXI0O4oyoyQOoC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-10-08 at 10:25 +0200, Guennadi Liakhovetski wrote:

> In general, I might be misunderstanding something, but don't we have to=
=20
> distinguish between 2 types of information about display timings: (1) is=
=20
> defined by the display controller requirements, is known to the display=
=20
> driver and doesn't need to be present in timings DT. We did have some of=
=20
> these parameters in board data previously, because we didn't have proper=
=20
> display controller drivers... (2) is board specific configuration, and is=
=20
> such it has to be present in DT.
>=20
> In that way, doesn't "interlaced" belong to type (1) and thus doesn't nee=
d=20
> to be present in DT?

As I see it, this DT data is about the display (most commonly LCD
panel), i.e. what video mode(s) the panel supports. If things were done
my way, the panel's supported timings would be defined in the driver for
the panel, and DT would be left to describe board specific data, but
this approach has its benefits.

Thus, if you connect an interlaced panel to your board, you need to tell
the display controller that this panel requires interlace signal. Also,
pixel clock source doesn't make sense in this context, as this doesn't
describe the actual used configuration, but only what the panel
supports.

Of course, if this is about describing the hardware, the default-mode
property doesn't really fit in...

 Tomi


--=-UJ1ZVwdXI0O4oyoyQOoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQcpZeAAoJEPo9qoy8lh71jiIP/RpaYW8fyffAFqfy8QlVtOyF
eUDBwng9QkEjAyOd6+JzVlXB3Ex/40nQCubII7g73e9+tKaPx+C0uR+ugbf5QObc
pq2D08O9fWgxJAdmdN+2cW859hX6m5Fm9N74lXXSIZqqcbyUjxIwAuUn3rsiwQV2
gKB9LZr8s0s7H6u+f9aUZtro9Es/lpZNjVYR1x0pRfFUCLIdypfuCpIv3244WkH2
HcOvbDVThAHHtNI+vI/6vPRo3KDA/vYFRZ/4056dx+v/uPkGdAH2RRW4iQ+3nBA3
alqjadOzKOHrqb65JyDU2GCPIGJh5b05HTRAh5T7xuT2C0wJ8CU7ZULrzL/thyFK
DOgDFJAig8Uyj5vQ4bA6Hz0U+QiaRnm0EWUph+O9XbaHsoM15sG1Gk01F99R+1RM
BK/X0dNs1fWXiRxSIfJtFd9gzI9YrTK9tqF2l29E6sDBCt7C8EbImo74Lk/OSrfy
BhuZTwnm/LiHYE5A5c0PbJr1zQIsRRe49CZ9boqCOnLvgwDvfL4hYoug9H2qmlH9
FbpxRADQAWmYcWfE6A/mHbzQqKlFDdrsylPMCwotzHiRApUBdqloNPBPSi+n1zPe
p+JQeCcjXx53TulC5uM0+gXWwHQf6psImU+8X7JOXD7XCYOEk6OhW3vyWmtcinOj
5Fw728bqQlFNIWs0l59s
=ZIY1
-----END PGP SIGNATURE-----

--=-UJ1ZVwdXI0O4oyoyQOoC--

