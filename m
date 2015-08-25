Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17092 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbbHYL1C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 07:27:02 -0400
Date: Tue, 25 Aug 2015 13:25:38 +0200
From: Thierry Reding <treding@nvidia.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Bryan Wu <pengw@nvidia.com>, <hansverk@cisco.com>,
	<linux-media@vger.kernel.org>, <ebrower@nvidia.com>,
	<jbang@nvidia.com>, <swarren@nvidia.com>, <wenjiaz@nvidia.com>,
	<davidw@nvidia.com>, <gfitzer@nvidia.com>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/2] [media] v4l: tegra: Add NVIDIA Tegra VI driver
Message-ID: <20150825112537.GG14034@ulmo.nvidia.com>
References: <1440118300-32491-1-git-send-email-pengw@nvidia.com>
 <1440118300-32491-5-git-send-email-pengw@nvidia.com>
 <20150821130339.GB22118@ulmo.nvidia.com>
 <55DBB62C.4020606@nvidia.com>
 <55DC0B91.2000204@xs4all.nl>
MIME-Version: 1.0
In-Reply-To: <55DC0B91.2000204@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="V32M1hWVjliPHW+c"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--V32M1hWVjliPHW+c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2015 at 08:30:41AM +0200, Hans Verkuil wrote:
> A quick follow-up to Thierry's excellent review:
>=20
> On 08/25/2015 02:26 AM, Bryan Wu wrote:
> > On 08/21/2015 06:03 AM, Thierry Reding wrote:
> >> On Thu, Aug 20, 2015 at 05:51:39PM -0700, Bryan Wu wrote:
>=20
> <snip>
>=20
> >>> +static void
> >>> +__tegra_channel_try_format(struct tegra_channel *chan, struct v4l2_p=
ix_format *pix,
> >>> +		      const struct tegra_video_format **fmtinfo)
> >>> +{
> >>> +	const struct tegra_video_format *info;
> >>> +	unsigned int min_width;
> >>> +	unsigned int max_width;
> >>> +	unsigned int min_bpl;
> >>> +	unsigned int max_bpl;
> >>> +	unsigned int width;
> >>> +	unsigned int align;
> >>> +	unsigned int bpl;
> >>> +
> >>> +	/* Retrieve format information and select the default format if the
> >>> +	 * requested format isn't supported.
> >>> +	 */
> >>> +	info =3D tegra_core_get_format_by_fourcc(pix->pixelformat);
> >>> +	if (!info)
> >>> +		info =3D tegra_core_get_format_by_fourcc(TEGRA_VF_DEF_FOURCC);
> >> Should this not be an error? As far as I can tell this is silently
> >> substituting the default format for the requested one if the requested
> >> one isn't supported. Isn't the whole point of this to find out if some
> >> format is supported?
> >>
> > I think it should return some error and escape following code. I will=
=20
> > fix that.
>=20
> Actually, this code is according to the V4L2 spec: if the given format is
> not supported, then VIDIOC_TRY_FMT should replace it with a valid default
> format.
>=20
> The reality is a bit more complex: in many drivers this was never reviewed
> correctly and we ended up with some drivers that return an error for this
> case and some drivers that follow the spec. Historically TV capture drive=
rs
> return an error, webcam drivers don't. Most unfortunate.
>=20
> Since this driver is much more likely to be used with sensors I would
> follow the spec here and substitute an invalid format with a default
> format.

Okay, sounds good to me.

Thierry

--V32M1hWVjliPHW+c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJV3FCuAAoJEN0jrNd/PrOhJ/0P/0Q/3GoPsZsAHK6qsf7Zf0V8
NLTS4P971367HJwxi0rr3G9rOh7za/n0T1ySpUbJABbjt1AGH3m4OaxAi9klKrvJ
T7jhUEYFFCl8EDwBLi2O4eezfBVUO6h6Ye1vwDDpU5CWlSgLk5CTp+cnjlzGt5eQ
Eh3P34n63m6TsWUgFIWSmP+5ghAmhxEtbKYUy+P5+GqQc7f96eXT0pplBJaWufTY
B5S5ozuxf6eSV1r3YEcgC2bhiunHp1MrG+Kq9SMaaz71KsqHvw9w/kmvUdJ7LoOc
LXEghWyimxjbJsABvfE9+alV2SfSnXROTqsYGkgAuDV2jr7L1p3sXGTk6ZpOLCNX
/x1fvk6OViXS7qRdzYV+nlGrLSxHVI9qcwoQWdeKaavC169j90VDwMTDms1xuIng
UiAuPbSbOBHAJouXZwdrlY/p4peIBKV8UVdHgP5OHDn+jZKxJYX7kGe8P84tTEzb
fyrRBLSJ5H8Y7LC7JOsClHVMAjLpZlQSaR+0UlQAmOgfrIjT75jRmw6QSWApY8sc
5bRsQt9PIbqr9dA7VspZXfw8OvJDOMJ97aRzbrswisUfc6cuOtwsr4DFf5hxLvc9
rC1ALGKF+Z3UORiwa7mD0Ng0VNgX8tRbBt6HWNMla6MoSoW/JiqN3QiVLhyLwsNa
FglQNyO71EI6AwiB9lJZ
=/BBB
-----END PGP SIGNATURE-----

--V32M1hWVjliPHW+c--
