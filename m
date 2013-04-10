Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46078 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760488Ab3DJN43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 09:56:29 -0400
Date: Wed, 10 Apr 2013 14:56:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"renwei.wu" <renwei.wu@csr.com>,
	DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
	xiaomeng.hou@csr.com, zilong.wu@csr.com
Subject: Re: [PATCH 07/14] media: soc-camera: support deferred probing of
 clients
Message-ID: <20130410135627.GD9243@opensource.wolfsonmicro.com>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <1348754853-28619-8-git-send-email-g.liakhovetski@gmx.de>
 <CAGsJ_4yUY6PE0NWZ9yaOLFmRb3O-HL55=w7Y6muwL0YbkJtP0Q@mail.gmail.com>
 <Pine.LNX.4.64.1304101358490.13557@axis700.grange>
 <CAGsJ_4xn_R7D7Uh0dJB7WuDQG3K_mZkMwYNtMDuHMhX+4oTk=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dnvf+KcI+0MByPWJ"
Content-Disposition: inline
In-Reply-To: <CAGsJ_4xn_R7D7Uh0dJB7WuDQG3K_mZkMwYNtMDuHMhX+4oTk=Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Dnvf+KcI+0MByPWJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 10, 2013 at 09:53:20PM +0800, Barry Song wrote:
> 2013/4/10 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:

> >> what about another possible way:
> >> we let all host and i2c client driver probed in any order,

> > This cannot work, because some I2C devices, e.g. sensors, need a clock
> > signal from the camera interface to probe. Before the bridge driver has
> > completed its probing and registered a suitable clock source with the
> > v4l2-clk framework, sensors cannot be probed. And no, we don't want to
> > fake successful probing without actually being able to talk to the
> > hardware.

> i'd say same dependency also exists on ASoC.  a "fake" successful
> probing doesn't mean it should really begin to work if there is no
> external trigger source.  ASoC has successfully done that by a machine
> driver to connect all DAI.
> a way is we put all things ready in their places, finally we connect
> them together and launch the whole hardware flow.

In the ASoC case the idea is that drivers should probe as far as they
can with just the chip and then register with the core.  The machine
driver defers probing until all components have probed and then runs
through second stage initialisaton which pulls everything together.

--Dnvf+KcI+0MByPWJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZW+AAAoJELSic+t+oim9RisP/0JnIg+nLUD6ybwBMA2Mc1d+
GvVQVmasJue54gyGd9X+XcRXdBrtSw8UUiSI5rUFoOHIyc6ZLYz+qprpSCjIEAUz
BRiPG2zwpEsHvdI9ys3mCtwU/9Go4pnxhGUHLtb7xHbsORxdaTyN0yiiOEwbwaAe
9mfzBn3iZGru5vjSf7vIft/YX5rcmsMaRq9typ1b10Q1dEHJQFk3V4GVN1KbpULG
4xEOaipv3HorsJhcEuc7r+LIXp7Zp9Yg2W5RVTTu7CDnGWmyu4ELSCDa8mWsqAdu
80N2zDzQQHu+QZwxrGp2GPHRbBeL4Pekp3GHUXqUokWnHSHe1pTaqEvp4BpBMRUn
UQqDJkFNNu8n3bL9UjQ7feVgo1obX4e9B1BG4Z+PWFbIViK/Q9mMU5EatSesx7Ju
qqCIIGKG0Q8YxildXDf9y70CirkXIDyvOt42O0uxZTeQMMx5AdP0y/gvz+nPfdVw
kReb2sXLVKvysXmvsG5B8L0FnWKB1sDDMCDCrkZowzIDkuhFZ9ZphdeUr9j/IKf7
MjnfIGrsGos7+D/yVXBJJJ/t2JZ1IzGzNdoGhG/XYLS1hjmhj5KiBFd2k3Mr77/u
Qa+pG7guhaCYlh+8/CcCCpabjW6wPQfjtzZ1bMjAx77grcm+jGlSJJHMdIdOd7nD
N+AOg+yeJVJQwvabeOMk
=XoTj
-----END PGP SIGNATURE-----

--Dnvf+KcI+0MByPWJ--
