Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:41451 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab2K3MDE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Nov 2012 07:03:04 -0500
Message-ID: <50B8A05E.9040503@ti.com>
Date: Fri, 30 Nov 2012 14:02:38 +0200
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
Subject: Re: [RFC v2 3/5] video: display: Add MIPI DBI bus support
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <1353620736-6517-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1353620736-6517-4-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigE41CD55EB45F00E03ED094B8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigE41CD55EB45F00E03ED094B8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 2012-11-22 23:45, Laurent Pinchart wrote:
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/video/display/Kconfig        |    4 +
>  drivers/video/display/Makefile       |    1 +
>  drivers/video/display/mipi-dbi-bus.c |  228 ++++++++++++++++++++++++++=
++++++++
>  include/video/display.h              |    5 +
>  include/video/mipi-dbi-bus.h         |  125 +++++++++++++++++++
>  5 files changed, 363 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/video/display/mipi-dbi-bus.c
>  create mode 100644 include/video/mipi-dbi-bus.h

I've been doing some omapdss testing with CDF and DSI, and I have some
thoughts about the bus stuff. I already told these to Laurent, but I'll
write them to the mailing list also for discussion.

So with the current CDF model we have separate control and video buses.
The control bus is represented as proper Linux bus, and video bus is
represented via custom display_entity. This sounds good on paper, and I
also agreed to this approach when we were planning CDF.

However, now I doubt that approach.

First, I want to list some examples of devices with different bus
configurations:

1) Panel without any control, only video bus
2) Panel with separate control and video buses, e.g. i2c for control,
DPI for video
3) Panel with the same control and video buses, like DSI or DBI.

The first one is simple, it's just a platform device. No questions there.=


The second one can be a bit tricky. Say, if we have a panel controlled
via i2c, and DSI/DBI used for video. The problem here is that with the
current model, DSI/DBI would be represented as a real bus, for control.
But in this case there's only the video path.

So if all the DSI/DBI bus configuration is handled on the DSI/DBI
control bus side, how can it be handled with only the video bus? And if
we add the same bus configuration to the video bus side as we have on
control bus side, then we have duplicated the API, and it's also
somewhat confusing. I don't have any good suggestion for this.

Third one is kinda clear, but I feel slightly uneasy about it. In theory
we can have separate control and video buses, which use the same HW
transport. However, I feel that we'll have some trouble with the
implementation, as we'll then have two more or less independent users
for the HW transport. I can't really point out why this would not be
possible to implement, but I have a gut feeling that it will be
difficult, at least for DSI.

So I think my question is: what does it give us to have separate control
and video buses, and what does the Linux bus give us with the control bus=
?

I don't see us ever having a case where a device would use one of the
display buses only for control. So either the display bus is only used
for video, or it's used for both control and video. And the display bus
is always 1-to-1, so we're talking about really simple bus here.

I believe things would be much simpler if we just have one entity for
the display buses, which support both video and (when available)
control. What would be the downsides of this approach versus the current
CDF proposal?

 Tomi



--------------enigE41CD55EB45F00E03ED094B8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQuKBeAAoJEPo9qoy8lh71s3YP/jOdlh7Gpgg57HqgSy0aJJ60
jWoj+Elf7n8Keq8fR8dUfJeyKUcOec4WUKqsT+SIn3L/7wt4e5y7J650Y6U+TNhQ
uCKMdfTnOMcpMC8s27FyXqPb3/whaf5MtykaPSG3VMqtUXxN5wS/vZcXAMnCpGmH
StUTFJaujyVcZUmK7PPJ6I5FOdIV1BxKRgLJ5/MblcjuVRU8aOKfuZ8Iab/7tgVr
S/sY/eyBpl/zr8apiQEOG87/5Swq+anillppPX05lNRRKc0OUVtFW48iM7mefWvm
c34cCXsyel44wzMph42UepxtN6MUAT57EZzCWfQOiZuvgmG6mbKt67xaAKfkgiVU
WJcKLqBPlT18icZP04HzQVAU1HZvM4+xIJMJWUTKe5aLsCY/uLbgdsjpct0oC0dJ
mhIci2E5kSxJIuVIno326vwtelGydHR6vlUjlOKPNp28920RG/AvV+DX6y3W+pZT
nJ1sPpGehfAn4F6YNmxNImKJHarDt7zYFX6KuDaXkCrr7gkpZjWwIhkP2CFlbOym
1Qj3rTleAnqjCzB2uIRYj3IimvrxDFmdG198or4DxtVlVetN1Vh9gYcMRtHcTtY0
JuhkJ0kUkilHHys8OeduyDAryLJeqX5o5lkYtAiZbfFDmT2UUEZgT1X0hrYA6NwM
0HVolpnRxNtOh7BG2hRC
=n1B2
-----END PGP SIGNATURE-----

--------------enigE41CD55EB45F00E03ED094B8--
