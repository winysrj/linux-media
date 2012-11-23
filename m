Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:54789 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2KWT4W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 14:56:22 -0500
Date: Fri, 23 Nov 2012 20:56:07 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC v2 0/5] Common Display Framework
Message-ID: <20121123195607.GA20990@avionic-0098.adnet.avionic-design.de>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 22, 2012 at 10:45:31PM +0100, Laurent Pinchart wrote:
[...]
> Display entities are accessed by driver using notifiers. Any driver can
> register a display entity notifier with the CDF, which then calls the not=
ifier
> when a matching display entity is registered. The reason for this asynchr=
onous
> mode of operation, compared to how drivers acquire regulator or clock
> resources, is that the display entities can use resources provided by the
> display driver. For instance a panel can be a child of the DBI or DSI bus
> controlled by the display device, or use a clock provided by that device.=
 We
> can't defer the display device probe until the panel is registered and al=
so
> defer the panel device probe until the display is registered. As most dis=
play
> drivers need to handle output devices hotplug (HDMI monitors for instance=
),
> handling other display entities through a notification system seemed to b=
e the
> easiest solution.
>=20
> Note that this brings a different issue after registration, as display
> controller and display entity drivers would take a reference to each othe=
r.
> Those circular references would make driver unloading impossible. One pos=
sible
> solution to this problem would be to simulate an unplug event for the dis=
play
> entity, to force the display driver to release the dislay entities it use=
s. We
> would need a userspace API for that though. Better solutions would of cou=
rse
> be welcome.

Maybe I don't understand all of the underlying issues correctly, but a
parent/child model would seem like a better solution to me. We discussed
this back when designing the DT bindings for Tegra DRM and came to the
conclusion that the output resource of the display controller (RGB,
HDMI, DSI or TVO) was the most suitable candidate to be the parent of
the panel or display attached to it. The reason for that decision was
that it keeps the flow of data or addressing of nodes consistent. So the
chain would look something like this (on Tegra):

	CPU
	+-host1x
	  +-dc
	    +-rgb
	    | +-panel
	    +-hdmi
	      +-monitor

In a natural way this makes the output resource the master of the panel
or display. From a programming point of view this becomes quite easy to
implement and is very similar to how other busses like I2C or SPI are
modelled. In device tree these would be represented as subnodes, while
with platform data some kind of lookup could be done like for regulators
or alternatively a board setup registration mechanism like what's in
place for I2C or SPI.

Thierry

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQr9TXAAoJEN0jrNd/PrOhiLsP/1PCCWZJ1Udmo6KJN7EgQ6TK
zXV/YWYfNQAkKvhyMU9tK+1YAOYm754AyTEzd1xew22ubMBCrRYz61sWeNeS8Z/M
4GsUJvB+3Ywo7PMiYy8KX3ENiD1EJ77qUBFwX1ov8FvzvcdV9NtlRDuUpzqEMyOO
dwfBLeWb1ky1ET8FscssZW2vISKZUMwrTxGsLoQWd8lYB98IqQ0MT12urCW7yJ+K
dpipU4mubXgPiysUu6tJZ7v/Zy3UGahZmN6Nxlkr6ohmJ2oiyHXuPsJ98fp5iXB2
8c0W/4Lqrhi6V2AkDWXgO+/FYMki/3+P3WMpZUwSh0Ju6/sS09unE9ZLcr7UyYTD
4vIWuTk6EWQKjyM5CB8l5Iv+osyHN5NyI1YvkexNt3p8sH46Geqh136RxIL9V68B
2lyvmAUHiZbdJDxXKCM57OhG9tuVOztHxw214DbstglyXWfhn3Lz9zjkHVr3AHsf
n1eFdC0ng+Ohul4LUhBGtY77U7QRgsUkfAXBFwNF5Rgoid67EELfYUg4B2Mq68Yj
Hbj/I+tn703ugIDd5PpPtdZTm7sR0MGU2tOgxaEQx3cYsrWwr2GB943aFtrg6g4A
a39zwktP54azTcnu7ApIHvx0fScEqnyekh1DWXVSuSAW0Sa8KrqhyUlmAIJo3Ko/
b+wnZ13hGC+CI6CtJmYw
=MxeW
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
