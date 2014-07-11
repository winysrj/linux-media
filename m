Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:44644 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaGKCZD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jul 2014 22:25:03 -0400
Received: by mail-yh0-f43.google.com with SMTP id a41so206088yho.30
        for <linux-media@vger.kernel.org>; Thu, 10 Jul 2014 19:25:01 -0700 (PDT)
Date: Thu, 10 Jul 2014 23:24:02 -0300
From: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
To: linux-media@vger.kernel.org
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/2] solo6x10: expose encoder quantization setting as
 V4L2 control
Message-ID: <20140710232402.6f0432c4@pirotess.bf.iodev.co.uk>
In-Reply-To: <1404833013-18627-1-git-send-email-andrey.utkin@corp.bluecherry.net>
References: <1404833013-18627-1-git-send-email-andrey.utkin@corp.bluecherry.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/z62uznoFBiAGXP3Oa1.V1kl"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/z62uznoFBiAGXP3Oa1.V1kl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  8 Jul 2014 18:23:32 +0300
Andrey Utkin <andrey.utkin@corp.bluecherry.net> wrote:
> solo6*10 boards have configurable quantization parameter which takes
> values from 0 to 31, inclusively.
>=20
> This change enables setting it with ioctl VIDIOC_S_CTRL with id
> V4L2_CID_MPEG_VIDEO_H264_MIN_QP.
>=20
> Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> ---
>  drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
> b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c index
> b8ff113..bf6eb06 100644 ---
> a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c +++
> b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c @@ -1111,6
> +1111,9 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl) case
> V4L2_CID_MPEG_VIDEO_GOP_SIZE: solo_enc->gop =3D ctrl->val;
>  		return 0;
> +	case V4L2_CID_MPEG_VIDEO_H264_MIN_QP:
> +		solo_enc->qp =3D ctrl->val;
> +		return 0;
>  	case V4L2_CID_MOTION_THRESHOLD:
>  		solo_enc->motion_thresh =3D ctrl->val;
>  		if (!solo_enc->motion_global
> || !solo_enc->motion_enabled) @@ -1260,6 +1263,8 @@ static struct
> solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
> V4L2_CID_SHARPNESS, 0, 15, 1, 0); v4l2_ctrl_new_std(hdl,
> &solo_ctrl_ops, V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 255, 1,
> solo_dev->fps);
> +	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
> +			V4L2_CID_MPEG_VIDEO_H264_MIN_QP, 0, 31, 1,
> SOLO_DEFAULT_QP); v4l2_ctrl_new_custom(hdl,
> &solo_motion_threshold_ctrl, NULL); v4l2_ctrl_new_custom(hdl,
> &solo_motion_enable_ctrl, NULL); v4l2_ctrl_new_custom(hdl,
> &solo_osd_text_ctrl, NULL);

Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>

--Sig_/z62uznoFBiAGXP3Oa1.V1kl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTv0rCAAoJEBrCLcBAAV+Gcb4H/1xgl5OTx2qHXSR0h/ZGGHrL
N+2QQVRChAZfHhKck7STKoX86pdqN/YRmOGvrSqQhJ++p2Q6r5AZPwjg4mjYNJOM
YBKru2QCoAXgOYCPKJ3gRi/EpAKoSbAQwa64hYuTlYF3b8otop3nb7cY6gOm5Y5D
6s4fGtDH0WF6lXAIN67mou+E8J2Q2VIdE88bNekYjqEMc4EcdrxpejaGnzby+0nf
Ou3aOyX1NnnL41/IIUfaB3NakGIg7BNNwtkRKACy92btBPx7GL81Zo8zcJzHmZ7D
rsByiV8SicaKbrd9MjYYyEQb1oFy7RveSekVUnRMbGap5uP4aSPRDEn+UMb1Fak=
=wUxD
-----END PGP SIGNATURE-----

--Sig_/z62uznoFBiAGXP3Oa1.V1kl--
