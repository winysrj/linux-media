Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:61896 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaGKCZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jul 2014 22:25:40 -0400
Received: by mail-yh0-f45.google.com with SMTP id t59so205505yho.4
        for <linux-media@vger.kernel.org>; Thu, 10 Jul 2014 19:25:39 -0700 (PDT)
Date: Thu, 10 Jul 2014 23:24:56 -0300
From: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
To: linux-media@vger.kernel.org
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 2/2] solo6x10: update GOP size, QP immediately
Message-ID: <20140710232456.68fbb82b@pirotess.bf.iodev.co.uk>
In-Reply-To: <1404833013-18627-2-git-send-email-andrey.utkin@corp.bluecherry.net>
References: <1404833013-18627-1-git-send-email-andrey.utkin@corp.bluecherry.net>
	<1404833013-18627-2-git-send-email-andrey.utkin@corp.bluecherry.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Nu2YdZD4VVeULicCTmFM/O5"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/Nu2YdZD4VVeULicCTmFM/O5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  8 Jul 2014 18:23:33 +0300
Andrey Utkin <andrey.utkin@corp.bluecherry.net> wrote:
> Previously, it was needed to reopen device to update GOP size and
> quantization parameter. Now we update device registers with new values
> immediately.
>=20
> Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> ---
>  drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
> b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c index
> bf6eb06..14f933f 100644 ---
> a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c +++
> b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c @@ -1110,9
> +1110,13 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl) ctrl->val);
>  	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
>  		solo_enc->gop =3D ctrl->val;
> +		solo_reg_write(solo_dev,
> SOLO_VE_CH_GOP(solo_enc->ch), solo_enc->gop);
> +		solo_reg_write(solo_dev,
> SOLO_VE_CH_GOP_E(solo_enc->ch), solo_enc->gop); return 0;
>  	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:
>  		solo_enc->qp =3D ctrl->val;
> +		solo_reg_write(solo_dev,
> SOLO_VE_CH_QP(solo_enc->ch), solo_enc->qp);
> +		solo_reg_write(solo_dev,
> SOLO_VE_CH_QP_E(solo_enc->ch), solo_enc->qp); return 0;
>  	case V4L2_CID_MOTION_THRESHOLD:
>  		solo_enc->motion_thresh =3D ctrl->val;

Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>

--Sig_/Nu2YdZD4VVeULicCTmFM/O5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTv0r4AAoJEBrCLcBAAV+GM54H/3N4I2yYBX+/g4/gLiC+CiRt
fQFFCPFzQ4KBgCHatoKzXfVnM6GFw5LUiB/aTjWJctoIZNTdlc+4LbTef1TQvst0
lALxZtFnDYBg5tExobbq4k5bR26E7RH41Zp1rYEY7pA9LftE8s4uuEsO4q832hUw
lA8B3dVOVV/5Rzh/sTBsblnbxDxw16+ClmbvJpYkI4MLbfFW2CajJ73JMeFnz1mW
z2GhZ00WTPvRsV0dN8zj0X37p0qQtEs6/PQOrq+kB+1NpRjt0JIjRMOKOitD+FUW
umsf/yZLnRkOlMGrcnqytLx4Z4cj+VFvct17Bef0DlD7MRQlAzThmE0Mp+iqEXo=
=nRiO
-----END PGP SIGNATURE-----

--Sig_/Nu2YdZD4VVeULicCTmFM/O5--
