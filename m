Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49990 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933919AbeFYNcp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 09:32:45 -0400
Date: Mon, 25 Jun 2018 15:32:33 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH 8/9] media: cedrus: Add start and stop decoder operations
Message-ID: <20180625133233.3b7qup3tcgydfo5t@flea>
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
 <20180613140714.1686-9-maxime.ripard@bootlin.com>
 <f37f23580c92728bbcd5bfe3fff506b5bb2bdfd0.camel@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bkh4pwgu6vcj5lmf"
Content-Disposition: inline
In-Reply-To: <f37f23580c92728bbcd5bfe3fff506b5bb2bdfd0.camel@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bkh4pwgu6vcj5lmf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 21, 2018 at 05:38:23PM +0200, Paul Kocialkowski wrote:
> Hi,
>=20
> On Wed, 2018-06-13 at 16:07 +0200, Maxime Ripard wrote:
> > Some codec needs to perform some additional task when a decoding is sta=
rted
> > and stopped, and not only at every frame.
> >=20
> > For example, the H264 decoding support needs to allocate buffers that w=
ill
> > be used in the decoding process, but do not need to change over time, o=
r at
> > each frame.
> >=20
> > In order to allow that for codecs, introduce a start and stop hook that
> > will be called if present at start_streaming and stop_streaming time.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> > ---
> >  .../platform/sunxi/cedrus/sunxi_cedrus_common.h    |  2 ++
> >  .../platform/sunxi/cedrus/sunxi_cedrus_video.c     | 14 +++++++++++++-
> >  2 files changed, 15 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h =
b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > index a2a507eb9fc9..20c78ec1f037 100644
> > --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_common.h
> > @@ -120,6 +120,8 @@ struct sunxi_cedrus_dec_ops {
> >  	enum sunxi_cedrus_irq_status (*irq_status)(struct sunxi_cedrus_ctx *c=
tx);
> >  	void (*setup)(struct sunxi_cedrus_ctx *ctx,
> >  		      struct sunxi_cedrus_run *run);
> > +	int (*start)(struct sunxi_cedrus_ctx *ctx);
> > +	void (*stop)(struct sunxi_cedrus_ctx *ctx);
> >  	void (*trigger)(struct sunxi_cedrus_ctx *ctx);
> >  };
> > =20
> > diff --git a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c b=
/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
> > index fb7b081a5bb7..d93461178857 100644
> > --- a/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
> > +++ b/drivers/media/platform/sunxi/cedrus/sunxi_cedrus_video.c
> > @@ -416,6 +416,8 @@ static int sunxi_cedrus_buf_prepare(struct vb2_buff=
er *vb)
> >  static int sunxi_cedrus_start_streaming(struct vb2_queue *q, unsigned =
int count)
> >  {
> >  	struct sunxi_cedrus_ctx *ctx =3D vb2_get_drv_priv(q);
> > +	struct sunxi_cedrus_dev *dev =3D ctx->dev;
> > +	int ret =3D 0;
> > =20
> >  	switch (ctx->vpu_src_fmt->fourcc) {
> >  	case V4L2_PIX_FMT_MPEG2_FRAME:
> > @@ -425,16 +427,26 @@ static int sunxi_cedrus_start_streaming(struct vb=
2_queue *q, unsigned int count)
> >  		return -EINVAL;
> >  	}
> > =20
> > -	return 0;
> > +	if (V4L2_TYPE_IS_OUTPUT(q->type) &&
>=20
> I suppose this check was put in place to ensure that ->start is only
> called once, but what if start_streaming is called multiple times on
> output? Am I totally unsure about whether the API guarantees that we
> only get one start_streaming call per buffer queue, regardless of how
> many userspace issues.
>=20
> If we don't have such a guarantee, we probably need an internal
> mechanism to avoid having ->start called more than once.

As far as I understand it, start_streaming can only be called once:
https://elixir.bootlin.com/linux/latest/source/include/media/videobuf2-core=
=2Eh#L357

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--bkh4pwgu6vcj5lmf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlsw7vAACgkQ0rTAlCFN
r3SG9A/+JxtDrW0vEWk/HeW3YiinlIPzaEXNtQQL668DXghQmSP1QT+7Orc6SZRZ
5Vldwdb4Aikj099JA13q72N52jqkKALfQCEhcoFuLdlfCV2RtAJwS1B9qG22sTlT
674bisEeytEa1ryIZkOCFORksnYsa/AEJqr2Zzm/v8bBLpOd+IptfM2J3FunjvPz
kl1NK/WsZB307KYS9KgFmC/TOzMACRRxqhRK7Hm189xQn6gLSPf82fK9JxLmKoEu
EkT2pJzFhFFFtEcV1L0GrQrSGfB2l/VgdPn6Anwxpnh+YEscWnO71lb8FNAjlD1K
QltM7XhhqFEnjJXOGQz/svWeYQbo8iy8boKKHFTj6j2Xff+GrVeSstERakfgtdID
fegw93I7g/qeeQd5MuZvX02ya2Jlft2LzHn3a18c26UxoT3lUZhX+CGae05Xx3An
Jt9N88HJcx87Zl+mVX+3pA5oll6fpALb9p8w0WJ0NHEVXheb8iMuyBGuTmbydvRo
GjsNjgtBiQETXe6+4xEV3TbTXH8VvaCrFpJi5W3O8TN1X5Fbp/vlxSuFm/Q8mdix
mdaiey+A8nKBLcJDg+SqBiwoRdXWY0t9r4agZPj9A0jU2uFRDRsNCKNyVIpMqjef
SFcb2mtIcYNZPwZvtX7E+08jiVDV/D1vDy82HeRburJPpPmNcSY=
=e2dl
-----END PGP SIGNATURE-----

--bkh4pwgu6vcj5lmf--
